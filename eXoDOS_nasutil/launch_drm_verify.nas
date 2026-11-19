@echo off
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
echo.
echo !indexname!
echo ____________________________________________________________
echo.
echo Press ALT-U or F12 in game to change Sound ^& Video settings
echo or type K and press ENTER to view the in-game keyboard shortcuts
echo.
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
set /A cnt=!cnt!+1
set game9!cnt!=%%a
set name=%%a
echo Type !cnt! for !name!
)
if !cnt!==1 (
cls
set selection=!game91!
goto game_launch
)
echo.
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
echo.
echo That is not a valid selection, please try again.
echo.
pause
goto :main

:game_launch
cd !var!
cd ..\..\..
rem .\util\setconsole.exe /minimize
".\Emulators\DREAMM\!drm!" -verify ".\eXoDREAMM\%GameDir%\!selection!\"
pause
rem ".\Emulators\DREAMM\!drm!" -option !aspect! -option !screen! ".\eXoDREAMM\%GameDir%\!selection!\"
goto main

:langselect
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
echo Type !cnt! for !name!
)
if !cnt!==1 (
cls
echo.
echo This game only has a !select1! version. Press a key to launch it.
echo.
pause
set language=!select1!
goto game_sel
)
echo.
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
echo That is not a valid selection, please try again.
echo.
pause
goto :langselect

:sel_error2
echo.
echo That is not a valid selection, please try again.
echo.
pause
goto :game_sel

:game_sel
cd %language%
set cnt=0
cls
echo.
echo Selected Language: !language!
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
echo.
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

rem.\util\setconsole.exe /minimize
".\Emulators\DREAMM\%drm%" -verify ".\eXoDREAMM\%GameDir%\%selection%\%language%\%launch%\"
pause
goto main

:keys
cls
echo.
echo +---------------+--------------------------------+---------------------------------------------+
echo ^| ALT U or F12  ^| In-Game Menu                   ^| Notes                                       ^|
echo +---------------^|--------------------------------^|---------------------------------------------^|
echo ^| ALT ENTER     ^| Toggle Fullscreen ^\ Window     ^|                                             ^|
echo ^| ALT +         ^| Increase Window Size           ^| Also increases play area size in fullscreen ^|
echo ^| ALT -         ^| Decrease Window Size           ^| Also decreases play area size in fullscreen ^|
echo +---------------^|--------------------------------^|---------------------------------------------^|
echo ^| ALT 1         ^| Insert Disk 1                  ^| Only used for games with multiple disks     ^|
echo ^| ALT 2         ^| Insert Disk 2                  ^|                                             ^|
echo +---------------^|--------------------------------^|---------------------------------------------^|
echo ^| ALT S         ^| Toggle Smooth Graphics         ^| Enables EPX Smoothing                       ^|
echo ^| ALT A         ^| Toggle Aspect Ratio Correction ^| Switches between 4:3 or RAW output          ^|
echo ^| ALT I         ^| Toggle Integer Video Scaling   ^| Similar to "Pixel Perfect"                  ^|
echo ^| ALT BACKSPACE ^| Take Screenshot                ^| Found in emulators folder                   ^|
echo +---------------^|--------------------------------^|---------------------------------------------^|
echo ^| ALT O         ^| Shortcut to Options Menu       ^|                                             ^|
echo ^| ALT V         ^| Shortcut to Volume Menu        ^|                                             ^|
echo ^| ALT X         ^| Exit Game                      ^|                                             ^|
echo +---------------+--------------------------------+---------------------------------------------+
echo.
pause
goto main

:none
.\util\setconsole.exe /reset
cls
echo.
echo Game has not been installed 
echo.
echo.
echo Would you like to install the game?
echo.
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
