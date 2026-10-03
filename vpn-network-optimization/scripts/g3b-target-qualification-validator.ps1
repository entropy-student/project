[CmdletBinding()]
param([switch]$Validate)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Validate) { throw 'VALIDATE_MODE_REQUIRED' }

$projectRoot = Split-Path -Parent $PSScriptRoot
$probePath = Join-Path $PSScriptRoot 'g3b-target-qualification-readonly.sh'

$minMemAvailableKiB = 196608
$minRootFreeKiB = 1048576

function Assert-D2 {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Get-D2Int {
    param(
        [Parameter(Mandatory = $true)][hashtable]$Facts,
        [Parameter(Mandatory = $true)][string]$Key
    )
    Assert-D2 ($Facts.ContainsKey($Key)) "TARGET_FACT_MISSING_$Key"
    $value = 0
    Assert-D2 ([int]::TryParse([string]$Facts[$Key],[ref]$value)) "TARGET_FACT_NOT_INTEGER_$Key"
    return $value
}

function Test-D2TargetFacts {
    param([Parameter(Mandatory = $true)][hashtable]$Facts)

    foreach ($key in @(
        'EXPECTED_HOSTNAME','TARGET_HOSTNAME','EXPECTED_PUBLIC_IPV4','PUBLIC_IP_MATCH_COUNT',
        'OS_ID','OS_VERSION_ID','KERNEL','ARCH','DEFAULT_ROUTE_COUNT','WAN_INTERFACE','WAN_GATEWAY',
        'MEM_AVAILABLE_KIB','ROOT_FREE_KIB','IP_FORWARD',
        'UDP_51820','UDP_8443','TCP_443','TCP_14443',
        'WG_RUNTIME_COUNT','HY2_RUNTIME_COUNT','MIHOMO_RUNTIME_COUNT','SING_BOX_RUNTIME_COUNT','XRAY_RUNTIME_COUNT',
        'PROJECT_APP_EXISTS','PROJECT_DATA_EXISTS','PROJECT_BACKUP_EXISTS','PROJECT_LIB_EXISTS','PROJECT_HY2_UNIT_EXISTS',
        'UFW_STATUS','IPTABLES_BACKEND','NFT_INPUT_POLICY',
        'PRIVATE_KEYS_READ','APPLICATION_SECRET_VALUES_READ',
        'NETWORK_MUTATION','SERVICE_MUTATION','PACKAGE_MUTATION','FIREWALL_MUTATION','FILESYSTEM_MUTATION',
        'G3B_TARGET_PROBE_RESULT'
    )) {
        Assert-D2 ($Facts.ContainsKey($key)) "TARGET_FACT_MISSING_$key"
    }

    Assert-D2 ($Facts['G3B_TARGET_PROBE_RESULT'] -eq 'COMPLETE') 'TARGET_PROBE_INCOMPLETE'
    Assert-D2 ($Facts['PRIVATE_KEYS_READ'] -eq 'NO') 'TARGET_PRIVATE_KEY_READ_OCCURRED'
    Assert-D2 ($Facts['APPLICATION_SECRET_VALUES_READ'] -eq '0') 'TARGET_APPLICATION_SECRET_READ_OCCURRED'

    foreach ($key in @('NETWORK_MUTATION','SERVICE_MUTATION','PACKAGE_MUTATION','FIREWALL_MUTATION','FILESYSTEM_MUTATION')) {
        Assert-D2 ($Facts[$key] -eq 'NO') "TARGET_MUTATION_MARKER_INVALID_$key"
    }

    Assert-D2 (
        [string]$Facts['TARGET_HOSTNAME'] -ceq [string]$Facts['EXPECTED_HOSTNAME']
    ) 'TARGET_HOSTNAME_MISMATCH'
    Assert-D2 ((Get-D2Int -Facts $Facts -Key 'PUBLIC_IP_MATCH_COUNT') -eq 1) 'TARGET_PUBLIC_IP_MISMATCH'

    Assert-D2 ([string]$Facts['OS_ID'] -eq 'ubuntu') 'TARGET_OS_UNSUPPORTED'
    Assert-D2 ([string]$Facts['OS_VERSION_ID'] -like '24.04*') 'TARGET_OS_VERSION_UNSUPPORTED'
    Assert-D2 ([string]$Facts['ARCH'] -eq 'x86_64') 'TARGET_ARCH_UNSUPPORTED'

    Assert-D2 ((Get-D2Int -Facts $Facts -Key 'DEFAULT_ROUTE_COUNT') -eq 1) 'TARGET_DEFAULT_ROUTE_AMBIGUOUS'
    Assert-D2 (-not [string]::IsNullOrWhiteSpace([string]$Facts['WAN_INTERFACE']) -and
        [string]$Facts['WAN_INTERFACE'] -ne 'UNKNOWN') 'TARGET_WAN_INTERFACE_UNKNOWN'
    Assert-D2 (-not [string]::IsNullOrWhiteSpace([string]$Facts['WAN_GATEWAY']) -and
        [string]$Facts['WAN_GATEWAY'] -ne 'UNKNOWN') 'TARGET_WAN_GATEWAY_UNKNOWN'

    Assert-D2 ((Get-D2Int -Facts $Facts -Key 'MEM_AVAILABLE_KIB') -ge $minMemAvailableKiB) 'TARGET_MEMORY_INSUFFICIENT'
    Assert-D2 ((Get-D2Int -Facts $Facts -Key 'ROOT_FREE_KIB') -ge $minRootFreeKiB) 'TARGET_ROOT_FREE_INSUFFICIENT'

    $ipForward = [string]$Facts['IP_FORWARD']
    Assert-D2 ($ipForward -in @('0','1')) 'TARGET_IP_FORWARD_UNKNOWN'

    foreach ($key in @('UDP_51820','UDP_8443','TCP_443','TCP_14443')) {
        Assert-D2 ((Get-D2Int -Facts $Facts -Key $key) -eq 0) "TARGET_PORT_COLLISION_$key"
    }

    foreach ($key in @('WG_RUNTIME_COUNT','HY2_RUNTIME_COUNT','MIHOMO_RUNTIME_COUNT','SING_BOX_RUNTIME_COUNT','XRAY_RUNTIME_COUNT')) {
        Assert-D2 ((Get-D2Int -Facts $Facts -Key $key) -eq 0) "TARGET_RUNTIME_COLLISION_$key"
    }

    foreach ($key in @('PROJECT_APP_EXISTS','PROJECT_DATA_EXISTS','PROJECT_BACKUP_EXISTS','PROJECT_LIB_EXISTS','PROJECT_HY2_UNIT_EXISTS')) {
        Assert-D2 ((Get-D2Int -Facts $Facts -Key $key) -eq 0) "TARGET_PROJECT_COLLISION_$key"
    }

    Assert-D2 ([string]$Facts['UFW_STATUS'] -in @('active','inactive','not-installed')) 'TARGET_UFW_STATE_AMBIGUOUS'
    Assert-D2 ([string]$Facts['IPTABLES_BACKEND'] -in @('nf_tables','legacy','not-installed')) 'TARGET_IPTABLES_STATE_AMBIGUOUS'
    Assert-D2 ([string]$Facts['NFT_INPUT_POLICY'] -in @('ACCEPT','DROP','REJECT','NO_INPUT_HOOK','EMPTY','not-installed')) 'TARGET_NFT_STATE_AMBIGUOUS'

    $firewallChangeRequired =
        [string]$Facts['UFW_STATUS'] -eq 'active' -or
        [string]$Facts['NFT_INPUT_POLICY'] -in @('DROP','REJECT')

    return [pscustomobject]@{
        Qualification = 'QUALIFIED_FOR_STAGED_INSTALL'
        IpForwardChangeRequired = ($ipForward -eq '0')
        FirewallChangeRequired = $firewallChangeRequired
        MinMemAvailableKiB = $minMemAvailableKiB
        MinRootFreeKiB = $minRootFreeKiB
    }
}

function Invoke-D2ExpectedFailure {
    param(
        [Parameter(Mandatory = $true)][scriptblock]$Action,
        [Parameter(Mandatory = $true)][string]$ExpectedCode
    )
    try {
        & $Action
        throw "EXPECTED_FAILURE_NOT_RAISED_$ExpectedCode"
    }
    catch {
        if ([string]$_.Exception.Message -ne $ExpectedCode) { throw }
    }
}

function New-D2QualifiedFixture {
    return @{
        EXPECTED_HOSTNAME = 'target-vpn-01'
        TARGET_HOSTNAME = 'target-vpn-01'
        EXPECTED_PUBLIC_IPV4 = '203.0.113.10'
        PUBLIC_IP_MATCH_COUNT = '1'
        OS_ID = 'ubuntu'
        OS_VERSION_ID = '24.04'
        KERNEL = '6.8.0-fixture'
        ARCH = 'x86_64'
        DEFAULT_ROUTE_COUNT = '1'
        WAN_INTERFACE = 'eth0'
        WAN_GATEWAY = '203.0.113.1'
        MEM_AVAILABLE_KIB = '524288'
        ROOT_FREE_KIB = '8388608'
        IP_FORWARD = '0'
        UDP_51820 = '0'
        UDP_8443 = '0'
        TCP_443 = '0'
        TCP_14443 = '0'
        WG_RUNTIME_COUNT = '0'
        HY2_RUNTIME_COUNT = '0'
        MIHOMO_RUNTIME_COUNT = '0'
        SING_BOX_RUNTIME_COUNT = '0'
        XRAY_RUNTIME_COUNT = '0'
        PROJECT_APP_EXISTS = '0'
        PROJECT_DATA_EXISTS = '0'
        PROJECT_BACKUP_EXISTS = '0'
        PROJECT_LIB_EXISTS = '0'
        PROJECT_HY2_UNIT_EXISTS = '0'
        UFW_STATUS = 'inactive'
        IPTABLES_BACKEND = 'nf_tables'
        NFT_INPUT_POLICY = 'NO_INPUT_HOOK'
        PRIVATE_KEYS_READ = 'NO'
        APPLICATION_SECRET_VALUES_READ = '0'
        NETWORK_MUTATION = 'NO'
        SERVICE_MUTATION = 'NO'
        PACKAGE_MUTATION = 'NO'
        FIREWALL_MUTATION = 'NO'
        FILESYSTEM_MUTATION = 'NO'
        G3B_TARGET_PROBE_RESULT = 'COMPLETE'
    }
}

Assert-D2 (Test-Path -LiteralPath $probePath -PathType Leaf) 'TARGET_PROBE_FILE_MISSING'
$probe = Get-Content -LiteralPath $probePath -Raw

foreach ($requiredMarker in @(
    'G3B_TARGET_PROBE_RESULT=COMPLETE',
    'PRIVATE_KEYS_READ=NO',
    'APPLICATION_SECRET_VALUES_READ=0',
    'NETWORK_MUTATION=NO',
    'SERVICE_MUTATION=NO',
    'PACKAGE_MUTATION=NO',
    'FIREWALL_MUTATION=NO',
    'FILESYSTEM_MUTATION=NO'
)) {
    Assert-D2 ($probe.Contains($requiredMarker)) "TARGET_PROBE_MARKER_MISSING_$($requiredMarker.Replace('=','_'))"
}

foreach ($forbidden in @(
    'systemctl start','systemctl stop','systemctl restart','systemctl enable','systemctl disable',
    'apt install','apt-get install','dnf install','yum install','apk add',
    'sysctl -w','ip route add','ip route del','ip route delete',
    'ufw allow','ufw delete','ufw enable','ufw disable',
    'iptables -A','iptables -D','iptables -I',
    'nft add','nft delete','nft insert',
    'mkdir ','rm -','cp ','mv ',
    'curl ','wget ','scp ','ssh '
)) {
    Assert-D2 (-not $probe.ToLowerInvariant().Contains($forbidden.ToLowerInvariant())) "TARGET_PROBE_MUTATION_OR_NETWORK_ACTION_PRESENT_$($forbidden.Replace(' ','_').Replace('-','_'))"
}

foreach ($forbiddenSecretRead in @('wg showconf','wg dump','/secrets/','server.key','privatekey')) {
    Assert-D2 (-not $probe.ToLowerInvariant().Contains($forbiddenSecretRead.ToLowerInvariant())) "TARGET_PROBE_SECRET_READ_PATTERN_PRESENT"
}

$passed = 0

$good = New-D2QualifiedFixture
$result = Test-D2TargetFacts -Facts $good
Assert-D2 ($result.Qualification -eq 'QUALIFIED_FOR_STAGED_INSTALL') 'SELFTEST_QUALIFIED_TARGET_FAILED'
Assert-D2 ($result.IpForwardChangeRequired -eq $true) 'SELFTEST_IP_FORWARD_PLANNED_CHANGE_FAILED'
$passed++

$portCollision = (New-D2QualifiedFixture).Clone()
$portCollision['UDP_8443'] = '1'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_PORT_COLLISION_UDP_8443' -Action {
    $null = Test-D2TargetFacts -Facts $portCollision
}
$passed++

$runtimeCollision = (New-D2QualifiedFixture).Clone()
$runtimeCollision['SING_BOX_RUNTIME_COUNT'] = '1'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_RUNTIME_COLLISION_SING_BOX_RUNTIME_COUNT' -Action {
    $null = Test-D2TargetFacts -Facts $runtimeCollision
}
$passed++

$lowResource = (New-D2QualifiedFixture).Clone()
$lowResource['MEM_AVAILABLE_KIB'] = '131072'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_MEMORY_INSUFFICIENT' -Action {
    $null = Test-D2TargetFacts -Facts $lowResource
}
$passed++

$identityMismatch = (New-D2QualifiedFixture).Clone()
$identityMismatch['TARGET_HOSTNAME'] = 'wrong-target'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_HOSTNAME_MISMATCH' -Action {
    $null = Test-D2TargetFacts -Facts $identityMismatch
}
$passed++

$firewallAmbiguous = (New-D2QualifiedFixture).Clone()
$firewallAmbiguous['NFT_INPUT_POLICY'] = 'UNKNOWN'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_NFT_STATE_AMBIGUOUS' -Action {
    $null = Test-D2TargetFacts -Facts $firewallAmbiguous
}
$passed++

$projectCollision = (New-D2QualifiedFixture).Clone()
$projectCollision['PROJECT_APP_EXISTS'] = '1'
Invoke-D2ExpectedFailure -ExpectedCode 'TARGET_PROJECT_COLLISION_PROJECT_APP_EXISTS' -Action {
    $null = Test-D2TargetFacts -Facts $projectCollision
}
$passed++

Write-Output "G3B_D2_SELFTEST_CASES=$passed"
Write-Output 'G3B_D2_SELFTEST_RESULT=PASS'
Write-Output "G3B_D2_MIN_MEM_AVAILABLE_KIB=$minMemAvailableKiB"
Write-Output "G3B_D2_MIN_ROOT_FREE_KIB=$minRootFreeKiB"
Write-Output 'G3B_D2_QUALIFIED_RESULT=QUALIFIED_FOR_STAGED_INSTALL'
Write-Output 'G3B_D2_IP_FORWARD_ZERO_IS_PLANNED_CHANGE=YES'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'VPS_ACCESS=NO'
Write-Output 'PROVIDER_ACTION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3B_D2_OFFLINE_VALIDATION=PASS'
