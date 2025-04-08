```powershell
<#
.SYNOPSIS
This script checks RDP connection to a list of IP addresses or hostnames.

.DESCRIPTION
The script takes a list of IP addresses or hostnames as input and attempts to establish an RDP connection to each one.
It uses Test-Path to check for the mstsc.exe executable (the Remote Desktop client) and leverages it to test the connections.
The script outputs the status of each connection attempt.  It's designed to be safe and read-only, making no changes to the target systems.

.PARAMETER ComputerName
A list of IP addresses or hostnames to check.  If not provided, the script will prompt for a list.

.EXAMPLE
.\Test-RDPConnections.ps1 -ComputerName "192.168.1.10", "server.example.com"

.EXAMPLE
.\Test-RDPConnections.ps1  # Will prompt for a list of computer names.

.NOTES
* Requires PowerShell 3.0 or later.
* The script does not actually log in to the remote machines; it only checks if a connection can be established.
* Error handling is implemented to catch common exceptions.
#>

param (
    [Parameter(Mandatory=$false, HelpMessage="Enter a comma-separated list of IP addresses or hostnames.")]
    [string[]]$ComputerName
)

# Check if mstsc.exe exists
if (!(Test-Path -Path "$env:SystemRoot\system32\mstsc.exe")) {
    Write-Error "Remote Desktop client (mstsc.exe) not found.  Please ensure it is installed."
    exit 1
}

# If no computer names are provided, prompt the user for input
if (-not $ComputerName) {
    $ComputerName = Read-Host "Enter a comma-separated list of IP addresses or hostnames" -split "," | ForEach-Object { $_.Trim() }
}

Write-Host "Testing RDP connections..."

foreach ($Computer in $ComputerName) {
    try {
        # Use mstsc.exe to attempt an RDP connection.  The /v parameter specifies the target computer.
        # The /admin parameter connects to the console session (if available).
        # The /f parameter runs the connection in full-screen mode.  We don't actually want full-screen, so the -w and -h parameters immediately resize it.
        # The /NoAutoReconnect parameter prevents automatic reconnection attempts.
        # /span attempts to match the client area to the virtual desktop size across multiple monitors.
        # /multimon uses all monitors for the remote session.

        Write-Host "Testing connection to: $($Computer)..."

        # Start-Process is used to run mstsc.exe in a separate process.
        # -ArgumentList specifies the arguments to pass to mstsc.exe.
        # -PassThru returns a process object that can be used to monitor the process.
        $process = Start-Process -FilePath "$env:SystemRoot\system32\mstsc.exe" -ArgumentList "/v:$Computer /admin /f /w:1 /h:1 /NoAutoReconnect /span /multimon" -PassThru -ErrorAction Stop

        # Wait for a short period to see if the RDP connection is established.  Adjust the timeout as needed.
        Start-Sleep -Seconds 3

        # Check if the process is still running.  If it is not, the connection likely failed.
        if ($process.HasExited) {
            Write-Host "  Connection to $($Computer) failed."
        } else {
            Write-Host "  Connection to $($Computer) successful."
            # If the process is still running, kill it to close the RDP connection.
            Stop-Process -Id $process.Id -Force
        }


    }
    catch {
        Write-Host "  Error connecting to $($Computer): $($_.Exception.Message)"
    }
    finally {
        # Cleanup: Ensure the mstsc.exe process is terminated, even if an error occurred.
        if ($process -and -not $process.HasExited) {
            Stop-Process -Id $process.Id -Force
        }
    }
}

Write-Host "RDP connection testing complete."
```