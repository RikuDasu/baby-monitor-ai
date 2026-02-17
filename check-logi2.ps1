Get-Process | Where-Object { $_.ProcessName -match 'logi' } | Select-Object ProcessName, Id, StartTime | Format-Table -AutoSize
