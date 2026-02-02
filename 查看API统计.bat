@echo off
chcp 65001
cls

echo ========================================
echo      MaiBot API使用统计
echo ========================================
echo.

cd /d "%~dp0"

echo 正在分析API调用统计...
echo.
echo ========================================
echo.

docker-compose logs core | grep -E "模型名称|累计花费|调用次数" | tail -20

echo.
echo ========================================
echo.
echo 按任意键退出...
pause >nul
