@echo off
chcp 65001 >nul
title MaiBot 完整故障诊断工具
color 0E

echo.
echo ================================================================================
echo                        MaiBot 完整故障诊断工具
echo ================================================================================
echo.
echo 此工具将诊断所有常见问题，不仅仅是网络问题
echo.
echo ================================================================================
echo.

REM 创建临时日志文件
set LOGFILE=maibot_diagnostic_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOGFILE=%LOGFILE: =0%

echo 诊断日志：%LOGFILE%
echo.

REM ============================================================
REM 1. Docker 相关问题
REM ============================================================
echo [检查 1/8] Docker Desktop 是否运行...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ 问题：Docker Desktop 未运行
    echo.
    echo 💡 解决方案：
    echo    1. 启动 Docker Desktop
    echo    2. 等待约 30 秒直到完全启动
    echo    3. 重新运行此脚本
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Docker Desktop 正在运行
)
echo.

REM ============================================================
REM 2. 容器状态检查
REM ============================================================
echo [检查 2/8] Docker 容器状态...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "maim-bot" >tmp_containers.txt
echo 当前运行的容器：
type tmp_containers.txt
del tmp_containers.txt

docker ps --format "{{.Names}}" | findstr "maim-bot-core" >nul
if errorlevel 1 (
    echo ❌ 问题：MaiBot 核心容器未运行
    echo.
    echo 💡 解决方案：
    echo    docker-compose up -d
    echo.
) else (
    echo ✅ MaiBot 核心容器正在运行
)
echo.

REM ============================================================
REM 3. 代理软件检查
REM ============================================================
echo [检查 3/8] 代理软件 (Clash Verge) 检查...
netstat -ano | findstr ":7897" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo ❌ 问题：代理软件未在端口 7897 运行
    echo.
    echo 💡 解决方案：
    echo    1. 启动 Clash Verge
    echo    2. 确认"允许局域网连接"已开启
    echo    3. 确认 HTTP 代理端口是 7897
    echo.
    pause
    exit /b 1
) else (
    echo ✅ 代理软件正在运行 (端口 7897)
)

REM 检查是否监听所有接口
netstat -ano | findstr "0.0.0.0:7897" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo ⚠️  警告：代理可能未开启"允许局域网连接"
    echo    当前监听：127.0.0.1:7897（应该是 0.0.0.0:7897）
    echo.
    echo 💡 解决方案：
    echo    在 Clash Verge 中开启"允许局域网连接"
    echo.
) else (
    echo ✅ 代理允许局域网连接 (0.0.0.0:7897)
)
echo.

REM ============================================================
REM 4. 网络连接检查
REM ============================================================
echo [检查 4/8] 网络连接检查...

REM 测试容器到代理的连接
docker exec maim-bot-core python -c "import socket; s=socket.socket(); s.settimeout(3); r=s.connect_ex(('172.30.240.1', 7897)); s.close(); exit(0 if r==0 else 1)" >nul 2>&1
if errorlevel 1 (
    echo ❌ 问题：容器无法连接到代理
    echo.
    echo 💡 运行"诊断并修复网络问题.bat"自动修复
    echo.
) else (
    echo ✅ 容器可以连接到代理
)

REM 测试到 AI API 的连接
docker exec maim-bot-core python -c "import os, urllib.request; os.environ['HTTPS_PROXY']='http://172.30.240.1:7897'; urllib.request.urlopen('https://open.bigmodel.cn', timeout=10)" >nul 2>&1
if errorlevel 1 (
    echo ❌ 问题：无法访问 AI API
    echo.
    echo 💡 可能原因：
    echo    - 代理节点本身有问题
    echo    - API 服务器暂时不可用
    echo    - 尝试切换代理节点
    echo.
) else (
    echo ✅ 可以访问 AI API
)
echo.

REM ============================================================
REM 5. QQ 登录状态检查
REM ============================================================
echo [检查 5/8] QQ 登录状态检查...
docker logs maim-bot-napcat --tail 50 2>&1 | findstr /i "登录\|login\|已连接" >tmp_qq.txt
if %ERRORLEVEL% EQU 0 (
    echo ✅ NapCat 日志中发现登录相关信息
) else (
    echo ⚠️  未能确认 QQ 登录状态
)

docker logs maim-bot-core --tail 50 2>&1 | findstr /i "WebSocket.*连接" >tmp_ws.txt
if %ERRORLEVEL% EQU 0 (
    echo ✅ QQ WebSocket 已连接
) else (
    echo ❌ 问题：QQ WebSocket 可能未连接
    echo.
    echo 💡 解决方案：
    echo    1. 检查 NapCat 日志：docker logs maim-bot-napcat
    echo    2. 可能需要重新扫码登录
    echo    3. 运行"扫码登录.bat"
    echo.
)

del tmp_qq.txt tmp_ws.txt 2>nul
echo.

REM ============================================================
REM 6. 配置文件检查
REM ============================================================
echo [检查 6/8] 配置文件检查...

if not exist "docker-config\mmc\.env" (
    echo ❌ 问题：缺少 .env 文件
    echo.
    echo 💡 .env 文件包含 API 密钥等关键配置
    echo.
) else (
    echo ✅ .env 文件存在
)

if not exist "docker-config\mmc\model_config.toml" (
    echo ❌ 问题：缺少 model_config.toml
    echo.
    echo 💡 模型配置文件不存在
    echo.
) else (
    echo ✅ model_config.toml 存在
)

if not exist "docker-config\mmc\bot_config.toml" (
    echo ❌ 问题：缺少 bot_config.toml
    echo.
    echo 💡 机器人配置文件不存在
    echo.
) else (
    echo ✅ bot_config.toml 存在
)
echo.

REM ============================================================
REM 7. 磁盘空间检查
REM ============================================================
echo [检查 7/8] 磁盘空间检查...
wmic logicaldisk where "DeviceID='E:'" get FreeSpace /value >tmp_disk.txt 2>nul
for /f "tokens=2 delims==" %%a in ('findstr "FreeSpace" tmp_disk.txt') do set FREESPACE=%%a
set /a FREESPACE_GB=%FREESPACE:~0,-9%
del tmp_disk.txt

if %FREESPACE_GB% LSS 1024 (
    echo ⚠️  警告：磁盘空间不足 (%FREESPACE_GB% GB)
    echo    建议至少保留 10 GB 可用空间
    echo.
) else (
    echo ✅ 磁盘空间充足 (%FREESPACE_GB% GB 可用)
)
echo.

REM ============================================================
REM 8. 日志错误分析
REM ============================================================
echo [检查 8/8] 分析最近的错误日志...
echo.
echo === MaiBot 核心日志（最近 20 行）===
docker logs maim-bot-core --tail 20 2>&1 | findstr /i "error\|错误\|failed\|失败\|timeout\|超时" >nul
if %ERRORLEVEL% EQU 0 (
    echo ⚠️  发现可能的错误：
    docker logs maim-bot-core --tail 20 2>&1 | findstr /i "error\|错误\|failed\|失败\|timeout\|超时"
) else (
    echo ✅ 未发现明显错误
)
echo.

REM ============================================================
REM 总结和建议
REM ============================================================
echo ================================================================================
echo                              诊断完成
echo ================================================================================
echo.
echo 📋 发现的问题总结：
echo.
echo 如果上述检查都显示 ✅，但 MaiBot 仍然无法正常工作：
echo.
echo 💡 可能的原因和解决方案：
echo.
echo 1. AI API 密钥失效或余额不足
echo    → 检查：https://open.bigmodel.cn/console/overview
echo    → 或查看：docker-config\mmc\model_config.toml
echo.
echo 2. QQ 被限制或冻结
echo    → 尝试用手机 QQ 登录确认
echo    → 检查是否收到安全提示
echo.
echo 3. 机器人配置被意外修改
echo    → 检查：docker-config\mmc\bot_config.toml
echo    → 确认 mentioned_bot_reply 等设置
echo.
echo 4. 容器内部错误
echo    → 查看完整日志：docker logs maim-bot-core --tail 100
echo    → 重启容器：docker restart maim-bot-core
echo.
echo 5. 首次运行需要初始化
echo    → 等待 1-2 分钟让容器完全启动
echo    → 查看日志确认初始化完成
echo.
echo ================================================================================
echo.
echo 📁 查看详细日志：
echo    docker logs maim-bot-core --tail 50
echo    docker logs maim-bot-napcat --tail 50
echo.
echo 📁 访问管理界面：
echo    MaiBot WebUI: http://localhost:8001
echo    NapCat WebUI: http://localhost:6099
echo.
echo 📁 常用修复命令：
echo    docker-compose restart           （重启所有容器）
echo    docker restart maim-bot-core     （仅重启核心）
echo    docker-compose down && docker-compose up -d  （完全重启）
echo.
pause
