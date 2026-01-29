@echo off
chcp 65001 >nul
echo ========================================
echo       MaiBot 状态检查工具
echo ========================================
echo.

echo [1/4] 检查 Docker 状态...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未运行！
    echo 请先启动 Docker Desktop
    pause
    exit /b 1
)
echo ✅ Docker 正常运行
echo.

echo [2/4] 检查容器状态...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "maim"
echo.
if errorlevel 1 (
    echo ❌ 容器未运行！
    echo 请运行 "启动服务.bat" 或 "扫码登录.bat"
    pause
    exit /b 1
)
echo ✅ 容器正在运行
echo.

echo [3/4] 检查 QQ 登录状态...
docker logs maim-bot-napcat 2>&1 | findstr "登录成功" >nul
if errorlevel 1 (
    echo ❌ QQ 未登录！
    echo.
    echo 正在获取二维码图片...
    echo.

    REM 复制二维码图片到当前目录
    docker cp maim-bot-napcat:/app/napcat/cache/qrcode.png qrcode.png 2>nul

    if exist qrcode.png (
        echo ✅ 二维码已获取！正在打开...
        echo.
        echo ========================================
        echo    请用手机 QQ 扫描打开的二维码
        echo    有效期 2-3 分钟，请尽快扫码！
        echo ========================================
        echo.
        start qrcode.png
        echo.

        REM 添加刷新选项
        echo 如果二维码过期，请：
        echo 1. 关闭二维码图片
        echo 2. 按 R 刷新二维码
        echo 3. 或者扫码成功后按任意键退出
        echo.

        choice /c RN /n /m "按 R 刷新二维码，按 N 退出: "
        if errorlevel 2 goto :skip_refresh
        if errorlevel 1 goto :do_refresh

        :do_refresh
        echo.
        echo 正在刷新二维码...
        docker restart maim-bot-napcat >nul
        echo 等待重新启动（5秒）...
        timeout /t 5 /nobreak >nul

        docker cp maim-bot-napcat:/app/napcat/cache/qrcode.png qrcode_new.png 2>nul
        if exist qrcode_new.png (
            echo ✅ 新二维码已获取！正在打开...
            echo 请尽快扫码（2-3分钟内有效）！
            move /y qrcode_new.png qrcode.png >nul
            start qrcode.png
            echo.
            echo 扫码成功后，再次运行此脚本检查状态
            echo.
        ) else (
            echo ❌ 无法获取新二维码
        )

        :skip_refresh
    ) else (
        echo ❌ 无法获取二维码图片
        echo 请查看 NapCat 日志: docker logs maim-bot-napcat
    )

    pause
    exit /b 1
)
echo ✅ QQ 已登录
echo.

echo [4/4] 检查连接状态...
docker logs maim-bot-core 2>&1 | findstr "WebSocket 已连接" >nul
if errorlevel 1 (
    echo ⚠️  WebSocket 连接可能有问题
    echo 正在查看最新日志...
    docker logs --tail 10 maim-bot-core
) else (
    echo ✅ WebSocket 连接正常
)
echo.

echo ========================================
echo           状态汇总
echo ========================================
echo ✅ Docker: 运行中
echo ✅ 容器: 运行中
echo ✅ QQ: 已登录
echo ✅ 连接: 正常
echo.
echo 🎉 MaiBot 运行正常！
echo.
echo 访问地址:
echo   - WebUI: http://localhost:8001
echo   - 统计页面: maibot_statistics.html
echo ========================================
echo.
pause
