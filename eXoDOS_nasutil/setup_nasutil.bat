@echo off
rem Run from eXo\util\eXoDOS_nasutil after Setup has finished.
rem Each project: name, games folder, most zips a Lite copy can have, settings file, installer, NAS installer
set configured=0
if exist "..\..\..\Setup eXoDOS.bat" call :configure eXoDOS eXoDOS 7000 nas.conf install.bat install.nas
if exist "..\..\..\Setup eXoDREAMM.bat" call :configure eXoDREAMM eXoDREAMM 30 nas_eXoDREAMM.conf install_drm.bat install_drm.nas
if %configured%==0 (
	cls
	echo.
	echo No Lite copy of a supported eXo project was found.
	pause
)
goto end

:configure
set gamecnt=0
for %%A in ("..\..\%~2\*.zip") do set /a gamecnt+=1
if %gamecnt% GTR %~3 (
	echo %~1 is not a Lite copy, so it was left unchanged.
	if exist "..\%~4" del "..\%~4"
	exit /B
)
set configured=1
cls
echo.
echo Would you like to install %~1 games from a network share?
echo.
echo Choosing Yes will copy each game from the full %~1 folder on your network
echo share the first time you install it.
echo.
echo Choosing No will leave %~1 unchanged.
echo.
..\choice /C:YN /N [Y]es or [N]o

if errorlevel 2 goto configureN
if errorlevel 1 goto configureY
goto configureN

:configureY
cls
set naspath=
set /P naspath=Enter the full path of the %~1 folder on the network share: 
if not defined naspath goto configureN
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
>"..\%~4" echo %naspath%
copy /Y "..\%~5" "..\%~n5.bak"
copy /Y "%~6" "..\%~5"
if /i "%~1"=="eXoDOS" (
	copy /Y ..\..\Update\update.bat ..\..\Update\update.bak
	copy /Y update.nas ..\..\Update\update.bat
)
copy /Y "..\..\..\Setup %~1.bat" "..\..\..\Setup %~1.bak"
copy /Y "Setup %~1.nas" "..\..\..\Setup %~1.bat"
exit /B

:configureN
cls
if exist "..\%~4" del "..\%~4"
exit /B

:end
