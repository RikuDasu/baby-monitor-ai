# Find processes that might be using the camera
Write-Host "=== All processes with possible camera/media access ==="
$suspects = Get-Process | Where-Object {
    $_.ProcessName -match 'stream|cam|video|capture|obs|virtual|bmd|blackmagic|logi|pico|vr|desktop|deck|media|render'
} | Select-Object ProcessName, Id, Path

if ($suspects) {
    $suspects | Format-Table -AutoSize
} else {
    Write-Host "  No obvious camera processes found"
}

Write-Host ""
Write-Host "=== Logitech processes (Brio 100 manufacturer) ==="
Get-Process | Where-Object { $_.ProcessName -match 'logi' } | Select-Object ProcessName, Id | Format-Table -AutoSize

Write-Host ""
Write-Host "=== Blackmagic processes ==="
Get-Process | Where-Object { $_.ProcessName -match 'bmd|blackmagic|decklink|davinci' } | Select-Object ProcessName, Id | Format-Table -AutoSize

Write-Host ""
Write-Host "=== VR / PICO processes ==="
Get-Process | Where-Object { $_.ProcessName -match 'pico|vr|virtual|steam|oculus|openxr' } | Select-Object ProcessName, Id | Format-Table -AutoSize

Write-Host ""
Write-Host "=== StreamDeck ==="
Get-Process | Where-Object { $_.ProcessName -match 'stream' } | Select-Object ProcessName, Id | Format-Table -AutoSize

Write-Host ""
Write-Host "=== All non-system processes (for manual review) ==="
Get-Process | Where-Object { $_.Path -and $_.Path -notmatch 'Windows|Microsoft|System32' } |
    Select-Object ProcessName, Id, @{N='Path';E={$_.Path}} |
    Sort-Object ProcessName | Format-Table -AutoSize -Wrap
