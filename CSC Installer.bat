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
