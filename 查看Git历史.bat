@echo off
chcp 65001 >nul
title Git 历史记录查看工具
cd /d "%~dp0"

:menu
cls
echo.
echo ========================================
echo   Git 历史记录查看工具
echo ========================================
echo.
echo 请选择要查看的内容：
echo.
echo [1] 查看最近 10 次提交（简洁版）
echo [2] 查看最近 5 次提交（详细版）
echo [3] 查看某次提交的详细信息
echo [4] 查看某个文件的修改历史
echo [5] 对比两个版本的差异
echo [6] 查看某个提交改了什么文件
echo [7] 搜索提交记录（按关键词）
echo [8] 图形化查看历史（推荐）
echo [0] 退出
echo.
set /p choice="请输入选项 (0-8): "

if "%choice%"=="1" goto simple
if "%choice%"=="2" goto detail
if "%choice%"=="3" goto commit_info
if "%choice%"=="4" goto file_history
if "%choice%"=="5" goto compare
if "%choice%"=="6" goto commit_files
if "%choice%"=="7" goto search
if "%choice%"=="8" goto gui
if "%choice%"=="0" goto end
goto menu

:simple
cls
echo ========================================
echo   最近 10 次提交（简洁版）
echo ========================================
echo.
git log --oneline -10 --graph --decorate
echo.
pause
goto menu

:detail
cls
echo ========================================
echo   最近 5 次提交（详细版）
echo ========================================
echo.
git log -5 --pretty=format:"%%h - %%an, %%ar : %%s" --stat
echo.
pause
goto menu

:commit_info
cls
echo ========================================
echo   查看某次提交的详细信息
echo ========================================
echo.
set /p commit_id="请输入提交ID（按 Enter 返回）: "
if "%commit_id%"=="" goto menu
echo.
echo 正在查看提交: %commit_id%
echo.
git show %commit_id% --stat
echo.
pause
goto menu

:file_history
cls
echo ========================================
echo   查看某个文件的修改历史
echo ========================================
echo.
set /p file_path="请输入文件路径（如 docker-compose.yml）: "
if "%file_path%"=="" goto menu
echo.
echo 正在查看文件历史: %file_path%
echo.
git log --oneline --follow -- %file_path% | head -10
echo.
echo.
set /p view_diff="是否查看详细差异？(Y/N): "
if /i "%view_diff%"=="Y" (
    echo.
    git log --patch -10 -- %file_path%
)
echo.
pause
goto menu

:compare
cls
echo ========================================
echo   对比两个版本的差异
echo ========================================
echo.
echo 提示：
echo - HEAD 表示最新版本
echo - HEAD~1 表示上一个版本
echo - HEAD~5 表示往前第5个版本
echo.
set /p version1="请输入第一个版本（如 HEAD~1）: "
set /p version2="请输入第二个版本（如 HEAD）: "
if "%version1%"=="" set version1=HEAD~1
if "%version2%"=="" set version2=HEAD
echo.
echo 正在对比: %version1% vs %version2%
echo.
git diff %version1%..%version2% --stat
echo.
echo.
set /p view_detail="是否查看详细差异？(Y/N): "
if /i "%view_detail%"=="Y" (
    echo.
    git diff %version1%..%version2%
)
echo.
pause
goto menu

:commit_files
cls
echo ========================================
echo   查看某个提交改了什么文件
echo ========================================
echo.
set /p commit_id="请输入提交ID: "
if "%commit_id%"=="" goto menu
echo.
git show --name-only %commit_id%
echo.
pause
goto menu

:search
cls
echo ========================================
echo   搜索提交记录
echo ========================================
echo.
set /p keyword="请输入搜索关键词: "
if "%keyword%"=="" goto menu
echo.
echo 正在搜索: %keyword%
echo.
git log --all --oneline --grep="%keyword%"
echo.
pause
goto menu

:gui
cls
echo ========================================
echo   图形化查看历史
echo ========================================
echo.
echo 正在启动 Git 图形化工具...
echo.

REM 尝试启动 gitk
where gitk >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start gitk
    echo 已启动 Gitk（Git 自带的图形化工具）
    goto after_gui
)

REM 尝试启动 GitHub Desktop
where github >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start github
    echo 已启动 GitHub Desktop
    goto after_gui
)

REM 都没有，提示安装
echo.
echo ❌ 未检测到 Git 图形化工具
echo.
echo 推荐安装以下工具之一：
echo.
echo 1. Gitk（Git 自带，最简单）
echo    下载: https://git-scm.com/downloads
echo.
echo 2. GitHub Desktop（官方客户端）
echo    下载: https://desktop.github.com/
echo.
echo 3. SourceTree（功能强大）
echo    下载: https://www.sourcetreeapp.com/
echo.
echo 4. 在线查看（最简单）:
echo    访问: https://github.com/hcx185381/maibot-my-fork/commits/main
echo.

:after_gui
echo.
echo 或者直接在浏览器中查看：
echo https://github.com/hcx185381/maibot-my-fork/commits/main
echo.
pause
goto menu

:end
cls
echo.
echo 感谢使用！
echo.
timeout /t 2 >nul
exit
