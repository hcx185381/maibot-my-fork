@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════════════╗
echo ║     切换到智谱AI官方免费模型方案（100%%免费）                 ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 正在切换到智谱AI免费模型...
echo.

REM 进入项目目录
cd /d "%~dp0"

REM 检查配置文件是否存在
if not exist "docker-config\mmc\model_config_zhipu_free.toml" (
    echo [错误] 找不到智谱免费配置文件！
    echo        请确保 model_config_zhipu_free.toml 存在
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

REM 应用智谱免费配置
echo.
echo [2/3] 应用智谱AI免费模型配置...
copy /Y "docker-config\mmc\model_config_zhipu_free.toml" "docker-config\mmc\model_config.toml" >nul
if errorlevel 1 (
    echo [错误] 配置文件复制失败！
    pause
    exit /b 1
)
echo       ✓ 智谱免费配置已应用

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
echo 当前配置：智谱AI官方免费方案
echo 使用模型：
echo   • GLM-4-Flash    (日常聊天，完全免费)
echo   • GLM-4V-Flash   (视觉理解，完全免费)
echo.
echo 💰 成本：¥0/月 (100%%免费！)
echo 🚀 性能：比Qwen2.5-7B/GLM-4-9B提升3-5倍
echo 📚 来源：智谱AI官方 https://docs.bigmodel.cn/cn/guide/models/free/glm-4-flash-250414
echo.
echo 性能对比：
echo   [之前] Qwen2.5-7B  (70亿参数)  ⭐⭐
echo   [之前] GLM-4-9B    (90亿参数)  ⭐⭐⭐
echo   [现在] GLM-4-Flash              ⭐⭐⭐⭐⭐
echo.
echo 模型特性：
echo   ✓ 完全免费，无限制使用
echo   ✓ 128K超长上下文
echo   ✓ 支持联网搜索
echo   ✓ 支持函数调用
echo   ✓ 多模态能力（看图、OCR）
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
echo ║  其他切换选项：                                               ║
echo ║  • 运行 "切换到全免费模型.bat" - 切换回硅基流动小参数方案    ║
echo ║  • 运行 "切换回DeepSeek官网.bat" - 切换到DeepSeek官方        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
