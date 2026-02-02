@echo off
chcp 65001
cls

echo ========================================
echo    Switch to DeepSeek-R1 (Think)
echo ========================================
echo.
echo Features: Strong reasoning, deep thinking
echo Best for: Math, logic, complex problems
echo.
echo WARNING:
echo   - NO GLM models used
echo   - Emoji/image recognition DISABLED
echo   - Response SLOW (needs thinking time)
echo.

if not exist "docker-config\mmc\model_config.toml" (
    echo ERROR: docker-config\mmc\model_config.toml not found!
    echo Please run this script from the MaiBot directory.
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo [1/3] Backup config...
copy /Y "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config.toml.backup" >nul
echo OK - Config backed up

echo.
echo [2/3] Switch to DeepSeek-R1...

powershell -Command "$content = Get-Content 'docker-config\mmc\model_config.toml'; $content = $content -replace 'model_list = \[\"[^\"]+\"\]', 'model_list = [\"deepseek-reasoner\"]'; Set-Content 'docker-config\mmc\model_config.toml' $content"

echo OK - All tasks switched to DeepSeek-R1

echo.
echo [3/3] Restart container...
docker-compose stop core >nul 2>&1
docker-compose up -d core >nul 2>&1

echo.
echo ========================================
echo       Done! Switched to DeepSeek-R1
echo ========================================
echo.
echo Current config (Pure DeepSeek):
echo   - All tasks: DeepSeek-R1 (deepseek-reasoner)
echo.
echo NOTES:
echo   - Emoji recognition: DISABLED
echo   - Image recognition: DISABLED
echo   - Chat: Works normally
echo   - Response: SLOW but accurate
echo.
echo Press any key to exit...
pause >nul
