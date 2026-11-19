cd %FOLDER%
@echo off
set CONF=%CD%
set nasconf=.\util\nas_eXoWin9x.conf
for %%I in (.) do set GameDir=%%~nxI
for %%f in (*^).bat) do set GameName2=%%f
set GameName=%GameName2:~0,-4%
set IndexName=%GameName:~0,-7%
cd ..
set RYEAR=%CD:~-4%
cd ..
cd ..
cd ..
call .\util\theme.bat

:next
IF EXIST ".\eXoWin9x\%RYEAR%\%GameDir%\" GOTO dele
:unzip
IF EXIST "eXoWin9x\%RYEAR%\%GameName%.zip" goto unzipgame
IF EXIST %nasconf% goto nasprompt
goto exit

:unzipgame
copy .\util\unzip.exe .\eXoWin9x\%RYEAR%\unzip.exe
cd eXoWin9x\%RYEAR%
unzip "%GameName%.zip"
cd ..
cd ..
goto config

:dele
.\util\setconsole.exe /reset
@echo off 
cls
echo.
echo %ctitles%-=%cclear%%ctitle%Setup Menu%ctitles%=-%cclear%
echo.
echo %cnote%Would you like to%cclear%
echo %cpress%(%cpick%C%cclear%%cpress%)onfigure settings
echo %cpress%(%cpick%U%cclear%%cpress%)ninstall the game%cclear%
echo %cchoice%
.\util\choice /C:CU /N Please Choose:

IF ERRORLEVEL 2 GOTO erase
IF ERRORLEVEL 1 GOTO config

:config
echo %cclear%
echo %cback%
IF NOT EXIST ".\eXoWin9x\%ryear%\%GameDir%\" GOTO exit
.\util\setconsole.exe /reset
for /F "delims=" %%a in ('findstr /i /C:"REM" .\util\theme.bat') do (set theme=%%a)
set theme=%theme:~4%
cls
echo.
echo %ctitles%-=%cclear%%ctitle%Global Settings%ctitles%=-%cclear%
echo.
echo %cnote%Your current global config settings are:%cclear%
echo.
IF EXIST ".\util\WIN.SEL" echo %cpress%Fullscreen mode is    %cselect%Off%cclear%
IF EXIST ".\util\FULL.SEL" echo %cpress%Fullscreen mode is    %cselect%On%cclear%
IF EXIST ".\util\SML.SEL" echo %cpress%Window Resolution is  %cselect%Small (less than 1080)%cclear%
rem Small desktop window resolution (less than 1080)
IF EXIST ".\util\MED.SEL" echo %cpress%Window Resolution is  %cselect%Medium (1080)%cclear%
rem Medium desktop window resolution (1080)
IF EXIST ".\util\LRG.SEL" echo %cpress%Window Resolution is  %cselect%Large (4k)%cclear%
rem Large desktop window resolution (4k)
IF EXIST ".\util\ANO.SEL" echo %cpress%Aspect correction is  %cselect%Off%cclear%
IF EXIST ".\util\AYES.SEL" echo %cpress%Aspect correction is  %cselect%On%cclear%
echo %cpress%Your current theme is %cselect%%theme%%cclear%
echo.
echo %cnote%Would you like to change any of these?
echo.
echo %cnote%NOTE: Desktop resolution is only used when in windowed mode. Fullscreen will
echo auto scale to your full desktop resolution.%cclear%
echo %cchoice%
.\util\choice /C:YN? /N [Y]es or [N]o, or [?] for more information

if errorlevel = 3 goto whatglob
If errorlevel = 2 goto end
If errorlevel = 1 goto config2

:config2
echo %cclear%
echo %cback%
IF NOT EXIST ".\eXoWin9x\%ryear%\%GameDir%\" GOTO exit
.\util\setconsole.exe /reset
for /F "delims=" %%a in ('findstr /i /C:"REM" .\util\theme.bat') do (set theme=%%a)
set theme=%theme:~4%
cls
echo.
echo %ctitles%-=%cclear%%ctitle%Global Settings%ctitles%=-%cclear%
echo.
echo %cnote%Your current global config settings are:%cclear%
echo.
IF EXIST ".\util\WIN.SEL" echo %cpress%Fullscreen mode is    %cselect%Off%cclear%
IF EXIST ".\util\FULL.SEL" echo %cpress%Fullscreen mode is    %cselect%On%cclear%
IF EXIST ".\util\SML.SEL" echo %cpress%Window Resolution is  %cselect%Small (less than 1080)%cclear%
rem Small desktop window resolution (less than 1080)
IF EXIST ".\util\MED.SEL" echo %cpress%Window Resolution is  %cselect%Medium (1080)%cclear%
rem Medium desktop window resolution (1080)
IF EXIST ".\util\LRG.SEL" echo %cpress%Window Resolution is  %cselect%Large (4k)%cclear%
rem Large desktop window resolution (4k)
IF EXIST ".\util\ANO.SEL" echo %cpress%Aspect correction is  %cselect%Off%cclear%
IF EXIST ".\util\AYES.SEL" echo %cpress%Aspect correction is  %cselect%On%cclear%
echo %cpress%Your current theme is %cselect%%theme%%cclear%
echo.
rem echo Would you like to change any of these?
echo %cpress%Press %cpick%1%cclear%%cpress% to turn Fullscreen On^\Off
echo %cpress%Press %cpick%2%cclear%%cpress% to change Window Resolution
echo %cpress%Press %cpick%3%cclear%%cpress% to turn Aspect Ratio On^\Off
echo %cpress%Press %cpick%4%cclear%%cpress% to change the Current Menu Theme Colors
echo %cpress%Press %cpick%5%cclear%%cpress% to Exit
echo.
echo %cnote%NOTE: Desktop resolution is only used when in windowed mode. Fullscreen will
echo auto scale to your full desktop resolution.%cclear%
echo %cchoice%
.\util\choice /C:12345? /N [1], [2], [3], [4], [5] or [?] for more information
rem .\util\choice /C:YN? /N [Y]es or [N]o, or [?] for more information

If errorlevel = 6 goto whatglob2
If errorlevel = 5 goto exit
If errorlevel = 4 goto theme
if errorlevel = 3 goto aspect
If errorlevel = 2 goto resolution
If errorlevel = 1 goto size

:whatglob
echo %cclear%
cls
echo. %cback%%cwipe%
echo %cnote%These are %cpress%Global Settings%cnote%, in that they are applied to all games in the pack.
echo If you have merged multiple eXo projects together, then these options will be
echo applied to all merged projects that support them.
echo.
echo %cpress%Fullscreen%cnote% and %cpress%Windowed%cnote% are self-explanatory, however if you have chosen %cpress%Windowed%cclear%
echo %cnote%then selecting the proper desktop resolution is important. Currently the three
echo "buckets" are %cpress%resolutions%cnote% lower than %cpress%1080%cnote%, %cpress%1080-4k%cnote%, and %cpress%4k or above%cnote%. In the event
echo you feel your window size is too large or too small, simply re-run the configuration
echo and try the next size up or down.%cclear%
echo.
echo %cpress%Aspect ratio%cnote% is the proportional relationship of the game image's width to height. 
echo Generally, DOS era monitors were 4:3 (W:H). Modern monitors are typically widescreen,
echo such as 16:9. If aspect ratio is off, a 4:3 game may be stretched and distorted.
echo Circles turn into ovals and characters become short ^& wide.
echo.
echo The recommended settings is %cpress%ON%cnote%, as this respects the games original layout. Choosing
echo %cpress%OFF%cnote% will stretch the original image to fit your screen. This removes the black side
echo bars at the expense of the game's original ratio.%cclear%
echo.
echo %cpress%Themes%cnote% simply change the menu colors in many of the menus native to the eXo Projects.
echo %cchoice%
pause
echo %cclear%
goto config

:whatglob2
echo %cclear%
cls
echo. %cback%%cwipe%
echo %cnote%These are %cpress%Global Settings%cnote%, in that they are applied to all games in the pack.
echo If you have merged multiple eXo projects together, then these options will be
echo applied to all merged projects that support them.
echo.
echo %cpress%Fullscreen%cnote% and %cpress%Windowed%cnote% are self-explanatory, however if you have chosen %cpress%Windowed%cclear%
echo %cnote%then selecting the proper desktop resolution is important. Currently the three
echo "buckets" are %cpress%resolutions%cnote% lower than %cpress%1080%cnote%, %cpress%1080-4k%cnote%, and %cpress%4k or above%cnote%. In the event
echo you feel your window size is too large or too small, simply re-run the configuration
echo and try the next size up or down.%cclear%
echo.
echo %cpress%Aspect ratio%cnote% is the proportional relationship of the game image's width to height. 
echo Generally, DOS era monitors were 4:3 (W:H). Modern monitors are typically widescreen,
echo such as 16:9. If aspect ratio is off, a 4:3 game may be stretched and distorted.
echo Circles turn into ovals and characters become short ^& wide.
echo.
echo The recommended settings is %cpress%ON%cnote%, as this respects the games original layout. Choosing
echo %cpress%OFF%cnote% will stretch the original image to fit your screen. This removes the black side
echo bars at the expense of the game's original ratio.%cclear%
echo.
echo %cpress%Themes%cnote% simply change the menu colors in many of the menus native to the eXo Projects.
echo %cchoice%
pause
echo %cclear%
goto config2

:aspect
echo %cclear%
call .\emulators\dosbox\config9x.bat A
goto config2

:theme
echo %cclear%
call .\emulators\dosbox\config9x.bat T
goto config2

:resolution
echo %cclear%
call .\emulators\dosbox\config9x.bat R
goto config2

:size
echo %cclear%
call .\emulators\dosbox\config9x.bat S
goto config2

:scaler1
goto end

:erase
rd /q /s ".\eXoWin9x\%RYEAR%\%GameDir%\"
IF EXIST %nasconf% goto rmzip

:end
cd eXoWin9x\%RYEAR%
if exist unzip.exe erase unzip.exe
cd ..\..
goto exit

:nasprompt
.\util\setconsole.exe /reset
cls
echo. %cback%%cwipe%
echo %cnote%This game has not been copied from the network share yet.
echo.
echo %cpress%Would you like to copy %GameName% now?
echo %cchoice%
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto nasdecline
If errorlevel = 1 goto nas
goto nasdecline

:nasdecline
echo %cclear%
goto exit

:nas
echo %cclear%
set naspath=
set /p naspath=<%nasconf%
if not defined naspath goto nasmissing
if "%naspath:~-1%"==" " set naspath=%naspath:~0,-1%
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
IF NOT EXIST "%naspath%\eXo\eXoWin9x\%RYEAR%\%GameName%.zip" goto nasmissing
cls
echo.
echo Copying %GameName% from the network share...
echo.
IF NOT EXIST ".\eXoWin9x\%RYEAR%\" md ".\eXoWin9x\%RYEAR%"
copy /Y "%naspath%\eXo\eXoWin9x\%RYEAR%\%GameName%.zip" ".\eXoWin9x\%RYEAR%\%GameName%.zip"
if errorlevel 1 goto nasfailed
goto unzipgame

:nasfailed
if exist ".\eXoWin9x\%RYEAR%\%GameName%.zip" del ".\eXoWin9x\%RYEAR%\%GameName%.zip"
cls
echo.
echo %GameName% could not be copied from the network share.
echo.
pause
goto exit

:nasmissing
cls
echo.
echo %GameName% was not found on the network share:
echo %naspath%
echo.
pause
goto exit

:rmzip
cls
echo.
echo %cpress%Would you like to delete the game zip file?
echo.
echo %cnote%NOTE: If you choose yes, the game will be copied from the network share again
echo the next time you install it.
echo %cchoice%
.\util\choice /C:YN /N [Y]es or [N]o

If errorlevel = 2 goto rmzipN
If errorlevel = 1 goto rmzipY
goto rmzipN

:rmzipY
cmd /c del /F /Q ".\eXoWin9x\%RYEAR%\%GameName%.zip"

:rmzipN
echo %cclear%
goto end

:exit