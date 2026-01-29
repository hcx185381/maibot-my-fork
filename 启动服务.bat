@echo off
echo Starting MaiBot...
cd /d "%~dp0"
docker-compose up -d
echo.
echo ========================================
echo MaiBot Started!
echo ========================================
echo WebUI: http://localhost:8001
echo.
pause
