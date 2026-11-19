@echo off
call .\util\theme.bat
IF EXIST .\util\FULL.SEL SET screen=-f
IF EXIST .\util\WIN.SEL SET screen=-F
IF EXIST .\util\AYES.SEL SET screen=%screen% --aspect-ratio
IF EXIST .\util\SML.SEL .\util\unzip.exe -o -q .\Emulators\scmvm\scmvm_sml.zip -d .\Emulators\scmvm\
IF EXIST .\util\MED.SEL .\util\unzip.exe -o -q .\Emulators\scmvm\scmvm_med.zip -d .\Emulators\scmvm\
IF EXIST .\util\LRG.SEL .\util\unzip.exe -o -q .\Emulators\scmvm\scmvm_lrg.zip -d .\Emulators\scmvm\
set sound=--opl-driver=nuked --output-rate=44100
set platform=
set brexception=Blade Runner with Restored Content (CD Windows)
IF NOT EXIST ".\eXoScummVM\%GameDir%\" goto none

:launch
for /F "delims=" %%a in ('findstr /b /C:"%GameName%" .\util\scummvm.txt') do set svmindex=%%a
set svm1=%svmindex:*:=%
for /f "tokens=1,2,3 delims=;" %%a in ("%svmindex%") do set gamename=%%a&set gameid=%%b&set svm=%%c
set svmini=\%svm:~0,-11%
if [%svmini%]==[] set svmini=\

rem echo svmindex:  %svmindex%
rem echo svm1:      %svm1%
rem echo gameid:    %gameid%
rem echo svm:       %svm%
rem echo svmini:    %svmini%

:main
cls
.\util\setconsole.exe /reset
set cnt=0
SETLOCAL ENABLEDELAYEDEXPANSION
cd .\eXoScummVM\!GameDir!\
cls
echo.%cback%%cwipe%
echo %ctitle%!gamename!
echo %ctitles%____________________________________________________________
echo.
echo %cpress%Press %cpick%Ctrl+F5 %cpress%in game to open the global main menu
echo or type %cpick%K%cpress% below and press ENTER to view the in-game keyboard shortcuts
echo.
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
if not %%a==note.txt set /A cnt=!cnt!+1
if not %%a==note.txt set game9!cnt!=%%a
set name=%%a
if not !name!==note.txt echo %cpress%Type %cpick%!cnt!%cpress% for !name!
)
if !cnt!==1 (
cls
if exist note.txt echo %cnote%
if exist note.txt type note.txt
if exist note.txt echo.
if exist note.txt echo.
if exist note.txt pause
set selection=!game91!
goto game_launch_pre
)
if exist note.txt echo %cnote%
if exist note.txt type note.txt
if exist note.txt echo.
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

cd ..\..
for /F "delims=" %%a in ('findstr /b /C:"!selection!" .\util\scummvm.txt') do set svmindex=%%a
set svm1=%svmindex:*:=%
for /f "tokens=1,2,3 delims=;" %%a in ("%svmindex%") do set gamename=%%a&set gameid=%%b&set svm=%%c
set svmini=\%svm:~0,-11%
if [%svmini%]==[] set svmini=\

rem echo selection: %selection%
rem echo svmindex:  %svmindex%
rem echo svm1:      %svm1%
rem echo gameid:    %gameid%
rem echo svm:       %svm%
rem echo svmini:    %svmini%
rem pause

if !selection!==!brexception! set selection=Blade Runner (CD Windows)
cd eXoScummVM\!GameDir!

if exist ".\!selection!\menu.txt" goto sub_menu
if exist ".\!selection!\platform.txt" (
cd !selection!
for /f "tokens=1 delims=:" %%a in (platform.txt) do set plat=%%a
cd ..
set platform=--platform=!plat!
)

:game_launch_pre
if exist ".\!selection!\subtitle.txt" goto sub_selection
goto game_launch_pre_cont

:sub_selection
cls
echo %cback%%cwipe%
echo %ctitle%!gamename!
echo %ctitles%____________________________________________________________
echo.
echo %cpress%This game has an option to enable subtitles. 
echo %cchoice%
..\..\util\choice /C:YN /N Would you like to enabled subtiles? [%ctitle%Y%cchoice%]es or [%ctitle%N%cchoice%]o

if errorlevel = 2 goto sub_no
if errorlevel = 1 goto sub_yes

:sub_yes
cd !selection!
for /f "tokens=1 delims=:" %%a in (subtitle.txt) do set subtitle=%%a
cd ..
goto sub_exit

:sub_no
goto sub_exit

:sub_exit

:game_launch_pre_cont
if exist ".\!selection!\sound.txt" goto sound_menu
if exist ".\!selection!\audio.txt" goto audio_set
if exist ".\!selection!\video.txt" goto video_set
goto game_launch

:sel_error1
echo %cback%
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :main

:sel_errorsub
echo %cback%
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :sub_menu

:sub_menu
cd !selection!
set cnt=0
cls
echo %cback%%cwipe%
echo %ctitle%!selection!
echo %ctitles%____________________________________________________________
echo.
echo %cpress%Press %cpick%Ctrl+F5%cpress% in game to open the global main menu
echo or type %cpick%K%cpress% below and press ENTER to view the in-game keyboard shortcuts
echo.
echo.
for /F "delims=" %%a in ('dir .\ /A /B') DO (
if not %%a==menu.txt (if not %%a==note.txt set /A cnt=!cnt!+1
)
if not %%a==menu.txt (if not %%a==note.txt set game9!cnt!=%%a
)
set name=%%a
set show=true
if !name!==menu.txt set show=false
if !name!==note.txt set show=false
if !show!==true echo %cpress%Type %cpick%!cnt!%cpress% for !name!
)


if !cnt!==1 (
cls
set selection2=!game91!
goto game_launch
)
if exist note.txt echo %cnote%
if exist note.txt type note.txt
if exist note.txt echo.
echo %cchoice%
set /p pick="Type the number and press Enter: "

if !pick!==k goto keys
if !pick!==K goto keys

for /L %%a IN (1,1,!cnt!) do (
if %%a==!pick! set selection2=!game9%%a!
)

SET "var4="&for /f "delims=0123456789" %%i in ("!pick!") do set var4=%%i
if defined var4 goto sel_errorsub
if !pick! gtr !cnt! goto sel_errorsub
if [!pick!]==[] goto sel_errorsub
set test=Other Languages
if !selection2!==!test! goto langselect
set selection=!selection!\!selection2!

cd ..\..\..
for /F "delims=" %%a in ('findstr /b /C:"%selection2%" .\util\scummvm.txt') do set svmindex=%%a
set svm1=%svmindex:*:=%
for /f "tokens=1,2,3 delims=;" %%a in ("%svmindex%") do set gamename=%%a&set gameid=%%b&set svm=%%c
cd eXoScummVM\%gamedir%\%selection%
cd..

rem echo selection2: %selection2%
rem echo svmindex:  %svmindex%
rem echo svm1:      %svm1%
rem echo gameid:    %gameid%
rem echo svm:       %svm%
rem echo svmini:    %svmini%
rem pause

if exist ".\!selection2!\menu.txt" goto sub_menu
if exist ".\!selection2!\sound.txt" goto sound_menu
if exist ".\!selection2!\video.txt" goto video_set
if exist ".\!selection2!\audio.txt" (
cd !selection2!
for /f "tokens=1 delims=:" %%a in (!s!audio.txt) do set audio1=%%a
cd ..
cd ..
set sound=!sound! !audio1!
)
goto game_launch

:sound_menu
cd !selection!
if exist menu.txt cd !selection2!
for /f "tokens=1,2,3,4,5,6,7,8,9 delims=:" %%a in (sound.txt) do set sound1=%%a&set sound2=%%b&set sound3=%%c&set sound4=%%d&set sound5=%%e&set sound6=%%f&set sound7=%%g&set sound8=%%h&set sound9=%%i
set Tandy=Tandy
Set CMS=Creative Music System (CMS)
set SB=Sound Blaster
set MT32=Roland MT32
set SC=Sound Canvas
set EH=James Woodcock's Enhanced Music
cd ..
if [!sound9!]==[] set final=8
if [!sound8!]==[] set final=7
if [!sound7!]==[] set final=6
if [!sound6!]==[] set final=5
if [!sound5!]==[] set final=4
if [!sound4!]==[] set final=3
if [!sound3!]==[] set final=2
if [!sound2!]==[] set final=1
if [!sound1!]==[] set final=0
cls
echo %cback%%cwipe%
echo !selection!
echo %ctitles%____________________________________________________________
echo %ctitle%Sound Selection Menu
echo %ctitles%____________________________________________________________
echo.
echo.
if not [!sound1!]==[] echo %cpress%Press %cpick%1%cpress% for !sound1!%cpress% music
if not [!sound2!]==[] echo %cpress%Press %cpick%2%cpress% for !sound2!%cpress% music
if not [!sound3!]==[] echo %cpress%Press %cpick%3%cpress% for !sound3!%cpress% music
if not [!sound4!]==[] echo %cpress%Press %cpick%4%cpress% for !sound4!%cpress% music
if not [!sound5!]==[] echo %cpress%Press %cpick%5%cpress% for !sound5!%cpress% music
if not [!sound6!]==[] echo %cpress%Press %cpick%6%cpress% for !sound6!%cpress% music
if not [!sound7!]==[] echo %cpress%Press %cpick%7%cpress% for !sound7!%cpress% music
if not [!sound8!]==[] echo %cpress%Press %cpick%8%cpress% for !sound8!%cpress% music
if not [!sound9!]==[] echo %cpress%Press %cpick%9%cpress% for !sound9!%cpress% music
echo.
echo %cchoice%
set /p sound="Type the number and press Enter: "

SET "var44="&for /f "delims=0123456789" %%i in ("!sound!") do set var44=%%i
if defined var44 goto sel_error3
if !sound! gtr !final! goto sel_error3
if !sound! == 0 goto sel_error3
if [!sound!]==[] goto sel_error3

if !sound! == 1 set sound_selection=!sound1!
if !sound! == 2 set sound_selection=!sound2!
if !sound! == 3 set sound_selection=!sound3!
if !sound! == 4 set sound_selection=!sound4!
if !sound! == 5 set sound_selection=!sound5!
if !sound! == 6 set sound_selection=!sound6!
if !sound! == 7 set sound_selection=!sound7!
if !sound! == 8 set sound_selection=!sound8!
if !sound! == 9 set sound_selection=!sound9!

if !sound_selection!==!Tandy! (
set s=T_
set sound=--opl-driver=nuked -epcjr --output-rate=44100
)
if !sound_selection!==!CMS! (
set s=CMS_
set sound=--opl-driver=nuked -ecms --output-rate=44100
)
if !sound_selection!==!SB! (
set s=sb_
set sound=--opl-driver=nuked --output-rate=44100
)
if !sound_selection!==!MT32! (
set s=mt32_
set sound=--opl-driver=nuked -emt32 --multi-midi --extrapath=.\mt32\ --output-rate=44100
if exist !selection!\mt32_rev0.txt set sound=--opl-driver=nuked -emt32 --multi-midi --extrapath=.\mt32\rev0 --output-rate=44100
if exist !selection2!\mt32_rev0.txt set sound=--opl-driver=nuked -emt32 --multi-midi --extrapath=.\mt32\rev0 --output-rate=44100
)
if !sound_selection!==!SC! (
set s=sc_
set sound=--opl-driver=nuked -efluidsynth --multi-midi --soundfont=.\mt32\soundcanvas.sf2 --output-rate=44100
)
if !sound_selection!==!EH! (
set s=eh_
set sound=--opl-driver=nuked --output-rate=44100
)

if exist ".\!selection!\!s!audio.txt" (
cd !selection!
for /f "tokens=1 delims=:" %%a in (!s!audio.txt) do set audio1=%%a
cd ..
set sound=!sound! !audio1!
)

if exist ".\!selection2!\!s!audio.txt" (
cd !selection2!
for /f "tokens=1 delims=:" %%a in (!s!audio.txt) do set audio1=%%a
cd ..
cd ..
set sound=!sound! !audio1!
)

if exist ".\!selection!\video.txt" goto video_set
if exist ".\!selection2!\video.txt" goto video_set

goto game_launch

:audio_set
if exist !selection! cd !selection!
if exist menu.txt cd !selection2!
for /f "tokens=1 delims=:" %%a in (audio.txt) do set audio1=%%a
set sound=!sound! !audio1!
cd ..
if exist menu.txt cd ..
if exist ".\!selection!\video.txt" goto video_set
if exist ".\!selection2!\video.txt" goto video_set
goto game_launch

:video_set
if exist !selection! cd !selection!
if exist menu.txt cd !selection2!
for /f "tokens=1 delims=:" %%a in (video.txt) do set render=%%a
cd ..
if exist menu.txt cd ..

:game_launch
cd !var!
cd ..\..\..
.\util\setconsole.exe /minimize
".\Emulators\scmvm\!svm!" --no-console !screen! !render! !subtitle! --stretch-mode=pixel-perfect !platform! --config=.\Emulators\scmvm%svmini%scummvm.ini !sound! -p".\eXoScummVM\!GameDir!\!selection!\\" !gameid!
goto end

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
echo %cpress%This game only has a !select1! version. Press a key to launch it.
echo %cchoice%
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

:sel_error3
echo.
echo %cpress%That is not a valid selection, please try again.
echo %cchoice%
pause
goto :sound_menu

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
".\Emulators\DREAMM\%drm%" -option %aspect% -option %screen% ".\eXoDREAMM\%GameDir%\%selection%\%language%\%launch%\"
goto end

:keys
cls
echo.
echo %ctitle%+-----------------+--------------------------------+---------------------------------------------+
echo %ctitle%^| %cpress%Hotkey%ctitles%          ^| %cpress%Effect%ctitles%                         ^| %cpress%Notes%ctitle%                                       ^|
echo %ctitle%+%ctitles%-----------------+--------------------------------+---------------------------------------------%ctitle%+
echo %ctitle%^| %cpress%CTRL F5         %ctitles%^| %cnote%In-Game Menu                   %ctitles%^|                                             %ctitle%^|
echo %ctitle%+%ctitles%-----------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%ALT ENTER       %ctitles%^| %cnote%Toggle Fullscreen ^\ Window     %ctitles%^|                                             %ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT +      %ctitles%^| %cnote%Increase Window Size           %ctitles%^| %cnote%Also increases play area size in fullscreen %ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT -      %ctitles%^| %cnote%Decrease Window Size           %ctitles%^| %cnote%Also decreases play area size in fullscreen %ctitle%^|
echo %ctitle%+%ctitles%-----------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT F      %ctitles%^| %cnote%Toggle Interpolation           %ctitles%^| %cnote%Nearest neighbor vs bilinear                %ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT 9 or 0 %ctitles%^| %cnote%Cycles Graphic Filters         %ctitles%^|                                             %ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT S      %ctitles%^| %cnote%Cycles Stretch Modes           %ctitles%^| %cnote%Pixel Perfect is default                    %ctitle%^|
echo %ctitle%^| %cpress%CTRL ALT A      %ctitles%^| %cnote%Toggle Aspect Ratio Correction %ctitles%^| %cnote%Switches between 4:3 or RAW output          %ctitle%^|
echo %ctitle%^| %cpress%ALT S           %ctitles%^| %cnote%Take Screenshot                %ctitles%^| %cnote%Found in Pictures folder                    %ctitle%^|
echo %ctitle%+%ctitles%-----------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%CTRL U          %ctitles%^| %cnote%Mutes all Sound                %ctitles%^|                                             %ctitle%^|
echo %ctitle%+%ctitles%-----------------^|--------------------------------^|---------------------------------------------%ctitle%^|
echo %ctitle%^| %cpress%ALT F4          %ctitles%^| %cnote%Exit Game                      %ctitles%^|                                             %ctitle%^|
echo %ctitle%+-----------------+--------------------------------+---------------------------------------------+
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
IF NOT EXIST ".\eXoScummVM\%GameDir%\" goto end
goto launch
goto end
:no
goto end

:end
