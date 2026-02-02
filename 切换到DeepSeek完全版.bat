@echo off
chcp 65001 >nul
cls

echo ========================================
echo    Switch to DeepSeek Complete
echo ========================================
echo.
echo WARNING: Switching ALL tasks to DeepSeek
echo.
echo Model Allocation:
echo   - Reasoning tasks: DeepSeek-R1
echo   - Chat tasks: DeepSeek-V3.2
echo   - Visual tasks: DeepSeek-VL
echo.
echo NOTE: DeepSeek-VL may not work
echo       Emoji recognition might fail
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
echo [2/4] Switching to DeepSeek...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0switch_to_deepseek.ps1"

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
echo.
echo Reasoning Engine (R1):
echo   - Planner: deepseek-reasoner
echo   - Tool Use: deepseek-reasoner
echo   - Planner Small: deepseek-reasoner
echo.
echo Chat Engine (V3.2):
echo   - Replyer: deepseek-chat
echo   - Utils: deepseek-chat
echo   - Emotion: deepseek-chat
echo   - All other tasks: deepseek-chat
echo.
echo Visual Engine (VL):
echo   - VLM: deepseek-vl
echo.
echo IMPORTANT:
echo   - Emoji recognition may fail
echo   - DeepSeek does not have visual API yet
echo   - This is normal and cannot be fixed
echo.
echo Press any key to exit...
pause >nul
