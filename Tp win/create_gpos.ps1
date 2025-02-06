# Import du module GroupPolicy
Import-Module GroupPolicy

# Définition des variables
$DomainName = (Get-ADDomain).DistinguishedName
$ExamOU = "OU=EXAM,$DomainName"

# Chemin du fond d'écran
$CorpWallpaper = "\\DC01\Partages\Commun\wallpapers\UL.jpg"

# Création de la GPO CORPWP
$CORPWP = New-GPO -Name "CORPWP"
New-GPLink -Name "CORPWP" -Target $ExamOU
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $CorpWallpaper
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"
