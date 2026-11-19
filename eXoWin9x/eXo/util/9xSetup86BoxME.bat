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
SET SDL_WINDOWS_DPI_SCALING=0
del .\emulators\86Box98\W98-C.vhd
.\emulators\86Box98\makevhd.exe -f .\emulators\86Box98\W98-C.vhd .\emulators\86Box98\parent\W98-P.vhd
xcopy "%conf%\play.cfg" .\emulators\86Box98\ /Y
start "" ".\emulators\86Box98\86box.exe" -c .\emulators\86Box98\play.cfg
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