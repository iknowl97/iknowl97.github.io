```powershell
# PowerShell script for cleaning up Windows Updates, restarting services, and removing the SoftwareDistribution folder

# Script should be run as Administrator

# Function to check if the script is running as administrator
function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if running as administrator, exit if not
if (-not (Test-IsAdmin)) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    Write-Host "Please run PowerShell as an administrator and try again." -ForegroundColor Red
    exit
}

# Stop Windows Update Services
Write-Host "Stopping Windows Update services..."
try {
    Stop-Service -Name wuauserv -Force -ErrorAction Stop
    Stop-Service -Name bits -Force -ErrorAction Stop
    Stop-Service -Name appidsvc -Force -ErrorAction SilentlyContinue  # Sometimes not present
}
catch {
    Write-Warning "Failed to stop one or more services. Error: $($_.Exception.Message)"
}

# Remove SoftwareDistribution folder
Write-Host "Removing SoftwareDistribution folder..."
$SoftwareDistributionPath = "C:\Windows\SoftwareDistribution"

try {
    if (Test-Path $SoftwareDistributionPath) {
        # Rename instead of delete to be safer (and allow rollback if needed)
        $NewSoftwareDistributionPath = "C:\Windows\SoftwareDistribution.old"

        # Check if SoftwareDistribution.old already exists and delete if so
        if (Test-Path $NewSoftwareDistributionPath) {
            Write-Host "Removing existing SoftwareDistribution.old folder..."
            Remove-Item -Path $NewSoftwareDistributionPath -Recurse -Force -ErrorAction Stop
        }
        
        Rename-Item -Path $SoftwareDistributionPath -NewName "SoftwareDistribution.old" -ErrorAction Stop
        Write-Host "SoftwareDistribution folder renamed to SoftwareDistribution.old"
    } else {
        Write-Host "SoftwareDistribution folder does not exist."
    }
}
catch {
    Write-Warning "Failed to remove/rename SoftwareDistribution folder. Error: $($_.Exception.Message)"
    Write-Warning "Ensure no processes are using files within the SoftwareDistribution folder and try again."
}

# Restart Windows Update Services
Write-Host "Restarting Windows Update services..."
try {
    Start-Service -Name wuauserv -ErrorAction Stop
    Start-Service -Name bits -ErrorAction Stop
    Start-Service -Name appidsvc -ErrorAction SilentlyContinue #Sometimes not present
}
catch {
    Write-Warning "Failed to start one or more services. Error: $($_.Exception.Message)"
}

# Cleanup temporary update files (optional)
Write-Host "Cleaning up temporary update files..."
try {
    Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object {$_.Name -like "*.~tmp"} | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path "C:\Windows\Temp" -File | Where-Object {$_.Name -like "*.tmp"} | Remove-Item -Force -ErrorAction SilentlyContinue
}
catch {
    Write-Warning "Failed to clean up temporary files. Error: $($_.Exception.Message)"
}

# Run Disk Cleanup (optional, requires user interaction)
Write-Host "Running Disk Cleanup (requires user interaction)..."
try {
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/d C:" -Wait
}
catch {
    Write-Warning "Failed to start Disk Cleanup. Error: $($_.Exception.Message)"
}

Write-Host "Windows Update cleanup process completed." -ForegroundColor Green
Write-Host "You may need to restart your computer for changes to fully take effect." -ForegroundColor Green

# Optional: Prompt to restart
$Restart = Read-Host "Do you want to restart your computer now? (Y/N)"
if ($Restart -eq "Y" -or $Restart -eq "y") {
    Restart-Computer -Force
}
```

**Explanation and Best Practices:**

1. **Administrator Check:** The script now verifies if it's running with administrator privileges.  This is crucial as most of the operations require elevated permissions.  If not running as admin, it displays an error and exits.

2. **Service Stopping:** The script attempts to stop the `wuauserv` (Windows Update), `bits` (Background Intelligent Transfer Service), and `appidsvc` (Application Identity Service) services.  The `-Force` parameter is used to attempt to stop the services even if they are busy.  `SilentlyContinue` is used for `appidsvc` because it might not always be running or present. The `try-catch` block handles potential errors during the stopping process.  It's important to stop these services before manipulating the `SoftwareDistribution` folder.

3. **SoftwareDistribution Removal (Rename instead of Delete):**  Instead of directly deleting the `SoftwareDistribution` folder, the script now *renames* it to `SoftwareDistribution.old`. This is a safer approach:
   - **Rollback:**  If something goes wrong, you can easily revert by renaming the folder back.
   - **Reduced Risk of Data Loss:** Accidental deletion of important files is avoided.
   - **Handles Permissions Issues:** Renaming is often less problematic permission-wise than deleting.

   The script also checks if `SoftwareDistribution.old` already exists and deletes it if it does before renaming the current `SoftwareDistribution` folder to avoid errors.

4. **Error Handling:**  `try-catch` blocks are used around critical operations (stopping services, removing the folder, starting services, cleaning up temp files, running disk cleanup).  This allows the script to gracefully handle errors and provide informative messages to the user instead of abruptly crashing.  `-ErrorAction Stop` in the `try` block makes the script jump to the `catch` block immediately if an error happens.

5. **Service Restarting:** After renaming the folder, the script attempts to restart the stopped services.  Error handling is included here as well.

6. **Temporary File Cleanup (Optional):** The script attempts to remove temporary files related to updates. The `-Force` parameter is used to bypass confirmation prompts.  `-ErrorAction SilentlyContinue` prevents the script from stopping if it encounters files that are in use or protected.

7. **Disk Cleanup (Optional, User Interaction Required):** The script includes an optional step to run the Disk Cleanup utility. This requires user interaction to select the drive and specify which files to clean. The `-Wait` parameter is used to wait for the `cleanmgr.exe` process to finish before continuing the script.

8. **Informative Output:** The script provides clear and informative messages to the user about what it's doing at each step.  It uses `Write-Host` with different `ForegroundColor` values to highlight important messages.

9. **Restart Prompt (Optional):** The script prompts the user to restart their computer after the cleanup process is complete.  This is often necessary for the changes to fully take effect.

10. **Security Considerations:**
    - **Running as Administrator:**  The script explicitly checks for and requires administrator privileges.
    - **Renaming Instead of Deleting:** This is a much safer approach than directly deleting the `SoftwareDistribution` folder.
    - **Error Handling:**  Comprehensive error handling prevents the script from crashing and potentially causing data loss.

**How to Use:**

1. **Save the script:** Save the code as a `.ps1` file (e.g., `cleanup_updates.ps1`).
2. **Run as Administrator:**  Open PowerShell as an administrator (right-click on the PowerShell icon and select "Run as administrator").
3. **Navigate to the script:** Use the `cd` command to navigate to the directory where you saved the script.  For example: `cd C:\Scripts`
4. **Execute the script:** Run the script by typing `.\cleanup_updates.ps1` and pressing Enter.
5. **Follow the prompts:** The script will guide you through the cleanup process and prompt you to restart your computer if necessary.

**Important Notes:**

* **Testing:** Before running this script on a production system, test it thoroughly in a test environment to ensure it works as expected and doesn't cause any issues.
* **Backup:**  It's always a good practice to create a system backup before making significant changes to your system.  While this script is designed to be safe, unexpected issues can always occur.
* **User Interaction:** The Disk Cleanup utility requires user interaction.  If you want to automate this step, you can use the `DISM /Online /Cleanup-Image /AnalyzeComponentStore` and `DISM /Online /Cleanup-Image /StartComponentCleanup` commands, but be very careful when using these commands, as they can potentially remove important system files if used incorrectly.
* **Schedule Tasks:** Do not run this script as a scheduled task without thorough testing. Unexpected behavior can occur when automated.
