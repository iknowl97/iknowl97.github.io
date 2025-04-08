```powershell
# PowerShell script to detect what's using port 8000 and display name and PID

# Use Get-NetTCPConnection to find connections using port 8000
$connections = Get-NetTCPConnection -LocalPort 8000

# Check if any connections are found
if ($connections) {
    Write-Host "Processes using port 8000:"

    # Iterate through each connection found
    foreach ($connection in $connections) {
        # Get the process ID (PID) associated with the connection
        $processId = $connection.OwningProcess

        # Attempt to get the process information using the PID
        try {
            $process = Get-Process -Id $processId

            # Display the process name and PID
            Write-Host "  Process Name: $($process.ProcessName)"
            Write-Host "  PID: $($process.Id)"
            Write-Host "  State: $($connection.State)" #Added state for more info
			Write-Host "  Remote Address: $($connection.RemoteAddress)" #Remote address
			Write-Host "  Remote Port: $($connection.RemotePort)" #Remote port
            Write-Host "-------------------------"
        }
        catch {
            # Handle the case where the process information cannot be retrieved (e.g., insufficient permissions or process no longer exists)
            Write-Warning "  Unable to retrieve process information for PID: $processId"
			Write-Host "  State: $($connection.State)"  #Still display connection info if process lookup fails
			Write-Host "  Remote Address: $($connection.RemoteAddress)"
			Write-Host "  Remote Port: $($connection.RemotePort)"
            Write-Host "-------------------------"
        }
    }
}
else {
    # Display a message if no connections are found on port 8000
    Write-Host "No process is currently using port 8000."
}
```