@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════════════╗
echo ║              MaiBot 当前模型配置状态                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

REM 读取配置文件，判断当前使用哪种配置
echo ══════════════════════════════════════════════════════════════
echo 当前配置文件分析：
echo ══════════════════════════════════════════════════════════════

findstr /C:"Qwen/Qwen2.5-7B-Instruct" "docker-config\mmc\model_config.toml" >nul 2>&1
if !errorlevel! equ 0 (
    echo 状态：🆓 全免费模型模式
    echo.
    echo 使用模型：
    echo   • Qwen/Qwen2.5-7B-Instruct  (日常聊天)
    echo   • DeepSeek-R1-Distill-7B    (复杂推理)
    echo   • PaddlePaddle/PaddleOCR-VL (OCR识别)
    echo.
    echo 💰 月费用：¥0 (完全免费)
    echo 📊 性能：DeepSeek-V3的75%%
    echo ✨ 优势：零成本，性能足够
    echo.
    goto :show_status
)

findstr /C:"model_list = \"deepseek-chat\"" "docker-config\mmc\model_config.toml" >nul 2>&1
if !errorlevel! equ 0 (
    echo 状态：⭐ DeepSeek官方API
    echo.
    echo 使用模型：
    echo   • deepseek-chat  (所有任务)
    echo   • deepseek-vl    (视觉理解)
    echo.
    echo 💰 月费用：¥8-26 (有缓存)
    echo 📊 性能：100%% (最强)
    echo 🏢 稳定性：官方源
    echo.
    goto :show_status
)

echo 状态：❓ 未知配置
echo 无法自动识别当前配置类型
echo.

:show_status
echo ══════════════════════════════════════════════════════════════
echo 容器运行状态：
echo ══════════════════════════════════════════════════════════════
docker ps --filter "name=maim-bot-core" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ══════════════════════════════════════════════════════════════
echo 最近日志 (最后20行)：
echo ══════════════════════════════════════════════════════════════
docker logs maim-bot-core --tail 20 2>&1 | findstr /V "^[0-9]" | findstr /V "^$"

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║  快速操作：                                                  ║
echo ║                                                                ║
echo ║  [1] 切换到全免费模型 (¥0/月)                                ║
echo ║      运行 "切换到全免费模型.bat"                              ║
echo ║                                                                ║
echo ║  [2] 切换回DeepSeek官网 (性能最优)                            ║
echo ║      运行 "切换回DeepSeek官网.bat"                            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
