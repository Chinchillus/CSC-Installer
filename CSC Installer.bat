rem MIT License

rem Copyright (c) 2023 Chinchill

rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:

rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.

rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.

@echo off
MODE 100,20
title CSC Installer v1.4
color b
echo Welcome %USERNAME%!
timeout /t 1 >nul
echo.

:choose_version
echo Select the version to install:
echo 1. Normal (full)
echo 2. Lite
echo 3. Uninstall
set /p version_choice=Choice [1/2]: 
cls
if "%version_choice%"=="1" (
    set "SOURCE_URL=https://github.com/Chinchillus/CSC/releases/latest/download/csc.bat"
    set "DESTINATION_FILE=%APPDATA%\ChinchillScripts\csc.bat"
    set "SHORTCUT_NAME=CSC"
) else if "%version_choice%"=="2" (
    set "SOURCE_URL=https://github.com/Chinchillus/CSC-Lite/releases/latest/download/CSC-Lite.bat"
    set "DESTINATION_FILE=%APPDATA%\ChinchillScripts\CSC-Lite.bat"
    set "SHORTCUT_NAME=CSC Lite"
) else if "%version_choice%"=="3" (
	rd /s /q %APPDATA%\ChinchillScripts
	del /f /s /q "%USERPROFILE%\Desktop\CSC Lite.lnk"
	del /f /s /q "%USERPROFILE%\Desktop\CSC.lnk" 
	del /f /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\CSC Lite.lnk"
	del /f /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\CSC.lnk"
	goto uninstalled
) else (
    echo Invalid choice. Select 1 or 2.
    goto choose_version
)

if exist "%DESTINATION_FILE%" (
    echo %SHORTCUT_NAME% is already installed.
    echo Updating...
    del "%DESTINATION_FILE%"
    del "%APPDATA%\ChinchillScripts\Icon.ico"
    echo.
    goto install
)

:install
set "INSTALL_DIR=%APPDATA%\ChinchillScripts"
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

set "ICON_URL=https://raw.githubusercontent.com/Chinchillus/CSC/main/Icon.ico"
set "ICON_FILE=%INSTALL_DIR%\Icon.ico"

powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%SOURCE_URL%', '%DESTINATION_FILE%')"
echo Latest version downloaded to: "%DESTINATION_FILE%".

powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%ICON_URL%', '%ICON_FILE%')"
echo Latest icon downloaded to: "%ICON_FILE%".

set "SHORTCUT_PATH=%USERPROFILE%\Desktop\%SHORTCUT_NAME%.lnk"
set "PROGRAMS_SHORTCUT_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\%SHORTCUT_NAME%.lnk"

powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = '%DESTINATION_FILE%'; $Shortcut.IconLocation = '%ICON_FILE%'; $Shortcut.Save()"
powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%PROGRAMS_SHORTCUT_PATH%'); $Shortcut.TargetPath = '%DESTINATION_FILE%'; $Shortcut.IconLocation = '%ICON_FILE%'; $Shortcut.Save()"

echo Shortcut created at start menu and desktop.
echo.
echo %SHORTCUT_NAME% installed succesfully!
echo.
timeout /t 4 >nul
exit
:uninstalled
echo Removed succesfully!
echo Exiting...
timeout /t 2 >nul
exit
