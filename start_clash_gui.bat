@echo off
chcp 65001 >nul
echo ================================================================================
echo                        Clash Verge GUI 启动工具
echo ================================================================================
echo.

echo [1/3] Searching for Clash Verge...
echo.

set "EXE_PATH="

if exist "C:\Users\admin\AppData\Local\Programs\clash-verge-rev-clash-verge-rev\clash-verge.exe" (
    set "EXE_PATH=C:\Users\admin\AppData\Local\Programs\clash-verge-rev-clash-verge-rev\clash-verge.exe"
    echo Found: C:\Users\admin\AppData\Local\Programs\clash-verge-rev-clash-verge-rev\
)

if exist "C:\Program Files\clash-verge-rev\clash-verge.exe" (
    set "EXE_PATH=C:\Program Files\clash-verge-rev\clash-verge.exe"
    echo Found: C:\Program Files\clash-verge-rev\
)

if "%EXE_PATH%"=="" (
    echo Not found. Please:
    echo 1. Start from Start Menu
    echo 2. Reinstall Clash Verge
    echo.
    pause
    exit /b 1
)

echo.
echo [2/3] Current processes:
tasklist | findstr /i "clash verge mihomo"
echo.

echo [3/3] Starting GUI...
echo.
echo Starting: %EXE_PATH%
echo.
start "" "%EXE_PATH%"

echo ================================================================================
echo                           Start command sent
echo ================================================================================
echo.
echo Please check:
echo - System tray for Clash icon
echo - Task Manager for clash-verge.exe process
echo.

timeout /t 3 >nul

echo Checking again...
tasklist | findstr /i "clash"
echo.

pause
