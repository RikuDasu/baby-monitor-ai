Start-Sleep -Seconds 5
$procs = Get-Process | Where-Object { $_.ProcessName -match 'logi' }
if ($procs) {
    Write-Host "Logi processes still running:"
    $procs | Select-Object ProcessName, Id | Format-Table -AutoSize
} else {
    Write-Host "ALL CLEAR - No Logi processes running"
}
