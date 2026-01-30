@echo off
chcp 65001 >nul
title MaiBot 网络诊断与自动修复工具
color 0B

echo.
echo ================================================================================
echo                        MaiBot 网络诊断与自动修复工具
echo ================================================================================
echo.
echo 此工具将自动诊断并修复 MaiBot 的网络连接问题
echo 适用于：家庭网络、校园网、公司网络等任何网络环境
echo.
echo ================================================================================
echo.

REM 步骤1：检查Docker是否运行
echo [1/6] 检查 Docker Desktop 是否运行...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop 未运行！
    echo.
    echo 请先启动 Docker Desktop，然后重新运行此脚本
    echo.
    pause
    exit /b 1
)
echo ✅ Docker Desktop 正在运行
echo.

REM 步骤2：检查代理是否运行
echo [2/6] 检查代理软件 (Clash) 是否运行...
netstat -ano | findstr ":7897" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo ❌ 代理软件未在端口 7897 上运行！
    echo.
    echo 请启动 Clash Verge 并确认：
    echo   - HTTP 代理端口设置为 7897
    echo   - "允许局域网连接"已开启
    echo.
    pause
    exit /b 1
)
echo ✅ 代理软件正在运行 (端口 7897)
echo.

REM 步骤3：自动检测最佳代理IP
echo [3/6] 自动检测最佳代理地址...

REM 检测WSL网关IP
set PROXY_IP=172.30.240.1
set PROXY_FOUND=0

REM 测试WSL网关
ping -n 1 172.30.240.1 >nul 2>&1
if not errorlevel 1 (
    set PROXY_IP=172.30.240.1
    set PROXY_FOUND=1
    echo ✅ 找到 WSL 网关: 172.30.240.1
)

REM 如果WSL不可用，尝试Docker网关
if %PROXY_FOUND%==0 (
    docker network inspect maibot_maim_bot --format "{{json .IPAM.Config}}" >tmp_network.txt 2>nul
    if exist tmp_network.txt (
        for /f "tokens=2 delims=:," %%a in ('findstr "Gateway" tmp_network.txt') do (
            set GATEWAY_IP=%%a
            set GATEWAY_IP=!GATEWAY_IP: =!
        )
        if defined GATEWAY_IP (
            set PROXY_IP=!GATEWAY_IP!
            set PROXY_FOUND=1
            echo ✅ 找到 Docker 网关: !GATEWAY_IP!
        )
        del tmp_network.txt
    )
)

if %PROXY_FOUND%==0 (
    echo ⚠️  无法自动检测网关IP，使用默认值 172.30.240.1
    set PROXY_IP=172.30.240.1
)

echo    代理地址: http://%PROXY_IP%:7897
echo.

REM 步骤4：测试容器到代理的连接
echo [4/6] 测试 Docker 容器到代理的连接...
docker exec maim-bot-core python -c "import socket; s=socket.socket(); s.settimeout(3); r=s.connect_ex(('%PROXY_IP%', 7897)); s.close(); exit(0 if r==0 else 1)" >nul 2>&1
if errorlevel 1 (
    echo ❌ 容器无法连接到代理！
    echo.
    echo 可能的原因：
    echo   1. 代理软件未开启"允许局域网连接"
    echo   2. 防火墙阻止了连接
    echo   3. 网络环境特殊（如严格的校园网）
    echo.
    echo 尝试解决方案...
    echo.

    REM 尝试修复docker-compose.yml
    echo    正在更新代理配置...
    powershell -Command "(Get-Content 'docker-compose.yml') -replace 'HTTP_PROXY=http://[0-9.]+:7897', 'HTTP_PROXY=http://%PROXY_IP%:7897' -replace 'HTTPS_PROXY=http://[0-9.]+:7897', 'HTTPS_PROXY=http://%PROXY_IP%:7897' | Set-Content 'docker-compose.yml'"

    echo    ✅ 代理配置已更新为: http://%PROXY_IP%:7897
    echo.
    echo    正在重启 Docker 容器...
    docker-compose down >nul 2>&1
    docker-compose up -d >nul 2>&1
    timeout /t 5 /nobreak >nul

    REM 重新测试
    docker exec maim-bot-core python -c "import socket; s=socket.socket(); s.settimeout(3); r=s.connect_ex(('%PROXY_IP%', 7897)); s.close(); exit(0 if r==0 else 1)" >nul 2>&1
    if errorlevel 1 (
        echo ❌ 修复失败！
        echo.
        echo 请手动检查：
        echo   1. Clash Verge 的"允许局域网连接"是否开启
        echo   2. Windows 防火墙是否允许 Docker 网络
        echo   3. 校园网是否有特殊限制
        echo.
        pause
        exit /b 1
    ) else (
        echo ✅ 修复成功！容器可以连接到代理
    )
) else (
    echo ✅ 容器可以连接到代理
)
echo.

REM 步骤5：测试AI API连接
echo [5/6] 测试 AI API 连接...
docker exec maim-bot-core python -c "import os, urllib.request; os.environ['HTTPS_PROXY']='http://%PROXY_IP%:7897'; urllib.request.urlopen('https://open.bigmodel.cn', timeout=10)" >nul 2>&1
if errorlevel 1 (
    echo ❌ 无法连接到 AI API！
    echo.
    echo 可能的原因：
    echo   - 代理本身无法访问外网
    echo   - API 服务器暂时不可用
    echo.
    echo 请检查：
    echo   1. 代理软件是否正常工作
    echo   2. 浏览器能否通过代理访问 https://open.bigmodel.cn
    echo.
) else (
    echo ✅ 可以连接到 AI API
)
echo.

REM 步骤6：检查MaiBot运行状态
echo [6/6] 检查 MaiBot 运行状态...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "maim-bot"
echo.

echo ================================================================================
echo                                    诊断完成
echo ================================================================================
echo.
echo 📝 网络配置摘要：
echo    代理地址: http://%PROXY_IP%:7897
echo    Docker网络: maibot_maim_bot
echo.
echo 💡 提示：
echo    - 如果切换到其他网络（如校园网），请重新运行此脚本
echo    - 如果遇到问题，请检查日志：docker logs maim-bot-core
echo    - WebUI 管理界面：http://localhost:8001
echo.
pause
