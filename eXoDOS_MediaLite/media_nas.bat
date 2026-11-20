@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Opens an eXoDOS Media Pack Lite item. The first time, the item is copied from the full
rem Media Pack on the network share. LaunchBox passes:
rem   "zip name" "item file or folder" "file that shows it is here" "program to open" [its arguments]
for %%R in ("%~dp0..\..") do set "root=%%~fR"
set "conf=%~dp0nas_media.conf"
set "zip=%~1"
set "unit=%~2"
set "check=%~3"
set "app=%~4"
if not defined app goto usage
set args=
:collect
if "%~5"=="" goto collected
set args=%args% %5
shift /5
goto collect
:collected
if exist "%root%\%check%" goto run

rem Find the share
set nas=
if exist "%conf%" set /P nas=<"%conf%"
if not defined nas goto ask
if "%nas:~-1%"==" " set "nas=%nas:~0,-1%"
if not defined nas goto ask
if "%nas:~-1%"=="\" set "nas=%nas:~0,-1%"
if not defined nas goto ask
if exist "%nas%\Content\%zip%" goto fetch
echo.
echo "%zip%" was not found in "%nas%\Content".
echo The network share may be offline, or the Media Pack may have moved.

:ask
echo.
echo This item is part of the eXoDOS Media Pack Lite. It is copied from the full
echo Media Pack on your network share the first time you open it.
echo.
echo Enter the full path of the eXoDOS Media Pack folder (the one that holds Content),
echo or leave it blank to cancel.
set nas=
set /P "nas=Media Pack folder: "
if not defined nas goto cancel
set "nas=%nas:"=%"
if not defined nas goto cancel
if "%nas:~-1%"=="\" set "nas=%nas:~0,-1%"
if not defined nas goto cancel
if not exist "%nas%\Content\%zip%" goto notfound
>"%conf%" echo %nas%

:fetch
set "pat=%unit:\=/%"
rem [ is a wildcard for unzip, so match it literally
set "pat=%pat:[=[[]%"
if /i "%unit%"=="%check%" (set "what=%pat%") else (set "what=%pat%/*")
set "work=%~dp0mediatemp"
if exist "%work%\" rd /S /Q "%work%"
md "%work%"
echo.
echo Copying from the network share. This only happens the first time.
echo   "%unit%"
echo Please wait...
"%~dp0unzip.exe" -o -qq "%nas%\Content\%zip%" "%what%" -d "%work%"
if errorlevel 2 goto failed
if not exist "%work%\%check%" goto failed
if /i "%unit%"=="%check%" goto movefile
robocopy "%work%\%unit%" "%root%\%unit%" /E /MOVE /R:2 /W:2 /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto failed
goto fetched
:movefile
for %%F in ("%root%\%unit%") do if not exist "%%~dpF" md "%%~dpF"
move /Y "%work%\%unit%" "%root%\%unit%" >nul
if errorlevel 1 goto failed
:fetched
rd /S /Q "%work%"
if not exist "%root%\%check%" goto failed

:run
for %%A in ("%root%\%app%") do (
	set "appdir=%%~dpA"
	set "appname=%%~nxA"
	set "appext=%%~xA"
)
cd /d "%appdir%"
if /i "%appext%"==".bat" goto runbat
rem For testing: show what would be opened instead of opening it
if defined MEDIA_NAS_NOOPEN (
	echo OPEN "%cd%\%appname%"%args%
	goto end
)
if /i "%appext%"==".exe" goto runexe
if /i "%appext%"==".com" goto runexe
start "" "%appdir%%appname%"
goto end
:runbat
call "%appdir%%appname%" %args%
goto end
:runexe
start "" "%appdir%%appname%" %args%
goto end

:notfound
echo "%zip%" was not found in "%nas%\Content".
goto cancel

:failed
if exist "%work%\" rd /S /Q "%work%"
echo.
echo The item could not be copied from the network share. Check that the share is
echo online and there is enough free space, then try again.
pause
exit /B 1

:cancel
echo Nothing was copied.
pause
exit /B 1

:usage
echo This is started by LaunchBox for eXoDOS Media Pack Lite items.
pause
exit /B 1

:end
endlocal
