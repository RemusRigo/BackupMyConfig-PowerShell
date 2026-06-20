#--------------------------------------------------------------------------------------------------
# Config Backup
#   © 2025 Remus Rigo
#      v1.1 2026-05-05
#                                                   [System.Windows.Forms.MessageBox]::Show("Test")
#--------------------------------------------------------------------------------------------------

Clear-Host
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$appMainTitle = "Config Backup v1.1 by Remus Rigo"
$selectedApps = 01
$selectedBackup = 0

#--------------------------------------------------------------------------------------------------
# GUI / controls

# Main Form ---------------------------------------------------------------------------------------
$frmBackup = New-Object System.Windows.Forms.Form
$frmBackup.AutoScroll = $true
$frmBackup.FormBorderStyle = "FixedSingle"
$frmBackup.MaximizeBox = $false
$frmBackup.MinimizeBox = $true
$frmBackup.Size = New-Object System.Drawing.Size(1100, 600)
$frmBackup.Text = $appAppsTitle
$frmBackup.StartPosition = "CenterScreen"

# ListView: Apps ----------------------------------------------------------------------------------
$lvApps = New-Object System.Windows.Forms.ListView
$lvApps.CheckBoxes = $true
$lvApps.Columns.Add("Apps", 250)
$lvApps.FullRowSelect = $true
$lvApps.Location = New-Object System.Drawing.Point(3,3)
$lvApps.Size = New-Object System.Drawing.Size(300,($frmBackup.Height-80))
$lvApps.View = [System.Windows.Forms.View]::Details

# ListView: Backups -------------------------------------------------------------------------------
$lvAppsBackup = New-Object System.Windows.Forms.ListView
$lvAppsBackup.CheckBoxes = $true
$lvAppsBackup.Columns.Add("Backups", 200)
$lvAppsBackup.FullRowSelect = $true
$lvAppsBackup.Location = New-Object System.Drawing.Point(($lvApps.Location.X+$lvApps.Width+3),3)
$lvAppsBackup.Size = New-Object System.Drawing.Size(300,($frmBackup.Height-80))
$lvAppsBackup.View = [System.Windows.Forms.View]::Details

# ListView: Log -----------------------------------------------------------------------------------
$lvAppsLog = New-Object System.Windows.Forms.ListView
$lvAppsLog.CheckBoxes = $false
$lvAppsLog.Columns.Add("Log", ($lvAppsLog.Width-5))
$lvAppsLog.FullRowSelect = $true
$lvAppsLog.Location = New-Object System.Drawing.Point(($lvAppsBackup.Location.X+$lvAppsBackup.Width+3),3)
$lvAppsLog.Size = New-Object System.Drawing.Size(470,($frmBackup.Height-80))
$lvAppsLog.View = [System.Windows.Forms.View]::Details

# Button: Backup ----------------------------------------------------------------------------------
$btnBackup = New-Object System.Windows.Forms.Button
$btnBackup.Location = New-Object System.Drawing.Point(5, ($lvApps.Height+3))
$btnBackup.Size = New-Object System.Drawing.Size(60,24)
$btnBackup.Text = "Backup"
$btnBackup.BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)

# Button: Restore ---------------------------------------------------------------------------------
$btnRestore = New-Object System.Windows.Forms.Button
$btnRestore.Location = New-Object System.Drawing.Point(($btnBackup.Location.X + $btnBackup.Width+3), ($lvApps.Height+3))
$btnRestore.Size = New-Object System.Drawing.Size(60,24)
$btnRestore.Text = "Restore"
$btnRestore.BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)

# Button: Drivers ---------------------------------------------------------------------------------
$btnDrivers = New-Object System.Windows.Forms.Button
$btnDrivers.Location = New-Object System.Drawing.Point(($frmBackup.Width-80), ($lvApps.Height+3))
$btnDrivers.Size = New-Object System.Drawing.Size(60,24)
$btnDrivers.Text = "Drivers"

#--------------------------------------------------------------------------------------------------

function Add-Log($msg)
{
   $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
   $item = New-Object System.Windows.Forms.ListViewItem("$($timestamp): $($msg)")
   $lvAppsLog.Invoke([Action] { $lvAppsLog.Items.Add($item) })
   $lvAppsLog.AutoResizeColumn(0, [System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
}

function Scan-Backups
{
   $rootBkPath = Join-Path -Path $PSScriptRoot -ChildPath "Backup"   
   $lvAppsBackup.Items.Clear()
   $folders = Get-ChildItem -Path $rootBkPath -Directory -Force -ErrorAction SilentlyContinue
   foreach ($folder in $folders) {
      $item = New-Object System.Windows.Forms.ListViewItem($folder.Name)
      $lvAppsBackup.Items.Add($item)
   }

   $lvAppsBackup.AutoResizeColumn(0, [System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
}

# Backup Apps --------------------------------------------------------------------------------------------------------------
function Backup-Apps
{
   $rootBkPath = Join-Path -Path $PSScriptRoot -ChildPath "Backup\$($env:USERNAME) on $($env:COMPUTERNAME)"

   for ($i = 0; $i -lt $lvApps.Items.Count; $i++)
   {
      if ($lvApps.Items[$i].checked)
      {
         switch ($lvApps.Items[$i].Text)
         {
            #---------------------------------------------------------------------------------------------------------------
            "Adobe CameraRAW"
            {
               Add-Log "Backup: Backup: Adobe CameraRAW: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\CameraRaw"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\Adobe\CameraRaw")
               {
                  Add-Log "Backup: Backup: Adobe CameraRAW: configuration found"

                  $customFolders = @(
                     "CameraProfiles",
                     "Curves",
                     "Defaults",
                     "GPU",
                     "ImportedSettings",
                     "LensProfileDefaults",
                     "LensProfiles",
                     "LocalCorrections",
                     "ModelSupport",
                     "ModelZoo",
                     "SaveOptions",
                     "Settings",
                     "UI",
                     "Workflow"
                  )
                  foreach ($folder in $customFolders)
                  {
                     Copy-Item -Path "$($env:AppData)\Adobe\CameraRaw\$($folder)" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  }
                  Add-Log "Backup: Backup: Adobe CameraRAW: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Backup: Adobe CameraRAW: configuration not found"
               }
                  $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }
            
            "Adobe Lightroom Classic" #-------------------------------------------------------------------------------------
            {
               Add-Log "Backup: Adobe Lightroom Classic: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Lightroom"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\Adobe\Lightroom")
               {
                  Add-Log "Backup: Adobe Lightroom Classic: configuration found"
                  $customFolders = @(
                     "Color Profiles",
                     "Develop Presets",
                     "Export Actions",
                     "Export Presets",
                     "External Editor Presets",
                     "Filename Templates",
                     "Filter Presets",
                     "Import Presets",
                     "Keyword Sets",
                     "Label Sets",
                     "Local Adjustment Presets",
                     "Locations",
                     "Metadata",
                     "Metadata Presets",
                     "Modules",
                     "Preferences",
                     "Slideshow Templates",
                     "Smart Collection Templates",
                     "Watermarks"
                  )
                  foreach ($folder in $customFolders)
                  {
                  Copy-Item -Path "$($env:AppData)\Adobe\Lightroom\$($folder)" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  }
                  Add-Log "Backup: Adobe Lightroom Classic: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Adobe Lightroom Classic: configuration not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            #---------------------------------------------------------------------------------------------------------------
            "Adobe Photoshop" 
            {
               Add-Log "Backup: Adobe Photoshop 2024: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Adobe Photoshop 2024"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\Adobe\Adobe Photoshop 2024")
               {
                  Add-Log "Backup: Adobe Photoshop 2024: configuration found"
                  Copy-Item -Path "$($env:AppData)\Adobe\Adobe Photoshop 2024\Adobe Photoshop 2024 Settings" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  Copy-Item -Path "$($env:AppData)\Adobe\Adobe Photoshop 2024\Presets" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: Adobe Photoshop 2024: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Adobe Photoshop 2024: configuration not found"
               }

               Add-Log "Backup: Adobe Photoshop 2025: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Adobe Photoshop 2025"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\Adobe\Adobe Photoshop 2025")
               {
                  Add-Log "Backup: Adobe Photoshop 2025: configuration found"
                  Copy-Item -Path "$($env:AppData)\Adobe\Adobe Photoshop 2025\Adobe Photoshop 2025 Settings" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  Copy-Item -Path "$($env:AppData)\Adobe\Adobe Photoshop 2025\Presets" -Destination $bkPath -Recurse -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: Adobe Photoshop 2025: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Adobe Photoshop 2025: configuration not found"
               }

               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            "GeoSetter" #---------------------------------------------------------------------------------------------------
            {
               Add-Log "Backup: GeoSetter: Start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\GeoSetter"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\GeoSetter")
               {
                  Add-Log "Backup: GeoSetter: configuration found"
                  Copy-Item -Path "$($env:AppData)\GeoSetter\config.ini" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Copy-Item -Path "$($env:AppData)\GeoSetter\favorites.xml" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: GeoSetter: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: GeoSetter: configuration not found"
               }

               Add-Log "Backup: GeoSetter Beta: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\GeoSetter_beta"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\GeoSetter_beta")
               {
                  Add-Log "Backup: GeoSetter Beta: configuration found"
                  Copy-Item -Path "$($env:AppData)\GeoSetter_beta\config.ini" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Copy-Item -Path "$($env:AppData)\GeoSetter_beta\favorites.xml" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: GeoSetter Beta: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: GeoSetter Beta: configuration not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            #---------------------------------------------------------------------------------------------------------------
            "Lazarus" 
            {
               Add-Log "Backup: Lazarus: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Local\lazarus"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:LocalAppData)\lazarus")
               {
                  Add-Log "Backup: Lazarus: configuration found"
                  Copy-Item -Path "$($env:LocalAppData)\lazarus\*" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: Lazarus: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Lazarus: configuration not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            #---------------------------------------------------------------------------------------------------------------
            "Microsoft Windows Terminal" 
            {
               Add-Log "Backup: Microsoft Windows Terminal: start"

               # config
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }

               if (Test-Path -Path "$($env:LocalAppData)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState")
               {
                  Add-Log "Backup: Microsoft Windows Terminal: configuration found"
                  Copy-Item -Path "$($env:LocalAppData)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: Microsoft Windows Terminal: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Microsoft Windows Terminal: configuration not found"
               }

               # profile
               $profileFile = "$([Environment]::GetFolderPath('MyDocuments'))\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "MyDocuments\WindowsPowerShell"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path $profileFile)
               {
                  Add-Log "Backup: Microsoft Windows Terminal: profile found"
                  Copy-Item -Path $profileFile -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: Microsoft Windows Terminal: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: Microsoft Windows Terminal: profile not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            #---------------------------------------------------------------------------------------------------------------
            "VLC" 
            {
               Add-Log "Backup: VLC: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\VLC"
               if (!(Test-Path -Path $bkPath))
               {
                  New-Item -ItemType Directory -Path $bkPath
               }
               if (Test-Path -Path "$($env:AppData)\VLC")
               {
                  Add-Log "Backup: VLC: configuration found"
                  Copy-Item -Path "$($env:AppData)\VLC\vlcrc" -Destination $bkPath -Force -ErrorAction SilentlyContinue
                  Add-Log "Backup: VLC: file(s) copied"
               }
               else
               {
                  Add-Log "Backup: VLC: configuration not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(200, 255, 200)
            }

            #---------------------------------------------------------------------------------------------------------------

         }
      }
   }
}

# Restore Apps --------------------------------------------------------------------------------------------------------------
function Restore-Apps($backupPoint)
{
   $rootBkPath = Join-Path -Path $PSScriptRoot -ChildPath "Backup\$($backupPoint)"

   for ($i = 0; $i -lt $lvApps.Items.Count; $i++)
   {
      if ($lvApps.Items[$i].checked)
      {
         switch ($lvApps.Items[$i].Text)
         {
            "Adobe CameraRAW" #--------------------------------------------------------------------------------------------
            {
               Add-Log "Restore: Adobe CameraRAW: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\CameraRaw"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Adobe CameraRAW: backup found"
                  if (Test-Path -Path "$($env:AppData)\Adobe\CameraRaw")
                  {
                     Add-Log "Restore: : start"
                     $customFolders = @(
                        "CameraProfiles",
                        "Curves",
                        "Defaults",
                        "GPU",
                        "ImportedSettings",
                        "LensProfileDefaults",
                        "LensProfiles",
                        "LocalCorrections",
                        "ModelSupport",
                        "ModelZoo",
                        "SaveOptions",
                        "Settings",
                        "UI",
                        "Workflow"
                     )
                     foreach ($folder in $customFolders)
                     {
                        Copy-Item -Path "$($bkPath)\$($folder)" -Destination "$($env:AppData)\Adobe\CameraRaw" -Recurse -Force -ErrorAction SilentlyContinue
                     }
                     Add-Log "Restore: Adobe CameraRAW: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Adobe CameraRAW: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Adobe CameraRAW: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            "Adobe Lightroom Classic" #-------------------------------------------------------------------------------------
            {
               Add-Log "Restore: Adobe Lightroom Classic: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Lightroom"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Adobe Lightroom Classic: backup found"
                  if (Test-Path -Path "$($env:AppData)\Adobe\Lightroom")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\Adobe\Lightroom" -Recurse -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: Adobe Lightroom Classic: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Adobe Lightroom Classic: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Adobe Lightroom Classic: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            #---------------------------------------------------------------------------------------------------------------
            "Adobe Photoshop" 
            {
               Add-Log "Restore: Adobe Photoshop 2024: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Adobe Photoshop 2024"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Adobe Photoshop 2024: backup found"
                  if (Test-Path -Path "$($env:AppData)\Adobe\Adobe Photoshop 2024")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\Adobe\Adobe Photoshop 2024" -Recurse -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: Adobe Photoshop 2024: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Adobe Photoshop 2024: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Adobe Photoshop 2024: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
               
               
               Add-Log "Restore: Adobe Photoshop 2025: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\Adobe\Adobe Photoshop 2025"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Adobe Photoshop 2025: backup found"
                  if (Test-Path -Path "$($env:AppData)\Adobe\Adobe Photoshop 2025")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\Adobe\Adobe Photoshop 2025" -Recurse -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: Adobe Photoshop 2025: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Adobe Photoshop 2025: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Adobe Photoshop 2025: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }
            
            "GeoSetter" #---------------------------------------------------------------------------------------------------
            {
               Add-Log "Restore: GeoSetter: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\GeoSetter"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: GeoSetter: backup found"
                  if (Test-Path -Path "$($env:AppData)\GeoSetter")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\GeoSetter" -Recurse -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: GeoSetter: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: GeoSetter: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: GeoSetter: backup not found"
               }

               Add-Log "Restore: GeoSetter Beta: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\GeoSetter_beta"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: GeoSetter Beta: backup found"
                  if (Test-Path -Path "$($env:AppData)\GeoSetter")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\GeoSetter_beta" -Recurse -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: GeoSetter Beta: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: GeoSetter Beta: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: GeoSetter Beta: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            "Lazarus" #----------------------------------------------------------------------------------
            {
               Add-Log "Restore: Lazarus: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Local\lazarus"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Lazarus: backup found"
                  if (Test-Path -Path "$($env:LocalAppData)\Lazarus")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:LocalAppData)\Lazarus" -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: Microsoft Windows Terminal: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Lazarus: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Lazarus: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            "Microsoft Windows Terminal" #----------------------------------------------------------------------------------
            {
               Add-Log "Restore: Microsoft Windows Terminal: start"

               # config
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Microsoft Windows Terminal: backup found"
                  if (Test-Path -Path "$($env:LocalAppData)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState")
                  {
                     Copy-Item -Path "$($bkPath)\settings.json" -Destination "$($env:LocalAppData)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: Microsoft Windows Terminal: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: Microsoft Windows Terminal: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: Microsoft Windows Terminal: backup config not found"
               }

               # profile
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "MyDocuments\WindowsPowerShell"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: Microsoft Windows Terminal: profile found"
                  Copy-Item -Path "$($bkPath)\Microsoft.PowerShell_profile.ps1" -Destination "$([Environment]::GetFolderPath('MyDocuments'))\WindowsPowerShell" -Force -ErrorAction SilentlyContinue
                  Add-Log "Restore: Microsoft Windows Terminal: profile file copied"
               }
               else
               {
                  Add-Log "Restore: Microsoft Windows Terminal: backup profile not found"
               }

               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            "VLC" #---------------------------------------------------------------------------------------------------------
            {
               Add-Log "Restore: VLC: start"
               $bkPath = Join-Path -Path $rootBkPath -ChildPath "AppData\Roaming\VLC"
               if (Test-Path -Path $bkPath)
               {
                  Add-Log "Restore: VLC: backup found"
                  if (Test-Path -Path "$($env:AppData)\VLC")
                  {
                     Copy-Item -Path $bkPath\* -Destination "$($env:AppData)\VLC" -Force -ErrorAction SilentlyContinue
                     Add-Log "Restore: VLC: file(s) copied"
                  }
                  else
                  {
                     Add-Log "Restore: VLC: destination not found"
                  }
               }
               else
               {
                  Add-Log "Restore: VLC: backup not found"
               }
               $lvApps.Items[$i].BackColor = [System.Drawing.Color]::FromArgb(127, 217, 235)
            }

            #---------------------------------------------------------------------------------------------------------------
         }
      }
   }
}

# LoadApps -----------------------------------------------------------------------------------------------------------------
function Load-Apps
{
   $lvApps.Items.Clear()
   function Add-Item ($appName)
   {  
      $item = New-Object System.Windows.Forms.ListViewItem($appName)
      $lvApps.Invoke([Action] { $lvApps.Items.Add($item) })
   }
   Add-Item "Adobe CameraRAW"
   Add-Item "Adobe Lightroom Classic"
   Add-Item "Adobe Photoshop"
   Add-Item "GeoSetter"
   Add-Item "Lazarus"
   Add-Item "Microsoft Windows Terminal"
   Add-Item "VLC"

   $lvApps.AutoResizeColumn(0, [System.Windows.Forms.ColumnHeaderAutoResizeStyle]::ColumnContent)
}

#---------------------------------------------------------------------------------------------------------------------------
# Methods/Events

$btnBackup.Add_Click({
   if ($lvApps.CheckedItems.Count -eq 0)
   {
      [System.Windows.Forms.MessageBox]::Show("No Apps selected")
   }
   else
   {
      Backup-Apps
   }
})

$btnRestore.Add_Click({
   if ($lvApps.CheckedItems.Count -eq 0)
   {
      [System.Windows.Forms.MessageBox]::Show("No Apps selected")
   }

   if ($lvAppsBackup.CheckedItems.Count -eq 0)
   {
      [System.Windows.Forms.MessageBox]::Show("No Backup Point selected")
   }
   else
   {
      for ($i = 0; $i -lt $lvAppsBackup.Items.Count; $i++)
      {
         if ($lvAppsBackup.Items[$i].checked)
         {
            Restore-Apps($lvAppsBackup.Items[$i].Text)
         }
      }
   }
})

$btnDrivers.Add_Click({
   $psFile = Join-Path -Path $PSScriptRoot -ChildPath "DrvBackup.ps1"
   $psFileQuoted = "`"$psFile`""
   Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $psFileQuoted -Verb RunAs -Wait
})

#---------------------------------------------------------------------------------------------------------------------------
# Controls
$frmBackup.Controls.AddRange(@($lvApps, $lvAppsBackup, $lvAppsLog, $btnBackup, $btnRestore, $btnDrivers))

$frmBackup.Add_Shown({
   $frmBackup.Activate()
   Load-Apps
   Scan-Backups
})

[void] $frmBackup.ShowDialog()