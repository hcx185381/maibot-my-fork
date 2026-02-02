@echo off
chcp 65001 >nul
cls

echo ========================================
echo    Switch to DeepSeek V3.2
echo ========================================
echo.
echo All tasks will use DeepSeek-V3.2 (deepseek-chat)
echo.
echo Model: DeepSeek-V3.2 (Non-thinking Mode)
echo Features: Fast, cost-effective, stable
echo.
echo NOTE: Visual tasks (emoji recognition)
echo       will be DISABLED - DeepSeek has no visual API
echo.

if not exist "docker-config\mmc\model_config.toml" (
    echo ERROR: docker-config\mmc\model_config.toml not found!
    echo Please run from MaiBot directory.
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo [1/4] Backup config...
copy /Y "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config.toml.backup" >nul
if errorlevel 1 (
    echo FAILED: Cannot backup config
    pause
    exit /b 1
)
echo OK - Config backed up

echo.
echo [2/4] Switching to DeepSeek-V3.2...

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0switch_to_v32.ps1"

if errorlevel 1 (
    echo FAILED: PowerShell script failed
    pause
    exit /b 1
)
echo OK - Models switched

echo.
echo [3/4] Verify config...
findstr /C:"deepseek-chat" "docker-config\mmc\model_config.toml" >nul
if errorlevel 1 (
    echo FAILED: Config verification failed
    echo Restoring backup...
    copy /Y "docker-config\mmc\model_config.toml.backup" "docker-config\mmc\model_config.toml" >nul
    pause
    exit /b 1
)
echo OK - Config verified

echo.
echo [4/4] Restart container...
docker-compose stop core >nul 2>&1
timeout /t 2 /nobreak >nul
docker-compose up -d core >nul 2>&1
timeout /t 3 /nobreak >nul
echo OK - Container restarted

echo.
echo ========================================
echo       Switch Complete!
echo ========================================
echo.
echo Current Configuration:
echo   - All tasks: deepseek-chat (DeepSeek-V3.2)
echo.
echo Advantages:
echo   - Stable and reliable
echo   - Fast response
echo   - Cost-effective
echo   - Tool calls work properly
echo.
echo Limitations:
echo   - No emoji/image recognition
echo   - No deep reasoning mode (R1)
echo.
echo WebUI: http://localhost:8001
echo.
echo Press any key to exit...
pause >nul
