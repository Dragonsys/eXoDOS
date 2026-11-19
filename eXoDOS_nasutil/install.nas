cd %FOLDER%
@echo off 
set mediafiles=false
set CONF=%CD%
set RESTORE=NO
set nasconf=.\util\nas.conf
for %%I in (.) do set GameDir=%%~nxI
for %%f in (*^).bat) do set GameName2=%%f
set GameName=%GameName2:~0,-4%
set IndexName=%GameName:~0,-7%
cd ..
cd ..
cd ..

if [%lang%]==[] set lang=false
if [%lang_cnt%]==[] set lang_cnt=0
if %lang_cnt% == 1 goto :skip_selection
set lang_cnt=0

if exist ".\eXoDOS\!dos\!Chinese\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\%GameName%.zip" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!French\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!German\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!Italian\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!Korean\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!Polish\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!Russian\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1
if exist ".\eXoDOS\!dos\!Spanish\%GameDir%\*).bat" set /A lang_cnt=%lang_cnt%+1

if %lang_cnt% == 0 goto :English
if %lang_cnt% == 1 goto :skip_selection
rem if NOT %lang% == false goto :skip_selection

.\util\setconsole.exe /reset
cls
echo.
echo Language Selection Menu
echo.
if exist ".\eXoDOS\!dos\!Chinese\%GameDir%\*).bat" echo Press C to install or configure the Chinese version
if exist ".\eXoDOS\%GameName%.zip" echo Press E to install or configure the English version
if exist ".\eXoDOS\!dos\!French\%GameDir%\*).bat" echo Press F to install or configure the French version
if exist ".\eXoDOS\!dos\!German\%GameDir%\*).bat" echo Press G to install or configure the German version
if exist ".\eXoDOS\!dos\!Italian\%GameDir%\*).bat" echo Press I to install or configure the Italian version
if exist ".\eXoDOS\!dos\!Korean\%GameDir%\*).bat" echo Press K to install or configure the Korean version
if exist ".\eXoDOS\!dos\!Polish\%GameDir%\*).bat" echo Press P to install or configure the Polish version
if exist ".\eXoDOS\!dos\!Russian\%GameDir%\*).bat" echo Press R to install or configure the Russian version
if exist ".\eXoDOS\!dos\!Spanish\%GameDir%\*).bat" echo Press S to install or configure the Spanish version
echo Press X to Quit
echo.
.\util\choice /C:CEFGIKPRSX /N Please Choose:

if errorlevel = 1 set lang=!chinese
if errorlevel = 2 set lang=!english
if errorlevel = 3 set lang=!french
if errorlevel = 4 set lang=!german
if errorlevel = 5 set lang=!italian
if errorlevel = 6 set lang=!korean
if errorlevel = 7 set lang=!polish
if errorlevel = 8 set lang=!russian
if errorlevel = 9 set lang=!spanish
if errorlevel = 10 goto exit

:skip_selection
.\util\setconsole.exe /minimize
if %lang% == !english goto english
cd ".\eXoDOS\!dos\%lang%\%GameDir%\"
install.bat
cls

:english
for %%G in (".\eXoDOS\%GameName%.zip") do set size=%%~zG
if "%size%"=="0" del ".\eXoDOS\%GameName%.zip"
IF EXIST "eXoDOS\%GameName%.zip" goto next
IF EXIST %nasconf% goto nasprompt

cls
set gigabyte=false
set totalsizemb=0
for /F "delims=" %%a in ('findstr /C:":%GameName%" .\util\aria\index.txt') do set fullindex=%%a
for /F "delims=" %%b in ('findstr /C:":./GameData/eXoDOS/%GameName%" .\util\aria\index.txt') do set fullindex2=%%b
set filesize2=%fullindex2:*:=%
set filesizex=%filesize2:*:=%
set filesize1=%fullindex:*:=%
set filesize=%filesize1:*:=%
set removeindex=%fullindex:*:=%
CALL set result=%%fullindex:%removeindex%=%%
set index=%result:~0,-1%

IF DEFINED fullindex2 goto cont
set combinedsize=%filesize%
set filesizex=0Kib
goto dl

:cont
set mediafiles=true
set removeindex2=%fullindex2:*:=%
CALL set result2=%%fullindex2:%removeindex2%=%%
set index=%result:~0,-1%
set index2=%result2:~0,-1%
Set "gamesize2=%filesize:* =%"
Set "contentsize2=%filesizex:* =%"

REM -=remove the parenthesis=-
set gamesize3=%gamesize2:~1,-1%
set contentsize3=%contentsize2:~1,-1%

REM -=remove the comma=-
set gamesize4=%gamesize3:,=%
set contentsize4=%contentsize3:,=%

REM -=Preliminary unit check. If more than 1 GB, special actions needed=-
set unit=Gb
if %gamesize4% LSS 1000000000 set unit=Mb
if %gamesize4% LSS 1000000 set unit=Kb
if %gamesize4% LSS 1000 set unit=b
if %unit%==Gb set gigabyte=true

REM -=Remove the one digit if it is over 1Gb due to integer limitations in batch=-
if %gigabyte%==true set gamesize4=%gamesize4:~0,-1%
if %gigabyte%==true set contentsize4=%contentsize4:~0,-1%

REM -=Add content size to game size to determine final download size=-
set /a totalsize=%gamesize4%+%contentsize4%

REM -=Add one's place back if it is over a Gb, as we removed it earlier=-
if %gigabyte%==true set totalsize=%totalsize%0

REM -=Determine the combined unit=-
set unit=Gb
if %totalsize% LSS 1000000000 set unit=Mb
if %totalsize% LSS 1000000 set unit=Kb
if %totalsize% LSS 1000 set unit=b

REM -=This section populates the Kb, Mb, and Gb variables, to build the final on the download page=-
set totalsizekb=%totalsize:~0,-3%
if [%totalsizekb%]==[] set totalsizekb=%totalsize%

if %gigabyte%==false set /a totalsizemb=%totalsize%/1000000
if %gigabyte%==true set totalsizemb=%totalsize:~0,-6%
if [%totalsizemb%]==[] set totalsizemb=%totalsize%

if %gigabyte%==false set /a totalsizegb=%totalsize%/1000000000
if %gigabyte%==true set totalsizegb=%totalsize:~0,-9%
if [%totalsizegb%]==[] set totalsizegb=%totalsize%

REM -=Based on Unit type, create the final value=-
if %unit%==Gb set combinedsize=%totalsizegb%.%totalsizemb:~1,-1% %unit%
if %unit%==Mb set combinedsize=%totalsizemb%.%totalsizekb:~3,-1% %unit%
if %unit%==Kb set combinedsize=%totalsizekb% %unit%

rem -=Check section, to verify values during testing=-
rem echo filesize=%filesize%
rem echo game size=%gamesize4%
rem echo content size=%contentsize4%
rem echo total size=%totalsize%
rem echo total kb=%totalsizekb%
rem echo total mb=%totalsizemb%
rem echo index1 = %index%
rem echo index2 = %index2%
rem echo filesizex = %filesizex%
rem echo combined size = %combinedsize%
rem echo unit = %unit%
rem echo gigabyte = %gigabyte%
rem pause

:dl
.\util\setconsole.exe /reset
cls
echo.
echo It appears you have not downloaded this game yet.
echo.
echo %GameName%'s download size is %filesize%
if %mediafiles%==false echo There are no media files for this game.
if %mediafiles%==true echo The media files for this game are %filesizex%
if %mediafiles%==true echo.
if %mediafiles%==true echo Total download will be %combinedsize%
echo.
echo Would you like to download it?
echo.
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto download

:download
tasklist /FI "IMAGENAME eq aria2c.exe" 2>NUL | find /I /N "aria2c.exe">NUL
if "%ERRORLEVEL%"=="0" goto inprogress

if exist DOWNLOAD rd DOWNLOAD /S /Q
MD DOWNLOAD
MD .\DOWNLOAD\GAMEDATA\
copy .\util\aria\eXoDOS.torrent .\DOWNLOAD\
copy .\util\aria\aria2c.exe .\DOWNLOAD\
cd DOWNLOAD
cls
aria2c.exe --select-file=%INDEX% --index-out=%INDEX%="%GameName%.zip" --file-allocation=none --allow-overwrite=true --seed-time=0 eXoDOS.torrent
aria2c.exe --select-file=%INDEX2% --index-out=%INDEX2%=".\GAMEDATA\%GameName%.zip" --file-allocation=none --allow-overwrite=true --seed-time=0 eXoDOS.torrent
del aria2c.exe
del *.aria2
del *.torrent
cd ..
move ".\DOWNLOAD\%GameName%.zip" ".\eXoDOS\%GameName%.zip"
move ".\DOWNLOAD\GAMEDATA\%GameName%.zip" "..\.\Content\GameData\eXoDOS\%GameName%.zip"

:extract
cd ..
IF EXIST ".\Content\GameData\eXoDOS\%GameName%.zip" .\eXo\util\unzip -o ".\Content\GameData\eXoDOS\%GameName%.zip" -d .\
cd eXo
IF EXIST DOWNLOAD rd DOWNLOAD /S /Q
cd eXoDOS
for %%G in ("%GameName%.zip") do set size=%%~zG
if "%size%"=="0" del "%GameName%.zip"
cls
echo.
IF EXIST "%GameName%.zip" echo Game Downloaded Successfully
IF NOT EXIST "%GameName%.zip" echo There was an error downloading the game. Exiting...
echo.
pause

cd ..
:next
IF EXIST ".\eXoDOS\%GameDir%\" GOTO dele
:unzip
IF NOT EXIST "eXoDOS\%GameName%.zip" goto exit

if not exist ".\eXoDOS\!save\%GameName%.zip" goto unzip2
.\util\setconsole.exe /reset
cls
echo.
echo You have backed up save data for this game. Would you like to restore it?
echo.
.\util\choice /C:YND /N [Y]es or [N]o, or [D]elete your Save
 
if errorlevel = 3 goto remove
If errorlevel = 2 goto unzip2
If errorlevel = 1 goto restore

:remove
.\util\setconsole.exe /minimize
del ".\eXoDOS\!save\%GameName%.zip"
goto unzip2

:restore
.\util\setconsole.exe /minimize
set RESTORE=Y

:unzip2
.\util\setconsole.exe /reset
rem .\util\setconsole.exe /minimize
.\util\unzip ".\eXoDOS\%GameName%.zip" -d .\eXoDOS\
IF %RESTORE% == Y .\util\unzip -o ".\eXoDOS\!save\%GameName%.zip" -d .\eXoDOS\
set RUNUPDATE=N
IF EXIST ".\Update\!dos\%GameName%.zip" set RUNUPDATE=Y
IF EXIST ".\Update\!dos\linux\release\%GameName%.zip" set RUNUPDATE=Y
IF EXIST ".\Update\!dos\linux\%GameName%.zip" set RUNUPDATE=Y
IF %RUNUPDATE% == N goto config

cls
echo.
echo An update for this game has been found. It will now be applied.
echo.
pause
IF EXIST ".\Update\!dos\%GameName%.zip" .\util\unzip -o ".\Update\!dos\%GameName%.zip" -d .\eXoDOS\
IF EXIST ".\Update\!dos\linux\release\%GameName%.zip" .\util\unzip -o ".\Update\!dos\linux\release\%GameName%.zip" -d .\eXoDOS\
IF EXIST ".\Update\!dos\linux\%GameName%.zip" .\util\unzip -o ".\Update\!dos\linux\%GameName%.zip" -d .\eXoDOS\
goto config

:dele
.\util\setconsole.exe /reset
@echo off 
cls
echo.
echo Would you like to
echo [C]onfigure settings
echo [U]ninstall the game
echo.
.\util\choice /C:CU /N Please Choose: [C,U]

IF ERRORLEVEL 2 GOTO erase
IF ERRORLEVEL 1 GOTO config

:config
IF NOT EXIST ".\eXoDOS\%GameDir%\" GOTO exit
.\util\setconsole.exe /reset
cls
echo.
echo Your current global config settings are:
echo.
IF EXIST ".\util\WIN.SEL" echo Windowed mode
IF EXIST ".\util\FULL.SEL" echo Fullscreen mode
IF EXIST ".\util\SML.SEL" echo Small desktop window resolution (less than 1080)
IF EXIST ".\util\MED.SEL" echo Medium desktop window resolution (1080)
IF EXIST ".\util\LRG.SEL" echo Large desktop window resolution (4k)
IF EXIST ".\util\ANO.SEL" echo Aspect correction off
IF EXIST ".\util\AYES.SEL" echo Aspect correction on
echo.
echo Would you like to change any of these?
echo.
echo NOTE: Desktop resolution is only used when in windowed mode. Fullscreen will
echo auto scale to your full desktop resolution.
echo.
.\util\choice /C:YN? /N [Y]es or [N]o, or [?] for more information
 
if errorlevel = 3 goto whatglob
If errorlevel = 2 goto scaler1
If errorlevel = 1 goto aspect

:whatglob
cls
echo.
echo These are Global Settings, in that they are applied to all games in the pack.
echo If you have merged multiple eXo projects together, then these options will be
echo applied to all merged projects.
echo.
echo Fullscreen and Windowed are self-explanatory, however if you have chosen Windowed
echo then selecting the proper desktop resolution is important. Currently the three
echo "buckets" are resolutions lower than 1080, 1080-4k, and 4k or above. In the event
echo you feel your window size is too large or too small, simply re-run the configuration
echo and try the next size up or down. 
echo.
echo Aspect ratio on attempts to preserve the game's original height to width ratio. 
echo Generally, DOS era monitors were 4:3 (W:H). Modern monitors are typically widescreen,
echo such as 16:9. If aspect ratio is off, a 4:3 game may be stretched out on the width
echo axis. Circles turn into ovals and characters become short ^& wide. The recommended
echo settings is "ON". A handful of games do not work properly with aspect ratio enabled.
echo These have been setup to bypass the global option and always run with the setting
echo disabled.
echo.
pause
goto config

:aspect
call .\emulators\dosbox\config.bat
goto scaler1

:scaler1
cls
echo.
echo Would you like to change your graphics filter?
echo.
echo Note: This only affects this game
echo.
.\util\choice /C:YN? /N [Y]es or [N]o, or [?] for more information

if errorlevel = 3 goto whatsy
if errorlevel = 2 goto end
if errorlevel = 1 goto sy

:whatsy
cls
echo.
echo This option is on a per game basis, it does not change globally.
echo.
echo Within DOSBox, the filter/scaler is a post-processed affect that either assists
echo in enhancing a low resolution image or adding a stylized effect. 
echo.
echo DOS games generally had native resolutions between 320x200 to 640x480 (with a few
echo of the later games able to go even higher). On today's resolutions, this requires
echo some scaling in order to blow these screens up to a suitable size.
echo.
echo eXoDOS has the following scalers setup for easy access:
echo None         - With no scaler, you get a direct image that has no been modified
echo Normal2x/3x  - Uses nearest-neighbor to determine how to add pixels.
echo HQ2x/3x      - An algorithm that interpolates pixels, and in turn tends to smooth out edges
echo 2xsai        - This algorithm heavily smooths pixels out, to the point they may appear blurry
echo super2xsai   - So much smoothing that it almost begins to appear cell shaded
echo advmame2x/3x - Also known as EPX, this is a scaler that dates back to 1992.
echo tv2          - adds scanlines to mimic a CRT
echo.
echo Explanation of 2x/3x
echo 2x - Expands a single pixel into a 2x2 block
echo 3x - Expands a single pixel into a 3x3 block
echo Some scalers go up to 4x. However the higher this number gets, the bigger chance you have
echo of distortion and unexpected results.
echo.
echo Another option is to use the "Pixel Perfect & Shader Options" file, which can be found by right
echo clicking a game in LaunchBox and going to additional applications. Within this file are options
echo for Pixel Perfect, Curved CRT, and No Scan Lines (useful for FMV that has black lines)
echo.
echo The eXoDOS manual (PDF) has a sample comparison of all of these scalers on the same image.
echo.
pause
goto scaler1

:sy
cls
echo.
echo Press 1 for no scaler
echo Press 2 for normal3x
echo Press 3 for hq2x
echo Press 4 for hq3x
echo Press 5 for 2xsai
echo Press 6 for super2xsai
echo press 7 for advmame2x
echo press 8 for advmame3x
echo press 9 for tv2x
echo Press 0 for normal2x
echo.
.\util\choice /C:1234567890 /N

if errorlevel = 10 goto :normal2x
if errorlevel = 9 goto :scaltv2x
if errorlevel = 8 goto :scalam3x
if errorlevel = 7 goto :scalam2x
if errorlevel = 6 goto :scals2xs
if errorlevel = 5 goto :scal2xs
if errorlevel = 4 goto :scalhq3x
if errorlevel = 3 goto :scalhq2x
if errorlevel = 2 goto :scaln3x
if errorlevel = 1 goto :scalno

:scalno
set SC=none
goto scaler

:scaln3x
set SC=normal3x
goto scaler

:scalhq2x
set SC=hq2x
goto scaler

:scalhq3x
set SC=hq3x
goto scaler

:scal2xs
set SC=2xsai
goto scaler

:scals2xs
set SC=super2xsai
goto scaler

:scalam2x
set SC=advmame2x
goto scaler

:scalam3x
set SC=advmame3x
goto scaler

:scaltv2x
set SC=tv2x
goto scaler

:normal2x
set SC=normal2x
goto scaler

:scaler
cd "%CONF%"
for %%Z in (*.conf) do (
cd ..
cd ..
cd ..
.\util\ssr 0 scaler=none scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=normal3x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=hq2x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=hq3x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=2xsai scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=super2xsai scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=advmame2x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=advmame3x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=tv2x scaler=%SC% "%CONF%\%%Z"
.\util\ssr 0 scaler=normal2x scaler=%SC% "%CONF%\%%Z"
cd "%CONF%"
)
goto exit

:erase
cls
echo.
echo Would you like to backup your saves and game settings before you uninstall?
echo.
echo NOTE: If you choose yes, then the next time you install this game, it will ask if you
echo would like to restore your saves and settings. These files are stored in your !save
echo folder, in a zip file with the same name as the game.
echo.
echo NOTE 2: If you have already backed up previously, this will overwrite your prior save.
echo.
.\util\choice /C:YN? /N [Y]es or [N]o
 
If errorlevel = 2 goto delete
If errorlevel = 1 goto backup

:backup
cd eXoDOS
..\.\util\zip2 --dif "..\.\eXoDOS\%GameName%.zip" -r .\%GameDir% --out "..\.\eXoDOS\!save\%GameName%.zip"
cd ..

:delete
cmd /c rd /q /s ".\eXoDOS\%GameDir%\"
IF EXIST %nasconf% goto rmzip

:end
cd eXoDOS
if exist unzip.exe erase unzip.exe
goto exit

:nasprompt
.\util\setconsole.exe /reset
cls
echo.
echo It appears you have not copied this game yet.
echo.
echo Would you like to copy %GameName% from the network share?
echo.
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto nas
goto end

:nas
set /p naspath=<%nasconf%
if "%naspath:~-1%"==" " set naspath=%naspath:~0,-1%
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
IF NOT EXIST "%naspath%\eXo\eXoDOS\%GameName%.zip" goto nasmissing
cls
echo.
echo Copying %GameName% from the network share...
echo.
copy /Y "%naspath%\eXo\eXoDOS\%GameName%.zip" ".\eXoDOS\%GameName%.zip"
IF NOT EXIST "%naspath%\Content\GameData\eXoDOS\%GameName%.zip" goto extract
IF NOT EXIST "..\Content\GameData\eXoDOS\" md "..\Content\GameData\eXoDOS"
copy /Y "%naspath%\Content\GameData\eXoDOS\%GameName%.zip" "..\Content\GameData\eXoDOS\%GameName%.zip"
goto extract

:nasmissing
cls
echo.
echo %GameName% was not found on the network share:
echo %naspath%
echo.
pause
goto end

:rmzip
cls
echo.
echo Would you like to delete the game zip files?
echo.
echo NOTE: If you choose yes, then the next time you install this game, you will have
echo to copy the files from the network share again.
echo.
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto end
If errorlevel = 1 goto rmzipY
goto end

:rmzipY
cmd /c del /F /Q ".\eXoDOS\%GameName%.zip"
cmd /c del /F /Q "..\Content\GameData\eXoDOS\%GameName%.zip"
goto end

:inprogress
cls
echo.
echo You are currently already downloading a game. Please complete that download
echo before starting another one.
echo.
pause

:exit