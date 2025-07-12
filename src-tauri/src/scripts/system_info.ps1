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
        @{ property = "Modele"; value = $comp.Model }
        @{ property = "N de serie"; value = $bios.SerialNumber }
        @{ property = "Version du BIOS"; value = $bios.SMBIOSBIOSVersion }
    )
}

# Memoire RAM
$ramSlots = Get-WmiObject Win32_PhysicalMemory | ForEach-Object {
    @{
        number = "Slot N$($_.DeviceLocator)"
        props = @(
            @{ property = "Modele"; value = $_.Manufacturer }
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
        @{ property = "Disque interne"; value = $disk.DeviceID }
        @{ property = "Marque"; value = $disk.Manufacturer }
        @{ property = "Modele"; value = $disk.Model }
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
        @{ property = "Modele"; value = $cpu.Name }
    )
}

# Batterie
$battery = Get-WmiObject Win32_Battery
$battValue = if ($battery) {
    "$($battery.EstimatedChargeRemaining)%"
} else {
    "Non detectee"
}
$data += @{
    title = "Batterie"
    props = @(
        @{ property = "Etat de la batterie"; value = $battValue }
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
$res = Get-CimInstance Win32_VideoController | Select-Object -First 1
$mon = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | Select-Object -First 1
$inches = if ($mon) { [math]::Round($mon.MaxHorizontalImageSize / 25.4, 1) } else { "Inconnue" }
$resolution = "$($res.CurrentHorizontalResolution)x$($res.CurrentVerticalResolution)"

$data += @{
    title = "Affichage"
    props = @(
        @{ property = "Taille en pouces"; value = $inches }
        @{ property = "Resolution"; value = $resolution }
    )
}

# Carte graphique
$gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
$data += @{
    title = "Carte graphique"
    props = @(
        @{ property = "Marque"; value = $gpu.AdapterCompatibility }
        @{ property = "Modele"; value = $gpu.Name }
        @{ property = "Memoire"; value = "$([math]::Round($gpu.AdapterRAM / 1MB)) Mo" }
    )
}

# Export JSON
$data | ConvertTo-Json -Depth 5
