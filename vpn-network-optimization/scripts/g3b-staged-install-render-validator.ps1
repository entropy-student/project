[CmdletBinding()]
param([switch]$Validate)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Validate) { throw 'VALIDATE_MODE_REQUIRED' }

$projectRoot = Split-Path -Parent $PSScriptRoot

function Assert-D3 {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Read-D3 {
    param([Parameter(Mandatory = $true)][string]$Relative)
    $path = Join-Path $projectRoot $Relative
    Assert-D3 (Test-Path -LiteralPath $path -PathType Leaf) "REQUIRED_FILE_MISSING_$($Relative.Replace('\','_').Replace('/','_').Replace('.','_'))"
    return Get-Content -LiteralPath $path -Raw
}

function Render-D3 {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][hashtable]$Values
    )
    $rendered = $Text
    foreach ($key in $Values.Keys) {
        $braceToken = '{{' + $key + '}}'
        $underscoreToken = '__' + $key + '__'
        $rendered = $rendered.Replace($braceToken,[string]$Values[$key])
        $rendered = $rendered.Replace($underscoreToken,[string]$Values[$key])
    }
    return $rendered
}

function Test-D3RenderedArtifacts {
    param(
        [Parameter(Mandatory = $true)][string]$WgServer,
        [Parameter(Mandatory = $true)][string]$WgClient,
        [Parameter(Mandatory = $true)][string]$Hy2Server,
        [Parameter(Mandatory = $true)][string]$Hy2Unit,
        [Parameter(Mandatory = $true)][string]$Clash,
        [Parameter(Mandatory = $true)][string]$Manifest,
        [Parameter(Mandatory = $true)][hashtable]$Fixture
    )

    $combined = $WgServer + $WgClient + $Hy2Server + $Clash
    foreach ($secretSentinel in @(
        '__EXTERNAL_WG_SERVER_PRIVATE_KEY_NOT_IN_REPOSITORY__',
        '__EXTERNAL_WG_CLIENT_PRIVATE_KEY_NOT_IN_REPOSITORY__',
        '__EXTERNAL_SECRET_NOT_IN_REPOSITORY__',
        '__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__'
    )) {
        Assert-D3 ($combined.Contains($secretSentinel)) "SECRET_SENTINEL_MISSING_$secretSentinel"
    }

    Assert-D3 ($WgServer -notmatch '(?m)^\s*PrivateKey\s*=') 'WG_SERVER_PRIVATE_KEY_POPULATED'
    Assert-D3 ($WgClient -notmatch '(?m)^\s*PrivateKey\s*=') 'WG_CLIENT_PRIVATE_KEY_POPULATED'
    Assert-D3 ($Hy2Server -match '(?m)^\s*password:\s*__EXTERNAL_SECRET_NOT_IN_REPOSITORY__\s*$') 'HY2_AUTH_SENTINEL_CHANGED'
    Assert-D3 ($Clash -match '(?m)^\s*password:\s*__EXTERNAL_SECRET_NOT_IN_REPOSITORY__\s*$') 'CLASH_AUTH_SENTINEL_CHANGED'
    Assert-D3 ($Clash -match '(?m)^\s*fingerprint:\s*__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__\s*$') 'CLASH_FINGERPRINT_SENTINEL_CHANGED'

    Assert-D3 ($WgClient -match '(?m)^AllowedIPs\s*=\s*0\.0\.0\.0/1,\s*128\.0\.0\.0/1\s*    Assert-D3 ($WgClient.Contains("Endpoint = $($Fixture.VPS_HOST):$($Fixture.WG_PORT)")) 'WG_TARGET_ENDPOINT_NOT_RENDERED'
    Assert-D3 ($WgClient.Contains("PublicKey = $($Fixture.WG_SERVER_PUBLIC_KEY)")) 'WG_SERVER_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($WgServer.Contains("PublicKey = $($Fixture.WG_CLIENT_PUBLIC_KEY)")) 'WG_CLIENT_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains('listen: "' + $Fixture.HY2_LISTEN + '"')) 'HY2_LISTEN_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains($Fixture.HY2_SNI)) 'HY2_SNI_NOT_RENDERED'
    Assert-D3 ($Hy2Unit.Contains("User=$($Fixture.HY2_RUNTIME_USER)")) 'HY2_RUNTIME_USER_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("server: $($Fixture.VPS_HOST)")) 'CLASH_TARGET_HOST_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("sni: $($Fixture.HY2_SNI)")) 'CLASH_TARGET_SNI_NOT_RENDERED'

    foreach ($required in @(
        'D2 target qualification PASS',
        'Secret checkpoint',
        'Perform target health/read-back',
        'Keep source VPS healthy and distinguishable through the rollback window',
        'Decommission source only in a later Closeout Gate'
    )) {
        Assert-D3 ($Manifest.Contains($required)) "STAGED_INSTALL_ORDER_MISSING_$($required.Replace(' ','_'))"
    }

    Assert-D3 ($Manifest.Contains('rollback means restoring the exact Owner client endpoint/profile/route state to the still-valid source VPS')) 'ROLLBACK_TO_SOURCE_BOUNDARY_MISSING'

    return [pscustomobject]@{
        Result = 'PASS'
        TargetHost = $Fixture.VPS_HOST
        TargetHostname = $Fixture.TARGET_EXPECTED_HOSTNAME
        Hy2Sni = $Fixture.HY2_SNI
    }
}

$variables = Read-D3 'config\variables.env.example'
$wgServerTemplate = Read-D3 'templates\wireguard\server.conf.template'
$wgClientTemplate = Read-D3 'templates\wireguard\client.conf.template'
$hy2ServerTemplate = Read-D3 'templates\hysteria2\server.yaml.template'
$hy2UnitTemplate = Read-D3 'templates\systemd\hysteria2.service.template'
$clashTemplate = Read-D3 'templates\clash\mihomo-hy2.yaml.template'
$manifest = Read-D3 'docs\G3B_STAGED_INSTALL_MANIFEST.md'

foreach ($name in @(
    'VPS_HOST','TARGET_EXPECTED_HOSTNAME','WG_SERVER_ADDRESS','WG_CLIENT_ADDRESS',
    'WG_SERVER_PUBLIC_KEY','WG_CLIENT_PUBLIC_KEY','WG_PORT','WG_PERSISTENT_KEEPALIVE',
    'WG_MTU','HY2_PORT','HY2_LISTEN','HY2_CERT_FILE','HY2_KEY_FILE','HY2_SNI','HY2_RUNTIME_USER'
)) {
    Assert-D3 ($variables -match "(?m)^$([regex]::Escape($name))=") "NON_SECRET_INPUT_UNDECLARED_$name"
}

$fixture = @{
    VPS_HOST = '203.0.113.10'
    TARGET_EXPECTED_HOSTNAME = 'target-vpn-01'
    WG_SERVER_ADDRESS = '10.77.31.1/24'
    WG_CLIENT_ADDRESS = '10.77.31.2/32'
    WG_SERVER_PUBLIC_KEY = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
    WG_CLIENT_PUBLIC_KEY = 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB='
    WG_PORT = '51820'
    WG_PERSISTENT_KEEPALIVE = '25'
    WG_MTU = 'auto'
    HY2_PORT = '8443'
    HY2_LISTEN = '0.0.0.0:8443'
    HY2_CERT_FILE = '/srv/data/vpn-network-optimization/secrets/server.crt'
    HY2_KEY_FILE = '/srv/data/vpn-network-optimization/secrets/server.key'
    HY2_SNI = 'hy2.target-vpn-01.invalid'
    HY2_RUNTIME_USER = 'hy2-vpn'
}

$wgServer = Render-D3 -Text $wgServerTemplate -Values $fixture
$wgClient = Render-D3 -Text $wgClientTemplate -Values $fixture
$hy2Server = Render-D3 -Text $hy2ServerTemplate -Values $fixture
$hy2Unit = Render-D3 -Text $hy2UnitTemplate -Values $fixture
$clash = Render-D3 -Text $clashTemplate -Values $fixture

$result = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture

$passed = 0
Assert-D3 ($result.Result -eq 'PASS') 'SELFTEST_GOOD_RENDER_FAILED'
$passed++

$badWg = $wgClient.Replace('AllowedIPs = 0.0.0.0/1, 128.0.0.0/1','AllowedIPs = 0.0.0.0/0')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $badWg -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_WG_STRICT_DEFAULT_PRESENT'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -eq 'WG_SPLIT_DEFAULT_BASELINE_MISSING') 'SELFTEST_WG_STRICT_DEFAULT_FAILURE_CLASS_CHANGED'
}
$passed++

$badHy2 = $hy2Server.Replace('__EXTERNAL_SECRET_NOT_IN_REPOSITORY__','fixture-password')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $badHy2 -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_HY2_AUTH_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'HY2_AUTH_SENTINEL_CHANGED') 'SELFTEST_HY2_SECRET_FAILURE_CLASS_CHANGED'
}
$passed++

$badClash = $clash.Replace('__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__','AA:BB:CC')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badClash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLASH_FINGERPRINT_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'CLASH_FINGERPRINT_SENTINEL_CHANGED') 'SELFTEST_FINGERPRINT_FAILURE_CLASS_CHANGED'
}
$passed++

$badPortable = $clash.Replace('203.0.113.10','24.199.118.137')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badPortable -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_STALE_CURRENT_INSTANCE'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STALE_CURRENT_INSTANCE_CONSTANT_PRESENT_*') 'SELFTEST_STALE_INSTANCE_FAILURE_CLASS_CHANGED'
}
$passed++

$badManifest = $manifest.Replace('Decommission source only in a later Closeout Gate.','Decommission source.')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $badManifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLOSEOUT_BOUNDARY'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STAGED_INSTALL_ORDER_MISSING_*') 'SELFTEST_CLOSEOUT_FAILURE_CLASS_CHANGED'
}
$passed++

Write-Output "G3B_D3_SELFTEST_CASES=$passed"
Write-Output 'G3B_D3_SELFTEST_RESULT=PASS'
Write-Output "G3B_D3_FIXTURE_TARGET_HOST=$($fixture.VPS_HOST)"
Write-Output "G3B_D3_FIXTURE_TARGET_HOSTNAME=$($fixture.TARGET_EXPECTED_HOSTNAME)"
Write-Output "G3B_D3_FIXTURE_HY2_SNI=$($fixture.HY2_SNI)"
Write-Output 'G3B_D3_WG_SPLIT_DEFAULT=PASS'
Write-Output 'G3B_D3_SECRET_SENTINELS=PASS'
Write-Output 'G3B_D3_STAGED_ORDER=PASS'
Write-Output 'G3B_D3_ROLLBACK_TO_SOURCE=PASS'
Write-Output 'FILES_CREATED=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'VPS_ACCESS=NO'
Write-Output 'PROVIDER_ACTION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3B_D3_OFFLINE_VALIDATION=PASS'
) 'WG_SPLIT_DEFAULT_BASELINE_MISSING'
    Assert-D3 ($WgClient -notmatch '(?m)^AllowedIPs\s*=\s*0\.0\.0\.0/0\s*    Assert-D3 ($WgClient.Contains("Endpoint = $($Fixture.VPS_HOST):$($Fixture.WG_PORT)")) 'WG_TARGET_ENDPOINT_NOT_RENDERED'
    Assert-D3 ($WgClient.Contains("PublicKey = $($Fixture.WG_SERVER_PUBLIC_KEY)")) 'WG_SERVER_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($WgServer.Contains("PublicKey = $($Fixture.WG_CLIENT_PUBLIC_KEY)")) 'WG_CLIENT_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains('listen: "' + $Fixture.HY2_LISTEN + '"')) 'HY2_LISTEN_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains($Fixture.HY2_SNI)) 'HY2_SNI_NOT_RENDERED'
    Assert-D3 ($Hy2Unit.Contains("User=$($Fixture.HY2_RUNTIME_USER)")) 'HY2_RUNTIME_USER_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("server: $($Fixture.VPS_HOST)")) 'CLASH_TARGET_HOST_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("sni: $($Fixture.HY2_SNI)")) 'CLASH_TARGET_SNI_NOT_RENDERED'

    foreach ($required in @(
        'D2 target qualification PASS',
        'Secret checkpoint',
        'Perform target health/read-back',
        'Keep source VPS healthy and distinguishable through the rollback window',
        'Decommission source only in a later Closeout Gate'
    )) {
        Assert-D3 ($Manifest.Contains($required)) "STAGED_INSTALL_ORDER_MISSING_$($required.Replace(' ','_'))"
    }

    Assert-D3 ($Manifest.Contains('rollback means restoring the exact Owner client endpoint/profile/route state to the still-valid source VPS')) 'ROLLBACK_TO_SOURCE_BOUNDARY_MISSING'

    return [pscustomobject]@{
        Result = 'PASS'
        TargetHost = $Fixture.VPS_HOST
        TargetHostname = $Fixture.TARGET_EXPECTED_HOSTNAME
        Hy2Sni = $Fixture.HY2_SNI
    }
}

$variables = Read-D3 'config\variables.env.example'
$wgServerTemplate = Read-D3 'templates\wireguard\server.conf.template'
$wgClientTemplate = Read-D3 'templates\wireguard\client.conf.template'
$hy2ServerTemplate = Read-D3 'templates\hysteria2\server.yaml.template'
$hy2UnitTemplate = Read-D3 'templates\systemd\hysteria2.service.template'
$clashTemplate = Read-D3 'templates\clash\mihomo-hy2.yaml.template'
$manifest = Read-D3 'docs\G3B_STAGED_INSTALL_MANIFEST.md'

foreach ($name in @(
    'VPS_HOST','TARGET_EXPECTED_HOSTNAME','WG_SERVER_ADDRESS','WG_CLIENT_ADDRESS',
    'WG_SERVER_PUBLIC_KEY','WG_CLIENT_PUBLIC_KEY','WG_PORT','WG_PERSISTENT_KEEPALIVE',
    'WG_MTU','HY2_PORT','HY2_LISTEN','HY2_CERT_FILE','HY2_KEY_FILE','HY2_SNI','HY2_RUNTIME_USER'
)) {
    Assert-D3 ($variables -match "(?m)^$([regex]::Escape($name))=") "NON_SECRET_INPUT_UNDECLARED_$name"
}

$fixture = @{
    VPS_HOST = '203.0.113.10'
    TARGET_EXPECTED_HOSTNAME = 'target-vpn-01'
    WG_SERVER_ADDRESS = '10.77.31.1/24'
    WG_CLIENT_ADDRESS = '10.77.31.2/32'
    WG_SERVER_PUBLIC_KEY = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
    WG_CLIENT_PUBLIC_KEY = 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB='
    WG_PORT = '51820'
    WG_PERSISTENT_KEEPALIVE = '25'
    WG_MTU = 'auto'
    HY2_PORT = '8443'
    HY2_LISTEN = '0.0.0.0:8443'
    HY2_CERT_FILE = '/srv/data/vpn-network-optimization/secrets/server.crt'
    HY2_KEY_FILE = '/srv/data/vpn-network-optimization/secrets/server.key'
    HY2_SNI = 'hy2.target-vpn-01.invalid'
    HY2_RUNTIME_USER = 'hy2-vpn'
}

$wgServer = Render-D3 -Text $wgServerTemplate -Values $fixture
$wgClient = Render-D3 -Text $wgClientTemplate -Values $fixture
$hy2Server = Render-D3 -Text $hy2ServerTemplate -Values $fixture
$hy2Unit = Render-D3 -Text $hy2UnitTemplate -Values $fixture
$clash = Render-D3 -Text $clashTemplate -Values $fixture

$result = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture

$passed = 0
Assert-D3 ($result.Result -eq 'PASS') 'SELFTEST_GOOD_RENDER_FAILED'
$passed++

$badWg = $wgClient.Replace('AllowedIPs = 0.0.0.0/1, 128.0.0.0/1','AllowedIPs = 0.0.0.0/0')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $badWg -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_WG_STRICT_DEFAULT_PRESENT'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -eq 'WG_SPLIT_DEFAULT_BASELINE_MISSING') 'SELFTEST_WG_STRICT_DEFAULT_FAILURE_CLASS_CHANGED'
}
$passed++

$badHy2 = $hy2Server.Replace('__EXTERNAL_SECRET_NOT_IN_REPOSITORY__','fixture-password')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $badHy2 -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_HY2_AUTH_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'HY2_AUTH_SENTINEL_CHANGED') 'SELFTEST_HY2_SECRET_FAILURE_CLASS_CHANGED'
}
$passed++

$badClash = $clash.Replace('__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__','AA:BB:CC')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badClash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLASH_FINGERPRINT_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'CLASH_FINGERPRINT_SENTINEL_CHANGED') 'SELFTEST_FINGERPRINT_FAILURE_CLASS_CHANGED'
}
$passed++

$badPortable = $clash.Replace('203.0.113.10','24.199.118.137')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badPortable -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_STALE_CURRENT_INSTANCE'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STALE_CURRENT_INSTANCE_CONSTANT_PRESENT_*') 'SELFTEST_STALE_INSTANCE_FAILURE_CLASS_CHANGED'
}
$passed++

$badManifest = $manifest.Replace('Decommission source only in a later Closeout Gate.','Decommission source.')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $badManifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLOSEOUT_BOUNDARY'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STAGED_INSTALL_ORDER_MISSING_*') 'SELFTEST_CLOSEOUT_FAILURE_CLASS_CHANGED'
}
$passed++

Write-Output "G3B_D3_SELFTEST_CASES=$passed"
Write-Output 'G3B_D3_SELFTEST_RESULT=PASS'
Write-Output "G3B_D3_FIXTURE_TARGET_HOST=$($fixture.VPS_HOST)"
Write-Output "G3B_D3_FIXTURE_TARGET_HOSTNAME=$($fixture.TARGET_EXPECTED_HOSTNAME)"
Write-Output "G3B_D3_FIXTURE_HY2_SNI=$($fixture.HY2_SNI)"
Write-Output 'G3B_D3_WG_SPLIT_DEFAULT=PASS'
Write-Output 'G3B_D3_SECRET_SENTINELS=PASS'
Write-Output 'G3B_D3_STAGED_ORDER=PASS'
Write-Output 'G3B_D3_ROLLBACK_TO_SOURCE=PASS'
Write-Output 'FILES_CREATED=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'VPS_ACCESS=NO'
Write-Output 'PROVIDER_ACTION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3B_D3_OFFLINE_VALIDATION=PASS'
) 'WG_STRICT_DEFAULT_PRESENT'

    foreach ($stale in @('24.199.118.137','hy2.sfo3-a.invalid','SFO3-A','192.168.1.1','192.168.1.4')) {
        $portable = $WgServer + $WgClient + $Hy2Server + $Hy2Unit + $Clash
        Assert-D3 (-not $portable.Contains($stale)) "STALE_CURRENT_INSTANCE_CONSTANT_PRESENT_$($stale.Replace('.','_').Replace('-','_'))"
    }

    Assert-D3 ($WgClient.Contains("Endpoint = $($Fixture.VPS_HOST):$($Fixture.WG_PORT)")) 'WG_TARGET_ENDPOINT_NOT_RENDERED'
    Assert-D3 ($WgClient.Contains("PublicKey = $($Fixture.WG_SERVER_PUBLIC_KEY)")) 'WG_SERVER_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($WgServer.Contains("PublicKey = $($Fixture.WG_CLIENT_PUBLIC_KEY)")) 'WG_CLIENT_PUBLIC_KEY_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains('listen: "' + $Fixture.HY2_LISTEN + '"')) 'HY2_LISTEN_NOT_RENDERED'
    Assert-D3 ($Hy2Server.Contains($Fixture.HY2_SNI)) 'HY2_SNI_NOT_RENDERED'
    Assert-D3 ($Hy2Unit.Contains("User=$($Fixture.HY2_RUNTIME_USER)")) 'HY2_RUNTIME_USER_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("server: $($Fixture.VPS_HOST)")) 'CLASH_TARGET_HOST_NOT_RENDERED'
    Assert-D3 ($Clash.Contains("sni: $($Fixture.HY2_SNI)")) 'CLASH_TARGET_SNI_NOT_RENDERED'

    foreach ($required in @(
        'D2 target qualification PASS',
        'Secret checkpoint',
        'Perform target health/read-back',
        'Keep source VPS healthy and distinguishable through the rollback window',
        'Decommission source only in a later Closeout Gate'
    )) {
        Assert-D3 ($Manifest.Contains($required)) "STAGED_INSTALL_ORDER_MISSING_$($required.Replace(' ','_'))"
    }

    Assert-D3 ($Manifest.Contains('rollback means restoring the exact Owner client endpoint/profile/route state to the still-valid source VPS')) 'ROLLBACK_TO_SOURCE_BOUNDARY_MISSING'

    return [pscustomobject]@{
        Result = 'PASS'
        TargetHost = $Fixture.VPS_HOST
        TargetHostname = $Fixture.TARGET_EXPECTED_HOSTNAME
        Hy2Sni = $Fixture.HY2_SNI
    }
}

$variables = Read-D3 'config\variables.env.example'
$wgServerTemplate = Read-D3 'templates\wireguard\server.conf.template'
$wgClientTemplate = Read-D3 'templates\wireguard\client.conf.template'
$hy2ServerTemplate = Read-D3 'templates\hysteria2\server.yaml.template'
$hy2UnitTemplate = Read-D3 'templates\systemd\hysteria2.service.template'
$clashTemplate = Read-D3 'templates\clash\mihomo-hy2.yaml.template'
$manifest = Read-D3 'docs\G3B_STAGED_INSTALL_MANIFEST.md'

foreach ($name in @(
    'VPS_HOST','TARGET_EXPECTED_HOSTNAME','WG_SERVER_ADDRESS','WG_CLIENT_ADDRESS',
    'WG_SERVER_PUBLIC_KEY','WG_CLIENT_PUBLIC_KEY','WG_PORT','WG_PERSISTENT_KEEPALIVE',
    'WG_MTU','HY2_PORT','HY2_LISTEN','HY2_CERT_FILE','HY2_KEY_FILE','HY2_SNI','HY2_RUNTIME_USER'
)) {
    Assert-D3 ($variables -match "(?m)^$([regex]::Escape($name))=") "NON_SECRET_INPUT_UNDECLARED_$name"
}

$fixture = @{
    VPS_HOST = '203.0.113.10'
    TARGET_EXPECTED_HOSTNAME = 'target-vpn-01'
    WG_SERVER_ADDRESS = '10.77.31.1/24'
    WG_CLIENT_ADDRESS = '10.77.31.2/32'
    WG_SERVER_PUBLIC_KEY = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
    WG_CLIENT_PUBLIC_KEY = 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB='
    WG_PORT = '51820'
    WG_PERSISTENT_KEEPALIVE = '25'
    WG_MTU = 'auto'
    HY2_PORT = '8443'
    HY2_LISTEN = '0.0.0.0:8443'
    HY2_CERT_FILE = '/srv/data/vpn-network-optimization/secrets/server.crt'
    HY2_KEY_FILE = '/srv/data/vpn-network-optimization/secrets/server.key'
    HY2_SNI = 'hy2.target-vpn-01.invalid'
    HY2_RUNTIME_USER = 'hy2-vpn'
}

$wgServer = Render-D3 -Text $wgServerTemplate -Values $fixture
$wgClient = Render-D3 -Text $wgClientTemplate -Values $fixture
$hy2Server = Render-D3 -Text $hy2ServerTemplate -Values $fixture
$hy2Unit = Render-D3 -Text $hy2UnitTemplate -Values $fixture
$clash = Render-D3 -Text $clashTemplate -Values $fixture

$result = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture

$passed = 0
Assert-D3 ($result.Result -eq 'PASS') 'SELFTEST_GOOD_RENDER_FAILED'
$passed++

$badWg = $wgClient.Replace('AllowedIPs = 0.0.0.0/1, 128.0.0.0/1','AllowedIPs = 0.0.0.0/0')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $badWg -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_WG_STRICT_DEFAULT_PRESENT'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -eq 'WG_SPLIT_DEFAULT_BASELINE_MISSING') 'SELFTEST_WG_STRICT_DEFAULT_FAILURE_CLASS_CHANGED'
}
$passed++

$badHy2 = $hy2Server.Replace('__EXTERNAL_SECRET_NOT_IN_REPOSITORY__','fixture-password')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $badHy2 -Hy2Unit $hy2Unit -Clash $clash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_HY2_AUTH_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'HY2_AUTH_SENTINEL_CHANGED') 'SELFTEST_HY2_SECRET_FAILURE_CLASS_CHANGED'
}
$passed++

$badClash = $clash.Replace('__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__','AA:BB:CC')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badClash -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLASH_FINGERPRINT_SENTINEL_CHANGED'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'SECRET_SENTINEL_MISSING_*' -or [string]$_.Exception.Message -eq 'CLASH_FINGERPRINT_SENTINEL_CHANGED') 'SELFTEST_FINGERPRINT_FAILURE_CLASS_CHANGED'
}
$passed++

$badPortable = $clash.Replace('203.0.113.10','24.199.118.137')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $badPortable -Manifest $manifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_STALE_CURRENT_INSTANCE'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STALE_CURRENT_INSTANCE_CONSTANT_PRESENT_*') 'SELFTEST_STALE_INSTANCE_FAILURE_CLASS_CHANGED'
}
$passed++

$badManifest = $manifest.Replace('Decommission source only in a later Closeout Gate.','Decommission source.')
try {
    $null = Test-D3RenderedArtifacts -WgServer $wgServer -WgClient $wgClient -Hy2Server $hy2Server -Hy2Unit $hy2Unit -Clash $clash -Manifest $badManifest -Fixture $fixture
    throw 'EXPECTED_FAILURE_NOT_RAISED_CLOSEOUT_BOUNDARY'
}
catch {
    Assert-D3 ([string]$_.Exception.Message -like 'STAGED_INSTALL_ORDER_MISSING_*') 'SELFTEST_CLOSEOUT_FAILURE_CLASS_CHANGED'
}
$passed++

Write-Output "G3B_D3_SELFTEST_CASES=$passed"
Write-Output 'G3B_D3_SELFTEST_RESULT=PASS'
Write-Output "G3B_D3_FIXTURE_TARGET_HOST=$($fixture.VPS_HOST)"
Write-Output "G3B_D3_FIXTURE_TARGET_HOSTNAME=$($fixture.TARGET_EXPECTED_HOSTNAME)"
Write-Output "G3B_D3_FIXTURE_HY2_SNI=$($fixture.HY2_SNI)"
Write-Output 'G3B_D3_WG_SPLIT_DEFAULT=PASS'
Write-Output 'G3B_D3_SECRET_SENTINELS=PASS'
Write-Output 'G3B_D3_STAGED_ORDER=PASS'
Write-Output 'G3B_D3_ROLLBACK_TO_SOURCE=PASS'
Write-Output 'FILES_CREATED=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'VPS_ACCESS=NO'
Write-Output 'PROVIDER_ACTION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3B_D3_OFFLINE_VALIDATION=PASS'
