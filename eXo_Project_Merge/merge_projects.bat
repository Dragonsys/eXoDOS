@echo off
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
set installer=""

:Win3x
set eXoWin3x=1
cls
rem set /p eXoWin3x="Enter path to your eXoWin3x source (leave blank to skip): "
FOR /f %%i IN ('OPENFOLDERBOX %~dp0 "Select your eXoWin3x source folder (cancel to skip)"') DO SET eXoWin3x=%%i
IF %eXoWin3x% EQU 1 GOTO DOS
IF %moveFiles%==1 (robocopy %eXoWin3x% %~dp0 /e /copyall /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy %eXoWin3x% %~dp0 /e /copyall /xf desktop.ini thumbs.db /r:3 /w:5)
set installer=Win3x
GOTO DOS

:DOS
set eXoDOS=1
cls
FOR /f %%i IN ('OPENFOLDERBOX %~dp0 "Select your eXoDOS source folder (cancel to skip)"') DO SET eXoDOS=%%i
IF %eXoDOS% EQU 1 GOTO DREAMM
IF %moveFiles%==1 (robocopy %eXoDOS% %~dp0 /e /copyall /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy %eXoDOS% %~dp0 /e /copyall /xf desktop.ini thumbs.db /r:3 /w:5)
set installer=DOS
GOTO DREAMM

:DREAMM
set eXoDREAMM=1
cls
FOR /f %%i IN ('OPENFOLDERBOX %~dp0 "Select your eXoDREAMM source folder (cancel to skip)"') DO SET eXoDREAMM=%%i
IF %eXoDREAMM% EQU 1 GOTO ScummVM
IF %moveFiles%==1 (robocopy %eXoDREAMM% %~dp0 /e /copyall /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy %eXoDREAMM% %~dp0 /e /copyall /xf desktop.ini thumbs.db /r:3 /w:5)
set installer=DREAMM
GOTO ScummVM

:ScummVM
set eXoScummVM=1
cls
FOR /f %%i IN ('OPENFOLDERBOX %~dp0 "Select your eXoScummVM source folder (cancel to skip)"') DO SET eXoScummVM=%%i
IF %eXoScummVM% EQU 1 GOTO Extras
IF %moveFiles%==1 (robocopy %eXoScummVM% %~dp0 /e /copyall /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy %eXoScummVM% %~dp0 /e /copyall /xf desktop.ini thumbs.db /r:3 /w:5)
set installer=ScummVM
GOTO Extras

:Extras
set eXoDOSCP=1
IF %eXoDOS% EQU 1 GOTO RunSetup
cls
FOR /f %%i IN ('OPENFOLDERBOX %~dp0 "Select your eXoDOS Content Pack source folder (cancel to skip)"') DO SET eXoDOSCP=%%i
IF %eXoDOSCP% EQU 1 GOTO RunSetup
IF %moveFiles%==1 (robocopy %eXoDOSCP% %~dp0 /e /copyall /move /xf desktop.ini thumbs.db /r:3 /w:5) else (robocopy %eXoDOSCP% %~dp0 /e /copyall /xf desktop.ini thumbs.db /r:3 /w:5)
GOTO RunSetup

:RunSetup
rem cls
echo Current installer is "Setup eXo%installer%.bat"
CHOICE /C YN /M "Would you like to run the installer now? [Y]es or [N]o"
IF %ERRORLEVEL% EQU 1 (START "%~dp0\Setup eXo%installer%.bat")
GOTO end

:end
