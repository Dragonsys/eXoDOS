:main
set cnt=0
set multi=false
set content=false
if exist .\Content\*Magazines.zip set content=true
if exist .\Content\*Books.zip set content=true
if exist .\Content\*Catalogs.zip set content=true
if exist .\Content\*Soundtracks.zip set content=true
@for %%f in (.\content\^!*.zip) do set name2=%%f
@for %%A in (.\content\^!*.zip) do set /a cnt+=1
cls
@set name=%name2:~11,-12%
if %cnt% gtr 1 set multi=true
@set var=%cd%
@set merge=false
@set exist=false
@set current=%CD:~0,2%
@for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='%current%'" get FreeSpace /format:value`) do set FreeSpace=%%x
cls
@echo off
if not exist launchbox.exe goto a1
set exist=true
cd exo\util
if not exist util.zip unzip.exe -o -q *.zip CHOICE.EXE
unzip.exe -o -q util.zip CHOICE.EXE
cd ..
cd ..

if %content%==false goto keeptruckin
if %content%==true (
	cls
	echo.
	echo An eXo Project is already set up in this folder and the Media Add-On Pack
	echo has been detected. Do you want to install a full pack, or just add the
	echo Media Add-On Pack?
	echo.
	.\exo\util\choice /C:FM /N [F]ull Install or just the [M]edia Add-On Pack?
	
	if errorlevel = 2 goto mediainstall
	if errorlevel = 1 goto keeptruckin

)

:mediainstall
cls
echo.
echo Extracting Media Add-On Pack
echo Estimated Time: 10-15 minutes.
echo.

if exist .\content\*magazines.zip .\eXo\util\unzip -o .\Content\*magazines.zip -d .\
if exist .\content\*books.zip .\eXo\util\unzip -o .\Content\*books.zip -d .\
if exist .\content\*catalogs.zip .\eXo\util\unzip -o .\Content\*catalogs.zip -d .\
if exist .\content\*soundtracks.zip .\eXo\util\unzip -o .\Content\*soundtracks.zip -d .\

cd exo\util
if exist ..\..\content\*magazines.zip eXoLBpm.exe -i - -"MS-DOS Magazines &amp; Newsletters" -Literature
if exist ..\..\content\*books.zip eXoLBpm.exe -i - -"MS-DOS Books" -Literature
if exist ..\..\content\*catalogs.zip eXoLBpm.exe -i - -"MS-DOS Catalogs" -Literature
if exist ..\..\content\*soundtracks.zip eXoLBpm.exe -i - -"Soundtracks" -Audio
cd ..\..
if exist .\data\*_tmp.xml del .\data\*_tmp.xml

cls
echo.
echo All Media has been extracted successfully. Enjoy!
echo.
pause
goto end

:keeptruckin
cls
echo.
echo An eXo project or previous LaunchBox install has previously been setup in this folder. 
echo.
if %multi% == true echo More than one eXo pack has been detected in this folder. If you continue
if %multi% == true echo they will all be installed together and merged.
if %multi% == true echo.
if %multi% == true echo Press C to Continue (This will Re-extract, Update or Install all eXo packs in this folder)
if %multi% == false echo Press C to Continue (This will Re-extract or Update the existing eXo packs)
echo Press E to Exit
echo.
if %multi% == false echo If you wish to merge multiple eXo packs together, please ensure all of the packs have been copied
if %multi% == false echo to this folder before you run setup. If you wish to do this, please exit now and restart the Setup
if %multi% == false echo process once all files are in their proper place.
if %multi% == false echo.
.\exo\util\choice /C:CE /N [C]ontinue or [E]xit

if errorlevel = 2 goto end
if errorlevel = 1 goto a1

:a1
cd exo\util
if not exist util.zip unzip.exe -o -q *.zip CHOICE.EXE
if not exist CHOICE.EXE unzip.exe -o -q util.zip CHOICE.EXE
cd ..
cd ..
cls

echo.
if %multi% == false echo                                     -=[WELCOME to eXo%name%]=- 
if %multi% == true echo                                     -=[WELCOME to eXoMerge]=- 
echo.

if %multi% == true echo This setup will install all eXo projects whose files are in this folder. The following packs have been
if %multi% == true echo detected:
if %multi% == true setlocal EnableDelayedExpansion
if %multi% == true for %%f in (".\content\^!*.zip") do (
	set pack2=%%f
	set pack=!pack2:~10,-12!
	echo eXo!pack!
)
if %multi% == true echo.
if %multi% == true echo If you do not see a pack listed that you wish to merge, please ensure it has been copied to this folder.

if %multi% == false echo This setup will install eXo%name%.
if %multi% == false echo.
if %multi% == false echo However, if you wish to merge\combine, you will want to ensure you have copied all of the projects you wish
if %multi% == false echo to merge into the folder you ran this setup file from.
if %multi% == false echo.
if %multi% == false echo For example, if you have downloaded both eXo%name% and another eXo pack, they can be combined into a single
if %multi% == false echo instance so that you may browse games from both packs in the same LaunchBox setup. To do this, simply copy
if %multi% == false echo all of the files (retaining their original folder structure) to the same folder. Then run this setup file.
if %multi% == false echo The packs will be detected merged during the installation process.
echo.
.\exo\util\choice /C:CEM /N [C]ontinue, [E]xit, or [M]erge Instructions

If errorlevel = 3 goto mergei
If errorlevel = 2 goto end
If errorlevel = 1 goto checks

:mergei
cls
echo.
echo To merge eXo packs together, you will need to copy the files of all packs you wish to merge into the same folder.
echo Specifically, you need to copy the following files and subfolders:
echo "    .\Content\        <-FOLDER    "
echo "    .\eXo\            <-FOLDER    "
echo "    Setup.bat file    <-FILE      "
echo.
echo It is best to copy these files *before* running setup. 
echo.
pause
goto a1

:checks
setlocal DisableDelayedExpansion
if not exist .\eXo\util\util*.zip (
	cls
	echo.
	echo ERROR
	echo.
	echo You are missing the util file. This file contains the emulators, along with several
	echo utilities required to run the games included with this pack.
	echo.
	echo The file resides in the .\eXo\util\ folder
	echo Please make sure this file has been downloaded before proceeding with setup.
	echo.
	echo Exiting setup
	pause
	goto end
)

if %content%==false (
	cls
	echo.
	echo Content Add-On Pack Missing
	echo.
	echo A media content pack is available. This includes magazines, books,
	echo catalogs, and soundtracks. If you wish to add these features, please download
	echo the content pack and ensure the files are in your .\Content\ folder.
	echo.
	echo At that point, run the setup file again and it will detect and add these
	echo features to your install.
	echo.
	pause
	goto GameData
)

if %content%==true (
	cls
	echo.
	if not exist .\Content\DOSBooks.zip echo Books Content Add-On Pack:		Missing
	if exist .\Content\DOSBooks.zip echo Books Content Add-On Pack:			Present
	if not exist .\Content\DOSCatalogs.zip echo Catalogs Content Add-On Pack:	Missing
	if exist .\Content\DOSCatalogs.zip echo Catalogs Content Add-On Pack:		Present
	if not exist .\Content\DOSMagazines.zip echo Magazines Content Add-On Pack:	Missing
	if exist .\Content\DOSMagazines.zip echo Magazines Content Add-On Pack:		Present
	if not exist .\Content\DOSSoundtracks.zip echo Soundtracks Content Add-On Pack:	Missing
	if exist .\Content\DOSSoundtracks.zip echo Soundtracks Content Add-On Pack:	Present
	echo.
	echo A media content pack is available. This includes magazines, books,
	echo catalogs, and soundtracks. If you wish to add these features, please download
	echo the content pack and ensure the files are in your .\Content\ folder.
	echo.
	if not exist .\Content\DOSSoundtracks.zip (
		pause
		goto GameData
	)
	if not exist .\Content\DOSCatalogs.zip (
		pause
		goto GameData
	)
	if not exist .\Content\DOSBooks.zip (
		pause
		goto GameData
	)
	if not exist .\Content\DOSMagazines.zip (
		pause
		goto GameData
	)
)

:GameData
if not exist .\Content\GameData goto gerror
goto metadata

:gerror
cls
echo.
echo ERROR
echo.
echo You are missing the GameData subfolder.
echo This folder contains all of the manuals, music, and extras for each game.
echo.
echo This subfolder should be in your .\Content\ folder.
echo.
pause
goto end

:metadata
if not exist .\Content\^!*metadata.zip goto merror
goto lbcheck

:merror
cls
echo.
echo ERROR
echo.
echo You are missing the !metadata file (!^<name^>metadata.zip).
echo Without this, the entire pack is unplayable.
echo This file contains the actual launch files and configuration files need to play the games.
echo Please download this file and then re-run setup.
echo.
echo This file should be in your .\Content\ folder.
echo.
echo Exiting setup
pause
goto end

:lbcheck
if not exist .\Content\LaunchBox.zip (
	cls
	echo.
	echo ERROR
	echo.
	echo You are missing the LaunchBox.zip file.
	echo Without this, you will have no front end.
	echo.
	echo This file should be in your .\Content\ folder.
	echo.
	echo If you plan to use a different front end or no front end at all, you can choose
	echo to continue.
	echo.
	goto check
)

if %multi% == true if not exist .\Content\XO*Metadata.zip goto m2error
if %multi% == false if not exist .\Content\XO%name%Metadata.zip goto m2error
goto verified

:m2error
cls
echo.
echo ERROR
echo You are missing the XOMetadata file (XO^<name^>Metadata.zip).
echo Without this LaunchBox will not run properly.
echo This file contains the manuals, xml, and image data LaunchBox needs.
echo.
echo This file should be in your .\Content\ folder.
echo.
echo If you plan to use a different front end or no front end at all, you can choose
echo to continue.
echo.
goto check
)

:check
echo.
echo Do you want to continue setup without support for LaunchBox?
echo.
echo Note: Launchbox is the front end. Without it, you will simply have a collection
if %multi% == false echo of %name% zip files and a !%name% folder full of config files and game launch files.
if %multi% == true echo of zip files and a folder full of config files and game launch files.
echo Do not use this method if you aren't 100%% sure of what you are doing.
echo. 
.\exo\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto skip

:verified
cls
set x64=false
rem wmic os get osarchitecture > oscheck.txt
rem systeminfo | findstr /I type: > oscheck.txt
cmd /c "echo %PROCESSOR_ARCHITECTURE%" > oscheck.txt
for /F %%a in ('findstr /C:AMD64 oscheck.txt') do set x64=true
del oscheck.txt
if %x64%==false echo.
if %x64%==false echo This machine is not reporting itself as 64 bit. LaunchBox, the front end,
if %x64%==false echo will only run on a 64 bit machine. 
if %x64%==false echo.
if %x64%==false pause
if %x64%==false goto skip_lb

cls
echo.
echo All files verified.
echo.
echo Beginning setup
echo.
if %content%==false echo Step 1 of 3
if %content%==true echo Step 1 of 4
echo Extracting LaunchBox files
echo Estimated Time: Less than 5 minutes.
echo. 
PAUSE
echo EXTRACTING...

.\eXo\util\unzip -o -q .\Content\LaunchBox.zip -d .\
goto continue

:skip_lb
echo.
echo Installation will now continue, but please be aware that the front-end will not
echo be functional on this machine. You may still run the games manually by navigating
echo to the games launch folder and running the launch file manually. These can be found
echo in:
if %multi% == false echo .\eXo\eXo%name%\!%name%\
if %multi% == true echo .\eXo\eXoPACK\!PACK\
if %multi% == true echo    *each PACK will have it's own name 
echo.
echo Apart from launching the games, the front end also contains metadata, screenshots,
echo manuals, box scans, game music, strategy guides, code wheels, and lots of other
echo interesting things for each game. It is highly recommended that you take the necessary
echo steps to get the frontend working.
echo.
pause
goto continue

:continue
cls
echo.
if %content%==false echo Step 2 of 3
if %content%==true echo Step 2 of 4
echo Extracting LaunchBox Metadata
echo Estimated Time: 25-30 minutes.
echo.
pause

.\eXo\util\unzip -o .\Content\XO*Metadata.zip -d .\
.\eXo\util\unzip -o .\Content\XODOSMetadata Plugins\eXoPlugin.dll -d .\

cls
echo.
if %content%==false goto step3
if %content%==true echo Step 3 of 4
echo Extracting Media Add-On Pack
echo Estimated Time: Depends on if you have the entire pack or not
echo                 The full thing will take about an hour.
echo.
pause

if exist .\content\*magazines.zip .\eXo\util\unzip -o .\Content\*magazines.zip -d .\
if exist .\content\*books.zip .\eXo\util\unzip -o .\Content\*books.zip -d .\
if exist .\content\*catalogs.zip .\eXo\util\unzip -o .\Content\*catalogs.zip -d .\
if exist .\content\*soundtracks.zip .\eXo\util\unzip -o .\Content\*soundtracks.zip -d .\

:step3
cls
echo.
if %content%==false echo Step 3 of 3
if %content%==true echo Step 4 of 4
echo Extracting Game Configuration Files
echo Estimated Time: 30-40 minutes.
echo. 
pause

for /F %%a in ('dir .\Content\GameData\ /A:D /B') DO (
	.\eXo\util\unzip -o .\Content\GameData\%%a\*.zip -d .\
)
.\eXo\util\unzip -o .\Content\!*metadata.zip -d .\

IF %EXIST% == false goto :skip
:cleanup
cd exo
cd util
copy unzip.exe ..
for /f %%F in ('dir /b /a-d ^| findstr /vile ".zip .bat"') do del "%%F"
for /f %%H in ('dir /A:D /B') do rmdir %%H /s /q
copy ..\unzip.exe .\
del ..\unzip.exe
cd ..
cd ..

:skip
rem if exist .\eXo\eXo%name%\!%name% rd .\eXo\eXo%name%\!%name% /s /q
rem .\eXo\util\unzip -o .\Content\!%name%metadata.zip
rem if %merge%==true .\eXo\util\unzip -o .\Content\!%pack%Metadata.zip -d .\
cd eXo
.\util\unzip -o .\util\util*.zip -d .\util
if exist .\util\OPT*.zip .\util\unzip -o .\util\OPT*.zip -d .\util\
if exist .\util\EXT*.zip .\util\unzip -o .\util\EXT*.zip
if exist .\util\deprotect.zip del .\util\deprotect.zip
del .\util\OPT*.zip
del .\util\EXT*.zip
.\util\unzip -o .\util\util.zip ssr.exe -d .\util\
.\util\unzip -o .\util\util.zip SetConsole.exe -d .\util\
if not exist .\util\scummvm.ini goto skipsvm
if not exist %USERPROFILE%\AppData\Roaming\ScummVM\scummvm.ini (
	md %USERPROFILE%\AppData\Roaming\ScummVM
	copy .\util\scummvm.ini %USERPROFILE%\AppData\Roaming\ScummVM\scummvm.ini
)
:skipsvm
cd ..
goto xml

:skipxtract
goto xml

:xml
cls
echo.
echo Would you like to remove access to Adult games from LaunchBox?
echo.
echo Please read carefully: "Adult" refers to games with nudity rather than violence. Choosing YES
echo will remove them from the front end, but not remove them from your hard drive.
echo.
echo If they have previously been removed, choosing NO here will restore them in the front end.
echo. 
.\eXo\util\choice /C:NY /N [Y]es or [N]o

If errorlevel = 2 goto YESA
If errorlevel = 1 goto NOA

:NOA
if exist .\xml\ALL\*.xml copy .\xml\ALL\*.xml .\Data\Platforms\
copy .\xml\Playlists\*.* .\Data\Playlists\
cd xml
call merge_parents
call merge_platforms
cd ..
copy .\xml\Platforms.xml .\Data\
copy .\xml\Parents.xml .\Data\
if exist .\xml\MS-DOS.xml del .\xml\MS-DOS.xml
cd .\exo\util
call fix_names
goto screen

:YESA
if exist .\xml\family\*.xml copy .\xml\family\*.xml .\Data\Platforms\
copy .\xml\Playlists\*.* .\Data\Playlists\
cd xml
call merge_parents
call merge_platforms
cd ..
copy .\xml\Platforms.xml .\Data\
copy .\xml\Parents.xml .\Data\
if exist .\xml\MS-DOS.xml del .\xml\MS-DOS.xml
cd .\exo\util
call fix_names
goto screen

:screen
cls
echo.
echo Would you like [F]ullscreen or [W]indowed mode to be the default setting?
echo. 
.\eXo\util\choice /C:FW

If errorlevel = 2 goto WIN
If errorlevel = 1 goto FULL

:FULL
cd eXo
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 fullscreen=false fullscreen=true .\emulators\dosbox\options.conf
if exist ".\util\WIN.SEL" del ".\util\WIN.SEL"
echo > ".\util\FULL.SEL"
cd ..
goto res

:WIN
cd eXo
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 fullscreen=true fullscreen=false .\emulators\dosbox\options.conf
if exist ".\util\FULL.SEL" del ".\util\FULL.SEL"
echo > ".\util\WIN.SEL"
cd ..
goto res

:RES
cd eXo
if exist .\util\SML.SEL del .\util\SML.SEL
if exist .\util\MED.SEL del .\util\MED.SEL
if exist .\util\LRG.SEL del .\util\LRG.SEL
cls
echo.
echo What is your primary desktop resolution?
echo [L]arge (4k)
echo [M]edium (1080)
echo [S]mall (less than 1080)
echo. 
echo Note: This will be used to calculate the window size in windowed mode.
echo.
.\util\choice /C:LMS

if errorlevel = 3 goto small 
if errorlevel = 2 goto medium
if errorlevel = 1 goto large

:large
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=640x480 windowresolution=2560x1920 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=2560x1920 .\emulators\dosbox\options.conf
echo > ".\util\LRG.SEL"
goto ratio

:medium
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=640x480 windowresolution=1280x960 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=1280x960 .\emulators\dosbox\options.conf
echo > ".\util\MED.SEL"
goto ratio

:small
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=640x480 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=640x480 .\emulators\dosbox\options.conf
echo > ".\util\SML.SEL"
goto ratio

:ratio
cls
echo.
echo Would you like to enable Aspect Correction for all games?
echo.
echo Choosing Yes will attempt to preserve the game's original format. In fullscreen
echo mode this will introduce black bars on the sides.
echo.
echo Choosing No will stretch the image to fit your monitor.
echo.
echo Choosing Yes is useful for widescreen monitors which cause stretching or distortion.
echo.
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto aspectN
If errorlevel = 1 goto aspectY

:aspectY
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 aspect=false aspect=true .\emulators\dosbox\options.conf
if exist ".\util\ANO.SEL" del ".\util\ANO.SEL"
echo > ".\util\AYES.SEL"
goto nas

:aspectN
cls
if exist .\emulators\dosbox\options.conf .\util\ssr 0 aspect=true aspect=false .\emulators\dosbox\options.conf
if exist ".\util\AYES.SEL" del ".\util\AYES.SEL"
echo > ".\util\ANO.SEL"
goto nas

:nas
cls
echo.
echo Would you like to enable downloading from a network share instead of torrent?
echo.
echo Choosing Yes will attempt to set a network share location for the full eXoDOS
echo location, to use for downloading games form instead of using the torrent, when
echo eXoDOS Lite is installed and the game has not yet been downloaded.
echo.
echo Choosing No will leave the default of using torrent downloads.
echo.
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto nasN
If errorlevel = 1 goto nasY

:nasY
cls
set /P naspath=Enter Full Network Share Path: 
echo %naspath% > ".\util\nas.conf"
goto ini

:nasN
cls
if exist ".\util\nas.conf" del ".\util\nas.conf"
goto ini

:ini
cd ..
rem echo %cd%\launchbox.exe > eXo.bat
rem .\exo\util\B2E /bat eXo.bat /exe eXo.exe /icon .\exo\util\exodos.ico
rem del exo.bat

cd exo\util
if exist ..\..\content\*magazines.zip eXoLBpm.exe -i - -"MS-DOS Magazines &amp; Newsletters" -Literature
if exist ..\..\content\*books.zip eXoLBpm.exe -i - -"MS-DOS Books" -Literature
if exist ..\..\content\*catalogs.zip eXoLBpm.exe -i - -"MS-DOS Catalogs" -Literature
if exist ..\..\content\*soundtracks.zip eXoLBpm.exe -i - -"Soundtracks" -Audio
cls
cd ..\..

.\eXo\util\ffplay.exe -v 0 -nodisp -autoexit .\eXo\util\blow.mp3
cls
echo.
if %multi% == false echo eXo%name% is now setup. Enjoy!
if %multi% == true echo Your eXoPacks are now setup. Enjoy!
rem echo Run "eXo.exe" to start.
rem echo.
echo.
echo Would you like to create an icon on your desktop?
echo.
.\exo\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto shortcut

:shortcut
echo [InternetShortcut] > "%userprofile%\Desktop\eXoDOS.url"
echo URL=%CD%\LaunchBox.exe >> "%userprofile%\Desktop\exoDOS.url"
echo IconFile=%CD%\eXo\util\exodos.ico >> "%userprofile%\Desktop\eXoDOS.url"
echo IconIndex=0 >> "%userprofile%\Desktop\eXoDOS.url"

:end
