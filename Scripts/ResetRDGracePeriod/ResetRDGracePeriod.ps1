```powershell
<#
.SYNOPSIS
Resets the Remote Desktop Services grace period, logs off disconnected sessions, and restarts the TermService.  Sends warning messages to connected users before initiating these actions.

.DESCRIPTION
This script automates the process of resetting the RDS grace period, logging off disconnected RDP sessions, and restarting the Remote Desktop Services.  It first sends a warning message to all connected users, then logs off disconnected sessions, resets the grace period (by deleting the registry key), and finally restarts the TermService. This script is designed to be run silently from a scheduled task.

.PARAMETER RegistryPath
The path to the RDS grace period registry key.  Defaults to "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod".

.PARAMETER WarningMessage
The message to be sent to connected users before disconnecting them. Defaults to "Mimdinareobt Tech Samushao, Gtxovt Sheinaxot samushao da datovot remote 5 wutshi , 10 wutit".

.NOTES
*   Requires administrator privileges to run.
*   Designed to run on a Windows Server with Remote Desktop Services installed.
*   The scheduled task running this script should be configured to run with an account that has administrator privileges.
*   The script includes error handling to ensure that it continues to run even if some operations fail.
*   It is crucial to test this script in a non-production environment before deploying it to a production environment.
*   The 'takeown' command may require confirmation depending on system configuration.  The '/d y' parameter attempts to automatically answer 'yes' to the prompt.
*   Consider implementing logging to a file for auditing purposes.

.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/restart-service?view=powershell-7.3
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-host?view=powershell-7.3
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-acl?view=powershell-7.3
https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/takeown
https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/logoff
https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/query-session

#>

#region Configuration
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod"
$WarningMessage = "Mimdinareobt Tech Samushao, Gtxovt Sheinaxot samushao da datovot remote 5 wutshi , 10 wutit"
$WarningDelaySeconds = 300 # 5 minutes = 300 seconds
$LogoffDelaySeconds = 60 # 1 minute = 60 seconds
$ErrorActionPreference = "Stop" # Terminate script on first error.  Change to 'Continue' for less strict error handling (but may leave system in unexpected state).
#endregion Configuration


#region Functions

function Send-MessageToUsers {
    param (
        [string]$Message,
        [int]$DelaySeconds
    )

    try {
        # Use msg.exe to send the message to all active sessions.  ErrorActionPreference is set globally so this will stop on any error.
        Write-Host "Sending warning message to all users..."
        msg.exe /server:localhost * "$Message"
        Write-Host "Warning message sent.  Waiting $DelaySeconds seconds..."
        Start-Sleep -Seconds $DelaySeconds
    }
    catch {
        Write-Error "Error sending message to users: $_"
        #Continue # Comment out if you want the script to stop if the message fails to send
    }
}

function Logoff-DisconnectedSessions {
    try {
        Write-Host "Logging off disconnected sessions..."

        # Get all disconnected sessions
        $disconnectedSessions = quser | Where-Object { $_ -match "Disc" }

        # Log off all disconnected sessions
        foreach ($session in $disconnectedSessions) {
            $sessionId = ($session -split ' +')[2]
            Write-Host "Logging off session ID: $sessionId"
            logoff $sessionId /server:localhost /V
        }

        Write-Host "Disconnected sessions logged off."
    }
    catch {
        Write-Error "Error logging off disconnected sessions: $_"
        #Continue # Comment out if you want the script to stop if logoff fails
    }
}

function Reset-RDGracePeriod {
    param (
        [string]$RegistryPath
    )

    try {
        Write-Host "Resetting RDS grace period..."

        # Check if the registry key exists
        if (Test-Path $RegistryPath) {
            try {
                # Take ownership of the registry key
                Write-Host "Taking ownership of the registry key..."
                takeown /f $RegistryPath /r /d y

                # Assign full control permissions to the Administrators group
                Write-Host "Assigning full control permissions to Administrators..."
                $acl = Get-Acl $RegistryPath
                $permission = "Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow"
                $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule $permission
                $acl.SetAccessRule($accessRule)
                Set-Acl $RegistryPath $acl

                # Remove the registry key
                Write-Host "Removing the registry key..."
                Remove-Item -Path $RegistryPath -Recurse

                Write-Host "The RDS Grace Period registry key has been successfully removed."
            } catch {
                Write-Error "An error occurred while removing the RDS Grace Period registry key: $_"
            }
        } else {
            Write-Host "The RDS Grace Period registry key does not exist. No action is necessary."
        }

        Write-Host "RDS grace period reset."
    }
    catch {
        Write-Error "Error resetting RDS grace period: $_"
    }
}

function Restart-RemoteDesktopServices {
    try {
        Write-Host "Restarting Remote Desktop Services..."
        Restart-Service TermService -Force
        Write-Host "The Remote Desktop Services have been restarted successfully."
    } catch {
        Write-Error "An error occurred while restarting the Remote Desktop Services: $_"
    }
}

#endregion Functions


#region Main Script

try {
    # Send Warning Message
    Send-MessageToUsers -Message $WarningMessage -DelaySeconds $WarningDelaySeconds

    # Log off Disconnected Sessions after a delay.
    Write-Host "Waiting $($LogoffDelaySeconds) seconds before logging off disconnected sessions..."
    Start-Sleep -Seconds $LogoffDelaySeconds
    Logoff-DisconnectedSessions

    # Reset RDS Grace Period
    Reset-RDGracePeriod -RegistryPath $RegistryPath

    # Restart Remote Desktop Services
    Restart-RemoteDesktopServices
}
catch {
    Write-Error "A critical error occurred: $_"
    # You might want to add logging to a file here for troubleshooting
}

#endregion Main Script
```
