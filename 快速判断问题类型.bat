@echo off
chcp 65001 >nul
title MaiBot 问题快速诊断
color 0B

cls
echo.
echo ================================================================================
echo                   MaiBot 问题快速诊断 - 只需回答 3 个问题
echo ================================================================================
echo.
echo 请根据实际情况回答以下问题，按 Y/N 选择
echo.
pause
cls

echo.
echo ================================================================================
echo 问题 1/3：机器人能收到消息吗？
echo ================================================================================
echo.
echo 症状描述：
echo   - 你发消息给机器人
echo   - QQ 显示消息已发送
echo   - 但机器人完全没有任何反应
echo.
echo 如果是这种情况，按 Y
echo 如果机器人有反应（比如显示了"对方正在输入"），按 N
echo.
choice /c YN /n /m "你的选择 [Y/N]: "
if errorlevel 2 goto HAS_RESPONSE
if errorlevel 1 goto NO_RESPONSE

:NO_RESPONSE
cls
echo.
echo ================================================================================
echo                       诊断结果：QQ 连接问题
echo ================================================================================
echo.
echo ✋ 这不是网络问题！
echo.
echo 💡 可能的原因：
echo   1. QQ 未登录
echo   2. NapCat 连接断开
echo   3. WebSocket 配置错误
echo.
echo 📋 解决步骤：
echo.
echo 步骤 1：检查 QQ 登录状态
echo   docker logs maim-bot-napcat --tail 30
echo.
echo 步骤 2：如果显示未登录，运行扫码登录
echo   双击：扫码登录.bat
echo.
echo 步骤 3：检查 WebSocket 连接
echo   docker logs maim-bot-core --tail 30 ^| findstr WebSocket
echo.
echo 步骤 4：如果连接断开，重启容器
echo   docker restart maim-bot-napcat
echo   docker restart maim-bot-core
echo.
pause
exit /b 0

:HAS_RESPONSE
cls
echo.
echo ================================================================================
echo 问题 2/3：机器人完全不回复，还是回复很慢？
echo ================================================================================
echo.
echo A. 完全不回复：发送消息后，机器人永远不回复
echo.
echo B. 回复很慢：发送消息后，机器人会回复，但要等很久（超过 30 秒）
echo.
choice /c AB /n /m "你的选择 [A/B]: "
if errorlevel 2 goto SLOW_REPLY
if errorlevel 1 goto NO_REPLY

:NO_REPLY
cls
echo.
echo ================================================================================
echo                       诊断结果：AI API 连接问题
echo ================================================================================
echo.
echo ⚠️  这通常是网络问题！
echo.
echo 💡 可能的原因：
echo   1. 代理软件未运行
echo   2. 代理未开启"允许局域网连接"
echo   3. API 密钥失效或余额不足
echo   4. 机器人配置为"仅回复 @"
echo.
echo 📋 解决步骤：
echo.
echo 步骤 1：运行自动诊断（推荐）
echo   双击：诊断并修复网络问题.bat
echo.
echo 步骤 2：检查代理软件
echo   - Clash Verge 是否运行？
echo   - "允许局域网连接"是否开启？
echo   - HTTP 代理端口是否为 7897？
echo.
echo 步骤 3：检查 API 余额
echo   访问：https://open.bigmodel.cn/console/overview
echo.
echo 步骤 4：检查机器人配置
echo   打开：docker-config\mmc\bot_config.toml
echo   搜索：mentioned_bot_reply
echo   如果是 true，改为 false（如果想主动聊天）
echo.
echo 步骤 5：检查群组活跃度
echo   打开：docker-config\mmc\bot_config.toml
echo   搜索：talk_value_rules
echo   确认数值不是 0.0001（几乎静默）
echo.
pause
exit /b 0

:SLOW_REPLY
cls
echo.
echo ================================================================================
echo 问题 3/3：是一直都很慢，还是最近才变慢？
echo ================================================================================
echo.
echo A. 一直都很慢：从开始使用就这么慢
echo.
echo B. 最近才变慢：之前正常，最近突然变慢
echo.
choice /c AB /n /m "你的选择 [A/B]: "
if errorlevel 2 goto RECENTLY_SLOW
if errorlevel 1 goto ALWAYS_SLOW

:ALWAYS_SLOW
cls
echo.
echo ================================================================================
echo                       诊断结果：性能配置问题
echo ================================================================================
echo.
echo 💡 可能的原因：
echo   1. 代理节点延迟高
echo   2. API 服务器响应慢
echo   3. 超时设置过短
echo.
echo 📋 解决步骤：
echo.
echo 步骤 1：切换代理节点
echo   在 Clash Verge 中选择延迟更低的节点
echo.
echo 步骤 2：增加超时时间
echo   打开：docker-config\mmc\model_config.toml
echo   搜索：timeout
echo   改为：timeout = 120
echo.
echo 步骤 3：重启容器
echo   docker restart maim-bot-core
echo.
pause
exit /b 0

:RECENTLY_SLOW
cls
echo.
echo ================================================================================
echo                       诊断结果：临时性问题
echo ================================================================================
echo.
echo 💡 可能的原因：
echo   1. API 服务器暂时拥堵
echo   2. 网络暂时不稳定
echo   3. 系统资源不足
echo.
echo 📋 解决步骤：
echo.
echo 步骤 1：检查系统资源
echo   打开任务管理器，查看 CPU/内存使用率
echo.
echo 步骤 2：重启容器
echo   docker restart maim-bot-core
echo.
echo 步骤 3：等待 5-10 分钟
echo   API 服务器可能临时拥堵
echo.
echo 步骤 4：如果问题持续
echo   运行完整诊断：完整故障诊断流程.bat
echo.
pause
exit /b 0
