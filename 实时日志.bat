@echo off
chcp 65001
cls

echo ========================================
echo     MaiBot 实时日志监控
echo ========================================
echo.
echo 按 Ctrl+C 停止监控
echo.

cd /d "%~dp0"

docker-compose logs -f core
