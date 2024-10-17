# Imports
. "$PSScriptRoot\lib\config.ps1"
$configFile = "$PSScriptRoot\config.ini"

# Parse the config file to a hash table format
$config = Parse-Config -path $configFile
$saveDir = $config['save']
$backupDir = $config['backup']
$interval = $config['interval']

$backup1 = "$backupDir\backup1"
$backup2 = "$backupDir\backup2"
$backup3 = "$backupDir\backup3"
$backup4 = "$backupDir\backup4"
$backup5 = "$backupDir\backup5"
$lastSave = "$backupDir\lastsave"

$backupCmd = "xcopy /s /c /d /e /i /y"
$remainingTime = 0

# Start the game, if it's not already started.
$process = Get-Process -Name "DarkSoulsRemastered" -ErrorAction SilentlyContinue
if (-not $process) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$PSScriptRoot\startup.bat`""
}

# Backup loop
while ($true) {
    Clear-Host
    Invoke-Expression "$backupCmd `"$backup4`" `"$backup5`""
    Invoke-Expression "$backupCmd `"$backup3`" `"$backup4`""
    Invoke-Expression "$backupCmd `"$backup2`" `"$backup3`""
    Invoke-Expression "$backupCmd `"$backup1`" `"$backup2`""
    Invoke-Expression "$backupCmd `"$saveDir`"  `"$backup1`""
    Write-Output "Backup Complete!"

    for ($remainingTime = $interval; $remainingTime -ge 0; $remainingTime--) {
        $percentComplete = (($interval - $remainingTime) / $interval) * 100
        Write-Progress -Activity "Time to the next backup cycle::" -Status "$remainingTime seconds" -PercentComplete $percentComplete
        Start-Sleep -Seconds 1

        # Check if the game is still running
        $process = Get-Process -Name "DarkSoulsRemastered" -ErrorAction SilentlyContinue
        if (-not $process) {
            Invoke-Expression "$backupCmd `"$saveDir`" `"$lastSave`""
            Start-Sleep 2
            Write-Output "Exiting..."
            break 2  # Exit both loops if the process is not found
        }
    }
}
