# Nuclear option: completely reset camera subsystem

# 1. Stop FrameServer
Write-Host "Stopping FrameServer..."
Stop-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue
Start-Sleep 1
Write-Host "  FrameServer: $((Get-Service 'FrameServer').Status)"

# 2. Disable the camera device
$camId = (Get-PnpDevice -Class Camera | Select-Object -First 1).InstanceId
Write-Host "`nDisabling camera: $camId"
Disable-PnpDevice -InstanceId $camId -Confirm:$false
Start-Sleep 3

# 3. Re-enable the camera device
Write-Host "Re-enabling camera..."
Enable-PnpDevice -InstanceId $camId -Confirm:$false
Start-Sleep 3

# 4. Check device status
$cam = Get-PnpDevice -InstanceId $camId
Write-Host "  Camera: $($cam.FriendlyName) - $($cam.Status)"

# 5. Start FrameServer fresh
Write-Host "`nStarting FrameServer..."
Start-Service -Name 'FrameServer'
Start-Sleep 2
Write-Host "  FrameServer: $((Get-Service 'FrameServer').Status)"

Write-Host "`nDone. Camera subsystem fully reset."
