@echo off
chcp 65001
cls

echo ========================================
echo    Switch to DeepSeek-V3 (Fast)
echo ========================================
echo.
echo Features: Fast, versatile, cost-effective
echo Best for: Chat, code, writing
echo.
echo VISUAL SUPPORT:
echo   - VLM task: DeepSeek-VL (OCR + Emoji support)
echo   - Can recognize images and emojis
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
echo [2/3] Switch to DeepSeek-V3...

powershell -Command "$content = Get-Content 'docker-config\mmc\model_config.toml'; $content = $content -replace '(?s)\[model_task_config\.vlm\](.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.vlm]$1model_list = [\"deepseek-vl\"]'; $content = $content -replace '(?s)\[model_task_config\.(?!vlm)(.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.$1model_list = [\"deepseek-chat\"]'; Set-Content 'docker-config\mmc\model_config.toml' $content"

echo OK - Models switched:
echo   - Text tasks: DeepSeek-V3
echo   - Visual task: DeepSeek-VL (Emoji enabled)

echo.
echo [3/3] Restart container...
docker-compose stop core >nul 2>&1
docker-compose up -d core >nul 2>&1

echo.
echo ========================================
echo       Done! Switched to DeepSeek-V3
echo ========================================
echo.
echo Current config (DeepSeek + VL):
echo   - Text tasks: DeepSeek-V3 (deepseek-chat)
echo   - Visual task: DeepSeek-VL (deepseek-vl)
echo.
echo FEATURES:
echo   - Emoji recognition: ENABLED (via DeepSeek-VL)
echo   - Image recognition: ENABLED (via DeepSeek-VL)
echo   - Chat: Fast & cost-effective
echo.
echo Press any key to exit...
pause >nul
