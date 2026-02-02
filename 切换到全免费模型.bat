@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════════════╗
echo ║           切换到硅基流动全免费模型方案                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 正在切换到硅基流动全免费模型...
echo.

REM 进入项目目录
cd /d "%~dp0"

REM 检查配置文件是否存在
if not exist "docker-config\mmc\model_config_siliconflow_free_only.toml" (
    echo [错误] 找不到全免费配置文件！
    echo        请确保 model_config_siliconflow_free_only.toml 存在
    pause
    exit /b 1
)

REM 备份当前配置
echo [1/3] 备份当前配置...
copy /Y "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config.toml.last" >nul
if errorlevel 1 (
    echo [错误] 备份失败！
    pause
    exit /b 1
)
echo       ✓ 当前配置已备份到 model_config.toml.last

REM 应用全免费配置
echo.
echo [2/3] 应用全免费模型配置...
copy /Y "docker-config\mmc\model_config_siliconflow_free_only.toml" "docker-config\mmc\model_config.toml" >nul
if errorlevel 1 (
    echo [错误] 配置文件复制失败！
    pause
    exit /b 1
)
echo       ✓ 全免费配置已应用

REM 重启容器
echo.
echo [3/3] 重启MaiBot容器...
docker-compose restart core >nul 2>&1
if errorlevel 1 (
    echo [错误] 容器重启失败！
    pause
    exit /b 1
)

echo       ✓ 容器已重启

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    ✅ 切换成功！                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 当前配置：硅基流动全免费模型
echo 使用模型：
echo   • Qwen/Qwen2.5-7B-Instruct  (日常聊天)
echo   • GLM-4-9B                   (复杂推理)
echo   • PaddlePaddle/PaddleOCR-VL (OCR识别)
echo.
echo 💰 月费用：¥0 (完全免费！)
echo 📊 性能：DeepSeek-V3的75%
echo.
echo 等待10秒后检查状态...
timeout /t 10 >nul

echo.
echo ══════════════════════════════════════════════════════════════
echo 容器状态检查：
echo ══════════════════════════════════════════════════════════════
docker ps --filter "name=maim-bot-core" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ══════════════════════════════════════════════════════════════
echo 最近日志：
echo ══════════════════════════════════════════════════════════════
docker logs maim-bot-core --tail 10

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║  提示：在QQ群里发消息测试机器人是否正常回复              ║
echo ║                                                                ║
echo ║  想切换回DeepSeek官网？运行 "切换回DeepSeek官网.bat"        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
