echo off
SET SDL_WINDOWS_DPI_SCALING=0
.\util\setconsole.exe /reset
rem echo %GameDir%
rem echo %GameLaunch%
rem echo %GameName%
rem echo %YearDir%
set conf=.\eXoWin9x\!win9x\%YearDir%\%GameDir%
rem echo %conf%

IF NOT EXIST ".\eXoWin9x\%yeardir%\%GameDir%\" goto none

:settings
IF EXIST .\util\AYES.SEL (
 IF EXIST .\util\ANO.SEL (
.\util\setconsole.exe /reset
del .\util\ANO.SEL
del .\util\AYES.SEL
echo.%cback%%cwipe%
echo %cnote%An error has occured and your setup is trying to turn Aspect Ratio On and Off at the same time.
echo The setting will be cleared, and you will be asked to reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat A
.\util\setconsole.exe /minimize
)
)

IF NOT EXIST .\util\AYES.SEL (
 IF NOT EXIST .\util\ANO.SEL (
.\util\setconsole.exe /reset
echo.%cback%%cwipe%
echo %cnote%An error has occured and your Aspect Ratio setting does not exist.
echo Please reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat A
.\util\setconsole.exe /minimize
)
)

IF EXIST .\util\FULL.SEL (
 IF EXIST .\util\WIN.SEL (
.\util\setconsole.exe /reset
del .\util\FULL.SEL
del .\util\WIN.SEL
echo.%cback%%cwipe%
echo %cnote%An error has occured and your setup is trying to turn Fullscreen On and Off at the same time.
echo The setting will be cleared, and you will be asked to reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat S
.\util\setconsole.exe /minimize
)
)

IF NOT EXIST .\util\FULL.SEL (
 IF NOT EXIST .\util\WIN.SEL (
.\util\setconsole.exe /reset
echo.%cback%%cwipe%
echo %cnote%An error has occured and your Fullscreen\Window setting does not exist.
echo Please reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat S
.\util\setconsole.exe /minimize
)
)

set /a rescount=0
IF exist .\util\SML.SEL set /a rescount=rescount+1
IF exist .\util\MED.SEL set /a rescount=rescount+1
IF exist .\util\LRG.SEL set /a rescount=rescount+1
IF %rescount% GTR 1 (
.\util\setconsole.exe /reset
IF exist .\util\SML.SEL del .\util\SML.SEL
IF exist .\util\MED.SEL del .\util\MED.SEL
IF exist .\util\LRG.SEL del .\util\LRG.SEL
echo.%cback%%cwipe%
echo %cnote%An error has occured and your setup is confused as to what resolution you would like.
echo The setting will be cleared, and you will be asked to reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat R
.\util\setconsole.exe /minimize
)

IF NOT EXIST .\util\SML.SEL (
 IF NOT EXIST .\util\MED.SEL (
  IF NOT EXIST .\util\LRG.SEL (
.\util\setconsole.exe /reset
echo.%cback%%cwipe%
echo %cnote%An error has occured and your Resolution setting does not exist.
echo Please reselect it.
echo.
pause
call .\emulators\dosbox\config9x.bat R
.\util\setconsole.exe /minimize
)
)
)

IF EXIST .\util\AYES.SEL .\util\ssr 0 aspect=false aspect=true .\emulators\dosbox\options9x.conf
IF EXIST .\util\ANO.SEL .\util\ssr 0 aspect=true aspect=false .\emulators\dosbox\options9x.conf
IF EXIST .\util\FULL.SEL .\util\ssr 0 fullscreen=false fullscreen=true .\emulators\dosbox\options9x.conf
IF EXIST .\util\WIN.SEL .\util\ssr 0 fullscreen=true fullscreen=false .\emulators\dosbox\options9x.conf
IF EXIST .\util\SML.SEL .\util\ssr 0 windowresolution=1280x960 windowresolution=640x480 .\emulators\dosbox\options9x.conf
IF EXIST .\util\SML.SEL .\util\ssr 0 windowresolution=2560x1920 windowresolution=640x480 .\emulators\dosbox\options9x.conf
IF EXIST .\util\MED.SEL .\util\ssr 0 windowresolution=640x480 windowresolution=1280x960 .\emulators\dosbox\options9x.conf
IF EXIST .\util\MED.SEL .\util\ssr 0 windowresolution=2560x1920 windowresolution=1280x960 .\emulators\dosbox\options9x.conf
IF EXIST .\util\LRG.SEL .\util\ssr 0 windowresolution=640x480 windowresolution=2560x1920 .\emulators\dosbox\options9x.conf
IF EXIST .\util\LRG.SEL .\util\ssr 0 windowresolution=1280x960 windowresolution=2560x1920 .\emulators\dosbox\options9x.conf

:launch
SET SDL_WINDOWS_DPI_SCALING=0
start "" ".\emulators\dosbox\x98\dosbox-x.exe" -conf "%conf%\play.conf" -conf ".\emulators\dosbox\options9x.conf" -nomenu -noconsole
rem "" ".\emulators\dosbox\x98\dosbox-x.exe" -conf "%conf%\play.conf" -conf ".\emulators\dosbox\options9x.conf"
goto end

:none
.\util\setconsole.exe /reset
cls
echo.
echo.%cback%%cwipe%
echo %cpress%Game has not been installed
echo.
echo.
echo %cnote%Would you like to install the game?
echo.%cchoice%
.\util\choice

if errorlevel = 2 goto no
if errorlevel = 1 goto yes

:yes
echo on
cd %VAR%\%gamedir%
call install.bat
rem cd ..
.\util\setconsole.exe /minimize
cls
IF NOT EXIST ".\eXoWin9x\%yeardir%\%GameDir%\" goto end
goto settings

:no
goto end

:end