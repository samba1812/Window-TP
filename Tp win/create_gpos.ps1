# Import du module GroupPolicy
Import-Module GroupPolicy

# Définition des variables
$DomainName = (Get-ADDomain).DistinguishedName
$ExamOU = "OU=EXAM,$DomainName"
$HROU = "OU=HR,OU=EXAM,$DomainName"
$ITOU = "OU=IT,OU=EXAM,$DomainName"

# Chemins des fonds d'écran (à adapter selon vos besoins)
$CorpWallpaper = "\\serveur\partage\wallpapers\corp.jpg"
$HRWallpaper = "\\serveur\partage\wallpapers\hr.jpg"
$ITWallpaper = "\\serveur\partage\wallpapers\it.jpg"

# 1. Création de la GPO CORPWP
$CORPWP = New-GPO -Name "CORPWP"
New-GPLink -Name "CORPWP" -Target $ExamOU
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $CorpWallpaper
Set-GPRegistryValue -Name "CORPWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# 2. Création de la GPO HRWP
$HRWP = New-GPO -Name "HRWP"
New-GPLink -Name "HRWP" -Target $HROU
Set-GPRegistryValue -Name "HRWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $HRWallpaper
Set-GPRegistryValue -Name "HRWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# 3. Création de la GPO ITWP
$ITWP = New-GPO -Name "ITWP"
New-GPLink -Name "ITWP" -Target $ITOU
Set-GPRegistryValue -Name "ITWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $ITWallpaper
Set-GPRegistryValue -Name "ITWP" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# 4. Création de la GPO DENY_CTRL_PANEL
$DenyCtrlPanel = New-GPO -Name "DENY_CTRL_PANEL"
New-GPLink -Name "DENY_CTRL_PANEL" -Target $ExamOU

# Bloquer l'accès au panneau de configuration
Set-GPRegistryValue -Name "DENY_CTRL_PANEL" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" -Type DWord -Value 1

# Configurer les exceptions pour Domain Admins et IT Admins
$Groups = @("Domain Admins", "IT Admins")
foreach ($Group in $Groups) {
    $Trustee = (Get-ADGroup -Identity $Group).SID.Value
    Set-GPPermission -Name "DENY_CTRL_PANEL" -TargetName $Group -TargetType Group `
        -PermissionLevel GpoApply -Deny $true
}

