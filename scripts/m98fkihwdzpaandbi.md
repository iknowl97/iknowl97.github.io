```powershell
<#
.SYNOPSIS
  This script performs various Windows OS repair tasks, including SFC and DISM operations.
  It's designed for Windows 10, 11, and Server operating systems.

.DESCRIPTION
  The script automates the process of checking and repairing common Windows OS issues.
  It includes System File Checker (SFC) scan, DISM health checks, and DISM restore health operations.
  The script logs the output of each operation to a log file for later review.

.NOTES
  Version: 1.0
  Author: Bard
  Date: 2024-01-02

  Requires:
    - PowerShell 5.1 or higher
    - Administrator privileges

.EXAMPLE
  .\Repair-WindowsOS.ps1

  This will run all repair checks and attempt to fix any detected issues.  The output
  will be logged to Repair-WindowsOS.log in the same directory as the script.
#>

#region Script Configuration

# Set the log file path
$LogFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Repair-WindowsOS.log"

# Function to write to the log file
function Write-Log {
  param (
    [string]$Message
  )
  $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $LogEntry = "$Timestamp - $Message"
  Add-Content -Path $LogFilePath -Value $LogEntry
  Write-Host $LogEntry
}

# Function to check and request admin privileges
function Ensure-AdminRights {
  if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Log "Script requires administrator privileges.  Please run as administrator."
    Write-Host "This script requires administrator privileges. Please run PowerShell as an administrator." -ForegroundColor Red
    exit
  }
  Write-Log "Script running with administrator privileges."
}

#endregion

#region Main Script Logic

# Ensure the script is running with administrator privileges
Ensure-AdminRights

# Log script start
Write-Log "Starting Windows OS Repair Script"

# Step 1: Run System File Checker (SFC)
Write-Log "Starting System File Checker (SFC) scan..."
try {
  $SFCResult = sfc /scannow
  $SFCResult | Out-String | ForEach-Object { Write-Log $_ }
  Write-Log "SFC scan completed. Check the log for details."
}
catch {
  Write-Log "Error occurred during SFC scan: $($_.Exception.Message)"
}

# Step 2: Check DISM Health
Write-Log "Checking DISM health..."
try {
  $DISMCheckHealthResult = Dism /Online /Cleanup-Image /CheckHealth
  $DISMCheckHealthResult | Out-String | ForEach-Object { Write-Log $_ }
  Write-Log "DISM CheckHealth completed. Check the log for details."
}
catch {
  Write-Log "Error occurred during DISM CheckHealth: $($_.Exception.Message)"
}

# Step 3: Scan DISM Health
Write-Log "Scanning DISM health..."
try {
  $DISMScanHealthResult = Dism /Online /Cleanup-Image /ScanHealth
  $DISMScanHealthResult | Out-String | ForEach-Object { Write-Log $_ }
  Write-Log "DISM ScanHealth completed. Check the log for details."
}
catch {
  Write-Log "Error occurred during DISM ScanHealth: $($_.Exception.Message)"
}


# Step 4: Restore DISM Health
Write-Log "Starting DISM RestoreHealth..."
try {
  $DISMRestoreHealthResult = Dism /Online /Cleanup-Image /RestoreHealth
  $DISMRestoreHealthResult | Out-String | ForEach-Object { Write-Log $_ }
  Write-Log "DISM RestoreHealth completed. Check the log for details."
}
catch {
  Write-Log "Error occurred during DISM RestoreHealth: $($_.Exception.Message)"
}

# Log script end
Write-Log "Windows OS Repair Script completed. Check the log file for details: $LogFilePath"

#endregion
```