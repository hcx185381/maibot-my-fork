@echo off
title Switch to GLM
echo.
echo ========================================
echo   Switching to GLM Model
echo ========================================
echo.
echo This will:
echo   1. Switch back to GLM API
echo   2. Restart Core service
echo.
echo Press any key to continue...
pause >nul
echo.
echo Switching to GLM...
if exist "docker-config\mmc\model_config_glm_backup.toml" (
    copy "docker-config\mmc\model_config_glm_backup.toml" "docker-config\mmc\model_config.toml"
    echo Restored from backup
) else (
    echo Backup not found
)
echo.
echo Restarting Core service...
cd /d "%~dp0"
docker-compose restart core
echo.
echo ========================================
echo   Switch Complete!
echo ========================================
echo.
echo Current model: GLM-4
echo.
pause
