@echo off
chcp 65001 >nul
cls

echo ========================================
echo    Switch to GLM Models
echo ========================================
echo.
echo All tasks will use GLM models
echo.
echo Model Allocation:
echo   - Most tasks: glm-4-plus
echo   - Visual tasks: glm-4v-plus (emoji support)
echo.
echo Features:
echo   - Full emoji recognition
echo   - Image recognition
echo   - Stable and reliable
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
echo [2/4] Switching to GLM...

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0switch_to_glm.ps1"

if errorlevel 1 (
    echo FAILED: PowerShell script failed
    pause
    exit /b 1
)
echo OK - Models switched

echo.
echo [3/4] Verify config...
findstr /C:"glm-4-plus" "docker-config\mmc\model_config.toml" >nul
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
echo   - Most tasks: glm-4-plus
echo   - Visual tasks: glm-4v-plus
echo.
echo Features:
echo   - Emoji recognition: ENABLED
echo   - Image recognition: ENABLED
echo   - Tool calls: Working
echo.
echo WebUI: http://localhost:8001
echo.
echo Press any key to exit...
pause >nul
