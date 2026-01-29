@echo off
chcp 65001 >nul
title Git 版本回退工具
cd /d "%~dp0"

:menu
cls
echo.
echo ========================================
echo   Git 版本回退工具
echo ========================================
echo.
echo ⚠️  警告：版本回退会改变代码历史，请谨慎操作！
echo.
echo 请选择回退方式：
echo.
echo [1] 查看旧版本（不修改任何东西，最安全）
echo [2] 软回退 - 保留文件内容，只回退提交记录（推荐）
echo [3] 混合回退 - 回退提交+工作区（常用）
echo [4] 硬回退 - 完全回到旧版本（危险！）
echo [5] 撤销某次提交（创建新提交来撤销，安全）
echo [6] 查看提交历史选择要回退的版本
echo [7] 恢复到回退前的状态（后悔药）
echo [0] 退出
echo.
set /p choice="请输入选项 (0-7): "

if "%choice%"=="1" goto view_old
if "%choice%"=="2" goto soft_reset
if "%choice%"=="3" goto mixed_reset
if "%choice%"=="4" goto hard_reset
if "%choice%"=="5" goto revert_commit
if "%choice%"=="6" goto view_history
if "%choice%"=="7" goto restore
if "%choice%"=="0" goto end
goto menu

:view_old
cls
echo ========================================
echo   查看旧版本（不修改任何东西）
echo ========================================
echo.
echo 这种方式只是"查看"，不会修改任何文件！
echo.
set /p commit_id="请输入要查看的提交ID（或按 Enter 查看最近10次）: "
if "%commit_id%"=="" (
    echo.
    echo 最近 10 次提交：
    echo.
    git log --oneline -10
    echo.
    set /p commit_id="请输入提交ID: "
)
echo.
echo 正在查看提交: %commit_id%
echo.
echo ========================================
echo 该次提交修改的文件列表：
echo ========================================
git show --name-only %commit_id%
echo.
echo ========================================
echo 该次提交的详细信息：
echo ========================================
git show %commit_id% --stat
echo.
pause
goto menu

:soft_reset
cls
echo ========================================
echo   软回退（推荐，最安全）⭐⭐⭐⭐⭐
echo ========================================
echo.
echo 软回退会：
echo ✅ 保留当前文件的所有内容
echo ✅ 只回退提交记录
echo ✅ 如果后悔了，可以轻松恢复
echo.
echo 适用场景：
echo - 发现最后一次提交有问题，想重新提交
echo - 想合并多个提交为一个
echo - 修改了最后一次提交的说明
echo.
set /p commit_id="请输入要回退到的提交ID: "
if "%commit_id%"=="" goto menu
echo.
echo ⚠️  即将执行软回退到: %commit_id%
echo.
set /p confirm="确认执行？输入 YES 继续: "
if not "%confirm%"=="YES" goto menu
echo.
echo 正在备份当前状态...
git reflog expire --expire=now >nul 2>&1
echo.
echo 执行软回退...
git reset --soft %commit_id%
echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ 软回退成功！
    echo.
    echo 当前状态：
    echo - 所有文件内容保持不变
    echo - 之前的修改变成了"未提交的更改"
    echo - 您可以重新编辑后再次提交
    echo.
    git status --short
) else (
    echo ❌ 回退失败！
)
echo.
pause
goto menu

:mixed_reset
cls
echo ========================================
echo   混合回退（常用）⭐⭐⭐⭐
echo ========================================
echo.
echo 混合回退会：
echo ⚠️  回退提交记录
echo ⚠️  回退工作区文件（但保留新增文件）
echo ✅ 如果后悔了，可以恢复
echo.
echo 适用场景：
echo - 想丢弃某个版本的更改
echo - 想回到之前的某个状态重新开始
echo.
set /p commit_id="请输入要回退到的提交ID: "
if "%commit_id%"=="" goto menu
echo.
echo ⚠️  即将执行混合回退到: %commit_id%
echo.
echo 这个操作会：
echo - 回退到该版本的提交状态
echo - 保留您新增的文件（未跟踪的文件）
echo - 该版本之后的修改都会被丢弃
echo.
set /p confirm="确认执行？输入 YES 继续: "
if not "%confirm%"=="YES" goto menu
echo.
echo 执行混合回退...
git reset --mixed %commit_id%
echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ 混合回退成功！
    echo.
    git status --short
) else (
    echo ❌ 回退失败！
)
echo.
pause
goto menu

:hard_reset
cls
echo ========================================
echo   硬回退（危险！）⚠️⚠️⚠️
echo ========================================
echo.
echo ⚠️⚠️⚠️  警告：硬回退会丢弃所有更改！⚠️⚠️⚠️
echo.
echo 硬回退会：
echo ❌ 回退提交记录
echo ❌ 回退工作区文件
echo ❌ 丢弃所有更改（包括新增文件）
echo ⚠️  只有 reflog 可以恢复
echo.
echo 适用场景：
echo - 确定要完全丢弃某些版本
echo - 项目搞乱了，想彻底重来
echo.
set /p commit_id="请输入要回退到的提交ID: "
if "%commit_id%"=="" goto menu
echo.
echo ========================================
echo ⚠️⚠️⚠️  危险操作警告 ⚠️⚠️⚠️
echo ========================================
echo.
echo 即将执行硬回退到: %commit_id%
echo.
echo 这将：
echo - 完全丢弃 %commit_id% 之后的所有更改
echo - 删除所有未提交的修改
echo - 删除所有新增的文件
echo.
echo 在执行前，建议先查看当前状态：
git status --short
echo.
set /p confirm="如果您确定要执行，请输入 I UNDERSTAND: "
if not "%confirm%"=="I UNDERSTAND" (
    echo 已取消操作。
    pause
    goto menu
)
echo.
set /p confirm2="最后确认：输入 YES 执行硬回退: "
if not "%confirm2%"=="YES" goto menu
echo.
echo 执行硬回退...
git reset --hard %commit_id%
echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ 硬回退成功！
    echo.
    git log --oneline -3
) else (
    echo ❌ 回退失败！
)
echo.
pause
goto menu

:revert_commit
cls
echo ========================================
echo   撤销某次提交（安全）⭐⭐⭐⭐⭐
echo ========================================
echo.
echo 撤销提交会：
echo ✅ 创建一个新提交来撤销旧提交的更改
echo ✅ 保留完整的历史记录
echo ✅ 最安全的方式，推荐使用
echo.
echo 适用场景：
echo - 发现某个提交有bug，想撤销它
echo - 想保留所有历史记录
echo.
set /p commit_id="请输入要撤销的提交ID: "
if "%commit_id%"=="" goto menu
echo.
echo 即将撤销提交: %commit_id%
echo.
echo 这将创建一个新提交，该提交的更改会撤销 %commit_id% 的效果
echo.
set /p confirm="确认执行？输入 YES 继续: "
if not "%confirm%"=="YES" goto menu
echo.
echo 执行撤销...
git revert %commit_id% --no-edit
echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ 撤销成功！
    echo.
    echo 创建了新提交来撤销旧的更改
    echo.
    git log --oneline -3
) else (
    echo ❌ 撤销失败！
    echo.
    echo 可能需要手动解决冲突
)
echo.
pause
goto menu

:view_history
cls
echo ========================================
echo   查看提交历史
echo ========================================
echo.
echo 请选择查看方式：
echo.
echo [1] 简洁版（最近10次）
echo [2] 详细版（最近5次）
echo [3] 图形版（所有历史）
echo [0] 返回
echo.
set /p view_choice="请输入选项: "
if "%view_choice%"=="1" (
    cls
    git log --oneline -10 --graph --decorate
    pause
    goto menu
)
if "%view_choice%"=="2" (
    cls
    git log -5 --pretty=format:"%%h - %%an, %%ar : %%s"
    pause
    goto menu
)
if "%view_choice%"=="3" (
    cls
    echo 正在打开浏览器查看历史...
    start https://github.com/hcx185381/maibot-my-fork/commits/main
    pause
    goto menu
)
if "%view_choice%"=="0" goto menu
goto view_history

:restore
cls
echo ========================================
echo   恢复到回退前的状态（后悔药）
echo ========================================
echo.
echo 这个功能可以帮您找回回退之前的版本
echo.
echo 查看最近的操作记录：
echo.
git reflog -10
echo.
echo.
set /p ref_id="请输入要恢复到的 ref ID（或按 Enter 返回）: "
if "%ref_id%"=="" goto menu
echo.
echo 即将恢复到: %ref_id%
echo.
set /p confirm="确认执行？输入 YES 继续: "
if not "%confirm%"=="YES" goto menu
echo.
echo 执行恢复...
git reset --hard %ref_id%
echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ 恢复成功！
    echo.
    git log --oneline -3
) else (
    echo ❌ 恢复失败！
)
echo.
pause
goto menu

:end
cls
echo.
echo 感谢使用！
echo.
echo 💡 提示：
echo - 所有回退操作都可以用 reflog 恢复（除非用了 --clean）
echo - 不确定的话，先用"查看旧版本"功能看看
echo - 重要操作前建议先备份或创建新分支
echo.
timeout /t 3 >nul
exit
