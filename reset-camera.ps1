$id = 'USB\VID_046D&PID_094C&MI_00\A&39F4A62F&0&0000'
Write-Host "Disabling Brio 100..."
Disable-PnpDevice -InstanceId $id -Confirm:$false
Start-Sleep -Seconds 3
Write-Host "Enabling Brio 100..."
Enable-PnpDevice -InstanceId $id -Confirm:$false
Start-Sleep -Seconds 2
$dev = Get-PnpDevice -InstanceId $id
Write-Host "Status: $($dev.Status)"
