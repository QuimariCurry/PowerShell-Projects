Clear-Host

function Show-Menu {
    Write-Host "======================================"
    Write-Host "      USER ACCOUNT MANAGEMENT"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "1. Create a New User"
    Write-Host "2. Disable a User"
    Write-Host "3. Reset a User Password"
    Write-Host "4. List All Users"
    Write-Host "5. Exit"
    Write-Host ""
}

function Create-NewUser {
    Write-Host "`n--- Create New User ---`n"

    $username = Read-Host "Enter a username"
    $password = Read-Host "Enter a password" -AsSecureString
    $description = Read-Host "Enter a description (optional)"

   try {
      New-LocalUser -Name $username -Password $password -Description $description
      Write-Host "`nUser '$username' created successfully!" -ForegroundColor Green
    }
    catch {
      Write-Host "`nFailed to create user. Error." -ForegroundColor Red
      Write-Host $_
    }
}

function Disable-User {
    Write-Host "`n--- Disable User ---`n"

    $username = Read-Host "Enter the username to disable"
    
    try {
      Disable-LocalUser -Name $username -ErrorAction stop
      Write-Host "`nUser '$username' disabled successfully!" -ForegroundColor Green
    }
    catch {
      Write-Host "`nFailed to disable user. Error." -ForegroundColor Red
      Write-Host $_
    }
}

function Reset-UserPassword {
    Write-Host "`n--- Reset User Password ---`n"

    $username = Read-Host "Enter the username"
    $newpassword = Read-Host "Enter the new password" -AsSecureString

    try{
      Set-LocalUser -Name $username -Password $newpassword
      Write-Host "`nPassword reset successfully for '$username'!" -ForegroundColor Green
    }
    catch {
      Write-Host "`nFailed to reset password for '$username'. Error." -ForegroundColor Red
      Write-Host $_
    }
}

function List-AllUsers {
    Write-Host "`n--- List of Local Users ---`n"
    Get-LocalUser | Format-Table Name, Enabled, Description
}

do {
    Show-Menu
    $choice = Read-Host "Select an Option (1-5)"

    switch ($choice) {
      "1" { Create-NewUser }
      "2" { Disable-User }
      "3" { Reset-UserPassword }
      "4" { List-AllUsers }
      "5" { 
          Write-Host "`nExiting..."
          $choice = "5"
      }
      default { Write-Host "`nInvalid selection. Try again." -ForegroundColor Red }
    }

    if($choice -ne "5") {
      Write-Host "`nPress Enter to continue..."
      Read-Host
    }

  
} while ($choice -ne "5")
