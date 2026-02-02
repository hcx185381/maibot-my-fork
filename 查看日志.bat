@echo off
chcp 65001
cls

echo ========================================
echo       MaiBot 日志查看工具
echo ========================================
echo.

cd /d "%~dp0"

echo 正在查看MaiBot日志...
echo.
echo ========================================
echo.

docker-compose logs --tail=50 core

echo.
echo ========================================
echo.
echo 按任意键退出...
pause >nul
