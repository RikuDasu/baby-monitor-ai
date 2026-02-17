# Kill all processes that might be holding the camera
$targets = @(
    'LogiOptions', 'LogiOptionsMgr', 'logioptionsplus_agent', 'logioptionsplus_appbroker',
    'logioptionsplus_updater', 'LogiOverlay', 'LogiPluginService', 'LogiPluginServiceExt',
    'LogiAiPromptBuilder',
    'DesktopVideoHelper', 'DesktopVideoUpdater',
    'VirtualDesktop.Service', 'platform_runtime_VR4U2P2_service',
    'StreamDeck', 'WindowsCamera'
)

foreach ($name in $targets) {
    $procs = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($procs) {
        Stop-Process -Name $name -Force -ErrorAction SilentlyContinue
        Write-Host "Killed: $name (PID: $($procs.Id -join ', '))"
    }
}

Write-Host ""
Write-Host "Done. Remaining camera-related processes:"
Get-Process | Where-Object {
    $_.ProcessName -match 'logi|bmd|blackmagic|desktop.?video|virtual.?desktop|platform_runtime|streamdeck|camera'
} | Select-Object ProcessName, Id | Format-Table -AutoSize

if (-not (Get-Process | Where-Object { $_.ProcessName -match 'logi|bmd|blackmagic|desktop.?video|virtual.?desktop|platform_runtime|camera' })) {
    Write-Host "All clear!"
}
