# Kill ALL remaining suspects
$targets = @(
    'wallpaper64',          # Wallpaper Engine - CAN use webcam!
    'adb',                  # Android Debug Bridge (scrcpy/PICO)
    'steam',                # Steam client
    'SteamService',         # Steam service
    'steamwebhelper',       # Steam browser
    'Superwhisper',         # Audio app but just in case
    'WindowsCamera'         # Windows Camera app
)

foreach ($t in $targets) {
    $p = Get-Process -Name $t -ErrorAction SilentlyContinue
    if ($p) {
        taskkill /F /IM "$t.exe" 2>$null
        Write-Host "Killed: $t (PID: $($p.Id -join ', '))"
    }
}

Start-Sleep 2

# Restart FrameServer
Restart-Service -Name 'FrameServer' -Force -ErrorAction SilentlyContinue
Start-Sleep 3

Write-Host "`nFrameServer: $((Get-Service 'FrameServer').Status)"
Write-Host "Done. Try Windows Camera app now."
