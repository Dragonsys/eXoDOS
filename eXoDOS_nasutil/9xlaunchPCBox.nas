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

:launch
del .\emulators\PCbox\W98-C.vhd
.\emulators\PCbox\makevhd.exe -f .\emulators\PCbox\W98-C.vhd .\emulators\PCbox\parent\W98-P.vhd
xcopy "%conf%\play.cfg" .\emulators\PCbox\ /Y
start "" ".\emulators\PCbox\PCbox.exe" -c .\emulators\PCbox\play.cfg
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
goto launch

:no
goto end

:end