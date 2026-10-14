# Backup My Config
Backup My Config: a PowerShell GUI script to back up & restore your application configurations and drivers



## Author

* [@remusrigo](https://github.com/RemusRigo)
* [@remusrigo](https://sourceforge.net/u/remusrigo/profile)



## Features

* Back-up \& Restore:
  * Adobe CameraRAW
  * Adobe Lightroom Classic
  * Adobe Photoshop (2024, 2025)
  * GeoSetter (and GeoSetter Beta)
  * Lazarus IDE
  * Microsoft Windows Terminal
  * NuGet package manager
  * VLC
* One backup folder per user and computer; choose which backups to restore
* Backup all Windows drivers (`Export-WindowsDriver`)
* Log of every step in the window



## User's Guide

See the [User's Guide](UsersGuide.md) for requirements, installation and usage.



## Statistics

![PowerShell](https://img.shields.io/badge/Language-PowerShell-blue)
![VS](https://img.shields.io/badge/IDE-Visual%20Studio-purple)
<br>
![status](https://img.shields.io/badge/status-in%20progress-orange) 
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/RemusRigo/BackupMyConfig-PowerShell/total)



## Roadmap

* 2026-07-06: Add: NuGet package manager
* 2026-05-05: Upd: Reorganize GUI
* 2025-10-22: Add: Backup/Restore: PowerShell profile
* 2025-08-03: Add: rewrite the Restore function
* 2025-08-02: Add: verify if apps and restore points are selected when Restoring
* 2025-08-02: Add: verify if apps are selected when Backing-up
* 2025-08-02: Add: autosize columns
* 2025-07-22: Add: Backup Drivers: tested \& working
* 2025-07-22: Upd: Reorganize project into 3 parts (System settings / Applications configurations / Drivers)
* 2025-07-16: Upd: Re-think folder structure \& modify script
* 2025-07-16: Add: Backup/Restore: VLC
* 2025-06-20: Add: Backup/Restore: lazarus
* 2025-06-11: Add: Check if destination exist
* 2025-06-11: Add: Check if backup exist
* 2025-06-11: Upd: Rewrite Add-Log function
* 2025-06-11: Upd: Reorganize GUI
* 2025-06-10: Upd: Rewrite Add-Log function
* 2025-06-10: Add: Backup/Restore: Adobe Photoshop
* 2025-06-10: Add: Backup/Restore: Adobe CameraRAW
* 2025-06-09: Add: Backup/Restore: Adobe Lightroom Classic
* 2025-06-09: Add: Backup/Restore: GeoSetter
* 2025-06-09: Add: Backup/Restore: Microsoft Windows Terminal
* 2025-06-09: Add: logs
* 2025-06-09: Project started
