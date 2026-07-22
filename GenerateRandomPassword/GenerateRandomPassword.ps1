$length = 14
$character = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()'
$random = -join ((Get-Random -Count $length -InputObject $character.ToCharArray()) |ForEach-Object {$_})
Write-Host "Random Password: $Random"
