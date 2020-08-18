<#

.SYNOPSIS
log-rotate.ps1 - Script to rotate logs/files.

.DESCRIPTION
Log rotation in which log files are deleted once exceeds to the retention limit.

.OUTPUTS
Results are output to screen.

.PARAMETER Path
Must be a valid path where the log files are stored.

.PARAMETER DaysRetention
Retention limit in days.

.PARAMETER Recurse
Used to traverse into subdirectories.

.EXAMPLE
Syntax 1: .\log-rotate.ps1 -Path 'C:\temp' -DaysRetention 30 -Recurse
This syntax deletes files older than 30 days found in C:\temp and its subdirectories.

Syntax 2: .\log-rotate.ps1 -Path 'C:\logs' -DaysRetention 90
This syntax deletes files older than 90 days found in C:\logs directory.

.NOTES
• When using the script as a recurring task, it is strongly recommended to assign
a dedicated service account.
• Always verify the permissions before running the script to avoid errors/issues.
Things to check are:
    - script and its directory
    - folders defined in this script
#>

# Param Block. Add additional parameters if needed.
[CmdletBinding()]
param (
        [Parameter( Mandatory=$true)]
        [string]$Path,

        [Parameter( Mandatory=$true)]
        [int]$DaysRetention,

        [Parameter( Mandatory=$false)]
        [switch]$Recurse
)

# Check path if exists
$check = Test-Path $Path

# If path exists. iterate through path and filter
# files greater than the retention period.
# If age is greater than the retention, delete.

if ($check -eq $true) {
  set-location $Path

# Recurse switch to traverse into child directories.
  if ($Recurse -eq $true) {
    Get-childitem -Path $Path –recurse | Where {( ! $_.PSIsContainer) -AND ($_.LastWriteTime -lt (Get-Date).addDays(-$DaysRetention))} | Remove-item -Verbose
  }
# Recurse switch not used.
  else {
    Get-childitem -Path $Path | Where {( ! $_.PSIsContainer) -AND ($_.LastWriteTime -lt (Get-Date).addDays(-$DaysRetention))}  | Remove-item -Verbose
  }
}

# Entered path is invalid. Output to screen.
else {
  Write-Host -ForegroundColor Red "[ERROR] Cannot find path '$Path' because it does not exist."
}

exit
