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




    # Import des modules nécessaires
Import-Module GroupPolicy

# Récupération du nom de domaine
$DomainName = (Get-ADDomain).DistinguishedName

# Création de la GPO
$GPOName = "DENY_CTRL_PANEL"
New-GPO -Name $GPOName

# Lier la GPO à l'OU EXAM
New-GPLink -Name $GPOName -Target "OU=EXAM,$DomainName"

# Configurer la restriction du panneau de configuration
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" -Type DWord -Value 1

# Configuration des exceptions pour les groupes spécifiés
$SecurityFilter = @(
    "Domain Admins",
    "IT Admins"
)

# Appliquer les filtres de sécurité
$GPO = Get-GPO -Name $GPOName
foreach ($Group in $SecurityFilter) {
    # Vérifier si le groupe existe
    if (Get-ADGroup -Filter {Name -eq $Group}) {
        # Ajouter les permissions de lecture et d'application
        Set-GPPermission -Name $GPOName -TargetName $Group -TargetType Group -PermissionLevel GpoRead
        Set-GPPermission -Name $GPOName -TargetName $Group -TargetType Group -PermissionLevel GpoApply
    } else {
        Write-Warning "Le groupe $Group n'existe pas dans le domaine"
    }
}

# Retirer les permissions "Authenticated Users" pour l'application
Set-GPPermission -Name $GPOName -TargetName "Authenticated Users" -TargetType Group -PermissionLevel None

# Ajouter "Authenticated Users" en lecture seule (nécessaire pour le fonctionnement de la GPO)
Set-GPPermission -Name $GPOName -TargetName "Authenticated Users" -TargetType Group -PermissionLevel GpoRead