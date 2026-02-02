@echo off
chcp 65001
cls

echo ========================================
echo       Switch to GLM Models
echo ========================================
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
echo [2/3] Switch models...

powershell -Command "$content = Get-Content 'docker-config\mmc\model_config.toml'; $content = $content -replace 'model_list = \[\"[^\"]+\"\]', 'model_list = [\"glm-4-plus\"]'; $content = $content -replace 'model_list = \[\"glm-4v\"\]', 'model_list = [\"glm-4v-plus\"]'; $content = $content -replace 'model_list = \[\"deepseek-chat\"\]', 'model_list = [\"glm-4-plus\"]'; $content = $content -replace 'model_list = \[\"deepseek-reasoner\"\]', 'model_list = [\"glm-4-plus\"]'; Set-Content 'docker-config\mmc\model_config.toml' $content"

echo OK - Models switched:
echo   - All tasks: GLM-4-Plus (NO Air model!)
echo   - Vision: GLM-4V-Plus (Emoji support)

echo.
echo [3/3] Restart container...
docker-compose stop core >nul 2>&1
docker-compose up -d core >nul 2>&1

echo.
echo ========================================
echo       Done! Switched to GLM
echo ========================================
echo.
echo Models:
echo   - GLM-4-Plus (All tasks - BEST)
echo   - GLM-4V-Plus (Vision/Emoji)
echo.
echo NO GLM-Air! Using best models only.
echo.
echo Press any key to exit...
pause >nul
