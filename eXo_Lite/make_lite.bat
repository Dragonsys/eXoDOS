@echo off
setlocal
rem Creates a Lite copy of an eXo project: everything except the game zips, plus the NAS scripts from this repo.
set "project=%~1"
set "src=%~2"
set "dest=%~3"
if not defined dest goto usage

set games=
if /i "%project%"=="eXoDREAMM" (
	set project=eXoDREAMM
	set games=eXoDREAMM
)
if not defined games (
	echo %project% is not supported yet.
	goto usage
)

if "%src:~-1%"=="\" set "src=%src:~0,-1%"
if "%dest:~-1%"=="\" set "dest=%dest:~0,-1%"
if /i "%src%"=="%dest%" (
	echo The source and destination must be different folders.
	exit /B 1
)
if not exist "%src%\Setup %project%.bat" (
	echo "%src%" does not look like a %project% folder.
	exit /B 1
)
if not exist "%src%\eXo\%games%\" (
	echo The games folder "%src%\eXo\%games%" was not found.
	exit /B 1
)
if not exist "%~dp0..\%project%\" (
	echo The NAS scripts for %project% were not found next to this script.
	exit /B 1
)

echo Copying %project% without its game zips...
robocopy "%src%" "%dest%" /E /DCOPY:T /XD "%src%\eXo\%games%" /XF desktop.ini thumbs.db /R:3 /W:5 /NP
if errorlevel 8 goto failed
if not exist "%dest%\eXo\%games%\" md "%dest%\eXo\%games%"

echo Adding the NAS scripts...
robocopy "%~dp0..\%project%" "%dest%" /E /XF nas.patch /R:3 /W:5 /NP
if errorlevel 8 goto failed

echo.
echo The Lite copy is ready: %dest%
echo Run "Setup %project%.bat" there, answer Yes to the network share question, and enter:
echo %src%
exit /B 0

:failed
echo.
echo The copy did not finish. Check the messages above.
exit /B 1

:usage
echo Usage: make_lite.bat PROJECT "FULL PROJECT FOLDER" "NEW LITE FOLDER"
echo Supported projects: eXoDREAMM
exit /B 1
