$data = @()

# Informations generales
$bios = Get-WmiObject Win32_BIOS
$comp = Get-WmiObject Win32_ComputerSystem
$os = Get-WmiObject Win32_OperatingSystem

$data += @{
    title = "Informations generales"
    props = @(
        @{ property = "Nom"; value = $env:COMPUTERNAME }
        @{ property = "Version de Windows"; value = $os.Caption }
        @{ property = "Marque"; value = $comp.Manufacturer }
        @{ property = "Model"; value = $comp.Model }
        @{ property = "Num. serie"; value = $bios.SerialNumber }
        @{ property = "Version du BIOS"; value = $bios.SMBIOSBIOSVersion }
    )
}

# Memoire RAM
$ramSlots = Get-WmiObject Win32_PhysicalMemory | ForEach-Object {
    @{
        number = "Slot : $($_.DeviceLocator)"
        props = @(
            @{ property = "Marque"; value = $_.Manufacturer }
            @{ property = "Type"; value = $_.MemoryType }
            @{ property = "Taille"; value = "$([math]::Round($_.Capacity / 1GB)) Go" }
            @{ property = "Frequence"; value = "$($_.Speed) MHz" }
        )
    }
}

$data += @{
    title = "Memoire RAM"
    slots = $ramSlots
}

# Stockage de masse
$disk = Get-WmiObject Win32_DiskDrive | Select-Object -First 1
$data += @{
    title = "Stockage de masse"
    props = @(
        @{ property = "Disque interne"; value = $disk.Name }
        @{ property = "Marque"; value = $disk.Manufacturer }
        @{ property = "Model"; value = $disk.Model }
        @{ property = "Taille"; value = "$([math]::Round($disk.Size / 1GB)) Go" }
    )
}

# Processeur
$cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
$data += @{
    title = "Processeur"
    props = @(
        @{ property = "Architecture"; value = switch ($cpu.Architecture) {
            0 { "x86" }; 9 { "x64" }; default { "Inconnue" }
        } }
        @{ property = "Marque"; value = $cpu.Manufacturer }
        @{ property = "Model"; value = $cpu.Name }
    )
}

# Batterie
# Données principales
$battery = Get-WmiObject Win32_Battery

# Données avancées depuis le namespace root\wmi
$static = Get-WmiObject -Namespace root\wmi -Class BatteryStaticData
$status = Get-WmiObject -Namespace root\wmi -Class BatteryStatus
$full = Get-WmiObject -Namespace root\wmi -Class BatteryFullChargedCapacity

# Fallbacks et sécurités
$battValue = if ($battery) { "$($battery.EstimatedChargeRemaining)%" } else { "Non détectée" }
$voltage = if ($battery.DesignVoltage) { "$([math]::Round($battery.DesignVoltage / 1000, 2)) V" } else { "Inconnue" }

# Infos avancées avec vérif
$manufacturer = if ($static.ManufactureName) { $static.ManufactureName } else { "Inconnue" }
$model = if ($static.DeviceName) { $static.DeviceName } else { "Inconnu" }
$capMax = if ($full.FullChargedCapacity) { "$($full.FullChargedCapacity) mWh" } else { "Inconnue" }
$capRest = if ($status.RemainingCapacity) { "$($status.RemainingCapacity) mWh" } else { "Inconnue" }

# Ajout dans les données
$data += @{
    title = "Batterie"
    props = @(
        @{ property = "Etat de la batterie"; value = $battValue }
        @{ property = "Marque"; value = $manufacturer }
        @{ property = "Model"; value = $model }
        @{ property = "Capacite maximale"; value = $capMax }
        @{ property = "Capacite restante"; value = $capRest }
        @{ property = "Tension (design)"; value = $voltage }
    )
}


# Carte(s) reseau
$netAdapters = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true }
$networkProps = @()
$i = 1
foreach ($adapter in $netAdapters) {
    $networkProps += @{ property = "Carte n $i"; value = $adapter.Name }
    $i++
}
$data += @{
    title = "Carte(s) reseau"
    props = $networkProps
}

# Affichage / Moniteur
$resolutions = Get-CimInstance Win32_VideoController
$monitorInfo = @()
$index = 1

foreach ($res in $resolutions) {
    $resolution = "$($res.CurrentHorizontalResolution)x$($res.CurrentVerticalResolution)"
    $monitorInfo += @{
        property = "Ecran $index"
        value = "Resolution: $resolution"
    }
    $index++
}

if ($monitorInfo.Count -eq 0) {
    $monitorInfo += @{ property = "Affichage"; value = "Aucun ecran detecte" }
}

$data += @{
    title = "Affichage"
    props = $monitorInfo
}

# Carte graphique
$gpus = Get-WmiObject Win32_VideoController
$gpuProps = @()
$index = 1

foreach ($gpu in $gpus) {
    $nom = $gpu.Name
    $marque = $gpu.AdapterCompatibility
    $ram = "$([math]::Round($gpu.AdapterRAM / 1MB)) Mo"
    $gpuProps += @{
        property = "Carte $index"
        value = "$marque $nom - $ram"
    }
    $index++
}

$data += @{
    title = "Carte graphique"
    props = $gpuProps
}

# Export JSON
$data | ConvertTo-Json -Depth 5
