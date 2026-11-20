@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Merges every supported eXo project into one new folder, as Regular or Lite copies,
rem then runs Setup once for all of them.
rem   merge_eXo.bat           do the merge
rem   merge_eXo.bat /dryrun   only list what would be copied, nothing is changed
cd /d "%~dp0"
for %%R in ("%~dp0..") do set "repo=%%~fR"
set rcopt=
set dryrun=false
if /i "%~1"=="/dryrun" (
	set rcopt=/L
	set dryrun=true
)
rem Merge order. Later projects win when two have the same file, and the last one runs Setup.
set "projects=Win3x DOS DREAMM ScummVM DemoScene IF Win9x"
set tries=0

cls
echo eXo Project Merge
if %dryrun%==true echo DRY RUN: nothing will be copied or changed.
echo.
echo Copies the supported eXo projects into one new folder and runs Setup once for all of them.
echo.
echo   Regular - full copies of eXoWin3x, eXoDOS, eXoDREAMM, eXoScummVM, eXoDemoScene, eXoIF and eXoWin9x
echo   Lite    - eXoDOS, eXoDREAMM, eXoScummVM and eXoWin9x without their games. Each game is
echo             copied from the network share the first time you install it.
echo.
echo eXoAppleIIGS is not supported until it moves to the eXo v6 framework.
echo.
choice /C RL /M "Merge the [R]egular or [L]ite versions"
if errorlevel 2 (set mode=Lite) else (set mode=Regular)

:askbase
set /a tries+=1
if %tries% GTR 5 goto quit
set base=
echo.
echo Enter the folder that holds the eXo project folders, for example:
echo   \\192.168.1.10\Media\Games\eXo
set /P "base=Projects folder: "
if not defined base goto askbase
set "base=%base:"=%"
if not defined base goto askbase
if "%base:~-1%"=="\" set "base=%base:~0,-1%"
if not defined base goto askbase
if not exist "%base%\" (
	echo "%base%" was not found.
	goto askbase
)

rem Find the projects
set last=
set nonlite=
for %%P in (%projects%) do call :find %%P
if not defined last (
	echo No supported eXo projects were found in "%base%".
	set tries=0
	goto askbase
)
if defined nonlite (
	echo.
	echo These projects have no Lite version:%nonlite%
	choice /C YN /M "Include full copies of them"
	if errorlevel 2 (
		set nonlite=
	) else (
		for %%P in (%nonlite%) do call :addfull %%P
	)
)
set last=
for %%P in (%projects%) do call :findlast %%P
if not defined last goto quit
set media=false
if not defined type_DOS goto askdest
if not exist "%base%\eXoDOS Media Pack\eXoDOS\Content\" goto askdest
echo.
echo The eXoDOS Media Pack (books, magazines, catalogs, soundtracks and videos) was found.
echo It is about 240 GB.
choice /C YN /M "Include the eXoDOS Media Pack"
if errorlevel 2 (set media=false) else (set media=true)

:askdest
set tries=0
:askdest2
set /a tries+=1
if %tries% GTR 5 goto quit
set dest=
echo.
echo Enter the folder to create the merged install in, for example D:\eXo
set /P "dest=Destination folder: "
if not defined dest goto askdest2
set "dest=%dest:"=%"
if not defined dest goto askdest2
if "%dest:~-1%"=="\" set "dest=%dest:~0,-1%"
if not defined dest goto askdest2
for %%D in ("%dest%") do set "dest=%%~fD"
if /i "%dest%"=="%base%" (
	echo The destination must not be the projects folder.
	goto askdest2
)
set bad=
for %%P in (%projects%) do call :inside %%P
if defined bad (
	echo The destination must not be inside a project folder.
	goto askdest2
)
if not exist "%dest%\" goto summary
dir /B /A "%dest%" 2>nul | findstr "^" >nul
if errorlevel 1 goto summary
echo.
echo "%dest%" is not empty. Files that are already there and newer are kept.
choice /C YN /M "Use it anyway"
if errorlevel 2 goto askdest

:summary
cls
echo Mode:         %mode%
echo Projects:     %base%
echo Destination:  %dest%
echo.
for %%P in (%projects%) do call :show %%P
if %media%==true echo   eXoDOS Media Pack
echo.
echo Setup eXo%last%.bat will run after the copy.
echo.
choice /C YN /M "Start the merge"
if errorlevel 2 goto quit

if %dryrun%==false if not exist "%dest%\" md "%dest%"
if %dryrun%==false if not exist "%dest%\" (
	echo "%dest%" could not be created.
	goto failed
)
set failed=
for %%P in (%projects%) do call :copy %%P
if defined failed goto failed
if %media%==true (
	echo.
	echo ===== eXoDOS Media Pack =====
	call :rc "%base%\eXoDOS Media Pack\eXoDOS" "%dest%"
)
if defined failed goto failed
if %mode%==Lite for %%P in (%projects%) do call :overlay %%P
if defined failed goto failed

if %dryrun%==true (
	echo.
	echo Dry run finished. Nothing was copied or changed.
	goto end
)

echo.
echo ===== Running Setup eXo%last%.bat =====
if defined lite_%last% (
	echo When Setup asks whether the games are on a network share, answer Yes and enter:
	echo   %base%\eXo%last%
	echo This script sets up the share for the other Lite projects afterwards.
)
echo.
pause
pushd "%dest%"
cmd /c call "Setup eXo%last%.bat"
popd

rem Setup unpacks the stock scripts of every project, so put the NAS versions back
if %mode%==Lite (
	echo.
	echo Restoring the NAS scripts and share settings...
	for %%P in (%projects%) do call :overlay %%P
	for %%P in (%projects%) do call :conf %%P
)
if defined failed goto failed
echo.
echo The merged install is ready: %dest%
echo Run LaunchBox.exe there to play.
goto end

:failed
echo.
echo The merge did not finish. Check the messages above, fix the problem and run this script again.
echo Files that were already copied are kept and skipped next time.
goto end

:quit
echo.
echo Nothing was changed.
goto end

rem ---------------------------------------------------------------------------

:find
rem %1 = project. Sets src_P, type_P (full, litecopy or litemake) and lite_P.
set "src_%1="
set "type_%1="
set "lite_%1="
if %mode%==Regular goto findfull
set lite=false
for %%L in (DOS DREAMM ScummVM Win9x) do if /i "%1"=="%%L" set lite=true
if %lite%==false goto findnonlite
if not exist "%base%\eXo%1\Setup eXo%1.bat" exit /B
if not exist "%base%\eXo%1\eXo\eXo%1\" (
	echo eXo%1 was skipped: its games folder "%base%\eXo%1\eXo\eXo%1" was not found.
	exit /B
)
if not exist "%repo%\eXo%1\Setup eXo%1.bat" (
	echo eXo%1 was skipped: the NAS scripts were not found in "%repo%\eXo%1".
	exit /B
)
set "lite_%1=1"
set "last=%1"
set "type_%1=litemake"
set "src_%1=%base%\eXo%1"
if not "%1"=="DOS" exit /B
rem Use the official eXoDOS Lite when it is there
if exist "%base%\eXoDOS_Lite\Setup eXoDOS.bat" (
	set "type_DOS=litecopy"
	set "src_DOS=%base%\eXoDOS_Lite"
)
if exist "%base%\eXoDOS_Lite\eXoDOS\Setup eXoDOS.bat" (
	set "type_DOS=litecopy"
	set "src_DOS=%base%\eXoDOS_Lite\eXoDOS"
)
exit /B

:findnonlite
if exist "%base%\eXo%1\Setup eXo%1.bat" set "nonlite=%nonlite% eXo%1"
exit /B

:findfull
if not exist "%base%\eXo%1\Setup eXo%1.bat" exit /B
set "type_%1=full"
set "src_%1=%base%\eXo%1"
set "last=%1"
exit /B

:addfull
rem %1 = eXoName
set "p=%1"
set "p=%p:~3%"
set "type_%p%=full"
set "src_%p%=%base%\eXo%p%"
exit /B

:findlast
if defined type_%1 set "last=%1"
exit /B

:inside
call set "chk=%%src_%1%%"
if not defined chk exit /B
set "d2=%dest%\"
call set "rest=%%d2:%chk%\=%%"
if /i not "%rest%"=="%d2%" set bad=1
exit /B

:show
call set "type=%%type_%1%%"
call set "src=%%src_%1%%"
if not defined type exit /B
if "%type%"=="full" echo   eXo%1 - full copy from %src%
if "%type%"=="litecopy" echo   eXo%1 - official Lite copy from %src%, games from %base%\eXo%1
if "%type%"=="litemake" echo   eXo%1 - Lite copy made from %src% without its games
exit /B

:copy
if defined failed exit /B
call set "type=%%type_%1%%"
call set "src=%%src_%1%%"
if not defined type exit /B
echo.
echo ===== eXo%1 =====
if "%type%"=="litemake" goto copylite
call :rc "%src%" "%dest%"
exit /B
:copylite
if "%1"=="DOS" (
	call :rc "%src%" "%dest%" /XD "%src%\eXo\eXo%1" "%src%\Content\GameData\eXo%1"
) else (
	call :rc "%src%" "%dest%" /XD "%src%\eXo\eXo%1"
)
rem Keep the games folder and its year folders, without the zips
call :rcnozip "%src%\eXo\eXo%1" "%dest%\eXo\eXo%1"
if "%1"=="DOS" if exist "%src%\Content\GameData\eXo%1\" call :rcnozip "%src%\Content\GameData\eXo%1" "%dest%\Content\GameData\eXo%1"
exit /B

:overlay
if defined failed exit /B
if not defined lite_%1 exit /B
echo Adding the NAS scripts for eXo%1...
robocopy "%repo%\eXo%1" "%dest%" /E /XF nas.patch patch_files_info.txt /R:3 /W:5 /NP /NDL /NJH /NJS %rcopt%
if errorlevel 8 set failed=1
exit /B

:conf
if not defined lite_%1 exit /B
if "%1"=="DOS" (set "conf=nas.conf") else (set "conf=nas_eXo%1.conf")
if not exist "%dest%\eXo\util\" md "%dest%\eXo\util"
>"%dest%\eXo\util\%conf%" echo %base%\eXo%1
echo   eXo%1 games: %base%\eXo%1
exit /B

:rc
rem %1 = from, %2 = to, the rest are extra robocopy options
robocopy "%~1" "%~2" /E /DCOPY:T /XO /XF desktop.ini thumbs.db /R:3 /W:5 /NDL /NJH %rcopt% %3 %4 %5 %6 %7 %8
if errorlevel 8 set failed=1
exit /B

:rcnozip
robocopy "%~1" "%~2" /E /DCOPY:T /XO /XF desktop.ini thumbs.db *.zip /R:3 /W:5 /NDL /NJH /NJS %rcopt%
if errorlevel 8 set failed=1
exit /B

:end
echo.
pause
endlocal
