@echo off
title Switch to DeepSeek
echo.
echo ========================================
echo   Switching to DeepSeek Model
echo ========================================
echo.
echo This will:
echo   1. Backup current GLM config
echo   2. Switch to DeepSeek API
echo   3. Restart Core service
echo.
echo Press any key to continue...
pause >nul
echo.
echo Backing up current config...
copy "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config_glm_backup.toml"
echo.
echo Switching to DeepSeek...
copy "docker-config\mmc\model_config_deepseek.toml" "docker-config\mmc\model_config.toml"
echo.
echo Restarting Core service...
cd /d "%~dp0"
docker-compose restart core
echo.
echo ========================================
echo   Switch Complete!
echo ========================================
echo.
echo Current model: DeepSeek
echo.
pause
