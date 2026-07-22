Write-Host "=======================================================" -ForegroundColor Gray
Write-Host "		SYSTEM INFORMATION TOOL" -ForegroundColor DarkGray
Write-Host "======================================================="

Write-Host ""
Write-Host "1. View System Info" -ForegroundColor White
Write-Host "2. Save Report to Desktop" -ForegroundColor Cyan
Write-Host "3. Exit" -ForegroundColor DarkBlue
Write-Host ""

$choice = Read-Host "Select an option"

if ($choice -eq "3"){
    Write-Host "Exiting..." -ForegroundColor DarkBlue
    exit
}

if ($choice -eq "1" -or $choice -eq "2") {
    Write-Host "Gathering system information..." -ForegroundColor White
}

$computer = $env:COMPUTERNAME
$os = Get-WmiObject Win32_OperatingSystem
$cpu = Get-WmiObject Win32_Processor
$ram = [math]::Round(($os.TotalVisibleMemorySize / 1MB), 2)

$drives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

foreach ($drive in $drives) {
    $freeGB =[math]::Round(($drive.FreeSpace / 1GB), 2)
    $device =$drive.DeviceID

    if ($freeGB -lt 1) {
      Write-Host "CRITICAL: Less than 1GB free on $device drive!" -ForegroundColor Red
    }
    elseif ($freeGB -lt 5) {
      Write-Host "WARNING: Less than 5GB of free space remaining on $device drive!" -ForegroundColor Yellow
    } 
    else {
      Write-Host "$device Drive Free (GB): $freeGB" -ForegroundColor Green
    }
}

$bootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
$uptime = (Get-Date) - $bootTime

Write-Host "Computer Name: $computer"
Write-Host "OS: $($os.Caption)"
Write-Host "CPU: $($cpu.Name)"
Write-Host "RAM (GB): $ram"
Write-Host "Uptime: $($uptime.Days) days, $($uptime.Hours) hours"

if ($choice -eq "2") {

    $report = @"
System Information Report
Generated: $(Get-Date)

Computer Name: $computer
OS: $($os.Caption)
CPU: $($cpu.Name)
RAM (GB): $ram
Uptime: $($uptime.Days) days, $($uptime.Hours) hours
"@

    foreach ($drive in $drives) {
      $freeGB = [math]::Round(($drive.FreeSpace / 1GB), 2)
      $device = $drive.DeviceID
      $report += "`n$device Drive Free (GB): $freeGB"
    }

    $desktop = [Environment]::GetFolderPath("Desktop")
    $file = "SystemReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    $path = Join-Path $desktop $file

    $report | Out-File $path 

    Write-Host "Report saved to $path" -ForegroundColor Cyan
}
    