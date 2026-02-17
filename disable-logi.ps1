# Find and disable Logi Options+ auto-start mechanisms

# 1. Scheduled Tasks
Write-Host "=== Scheduled Tasks ==="
Get-ScheduledTask | Where-Object { $_.TaskName -match 'logi' } | ForEach-Object {
    Write-Host "  Disabling task: $($_.TaskName)"
    Disable-ScheduledTask -TaskName $_.TaskName -ErrorAction SilentlyContinue
}

# 2. Services
Write-Host "`n=== Services ==="
Get-Service | Where-Object { $_.DisplayName -match 'logi' } | ForEach-Object {
    Write-Host "  Stopping and disabling service: $($_.DisplayName) ($($_.Name))"
    Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue
    Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
}

# 3. Startup registry entries
Write-Host "`n=== Registry Run keys ==="
$runPaths = @(
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'
)
foreach ($path in $runPaths) {
    $props = Get-ItemProperty $path -ErrorAction SilentlyContinue
    $props.PSObject.Properties | Where-Object { $_.Name -match 'logi' -and $_.Name -notmatch 'PS' } | ForEach-Object {
        Write-Host "  Removing: $path\$($_.Name) = $($_.Value)"
        Remove-ItemProperty -Path $path -Name $_.Name -ErrorAction SilentlyContinue
    }
}

# 4. Kill all remaining Logi processes
Write-Host "`n=== Killing processes ==="
taskkill /F /IM "logioptionsplus_agent.exe" 2>$null
taskkill /F /IM "logioptionsplus_appbroker.exe" 2>$null
taskkill /F /IM "logioptionsplus_updater.exe" 2>$null
taskkill /F /IM "LogiPluginService.exe" 2>$null
taskkill /F /IM "LogiPluginServiceExt.exe" 2>$null
taskkill /F /IM "LogiAiPromptBuilder.exe" 2>$null
taskkill /F /IM "LogiOptions.exe" 2>$null
taskkill /F /IM "LogiOptionsMgr.exe" 2>$null
taskkill /F /IM "LogiOverlay.exe" 2>$null

Start-Sleep 2

# 5. Restart FrameServer
Restart-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# 6. Verify
Write-Host "`n=== Remaining Logi processes ==="
$remaining = Get-Process | Where-Object { $_.ProcessName -match 'logi' }
if ($remaining) {
    $remaining | Select-Object ProcessName, Id | Format-Table
} else {
    Write-Host "  All clear!"
}

Write-Host "`nDone. Logi Options+ auto-start disabled."
Write-Host "To re-enable later, re-enable the scheduled tasks and services."
