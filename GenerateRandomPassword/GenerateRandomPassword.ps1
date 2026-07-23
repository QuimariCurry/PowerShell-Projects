param(
    [int]$length = 14
)
$character = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()'
$characterarray = $character.ToCharArray()
$random = -join (1..$length |ForEach-Object{$characterarray | Get-Random})
Write-Host "Random Password: $Random"
