# Builds a Lite copy of the eXoDOS Media Pack.
# Each Lite zip keeps the LaunchBox images, the platform list and the small files, but not the
# books, catalogs, magazines, soundtracks and videos themselves. The platform list is changed so
# each item opens through eXo\util\media_nas.bat, which copies the item from the full Media Pack
# on the network share the first time it is opened.
#   -Source  the full Media Pack folder (the one that holds Content), or its Content folder
#   -Dest    where to write the Lite pack. The zips go in Dest\Content.
#   -Report  only show what would be kept and left on the share
param(
    [Parameter(Mandatory = $true)][string]$Source,
    [string]$Dest,
    [switch]$Report
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$launcher = Join-Path $here 'media_nas.bat'
$Source = $Source.Trim('"').TrimEnd('\')
$src = if (Test-Path -LiteralPath (Join-Path $Source 'Content')) { Join-Path $Source 'Content' } else { $Source }
if (-not $Report) {
    if (-not $Dest) { throw 'Give -Dest, or -Report to only list what would be done.' }
    $Dest = $Dest.Trim('"').TrimEnd('\')
    if (-not (Test-Path -LiteralPath $launcher)) { throw "media_nas.bat was not found next to this script ($launcher)." }
}
$packs = 'DOSBooks', 'DOSCatalogs', 'DOSMagazines', 'DOSSoundtracks', 'DOSVideos'
$found = @($packs | Where-Object { Test-Path -LiteralPath (Join-Path $src "$_.zip") })
if ($found.Count -eq 0) { throw "No Media Pack zips were found in $src" }
$stored = '.jpg', '.jpeg', '.png', '.gif', '.zip', '.mp4', '.pdf', '.iso', '.cdr', '.bin'
$runnable = '.bat', '.exe', '.com'
$media = '.pdf', '.mp4', '.zip', '.iso', '.cdr', '.bin', '.mkv', '.avi'
$utf8 = New-Object Text.UTF8Encoding($false)
function GB($n) { '{0:N2} GB' -f ($n / 1GB) }

if (-not $Report) {
    [void][IO.Directory]::CreateDirectory((Join-Path $Dest 'Content'))
    $launcherBytes = [IO.File]::ReadAllBytes($launcher)
}

$totalKept = 0; $totalLeft = 0
foreach ($pack in $found) {
    $zipPath = Join-Path $src "$pack.zip"
    Write-Host "$pack.zip"
    $zip = [IO.Compression.ZipFile]::OpenRead($zipPath)
    try {
        # Index the zip
        $files = @{}; $dirs = @{}
        foreach ($e in $zip.Entries) {
            if (-not $e.Name) { continue }
            $files[$e.FullName.ToLowerInvariant()] = $e
            $p = $e.FullName
            while (($i = $p.LastIndexOf('/')) -gt 0) {
                $p = $p.Substring(0, $i); $k = $p.ToLowerInvariant() + '/'
                if ($dirs.ContainsKey($k)) { break }
                $dirs[$k] = $p
            }
        }
        $xmlEntry = @($zip.Entries | Where-Object { $_.FullName -like 'Data/Platforms/*.xml' })
        if ($xmlEntry.Count -ne 1) { throw "$pack.zip does not have exactly one platform list." }
        $xmlEntry = $xmlEntry[0]
        $r = New-Object IO.StreamReader($xmlEntry.Open(), $utf8); $xmlText = $r.ReadToEnd(); $r.Close()
        $doc = New-Object Xml.XmlDocument; $doc.PreserveWhitespace = $true; $doc.LoadXml($xmlText)

        # First pass: find each item's file, and which items use each folder
        $items = New-Object Collections.Generic.List[object]; $folderIds = @{}
        foreach ($node in $doc.SelectNodes('/LaunchBox/Game | /LaunchBox/AdditionalApplication')) {
            $appNode = $node.SelectSingleNode('ApplicationPath'); $cmdNode = $node.SelectSingleNode('CommandLine')
            if (-not $appNode -or -not $appNode.InnerText) { continue }
            $app = $appNode.InnerText; $cmd = if ($cmdNode) { $cmdNode.InnerText } else { '' }
            if ($app -ieq 'eXo\util\media_nas.bat') { throw "$pack.zip is already a Lite zip." }
            $idNode = $node.SelectSingleNode('ID'); if ($node.LocalName -eq 'AdditionalApplication') { $idNode = $node.SelectSingleNode('GameID') }
            $id = if ($idNode) { $idNode.InnerText } else { [guid]::NewGuid().ToString() }
            $target = $app
            if ($app -like '*\foobar2000.exe' -and $cmd -match '^"?\.\.\\\.\.\\\.\.\\(Soundtracks\\[^"]+)"?$') { $target = 'eXo\' + $Matches[1] }
            $rel = $target -replace '\\', '/'
            $items.Add([pscustomobject]@{ Node = $node; AppNode = $appNode; CmdNode = $cmdNode; App = $app; Cmd = $cmd; Rel = $rel; Target = $target })
            $p = $rel
            while (($i = $p.LastIndexOf('/')) -gt 0) {
                $p = $p.Substring(0, $i); $k = $p.ToLowerInvariant() + '/'
                if (-not $folderIds.ContainsKey($k)) { $folderIds[$k] = @{} }
                $folderIds[$k][$id] = 1
            }
        }
        # Folders that hold launchers are shared by many issues, so they always stay local
        $hasRunnable = @{}
        foreach ($e in $files.Values) {
            if ($runnable -notcontains [IO.Path]::GetExtension($e.Name).ToLowerInvariant()) { continue }
            $p = $e.FullName
            while (($i = $p.LastIndexOf('/')) -gt 0) { $p = $p.Substring(0, $i); $hasRunnable[$p.ToLowerInvariant() + '/'] = 1 }
        }

        $fileUnits = @{}; $dirUnits = New-Object Collections.Generic.List[string]
        $moved = 0; $local = 0; $unresolved = New-Object Collections.Generic.List[string]
        foreach ($it in $items) {
            $node = $it.Node; $appNode = $it.AppNode; $cmdNode = $it.CmdNode; $app = $it.App; $cmd = $it.Cmd; $rel = $it.Rel
            $key = $rel.ToLowerInvariant()
            if (-not $files.ContainsKey($key)) {
                $top = ($rel -split '/')[0..1] -join '/'
                if ($dirs.ContainsKey($top.ToLowerInvariant() + '/')) { $unresolved.Add($it.Target) }
                continue
            }
            $ext = [IO.Path]::GetExtension($rel).ToLowerInvariant()
            $unit = $null; $check = $null
            if ($runnable -notcontains $ext) {
                $parent = $rel.Substring(0, $rel.LastIndexOf('/')); $pk = $parent.ToLowerInvariant() + '/'
                if ($parent.Split('/').Count -gt 2 -and $folderIds[$pk].Count -eq 1 -and -not $hasRunnable.ContainsKey($pk)) {
                    # The folder belongs to this item only, so it is copied as a whole
                    $unit = $dirs[$pk]; $check = $files[$key].FullName; $dirUnits.Add($unit + '/')
                } else {
                    $unit = $files[$key].FullName; $check = $unit; $fileUnits[$unit.ToLowerInvariant()] = 1
                }
            } else {
                $parent = $rel.Substring(0, $rel.LastIndexOf('/'))
                if ($parent.Split('/').Count -gt 2) {
                    # The item has its own folder
                    $unit = $dirs[$parent.ToLowerInvariant() + '/']; $check = $files[$key].FullName
                } else {
                    # A series launcher: the issue folder is <series folder>\<command line>
                    $r = New-Object IO.StreamReader($files[$key].Open()); $bat = $r.ReadToEnd(); $r.Close()
                    $series = $null
                    foreach ($line in $bat -split "`r?`n") { if ($line -match '^\s*cd\s+"?([^".][^"]*)"?\s*$') { $series = $Matches[1].Trim(); break } }
                    $issue = $cmd.Trim().Trim('"')
                    if ($series -and $issue) {
                        $k = ($parent + '/' + $series + '/' + $issue).ToLowerInvariant() + '/'
                        if ($dirs.ContainsKey($k)) {
                            $unit = $dirs[$k]
                            $check = @($files.Values | Where-Object { $_.FullName.StartsWith($unit + '/', [StringComparison]::OrdinalIgnoreCase) } | Sort-Object FullName | Select-Object -First 1)[0].FullName
                        }
                    }
                }
                if ($unit) { $dirUnits.Add($unit + '/') }
            }
            if (-not $unit) { $local++; continue }
            $moved++
            $line = '"{0}.zip" "{1}" "{2}" "{3}"' -f $pack, ($unit -replace '/', '\'), ($check -replace '/', '\'), $app
            if ($cmd) { $line += ' ' + $cmd }
            $appNode.InnerText = 'eXo\util\media_nas.bat'
            if (-not $cmdNode) { $cmdNode = $doc.CreateElement('CommandLine'); [void]$node.InsertAfter($cmdNode, $appNode) }
            $cmdNode.InnerText = $line
        }

        # Decide which files stay in the Lite zip
        $kept = New-Object Collections.Generic.List[object]; $keptBytes = 0; $leftBytes = 0; $unusedBytes = 0; $unused = 0
        foreach ($e in $files.Values) {
            if ($e -eq $xmlEntry) { continue }
            $left = $fileUnits.ContainsKey($e.FullName.ToLowerInvariant())
            if (-not $left) { foreach ($d in $dirUnits) { if ($e.FullName.StartsWith($d, [StringComparison]::OrdinalIgnoreCase)) { $left = $true; break } } }
            if (-not $left -and $e.FullName -like 'eXo/*' -and $media -contains [IO.Path]::GetExtension($e.Name).ToLowerInvariant()) {
                # Media that no LaunchBox item opens, outside the folders the launchers use
                $pk = $e.FullName.Substring(0, $e.FullName.LastIndexOf('/')).ToLowerInvariant() + '/'
                if (-not $hasRunnable.ContainsKey($pk)) { $unused++; $unusedBytes += $e.Length; $leftBytes += $e.Length; continue }
            }
            if ($left) { $leftBytes += $e.Length } else { $kept.Add($e); $keptBytes += $e.Length }
        }
        $totalKept += $keptBytes; $totalLeft += $leftBytes
        Write-Host ("  {0} items open from the share, {1} stay fully local" -f $moved, $local)
        Write-Host ("  Kept locally: {0} files, {1}. Left on the share: {2}" -f $kept.Count, (GB $keptBytes), (GB $leftBytes))
        if ($unused) { Write-Host ("  Of those left, {0} files ({1}) are not used by any LaunchBox item" -f $unused, (GB $unusedBytes)) }
        foreach ($u in $unresolved) { Write-Host "  Not found in the zip, left unchanged: $u" }
        if ($Report) {
            $big = $kept | Where-Object { $_.FullName -like 'eXo/*' } | Group-Object { ($_.FullName -split '/')[0..2] -join '/' } |
                ForEach-Object { [pscustomobject]@{ N = $_.Name; B = ($_.Group | Measure-Object Length -Sum).Sum } } | Sort-Object B -Descending | Select-Object -First 3
            foreach ($b in $big) { if ($b.B -gt 50MB) { Write-Host ("  Largest local folder: {0} ({1})" -f $b.N, (GB $b.B)) } }
            continue
        }

        # Write the Lite zip
        $out = Join-Path $Dest "Content\$pack.zip"; $tmp = "$out.tmp"
        $fs = [IO.File]::Open($tmp, [IO.FileMode]::Create)
        $lite = New-Object IO.Compression.ZipArchive($fs, [IO.Compression.ZipArchiveMode]::Create)
        try {
            foreach ($e in ($kept | Sort-Object FullName)) {
                $level = if ($stored -contains [IO.Path]::GetExtension($e.Name).ToLowerInvariant()) { 'NoCompression' } else { 'Optimal' }
                $n = $lite.CreateEntry($e.FullName, [IO.Compression.CompressionLevel]$level); $n.LastWriteTime = $e.LastWriteTime
                $i = $e.Open(); $o = $n.Open(); $i.CopyTo($o); $o.Close(); $i.Close()
            }
            $n = $lite.CreateEntry($xmlEntry.FullName); $n.LastWriteTime = [DateTimeOffset]::Now
            $o = $n.Open(); $w = New-Object IO.StreamWriter($o, $utf8); $w.Write($doc.OuterXml); $w.Close()
            $n = $lite.CreateEntry('eXo/util/media_nas.bat'); $n.LastWriteTime = [DateTimeOffset]::Now
            $o = $n.Open(); $o.Write($launcherBytes, 0, $launcherBytes.Length); $o.Close()
        } finally { $lite.Dispose(); $fs.Dispose() }
        Move-Item -LiteralPath $tmp -Destination $out -Force
        Write-Host ("  Written: {0} ({1})" -f $out, (GB (Get-Item -LiteralPath $out).Length))
    } finally { $zip.Dispose() }
}

if (-not $Report) {
    # Everything else in Content (the Linux zips, MediaPack.ver) is copied as it is
    foreach ($f in Get-ChildItem -LiteralPath $src -File) {
        if ($packs -contains $f.BaseName -and $f.Extension -ieq '.zip') { continue }
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Dest "Content\$($f.Name)") -Force
    }
    $readme = @(
        'eXoDOS Media Pack Lite',
        '',
        'Put the files from this Content folder in the Content folder of your eXoDOS install and run',
        'Setup eXoDOS.bat again, the same as the full Media Pack.',
        '',
        'The books, catalogs, magazines, soundtracks and videos are not included. The first time you',
        'open one, it is copied from the full Media Pack on your network share. You are asked for the',
        'share folder the first time; it is saved in eXo\util\nas_media.conf.',
        '',
        "Made from: $Source"
    )
    [IO.File]::WriteAllLines((Join-Path $Dest 'Media Pack Lite ReadMe.txt'), $readme)
}
Write-Host ''
Write-Host ("Total kept locally: {0}. Left on the share: {1}" -f (GB $totalKept), (GB $totalLeft))
