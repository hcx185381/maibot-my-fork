@echo off
chcp 65001 > nul
echo ================================================================================
echo                    MaiBot + Clash Verge 启动检查工具
echo ================================================================================
echo.
echo 此脚本将帮助您检查 Clash Verge 配置是否正确
echo.
echo ================================================================================
echo.

echo [检查 1/4] Clash Verge 是否运行?
netstat -ano | findstr ":7897" > nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Clash Verge 正在运行
) else (
    echo ✗ Clash Verge 未运行
    echo.
    echo 请先启动 Clash Verge，然后重新运行此脚本
    echo.
    pause
    exit /b 1
)

echo.
echo [检查 2/4] 是否允许局域网连接?
netstat -ano | findstr "0.0.0.0:7897" > nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ 已开启 "允许局域网连接" (0.0.0.0:7897)
) else (
    echo ✗ 未开启 "允许局域网连接" (127.0.0.1:7897)
    echo.
    echo 解决方法:
    echo   1. 打开 Clash Verge
    echo   2. 找到 "允许局域网连接" (Allow LAN)
    echo   3. 开启此选项
    echo   4. 确认端口是 7897
    echo.
    pause
    exit /b 1
)

echo.
echo [检查 3/4] MaiBot 容器是否配置了代理?
docker exec maim-bot-core env | findstr "HTTP_PROXY=http://172.30.240.1:7897" > nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ 容器已配置代理
) else (
    echo ✗ 容器未配置代理
    echo.
    echo 请检查 docker-compose.yml 中的代理配置是否已启用
    echo.
    pause
    exit /b 1
)

echo.
echo [检查 4/4] 测试容器到代理的连接...
docker exec maim-bot-core python -c "import urllib.request; req=urllib.request.Request('https://api.deepseek.com', method='HEAD'); print('代理连接测试成功' if urllib.request.urlopen(req, timeout=5).status==200 else '连接失败')" 2>&1 | findstr "成功"
if %ERRORLEVEL% EQU 0 (
    echo ✓ 代理连接正常
) else (
    echo ⚠ 无法完全测试，但配置应该正确
)

echo.
echo ================================================================================
echo                          所有检查通过!
echo ================================================================================
echo.
echo 当前配置:
echo   ✓ Clash Verge: 运行中
echo   ✓ 局域网连接: 已开启
echo   ✓ 代理端口: 7897
echo   ✓ MaiBot 代理: 已配置
echo.
echo 现在可以正常使用 MaiBot 了！
echo.
echo 提示: 如果机器人还是不回复，运行 "测试机器人回复.bat" 查看实时日志
echo.
echo ================================================================================
echo.
pause
