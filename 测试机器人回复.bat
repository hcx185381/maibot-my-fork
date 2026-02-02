@echo off
chcp 65001 > nul
echo ================================================================================
echo                       MaiBot 实时日志监控工具
echo ================================================================================
echo.
echo 正在监控 MaiBot 日志...
echo.
echo 请在 QQ 群中发送一条测试消息，然后查看日志输出。
echo.
echo 按 Ctrl+C 停止监控
echo.
echo ================================================================================
echo.

cd "E:\github ai xiangmu\MaiBot"
docker-compose logs -f --tail=50 core 2>&1 | findstr /i "ERROR WARNING planner replyer LLM"
