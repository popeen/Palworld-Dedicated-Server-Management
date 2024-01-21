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


Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_30_minutes"
Start-Sleep -Seconds $(60 * 15)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_15_minutes"
Start-Sleep -Seconds $(1 * 5)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_10_minutes"
Start-Sleep -Seconds $(1 * 5)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_5_minutes"
Start-Sleep -Seconds $(60 * 1)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_4_minutes"
Start-Sleep -Seconds $(60 * 1)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_3_minutes"
Start-Sleep -Seconds $(60 * 1)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_2_minutes"
Start-Sleep -Seconds $(60 * 1)

Invoke-RconCmd -cmd "Broadcast Server_will_reboot_in_1_minute"
Start-Sleep -Seconds $(60 * 1)

Invoke-RconCmd -cmd "Shutdown 5 Server_rebooting"

.\update.ps1 #This will also take a backup