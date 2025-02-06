# Import du module GroupPolicy
Import-Module GroupPolicy

# Récupération du nom de domaine
$DomainName = (Get-ADDomain).DistinguishedName

# Chemins des fonds d'écran (à adapter selon votre environnement)
$CorpWallpaper = "\\DC01\Partages\Commun\wallpapers\UL.jpg"
$HRWallpaper = "\\DC01\Partages\Commun\wallpapers\HR.jpg"
$ITWallpaper = "\\DC01\Partages\Commun\wallpapers\IT.jpg"

# Création et configuration de la GPO Corporate
$CORPWP = New-GPO -Name "CORPWP"
New-GPLink -Name "CORPWP" -Target $DomainName
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $CorpWallpaper
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# Création et configuration de la GPO HR
$HRWP = New-GPO -Name "HRWP"
New-GPLink -Name "HRWP" -Target "OU=HR,$DomainName"
Set-GPRegistryValue -Name "HRWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $HRWallpaper
Set-GPRegistryValue -Name "HRWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# Création et configuration de la GPO IT
$ITWP = New-GPO -Name "ITWP"
New-GPLink -Name "ITWP" -Target "OU=IT,$DomainName"
Set-GPRegistryValue -Name "ITWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $ITWallpaper
Set-GPRegistryValue -Name "ITWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"
