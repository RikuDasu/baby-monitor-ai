Write-Host "=== Camera-related processes ==="
$keywords = 'obs|zoom|teams|discord|skype|camera|snap|stream|virtual|vcam|droid|meet|webex|slack|pico|vr'
Get-Process | Where-Object { $_.ProcessName -match $keywords } | Select-Object ProcessName, Id | Format-Table

Write-Host "=== Windows Camera Privacy (Desktop apps) ==="
$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\NonPackaged"
if (Test-Path $path) {
    Get-ChildItem $path | ForEach-Object {
        $props = Get-ItemProperty $_.PSPath
        Write-Host "  $($_.PSChildName) = $($props.Value)"
    }
} else {
    Write-Host "  No NonPackaged entries"
}

Write-Host ""
Write-Host "=== Chrome version ==="
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    (Get-Item $chromePath).VersionInfo.ProductVersion
}

Write-Host ""
Write-Host "=== Device status ==="
Get-PnpDevice -Class Camera | Select-Object FriendlyName, Status | Format-Table
