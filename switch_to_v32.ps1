# PowerShell script to switch MaiBot to DeepSeek-V3.2 (deepseek-chat) only
$configFile = "docker-config\mmc\model_config.toml"

# Read the config file
$content = Get-Content $configFile -Raw

# Replace all GLM models with deepseek-chat
$content = $content -replace 'model_list = \[\"glm-4-plus\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4-air\"\]', 'model_list = ["deepseek-chat"]'
$content = $content -replace 'model_list = \[\"glm-4v-plus\"\]', 'model_list = ["deepseek-chat"]'

# Replace all deepseek-reasoner with deepseek-chat
$content = $content -replace 'model_list = \[\"deepseek-reasoner\"\]', 'model_list = ["deepseek-chat"]'

# Replace all deepseek-vl with deepseek-chat
$content = $content -replace 'model_list = \[\"deepseek-vl\"\]', 'model_list = ["deepseek-chat"]'

# Write back to file without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path $configFile).Path, $content, $utf8NoBom)

Write-Host "All tasks switched to DeepSeek-V3.2 (deepseek-chat)"
