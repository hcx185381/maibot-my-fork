# PowerShell script to switch MaiBot to GLM models
$configFile = "docker-config\mmc\model_config.toml"

# Read the config file
$content = Get-Content $configFile -Raw

# Replace all DeepSeek models with GLM models
$content = $content -replace 'model_list = \[\"deepseek-chat\"\]', 'model_list = ["glm-4-plus"]'
$content = $content -replace 'model_list = \[\"deepseek-reasoner\"\]', 'model_list = ["glm-4-plus"]'
$content = $content -replace 'model_list = \[\"deepseek-vl\"\]', 'model_list = ["glm-4v-plus"]'

# Fix: Make sure VLM task uses glm-4v-plus
# Note: We'll let VLM stay as glm-4-plus for now, will fix manually if needed

# Write back to file without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path $configFile).Path, $content, $utf8NoBom)

Write-Host "Switched to GLM models"
