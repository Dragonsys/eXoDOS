rem Run from eXo\util\eXoDOS_nasutil after eXoDOS 6.04 Setup has finished
set gamecnt=0
@for %%A in (..\..\eXoDOS\*.zip) do set /a gamecnt+=1
set exolite=false
if %gamecnt% LEQ 7000 set exolite=true
if %exolite%==true (
	cls
	echo.
	echo Would you like to enable downloading from a network share instead of torrent?
	echo.
	echo Choosing Yes will attempt to set a network share location for the full eXoDOS
	echo location, to use for downloading games from instead of using the torrent, when
	echo eXoDOS Lite is installed and the game has not yet been downloaded.
	echo.
	echo Choosing No will leave the default of using torrent downloads.
	echo.
	..\choice /C:YN /N [Y]es or [N]o

	If errorlevel = 2 goto nasN
	If errorlevel = 1 goto nasY
)
goto liteN

:nasY
cls
set /P naspath=Enter Full Network Share Path:
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
>"..\nas.conf" echo %naspath%
copy /Y ..\install.bat ..\install.bak
copy /Y install.nas ..\install.bat
copy /Y ..\..\Update\update.bat ..\..\Update\update.bak
copy /Y update.nas ..\..\Update\update.bat
copy /Y "..\..\..\Setup eXoDOS.bat" "..\..\..\Setup eXoDOS.bak"
copy /Y "Setup eXoDOS.nas" "..\..\..\Setup eXoDOS.bat"
goto end

:nasN
cls
if exist "..\nas.conf" del "..\nas.conf"
goto end

:liteN
cls
echo You do not appear to have the Lite version of eXoDOS installed.
pause
if exist "..\nas.conf" del "..\nas.conf"
goto end

:end
