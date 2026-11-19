:main
set gamecnt=0
@for /D %%Y in (.\eXo\eXoWin9x\????) do @for %%A in ("%%Y\*.zip") do set /a gamecnt+=1
set exolite=false
if %gamecnt% LEQ 100 set exolite=true
rem Setup re-extracts the stock scripts, so keep the NAS versions
findstr /C:"nasconf" .\eXo\util\install9x.bat >nul 2>nul
if not errorlevel 1 (
	if not exist .\eXo\NAS\ md .\eXo\NAS
	for %%F in (install9x.bat 9xlaunch.bat 9xlaunch86Box.bat 9xlaunch86BoxME.bat 9xlaunchPCBox.bat 9xSetup86BoxME.bat) do copy /Y .\eXo\util\%%F .\eXo\NAS\%%F >nul
)
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

if not exist .\eXo\util\util*.zip (
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the util file. This file contains the emulators, along with several
echo utilities required to run the games included with this pack.
echo.
echo The file resides in the %cpress%.\eXo\util\ %cclear%%cnote%folder
echo Please make sure this file has been downloaded before proceeding with setup.%cclear%
echo.
echo %cpress%Exiting setup
pause
goto end
)

cd exo\util
unzip.exe -o -q util*.zip CHOICE.EXE
unzip.exe -o -q util*.zip theme.bat
call theme
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
echo %ctitle%An eXo project or previous LaunchBox install has previously been setup in this folder.%cclear%
echo.
if %multi% == true echo %cnote%More than one eXo pack has been detected in this folder. If you continue
if %multi% == true echo they will all be installed together and merged.%cclear%
if %multi% == true echo.
if %multi% == true echo %cpress%Press %cpick%C%cclear%%cpress% to Continue (This will Re-extract, Update or Install all eXo packs in this folder)
if %multi% == false echo %cpress%Press %cpick%C%cclear%%cpress% to Continue (This will Re-extract or Update the existing eXo packs)
echo %cpress%Press %cpick%E%cclear%%cpress% to Exit
echo.
if %multi% == false echo %cnote%If you wish to merge multiple eXo packs together, please ensure all of the packs have been copied
if %multi% == false echo to this folder before you run setup. If you wish to do this, please exit now and restart the Setup
if %multi% == false echo process once all files are in their proper place.%cclear%
if %multi% == false echo %cchoice%
.\exo\util\choice /C:CE /N [C]ontinue or [E]xit

if errorlevel = 2 goto end
if errorlevel = 1 goto a1

:a1
cd exo\util
if not exist CHOICE.EXE unzip.exe -o -q util*.zip CHOICE.EXE
if not exist theme.bat unzip.exe -o -q util*.zip theme.bat
call theme
cd ..
cd ..
cls

echo.
if %multi% == false echo                                     %ctitles%-=[%cclear%%ctitle%WELCOME to eXo%name%%ctitles%]=-%cclear%
if %multi% == true echo                                     %ctitles%-=[%cclear%%ctitle%WELCOME to eXoMerge%ctitles%]=-%cclear%
echo.

if %multi% == true echo %cnote%This setup will install all eXo projects whose files are in this folder. The following packs have been
if %multi% == true echo detected:%cclear%
if %multi% == true setlocal EnableDelayedExpansion
if %multi% == true for %%f in (".\content\^!*.zip") do (
set pack2=%%f
set pack=!pack2:~10,-12!
echo eXo!pack!
)
if %multi% == true echo.
if %multi% == true echo %cnote%If you do not see a pack listed that you wish to merge, please ensure it has been copied to this folder.%cclear%

if %multi% == false echo %cnote%This setup will install %cpress%eXo%name%%cclear%%cnote%.
if %multi% == false echo.
if %multi% == false echo However, if you wish to merge\combine, you will want to ensure you have copied all of the projects you wish
if %multi% == false echo to merge into the folder you ran this setup file from.
if %multi% == false echo.
if %multi% == false echo For example, if you have downloaded both eXo%name% and another eXo pack, they can be combined into a single
if %multi% == false echo instance so that you may browse games from both packs in the same LaunchBox setup. To do this, simply copy
if %multi% == false echo all of the files (retaining their original folder structure) to the same folder. Then run this setup file.
if %multi% == false echo The packs will be detected and merged during the installation process. You can do this with as many eXo
if %multi% == false echo packs as you like.%cclear%
echo %cchoice%
.\exo\util\choice /C:CEM /N [C]ontinue, [E]xit, or [M]erge Instructions

If errorlevel = 3 goto mergei
If errorlevel = 2 goto end
If errorlevel = 1 goto checks

:mergei
cls
echo.
echo %cnote%To merge eXo packs together, you will need to copy the files of all packs you wish to merge into the same folder.
echo Specifically, you need to copy the following files and subfolders:%cclear%
echo "    %cpress%.\Content\%cclear%        %ctitle%<-FOLDER%cclear%    "
echo "    %cpress%.\eXo\%cclear%            %ctitle%<-FOLDER%cclear%    "
echo "    %cpress%Setup.bat     %cclear%    %ctitle%<-FILE%cclear%      "%cclear%
echo.
echo %cnote%It is best to copy these files *before* running setup. 
echo.
pause
goto a1

:checks
setlocal DisableDelayedExpansion
if not exist .\eXo\util\util*.zip (
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the util file. This file contains the emulators, along with several
echo utilities required to run the games included with this pack.
echo.
echo The file resides in the .\eXo\util\ folder
echo Please make sure this file has been downloaded before proceeding with setup.%cclear%
echo.
echo %cpress%Exiting setup%cchoice%
pause
goto end
)

if %content%==false goto nextcheck

:nextcheck
if %name%==DOS (
cls
echo.
echo %ctitle%Content Add-On Pack Missing%cclear%
echo.
echo %cnote%A media content pack is available. This includes magazines, books,
echo catalogs, and soundtracks. If you wish to add these features, please download
echo the content pack and ensure the files are in your .\Content\ folder.
echo.
echo At that point, run the setup file again and it will detect and add these
echo features to your install.%cclear%
echo.
pause
goto GameData
)

if %content%==true (
 cls
 echo.
 if not exist .\Content\DOSBooks.zip echo %cnote%Books Content Add-On Pack:		%cpress%Missing%cclear%
 if exist .\Content\DOSBooks.zip echo %cnote%Books Content Add-On Pack:		%cpress%Present%cclear%
 if not exist .\Content\DOSCatalogs.zip echo %cnote%Catalogs Content Add-On Pack:		%cpress%Missing%cclear%
 if exist .\Content\DOSCatalogs.zip echo %cnote%Catalogs Content Add-On Pack:		%cpress%Present%cclear%
 if not exist .\Content\DOSMagazines.zip echo %cnote%Magazines Content Add-On Pack:		%cpress%Missing%cclear%
 if exist .\Content\DOSMagazines.zip echo %cnote%Magazines Content Add-On Pack:		%cpress%Present%cclear%
 if not exist .\Content\DOSSoundtracks.zip echo %cnote%Soundtracks Content Add-On Pack:	%cpress%Missing%cclear%
 if exist .\Content\DOSSoundtracks.zip echo %cnote%Soundtracks Content Add-On Pack:	%cpress%Present%cclear%
 echo.
 echo %cnote%A media content pack is available. This includes magazines, books,
 echo catalogs, and soundtracks. If you wish to add these features, please download
 echo the content pack and ensure the files are in your .\Content\ folder.%cclear%
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
if not %name%=="DOS" goto metadata
if not exist .\Content\GameData goto gerror
goto metadata

:gerror
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the GameData subfolder.
echo This folder contains all of the manuals, music, and extras for each game.
echo.
echo This subfolder should be in your .\Content\ folder.%cclear%
echo.
pause
goto end

:metadata
if not exist .\Content\^!*metadata.zip goto merror
goto lbcheck

:merror
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the !metadata file %cpress%(!^<name^>metadata.zip)%cclear%.
echo Without this, the entire pack is unplayable.
echo This file contains the actual launch files and configuration files need to play the games.
echo Please download this file and then re-run setup.
echo.
echo This file should be in your .\Content\ folder.%cclear%
echo.
echo %cpress%Exiting setup%cchoice%
pause
goto end

:lbcheck
if not exist .\Content\LaunchBox.zip (
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the %cpress%LaunchBox.zip%cclear%%cnote% file.
echo Without this, you will have no front end.
echo.
echo This file should be in your .\Content\ folder.
echo.
echo If you plan to use a different front end or no front end at all, you can choose
echo to continue.%cclear%
echo.
goto check
)

if %multi% == true if not exist .\Content\XO*Metadata.zip goto m2error
if %multi% == false if not exist .\Content\XO%name%Metadata.zip goto m2error
goto verified

:m2error
cls
echo.
echo %ctitle%ERROR%cclear%
echo.
echo %cnote%You are missing the XOMetadata file %cpress%(XO^<name^>Metadata.zip)%cclear%%cnote%.
echo Without this LaunchBox will not run properly.
echo This file contains the manuals, xml, and image data LaunchBox needs.
echo.
echo This file should be in your .\Content\ folder.
echo.
echo If you plan to use a different front end or no front end at all, you can choose
echo to continue.%cclear%
echo.
goto check
)

:check
echo.
echo Do you want to continue setup without support for LaunchBox?
echo.
echo Note: %cnote%Launchbox is the front end. Without it, you will simply have a collection
if %multi% == false echo of %name% zip files and a !%name% folder full of config files and game launch files.
if %multi% == true echo of zip files and a folder full of config files and game launch files.
echo Do not use this method if you aren't 100%% sure of what you are doing.
echo %cchoice% 
.\exo\util\choice /C:YN /N (Y)es or (N)o

If errorlevel = 2 goto end
If errorlevel = 1 goto skip

:verified
cls
set x64=false
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
echo %cpress%All files verified.%cclear%
echo.
echo %cpress%Beginning setup%cclear%
echo.
if %content%==false echo Step 1 of 3
if %content%==true echo Step 1 of 4
echo %cnote%Extracting LaunchBox files%cclear%
echo %cnote%Estimated Time:%cclear% %ctitles%Less than 5 minutes.%cclear%
echo. 
PAUSE
echo %ctitle%EXTRACTING...%cclear%

.\eXo\util\unzip -o -q .\Content\LaunchBox.zip -d .\
goto continue

:skip_lb
echo %cclear%
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
if %content%==false echo %cpress%Step 2 of 3%cclear%
if %content%==true echo %cpress%Step 2 of 4%cclear%
echo %cnote%Extracting LaunchBox Metadata
echo Estimated Time: %clear%%ctitles%25-30 minutes%cclear%%cnote%.
echo.
pause

.\eXo\util\unzip -o .\Content\XO*Metadata.zip -d .\
.\eXo\util\unzip -o .\Content\XODOSMetadata.zip *.dll -d .\

cls
echo.
if %content%==false goto step3
if %content%==true echo %cpress%Step 3 of 4%cclear%
echo %cnote%Extracting Media Add-On Pack
echo Estimated Time: %clear%%ctitles%Depends on if you have the entire pack or not
echo                 The full thing will take about an hour%cclear%%cnote%.
echo.
pause

if exist .\content\*magazines.zip .\eXo\util\unzip -o .\Content\*magazines.zip -d .\
if exist .\content\*books.zip .\eXo\util\unzip -o .\Content\*books.zip -d .\
if exist .\content\*catalogs.zip .\eXo\util\unzip -o .\Content\*catalogs.zip -d .\
if exist .\content\*soundtracks.zip .\eXo\util\unzip -o .\Content\*soundtracks.zip -d .\

:step3
cls
echo.
if %content%==false echo %cpress%Step 3 of 3%cclear%
if %content%==true echo %cpress%Step 4 of 4%cclear%
echo %cnote%Extracting Game Configuration Files
echo Estimated Time: %clear%%ctitles%30-40 minutes%cclear%%cnote%.
echo. 
pause

for /F %%a in ('dir .\Content\GameData\ /A:D /B') DO (
.\eXo\util\unzip -o .\Content\GameData\%%a\*.zip -d .\
)
cls
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
cd eXo
.\util\unzip -o .\util\util*.zip -d .\util
if exist .\util\OPT*.zip .\util\unzip -o .\util\OPT*.zip -d .\util\
if exist .\util\EXT*.zip .\util\unzip -o .\util\EXT*.zip
if exist .\util\deprotect.zip del .\util\deprotect.zip
if exist .\util\OPT*.zip del .\util\OPT*.zip
if exist .\util\EXT*.zip del .\util\EXT*.zip
.\util\unzip -o .\util\util*.zip ssr.exe -d .\util\
.\util\unzip -o .\util\util*.zip SetConsole.exe -d .\util\
.\util\unzip -o .\util\util*.zip choice.exe -d .\util\
if not exist .\util\scummvm.ini goto skipsvm
if not exist %USERPROFILE%\AppData\Roaming\ScummVM\scummvm.ini (
md %USERPROFILE%\AppData\Roaming\ScummVM
copy .\util\scummvm.ini %USERPROFILE%\AppData\Roaming\ScummVM\scummvm.ini
)
:skipsvm
cd ..
goto npcap

:skipxtract
goto npcap

:npcap
cls
cls
echo.
echo %ctitle%Multiplayer Dependency%cclear%%cnote%
echo.
echo To enjoy remote multiplayer games in this pack you will need %cpress%npcap%cclear%%cnote% installed.
echo.
echo This is a windows packet capture and delivery application. Version 1.84 is included with this project.
echo.
echo Note: If you wish to do this at a later date, you may right click the eXoWin9x game entry in the front end,
echo select "Additional Applications", and then select "Install Multiplayer Dependency".
echo.
echo Would you like to install npcap now?%cchoice%
.\eXo\util\choice /C:NY /N (Y)es or (N)o

If errorlevel = 2 goto installnpcap
If errorlevel = 1 goto xml

:installnpcap
cd exo\util
call npcap-1.84.exe
cd ..
cd ..
goto xml

:xml
cls
echo.
echo Would you like to remove access to %ctitle%Adult%cclear%%cnote% games from LaunchBox?
echo.
echo %cpress%Please read carefully: %cclear%%cnote%"Adult" refers to games with nudity rather than violence. Choosing %cpress%YES%cclear%%cnote%
echo will remove them from the front end, but not remove them from your hard drive.
echo.
echo If they have previously been removed, choosing %cpress%NO%cclear%%cnote% here will restore them in the front end.
echo %cchoice% 
.\eXo\util\choice /C:NY /N (Y)es or (N)o

If errorlevel = 2 goto YESA
If errorlevel = 1 goto NOA

:NOA
if exist .\xml\ALL\*.xml copy .\xml\ALL\*.xml .\Data\Platforms\
copy .\xml\Playlists\*.* .\Data\Playlists\
cd xml
call merge_parents
call merge_platforms
if exist merge_9xfamily.bat call merge_9xfamily
cd ..
if exist .\xml\merge_9xfamily.bat copy ".\xml\Windows 9x.xml" .\Data\Platforms
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
if exist merge_9xall.bat call merge_9xall
cd ..
if exist .\xml\merge_9xall.bat copy ".\xml\Windows 9x.xml" .\Data\Platforms
copy .\xml\Platforms.xml .\Data\
copy .\xml\Parents.xml .\Data\
if exist .\xml\MS-DOS.xml del .\xml\MS-DOS.xml
goto screen

:screen
cls
echo.
echo %cpress%Would you like [%cpick%F%cpress%]ullscreen or [%cpick%W%cpress%]indowed mode to be the default setting?
echo.%cchoice%
.\eXo\util\choice /C:FW

If errorlevel = 2 goto WIN
If errorlevel = 1 goto FULL

:FULL
cd eXo
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 fullscreen=false fullscreen=true .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 fullscreen=false fullscreen=true .\emulators\dosbox\options.conf
if exist ".\util\WIN.SEL" del ".\util\WIN.SEL"
echo > ".\util\FULL.SEL"
cd ..
goto res

:WIN
cd eXo
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 fullscreen=true fullscreen=false .\emulators\dosbox\options9x.conf
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
echo %cnote%What is your primary desktop resolution?
echo %cpress%[%cpick%L%cpress%]arge (4k)
echo %cpress%[%cpick%M%cpress%]edium (1080)
echo %cpress%[%cpick%S%cpress%]mall (less than 1080)
echo.
echo %cnote%Note: This will be used to calculate the window size in windowed mode.
echo.%cchoice%
.\util\choice /C:LMS

if errorlevel = 3 goto small 
if errorlevel = 2 goto medium
if errorlevel = 1 goto large

:large
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=640x480 windowresolution=2560x1920 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=2560x1920 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=640x480 windowresolution=2560x1920 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=2560x1920 .\emulators\dosbox\options.conf
echo > ".\util\LRG.SEL"
goto ratio

:medium
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=640x480 windowresolution=1280x960 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=1280x960 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=640x480 windowresolution=1280x960 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=1280x960 .\emulators\dosbox\options.conf
echo > ".\util\MED.SEL"
goto ratio

:small
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=640x480 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=640x480 .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=1280x960 windowresolution=640x480 .\emulators\dosbox\options.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 windowresolution=2560x1920 windowresolution=640x480 .\emulators\dosbox\options.conf
echo > ".\util\SML.SEL"
goto ratio

:ratio
cls
echo. %cback%%cwipe%
echo %cpress%Would you like to enable Aspect Correction for all games?
echo.
echo %cnote%Choosing %cpress%YES%cnote% will attempt to preserve the game's %cpress%original format%cnote%. In fullscreen
echo mode this will introduce black bars on the sides.
echo.
echo Choosing %cpress%NO%cnote% will %cpress%stretch%cnote% the image to fit your monitor.
echo.
echo Choosing %cpress%YES%cnote% is useful for widescreen monitors which cause stretching or distortion.
echo.%cchoice%
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto aspectN
If errorlevel = 1 goto aspectY

:aspectY
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 aspect=false aspect=true .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 aspect=false aspect=true .\emulators\dosbox\options.conf
if exist ".\util\ANO.SEL" del ".\util\ANO.SEL"
echo > ".\util\AYES.SEL"
goto nas

:aspectN
cls
if exist .\emulators\dosbox\options9x.conf .\util\ssr 0 aspect=true aspect=false .\emulators\dosbox\options9x.conf
if exist .\emulators\dosbox\options.conf .\util\ssr 0 aspect=true aspect=false .\emulators\dosbox\options.conf
if exist ".\util\AYES.SEL" del ".\util\AYES.SEL"
echo > ".\util\ANO.SEL"
goto nas

:nas
if %exolite%==false goto nasN
cls
echo.
echo %cpress%Would you like to install eXoWin9x games from a network share?
echo.
echo Choosing Yes will copy each game from the full eXoWin9x folder on your network
echo share the first time you install it.
echo.
echo Choosing No will leave eXoWin9x unchanged.
echo %cchoice%
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto nasN
If errorlevel = 1 goto nasY
goto nasN

:nasY
cls
echo %cpress%
set naspath=
set /P naspath=Enter the full path of the eXoWin9x folder on the network share: 
if not defined naspath goto nasN
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
>".\util\nas_eXoWin9x.conf" echo %naspath%
for %%F in (install9x.bat 9xlaunch.bat 9xlaunch86Box.bat 9xlaunch86BoxME.bat 9xlaunchPCBox.bat 9xSetup86BoxME.bat) do if exist .\NAS\%%F copy /Y .\NAS\%%F .\util\%%F >nul
if not exist .\NAS\install9x.bat echo WARNING: The NAS version of install9x.bat was not found.
if not exist "%naspath%\eXo\eXoWin9x\" echo WARNING: No eXoWin9x games were found at %naspath%
if not exist "%naspath%\eXo\eXoWin9x\" pause
goto ini

:nasN
cls
if exist ".\util\nas_eXoWin9x.conf" del ".\util\nas_eXoWin9x.conf"
goto ini

:ini
cd ..

cd exo\util
if exist ..\..\content\*magazines.zip eXoLBpm.exe -i - -"MS-DOS Magazines &amp; Newsletters" -Literature
if exist ..\..\content\*books.zip eXoLBpm.exe -i - -"MS-DOS Books" -Literature
if exist ..\..\content\*catalogs.zip eXoLBpm.exe -i - -"MS-DOS Catalogs" -Literature
if exist ..\..\content\*soundtracks.zip eXoLBpm.exe -i - -"Soundtracks" -Audio
cls
cd ..\..

.\eXo\util\ffplay.exe -v 0 -nodisp -autoexit .\eXo\util\meat.mp3
cls
echo. %cback%%cwipe%
if %multi% == false echo %ctitle%eXo%name% is now setup. Enjoy!%cclear%
if %multi% == true echo %ctitle%Your eXoPacks are now setup. Enjoy!%cclear%
echo.
echo Would you like to create an icon on your desktop?
echo.
echo %press%Note: %cnote%This can fail due to a number of reasons, including virus protection.
echo %cchoice%
.\exo\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto shortcut

:shortcut
echo [InternetShortcut] > "%userprofile%\Desktop\eXo%name%.url"
echo URL=%CD%\LaunchBox.exe >> "%userprofile%\Desktop\exo%name%.url"
echo IconFile=%CD%\eXo\util\exodos.ico >> "%userprofile%\Desktop\eXo%name%.url"
echo IconIndex=0 >> "%userprofile%\Desktop\eXo%name%.url"

:end