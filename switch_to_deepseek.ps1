# PowerShell script to switch MaiBot to DeepSeek models
$configFile = "docker-config\mmc\model_config.toml"

# Read the config file
$content = Get-Content $configFile -Raw

# Replace all GLM models with DeepSeek models
$content = $content -replace 'model_list = \[\"glm-4-plus\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4-air\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4v-plus\"\]', 'model_list = ["deepseek-vl"]'

# Now replace specific tasks with deepseek-reasoner
$content = $content -replace '(?s)\[model_task_config\.tool_use\]\s*model_list = \[\"deepseek-chat\"\](\s*temperature =[\s\S]*?selection_strategy = "random")', '[model_task_config.tool_use]
model_list = ["deepseek-reasoner"]$1'

$content = $content -replace '(?s)\[model_task_config\.planner\]\s*model_list = \[\"deepseek-chat\"\](\s*temperature =[\s\S]*?selection_strategy = "random")', '[model_task_config.planner]
model_list = ["deepseek-reasoner"]$1'

$content = $content -replace '(?s)\[model_task_config\.planner_small\]\s*model_list = \[\"deepseek-chat\"\](\s*temperature =[\s\S]*?selection_strategy = "random")', '[model_task_config.planner_small]
model_list = ["deepseek-reasoner"]$1'

# Write back to file without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path $configFile).Path, $content, $utf8NoBom)

Write-Host "Configuration updated successfully"
