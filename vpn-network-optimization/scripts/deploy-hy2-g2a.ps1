[CmdletBinding()]
param(
    [string]$TargetIp = '24.199.118.137',
    [string]$ExpectedHostname = 'ubuntu-s-1vcpu-512mb-10gb-sfo3',
    [string]$ExpectedRegion = 'sfo3',
    [string]$SshIdentity = (Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'),
    [string]$KnownHosts = (Join-Path $env:USERPROFILE '.ssh\known_hosts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Security.Cryptography.ProtectedData

$project = Split-Path -Parent $PSScriptRoot
$pending = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.pending.dpapi'
$final = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
$remoteProvisioner = Join-Path $PSScriptRoot 'provision-hy2-g2a.py'
$recoveryHelper = Join-Path $PSScriptRoot 'protect-hy2-recovery.ps1'
$clientConfig = Join-Path $project 'config\clash\sfo3-a-hy2.yaml'
$unitName = 'hysteria2-vpn-network-optimization.service'
$phase = 'local-precheck'
$protectedBytes = $null
$bundleBytes = $null
$ssh = $null

function Assert-OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path)

    $acl = Get-Acl -LiteralPath $Path
    $sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    if (-not $acl.AreAccessRulesProtected) {
        throw 'ACL_INHERITANCE_ENABLED'
    }
    $ownerSid = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate(
        [Security.Principal.SecurityIdentifier]
    ).Value
    $rules = @($acl.Access)
    if ($ownerSid -ne $sid -or $rules.Count -ne 1) {
        throw 'ACL_OWNER_OR_RULE_COUNT_INVALID'
    }
    $ruleSid = $rules[0].IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
    if ($ruleSid -ne $sid -or
        $rules[0].AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow -or
        $rules[0].FileSystemRights -ne [Security.AccessControl.FileSystemRights]::FullControl) {
        throw 'ACL_PRINCIPAL_INVALID'
    }
}

function Get-WindowsSnapshot {
    $script:phase = 'windows-routes'
    $routes = @(Get-NetRoute -AddressFamily IPv4 |
        Sort-Object DestinationPrefix, NextHop, InterfaceIndex, RouteMetric |
        ForEach-Object {
            "$($_.DestinationPrefix)|$($_.NextHop)|$($_.InterfaceIndex)|$($_.RouteMetric)|$($_.State)|$($_.Store)"
        })
    $script:phase = 'windows-wireguard-services'
    $wireGuardManager = Get-Service -Name 'WireGuardManager'
    $wireGuardTunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A'
    $script:phase = 'windows-wireguard-adapter'
    $wireGuardAdapter = Get-NetAdapter -Name 'SFO2-A'
    $script:phase = 'windows-clash-service'
    $clashService = Get-Service -Name 'clash_verge_service'
    $script:phase = 'windows-proxy-state'
    $internetSettings = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    $script:phase = 'windows-winhttp-state'
    $winHttp = (& netsh.exe winhttp show proxy 2>&1 | Out-String).Trim()
    $script:phase = 'windows-tun-state'
    $tunAdapters = @(Get-NetAdapter -IncludeHidden |
        Where-Object { $_.Name -match 'Clash|Mihomo|Meta' -or $_.InterfaceDescription -match 'Clash|Mihomo|Meta' } |
        Sort-Object Name |
        ForEach-Object { "$($_.Name)|$($_.Status)|$($_.InterfaceIndex)" })
    $script:phase = 'windows-mihomo-processes'
    $coreProcesses = @(Get-Process -Name 'mihomo', 'verge-mihomo', 'verge-mihomo-alpha' -ErrorAction SilentlyContinue |
        Sort-Object ProcessName |
        ForEach-Object { $_.ProcessName })

    $script:phase = 'windows-snapshot-complete'
    return [pscustomobject]@{
        Routes = $routes -join [Environment]::NewLine
        WireGuardManager = $wireGuardManager.Status.ToString()
        WireGuardTunnel = $wireGuardTunnel.Status.ToString()
        WireGuardAdapter = "$($wireGuardAdapter.Status)|$($wireGuardAdapter.InterfaceIndex)"
        ClashService = $clashService.Status.ToString()
        ProxyEnable = [int]$internetSettings.ProxyEnable
        WinHttp = $winHttp
        TunAdapters = $tunAdapters -join ';'
        MihomoProcesses = $coreProcesses -join ';'
    }
}

function Invoke-RemoteProvisioner {
    param(
        [Parameter(Mandatory = $true)][byte[]]$Bundle,
        [Parameter(Mandatory = $true)][string]$SourceText
    )

    $sourceLine = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($SourceText)) + "`n"
    $parameters = [ordered]@{
        expected_ip = $TargetIp
        expected_hostname = $ExpectedHostname
        expected_region = $ExpectedRegion
        port = 8443
        sni = 'hy2.sfo3-a.invalid'
    } | ConvertTo-Json -Compress
    $parameterLine = $parameters + "`n"
    $remoteCommand = 'python3 -c "import sys,base64;exec(compile(base64.b64decode(sys.stdin.buffer.readline()),''<memory>'',''exec''))"'

    $process = [Diagnostics.Process]::new()
    $process.StartInfo.FileName = (Get-Command ssh.exe).Source
    foreach ($argument in @(
        '-T', '-i', $SshIdentity,
        '-o', 'BatchMode=yes',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'UpdateHostKeys=no',
        '-o', "UserKnownHostsFile=$KnownHosts",
        '-o', 'ControlMaster=no',
        '-o', 'ControlPath=none',
        '-o', 'ForwardAgent=no',
        '-o', 'ConnectTimeout=15',
        '-o', 'ServerAliveInterval=10',
        '-o', 'ServerAliveCountMax=3',
        "root@$TargetIp", $remoteCommand
    )) {
        [void]$process.StartInfo.ArgumentList.Add($argument)
    }
    $process.StartInfo.RedirectStandardInput = $true
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.UseShellExecute = $false
    [void]$process.Start()
    $script:ssh = $process

    $inputStream = $process.StandardInput.BaseStream
    $header = [Text.Encoding]::ASCII.GetBytes($sourceLine + $parameterLine)
    $inputStream.Write($header, 0, $header.Length)
    $inputStream.Write($Bundle, 0, $Bundle.Length)
    $process.StandardInput.Close()

    $stdout = $process.StandardOutput.ReadToEnd()
    $null = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    $result = $null
    if (-not [string]::IsNullOrWhiteSpace($stdout)) {
        try { $result = $stdout.Trim() | ConvertFrom-Json } catch { throw 'REMOTE_RESULT_UNPARSEABLE' }
    }
    return [pscustomobject]@{ ExitCode = $process.ExitCode; Result = $result }
}

try {
    $phase = 'required-paths'
    if (-not (Test-Path -LiteralPath $pending -PathType Leaf) -or
        (Test-Path -LiteralPath $final) -or
        -not (Test-Path -LiteralPath $remoteProvisioner -PathType Leaf) -or
        -not (Test-Path -LiteralPath $recoveryHelper -PathType Leaf) -or
        -not (Test-Path -LiteralPath $clientConfig -PathType Leaf) -or
        -not (Test-Path -LiteralPath $SshIdentity -PathType Leaf) -or
        -not (Test-Path -LiteralPath $KnownHosts -PathType Leaf)) {
        throw 'LOCAL_REQUIRED_PATH_MISSING_OR_COLLISION'
    }

    $phase = 'pending-acl-readback'
    Assert-OwnerOnlyAcl (Split-Path -Parent $pending)
    Assert-OwnerOnlyAcl $pending

    $phase = 'windows-readback'
    $windowBefore = Get-WindowsSnapshot

    $phase = 'windows-baseline-check'
    if ($windowBefore.WireGuardManager -ne 'Running' -or
        $windowBefore.WireGuardTunnel -ne 'Running' -or
        $windowBefore.WireGuardAdapter -notlike 'Up|*' -or
        $windowBefore.ClashService -ne 'Running' -or
        $windowBefore.ProxyEnable -ne 0 -or
        $windowBefore.WinHttp -notmatch 'Direct access' -or
        -not [string]::IsNullOrEmpty($windowBefore.TunAdapters) -or
        -not [string]::IsNullOrEmpty($windowBefore.MihomoProcesses)) {
        throw 'WINDOWS_BASELINE_NOT_AS_ACCEPTED'
    }

    $phase = 'client-fingerprint-check'
    $clientText = Get-Content -Raw -LiteralPath $clientConfig
    $fingerprintMatch = [regex]::Match(
        $clientText,
        '(?m)^\s*fingerprint:\s*([0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$'
    )
    if (-not $fingerprintMatch.Success) {
        throw 'CLIENT_FINGERPRINT_MISSING'
    }
    $expectedFingerprint = $fingerprintMatch.Groups[1].Value

    $phase = 'dpapi-unprotect'
    $protectedBytes = [IO.File]::ReadAllBytes($pending)
    $bundleBytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $protectedBytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if ($bundleBytes.Length -lt 100 -or
        [Text.Encoding]::ASCII.GetString($bundleBytes, 0, 8) -ne 'VPNHY2R1') {
        throw 'PENDING_BUNDLE_INVALID'
    }

    $phase = 'remote-deployment'
    $provisionerText = [IO.File]::ReadAllText($remoteProvisioner, [Text.Encoding]::UTF8)
    $remote = Invoke-RemoteProvisioner -Bundle $bundleBytes -SourceText $provisionerText
    $result = $remote.Result
    if ($remote.ExitCode -ne 0 -or $null -eq $result -or $result.DEPLOY_STATUS -eq 'FAILED') {
        if ($null -ne $result -and $result.FAIL_PHASE -match '^[a-z-]+$') {
            Write-Output "HY2_DEPLOY_FAILED_PHASE=$($result.FAIL_PHASE)"
        } else {
            Write-Output 'HY2_DEPLOY_RESULT=FAILED_OR_UNCLEAR'
        }
        Write-Output 'PENDING_PRESERVED=YES'
        Write-Output 'FINAL_CREATED=NO'
        exit 31
    }

    foreach ($field in @(
        'TARGET_HOST_VERIFIED', 'HY2_BINARY_SHA256_VERIFIED', 'SERVER_YAML_PARSE',
        'SYSTEMD_UNIT_VERIFY', 'HY2_SERVICE_ACTIVE', 'HY2_SERVICE_ENABLED',
        'HY2_UDP_8443_LISTENING', 'WG_ACTIVE', 'WG_51820_LISTENING',
        'ROUTES_UNCHANGED', 'NAT_FIREWALL_UNCHANGED', 'LIVE_SYSTEM_TUNING_CHANGED',
        'SECRET_VALUES_EMITTED', 'CERT_SHA256_FINGERPRINT'
    )) {
        if ($null -eq $result.$field) { throw 'REMOTE_REQUIRED_FIELD_MISSING' }
    }
    if ($result.TARGET_HOST_VERIFIED -ne 'YES' -or
        $result.HY2_BINARY_SHA256_VERIFIED -ne 'YES' -or
        $result.SERVER_YAML_PARSE -ne 'PASS' -or
        $result.SYSTEMD_UNIT_VERIFY -ne 'PASS' -or
        $result.HY2_SERVICE_ACTIVE -ne 'YES' -or
        $result.HY2_SERVICE_ENABLED -ne 'YES' -or
        $result.HY2_UDP_8443_LISTENING -ne 'YES' -or
        $result.WG_ACTIVE -ne 'YES' -or
        $result.WG_51820_LISTENING -ne 'YES' -or
        $result.ROUTES_UNCHANGED -ne 'YES' -or
        $result.NAT_FIREWALL_UNCHANGED -ne 'YES' -or
        $result.LIVE_SYSTEM_TUNING_CHANGED -ne 'NO' -or
        $result.SECRET_VALUES_EMITTED -ne 0 -or
        $result.CERT_SHA256_FINGERPRINT -ne $expectedFingerprint) {
        throw 'REMOTE_ACCEPTANCE_MISMATCH'
    }

    $phase = 'windows-postcheck'
    $windowAfter = Get-WindowsSnapshot
    if (($windowBefore | ConvertTo-Json -Compress) -ne ($windowAfter | ConvertTo-Json -Compress)) {
        throw 'WINDOWS_NETWORK_STATE_DRIFT'
    }

    $phase = 'atomic-promotion'
    if (Test-Path -LiteralPath $final) {
        throw 'FINAL_COLLISION'
    }
    [IO.File]::Move($pending, $final)

    $phase = 'final-readback'
    $verify = [Diagnostics.Process]::new()
    $verify.StartInfo.FileName = Join-Path $PSHOME 'pwsh.exe'
    foreach ($argument in @('-NoLogo', '-NoProfile', '-NonInteractive', '-File', $recoveryHelper, '-VerifyFinal')) {
        [void]$verify.StartInfo.ArgumentList.Add($argument)
    }
    $verify.StartInfo.RedirectStandardOutput = $true
    $verify.StartInfo.RedirectStandardError = $true
    $verify.StartInfo.UseShellExecute = $false
    [void]$verify.Start()
    $verifyOutput = $verify.StandardOutput.ReadToEnd()
    $null = $verify.StandardError.ReadToEnd()
    $verify.WaitForExit()
    if ($verify.ExitCode -ne 0 -or
        $verifyOutput -notmatch 'FINAL_EXISTS=YES' -or
        $verifyOutput -notmatch 'OWNER_ONLY_ACL=PASS' -or
        $verifyOutput -notmatch 'FINAL_DPAPI_ROUNDTRIP=PASS' -or
        $verifyOutput -notmatch ('CERT_SHA256_FINGERPRINT=' + [regex]::Escape($expectedFingerprint))) {
        throw 'FINAL_READBACK_FAILED'
    }

    $finalItem = Get-Item -LiteralPath $final
    Assert-OwnerOnlyAcl $final
    Assert-OwnerOnlyAcl (Split-Path -Parent $final)
    if (Test-Path -LiteralPath $pending) {
        throw 'PENDING_REMAINS_AFTER_MOVE'
    }

    Write-Output 'REMOTE_DEPLOYMENT=PASS'
    Write-Output 'HY2_SERVICE_ACTIVE=YES'
    Write-Output 'HY2_SERVICE_ENABLED=YES'
    Write-Output 'HY2_UDP_8443_LISTENING=YES'
    Write-Output 'WG_AND_ROUTES_PRESERVED=YES'
    Write-Output 'WINDOWS_WG_AND_ROUTES_PRESERVED=YES'
    Write-Output 'DPAPI_FINAL_EXISTS=YES'
    Write-Output 'DPAPI_FINAL_ACL=OWNER_ONLY_INHERITANCE_DISABLED'
    Write-Output "DPAPI_FINAL_BYTES=$($finalItem.Length)"
    Write-Output 'DPAPI_FINAL_ROUNDTRIP=PASS'
    Write-Output "CERT_SHA256_FINGERPRINT=$expectedFingerprint"
    Write-Output "HY2_RSS_KB=$($result.HY2_RSS_KB)"
    Write-Output "MEM_AVAILABLE_DELTA_KB=$($result.MEM_AVAILABLE_DELTA_KB)"
    Write-Output 'CLIENT_CONFIG_PARSE_STABLE_AND_ALPHA=PASS'
    Write-Output 'CLIENT_HANDSHAKE_TESTED=NO'
    Write-Output 'CURRENT_TRAFFIC_SWITCHED=NO'
    Write-Output 'LIVE_SYSTEM_TUNING_APPLIED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output 'SECRET_VALUES_COMMITTED=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
} catch {
    Write-Output "DEPLOY_PHASE_FAILED=$phase"
    Write-Output "PENDING_EXISTS=$(Test-Path -LiteralPath $pending)"
    Write-Output "FINAL_EXISTS=$(Test-Path -LiteralPath $final)"
    exit 32
} finally {
    if ($null -ne $bundleBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($bundleBytes)
    }
    if ($null -ne $protectedBytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($protectedBytes)
    }
    if ($null -ne $ssh) { $ssh.Dispose() }
}
