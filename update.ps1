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
    Invoke-RconCmd -cmd "Shutdown 10 Server_rebooting_for_update"
    Start-Sleep -Seconds 30
}Catch{}
try{
    Get-Process -Name PalServer-Win64-Test-Cmd | Stop-Process # Should not happen as we did a clean shutdown above but just in case
}Catch{}

.\backup.ps1

steamcmd +login anonymous +force_install_dir E:\PalServer +app_update 2394010 validate +quit

Set-Location "E:\PalServer"
.\PalServer.exe -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS