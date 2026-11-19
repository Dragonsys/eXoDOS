@echo off
set nasconf=..\util\nas.conf
set nas=false
if exist ..\..\Content\MediaPack.ver (
SETLOCAL ENABLEDELAYEDEXPANSION
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/MediaPack.exo', '.\MediaPack.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" MediaPack.txt') do set mpversionnum=%%a
for /F "delims=" %%a in ('findstr /C:"Version" ..\..\Content\MediaPack.ver') do set mpcurrentver=%%a
set mpver1=!mpversionnum:*:=!
set mpver=!mpver1:*:=!

if !mpver! == !mpcurrentver! goto mpskip
cls
echo.
echo Currently you have Media Pack !mpcurrentver!.
echo !mpver! is available. To update to it, please 
echo 1. Go to www.retro-exo.com
echo 2. Download the latest version
echo 3. Place the new files in the \Content\ folder of eXoDOS
echo 4. Run the Setup eXoDOS.bat file, and choose to install the Media Pack
echo.
echo Press a key to continue the update process.
pause >nul
)

:mpskip
@del MediaPack.txt
SETLOCAL DISABLEDELAYEDEXPANSION

set chineseupdate=false
set frenchupdate=false
set germanupdate=false
set italianupdate=false
set koreanupdate=false
set polishupdate=false
set russianupdate=false
set spanishupdate=false

IF NOT EXIST ..\emulators\dosbox\*.lang (
for /f "delims=" %%x in (..\util\!english\texts.txt) do (set "%%x")
goto continue
)

if exist "..\eXoDOS\!dos\!German\" set germanupdate=true
if exist "..\eXoDOS\!dos\!Chinese\" set chineseupdate=true
if exist "..\eXoDOS\!dos\!French\" set frenchupdate=true
if exist "..\eXoDOS\!dos\!Italian\" set italianupdate=true
if exist "..\eXoDOS\!dos\!Korean\" set koreanupdate=true
if exist "..\eXoDOS\!dos\!Polish\" set polishupdate=true
if exist "..\eXoDOS\!dos\!Russian\" set russianupdate=true
if exist "..\eXoDOS\!dos\!Spanish\" set spanishupdate=true

cls
echo.
echo Language Packs Detected.
echo.
if %chineseupdate%==true echo Press C to run the Updater in Chinese
echo Press E to run the Updater in English
if %frenchupdate%==true echo Press F to run the Updater in French
if %germanupdate%==true echo Press G to run the Updater in German
if %italianupdate%==true echo Press I to run the Updater in Italian
if %koreanupdate%==true echo Press K to run the Updater in Korean
if %polishupdate%==true echo Press P to run the Updater in Polish
if %russianupdate%==true echo Press R to run the Updater in Russian
if %spanishupdate%==true echo Press S to run the Updater in Spanish
echo Press X to Quit
echo.
..\util\choice /C:CEFGIKPRSX /N Please Choose:

if errorlevel = 1 set languagefolder=chinese
if errorlevel = 2 set languagefolder=english
if errorlevel = 3 set languagefolder=french
if errorlevel = 4 set languagefolder=german
if errorlevel = 5 set languagefolder=italian
if errorlevel = 6 set languagefolder=korean
if errorlevel = 7 set languagefolder=polish
if errorlevel = 8 set languagefolder=russian
if errorlevel = 9 set languagefolder=spanish
if errorlevel = 10 goto exit

::Load the language text file
for /f "delims=" %%x in (..\util\!%languagefolder%\texts.txt) do (set "%%x")

if exist "..\eXoDOS\!dos\!German\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set germanupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\util\eXoDOS-German.lang') do set germancurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/german.exo', '.\germanver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" germanver.txt') do set germanversionnum=%%a
set germanver1=!germanversionnum:*:=!
set germanver=!germanver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" germanver.txt') do set germanlinkaddress=%%a
set germanlink1=!germanlinkaddress:*:=!
set germanlink=!germanlink1:*:=!
set germanflink=!germanlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" germanver.txt') do set germanfilename1=%%a
set germanupdatefile=!germanfilename1:*:=!

echo !germanver!> germanver2.txt
fc germanver2.txt ..\emulators\dosbox\german.lang
if errorlevel = 0 set germanupdate=false
if errorlevel = 1 set germanupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Chinese\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set chineseupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\chinese.lang') do set chinesecurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/chinese.exo', '.\chinesever.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" chinesever.txt') do set chineseversionnum=%%a
set chinesever1=!chineseversionnum:*:=!
set chinesever=!chinesever1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" chinesever.txt') do set chineselinkaddress=%%a
set chineselink1=!chineselinkaddress:*:=!
set chineselink=!chineselink1:*:=!
set chineseflink=!chineselink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" chinesever.txt') do set chinesefilename1=%%a
set chineseupdatefile=!chinesefilename1:*:=!

echo !chinesever!> chinesever2.txt
fc chinesever2.txt ..\emulators\dosbox\chinese.lang
if errorlevel = 0 set chineseupdate=false
if errorlevel = 1 set chineseupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!French\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set frenchupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\french.lang') do set frenchcurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/french.exo', '.\frenchver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" frenchver.txt') do set frenchversionnum=%%a
set frenchver1=!frenchversionnum:*:=!
set frenchver=!frenchver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" frenchver.txt') do set frenchlinkaddress=%%a
set frenchlink1=!frenchlinkaddress:*:=!
set frenchlink=!frenchlink1:*:=!
set frenchflink=!frenchlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" frenchver.txt') do set frenchfilename1=%%a
set frenchupdatefile=!frenchfilename1:*:=!

echo !frenchver!> frenchver2.txt
fc frenchver2.txt ..\emulators\dosbox\french.lang
if errorlevel = 0 set frenchupdate=false
if errorlevel = 1 set frenchupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Italian\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set italianupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\italian.lang') do set italiancurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/italian.exo', '.\italianver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" italianver.txt') do set italianversionnum=%%a
set italianver1=!italianversionnum:*:=!
set italianver=!italianver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" italianver.txt') do set italianlinkaddress=%%a
set italianlink1=!italianlinkaddress:*:=!
set italianlink=!italianlink1:*:=!
set italianflink=!italianlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" italianver.txt') do set italianfilename1=%%a
set italianupdatefile=!italianfilename1:*:=!

echo !italianver!> italianver2.txt
fc italianver2.txt ..\emulators\dosbox\italian.lang
if errorlevel = 0 set italianupdate=false
if errorlevel = 1 set italianupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Korean\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set koreanupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\korean.lang') do set koreancurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/korean.exo', '.\koreanver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" koreanver.txt') do set koreanversionnum=%%a
set koreanver1=!koreanversionnum:*:=!
set koreanver=!koreanver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" koreanver.txt') do set koreanlinkaddress=%%a
set koreanlink1=!koreanlinkaddress:*:=!
set koreanlink=!koreanlink1:*:=!
set koreanflink=!koreanlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" koreanver.txt') do set koreanfilename1=%%a
set koreanupdatefile=!koreanfilename1:*:=!

echo !koreanver!> koreanver2.txt
fc koreanver2.txt ..\emulators\dosbox\korean.lang
if errorlevel = 0 set koreanupdate=false
if errorlevel = 1 set koreanupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Polish\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set polishupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\polish.lang') do set polishcurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/polish.exo', '.\polishver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" polishver.txt') do set polishversionnum=%%a
set polishver1=!polishversionnum:*:=!
set polishver=!polishver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" polishver.txt') do set polishlinkaddress=%%a
set polishlink1=!polishlinkaddress:*:=!
set polishlink=!polishlink1:*:=!
set polishflink=!polishlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" polishver.txt') do set polishfilename1=%%a
set polishupdatefile=!polishfilename1:*:=!

echo !polishver!> polishver2.txt
fc polishver2.txt ..\emulators\dosbox\polish.lang
if errorlevel = 0 set polishupdate=false
if errorlevel = 1 set polishupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Russian\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set russianupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\russian.lang') do set russiancurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/russian.exo', '.\russianver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" russianver.txt') do set russianversionnum=%%a
set russianver1=!russianversionnum:*:=!
set russianver=!russianver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" russianver.txt') do set russianlinkaddress=%%a
set russianlink1=!russianlinkaddress:*:=!
set russianlink=!russianlink1:*:=!
set russianflink=!russianlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" russianver.txt') do set russianfilename1=%%a
set russianupdatefile=!russianfilename1:*:=!

echo !russianver!> russianver2.txt
fc russianver2.txt ..\emulators\dosbox\russian.lang
if errorlevel = 0 set russianupdate=false
if errorlevel = 1 set russianupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

if exist "..\eXoDOS\!dos\!Spanish\" (
SETLOCAL ENABLEDELAYEDEXPANSION
set spanishupdate=true
for /F "delims=" %%a in ('findstr /C:"Version" ..\emulators\dosbox\spanish.lang') do set spanishcurrentver=%%a
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/spanish.exo', '.\spanishver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" spanishver.txt') do set spanishversionnum=%%a
set spanishver1=!spanishversionnum:*:=!
set spanishver=!spanishver1:*:=!
for /F "delims=" %%a in ('findstr /C:"link:" spanishver.txt') do set spanishlinkaddress=%%a
set spanishlink1=!spanishlinkaddress:*:=!
set spanishlink=!spanishlink1:*:=!
set spanishflink=!spanishlink:*/=!
for /F "delims=" %%a in ('findstr /C:"file:" spanishver.txt') do set spanishfilename1=%%a
set spanishupdatefile=!spanishfilename1:*:=!

echo !spanishver!> spanishver2.txt
fc spanishver2.txt ..\emulators\dosbox\spanish.lang
if errorlevel = 0 set spanishupdate=false
if errorlevel = 1 set spanishupdate=true
SETLOCAL DISABLEDELAYEDEXPANSION
)

:continue
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.retro-exo.com/ver.exo', '.\ver.txt') }"
for /F "delims=" %%a in ('findstr /C:"ver:" ver.txt') do set versionnum=%%a
for /F "delims=" %%a in ('findstr /C:"Version" .\ver\ver.txt') do set currentver=%%a
set ver1=%versionnum:*:=%
set ver=%ver1:*:=%
for /F "delims=" %%a in ('findstr /C:"link:" ver.txt') do set linkaddress=%%a
set link1=%linkaddress:*:=%
set link=%link1:*:=%
set flink=%link:*/=%

for /F "delims=" %%a in ('findstr /C:"file:" ver.txt') do set filename1=%%a
set filename=%filename1:*:=%
rem for /f "tokens=1,2,3,4 delims=/ " %%a in ("%flink%") do set update=%%b

IF NOT EXIST %nasconf% goto nasdone
set nas=true
set /p naspath=<%nasconf%
if not defined naspath set nas=false
if not defined naspath goto nasdone
if "%naspath:~-1%"==" " set naspath=%naspath:~0,-1%
if "%naspath:~-1%"=="\" set naspath=%naspath:~0,-1%
:nasdone

echo %ver%> ver2.txt
fc ver2.txt .\ver\ver.txt

if errorlevel = 0 set englishupdate=false
if errorlevel = 1 set englishupdate=true

rem Never offer a version older than the one installed
set remotever=0
set localver=0
for /f "tokens=2,3 delims=. " %%a in ("%ver%") do set /a remotever=%%a*1000+1%%b
for /f "tokens=2,3 delims=. " %%a in ("%currentver%") do set /a localver=%%a*1000+1%%b
if %remotever% LSS %localver% set englishupdate=false

if %englishupdate%==true goto cont
if %chineseupdate%==true goto cont
if %frenchupdate%==true goto cont
if %germanupdate%==true goto cont
if %italianupdate%==true goto cont
if %koreanupdate%==true goto cont
if %polishupdate%==true goto cont
if %russianupdate%==true goto cont
if %spanishupdate%==true goto cont
goto alreadyupdated

:cont
cls
if %englishupdate%==true echo.
if %englishupdate%==true echo.
if %englishupdate%==true echo %Updaterline0001% %currentver%.
if %englishupdate%==true echo eXoDOS %ver% %Updaterline0002%
if %chineseupdate%==true echo.
if %chineseupdate%==true echo ========================================================================
if %chineseupdate%==true echo.
if %chineseupdate%==true echo %Updaterline0003% %chinesecurrentver%.
if %chineseupdate%==true echo %Updaterline0004% %chinesever% %Updaterline0002%
if %frenchupdate%==true echo.
if %frenchupdate%==true echo ========================================================================
if %frenchupdate%==true echo.
if %frenchupdate%==true echo %Updaterline0006% %frenchcurrentver%.
if %frenchupdate%==true echo %Updaterline0007% %frenchver% %Updaterline0002%
if %germanupdate%==true echo.
if %germanupdate%==true echo ========================================================================
if %germanupdate%==true echo.
if %germanupdate%==true echo %Updaterline0008% %germancurrentver%.
if %germanupdate%==true echo %Updaterline0009% %germanver% %Updaterline0002%
if %italianupdate%==true echo.
if %italianupdate%==true echo ========================================================================
if %italianupdate%==true echo.
if %italianupdate%==true echo %Updaterline0010% %italiancurrentver%.
if %italianupdate%==true echo %Updaterline0011% %italianver% %Updaterline0002%
if %koreanupdate%==true echo.
if %koreanupdate%==true echo ========================================================================
if %koreanupdate%==true echo.
if %koreanupdate%==true echo %Updaterline0012% %koreancurrentver%.
if %koreanupdate%==true echo %Updaterline0013% %koreanver% %Updaterline0002%
if %polishupdate%==true echo.
if %polishupdate%==true echo ========================================================================
if %polishupdate%==true echo.
if %polishupdate%==true echo %Updaterline0014% %polishcurrentver%.
if %polishupdate%==true echo %Updaterline0015% %polishver% %Updaterline0002%
if %russianupdate%==true echo.
if %russianupdate%==true echo ========================================================================
if %russianupdate%==true echo.
if %russianupdate%==true echo %Updaterline0016% %russiancurrentver%.
if %russianupdate%==true echo %Updaterline0017% %russianver% %Updaterline0002%
if %spanishupdate%==true echo.
if %spanishupdate%==true echo ========================================================================
if %spanishupdate%==true echo.
if %spanishupdate%==true echo %Updaterline0018% %spanishcurrentver%.
if %spanishupdate%==true echo %Updaterline0019% %spanishver% %Updaterline0002%
echo.
echo.
echo %Updaterline0020%
cd ..
.\util\choice /C:%Updaterline0021% /N %Updaterline0022%

If errorlevel = 2 goto exit
If errorlevel = 1 goto start

:start
SETLOCAL EnableExtensions
SET EXE=LaunchBox.exe
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF NOT %%x == %EXE% (
  CLS
  ECHO.
  ECHO.
  GOTO updatenow
) ELSE (
  CLS
  echo.
  ECHO %EXE% %Updaterline0023%
  echo.
  echo %Updaterline0024%
  echo.
  ECHO %Updaterline0025%
  echo %Updaterline0026%
  echo.
  PAUSE
  GOTO start
)

:updatenow
cls
cd ..
echo %Updaterline0027%
if %englishupdate%==true call :getupdate "%filename%" "%link%"
if %chineseupdate%==true call :getupdate "%chineseupdatefile%" "%chineselink%"
if %frenchupdate%==true call :getupdate "%frenchupdatefile%" "%frenchlink%"
if %germanupdate%==true call :getupdate "%germanupdatefile%" "%germanlink%"
if %italianupdate%==true call :getupdate "%italianupdatefile%" "%italianlink%"
if %koreanupdate%==true call :getupdate "%koreanupdatefile%" "%koreanlink%"
if %polishupdate%==true call :getupdate "%polishupdatefile%" "%polishlink%"
if %russianupdate%==true call :getupdate "%russianupdatefile%" "%russianlink%"
if %spanishupdate%==true call :getupdate "%spanishupdatefile%" "%spanishlink%"

if %englishupdate%==true if not exist "%filename%" goto updatefailed
if %englishupdate%==true .\eXo\util\unzip -o "%filename%"
if %chineseupdate%==true if not exist "%chineseupdatefile%" goto updatefailed
if %chineseupdate%==true .\eXo\util\unzip -o "%chineseupdatefile%"
if %frenchupdate%==true if not exist "%frenchupdatefile%" goto updatefailed
if %frenchupdate%==true .\eXo\util\unzip -o "%frenchupdatefile%"
if %germanupdate%==true if not exist "%germanupdatefile%" goto updatefailed
if %germanupdate%==true .\eXo\util\unzip -o "%germanupdatefile%"
if %italianupdate%==true if not exist "%italianupdatefile%" goto updatefailed
if %italianupdate%==true .\eXo\util\unzip -o "%italianupdatefile%"
if %koreanupdate%==true if not exist "%koreanupdatefile%" goto updatefailed
if %koreanupdate%==true .\eXo\util\unzip -o "%koreanupdatefile%"
if %polishupdate%==true if not exist "%polishupdatefile%" goto updatefailed
if %polishupdate%==true .\eXo\util\unzip -o "%polishupdatefile%"
if %russianupdate%==true if not exist "%russianupdatefile%" goto updatefailed
if %russianupdate%==true .\eXo\util\unzip -o "%russianupdatefile%"
if %spanishupdate%==true if not exist "%spanishupdatefile%" goto updatefailed
if %spanishupdate%==true .\eXo\util\unzip -o "%spanishupdatefile%"

if %englishupdate%==true del "%filename%"
if %chineseupdate%==true del "%chineseupdatefile%"
if %frenchupdate%==true del "%frenchupdatefile%"
if %germanupdate%==true del "%germanupdatefile%"
if %italianupdate%==true del "%italianupdatefile%"
if %koreanupdate%==true del "%koreanupdatefile%"
if %polishupdate%==true del "%polishupdatefile%"
if %russianupdate%==true del "%russianupdatefile%"
if %spanishupdate%==true del "%spanishupdatefile%"

cd eXo
cd Update
if %englishupdate%==true copy ver2.txt .\ver\ver.txt
if %chineseupdate%==true copy chinesever2.txt ..\emulators\dosbox\chinese.lang
if %frenchupdate%==true copy frenchver2.txt ..\emulators\dosbox\french.lang
if %germanupdate%==true copy germanver2.txt ..\emulators\dosbox\german.lang
if %italianupdate%==true copy italianver2.txt ..\emulators\dosbox\italian.lang
if %koreanupdate%==true copy koreanver2.txt ..\emulators\dosbox\korean.lang
if %polishupdate%==true copy polishver2.txt ..\emulators\dosbox\polish.lang
if %russianupdate%==true copy russianver2.txt ..\emulators\dosbox\russian.lang
if %spanishupdate%==true copy spanishver2.txt ..\emulators\dosbox\spanish.lang
del *ver*.*
cd ..
cd ..

cd eXo
cls
echo.
echo %Updaterline0028%
echo %Updaterline0029%
echo.
pause
copy .\Update\update_installed.bat .\
call update_installed.bat
del update_installed.bat

cls
echo.
echo %Updaterline0030%
echo.
echo %Updaterline0031%
echo.
pause

:change
cls
if %englishupdate%==true echo.
if %englishupdate%==true echo %Updaterline0032%
if %englishupdate%==true echo.
if %englishupdate%==true type .\Update\changelog.txt | more
if %englishupdate%==true echo.
if %englishupdate%==true pause
cls
if %chineseupdate%==true echo.
if %chineseupdate%==true echo %Updaterline0033%
if %chineseupdate%==true echo.
if %chineseupdate%==true type .\Update\chinese_changelog.txt | more
if %chineseupdate%==true echo.
if %chineseupdate%==true pause
cls
if %frenchupdate%==true echo.
if %frenchupdate%==true echo %Updaterline0034%
if %frenchupdate%==true echo.
if %frenchupdate%==true type .\Update\french_changelog.txt | more
if %frenchupdate%==true echo.
if %frenchupdate%==true pause
cls
if %germanupdate%==true echo.
if %germanupdate%==true echo %Updaterline0035%
if %germanupdate%==true echo.
if %germanupdate%==true type .\Update\german_changelog.txt | more
if %germanupdate%==true echo.
if %germanupdate%==true pause
cls
if %italianupdate%==true echo.
if %italianupdate%==true echo %Updaterline0036%
if %italianupdate%==true echo.
if %italianupdate%==true type .\Update\italian_changelog.txt | more
if %italianupdate%==true echo.
if %italianupdate%==true pause
cls
if %koreanupdate%==true echo.
if %koreanupdate%==true echo %Updaterline0037%
if %koreanupdate%==true echo.
if %koreanupdate%==true type .\Update\korean_changelog.txt | more
if %koreanupdate%==true echo.
if %koreanupdate%==true pause
cls
if %polishupdate%==true echo.
if %polishupdate%==true echo %Updaterline0038%
if %polishupdate%==true echo.
if %polishupdate%==true type .\Update\polish_changelog.txt | more
if %polishupdate%==true echo.
if %polishupdate%==true pause
cls
if %russianupdate%==true echo.
if %russianupdate%==true echo %Updaterline0039%
if %russianupdate%==true echo.
if %russianupdate%==true type .\Update\russian_changelog.txt | more
if %russianupdate%==true echo.
if %russianupdate%==true pause
cls
if %spanishupdate%==true echo.
if %spanishupdate%==true echo %Updaterline0040%
if %spanishupdate%==true echo.
if %spanishupdate%==true type .\Update\spanish_changelog.txt | more
if %spanishupdate%==true echo.
if %spanishupdate%==true pause

cd Update
if exist *ver*.* del *ver*.*
goto exit

:alreadyupdated
cls
echo.
echo %Updaterline0041%
echo.
pause
cd ..
goto exit

rem :noupdate
rem cls
rem echo.
rem echo No update file found. Please download the update file and place it in the same folder
rem echo you launch eXoDOS from (where LaunchBox.exe resides)
rem echo.
rem pause
rem goto exit

rem :failed
rem cls
rem echo.
rem echo The update version could not be found. 
rem echo This typically means the internet is not reachable at this time.
rem echo Please check your internet connection.
rem echo.
rem pause

:getupdate
if %nas%==true if exist "%naspath%\%~1" (
	copy /Y "%naspath%\%~1" ".\%~1"
	exit /B
)
.\eXo\util\aria\aria2c.exe -x8 "https:%~2"
exit /B

:updatefailed
cls
echo.
echo The update file could not be found or downloaded. Nothing was changed.
echo.
pause
cd eXo
goto exit

:exit
cd Update
del *ver*.*
call update_xml.bat