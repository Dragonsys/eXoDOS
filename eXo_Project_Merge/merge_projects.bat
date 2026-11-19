@echo off
cd /d "%~dp0"
set "dest=%~dp0."
cls
echo Make sure you are running this script from the directory you want all
echo the Merged eXo Projects to be installed in.
echo.
echo eXoAppleIIGS is not currently supported. It will be added once the
echo project is updated to the newer eXo v6 framework.
pause
cls
CHOICE /C MC /M "Select if you want to [M]ove or [C]opy the source files"
set moveFiles=%ERRORLEVEL%
set installer=

:Win3x
set "eXoWin3x=1"
cls
rem set /p eXoWin3x="Enter path to your eXoWin3x source (leave blank to skip): "
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoWin3x source folder (cancel to skip)"') DO SET "eXoWin3x=%%i"
IF "%eXoWin3x%"=="1" GOTO DOS
call :CopyProject "%eXoWin3x%"
set installer=Win3x
GOTO DOS

:DOS
set "eXoDOS=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoDOS source folder (cancel to skip)"') DO SET "eXoDOS=%%i"
IF "%eXoDOS%"=="1" GOTO DREAMM
call :CopyProject "%eXoDOS%"
set installer=DOS
GOTO DREAMM

:DREAMM
set "eXoDREAMM=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoDREAMM source folder (cancel to skip)"') DO SET "eXoDREAMM=%%i"
IF "%eXoDREAMM%"=="1" GOTO ScummVM
call :CopyProject "%eXoDREAMM%"
set installer=DREAMM
GOTO ScummVM

:ScummVM
set "eXoScummVM=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoScummVM source folder (cancel to skip)"') DO SET "eXoScummVM=%%i"
IF "%eXoScummVM%"=="1" GOTO DemoScene
call :CopyProject "%eXoScummVM%"
set installer=ScummVM
GOTO DemoScene

:DemoScene
set "eXoDemoScene=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoDemoScene source folder (cancel to skip)"') DO SET "eXoDemoScene=%%i"
IF "%eXoDemoScene%"=="1" GOTO IF
call :CopyProject "%eXoDemoScene%"
set installer=DemoScene
GOTO IF

:IF
set "eXoIF=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoIF source folder (cancel to skip)"') DO SET "eXoIF=%%i"
IF "%eXoIF%"=="1" GOTO Win9x
call :CopyProject "%eXoIF%"
set installer=IF
GOTO Win9x

:Win9x
set "eXoWin9x=1"
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoWin9x source folder (cancel to skip)"') DO SET "eXoWin9x=%%i"
IF "%eXoWin9x%"=="1" GOTO Extras
call :CopyProject "%eXoWin9x%"
set installer=Win9x
GOTO Extras

:Extras
set "eXoDOSCP=1"
IF "%eXoDOS%"=="1" GOTO RunSetup
cls
FOR /f "delims=" %%i IN ('OPENFOLDERBOX "%dest%" "Select your eXoDOS Content Pack source folder (cancel to skip)"') DO SET "eXoDOSCP=%%i"
IF "%eXoDOSCP%"=="1" GOTO RunSetup
call :CopyProject "%eXoDOSCP%"
GOTO RunSetup

:RunSetup
IF NOT DEFINED installer GOTO end
IF NOT EXIST "%dest%\Setup eXo%installer%.bat" (
	echo "Setup eXo%installer%.bat" was not found. Check the copy results above.
	pause
	GOTO end
)
echo Current installer is "Setup eXo%installer%.bat"
CHOICE /C YN /M "Would you like to run the installer now? [Y]es or [N]o"
IF %ERRORLEVEL% EQU 1 START "" /D "%dest%" "Setup eXo%installer%.bat"
GOTO end

:CopyProject
IF %moveFiles%==1 (robocopy "%~1" "%dest%" /e /dcopy:T /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy "%~1" "%dest%" /e /dcopy:T /xf desktop.ini thumbs.db /r:3 /w:5)
exit /B

:end
