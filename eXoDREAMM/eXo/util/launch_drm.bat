@echo off
call .\util\theme.bat
IF EXIST .\util\FULL.SEL SET screen=window/fullscreen=true
IF EXIST .\util\WIN.SEL SET screen=window/fullscreen=false
IF EXIST .\util\AYES.SEL SET aspect=window/fixaspect=true
IF EXIST .\util\ANO.SEL SET aspect=window/fixaspect=false
IF NOT EXIST ".\eXoDREAMM\%GameDir%\" goto none

:launch
for /F "delims=" %%a in ('findstr /b /C:"%GameName%" .\util\dreamm.txt') do set drmindex=%%a
set drm1=%drmindex:*:=%
set drm=%drm1:*:=%
set drmini=\%drm:~0,-11%
if [%drmini%]==[] set drmini=\

:main
cls
.\util\setconsole.exe /reset
set cnt=0
SETLOCAL ENABLEDELAYEDEXPANSION
cd .\eXoDREAMM\%GameDir%\
cls
echo.%cback%%cwipe%
echo %ctitle%!indexname!
echo %ctitles%____________________________________________________________
echo.
echo %cpress%Press %cpick%ALT-U %cpress%or %cpick%F12 %cpress%in game to change Sound ^& Video settings
echo or type %cpick%K%cpress% and press %cpick%ENTER%cpress% to view the in-game keyboard shortcuts
echo.
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
set /A cnt=!cnt!+1
set game9!cnt!=%%a
set name=%%a
echo %cnote%Type %cpress%!cnt! %cnote%for !name!
)
if !cnt!==1 (
cls
set selection=!game91!
goto game_launch
)
echo.
echo %cchoice%
set /p pick="Type the number and press Enter: "

if !pick!==k goto keys
if !pick!==K goto keys

for /L %%a IN (1,1,!cnt!) do (
if %%a==!pick! set selection=!game9%%a!
)

SET "var4="&for /f "delims=0123456789" %%i in ("!pick!") do set var4=%%i
if defined var4 goto sel_error1
if !pick! gtr !cnt! goto sel_error1
if [!pick!]==[] goto sel_error1
set test=Other Languages
if !selection!==!test! goto langselect
goto game_launch

:sel_error1
echo %cback%
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :main

:game_launch
cd !var!
cd ..\..\..
.\util\setconsole.exe /minimize
".\Emulators\DREAMM\!drm!" -option !aspect! -option !screen! -run ".\eXoDREAMM\%GameDir%\!selection!\"
goto end

:langselect
echo.%cback%%cwipe%
rem SETLOCAL DISABLEDELAYEDEXPANSION
set cnt=0
SETLOCAL ENABLEDELAYEDEXPANSION
cd !selection!
cls
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
set /A cnt=!cnt!+1
set select!cnt!=%%a
set name=%%a
echo %cnote%Type %cpress%!cnt! %cnote%for !name!
)
if !cnt!==1 (
cls
echo.
echo %cpress%This game only has a !select1! version. Press a key to launch it.
echo %cchoice%
pause
set language=!select1!
goto game_sel
)
echo %cchoice%
set /p lang="Type the number and press Enter: "

for /L %%a IN (1,1,!cnt!) do (
if %%a==!lang! set language=!select%%a!
)

SET "var4="&for /f "delims=0123456789" %%i in ("!lang!") do set var4=%%i
if defined var4 goto sel_error
if !lang! gtr !cnt! goto sel_error
if [!lang!]==[] goto sel_error
goto :game_sel

:sel_error
echo.
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :langselect

:sel_error2
echo.
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :game_sel

:game_sel
cd %language%
set cnt=0
cls
echo.
echo %cpress%Selected Language: %cpick%!language!
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
set /A cnt=!cnt!+1
set game!cnt!=%%a
set name=%%a
echo Type !cnt! for !name! version
)
if !cnt!==1 (
cls
set launch=!game1!
goto game_launch2
)
echo %cchoice%
set /p gametype="Type the number and press Enter: "

for /L %%a IN (1,1,!cnt!) do (
if %%a==!gametype! set launch=!game%%a!
)
SET "var5="&for /f "delims=0123456789" %%i in ("!gametype!") do set var5=%%i
if defined var5 goto sel_error2
if !gametype! gtr !cnt! goto sel_error2
if [!gametype!]==[] goto sel_error2

:game_launch2
SETLOCAL DISABLEDELAYEDEXPANSION
cd %var%
cd ..\..\..

.\util\setconsole.exe /minimize
".\Emulators\DREAMM\%drm%" -option %aspect% -option %screen% -run ".\eXoDREAMM\%GameDir%\%selection%\%language%\%launch%\"
goto end

:keys
cls
echo.
echo %ctitle%+---------------+--------------------------------+---------------------------------------------+
echo %ctitle%^| %cpress%ALT U or F12  %ctitles%^| %cpress%In-Game Menu                   %ctitles%^| %cpress%Notes                                       %ctitle%^|
echo %ctitle%+%ctitles%---------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%ALT ENTER     %ctitles%^| %cnote%Toggle Fullscreen ^\ Window     %ctitles%^|                                             %ctitle%^|
echo %ctitle%^| %cpress%ALT +         %ctitles%^| %cnote%Increase Window Size           %ctitles%^| %cnote%Also increases play area size in fullscreen %ctitle%^|
echo %ctitle%^| %cpress%ALT -         %ctitles%^| %cnote%Decrease Window Size           %ctitles%^| %cnote%Also decreases play area size in fullscreen %ctitle%^|
echo %ctitle%+%ctitles%---------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%ALT 1         %ctitles%^| %cnote%Insert Disk 1                  %ctitles%^| %cnote%Only used for games with multiple disks     %ctitle%^|
echo %ctitle%^| %cpress%ALT 2         %ctitles%^| %cnote%Insert Disk 2                  %ctitles%^|                                             %ctitle%^|
echo %ctitle%+%ctitles%---------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%ALT S         %ctitles%^| %cnote%Toggle Smooth Graphics         %ctitles%^| %cnote%Enables EPX Smoothing                       %ctitle%^|
echo %ctitle%^| %cpress%ALT A         %ctitles%^| %cnote%Toggle Aspect Ratio Correction %ctitles%^| %cnote%Switches between 4:3 or RAW output          %ctitle%^|
echo %ctitle%^| %cpress%ALT I         %ctitles%^| %cnote%Toggle Integer Video Scaling   %ctitles%^| %cnote%Similar to "Pixel Perfect"                  %ctitle%^|
echo %ctitle%^| %cpress%ALT BACKSPACE %ctitles%^| %cnote%Take Screenshot                %ctitles%^| %cnote%Found in emulators folder                   %ctitle%^|
echo %ctitle%^| %cpress%ALT O         %ctitles%^| %cnote%Shortcut to Options Menu       %ctitles%^|                                             %ctitle%^|
echo %ctitle%^| %cpress%ALT V         %ctitles%^| %cnote%Shortcut to Volume Menu        %ctitles%^|                                             %ctitle%^|
echo %ctitle%^| %cpress%ALT X         %ctitles%^| %cnote%Exit Game                      %ctitles%^|                                             %ctitle%^|
echo %ctitle%+---------------+--------------------------------+---------------------------------------------+
echo %cchoice%
pause
goto main

:none
.\util\setconsole.exe /reset
cls
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
cd %VAR%
call install.bat
cd ..
.\util\setconsole.exe /minimize
cls
IF NOT EXIST ".\eXoDREAMM\%GameDir%\" goto end
goto launch
goto end
:no
goto end

:end
