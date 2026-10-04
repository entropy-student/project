[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $projectRoot 'templates\clash\g4b0-hy2-interface-bypass.yaml.template'
$gatePath = Join-Path $projectRoot 'docs\G4B0_WINDOWS_INTERFACE_BYPASS_CANARY_GATE.md'

function Assert-G4B0 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

foreach($path in @($templatePath,$gatePath)){
    Assert-G4B0 (Test-Path -LiteralPath $path -PathType Leaf) 'G4B0_REQUIRED_FILE_MISSING'
}

$templateText = [IO.File]::ReadAllText($templatePath,[Text.Encoding]::UTF8)
$cfg = ConvertFrom-Json -InputObject $templateText -AsHashtable -ErrorAction Stop

Assert-G4B0 ($cfg['allow-lan'] -eq $false) 'G4B0_ALLOW_LAN_INVALID'
Assert-G4B0 ($cfg['bind-address'] -ceq '127.0.0.1') 'G4B0_BIND_ADDRESS_INVALID'
Assert-G4B0 ($cfg['tun']['enable'] -eq $false) 'G4B0_TUN_MUST_BE_OFF'
Assert-G4B0 ($cfg['proxies'].Count -eq 1) 'G4B0_PROXY_CARDINALITY_INVALID'
Assert-G4B0 ($cfg['proxies'][0]['name'] -ceq 'HY2-INTERFACE-BYPASS-CANARY') 'G4B0_PROXY_NAME_INVALID'
Assert-G4B0 ($cfg['proxies'][0]['type'] -ceq 'hysteria2') 'G4B0_PROXY_TYPE_INVALID'
Assert-G4B0 ($cfg['proxies'][0]['port'] -eq 8443) 'G4B0_HY2_PORT_INVALID'
Assert-G4B0 ($cfg['proxies'][0]['interface-name'] -ceq '__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__') 'G4B0_INTERFACE_PLACEHOLDER_MISSING'
Assert-G4B0 ($cfg['proxy-groups'].Count -eq 1) 'G4B0_GROUP_CARDINALITY_INVALID'
Assert-G4B0 ($cfg['proxy-groups'][0]['type'] -ceq 'select') 'G4B0_GROUP_TYPE_INVALID'
Assert-G4B0 (($cfg['proxy-groups'][0]['proxies'] -join '|') -ceq 'HY2-INTERFACE-BYPASS-CANARY') 'G4B0_GROUP_CONTENT_INVALID'

foreach($placeholder in @(
    '__LOCAL_PROXY_PORT__',
    '__VPS_HOST__',
    '__HY2_AUTH_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__HY2_SNI__',
    '__HY2_CERT_SHA256__',
    '__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__'
)){
    Assert-G4B0 ($templateText.Contains($placeholder)) 'G4B0_REQUIRED_PLACEHOLDER_MISSING'
}

Assert-G4B0 ($templateText -notmatch '(?i)reality|vless|wg-baseline|url-test|fallback|load-balance') 'G4B0_SCOPE_EXPANSION_PRESENT'

$gateText = [IO.File]::ReadAllText($gatePath,[Text.Encoding]::UTF8)
foreach($required in @(
    'TEMP_OR_PERSISTENT_VPS_32_ROUTE_CREATED=NO',
    'REQUEST_COUNT=2',
    'SYSTEM_PROXY_FINAL=OFF',
    'TUN_FINAL=OFF',
    'No SSH or VPS mutation is needed'
)){
    Assert-G4B0 ($gateText.Contains($required)) 'G4B0_GATE_CONTRACT_MISSING'
}

Write-Output 'G4B0_TEMPLATE_PARSE=PASS'
Write-Output 'G4B0_INTERFACE_NAME_ONLY=PASS'
Write-Output 'G4B0_NO_ROUTE_CONTRACT=PASS'
Write-Output 'G4B0_NO_REALITY_OR_WG_NODE=PASS'
Write-Output 'G4B0_TUN_DISABLED=PASS'
Write-Output 'G4B0_REQUEST_BUDGET=2'
Write-Output 'G4B0_OFFLINE_PACKAGE_VALIDATION=PASS'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SECRET_ACCESS=NO'
Write-Output 'OWNER_AUTHORIZATION_REQUIRED_FOR_LIVE_G4B0=YES'
