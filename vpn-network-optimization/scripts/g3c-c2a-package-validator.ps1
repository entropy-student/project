[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $projectRoot 'templates\clash\c2b-wg-hy2-canary.yaml.template'
$runnerPath = Join-Path $PSScriptRoot 'c2b-owner-clash-ui-canary.ps1'
$packagePath = Join-Path $projectRoot 'docs\G3C_C2B_OWNER_CANARY_PACKAGE.md'

function Assert-C2A {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Read-C2A {
    param([string]$Path)
    Assert-C2A (Test-Path -LiteralPath $Path -PathType Leaf) 'PACKAGE_SOURCE_MISSING'
    return Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
}

function Test-C2APackage {
    param([string]$TemplateText, [string]$RunnerText, [string]$PackageText)
    $runnerLower = $RunnerText.ToLowerInvariant()
    $operational = $TemplateText + "`n" + $RunnerText
    $combined = $TemplateText + "`n" + $RunnerText + "`n" + $PackageText

    if ($RunnerText -match '(?i)ProtectedData|DataProtectionScope|VPNHY2R1|hy2-g2a\.dpapi|Read-C2BRecoveryClientFields|recoveryCiphertext|recoveryPlaintext|hy2Auth|authBytes|acceptedHy2Path') {
        throw 'DPAPI_RECOVERY_OR_REAL_AUTH_ACCESS_FORBIDDEN'
    }
    if ($TemplateText -notmatch '(?m)"server"\s*:\s*"203\.0\.113\.77"') {
        throw 'REAL_HY2_ENDPOINT_DEPENDENCY_FORBIDDEN'
    }
    if ($runnerLower -match '\b(?:curl(?:\.exe)?|invoke-webrequest|invoke-restmethod|test-netconnection|start-bitstransfer|start-sleep|test-connection)\b' -or
        $operational -match '(?im)\b(?:url-test|fallback)\b|https://api\.openai\.com') {
        throw 'NETWORK_OR_DELAY_TEST_FORBIDDEN'
    }
    if ($operational -match '(?im)"type"\s*:\s*"(?:url-test|fallback)"') { throw 'AUTOMATIC_SELECTOR_FORBIDDEN' }
    if ($runnerLower -match '\b(?:new-netroute|remove-netroute|set-netroute|route\s+(?:add|delete)|set-itemproperty|new-netipinterface|set-netipinterface)\b' -or
        $runnerLower -match '\b(?:stop-service|restart-service)\b[^\r\n]*wireguard|\bwg(?:\.exe)?\s+(?:down|delete)\b' -or
        $runnerLower -match '(?im)proxyenable\s*[,=]\s*1|(?:enable-tun|tun)\s*:\s*true') {
        throw 'SYSTEM_NETWORK_MUTATION_FORBIDDEN'
    }
    if ($RunnerText -notmatch '(?im)C2B_ACK\|IMPORT=YES\|WG_VISIBLE=YES\|HY2_SYNTHETIC_VISIBLE=YES\|SELECTOR_VISIBLE=YES\|CURRENT=WG-BASELINE\|HY2_TRAFFIC=NO\|PROFILE_REMOVED=YES' -or
        $RunnerText -notmatch '(?im)Read-Host[^\r\n]*expectedAck') {
        throw 'OWNER_UI_ACK_CONTRACT_INVALID'
    }
    if ($RunnerText -notmatch '(?im)function\s+Resolve-C2BProfileStoreRoot' -or
        $RunnerText -notmatch '(?im)function\s+Get-C2BProfileSnapshot' -or
        $RunnerText -notmatch '(?im)profileSnapshotBefore\s*=\s*Get-C2BProfileSnapshot' -or
        $RunnerText -notmatch '(?im)CLASH_PROFILE_STORE_BASELINE=PASS') {
        throw 'PROFILE_STORE_PRECHECK_MISSING'
    }
    if ($RunnerText -notmatch '(?im)profileSnapshotAfter\s*=\s*Get-C2BProfileSnapshot' -or
        $RunnerText -notmatch '(?im)Assert-C2BProfileSnapshotUnchanged' -or
        $RunnerText -notmatch '(?im)CLASH_PROFILE_STORE_POSTREMOVE=PASS' -or
        $RunnerText -match '(?im)Remove-Item[^\r\n]*(?:profileStore|profiles)') {
        throw 'PROFILE_STORE_POSTCHECK_OR_NO_DELETE_GUARD_INVALID'
    }
    if ($RunnerText -notmatch '(?is)finally\s*\{.*?Remove-Item' -or
        $RunnerText -notmatch '(?im)LOCAL_RUNTIME_CLEANUP=' -or
        $RunnerText -notmatch '(?im)OWNER_UI_PROFILE_REMOVED=' -or
        $RunnerText -notmatch '(?im)CreateNew' -or
        $RunnerText -notmatch '(?im)SetAccessRuleProtection\(\$true,\s*\$false\)' -or
        $RunnerText -notmatch '(?im)FileSystemRights\]::FullControl') {
        throw 'PROJECT_RUNTIME_CLEANUP_OR_ACL_GUARD_MISSING'
    }
    if ($RunnerText -notmatch '(?im)MIHOMO_VERSION_MISMATCH' -or
        -not $RunnerText.Contains('v1\.19\.32') -or
        $RunnerText -notmatch '(?im)-t\s+-f\s+\$script:runtimeConfigPath') {
        throw 'MIHOMO_LOCAL_PARSE_GUARD_MISSING'
    }
    if ($RunnerText -notmatch '(?im)ROUND_STARTED_AT=' -or
        $RunnerText -notmatch '(?im)ROUND_FINISHED_AT=' -or
        $RunnerText -notmatch '(?im)ACTUAL_ELAPSED=' -or
        $RunnerText -notmatch '(?im)TIME_OVERRUN=') {
        throw 'TIMING_INSTRUMENTATION_MISSING'
    }
    if ($PackageText -notmatch '(?im)COLD\s*/\s*DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE' -or
        $PackageText -notmatch '(?im)C2C Gate' -or
        $PackageText -notmatch '(?im)does not prove\s+HY2 connectivity') {
        throw 'REALITY_OR_C2C_BOUNDARY_UNDOCUMENTED'
    }
    if ($PackageText -match '(?im)REALITY.{0,60}(?:PRODUCTION|MANUAL)[-_ ]READY|(?:PRODUCTION|MANUAL)[-_ ]READY.{0,60}REALITY') {
        throw 'REALITY_READINESS_OVERCLAIM'
    }
    if ($combined -match '(?im)\b(?:WLAN|Wi-Fi|Ethernet)\b|\bifIndex\s*=\s*\d+|\b(?:gateway|source[- ]IPv4)\s*=\s*(?:\d{1,3}\.){3}\d{1,3}|(?<!\d)(?:10\.(?:\d{1,3}\.){2}\d{1,3}|172\.(?:1[6-9]|2\d|3[01])\.(?:\d{1,3}\.)\d{1,3}|192\.168\.\d{1,3}\.\d{1,3})(?!\d)') {
        throw 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
    }
    if ($PackageText -match '(?is)(?:persistent|permanent).{0,120}(?:public[- ]IP|\b\d{1,3}(?:\.\d{1,3}){3}).{0,40}/32|/32.{0,120}(?:persistent|permanent)') {
        throw 'PERSISTENT_BYPASS_ROUTE_FORBIDDEN'
    }

    try { $profile = ConvertFrom-Json -InputObject $TemplateText -AsHashtable -ErrorAction Stop }
    catch { throw 'TEMPLATE_PARSE_FAILED' }
    Assert-C2A ($profile -is [System.Collections.IDictionary]) 'PROFILE_ROOT_INVALID'
    $nodes = @($profile['proxies'])
    $groups = @($profile['proxy-groups'])
    if (@($nodes | Where-Object { $_['type'] -match '(?i)vless|reality' -or $_['name'] -match '(?i)reality' }).Count -gt 0) {
        throw 'REALITY_CANDIDATE_FORBIDDEN'
    }
    Assert-C2A ($nodes.Count -eq 2) 'NODE_SET_INVALID'
    Assert-C2A (($nodes[0]['name'] -ceq 'WG-BASELINE') -and ($nodes[0]['type'] -ceq 'direct')) 'WG_BASELINE_NOT_FIRST_DIRECT'
    Assert-C2A (($nodes[1]['name'] -ceq 'HY2-SFO3') -and ($nodes[1]['type'] -ceq 'hysteria2')) 'HY2_SYNTHETIC_NODE_INVALID'
    Assert-C2A ($nodes[1]['server'] -ceq '203.0.113.77' -and $nodes[1]['port'] -eq 8443) 'SYNTHETIC_ENDPOINT_INVALID'
    Assert-C2A ($nodes[1]['password'] -ceq '__C2B_SYNTHETIC_AUTH_FIXTURE_ONLY__') 'SYNTHETIC_AUTH_SENTINEL_INVALID'
    Assert-C2A ($nodes[1]['fingerprint'] -ceq '00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00') 'SYNTHETIC_FINGERPRINT_FIXTURE_INVALID'
    Assert-C2A ($nodes[1]['sni'] -ceq 'c2b-synthetic.invalid' -and $nodes[1]['skip-cert-verify'] -eq $false) 'SYNTHETIC_TLS_METADATA_INVALID'
    Assert-C2A (-not $nodes[1].Contains('interface-name')) 'PHYSICAL_INTERFACE_DEPENDENCY_FORBIDDEN'
    Assert-C2A ($groups.Count -eq 1 -and $groups[0]['name'] -ceq 'SELF-VPN-CANARY' -and $groups[0]['type'] -ceq 'select') 'MANUAL_SELECTOR_INVALID'
    Assert-C2A ((@($groups[0]['proxies']) -join '|') -ceq 'WG-BASELINE|HY2-SFO3') 'WG_DEFAULT_OR_SELECTOR_ORDER_INVALID'
    return 'PASS'
}

function Assert-C2AExpectedFailure {
    param([string]$Name, [string]$TemplateText, [string]$RunnerText, [string]$PackageText, [string]$Expected)
    $actual = $null
    try { $null = Test-C2APackage -TemplateText $TemplateText -RunnerText $RunnerText -PackageText $PackageText }
    catch { $actual = [string]$_.Exception.Message }
    Assert-C2A ($actual -ceq $Expected) ('FIXTURE_{0}_EXPECTED_{1}_GOT_{2}' -f $Name, $Expected, $actual)
}

$templateText = Read-C2A $templatePath
$runnerText = Read-C2A $runnerPath
$packageText = Read-C2A $packagePath
$null = Test-C2APackage -TemplateText $templateText -RunnerText $runnerText -PackageText $packageText
Write-Output 'G3C_C2A_FIXTURE_A_SYNTHETIC_UI_ONLY_PACKAGE=PASS'

$fixture = ConvertFrom-Json -InputObject $templateText -AsHashtable
$fixture['proxies'] += @{ name = 'REALITY-SFO3'; type = 'vless' }
Assert-C2AExpectedFailure 'A_REALITY_LIVE' (ConvertTo-Json $fixture -Depth 20) $runnerText $packageText 'REALITY_CANDIDATE_FORBIDDEN'
$fixture = ConvertFrom-Json -InputObject $templateText -AsHashtable
$fixture['proxies'] = @($fixture['proxies'] | Where-Object { $_['name'] -cne 'WG-BASELINE' })
Assert-C2AExpectedFailure 'A_WG_MISSING' (ConvertTo-Json $fixture -Depth 20) $runnerText $packageText 'NODE_SET_INVALID'
$fixture = ConvertFrom-Json -InputObject $templateText -AsHashtable
$fixture['proxy-groups'][0]['proxies'] = @('HY2-SFO3', 'WG-BASELINE')
Assert-C2AExpectedFailure 'A_WG_NOT_DEFAULT' (ConvertTo-Json $fixture -Depth 20) $runnerText $packageText 'WG_DEFAULT_OR_SELECTOR_ORDER_INVALID'
Write-Output 'G3C_C2A_FIXTURE_A1_WG_DEFAULT_REALITY_COLD=PASS'

$fixture = ConvertFrom-Json -InputObject $templateText -AsHashtable
$fixture['proxy-groups'][0]['type'] = 'url-test'
Assert-C2AExpectedFailure 'AUTO_SELECTOR' (ConvertTo-Json $fixture -Depth 20) $runnerText $packageText 'NETWORK_OR_DELAY_TEST_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_AUTOMATIC_SELECTOR_REJECTED=PASS'

Assert-C2AExpectedFailure 'PHYSICAL_WLAN' ($templateText + "`ninterface-name: WLAN") $runnerText $packageText 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'PHYSICAL_IFINDEX' $templateText $runnerText ($packageText + "`nifIndex=18") 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'PHYSICAL_GATEWAY' $templateText $runnerText ($packageText + "`ngateway=192.168.1.1") 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'PHYSICAL_LOCAL_IP' ($templateText + "`nsource-ip=192.168.1.4") $runnerText $packageText 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_DYNAMIC_INTERFACE_ONLY=PASS'

Assert-C2AExpectedFailure 'B_DPAPI_ACCESS' $templateText ($runnerText + "`n[ProtectedData]::Unprotect(`$bytes)") $packageText 'DPAPI_RECOVERY_OR_REAL_AUTH_ACCESS_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_B_NO_DPAPI_OR_RECOVERY=PASS'

Assert-C2AExpectedFailure 'C_NONRESERVED_ENDPOINT' ($templateText.Replace('203.0.113.77', '198.51.100.9')) $runnerText $packageText 'REAL_HY2_ENDPOINT_DEPENDENCY_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_C_NO_REAL_ENDPOINT=PASS'

Assert-C2AExpectedFailure 'D_REAL_AUTH' ($templateText.Replace('__C2B_SYNTHETIC_AUTH_FIXTURE_ONLY__', 'fixture-auth-not-sentinel')) $runnerText $packageText 'SYNTHETIC_AUTH_SENTINEL_INVALID'
Write-Output 'G3C_C2A_FIXTURE_D_SYNTHETIC_AUTH_SENTINEL=PASS'

$missingFingerprint = $templateText.Replace('00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00', 'fixture-fingerprint-not-sentinel')
Assert-C2AExpectedFailure 'D_FINGERPRINT_REPLACED' $missingFingerprint $runnerText $packageText 'SYNTHETIC_FINGERPRINT_FIXTURE_INVALID'
Write-Output 'G3C_C2A_FIXTURE_D1_FINGERPRINT_FIXTURE=PASS'

$missingAck = $runnerText.Replace('HY2_SYNTHETIC_VISIBLE=YES', 'HY2_VISIBLE=YES')
Assert-C2AExpectedFailure 'E_MISSING_ACK' $templateText $missingAck $packageText 'OWNER_UI_ACK_CONTRACT_INVALID'
Write-Output 'G3C_C2A_FIXTURE_E_STRUCTURED_ACK_REQUIRED=PASS'

$missingBefore = $runnerText.Replace('$script:profileSnapshotBefore = Get-C2BProfileSnapshot -Root $script:profileStoreRoot', '# pre-snapshot removed')
Assert-C2AExpectedFailure 'F_MISSING_PROFILE_BASELINE' $templateText $missingBefore $packageText 'PROFILE_STORE_PRECHECK_MISSING'
$missingAfter = $runnerText.Replace('$script:profileSnapshotAfter = Get-C2BProfileSnapshot -Root $script:profileStoreRoot', '# post-snapshot removed')
Assert-C2AExpectedFailure 'F_MISSING_PROFILE_POSTCHECK' $templateText $missingAfter $packageText 'PROFILE_STORE_POSTCHECK_OR_NO_DELETE_GUARD_INVALID'
Write-Output 'G3C_C2A_FIXTURE_F_PROFILE_STORE_SNAPSHOTS_REQUIRED=PASS'

Assert-C2AExpectedFailure 'G_DELAY_TEST' $templateText ($runnerText + "`nStart-Sleep -Seconds 1") $packageText 'NETWORK_OR_DELAY_TEST_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_G_NO_NETWORK_OR_DELAY=PASS'

$realityProfile = ConvertFrom-Json -InputObject $templateText -AsHashtable
$realityProfile['proxies'] += @{ name = 'REALITY-SFO3'; type = 'vless' }
Assert-C2AExpectedFailure 'H_REALITY_LIVE' (ConvertTo-Json $realityProfile -Depth 20) $runnerText $packageText 'REALITY_CANDIDATE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_H_REALITY_COLD=PASS'

Assert-C2AExpectedFailure 'H_REALITY_READY_CLAIM' $templateText $runnerText ($packageText + "`nREALITY production-ready") 'REALITY_READINESS_OVERCLAIM'
Assert-C2AExpectedFailure 'H_PERSISTENT_ROUTE' $templateText $runnerText ($packageText + "`nInstall a persistent public-IP /32 route.") 'PERSISTENT_BYPASS_ROUTE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_H1_NO_REALITY_READY_OR_PERSISTENT_ROUTE=PASS'

Assert-C2AExpectedFailure 'I_ROUTE_MUTATION' $templateText ($runnerText + "`nRemove-NetRoute -DestinationPrefix '203.0.113.77/32'") $packageText 'SYSTEM_NETWORK_MUTATION_FORBIDDEN'
Assert-C2AExpectedFailure 'I_WIREGUARD_MUTATION' $templateText ($runnerText + "`nStop-Service WireGuardManager") $packageText 'SYSTEM_NETWORK_MUTATION_FORBIDDEN'
Assert-C2AExpectedFailure 'I_PROXY_TUN_MUTATION' $templateText ($runnerText + "`nSet-ItemProperty ProxyEnable 1") $packageText 'SYSTEM_NETWORK_MUTATION_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_I_NO_SYSTEM_NETWORK_MUTATION=PASS'

$withoutFinally = $runnerText -replace '(?is)\r?\nfinally\s*\{\s*\$script:completionPhase[\s\S]*\z', ''
Assert-C2AExpectedFailure 'J_MISSING_CLEANUP' $templateText $withoutFinally $packageText 'PROJECT_RUNTIME_CLEANUP_OR_ACL_GUARD_MISSING'
$withoutTiming = $runnerText.Replace('Write-Output (''ROUND_STARTED_AT='' + $script:roundStartedAt.ToString(''o''))', '# timing removed')
Assert-C2AExpectedFailure 'J_MISSING_TIMING' $templateText $withoutTiming $packageText 'TIMING_INSTRUMENTATION_MISSING'
Write-Output 'G3C_C2A_FIXTURE_J_CLEANUP_AND_TIMING_REQUIRED=PASS'

foreach ($path in @($PSCommandPath, $runnerPath)) {
    $tokens = $null
    $errors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
    Assert-C2A ($errors.Count -eq 0) ('POWERSHELL_AST_PARSE_FAILED_' + [IO.Path]::GetFileName($path))
}
Write-Output 'POWERSHELL_AST_PARSE=PASS'
Write-Output 'G3C_C2A_OFFLINE_FIXTURES=PASS'
Write-Output 'DPAPI_UNPROTECT=NO'
Write-Output 'MIHOMO_STARTED=NO'
Write-Output 'NETWORK_REQUESTS=0'
Write-Output 'NETWORK_CHANGED=NO'
