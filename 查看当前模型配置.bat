@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ============================================================
echo              MaiBot Model Configuration Status
echo ============================================================
echo.

cd /d "%~dp0"

REM Check config type
echo [Current Configuration]
echo.

findstr /C:"model_list = [\"deepseek-chat\"]" "docker-config\mmc\model_config.toml" >nul 2>&1
if !errorlevel! equ 0 (
    echo Configuration: DeepSeek Official API
    echo.
    echo Models in use:
    echo   - deepseek-chat (all tasks)
    echo   - deepseek-vl (vision understanding)
    echo.
    echo Performance: 100 percent (Best)
    echo Monthly cost: 8-26 CNY
    echo Stability: Official source
    echo.
    goto :check_container
)

findstr /C:"Qwen/Qwen2.5-7B-Instruct" "docker-config\mmc\model_config.toml" >nul 2>&1
if !errorlevel! equ 0 (
    echo Configuration: SiliconFlow Free Models
    echo.
    echo Models in use:
    echo   - Qwen/Qwen2.5-7B-Instruct (daily chat)
    echo   - THUDM/glm-4-9b-chat (tool use, planning)
    echo   - PaddlePaddle/PaddleOCR-VL (OCR)
    echo.
    echo Performance: 60-75 percent
    echo Monthly cost: 0 CNY (Free)
    echo Stability: Good
    echo.
    goto :check_container
)

echo Configuration: Unknown
echo.

:check_container
echo ============================================================
echo.

echo [Container Status]
echo.
docker ps --filter "name=maim-bot-core" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo ============================================================
echo  Recent Activity
echo ============================================================
echo.
docker logs maim-bot-core --tail 100 2>&1 | findstr /C:"聊天消息统计" /A 20 >nul 2>&1
echo (Check container logs for recent activity)
echo.

echo ============================================================
echo  Quick Actions
echo ============================================================
echo.
echo [1] Switch to free models (0 CNY/month)
echo     Run: 切换到全免费模型.bat
echo.
echo [2] Switch to DeepSeek official (Best performance)
echo     Run: 切换回DeepSeek官网.bat
echo.
echo [3] View detailed config file
echo     File: docker-config\mmc\model_config.toml
echo.

echo ============================================================
echo.
pause
