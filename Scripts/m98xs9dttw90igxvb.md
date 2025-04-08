```powershell
# PowerShell script to find the process using port 8000

# Use Get-NetTCPConnection to find connections using port 8000.  Filter by local port.
$connection = Get-NetTCPConnection -LocalPort 8000

# Check if any connections were found.
if ($connection) {
  # Iterate through each connection found (although likely only one).
  foreach ($conn in $connection) {
    # Get the process ID (PID) associated with the connection.
    $pid = $conn.OwningProcess

    # Get the process information using the PID.  Wrap in a try-catch
    # to handle the case where the process no longer exists.  This can
    # happen if the connection is in a transient state (e.g., closing).
    try {
      $process = Get-Process -Id $pid
      # Output the process name and PID.
      Write-Output "Process Name: $($process.ProcessName)"
      Write-Output "PID: $($pid)"

    }
    catch {
      Write-Warning "Process with PID $pid not found.  It may have terminated."
    }
  }
} else {
  Write-Output "No process is currently listening on port 8000."
}
```