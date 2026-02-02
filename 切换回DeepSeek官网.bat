@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════════════╗
echo ║         切换回DeepSeek官方API（性能最优）                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 正在切换回DeepSeek官方API...
echo.

REM 进入项目目录
cd /d "%~dp0"

REM 检查配置文件是否存在
if not exist "docker-config\mmc\model_config_deepseek_official.toml" (
    echo [错误] 找不到DeepSeek官方配置文件！
    echo        请确保 model_config_deepseek_official.toml 存在
    echo.
    echo 正在查找其他备份文件...
    if exist "docker-config\mmc\model_config.toml.backup" (
        echo       找到备份：model_config.toml.backup
        set "BACKUP_FILE=model_config.toml.backup"
    ) else if exist "docker-config\mmc\model_config.toml.last" (
        echo       找到备份：model_config.toml.last
        set "BACKUP_FILE=model_config.toml.last"
    ) else (
        echo [错误] 没有找到任何备份文件！
        pause
        exit /b 1
    )
) else (
    set "BACKUP_FILE=model_config_deepseek_official.toml"
)

REM 备份当前配置
echo [1/3] 备份当前配置...
copy /Y "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config.toml.free" >nul
if errorlevel 1 (
    echo [错误] 备份失败！
    pause
    exit /b 1
)
echo       ✓ 当前配置已备份到 model_config.toml.free

REM 应用DeepSeek官方配置
echo.
echo [2/3] 应用DeepSeek官方配置...
copy /Y "docker-config\mmc\!BACKUP_FILE!" "docker-config\mmc\model_config.toml" >nul
if errorlevel 1 (
    echo [错误] 配置文件复制失败！
    pause
    exit /b 1
)
echo       ✓ DeepSeek官方配置已应用

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
echo 当前配置：DeepSeek官方API
echo 使用模型：
echo   • deepseek-chat  (所有任务)
echo   • deepseek-vl    (视觉理解)
echo.
echo 💰 月费用：¥8-26 (有缓存机制，实际可能更低)
echo 📊 性能：100% (最强性能)
echo 🏢 稳定性：官方源，最可靠
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
echo ║  想切换到全免费模型？运行 "切换到全免费模型.bat"            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
