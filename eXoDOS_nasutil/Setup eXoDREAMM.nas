:main
set gamecnt=0
@for %%A in (.\eXo\eXoDREAMM\*.zip) do set /a gamecnt+=1
set exolite=false
if %gamecnt% LEQ 30 set exolite=true
rem Setup re-extracts the stock scripts, so keep the NAS versions
findstr /C:"nasconf" .\eXo\util\install_drm.bat >nul 2>nul
if not errorlevel 1 (
	if not exist .\eXo\NAS\ md .\eXo\NAS
	for %%F in (install_drm.bat launch_drm.bat launch_drm_verify.bat) do copy /Y .\eXo\util\%%F .\eXo\NAS\%%F >nul
)
set cnt=0
set multi=false
set content=false
if exist .\Content\*Magazines.zip set content=true
if exist .\Content\*Books.zip set content=true
if exist .\Content\*Catalogs.zip set content=true
if exist .\Content\*Soundtracks.zip set content=true
if exist .\Content\*Videos.zip set content=true
@for %%f in (.\Content\^!*.zip) do set name2=%%f
@for %%A in (.\Content\^!*.zip) do set /a cnt+=1
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

if not exist LaunchBox.exe goto a1
set exist=true

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

cd eXo\util
if not exist choice.exe unzip.exe -o -q util*.zip choice.EXE
if not exist choice.exe goto MAJORERROR
if not exist theme.bat unzip.exe -o -q util*.zip theme.bat
call theme
cd ..\..\

if %content%==false goto keeptruckin
if %content%==true (
cls
echo.
echo An eXo Project is already set up in this folder and the Media Add-On Pack
echo has been detected. Do you want to install a full pack, or just add the
echo Media Add-On Pack?
echo.
.\eXo\util\choice /C:FM /N [F]ull Install or just the [M]edia Add-On Pack?

if errorlevel = 2 goto mediainstall
if errorlevel = 1 goto keeptruckin

)

:mediainstall
cls
echo.
echo Extracting Media Add-On Pack
echo Estimated Time: 10-15 minutes.
echo.

if exist .\Content\*Magazines.zip .\eXo\util\unzip -o .\Content\*Magazines.zip -d .\
if exist .\Content\*Books.zip .\eXo\util\unzip -o .\Content\*Books.zip -d .\
if exist .\Content\*Catalogs.zip .\eXo\util\unzip -o .\Content\*Catalogs.zip -d .\
if exist .\Content\*Soundtracks.zip .\eXo\util\unzip -o .\Content\*Soundtracks.zip -d .\
if exist .\Content\*Videos.zip .\eXo\util\unzip -o .\Content\*Videos.zip -d .\

cd eXo\util
if exist ..\..\Content\*Magazines.zip eXoLBpm.exe -i - -"MS-DOS Magazines &amp; Newsletters" -Literature
if exist ..\..\Content\*Books.zip eXoLBpm.exe -i - -"MS-DOS Books" -Literature
if exist ..\..\Content\*Catalogs.zip eXoLBpm.exe -i - -"MS-DOS Catalogs" -Literature
if exist ..\..\Content\*Soundtracks.zip eXoLBpm.exe -i - -"Soundtracks" -Audio
if exist ..\..\Content\*Videos.zip eXoLBpm.exe -i - -"MS-DOS Videos" -Video
cd ..\..
if exist .\Data\*_tmp.xml del .\Data\*_tmp.xml

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
.\eXo\util\choice /C:CE /N [C]ontinue or [E]xit

if errorlevel = 2 goto end
if errorlevel = 1 goto a1

:a1
cd eXo\util
if not exist CHOICE.exe unzip.exe -o -q util*.zip CHOICE.EXE
if not exist choice.exe goto MAJORERROR
if not exist theme.bat unzip.exe -o -q util*.zip theme.bat
call theme
cd ..\..\
cls

echo.
if %multi% == false echo                                     %ctitles%-=[%ctitle%WELCOME to eXo%name%%ctitles%]=- 
if %multi% == true echo                                     %ctitles%-=[%ctitle%WELCOME to eXoMerge%ctitles%]=- 
echo.

if %multi% == true echo %cpress%This setup will install all eXo projects whose files are in this folder. The following packs have been
if %multi% == true echo detected:
if %multi% == true setlocal EnableDelayedExpansion
if %multi% == true for %%f in (".\content\^!*.zip") do (
set pack2=%%f
set pack=!pack2:~10,-12!
echo %ctitle%eXo!pack!
)
if %multi% == true echo.
if %multi% == true echo %cpress%If you do not see a pack listed that you wish to merge, please ensure it has been copied to this folder.

if %multi% == false echo %cpress%This setup will install %ctitle%eXo%name%%cpress%.
if %multi% == false echo.
if %multi% == false echo However, if you wish to merge\combine, you will want to ensure you have copied all of the projects you wish
if %multi% == false echo to merge into the folder you ran this setup file from.
if %multi% == false echo.
if %multi% == false echo For example, if you have downloaded both %ctitle%eXo%name%%cpress% and another eXo pack, they can be combined into a single
if %multi% == false echo instance so that you may browse games from both packs in the same LaunchBox setup.
if %multi% == false echo.
if %multi% == false echo There are a few ways to do this. If you have never set an eXo project up before, you can place them all in
if %multi% == false echo the same folder and run the setup for the newest release. It will detect all of the packs and install them
if %multi% == false echo together.
if %multi% == false echo.
if %multi% == false echo On the other hand, if you already have some eXo projects setup, you can use the Merge Utility. This can be
if %multi% == false echo found on the project's discord. I am planning on integrating it into this pack on the next release.
echo %cchoice%
.\exo\util\choice /C:CEM /N [C]ontinue, [E]xit, or [M]erge Instructions

If errorlevel = 3 goto mergei
If errorlevel = 2 goto end
If errorlevel = 1 goto checks

:mergei
cls
echo.
echo %cpress%These instructions are for merging uninstalled packs.
echo.
echo %cpress%To merge eXo packs together, you will need to copy the files of all packs you wish to merge into the same folder.
echo Specifically, you need to copy the following files and subfolders:
echo "    %ctitle%.\Content\%cpress%        <-%cpick%FOLDER%cpress%    "
echo "    %ctitle%.\eXo\%cpress%            <-%cpick%FOLDER%cpress%    "
echo "    %ctitle%Setup.bat file%cpress%    <-%cpick%FILE%cpress%      "
echo.
echo Copy these files %ctitle%*before*%cpress% running setup. 
echo %cchoice%
pause
goto a1

:checks
setlocal DisableDelayedExpansion
if not exist .\eXo\util\util*.zip (
cls
echo.
echo %ctitle%%ERROR
echo.
echo %cpress%%You are missing the util file. This file contains the emulators, along with several
echo utilities required to run the games included with this pack.
echo.
echo The file resides in the .\eXo\util\ folder
echo Please make sure this file has been downloaded before proceeding with setup.
echo.
echo Exiting setup
echo %cchoice%
pause
goto end
)

if %content%==false goto nextcheck

:nextcheck
if %name%==DOS (
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
 if not exist .\Content\DOSBooks.zip echo Book Content Add-On Pack:		Missing
 if exist .\Content\DOSBooks.zip echo Book Content Add-On Pack:		Present
 if not exist .\Content\DOSCatalogs.zip echo Catalog Content Add-On Pack:		Missing
 if exist .\Content\DOSCatalogs.zip echo Catalog Content Add-On Pack:		Present
 if not exist .\Content\DOSMagazines.zip echo Magazine Content Add-On Pack:		Missing
 if exist .\Content\DOSMagazines.zip echo Magazine Content Add-On Pack:		Present
 if not exist .\Content\DOSSoundtracks.zip echo Soundtrack Content Add-On Pack:		Missing
 if exist .\Content\DOSSoundtracks.zip echo Soundtrack Content Add-On Pack:		Present
 if exist .\Content\DOSVideos.zip echo Video Content Add-On Pack:		Present
 if not exist .\Content\DOSVideos.zip echo Video Content Add-On Pack:		Missing
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
 if not exist .\Content\DOSVideos.zip (
 pause
 goto GameData
 )
)

:GameData
if not %name%=="DOS" goto metadata
rem if not exist .\Content\GameData goto gerror
goto metadata

:gerror
cls
echo.
echo %ctitle%ERROR
echo.
echo %cpress%You are missing the GameData subfolder.
echo This folder contains all of the manuals, music, and extras for each game.
echo.
echo This subfolder should be in your .\Content\ folder.
echo %cchoice%
pause
goto end

:metadata
if not exist .\Content\^!*metadata.zip goto merror
goto lbcheck

:merror
cls
echo.
echo %ctitle%ERROR
echo.
echo %cpress%You are missing the !metadata file (!^<name^>metadata.zip).
echo Without this, the entire pack is unplayable.
echo This file contains the actual launch files and configuration files need to play the games.
echo Please download this file and then re-run setup.
echo.
echo This file should be in your .\Content\ folder.
echo.
echo Exiting setup
echo %cchoice%
pause
goto end

:lbcheck
if not exist .\Content\LaunchBox.zip (
cls
echo.
echo %ctitle%ERROR
echo.
echo %cpress%You are missing the LaunchBox.zip file.
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
echo %ctitle%ERROR
echo.
echo %cpress%You are missing the XOMetadata file (XO^<name^>Metadata.zip).
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
echo %cpress%Do you want to continue setup without support for LaunchBox?
echo.
echo %cnote%Note: Launchbox is the front end. Without it, you will simply have a collection
if %multi% == false echo of %name% zip files and a !%name% folder full of config files and game launch files.
if %multi% == true echo of zip files and a folder full of config files and game launch files.
echo Do not use this method if you aren't 100%% sure of what you are doing.
echo %cchoice%
.\exo\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto skip_lb

:verify
cls
set x64=false
rem wmic os get osarchitecture > oscheck.txt
rem systeminfo | findstr /I type: > oscheck.txt
cmd /c "echo %PROCESSOR_ARCHITECTURE%" > oscheck.txt
for /F %%a in ('findstr /C:AMD64 oscheck.txt') do set x64=true
del oscheck.txt

if %x64%==false goto 64check
goto verified

:64check
cls
echo.
echo This machine is not reporting itself as 64 bit. LaunchBox, the front end,
echo will only run on a 64 bit machine. 
echo. 
echo There is a chance that your machine *is* 64 bit, and everything will function
echo fine. There are a handful of machines that do not report this normally.
echo If you believe your machine is 64 bit, then please choose Yes below.
echo.
echo Would you like to continue installing LaunchBox?
echo.
echo Press (Y)es to install everything
echo Press (N)o to only install the games, but not LaunchBox (the front end)
echo.
.\eXo\util\choice /C:YN /N (Y)es or (N)o

If errorlevel = 2 goto skip_lb
If errorlevel = 1 goto verified

:verified
cls
echo.
echo %cpress%All files verified.
echo.
echo Beginning setup
echo.
if %content%==false echo Step %ctitle%1%cpress% of %ctitle%3%cpress%
if %content%==true echo Step %ctitle%1%cpress% of %ctitle%4%cpress%
echo Extracting:     %cnote%LaunchBox files%cpress%
echo Estimated Time: %cnote%1-2 minutes
echo.
echo %cpress%Note: %cnote%Estimated times are based on a non-merged install.
echo %cchoice%
PAUSE
echo %ctitle%EXTRACTING...

.\eXo\util\unzip -o -q .\Content\LaunchBox.zip -d .\
goto continue

:skip_lb
echo.
echo %cpress%Installation will now continue, but please be aware that the front-end will not
echo be functional on this machine. You may still run the games manually by navigating
echo to the games launch folder and running the launch file manually. These can be found
echo in:
if %multi% == false echo .\eXo\eXo%name%\!%name%\
if %multi% == true echo .\eXo\eXoPACK\!PACK\
if %multi% == true echo    *each PACK will have its own name 
echo.
echo Apart from launching the games, the front end also contains metadata, screenshots,
echo manuals, box scans, game music, strategy guides, code wheels, and lots of other
echo interesting things for each game. It is highly recommended that you take the necessary
echo steps to get the frontend working.
echo %cchoice%
pause
goto continue

:continue
cls
echo.
if %content%==false echo %cpress%Step %ctitle%2%cpress% of %ctitle%3%cpress%
if %content%==true echo Step %ctitle%2%cpress% of %ctitle%4%cpress%
echo Extracting      %cnote%LaunchBox Metadata%cpress%
echo Estimated Time: %cnote%About 5 minutes
echo %cchoice%
pause

.\eXo\util\unzip -o .\Content\XO*Metadata.zip -d .\
.\eXo\util\unzip -o .\Content\XODOSMetadata Plugins\eXoPlugin.dll -d .\

cls
echo.
if %content%==false goto step3
if %content%==true echo %cpress%Step %ctitle%3%cpress% of %ctitle%4%cpress%
echo Extracting Media %cnote%Add-On Pack%cpress%
echo Estimated Time:  %cnote%Depends on if you have the entire pack or not
echo                  The full thing will take about an hour.
echo %cnote%
pause

if exist .\Content\*Magazines.zip .\eXo\util\unzip -o .\Content\*Magazines.zip -d .\
if exist .\Content\*Books.zip .\eXo\util\unzip -o .\Content\*Books.zip -d .\
if exist .\Content\*Catalogs.zip .\eXo\util\unzip -o .\Content\*Catalogs.zip -d .\
if exist .\Content\*Soundtracks.zip .\eXo\util\unzip -o .\Content\*Soundtracks.zip -d .\
if exist .\Content\*Videos.zip .\eXo\util\unzip -o .\Content\*Videos.zip -d .\

:step3
cls
echo.
if %content%==false echo Step %ctitle%3%cpress% of %ctitle%3%cpress%
if %content%==true echo Step %ctitle%4%cpress% of %ctitle%4%cpress%
echo Extracting      %cnote%Game Configuration Files%cpress%
echo Estimated Time: %cnote%5-10 minutes.
echo %cchoice%
pause

for /F %%a in ('dir .\Content\GameData\ /A:D /B') DO (
.\eXo\util\unzip -o .\Content\GameData\%%a\*.zip -d .\
)
cls
.\eXo\util\unzip -o .\Content\!*metadata.zip -d .\

rem IF %EXIST% == false goto :skip
rem :cleanup
rem cd exo
rem cd util
rem copy unzip.exe ..
rem for /f %%F in ('dir /b /a-d ^| findstr /vile ".zip .bat"') do del "%%F"
rem for /f %%H in ('dir /A:D /B') do rmdir %%H /s /q
rem copy ..\unzip.exe .\
rem del ..\unzip.exe
rem cd ..
rem cd ..

:skip
cd eXo
.\util\unzip -o .\util\util*.zip -d .\util
if exist .\util\OPT*.zip .\util\unzip -o .\util\OPT*.zip -d .\util\
if exist .\util\EXT*.zip .\util\unzip -o .\util\EXT*.zip
del .\util\OPT*.zip
del .\util\EXT*.zip
.\util\unzip -o .\util\util*.zip ssr.exe -d .\util\
.\util\unzip -o .\util\util*.zip SetConsole.exe -d .\util\
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
echo %cpress%Would you like to remove access to Adult games from LaunchBox?
echo.
echo Please read carefully: "Adult" refers to games with nudity rather than violence. Choosing YES
echo will remove them from the front end, but not remove them from your hard drive.
echo.
echo If they have previously been removed, choosing NO here will restore them in the front end.
echo %cchoice% 
.\eXo\util\choice /C:NY /N [Y]es or [N]o

If errorlevel = 2 goto YESA
If errorlevel = 1 goto NOA

:NOA
if exist .\xml\all\*.xml copy .\xml\all\*.xml .\Data\Platforms\
copy .\xml\Playlists\*.* .\Data\Playlists\
cd xml
call merge_parents
call merge_platforms
cd ..
copy .\xml\Platforms.xml .\Data\
copy .\xml\Parents.xml .\Data\
if exist .\xml\MS-DOS.xml del .\xml\MS-DOS.xml
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
goto screen

:screen
cls
echo.
echo %cpress%Would you like [%cpick%F%cpress%]ullscreen or [%cpick%W%cpress%]indowed mode to be the default setting?
echo %cchoice%
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
echo %cpress%What is your primary desktop resolution?
echo [%cpick%L%cpress%]arge (4k)
echo [%cpick%M%cpress%]edium (1080)
echo [%cpick%S%cpress%]mall (less than 1080)
echo. 
echo Note: %cnote%This will be used to calculate the window size in windowed mode.
echo %cchoice%
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
echo %cpress%Would you like to enable Aspect Correction for all games?
echo.
echo Choosing Yes will attempt to preserve the game's original format. In fullscreen
echo mode this will introduce black bars on the sides.
echo.
echo Choosing No will stretch the image to fit your monitor.
echo.
echo Choosing Yes is useful for widescreen monitors which cause stretching or distortion.
echo %cchoice%
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
if %exolite%==false goto nasN
cls
echo.
echo %cpress%Would you like to install eXoDREAMM games from a network share?
echo.
echo Choosing Yes will copy each game from the full eXoDREAMM folder on your network
echo share the first time you install it.
echo.
echo Choosing No will leave eXoDREAMM unchanged.
echo %cchoice%
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto nasN
If errorlevel = 1 goto nasY
goto nasN

:nasY
cls
echo %cpress%
set naspath=
set /P naspath=Enter the full path of the eXoDREAMM folder on the network share: 
if not defined naspath goto nasN
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
>".\util\nas_eXoDREAMM.conf" echo %naspath%
for %%F in (install_drm.bat launch_drm.bat launch_drm_verify.bat) do if exist .\NAS\%%F copy /Y .\NAS\%%F .\util\%%F >nul
if not exist .\NAS\install_drm.bat echo WARNING: The NAS version of install_drm.bat was not found.
if not exist "%naspath%\eXo\eXoDREAMM\" echo WARNING: No eXoDREAMM games were found at %naspath%
if not exist "%naspath%\eXo\eXoDREAMM\" pause
goto ini

:nasN
cls
if exist ".\util\nas_eXoDREAMM.conf" del ".\util\nas_eXoDREAMM.conf"
goto ini

:ini
cd ..

cd eXo\util
if exist ..\..\Content\*Magazines.zip eXoLBpm.exe -i - -"MS-DOS Magazines &amp; Newsletters" -Literature
if exist ..\..\Content\*Books.zip eXoLBpm.exe -i - -"MS-DOS Books" -Literature
if exist ..\..\Content\*Catalogs.zip eXoLBpm.exe -i - -"MS-DOS Catalogs" -Literature
if exist ..\..\Content\*Soundtracks.zip eXoLBpm.exe -i - -"Soundtracks" -Audio
if exist ..\..\Content\*Videos.zip eXoLBpm.exe -i - -"MS-DOS Videos" -Video
cls
cd ..\..

.\eXo\util\ffplay.exe -v 0 -nodisp -autoexit .\eXo\util\sand.mp3
cls
echo.
if %multi% == false echo eXo%name% is now setup. Enjoy!
if %multi% == true echo Your eXoPacks are now setup. Enjoy!
echo.
echo %cpress%Would you like to create an icon on your desktop?
echo %cchoice%
.\eXo\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto shortcut

:shortcut
echo [InternetShortcut] > "%userprofile%\Desktop\eXo%name%.url"
echo URL=%CD%\LaunchBox.exe >> "%userprofile%\Desktop\exo%name%.url"
echo IconFile=%CD%\eXo\util\exodos.ico >> "%userprofile%\Desktop\eXo%name%.url"
echo IconIndex=0 >> "%userprofile%\Desktop\eXo%name%.url"
goto end

:MAJORERROR
cls
echo ===================================
echo              WARNING
echo ===================================
echo.
echo You are missing a file called choice.exe. This should have been extracted from the util file when you first
echo started the setup process. It is literally the first thing that should happen. Please ensure the util.zip and
echo unzip.exe files exist in a folder called:
echo .\eXo\util\
echo.
echo If either of these files are missing, you will need to go back to your torrent client and redownload them.
echo.
pause

:end