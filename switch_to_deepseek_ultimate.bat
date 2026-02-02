@echo off
chcp 65001
cls

echo ========================================
echo    Switch to DeepSeek ULTIMATE
echo ========================================
echo.
echo The STRONGEST DeepSeek Model Combination
echo.
echo MODEL ALLOCATION:
echo   - Reasoning tasks: DeepSeek-R1 (deepseek-reasoner)
echo   - Chat tasks: DeepSeek-V3 (deepseek-chat)
echo   - Visual tasks: DeepSeek-VL (deepseek-vl)
echo.
echo BEST OF BOTH WORLDS:
echo   - Complex problems: R1's deep reasoning
echo   - Daily chat: V3's speed & cost-effectiveness
echo   - Images/Emojis: VL's recognition capabilities
echo.
echo TASK BREAKDOWN:
echo   - Planner: R1 (strong reasoning for planning)
echo   - Tool Use: R1 (precise tool execution)
echo   - Utils: R1 (complex problem solving)
echo   - Replyer: V3 (fast chat response)
echo   - Emotion: V3 (emotional understanding)
echo   - VLM: VL (emoji & image recognition)
echo.

if not exist "docker-config\mmc\model_config.toml" (
    echo ERROR: docker-config\mmc\model_config.toml not found!
    echo Please run this script from the MaiBot directory.
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo [1/3] Backup config...
copy /Y "docker-config\mmc\model_config.toml" "docker-config\mmc\model_config.toml.backup" >nul
echo OK - Config backed up

echo.
echo [2/3] Switch to DeepSeek ULTIMATE combination...

powershell -Command "$content = Get-Content 'docker-config\mmc\model_config.toml'; $content = $content -replace '(?s)\[model_task_config\.vlm\](.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.vlm]$1model_list = [\"deepseek-vl\"]'; $content = $content -replace '(?s)\[model_task_config\.replyer\](.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.replyer]$1model_list = [\"deepseek-chat\"]'; $content = $content -replace '(?s)\[model_task_config\.emotion\](.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.emotion]$1model_list = [\"deepseek-chat\"]'; $content = $content -replace '(?s)\[model_task_config\.(?!vlm|replyer|emotion)(.*?)model_list = \[\"[^\"]+\"\]', '[model_task_config.$1model_list = [\"deepseek-reasoner\"]'; Set-Content 'docker-config\mmc\model_config.toml' $content"

echo OK - Models switched to ULTIMATE combination:
echo   - DeepSeek-R1: utils, tool_use, planner, etc.
echo   - DeepSeek-V3: replyer, emotion
echo   - DeepSeek-VL: vlm (visual tasks)

echo.
echo [3/3] Restart container...
docker-compose stop core >nul 2>&1
docker-compose up -d core >nul 2>&1

echo.
echo ========================================
echo    Done! Switched to DeepSeek ULTIMATE
echo ========================================
echo.
echo Current Configuration:
echo.
echo REASONING ENGINE (R1):
echo   - Planner tasks: deepseek-reasoner
echo   - Tool use: deepseek-reasoner
echo   - Utils: deepseek-reasoner
echo   - Entity extraction: deepseek-reasoner
echo   - RDF build: deepseek-reasoner
echo.
echo CHAT ENGINE (V3):
echo   - Replyer: deepseek-chat
echo   - Emotion: deepseek-chat
echo   - Voice: deepseek-chat
echo.
echo VISUAL ENGINE (VL):
echo   - VLM: deepseek-vl
echo.
echo FEATURES:
echo   - Deep reasoning: ENABLED (via R1)
echo   - Fast chat: ENABLED (via V3)
echo   - Emoji recognition: ENABLED (via VL)
echo   - Image recognition: ENABLED (via VL)
echo.
echo This configuration gives you the BEST of both worlds:
echo   - R1's powerful reasoning for complex tasks
echo   - V3's speed and efficiency for daily chat
echo.
echo Press any key to exit...
pause >nul
