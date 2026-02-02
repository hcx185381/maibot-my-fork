@echo off
chcp 65001
cls

echo ========================================
echo    MaiBot 命令行工具
echo ========================================
echo.
echo 正在进入MaiBot目录...
echo.

cd /d "E:\github ai xiangmu\MaiBot"

echo 当前目录: %CD%
echo.
echo ========================================
echo.
echo 您现在可以使用以下命令:
echo.
echo   docker-compose logs --tail=50 core
echo   docker-compose logs -f core
echo   docker-compose ps
echo   docker-compose restart core
echo.
echo ========================================
echo.
echo 输入 exit 退出窗口
echo.

cmd /k
