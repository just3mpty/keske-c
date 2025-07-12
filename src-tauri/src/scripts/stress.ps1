$duration = 190
$sw = [Diagnostics.Stopwatch]::StartNew()

while ($sw.Elapsed.TotalSeconds -lt $duration) {
    1..5000 | ForEach-Object { [math]::Sqrt($_) } > $null
}

$sw.Stop()