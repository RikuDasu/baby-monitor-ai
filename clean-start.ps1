# Complete clean start: kill everything, restart services, launch app

# 1. Kill Chrome completely
Write-Host "Killing Chrome..."
taskkill /F /IM "chrome.exe" 2>$null
Start-Sleep -Seconds 2

# 2. Kill any remaining camera-hungry processes
Write-Host "Killing camera processes..."
$targets = @('logioptionsplus_agent','logioptionsplus_appbroker','logioptionsplus_updater',
    'LogiPluginService','LogiPluginServiceExt','LogiAiPromptBuilder','LogiOptions','LogiOptionsMgr','LogiOverlay',
    'DesktopVideoHelper','DesktopVideoUpdater',
    'VirtualDesktop.Service','platform_runtime_VR4U2P2_service',
    'WindowsCamera')
foreach ($t in $targets) { taskkill /F /IM "$t.exe" 2>$null }
Start-Sleep -Seconds 1

# 3. Restart FrameServer
Write-Host "Restarting FrameServer..."
Restart-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# 4. Verify clean state
$logi = Get-Process | Where-Object { $_.ProcessName -match 'logi' }
if ($logi) { Write-Host "WARNING: Logi still running!" } else { Write-Host "Logi: clear" }

$fs = Get-Service 'FrameServer'
Write-Host "FrameServer: $($fs.Status)"

# 5. Launch Chrome with ONLY the app
Write-Host "Launching Chrome (single tab)..."
Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "--new-window","https://rikudasu.github.io/baby-monitor-ai/"
Write-Host "Ready! Click the button NOW."
