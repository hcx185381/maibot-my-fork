@echo off
chcp 65001 >nul
echo ================================================================================
echo                           MaiBot 表情包问题诊断工具
echo ================================================================================
echo.

cd /d "%~dp0"

echo [1/5] 检查表情包目录结构...
echo.
echo 宿主机目录结构：
dir /b "data\MaiMBot" | findstr /i "emoji"
echo.

echo 宿主机 emoji 目录内容：
dir /b "data\MaiMBot\emoji" 2>nul
echo     ^^(空目录是正常的，新表情包会下载到这里^)
echo.

echo 宿主机 emoji_registed 目录内容（已注册的表情包）：
dir /b "data\MaiMBot\emoji_registed" 2>nul
echo.

echo.
echo [2/5] 检查容器内目录挂载...
docker exec maim-bot-core ls -la /MaiMBot/ | grep emoji
echo.

echo [3/5] 查看表情包配置...
docker exec maim-bot-core cat /MaiMBot/config/bot_config.toml | find /n "[" | findstr "emoji"
echo.

echo [4/5] 查看最近的表情包相关日志...
docker logs maim-bot-core 2>&1 | findstr /i "表情" | more
echo.

echo [5/5] 查看图片消息处理日志...
docker logs maim-bot-core 2>&1 | findstr /i "图片\|image" | findstr /i "收到\|下载" | more
echo.

echo ================================================================================
echo                                  诊断完成
echo ================================================================================
echo.
echo 说明：
echo 1. emoji 目录 - 用于存放新下载的表情包（空是正常的）
echo 2. emoji_registed 目录 - 存放已注册到数据库的表情包
echo 3. 配置中 steal_emoji=true 表示会自动偷取群聊中的表情包
echo.
echo 如果有问题，请检查：
echo - NapCat 是否正常运行
echo - 表情包功能是否在 bot_config.toml 中启用
echo - 是否有权限写入 emoji 目录
echo.
pause
