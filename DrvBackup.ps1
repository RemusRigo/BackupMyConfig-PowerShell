#---------------------------------------------------------------------------------------------------------------------------
# Config Backup: Backup Drivers
#    © 2025 Remus Rigo
# v1.0.20250723

#---------------------------------------------------------------------------------------------------------------------------
# Run As Admin

$drvPath = Get-Date -Format "yyyy.MM.dd"
$drvPath = Join-Path -Path $PSScriptRoot -ChildPath "Drivers\$($drvPath) $($env:COMPUTERNAME)"
if (!(Test-Path -Path $drvPath))
{
      New-Item -ItemType Directory -Path $drvPath
}

Export-WindowsDriver -Online -Destination "$drvPath" | Out-File -FilePath "$drvPath\Exported Drivers.txt" -Encoding utf8

