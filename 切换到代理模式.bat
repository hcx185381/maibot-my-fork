@echo off
chcp 65001 > nul
echo ================================================================================
echo                    MaiBot 切换到代理模式
echo ================================================================================
echo.
echo 此脚本将启用代理，让容器通过 Clash 访问 AI API
echo 适用于：网络环境不稳定或被阻止的情况
echo.
echo 前提条件:
echo   1. Clash Verge 必须运行
echo   2. 必须开启 "允许局域网连接" (Allow LAN)
echo   3. 端口必须是 7897
echo.
echo ================================================================================
echo.
pause

echo.
echo 正在启用代理配置...
powershell -Command "(Get-Content 'docker-compose.yml' -Raw) -replace '#\s*- HTTP_PROXY=http://172.30.240.1:7897', '- HTTP_PROXY=http://172.30.240.1:7897' -replace '#\s*- HTTPS_PROXY=http://172.30.240.1:7897', '- HTTPS_PROXY=http://172.30.240.1:7897' | Set-Content 'docker-compose.yml'"

echo ✓ 代理配置已启用
echo.
echo 正在重启容器...
docker-compose up -d core

echo.
echo ✓ 已切换到代理模式
echo.
echo 请确保:
echo   1. Clash Verge 正在运行
echo   2. 已开启 "允许局域网连接"
echo   3. 端口是 7897
echo.
pause
