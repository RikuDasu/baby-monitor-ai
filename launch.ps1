# 1. Kill Logi Options+ and related
Write-Host "Killing Logi processes..."
taskkill /F /IM "logioptionsplus_agent.exe" 2>$null
taskkill /F /IM "logioptionsplus_appbroker.exe" 2>$null
taskkill /F /IM "logioptionsplus_updater.exe" 2>$null
taskkill /F /IM "LogiPluginService.exe" 2>$null
taskkill /F /IM "LogiPluginServiceExt.exe" 2>$null
taskkill /F /IM "LogiAiPromptBuilder.exe" 2>$null

# 2. Restart Frame Server
Write-Host "Restarting FrameServer..."
Restart-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

# 3. Launch Chrome immediately
Write-Host "Launching Chrome..."
Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "https://rikudasu.github.io/baby-monitor-ai/"
Write-Host "Done! Click 'カメラ起動' immediately!"
