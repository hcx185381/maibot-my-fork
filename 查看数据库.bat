@echo off
chcp 65001 >nul
title MaiBot 数据库查看工具
cd /d "%~dp0"

:menu
cls
echo.
echo ========================================
echo   MaiBot 数据库查看工具
echo ========================================
echo.
echo 请选择要查看的内容：
echo.
echo [1] 查看最近 20 条消息
echo [2] 查看所有聊天统计
echo [3] 查看活跃用户排行
echo [4] 查看思考回溯记录
echo [5] 查看表达方式学习
echo [6] 查看表情包记录
echo [7] 查看图片记录
echo [8] 自定义 SQL 查询
echo [0] 退出
echo.
set /p choice="请输入选项 (0-8): "

if "%choice%"=="1" goto recent
if "%choice%"=="2" goto stats
if "%choice%"=="3" goto users
if "%choice%"=="4" goto thinking
if "%choice%"=="5" goto expression
if "%choice%"=="6" goto emoji
if "%choice%"=="7" goto images
if "%choice%"=="8" goto custom
if "%choice%"=="0" goto end
goto menu

:recent
cls
echo ========================================
echo   最近 20 条消息
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT message_id, datetime(time, 'unixepoch', 'localtime') as 时间, user_nickname as 用户, substr(display_message, 1, 80) as 消息内容 FROM messages ORDER BY time DESC LIMIT 20;"
echo.
echo.
pause
goto menu

:stats
cls
echo ========================================
echo   聊天统计
echo ========================================
echo.
echo [总消息数]
sqlite3 -column "data/MaiMBot/MaiBot.db" "SELECT '总消息数: ' || COUNT(*) FROM messages; SELECT '总思考数: ' || COUNT(*) FROM thinking_back; SELECT '表达方式数: ' || COUNT(*) FROM expression;"
echo.
echo [活跃群组]
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT chat_info_group_name as 群组名称, COUNT(*) as 消息数 FROM messages WHERE chat_info_group_name IS NOT NULL GROUP BY chat_info_group_name ORDER BY COUNT(*) DESC;"
echo.
pause
goto menu

:users
cls
echo ========================================
echo   活跃用户排行
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT user_nickname as 用户昵称, COUNT(*) as 消息数 FROM messages GROUP BY user_nickname ORDER BY COUNT(*) DESC LIMIT 10;"
echo.
pause
goto menu

:thinking
cls
echo ========================================
echo   思考回溯记录
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT datetime(time, 'unixepoch', 'localtime') as 时间, substr(triggering_event, 1, 100) as 触发事件, substr(result, 1, 100) as 结果 FROM thinking_back ORDER BY time DESC LIMIT 10;"
echo.
pause
goto menu

:expression
cls
echo ========================================
echo   表达方式学习
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT expression as 表达方式, source as 来源, usage_count as 使用次数 FROM expression ORDER BY usage_count DESC LIMIT 20;"
echo.
pause
goto menu

:emoji
cls
echo ========================================
echo   表情包记录
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT file_id as 表情包ID, description as 描述, add_time as 添加时间 FROM emoji ORDER BY add_time DESC LIMIT 20;"
echo.
pause
goto menu

:images
cls
echo ========================================
echo   图片记录
echo ========================================
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "SELECT id, datetime(time, 'unixepoch', 'localtime') as 时间, file_id as 图片ID, sha256 as SHA256 FROM images ORDER BY time DESC LIMIT 10;"
echo.
pause
goto menu

:custom
cls
echo ========================================
echo   自定义 SQL 查询
echo ========================================
echo.
echo 提示：输入 EXIT 返回主菜单
echo.
:sql_input
set /p sql="请输入 SQL 语句: "
if "%sql%"=="EXIT" goto menu
if "%sql%"=="exit" goto menu
if "%sql%"=="" goto sql_input
echo.
sqlite3 -header -column "data/MaiMBot/MaiBot.db" "%sql%"
echo.
pause
goto custom

:end
cls
echo.
echo 感谢使用！
echo.
timeout /t 2 >nul
exit
