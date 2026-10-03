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
    try { $profile = ConvertFrom-Json -InputObject $TemplateText -AsHashtable -ErrorAction Stop }
    catch { throw 'TEMPLATE_PARSE_FAILED' }
    Assert-C2A ($profile -is [System.Collections.IDictionary]) 'PROFILE_ROOT_INVALID'
    $nodes = @($profile['proxies'])
    $groups = @($profile['proxy-groups'])
    Assert-C2A ($nodes.Count -eq 2) 'LIVE_NODE_SET_INVALID'
    Assert-C2A (($nodes[0]['name'] -ceq 'WG-BASELINE') -and ($nodes[0]['type'] -ceq 'direct')) 'WG_BASELINE_NOT_FIRST_DIRECT'
    Assert-C2A (($nodes[1]['name'] -ceq 'HY2-SFO3') -and ($nodes[1]['type'] -ceq 'hysteria2')) 'HY2_NODE_INVALID'
    Assert-C2A ($groups.Count -eq 1 -and $groups[0]['type'] -ceq 'select') 'MANUAL_SELECTOR_INVALID'
    Assert-C2A ((@($groups[0]['proxies']) -join '|') -ceq 'WG-BASELINE|HY2-SFO3') 'LIVE_SELECTOR_ORDER_OR_MEMBERS_INVALID'
    Assert-C2A ($nodes[1]['password'] -ceq '__HY2_AUTH_INJECTED_IN_OWNER_RUNTIME__') 'HY2_SECRET_SENTINEL_INVALID'
    Assert-C2A ($nodes[1]['fingerprint'] -ceq '__HY2_FINGERPRINT_INJECTED_IN_OWNER_RUNTIME__') 'HY2_FINGERPRINT_SENTINEL_INVALID'
    Assert-C2A ($nodes[1]['interface-name'] -ceq '__PHYSICAL_INTERFACE_RUNTIME_DISCOVERY__') 'PHYSICAL_INTERFACE_NOT_DYNAMIC'
    Assert-C2A ($nodes[1]['server'] -ceq '24.199.118.137' -and $nodes[1]['port'] -eq 8443) 'HY2_ENDPOINT_INVALID'
    Assert-C2A ($nodes[1]['sni'] -ceq 'hy2.sfo3-a.invalid' -and $nodes[1]['skip-cert-verify'] -eq $true) 'HY2_TLS_CONTRACT_INVALID'

    $combined = $TemplateText + "`n" + $RunnerText + "`n" + $PackageText
    if ($combined -match '(?im)\b(?:WLAN|Wi-Fi|Ethernet)\b|\bifIndex\s*=\s*\d+|\b(?:gateway|source[- ]IPv4)\s*=\s*(?:\d{1,3}\.){3}\d{1,3}|(?<!\d)(?:10\.(?:\d{1,3}\.){2}\d{1,3}|172\.(?:1[6-9]|2\d|3[01])\.(?:\d{1,3}\.)\d{1,3}|192\.168\.\d{1,3}\.\d{1,3})(?!\d)') { throw 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN' }
    if ($combined -match '(?im)\b(?:Write-Output|Write-Host|Write-Verbose|Write-Warning|Out-File|Add-Content|Set-Content)\b[^\r\n]*(?:hy2Auth|authBytes|AuthBytes)|(?<![A-Fa-f0-9])(?:[0-9a-f]{64})(?![A-Fa-f0-9])') { throw 'PLAINTEXT_SECRET_OUTPUT_OR_VALUE' }
    if ($combined -match '(?im)(?:ProxyEnable\s*[,=]\s*1|Set-ItemProperty[^\r\n]*ProxyEnable|(?:enable-tun|tun)\s*:\s*true|Set-NetIPInterface[^\r\n]*Forwarding)') { throw 'AUTOMATIC_PROXY_OR_TUN_ENABLE_FORBIDDEN' }
    if ($combined -match '(?im)\b(?:Stop-Service|Restart-Service)\b[^\r\n]*WireGuard|\bwg(?:\.exe)?\s+(?:down|delete)\b|\b(?:Remove-NetRoute|route\s+delete|netsh\s+interface\s+ipv4\s+delete\s+route)\b') { throw 'WIREGUARD_OR_ROUTE_MUTATION_FORBIDDEN' }
    if ($combined -match '(?im)\b(?:New-NetRoute|route\s+add|netsh\s+interface\s+ipv4\s+add\s+route)\b|\b(?:create|add|install|configure|use)\b.{0,100}\bpersistent\b.{0,100}\b(?:route|/32)\b|\bpersistent\b.{0,100}\b(?:public[- ]IP\s+)?(?:\d{1,3}\.){3}\d{1,3}/32\b') { throw 'PERSISTENT_BYPASS_ROUTE_FORBIDDEN' }
    if ($RunnerText -notmatch '(?is)finally\s*\{.*?Remove-Item' -or
        $RunnerText -notmatch '(?im)LOCAL_RUNTIME_CLEANUP=' -or
        $RunnerText -notmatch '(?im)OWNER_UI_PROFILE_REMOVED=') { throw 'CLEANUP_ROLLBACK_MARKERS_MISSING' }
    if ($RunnerText -notmatch '(?im)ROUND_STARTED_AT=' -or
        $RunnerText -notmatch '(?im)ROUND_FINISHED_AT=' -or
        $RunnerText -notmatch '(?im)ACTUAL_ELAPSED=' -or
        $RunnerText -notmatch '(?im)TIME_OVERRUN=' -or
        $RunnerText.IndexOf('ROUND_STARTED_AT=', [StringComparison]::Ordinal) -gt $RunnerText.IndexOf('$script:phase = ''PRECHECK_RUNTIME''', [StringComparison]::Ordinal)) { throw 'TIMING_INSTRUMENTATION_MISSING_OR_LATE' }
    if ($PackageText -notmatch '(?im)COLD\s*/\s*DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE') { throw 'REALITY_COLD_DEFERRED_MARKER_MISSING' }
    if ($RunnerText -notmatch '(?im)MIHOMO_VERSION_MISMATCH' -or -not $RunnerText.Contains('v1\.19\.32')) { throw 'MIHOMO_PIN_MISSING' }
    if ($RunnerText -notmatch '(?im)CreateNew' -or
        $RunnerText -notmatch '(?im)SetAccessRuleProtection\(\$true,\s*\$false\)' -or
        $RunnerText -notmatch '(?im)FileSystemRights\]::FullControl' -or
        $RunnerText -notmatch '(?im)Guid\]::NewGuid' -or
        $RunnerText -notmatch '(?im)-t\s+-f\s+\$script:runtimeConfigPath') { throw 'OWNER_RUNTIME_OR_NATIVE_PARSE_GUARD_MISSING' }
    if ($PackageText -notmatch '(?im)system WireGuard connected' -or
        $PackageText -notmatch '(?im)system proxy/TUN off' -or
        $PackageText -notmatch '(?im)profile auto-apply') { throw 'OWNER_CHECKPOINT_BOUNDARY_UNDOCUMENTED' }
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
Write-Output 'G3C_C2A_FIXTURE_A_VALID_PACKAGE=PASS'

$fixture = ConvertFrom-Json -InputObject $templateText -AsHashtable
$fixture['proxies'] += @{ name = 'REALITY-SFO3'; type = 'vless' }
Assert-C2AExpectedFailure 'B_REALITY_LIVE' (ConvertTo-Json $fixture -Depth 20) $runnerText $packageText 'LIVE_NODE_SET_INVALID'
Write-Output 'G3C_C2A_FIXTURE_B_REALITY_EXCLUDED=PASS'

Assert-C2AExpectedFailure 'C_HARDCODED_INTERFACE' $templateText $runnerText ($packageText + "`n# WLAN") 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'C_HARDCODED_IFINDEX' $templateText ($runnerText + "`n# ifIndex=18") $packageText 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'C_HARDCODED_GATEWAY' $templateText $runnerText ($packageText + "`n# gateway=192.168.1.1") 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Assert-C2AExpectedFailure 'C_HARDCODED_LOCAL_IP' $templateText $runnerText ($packageText + "`n# 192.168.1.4") 'PHYSICAL_NETWORK_HARDCODE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_C_DYNAMIC_EGRESS=PASS'

$secretOutputRunner = $runnerText + "`nWrite-Output `$script:hy2Auth"
Assert-C2AExpectedFailure 'D_SECRET_OUTPUT' $templateText $secretOutputRunner $packageText 'PLAINTEXT_SECRET_OUTPUT_OR_VALUE'
Assert-C2AExpectedFailure 'D_SECRET_VALUE' ($templateText.Replace('__HY2_AUTH_INJECTED_IN_OWNER_RUNTIME__', ('a' * 64))) $runnerText $packageText 'HY2_SECRET_SENTINEL_INVALID'
Write-Output 'G3C_C2A_FIXTURE_D_SECRET_BOUNDARY=PASS'

Assert-C2AExpectedFailure 'E_PROXY_ENABLE' $templateText ($runnerText + "`nSet-ItemProperty ProxyEnable 1") $packageText 'AUTOMATIC_PROXY_OR_TUN_ENABLE_FORBIDDEN'
Assert-C2AExpectedFailure 'E_TUN_ENABLE' $templateText ($runnerText + "`ntun: true") $packageText 'AUTOMATIC_PROXY_OR_TUN_ENABLE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_E_NO_PROXY_TUN_ENABLE=PASS'

Assert-C2AExpectedFailure 'F_WG_STOP' $templateText ($runnerText + "`nStop-Service WireGuardManager") $packageText 'WIREGUARD_OR_ROUTE_MUTATION_FORBIDDEN'
Assert-C2AExpectedFailure 'F_ROUTE_REMOVE' $templateText ($runnerText + "`nRemove-NetRoute -DestinationPrefix x") $packageText 'WIREGUARD_OR_ROUTE_MUTATION_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_F_NO_WG_OR_ROUTE_MUTATION=PASS'

Assert-C2AExpectedFailure 'G_PERSISTENT_ROUTE' $templateText $runnerText ($packageText + "`nCreate a persistent public-IP 203.0.113.7/32 bypass route.") 'PERSISTENT_BYPASS_ROUTE_FORBIDDEN'
Write-Output 'G3C_C2A_FIXTURE_G_NO_PERSISTENT_ROUTE=PASS'

$missingCleanup = $runnerText -replace '(?is)finally\s*\{.*?\n\}', ''
Assert-C2AExpectedFailure 'H_MISSING_CLEANUP' $templateText $missingCleanup $packageText 'CLEANUP_ROLLBACK_MARKERS_MISSING'
Write-Output 'G3C_C2A_FIXTURE_H_CLEANUP_REQUIRED=PASS'

$missingTiming = $runnerText.Replace('Write-Output (''ROUND_STARTED_AT='' + $script:roundStartedAt.ToString(''o''))', '# timing removed')
Assert-C2AExpectedFailure 'I_MISSING_TIMING' $templateText $missingTiming $packageText 'TIMING_INSTRUMENTATION_MISSING_OR_LATE'
Write-Output 'G3C_C2A_FIXTURE_I_TIMING_REQUIRED=PASS'

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
