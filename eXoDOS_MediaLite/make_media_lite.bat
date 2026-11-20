@echo off
setlocal
rem Makes a Lite copy of the eXoDOS Media Pack. See make_media_lite.ps1 for details.
if "%~2"=="" goto usage
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0make_media_lite.ps1" -Source "%~1" -Dest "%~2"
if errorlevel 1 (
	echo.
	echo The Lite Media Pack was not finished. Check the messages above.
	exit /B 1
)
echo.
echo The Lite Media Pack is ready in "%~2".
echo Put the files from its Content folder in the Content folder of your eXoDOS install,
echo then run Setup eXoDOS.bat again.
exit /B 0

:usage
echo Usage: make_media_lite.bat "FULL MEDIA PACK FOLDER" "NEW LITE FOLDER"
echo   for example: make_media_lite.bat "\\192.168.1.10\Media\Games\eXo\eXoDOS Media Pack\eXoDOS" "D:\eXoDOS Media Pack Lite"
echo To only see what would be kept and left on the share:
echo   powershell -ExecutionPolicy Bypass -File make_media_lite.ps1 -Source "FULL MEDIA PACK FOLDER" -Report
exit /B 1
