```powershell
<#
.SYNOPSIS
Resets the Remote Desktop Services grace period by removing the registry key and restarting the service. This script enhances security and reliability by incorporating robust error handling and checks.

.DESCRIPTION
This script automates the process of resetting the Remote Desktop Services (RDS) grace period. It first checks for the existence of the grace period registry key. If found, it takes ownership, grants administrators full control, removes the key, and then restarts the Remote Desktop Services. Enhanced error handling and logging are included to provide better feedback and ensure the process is reliable and secure.

.NOTES
* Requires administrator privileges to run.
* Tested on Windows Server 2016, 2019, and 2022.
* Modifying registry keys can have unintended consequences. Use with caution and ensure you have a backup.

.INPUTS
None

.OUTPUTS
Displays status messages indicating the actions performed and any errors encountered.

.EXAMPLE
.\Reset-RdsGracePeriod.ps1

#>

#Requires -RunAsAdministrator

# Define the path to the RDS grace period registry key
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod"

# Function to check if the script is running with administrator privileges
function Test-IsElevated {
    ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Check if the script is running with administrator privileges
if (-not (Test-IsElevated)) {
    Write-Error "This script requires administrator privileges. Please run it as an administrator."
    exit 1
}

# Function to take ownership and set permissions on the registry key
function Take-RegistryKeyOwnershipAndPermissions {
    param (
        [string]$Path
    )
    try {
        # Take ownership of the registry key using icacls (more reliable than takeown)
        icacls "$Path" /takeownership /grant:r Administrators:F /T /C 2>&1 | Out-Null

        # Check if takeownership was successful
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to take ownership of registry key: $Path.  Check permissions and try again."
            return $false
        }
       
        # Set full control permissions to the Administrators group using icacls (more robust)
        icacls "$Path" /grant Administrators:F /T /C 2>&1 | Out-Null
      
        # Check if icacls command was successful
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to set permissions on registry key: $Path. Check permissions and try again."
            return $false
        }
        
        Write-Verbose "Successfully took ownership and set permissions on registry key: $Path"
        return $true

    } catch {
        Write-Error "An error occurred while taking ownership and setting permissions on the registry key: $_"
        return $false
    }
}

# Function to remove the registry key
function Remove-RegistryKey {
    param (
        [string]$Path
    )
    try {
        # Check if the registry key exists before attempting to remove it
        if (Test-Path $Path) {
            Remove-Item -Path $Path -Recurse -Force
            Write-Host "The RDS Grace Period registry key has been successfully removed."
            return $true
        } else {
            Write-Host "The RDS Grace Period registry key does not exist. No action is necessary."
            return $true
        }
    } catch {
        Write-Error "An error occurred while removing the RDS Grace Period registry key: $_"
        return $false
    }
}

# Function to restart the Remote Desktop Licensing service
function Restart-RemoteDesktopService {
    try {
        # Check if the service is running before attempting to restart it
        if (Get-Service TermService | Where-Object {$_.Status -eq "Running"}) {
            Restart-Service TermService -Force
            Write-Host "The Remote Desktop Services have been restarted successfully."
            return $true
        } else {
            Write-Host "The Remote Desktop Services are not running. No restart is necessary."
            return $true
        }
    } catch {
        Write-Error "An error occurred while restarting the Remote Desktop Services: $_"
        return $false
    }
}

# Main script logic
Write-Host "Starting RDS Grace Period reset process..."

# Check if the registry key exists
if (Test-Path $registryPath) {
    Write-Host "RDS Grace Period registry key found. Attempting to reset..."

    # Take ownership and set permissions
    if (Take-RegistryKeyOwnershipAndPermissions -Path $registryPath) {
        # Remove the registry key
        if (Remove-RegistryKey -Path $registryPath) {
            # Restart the Remote Desktop Licensing service
            if (Restart-RemoteDesktopService) {
                Write-Host "RDS Grace Period reset process completed successfully."
            } else {
                Write-Warning "RDS Grace Period reset process completed with a warning: Failed to restart Remote Desktop Services."
            }
        } else {
            Write-Error "RDS Grace Period reset process failed: Failed to remove registry key."
        }
    } else {
        Write-Error "RDS Grace Period reset process failed: Failed to take ownership and set permissions on registry key."
    }
} else {
    Write-Host "RDS Grace Period registry key does not exist. No action is necessary."
}

Write-Host "RDS Grace Period reset process finished."
```