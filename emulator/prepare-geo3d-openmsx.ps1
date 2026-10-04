param(
    [Parameter(Mandatory=$true)][string]$Profile,
    [string]$CbiosDirectory='D:\blueMSX+\Machines\MSX2 - C-BIOS'
)
$ErrorActionPreference='Stop'
$userData=Join-Path $Profile 'user'
$openmsxHome=Join-Path $Profile 'home'
$machineDirectory=Join-Path $userData 'machines'
New-Item -ItemType Directory -Path $userData,$openmsxHome,$machineDirectory -Force | Out-Null

foreach ($name in @('C-BIOS_MSX2_V9968.xml','C-BIOS_MSX2_Z80.xml')) {
    $source=Join-Path $PSScriptRoot $name
    $target=Join-Path $machineDirectory $name
    if (Test-Path -LiteralPath $target) {
        if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash) {
            throw "Private machine definition differs; not overwritten: $target"
        }
    } else { Copy-Item -LiteralPath $source -Destination $target }
}

# These three C-BIOS ROMs stay private. Their SHA-1 values are the ones in the
# bundled machine XML files; no BIOS file is copied into the repository itself.
$biosHashes=@{
    'cbios_main_msx2.rom'='c371688b4c5858bf4374992fc165b81e3f08e745'
    'cbios_logo_msx2.rom'='c670c8b61d4a775d9ea30718cf25b68a551020bc'
    'cbios_sub.rom'='2043aac247feec970de382f1c8511d95d013aca6'
}
foreach ($name in $biosHashes.Keys) {
    $source=Join-Path $CbiosDirectory $name
    if (!(Test-Path -LiteralPath $source -PathType Leaf)) { throw "C-BIOS ROM not found: $source" }
    $hash=(Get-FileHash -LiteralPath $source -Algorithm SHA1).Hash.ToLowerInvariant()
    if ($hash -ne $biosHashes[$name]) { throw "Unexpected C-BIOS ROM version: $source" }
    $target=Join-Path $machineDirectory $name
    if (Test-Path -LiteralPath $target) {
        if ((Get-FileHash -LiteralPath $target -Algorithm SHA1).Hash.ToLowerInvariant() -ne $hash) {
            throw "Private C-BIOS ROM differs; not overwritten: $target"
        }
    } else { Copy-Item -LiteralPath $source -Destination $target }
}
[pscustomobject]@{UserData=$userData; Home=$openmsxHome; MachineDirectory=$machineDirectory}
