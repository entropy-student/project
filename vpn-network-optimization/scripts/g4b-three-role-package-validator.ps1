[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$clashTemplate = Join-Path $projectRoot 'templates\clash\self-vpn-v1-three-role.yaml.template'
$serverTemplate = Join-Path $projectRoot 'templates\reality\mihomo-reality-server.yaml.template'
$serviceTemplate = Join-Path $projectRoot 'templates\systemd\mihomo-reality-vpn-network-optimization.service.template'
$gateDoc = Join-Path $projectRoot 'docs\G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md'
$planDoc = Join-Path $projectRoot 'docs\G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md'

function Assert-G4B {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

foreach ($path in @($clashTemplate,$serverTemplate,$serviceTemplate,$gateDoc,$planDoc)) {
    Assert-G4B (Test-Path -LiteralPath $path -PathType Leaf) 'G4B_REQUIRED_FILE_MISSING'
}

$clashText = [IO.File]::ReadAllText($clashTemplate,[Text.Encoding]::UTF8)
$clash = ConvertFrom-Json -InputObject $clashText -AsHashtable -ErrorAction Stop

Assert-G4B ($clash['proxies'].Count -eq 3) 'G4B_CLASH_PROXY_CARDINALITY_INVALID'
Assert-G4B ($clash['proxies'][0]['name'] -ceq 'HY2-SFO3') 'G4B_PRIMARY_ORDER_INVALID'
Assert-G4B ($clash['proxies'][1]['name'] -ceq 'WG-BASELINE') 'G4B_BACKUP1_ORDER_INVALID'
Assert-G4B ($clash['proxies'][1]['type'] -ceq 'direct') 'G4B_WG_DIRECT_INVALID'
Assert-G4B ($clash['proxies'][2]['name'] -ceq 'REALITY-SFO3') 'G4B_BACKUP2_ORDER_INVALID'
Assert-G4B ($clash['proxy-groups'].Count -eq 1) 'G4B_GROUP_CARDINALITY_INVALID'
Assert-G4B ($clash['proxy-groups'][0]['name'] -ceq 'SELF-VPN-V1') 'G4B_GROUP_NAME_INVALID'
Assert-G4B ($clash['proxy-groups'][0]['type'] -ceq 'select') 'G4B_GROUP_NOT_MANUAL_SELECT'
Assert-G4B (($clash['proxy-groups'][0]['proxies'] -join '|') -ceq 'HY2-SFO3|WG-BASELINE|REALITY-SFO3') 'G4B_GROUP_ORDER_INVALID'
Assert-G4B ($clashText -notmatch '(?i)url-test|fallback|load-balance') 'G4B_AUTOMATIC_SELECTION_PRESENT'

foreach ($placeholder in @(
    '__HY2_AUTH_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__HY2_CERT_SHA256__',
    '__REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_PUBLIC_KEY_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__'
)) {
    Assert-G4B ($clashText.Contains($placeholder)) 'G4B_CLASH_PLACEHOLDER_MISSING'
}

$serverText = [IO.File]::ReadAllText($serverTemplate,[Text.Encoding]::UTF8)
foreach ($required in @(
    'listen: __VPS_PUBLIC_IP__',
    'port: 443',
    'type: vless',
    'flow: xtls-rprx-vision',
    'dest: www.microsoft.com:443',
    'private-key: __REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__',
    'uuid: __REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__'
)) {
    Assert-G4B ($serverText.Contains($required)) 'G4B_REALITY_SERVER_CONTRACT_INVALID'
}

$serviceText = [IO.File]::ReadAllText($serviceTemplate,[Text.Encoding]::UTF8)
foreach ($required in @(
    '/usr/local/lib/vpn-network-optimization/mihomo-reality',
    '/srv/apps/vpn-network-optimization/reality',
    '/srv/apps/vpn-network-optimization/secrets/reality-server.yaml',
    'User=__REALITY_RUNTIME_USER__',
    'Group=__REALITY_RUNTIME_USER__',
    'Restart=on-failure',
    'NoNewPrivileges=true',
    'AmbientCapabilities=CAP_NET_BIND_SERVICE',
    'CapabilityBoundingSet=CAP_NET_BIND_SERVICE',
    'ProtectSystem=strict',
    'ProtectHome=true'
)) {
    Assert-G4B ($serviceText.Contains($required)) 'G4B_SYSTEMD_CONTRACT_INVALID'
}

$allText = $clashText + [Environment]::NewLine + $serverText + [Environment]::NewLine + $serviceText
Assert-G4B ($allText -notmatch '(?i)password:\s+[0-9a-f]{32,}|uuid:\s+[0-9a-f]{8}-[0-9a-f-]{27,}') 'G4B_REAL_SECRET_SHAPE_PRESENT'
Assert-G4B (([regex]::Matches($serverText, '(?m)^\s*private-key:')).Count -eq 1 -and $serverText.Contains('private-key: __REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__')) 'G4B_REALITY_PRIVATE_KEY_PLACEHOLDER_INVALID'

Write-Output 'G4B_THREE_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2'
Write-Output 'G4B_MANUAL_SELECTOR_ONLY=PASS'
Write-Output 'G4B_CLASH_TEMPLATE=PASS'
Write-Output 'G4B_REALITY_SERVER_TEMPLATE=PASS'
Write-Output 'G4B_SYSTEMD_TEMPLATE=PASS'
Write-Output 'G4B_SECRET_PLACEHOLDERS_ONLY=PASS'
Write-Output 'G4B_OFFLINE_PACKAGE_VALIDATION=PASS'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SECRET_ACCESS=NO'
Write-Output 'OWNER_AUTHORIZATION_REQUIRED_FOR_LIVE_G4B=YES'
