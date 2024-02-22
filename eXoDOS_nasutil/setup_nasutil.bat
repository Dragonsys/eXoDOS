set gamecnt=0
@for %%A in (..\..\eXo\eXoDOS\^!*.zip) do set /a gamecnt+=1
set exolite=false
if %gamecnt% LEQ 5000 set exolite=true
if %exolite%==true (
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
	..\choice /C:YN /N [Y]es or [N]o

	If errorlevel = 2 goto nasN
	If errorlevel = 1 goto nasY
)
goto liteN

:nasY
cls
set /P naspath=Enter Full Network Share Path: 
echo %naspath% > ".\util\nas.conf"
ren ..\install install.bak
copy install.nas ..\install.bat
ren "..\..\..\Setup eXoDOS.bat" "Setup eXoDOS.bak"
copy "Setup eXoDOS.nas" "..\..\..\Setup eXoDOS.bat"
goto end

:nasN
cls
if exist ".\util\nas.conf" del ".\util\nas.conf"
goto end

:liteN
cls
echo You do not appear to have the Lite version of eXoDOS installed.
pause
if exist ".\util\nas.conf" del ".\util\nas.conf"
goto end

:end