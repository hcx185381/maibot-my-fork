@echo off
chcp 65001 > nul
echo ================================================================================
echo                    MaiBot 切换到直连模式
echo ================================================================================
echo.
echo 此脚本将禁用代理，让容器直连 AI API
echo 适用于：网络环境良好的情况
echo.
echo ================================================================================
echo.

powershell -Command "(Get-Content 'docker-compose.yml' -Raw) -replace '^\s*- HTTP_PROXY=http://172.30.240.1:7897', '# - HTTP_PROXY=http://172.30.240.1:7897' -replace '^\s*- HTTPS_PROXY=http://172.30.240.1:7897', '# - HTTPS_PROXY=http://172.30.240.1:7897' | Set-Content 'docker-compose.yml'"

echo ✓ 代理配置已禁用
echo.
echo 正在重启容器...
docker-compose up -d core

echo.
echo ✓ 已切换到直连模式
echo.
echo 注意：如果机器人不回复，请运行 "切换到代理模式.bat"
echo.
pause
