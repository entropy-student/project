[CmdletBinding()]
param([switch]$Validate)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Validate) { throw 'VALIDATE_MODE_REQUIRED' }

$projectRoot = Split-Path -Parent $PSScriptRoot

$requiredFiles = @(
    'config\variables.env.example',
    'templates\wireguard\server.conf.template',
    'templates\wireguard\client.conf.template',
    'templates\hysteria2\server.yaml.template',
    'templates\systemd\hysteria2.service.template',
    'templates\clash\mihomo-hy2.yaml.template',
    'scripts\preflight-linux.sh',
    'scripts\health-check.sh',
    'scripts\migration-reinstall.sh',
    'scripts\rollback-uninstall.sh',
    'docs\G3B_MIGRATION_PACKAGE.md'
)

foreach ($relative in $requiredFiles) {
    $path = Join-Path $projectRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "REQUIRED_FILE_MISSING_$($relative.Replace('\','_').Replace('/','_').Replace('.','_'))"
    }
}

$variables = Get-Content -LiteralPath (Join-Path $projectRoot 'config\variables.env.example') -Raw
$wgClient = Get-Content -LiteralPath (Join-Path $projectRoot 'templates\wireguard\client.conf.template') -Raw
$hy2Server = Get-Content -LiteralPath (Join-Path $projectRoot 'templates\hysteria2\server.yaml.template') -Raw
$clash = Get-Content -LiteralPath (Join-Path $projectRoot 'templates\clash\mihomo-hy2.yaml.template') -Raw
$manifest = Get-Content -LiteralPath (Join-Path $projectRoot 'docs\G3B_MIGRATION_PACKAGE.md') -Raw

foreach ($name in @('SOURCE_VPS_HOST','TARGET_VPS_HOST','TARGET_EXPECTED_HOSTNAME','HY2_SNI')) {
    if ($variables -notmatch "(?m)^$([regex]::Escape($name))=") {
        throw "MIGRATION_METADATA_MISSING_$name"
    }
}

if ($wgClient -match '(?m)^AllowedIPs\s*=\s*0\.0\.0\.0/0\s*$') {
    throw 'STALE_WG_STRICT_DEFAULT_PRESENT'
}
if ($wgClient -notmatch '(?m)^AllowedIPs\s*=\s*0\.0\.0\.0/1,\s*128\.0\.0\.0/1\s*$') {
    throw 'WG_SPLIT_DEFAULT_BASELINE_MISSING'
}

foreach ($text in @($variables,$wgClient,$hy2Server,$clash)) {
    if ($text -match '192\.168\.1\.(1|4)') { throw 'HISTORICAL_WLAN_CONSTANT_PRESENT' }
    if ($text -match '24\.199\.118\.137') { throw 'CURRENT_VPS_PUBLIC_IP_PRESENT_IN_PORTABLE_PACKAGE' }
    if ($text -match '(?i)SFO3-A') { throw 'CURRENT_INSTANCE_LABEL_PRESENT_IN_PORTABLE_PACKAGE' }
}
foreach ($template in @($hy2Server,$clash)) {
    if ($template -match 'hy2\.sfo3-a\.invalid') { throw 'STALE_SFO3_SNI_PRESENT' }
}
if ($clash -notmatch '__HY2_SNI__') { throw 'HY2_SNI_PLACEHOLDER_MISSING' }

if ($manifest -notmatch 'config/clash/sfo3-a-hy2\.yaml.*must not be copied') {
    throw 'CURRENT_INSTANCE_CONFIG_BOUNDARY_MISSING'
}
if ($manifest -notmatch 'Source VPS deletion/decommission is a later Closeout Gate') {
    throw 'SOURCE_DECOMMISSION_BOUNDARY_MISSING'
}
if ($manifest -notmatch 'Secret movement is a separate Owner-authorized Gate') {
    throw 'SECRET_TRANSFER_BOUNDARY_MISSING'
}

Write-Output "G3B_REQUIRED_FILE_COUNT=$($requiredFiles.Count)"
Write-Output 'G3B_WG_SPLIT_DEFAULT_TEMPLATE=PASS'
Write-Output 'G3B_TARGET_IDENTITY_INPUTS=PASS'
Write-Output 'G3B_HY2_SNI_PARAMETERIZATION=PASS'
Write-Output 'G3B_CURRENT_INSTANCE_CONFIG_BOUNDARY=PASS'
Write-Output 'G3B_SECRET_TRANSFER_BOUNDARY=PASS'
Write-Output 'G3B_SOURCE_DECOMMISSION_BOUNDARY=PASS'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'VPS_MUTATION=NO'
Write-Output 'PROVIDER_ACTION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3B_D1_PACKAGE_VALIDATION=PASS'
