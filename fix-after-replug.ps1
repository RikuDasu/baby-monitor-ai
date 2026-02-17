# After USB replug: verify device, restart FrameServer, wait for driver
Write-Host "Checking camera device..."
$cam = Get-PnpDevice -Class Camera -ErrorAction SilentlyContinue
if ($cam) {
    Write-Host "  Found: $($cam.FriendlyName) - Status: $($cam.Status)"
} else {
    Write-Host "  WARNING: No camera device found! Wait and replug."
    exit 1
}

Write-Host "Restarting FrameServer..."
Restart-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5

Write-Host "FrameServer: $((Get-Service 'FrameServer').Status)"
Write-Host "Ready - try the camera now."
