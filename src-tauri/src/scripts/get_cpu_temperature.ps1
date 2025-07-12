$temps = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | ForEach-Object {
    [PSCustomObject]@{
        Nom = $_.InstanceName
        TempC = [math]::Round(($_.CurrentTemperature - 2732) / 10, 1)
    }
}

if ($temps.Count -eq 0) {
    Write-Host "⚠️ Impossible de récupérer la température (non exposée par le BIOS)"
} else {
    $temps | Format-Table
}
