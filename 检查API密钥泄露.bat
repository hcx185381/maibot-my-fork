@echo off
chcp 65001
cls

echo ========================================
echo    检查Git历史中的API密钥
echo ========================================
echo.

cd /d "%~dp0"

echo 正在搜索Git历史中的API密钥...
echo.
echo ========================================
echo.

echo [1/2] 搜索GLM API密钥...
git log -S "89a2bbde7e784556a0bd2ba1b6403e53" --oneline
echo.

echo [2/2] 搜索DeepSeek API密钥...
git log -S "sk-d38850098a9540b7a88ded9e311f2a46" --oneline
echo.

echo ========================================
echo.

echo 检查敏感文件是否仍在仓库中...
echo.
git log --oneline -- docker-config/mmc/model_config.toml
echo.

echo ========================================
echo.
echo 说明:
echo - 如果显示提交记录，说明历史中仍有API密钥
echo - 最新版本(85a84fd6)已移除敏感文件
echo - 本地文件保留，MaiBot可正常使用
echo.
echo 按任意键退出...
pause >nul
