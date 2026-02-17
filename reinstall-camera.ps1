# Complete camera driver reinstall

# 1. Stop FrameServer
Stop-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue

# 2. Get device
$cam = Get-PnpDevice -Class Camera | Select-Object -First 1
Write-Host "Device: $($cam.FriendlyName) [$($cam.InstanceId)]"

# 3. Completely remove the device (driver will be reinstalled on scan)
Write-Host "Removing device..."
pnputil /remove-device "$($cam.InstanceId)"
Start-Sleep 5

# 4. Scan for hardware changes (reinstalls the device)
Write-Host "Scanning for hardware changes..."
pnputil /scan-devices
Start-Sleep 5

# 5. Check result
$cam2 = Get-PnpDevice -Class Camera -ErrorAction SilentlyContinue
if ($cam2) {
    Write-Host "Reinstalled: $($cam2.FriendlyName) - $($cam2.Status)"
} else {
    Write-Host "WARNING: Camera not found after scan. Scanning again..."
    pnputil /scan-devices
    Start-Sleep 5
    $cam3 = Get-PnpDevice -Class Camera -ErrorAction SilentlyContinue
    if ($cam3) { Write-Host "Found: $($cam3.FriendlyName) - $($cam3.Status)" }
    else { Write-Host "FAILED: Camera not detected. Try replugging USB." }
}

# 6. Restart FrameServer
Start-Service -Name 'FrameServer' -ErrorAction SilentlyContinue
Start-Sleep 2
Write-Host "FrameServer: $((Get-Service 'FrameServer').Status)"
