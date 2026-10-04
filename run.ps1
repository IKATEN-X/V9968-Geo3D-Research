param(
    [string]$Demo,
    [string]$Emulator,
    [string]$Machine,
    [string]$CbiosDirectory,
    [switch]$External,
    [switch]$List,
    [switch]$DryRun
)
$ErrorActionPreference = 'Stop'
$catalog = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'demos.json') -Raw -Encoding UTF8 | ConvertFrom-Json
if ($List -or !$Demo) {
    $catalog.demos | Select-Object id,cpu,title,emulator,status | Format-Table -AutoSize
    return
}
$selectedEntries = @($catalog.demos | Where-Object { $_.id -eq $Demo })
if ($selectedEntries.Count -ne 1) { throw "Unknown demo '$Demo'. Use -List." }
$entry = $selectedEntries[0]
if ($entry.id -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw 'Invalid demo ID in catalog.' }
$root = [IO.Path]::GetFullPath($PSScriptRoot).TrimEnd([char]'\',[char]'/') + [IO.Path]::DirectorySeparatorChar
if ([IO.Path]::IsPathRooted($entry.file)) { throw 'ROM paths must be relative to this package.' }
$rom = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $entry.file))
if (!$rom.StartsWith($root,[StringComparison]::OrdinalIgnoreCase)) { throw 'ROM path escapes the package.' }
$romInfo = Get-Item -LiteralPath $rom
if ($romInfo.Length -ne $entry.bytes) { throw 'ROM size does not match demos.json.' }
$romHash = (Get-FileHash -LiteralPath $rom -Algorithm SHA256).Hash.ToLowerInvariant()
if ($romHash -ne $entry.sha256) { throw 'ROM SHA-256 does not match demos.json.' }
if (!$Emulator) { throw 'Specify -Emulator with the full path to the required emulator executable.' }
$executable = (Get-Item -LiteralPath $Emulator).FullName
$installation = Split-Path -Parent $executable
$environment = @{}
$isGeoOpenMSX = $entry.emulator -eq 'openMSX-Geo3D'
if ($entry.emulator -eq 'blueMSX+') {
    if ($External) { throw 'External Geo3D is not supported by the verified blueMSX+ configuration.' }
    if (!$Machine) { $Machine = 'MSXturboR - Panasonic FS-A1ST(V9968)' }
    $machineDirectory = Join-Path $installation 'Machines'
    if (!(Test-Path -LiteralPath $machineDirectory -PathType Container)) { throw 'blueMSX+ Machines directory is missing.' }
    $launchProfile = Join-Path $PSScriptRoot ('.local\blueMSX\' + $entry.id)
    $arguments = @('/rootdir',$launchProfile,'/machinedir',$machineDirectory,'/machine',$Machine,'/rom1',$rom)
    if ($entry.mapper -eq 'ASCII16') { $arguments += @('/romtype1','ASCII16') }
    elseif ($entry.mapper -ne 'Auto') { throw 'Unsupported blueMSX+ mapper in catalog.' }
    $arguments += @('/speed','100','/mute','/nofullscreen','/windowsize','3')
    $workingDirectory = $installation
} elseif ($entry.emulator -eq 'openMSX' -or $isGeoOpenMSX) {
    if ($isGeoOpenMSX -and !$CbiosDirectory) {
        throw 'For Z80 Geo3D, specify -CbiosDirectory with the three C-BIOS MSX2 ROMs.'
    }
    if (!$Machine) {
        if ($isGeoOpenMSX) { $Machine = if ($External) { 'C-BIOS_MSX2_Z80' } else { 'C-BIOS_MSX2_V9968' } }
        else { $Machine = if ($External) { 'Panasonic_FS-A1ST' } else { 'Panasonic_FS-A1ST(V9968)' } }
    }
    $systemData = Join-Path $installation 'share'
    if (!(Test-Path -LiteralPath $systemData -PathType Container)) { throw 'openMSX share directory is missing.' }
    $configuration = if ($External) { 'external' } else { 'internal' }
    $launchProfile = Join-Path $PSScriptRoot ('.local\openMSX\' + $entry.id + '-' + $configuration)
    $environment = @{
        OPENMSX_SYSTEM_DATA = $systemData
        OPENMSX_USER_DATA = (Join-Path $launchProfile 'user')
        OPENMSX_HOME = (Join-Path $launchProfile 'home')
    }
    if ($isGeoOpenMSX) {
        if ($entry.mapper -ne 'Normal' -and $entry.mapper -ne 'ASCII16') { throw 'Unsupported Z80 Geo3D mapper in catalog.' }
    } elseif ($entry.mapper -ne 'Normal') { throw 'Unsupported openMSX mapper in catalog.' }
    $arguments = @('-machine',$Machine)
    if ($External) {
        $extension = Join-Path $PSScriptRoot 'emulator\HRA_V9968.xml'
        $externalScript = Join-Path $PSScriptRoot 'emulator\external.tcl'
        if (!(Test-Path -LiteralPath $extension) -or !(Test-Path -LiteralPath $externalScript)) { throw 'External VDP helpers are missing.' }
        $arguments += @('-ext','HRA_V9968')
        if ($isGeoOpenMSX) { $arguments += @('-ext','geo3d88') }
    } elseif ($isGeoOpenMSX) {
        $arguments += @('-ext','geo3d')
    }
    $arguments += @('-cart',$rom,'-romtype',$entry.mapper)
    if ($External) { $arguments += @('-script',$externalScript) }
    $workingDirectory = $PSScriptRoot
} else { throw 'Unsupported emulator in catalog.' }
$plan = [pscustomobject]@{
    Demo=$entry.id; Rom=$rom; Bytes=$romInfo.Length; SHA256=$romHash
    Emulator=$entry.emulator; Executable=$executable; Arguments=$arguments
    WorkingDirectory=$workingDirectory; Profile=$launchProfile; Environment=$environment
    CbiosDirectory=if ($isGeoOpenMSX) { $CbiosDirectory } else { $null }
}
if ($DryRun) { $plan; return } # No directory, settings, environment or process changes.
New-Item -ItemType Directory -Path $launchProfile -Force | Out-Null
if ($entry.emulator -eq 'blueMSX+') {
    $settings = Join-Path $launchProfile 'bluemsx.ini'
    $defaultSettings = Join-Path $installation 'bluemsx.ini'
    if (!(Test-Path -LiteralPath $settings) -and (Test-Path -LiteralPath $defaultSettings)) {
        Copy-Item -LiteralPath $defaultSettings -Destination $settings
    }
} else {
    New-Item -ItemType Directory -Path $environment.OPENMSX_USER_DATA,$environment.OPENMSX_HOME -Force | Out-Null
    if ($isGeoOpenMSX) {
        & (Join-Path $PSScriptRoot 'emulator\prepare-geo3d-openmsx.ps1') -Profile $launchProfile -CbiosDirectory $CbiosDirectory | Out-Null
    }
    if ($External) {
        $extensionDirectory = Join-Path $environment.OPENMSX_USER_DATA 'extensions'
        New-Item -ItemType Directory -Path $extensionDirectory -Force | Out-Null
        $extensionTarget = Join-Path $extensionDirectory 'HRA_V9968.xml'
        if (Test-Path -LiteralPath $extensionTarget) {
            if ((Get-FileHash -LiteralPath $extensionTarget).Hash -ne (Get-FileHash -LiteralPath $extension).Hash) {
                throw 'Existing private external VDP configuration differs; it was not overwritten.'
            }
        } else { Copy-Item -LiteralPath $extension -Destination $extensionTarget }
    }
}
# Start-Process concatenates arguments; quote each complete value for Windows paths.
$quotedArguments = @($arguments | ForEach-Object { '"' + $_ + '"' })
$previousEnvironment = @{}
try {
    foreach ($name in $environment.Keys) {
        $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name,'Process')
        [Environment]::SetEnvironmentVariable($name,$environment[$name],'Process')
    }
    $process = Start-Process -FilePath $executable -ArgumentList $quotedArguments -WorkingDirectory $workingDirectory -WindowStyle Normal -PassThru
} finally {
    foreach ($name in $previousEnvironment.Keys) { [Environment]::SetEnvironmentVariable($name,$previousEnvironment[$name],'Process') }
}
Write-Host "Started $($entry.id) (PID $($process.Id)). $($entry.controls)"
Write-Output $process.Id
