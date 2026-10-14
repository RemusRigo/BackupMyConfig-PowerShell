# Backup My Config: User's Guide



## Requirements

* Windows 10/11 with **Windows PowerShell 5.1** (included in Windows)
* Administrator rights only for the **Drivers** backup



## Install

1. Download the latest release from the [Releases page](https://github.com/RemusRigo/BackupMyConfig-PowerShell/releases).
2. Copy the `Backup My Config` folder to a place where you keep your backups, e.g. an external drive or `D:\Backup\Backup My Config\`.
   The backups are saved next to the script, so you can take them to another PC.
3. Start it, either way:
   * double-click `Backup My Config.bat` (it runs the script with `-ExecutionPolicy Bypass`), or
   * right-click `Backup My Config.ps1` → **Run with PowerShell**.

> If Windows blocks the script, right-click it → **Properties** → check **Unblock** → **OK**.



## Usage

The window has 3 lists: **Apps** (left), **Backups** (middle) and **Log** (right).

### Backup

1. Check the apps in the **Apps** list.
2. Click **Backup**. The configuration files are copied to `Backup\<user> on <computer>\` and every step is shown in the **Log**.

|App|What is saved|
|-|-|
|**Adobe CameraRAW**|Camera Raw settings and presets (`%AppData%\Adobe\CameraRaw`)|
|**Adobe Lightroom Classic**|Lightroom presets and settings (`%AppData%\Adobe\Lightroom`)|
|**Adobe Photoshop**|Photoshop 2024/2025 settings and presets|
|**GeoSetter**|`config.ini` and `favorites.xml` (also of GeoSetter Beta)|
|**Lazarus**|Lazarus IDE configuration (`%LocalAppData%\lazarus`)|
|**Microsoft Windows Terminal**|Windows Terminal settings|
|**NuGet package manager for .NET**|NuGet configuration|
|**VLC**|VLC preferences|

### Restore

1. Check the apps in the **Apps** list.
2. Check one or more backups in the **Backups** list (one per user and computer).
3. Click **Restore**. Close the apps first, so their settings are not overwritten when they close.

### Drivers

Click **Drivers** and accept the administrator prompt. All third-party drivers of this PC are exported to
`Drivers\<yyyy.MM.dd> <computer>\`, with the list in `Exported Drivers.txt`.
To reinstall them later, right-click a driver's `.inf` file → **Install**, or use **Device Manager → Update driver → Browse my computer**.



## Folder structure

```
Backup My Config\
├── Backup My Config.bat
├── Backup My Config.ps1
├── DrvBackup.ps1
├── Backup\
│   └── <user> on <computer>\
│       └── AppData\Roaming\...   (same structure as on the PC)
└── Drivers\
    └── <yyyy.MM.dd> <computer>\
```



## Uninstall

Delete the `Backup My Config` folder (this also deletes your backups).
