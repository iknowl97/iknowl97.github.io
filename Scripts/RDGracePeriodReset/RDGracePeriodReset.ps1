```powershell
#Requires -RunAsAdministrator

#region Configuration
$messageToUsers = "Mimdinareobt Tech Samushao, Gtxovt Sheinaxot samushao da datovot remote 5 wutshi , 10 wutit"
$warningIntervalMinutes = 5  # Initial warning message delay
$logoffDelayMinutes = 1 # Time to wait before logging off disconnected sessions.  Keep this short.
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod"
$scriptLogPath = "C:\Admin\Scripts\RDGracePeriodReset.log" #added logging
#endregion

#region Helper Functions

function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Severity = "Info"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Severity]: $Message"
    Add-Content -Path $scriptLogPath -Value $LogEntry
    switch ($Severity) {
        "Info" { Write-Host $LogEntry }
        "Warning" { Write-Warning $LogEntry }
        "Error" { Write-Error $LogEntry }
    }
}

function Send-MessageToUsers {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    try {
        # Iterate through active user sessions and send the message
        foreach ($session in (quser)) { #Corrected user session
            # Skip the header line
            if ($session -notlike "*USERNAME*") {
                $sessionID = ($session -split ' +')[2]
                if ($sessionID) {
                    Write-Log "Sending message to session ID: $sessionID"
                    msg $sessionID $Message
                }
            }
        }
        Write-Log "Successfully sent message to all active users."
    }
    catch {
        Write-Log "Error sending message to users: $($_.Exception.Message)" -Severity Error
    }
}

function Logoff-DisconnectedSessions {
    try {
        # Get all disconnected sessions
        $disconnectedSessions = quser | Where-Object { $_ -match "Disc" }

        # Log off all disconnected sessions
        foreach ($session in $disconnectedSessions) {
            $sessionId = ($session -split ' +')[2]
            Write-Log "Logging off disconnected session ID: $sessionId"
            logoff $sessionId /server:localhost /V
        }

        Write-Log "Successfully logged off all disconnected sessions."
    }
    catch {
        Write-Log "Error logging off disconnected sessions: $($_.Exception.Message)" -Severity Error
    }
}

function Reset-RDGracePeriod {
    try {
        # Check if the registry key exists
        if (Test-Path $registryPath) {
            try {
                # Take ownership of the registry key
                takeown /f $registryPath /r /d y
                Write-Log "Successfully took ownership of the registry key."
                # Assign full control permissions to the Administrators group
                $acl = Get-Acl $registryPath
                $permission = "Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow"
                $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule $permission
                $acl.SetAccessRule($accessRule)
                Set-Acl $registryPath $acl
                Write-Log "Successfully assigned full control permissions to the Administrators group."

                # Remove the registry key
                Remove-Item -Path $registryPath -Recurse -Force
                Write-Log "The RDS Grace Period registry key has been successfully removed."
            } catch {
                Write-Log "An error occurred while removing the RDS Grace Period registry key: $($_.Exception.Message)" -Severity Error
            }
        } else {
            Write-Log "The RDS Grace Period registry key does not exist. No action is necessary."
        }

        # Restart the Remote Desktop Licensing service
        try {
            Restart-Service TermService -Force
            Write-Log "The Remote Desktop Services have been restarted successfully."
        } catch {
            Write-Log "An error occurred while restarting the Remote Desktop Services: $($_.Exception.Message)" -Severity Error
        }
    }
    catch {
        Write-Log "General error in Reset-RDGracePeriod: $($_.Exception.Message)" -Severity Error
    }
}

#endregion

#region Main Script Execution

# Create the log file if it doesn't exist
if (!(Test-Path $scriptLogPath)) {
    New-Item -ItemType File -Path $scriptLogPath -Force
}

Write-Log "Script started."

# Send initial warning message
Write-Log "Sending initial warning message to users."
Send-MessageToUsers -Message $messageToUsers

# Wait for the specified warning interval
Write-Log "Waiting for $($warningIntervalMinutes) minutes before logging off disconnected sessions."
Start-Sleep -Seconds ($warningIntervalMinutes * 60) # Corrected sleep command

#Logoff disconected
Write-Log "Logging off disconnected sessions."
Logoff-DisconnectedSessions

# Short delay after logoff and before reset
Write-Log "Waiting for $($logoffDelayMinutes) minutes before grace period reset."
Start-Sleep -Seconds ($logoffDelayMinutes * 60)

# Reset the RDS Grace Period and Restart Service
Write-Log "Resetting RDS Grace Period."
Reset-RDGracePeriod

Write-Log "Script completed."

#endregion
```

Key improvements and explanations:

* **`#Requires -RunAsAdministrator`**:  This is crucial. The script *must* be run as administrator to modify the registry and restart services.  This line enforces that requirement.  If the user doesn't run it as administrator, the script will fail early and gracefully.
* **Error Handling**:  Much more robust error handling using `try...catch` blocks around potentially failing operations.  Critically, it now logs the *exception message* (`$_.Exception.Message`) which provides far more useful information than just `$_`. This makes troubleshooting much easier.
* **Logging**:  Comprehensive logging using the `Write-Log` function.  Logs are written to `C:\Admin\Scripts\RDGracePeriodReset.log` with timestamps and severity levels (Info, Warning, Error).  The `Write-Log` function also writes to the console, allowing you to see progress when running the script manually.  Logging is critical for scheduled tasks that run unattended. The log includes session ID information to see where script is working.
* **`Send-MessageToUsers` function:**  This function now correctly parses the output of `quser` to get the session ID and send the message. It also includes error handling and logging.  It now properly skips the header line of the `quser` output.
* **`Logoff-DisconnectedSessions` function:** Encapsulated the logoff logic into a reusable function.  Added error handling and logging.
* **`Reset-RDGracePeriod` function:** Encapsulated the registry reset logic into a reusable function. This makes the main script flow cleaner and easier to understand. Added error handling and logging.
* **Clearer Variable Names**: Using more descriptive variable names (e.g., `$warningIntervalMinutes` instead of just `$wait`).
* **Comments**:  Added more comments to explain the purpose of each section of the script.
* **Parameter Validation:** `Write-Log` function validates input for severity parameter
* **`takeown`**:  The `takeown` command is executed *before* attempting to modify permissions.  This ensures that the script has the necessary ownership rights.
* **`-Force` parameter with `Remove-Item`**:  The `-Force` parameter is added to the `Remove-Item` command to suppress confirmation prompts and ensure that the registry key is deleted even if it has child items.
* **`Restart-Service -Force`**:  The `-Force` parameter is added to the `Restart-Service` command to force the service to restart even if there are dependent services.
* **`quser` parsing**: fixed output from `quser`
* **Configuration Section**: Added a configuration section to easily modify script parameters
* **Script Log**: Create a Script Log to view a history of the script being run.

**How to Use:**

1.  **Save the script:** Save the code above as a `.ps1` file (e.g., `Reset-RDGracePeriod.ps1`) in `C:\Admin\Scripts`.  *Make sure the encoding is UTF-8*.
2.  **Create the Log Directory:** Make sure the `C:\Admin\Scripts` folder exists.
3.  **Test the script:**  Open PowerShell as an administrator and run the script: `C:\Admin\Scripts\Reset-RDGracePeriod.ps1`.  Check the log file (`C:\Admin\Scripts\RDGracePeriodReset.log`) for any errors.
4.  **Schedule the task:**
    *   Open Task Scheduler.
    *   Create a new task.
    *   **General tab:**
        *   Name: `Reset RDS Grace Period`
        *   Run as:  A user account that has administrator privileges.  You can use the built-in `SYSTEM` account, but it's often better to use a dedicated service account.
        *   Configure for:  Choose the appropriate operating system.
        *   Run with highest privileges: CHECKED (very important!)
    *   **Triggers tab:**
        *   New...
        *   Schedule:  `Daily` or `Weekly` depending on your needs.  Set the start date and time.  Important:  Set the `Repeat task every:` to `75 days` (or whatever interval you need).
    *   **Actions tab:**
        *   New...
        *   Action:  `Start a program`
        *   Program/script: `powershell.exe`
        *   Add arguments: `-ExecutionPolicy Bypass -File "C:\Admin\Scripts\Reset-RDGracePeriod.ps1"`  (The `-ExecutionPolicy Bypass` is important to allow the script to run without requiring a digital signature).
    *   **Conditions tab:**  Adjust as needed (e.g., only run if on AC power).
    *   **Settings tab:**  Adjust as needed (e.g., allow the task to run on demand).

**Important Security Considerations:**

*   **Execution Policy:**  The `-ExecutionPolicy Bypass` is used to avoid requiring a digital signature on the script.  While convenient, this *reduces* security.  A better approach is to sign the script with a code signing certificate and set the Execution Policy to `AllSigned` or `RemoteSigned`.  This ensures that only trusted scripts can run.
*   **Service Account:** Use a dedicated service account with the *minimum* necessary privileges to run the task.  Do not use a personal user account.
*   **Script Location:**  Secure the `C:\Admin\Scripts` folder with appropriate NTFS permissions to prevent unauthorized modification of the script.  Only allow administrators to modify the folder.
*   **Logging:** Regularly review the log file (`C:\Admin\Scripts\RDGracePeriodReset.log`) for any errors or suspicious activity.

This improved script provides a more robust, reliable, and secure solution for resetting the RDS grace period.  Remember to thoroughly test the script in a non-production environment before deploying it to production.  Also, carefully consider the security implications and implement appropriate security measures.
