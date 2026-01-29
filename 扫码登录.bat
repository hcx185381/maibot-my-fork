@echo off
chcp 65001 >nul
echo ========================================
echo       MaiBot 扫码登录助手
echo ========================================
echo.

echo [1/3] 正在启动 MaiBot...
docker-compose up -d
echo.

echo [2/3] 等待服务启动（15秒）...
timeout /t 15 /nobreak >nul
echo.

echo [3/3] 正在获取二维码...
echo ========================================
echo.

REM 复制二维码图片
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
    echo 2. 按任意键刷新二维码
    echo 3. 或者扫码成功后按 Ctrl+C 退出
    echo.

    choice /c RN /n /m "按 R 刷新二维码，按 N 退出: "
    if errorlevel 2 goto :end
    if errorlevel 1 goto :refresh

    :refresh
    echo.
    echo 正在刷新二维码...
    docker restart maim-bot-napcat >nul
    echo 等待重新启动（5秒）...
    timeout /t 5 /nobreak >nul

    docker cp maim-bot-napcat:/app/napcat/cache/qrcode.png qrcode.png 2>nul
    if exist qrcode.png (
        echo ✅ 新二维码已获取！正在打开...
        echo 请尽快扫码（2-3分钟内有效）！
        start qrcode.png
        echo.
        goto :refresh
    ) else (
        echo ❌ 无法获取新二维码
        pause
    )
) else (
    echo ❌ 无法获取二维码图片
    echo.
    echo 查看最新日志：
    docker logs --tail 30 maim-bot-napcat
)

:end
echo.
echo ========================================
echo 扫码后按 Ctrl+C 可关闭此窗口
echo 或者按任意键退出...
pause >nul
