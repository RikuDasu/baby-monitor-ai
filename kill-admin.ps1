$targets = @(
    'LogiOptions', 'LogiOptionsMgr', 'logioptionsplus_agent', 'logioptionsplus_appbroker',
    'logioptionsplus_updater', 'LogiOverlay', 'LogiPluginService', 'LogiPluginServiceExt',
    'LogiAiPromptBuilder',
    'DesktopVideoHelper', 'DesktopVideoUpdater',
    'VirtualDesktop.Service', 'platform_runtime_VR4U2P2_service',
    'StreamDeck', 'WindowsCamera'
)
foreach ($name in $targets) {
    $p = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($p) {
        taskkill /F /IM "$name.exe" 2>$null
        Write-Host "taskkill: $name"
    }
}
Start-Sleep 3
Write-Host "`nRemaining:"
Get-Process | Where-Object {
    $_.ProcessName -match 'logi|bmd|desktop.?video|virtual.?desktop|platform_runtime|streamdeck|camera'
} | Select-Object ProcessName, Id | Format-Table -AutoSize
