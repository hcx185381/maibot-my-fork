@echo off
echo Stopping MaiBot...
cd /d "%~dp0"
docker-compose down
echo.
echo ========================================
echo MaiBot Stopped!
echo ========================================
echo.
pause
