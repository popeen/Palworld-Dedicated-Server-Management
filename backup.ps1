function Invoke-RconCmd{
    
    param(
        $serverAddress = "localhost",
        $serverPort = 25575,
        $Password = "",
        $cmd
    )

    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

    try {
        . "powershell-rcon\Classes.ps1"
    } catch {
        Write-Host "Was not able to load classes.ps1." -ForegroundColor red
        throw $PSItem
    }


    # Connect and authenticate
    try {
        $RconClient = New-Object RconClient $serverAddress, $serverPort
        $RconClient.Authenticate($Password)
    } catch {
        if ($RconClient.IsConnected()) { $RconClient.Quit() }
        throw $PSItem
    }

    $RconClient.Send($cmd)
}


try{
    Invoke-RconCmd -cmd "Broadcast Taking_backup"
}Catch{}


Compress-Archive -Path "E:\PalServer\Pal\Saved" -DestinationPath "E:\PalWorldBackup\$(get-date -f yyyy-MM-dd_HH-mm).zip" > $null

try{
    Invoke-RconCmd -cmd "Broadcast Backup_done"
}Catch{}
