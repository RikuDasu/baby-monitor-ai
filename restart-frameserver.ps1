Write-Host "Restarting Windows Camera Frame Server..."
Restart-Service -Name 'FrameServer' -Force
Start-Sleep -Seconds 2
$svc = Get-Service -Name 'FrameServer'
Write-Host "FrameServer status: $($svc.Status)"
