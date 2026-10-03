[CmdletBinding()]
param([switch]$Validate)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Validate) { throw 'VALIDATE_MODE_REQUIRED' }

$projectRoot = Split-Path -Parent $PSScriptRoot
$profilePath = Join-Path $projectRoot 'templates\clash\self-vpn-manual.yaml.template'
$contractPath = Join-Path $projectRoot 'docs\G3C_MANUAL_CONTROL_CONTRACT.md'

function Assert-C1 {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Read-C1 {
    param([string]$Path)
    Assert-C1 (Test-Path -LiteralPath $Path -PathType Leaf) 'C1_REQUIRED_SOURCE_MISSING'
    return Get-Content -LiteralPath $Path -Raw
}

function ConvertFrom-C1Profile {
    param([string]$Text)
    try {
        $value = ConvertFrom-Json -InputObject $Text -AsHashtable -ErrorAction Stop
    }
    catch {
        throw 'PROFILE_JSON_YAML_SUBSET_PARSE_FAILED'
    }
    Assert-C1 ($value -is [System.Collections.IDictionary]) 'PROFILE_ROOT_NOT_MAPPING'
    return $value
}

function Test-C1Contract {
    param([string]$ProfileText, [string]$ContractText)

    $profile = ConvertFrom-C1Profile -Text $ProfileText
    $proxies = @($profile['proxies'])
    $groups = @($profile['proxy-groups'])
    Assert-C1 ($proxies.Count -eq 3) 'PROXY_COUNT_INVALID'
    Assert-C1 ($groups.Count -eq 1) 'PROXY_GROUP_COUNT_INVALID'

    $nodeNames = @($proxies | ForEach-Object { $_['name'] })
    Assert-C1 (($nodeNames -join '|') -ceq 'WG-BASELINE|HY2-SFO3|REALITY-SFO3') 'PROXY_SET_OR_ORDER_INVALID'

    $wg = @($proxies | Where-Object { $_['name'] -ceq 'WG-BASELINE' })
    $hy2 = @($proxies | Where-Object { $_['name'] -ceq 'HY2-SFO3' })
    $reality = @($proxies | Where-Object { $_['name'] -ceq 'REALITY-SFO3' })
    Assert-C1 ($wg.Count -eq 1 -and $wg[0]['type'] -ceq 'direct') 'WG_BASELINE_NOT_DIRECT'

    $group = $groups[0]
    Assert-C1 ($group['name'] -ceq 'SELF-VPN-MANUAL') 'MANUAL_GROUP_NAME_INVALID'
    Assert-C1 ($group['type'] -ceq 'select') 'MANUAL_GROUP_NOT_SELECT'
    $selection = @($group['proxies'])
    Assert-C1 (($selection -join '|') -ceq 'WG-BASELINE|HY2-SFO3|REALITY-SFO3') 'WG_BASELINE_NOT_FIRST_OR_SELECTION_INVALID'

    $automaticTypes = @('url-test', 'fallback', 'load-balance', 'smart')
    foreach ($candidateGroup in $groups) {
        Assert-C1 ($candidateGroup['type'] -notin $automaticTypes) 'AUTOMATIC_SELECTION_TYPE_FORBIDDEN'
    }

    Assert-C1 ($hy2.Count -eq 1) 'HY2_NODE_MISSING'
    Assert-C1 ($hy2[0]['type'] -ceq 'hysteria2') 'HY2_SCHEMA_INVALID'
    Assert-C1 ($hy2[0]['server'] -ceq '__VPS_HOST__') 'HY2_SERVER_NOT_PARAMETERIZED'
    Assert-C1 ($hy2[0]['port'] -eq 8443) 'HY2_PORT_INVALID'
    Assert-C1 ($hy2[0]['password'] -ceq '__EXTERNAL_SECRET_NOT_IN_REPOSITORY__') 'HY2_AUTH_SENTINEL_MISSING_OR_POPULATED'
    Assert-C1 ($hy2[0]['sni'] -ceq '__HY2_SNI__') 'HY2_SNI_NOT_PARAMETERIZED'
    Assert-C1 ($hy2[0]['skip-cert-verify'] -eq $true) 'HY2_SELF_SIGNED_TLS_POLICY_CHANGED'
    Assert-C1 ($hy2[0]['fingerprint'] -ceq '__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__') 'HY2_FINGERPRINT_SENTINEL_MISSING_OR_POPULATED'
    Assert-C1 ((@($hy2[0]['alpn']) -join '|') -ceq 'h3') 'HY2_ALPN_INVALID'

    Assert-C1 ($reality.Count -eq 1) 'REALITY_NODE_MISSING'
    Assert-C1 ($reality[0]['type'] -ceq 'vless') 'REALITY_TYPE_INVALID'
    Assert-C1 ($reality[0]['server'] -ceq '__VPS_HOST__') 'REALITY_SERVER_NOT_PARAMETERIZED'
    Assert-C1 ($reality[0]['port'] -eq 443) 'REALITY_PORT_INVALID'
    Assert-C1 ($reality[0]['uuid'] -ceq '__EXTERNAL_REALITY_UUID_NOT_IN_REPOSITORY__') 'REALITY_UUID_SENTINEL_MISSING_OR_POPULATED'
    Assert-C1 ($reality[0]['udp'] -eq $false) 'REALITY_UDP_SEMANTICS_CHANGED'
    Assert-C1 ($reality[0]['flow'] -ceq 'xtls-rprx-vision') 'REALITY_FLOW_CHANGED'
    Assert-C1 ($reality[0]['network'] -ceq 'tcp') 'REALITY_NETWORK_CHANGED'
    Assert-C1 ($reality[0]['tls'] -eq $true) 'REALITY_TLS_DISABLED'
    Assert-C1 ($reality[0]['servername'] -ceq '__REALITY_SNI__') 'REALITY_SNI_NOT_PARAMETERIZED'
    Assert-C1 ($reality[0]['client-fingerprint'] -ceq 'chrome') 'REALITY_CLIENT_FINGERPRINT_CHANGED'
    $realityOptions = $reality[0]['reality-opts']
    Assert-C1 ($realityOptions['public-key'] -ceq '__TARGET_REALITY_PUBLIC_KEY_AFTER_LATER_GATE__') 'REALITY_PUBLIC_KEY_SENTINEL_MISSING_OR_POPULATED'
    Assert-C1 ($realityOptions['short-id'] -ceq '__TARGET_REALITY_SHORT_ID_AFTER_LATER_GATE__') 'REALITY_SHORT_ID_SENTINEL_MISSING_OR_POPULATED'
    foreach ($node in $proxies) {
        foreach ($key in $node.Keys) {
            Assert-C1 ($key -notmatch '(?i)^(?:auth|token|secret|api[-_]?key|private[-_]?key|tls[-_]?key)$') 'UNEXPECTED_CREDENTIAL_FIELD_FORBIDDEN'
        }
    }
    foreach ($key in $realityOptions.Keys) {
        Assert-C1 ($key -notmatch '(?i)^(?:auth|token|secret|api[-_]?key|private[-_]?key|tls[-_]?key)$') 'REALITY_PRIVATE_KEY_FIELD_FORBIDDEN'
    }

    $dynamicInterface = '__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__'
    Assert-C1 ($hy2[0]['interface-name'] -ceq $dynamicInterface -and $reality[0]['interface-name'] -ceq $dynamicInterface) 'PHYSICAL_INTERFACE_NOT_DYNAMIC'
    Assert-C1 ($ContractText.Contains('REALITY_SERVER_PRIVATE_KEY_SENTINEL=__EXTERNAL_REALITY_PRIVATE_KEY_NOT_IN_REPOSITORY__')) 'REALITY_PRIVATE_KEY_SENTINEL_MISSING'

    $combined = $ProfileText + "`n" + $ContractText
    Assert-C1 ($combined -notmatch '(?im)\b(?:WLAN|Wi-Fi|Ethernet)\b') 'HARDCODED_PHYSICAL_INTERFACE'
    Assert-C1 ($combined -notmatch '(?im)"(?:ifindex|interface-index|gateway|source-ip|source-address)"\s*:') 'HARDCODED_PHYSICAL_NETWORK_PROPERTY'
    Assert-C1 ($combined -notmatch '(?<!\d)(?:10\.(?:\d{1,3}\.){2}\d{1,3}|172\.(?:1[6-9]|2\d|3[01])\.(?:\d{1,3}\.)\d{1,3}|192\.168\.(?:\d{1,3}\.)\d{1,3})(?!\d)') 'HARDCODED_PRIVATE_IPV4'

    $routePattern = '(?im)\b(?:route\s+add|new-netroute|netsh\s+interface\s+ipv4\s+add\s+route)\b|\b(?:\d{1,3}\.){3}\d{1,3}/32\b|\b(?:persistent|permanent)\s+(?:public[- ]ip\s+)?(?:bypass\s+)?route\b'
    Assert-C1 ($combined -notmatch $routePattern) 'PERSISTENT_BYPASS_ROUTE_INSTRUCTION_PRESENT'

    Assert-C1 ($ContractText.Contains('REALITY_READINESS=COLD_CANDIDATE / NOT_READY_FOR_MANUAL_USE')) 'REALITY_COLD_MARKER_MISSING'
    Assert-C1 ($ContractText -notmatch '(?im)^REALITY_READINESS=(?:PRODUCTION_READY|MANUAL_READY|READY_FOR_MANUAL_USE)\b') 'REALITY_READINESS_UNSAFE'
    Assert-C1 ($ContractText.Contains('MANUAL_DELAY_TEST_URL=https://www.gstatic.com/generate_204')) 'MANUAL_DELAY_TEST_URL_MISSING'
    Assert-C1 ($ContractText.Contains('MANUAL_DELAY_TEST_MODE=OWNER_INITIATED_ONLY_NO_AUTOMATIC_SWITCH')) 'MANUAL_DELAY_TEST_MODE_INVALID'

    return 'PASS'
}

function Assert-C1ExpectedFailure {
    param([string]$Name, [string]$ProfileText, [string]$ContractText, [string]$ExpectedCode)
    $actualCode = $null
    try { $null = Test-C1Contract -ProfileText $ProfileText -ContractText $ContractText }
    catch { $actualCode = [string]$_.Exception.Message }
    Assert-C1 ($actualCode -ceq $ExpectedCode) ('FIXTURE_{0}_EXPECTED_{1}_GOT_{2}' -f $Name, $ExpectedCode, $actualCode)
}

$profileText = Read-C1 -Path $profilePath
$contractText = Read-C1 -Path $contractPath
$null = Test-C1Contract -ProfileText $profileText -ContractText $contractText
Write-Output 'G3C_C1_FIXTURE_A_VALID_PROFILE=PASS'

$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['interface-name'] = 'WLAN'
Assert-C1ExpectedFailure -Name 'B_WLAN' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'PHYSICAL_INTERFACE_NOT_DYNAMIC'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['interface-index'] = 18
Assert-C1ExpectedFailure -Name 'B_IFINDEX' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HARDCODED_PHYSICAL_NETWORK_PROPERTY'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['gateway'] = '192.168.1.1'
Assert-C1ExpectedFailure -Name 'B_GATEWAY' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HARDCODED_PHYSICAL_NETWORK_PROPERTY'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['source-ip'] = '192.168.1.4'
Assert-C1ExpectedFailure -Name 'B_LOCAL_IPV4' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HARDCODED_PHYSICAL_NETWORK_PROPERTY'
Write-Output 'G3C_C1_FIXTURE_B_HARDCODED_PHYSICAL_DETAILS=PASS'

$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'] = @($fixture['proxies'] | Where-Object { $_['name'] -cne 'WG-BASELINE' })
Assert-C1ExpectedFailure -Name 'C_WG_MISSING' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'PROXY_COUNT_INVALID'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxy-groups'][0]['proxies'] = @('HY2-SFO3', 'WG-BASELINE', 'REALITY-SFO3')
Assert-C1ExpectedFailure -Name 'C_WG_NOT_DEFAULT' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'WG_BASELINE_NOT_FIRST_OR_SELECTION_INVALID'
Write-Output 'G3C_C1_FIXTURE_C_WG_BASELINE_DEFAULT=PASS'

foreach ($automaticType in @('url-test', 'fallback', 'load-balance')) {
    $fixture = ConvertFrom-C1Profile -Text $profileText
    $fixture['proxy-groups'][0]['type'] = $automaticType
    Assert-C1ExpectedFailure -Name "D_$($automaticType.Replace('-', '_'))" -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'MANUAL_GROUP_NOT_SELECT'
}
Write-Output 'G3C_C1_FIXTURE_D_NO_AUTOMATIC_SELECTION=PASS'

$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['password'] = 'fixture-secret-marker'
Assert-C1ExpectedFailure -Name 'E_HY2_AUTH' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HY2_AUTH_SENTINEL_MISSING_OR_POPULATED'
$fixture = ConvertFrom-C1Profile -Text $profileText
$null = $fixture['proxies'][1].Remove('password')
Assert-C1ExpectedFailure -Name 'E_HY2_AUTH_REMOVED' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HY2_AUTH_SENTINEL_MISSING_OR_POPULATED'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][1]['fingerprint'] = 'fixture-fingerprint-marker'
Assert-C1ExpectedFailure -Name 'E_HY2_FINGERPRINT' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'HY2_FINGERPRINT_SENTINEL_MISSING_OR_POPULATED'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][2]['uuid'] = 'fixture-uuid-marker'
Assert-C1ExpectedFailure -Name 'E_REALITY_UUID' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'REALITY_UUID_SENTINEL_MISSING_OR_POPULATED'
$fixture = ConvertFrom-C1Profile -Text $profileText
$fixture['proxies'][2]['reality-opts']['private-key'] = 'fixture-private-key-marker'
Assert-C1ExpectedFailure -Name 'E_REALITY_PRIVATE_KEY_FIELD' -ProfileText (ConvertTo-Json -InputObject $fixture -Depth 20) -ContractText $contractText -ExpectedCode 'REALITY_PRIVATE_KEY_FIELD_FORBIDDEN'
Write-Output 'G3C_C1_FIXTURE_E_SECRET_SENTINELS=PASS'

$routeDoc = $contractText + "`nPersistent bypass route instruction: 203.0.113.7/32 via 203.0.113.1.`n"
Assert-C1ExpectedFailure -Name 'F_PERSISTENT_ROUTE' -ProfileText $profileText -ContractText $routeDoc -ExpectedCode 'PERSISTENT_BYPASS_ROUTE_INSTRUCTION_PRESENT'
Write-Output 'G3C_C1_FIXTURE_F_NO_PERSISTENT_BYPASS_ROUTE=PASS'

$unsafeRealityDoc = $contractText.Replace('REALITY_READINESS=COLD_CANDIDATE / NOT_READY_FOR_MANUAL_USE', 'REALITY_READINESS=PRODUCTION_READY / MANUAL_READY')
Assert-C1ExpectedFailure -Name 'G_REALITY_READY' -ProfileText $profileText -ContractText $unsafeRealityDoc -ExpectedCode 'REALITY_COLD_MARKER_MISSING'
Write-Output 'G3C_C1_FIXTURE_G_REALITY_COLD_ONLY=PASS'

Write-Output 'G3C_C1_OFFLINE_FIXTURES=PASS'
Write-Output 'G3C_C1_PROFILE_SYNTAX=JSON_COMPATIBLE_YAML_PARSE_PASS'
Write-Output 'G3C_C1_MIHOMO_NATIVE_PARSE=NOT_RUN_NO_VERIFIED_LOCAL_BINARY'
Write-Output 'NETWORK_CHANGED=NO'
Write-Output 'CLASH_STARTED=NO'
Write-Output 'SYSTEM_PROXY_CHANGED=NO'
Write-Output 'TUN_CHANGED=NO'
Write-Output 'WIREGUARD_CHANGED=NO'
Write-Output 'ROUTE_CHANGED=NO'
Write-Output 'SECRET_VALUES_ACCESSED=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
