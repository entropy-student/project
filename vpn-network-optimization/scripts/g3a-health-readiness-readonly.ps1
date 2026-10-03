[CmdletBinding()]
param(
    [switch]$ValidateAndCollect
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$publicVpsIp = '24.199.118.137'
$controlIp = '10.66.21.1'
$expectedHostname = 'ubuntu-s-1vcpu-512mb-10gb-sfo3'
$wireGuardAlias = 'SFO2-A'
$identityPath = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
$knownHostsPath = Join-Path $env:USERPROFILE '.ssh\known_hosts'
$hy2RecoveryPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
$realityClientPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\p1-client-v1.19.31\extracted\mihomo-windows-amd64-compatible.exe'
$realityArchivePath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\p1-client-v1.19.31\mihomo-windows-amd64-compatible-v1.19.31.zip'
$realityArchiveSha256 = '93d14e9a13b49b2f2d256202d02cc8d14a7c4695edf084cae0f941986bc9c218'

function Assert-H2 {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Test-H2IPv4 {
    param([Parameter(Mandatory = $true)][string]$Value)
    $parsed = [Net.IPAddress]::None
    if (-not [Net.IPAddress]::TryParse($Value, [ref]$parsed)) { return $false }
    return $parsed.AddressFamily -eq [Net.Sockets.AddressFamily]::InterNetwork
}

function Resolve-H2PhysicalEgress {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Candidates)

    $valid = @(
        $Candidates | Where-Object {
            $null -ne $_ -and
            $_.PSObject.Properties.Name -contains 'Physical' -and
            $_.PSObject.Properties.Name -contains 'Status' -and
            $_.PSObject.Properties.Name -contains 'Alias' -and
            $_.PSObject.Properties.Name -contains 'InterfaceIndex' -and
            $_.PSObject.Properties.Name -contains 'Gateway' -and
            $_.PSObject.Properties.Name -contains 'SourceIPv4' -and
            $_.PSObject.Properties.Name -contains 'DefaultRouteMatch' -and
            [bool]$_.Physical -and
            [string]$_.Status -eq 'Up' -and
            [int]$_.InterfaceIndex -gt 0 -and
            -not [string]::IsNullOrWhiteSpace([string]$_.Alias) -and
            [string]$_.Alias -ne $wireGuardAlias -and
            [bool]$_.DefaultRouteMatch -and
            (Test-H2IPv4 -Value ([string]$_.Gateway)) -and
            (Test-H2IPv4 -Value ([string]$_.SourceIPv4)) -and
            [string]$_.Gateway -ne '0.0.0.0' -and
            [string]$_.SourceIPv4 -ne '0.0.0.0'
        }
    )

    if ($valid.Count -eq 0) { throw 'PHYSICAL_EGRESS_MISSING' }
    if ($valid.Count -ne 1) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }

    return [pscustomobject]@{
        Alias = [string]$valid[0].Alias
        InterfaceIndex = [int]$valid[0].InterfaceIndex
        Gateway = [string]$valid[0].Gateway
        SourceIPv4 = [string]$valid[0].SourceIPv4
    }
}

function Get-H2Classification {
    param(
        [Parameter(Mandatory = $true)][hashtable]$Local,
        [Parameter(Mandatory = $true)][hashtable]$Remote
    )

    $wgKnown = @('WgAdapterUp','WgManagerRunning','WgTunnelRunning','ControlRouteViaWg','SplitDefaultsValid') |
        ForEach-Object { $Local.ContainsKey($_) }
    if ($wgKnown -contains $false) {
        $wgHealth = 'UNKNOWN'
    }
    elseif ($Local.WgAdapterUp -and $Local.WgManagerRunning -and $Local.WgTunnelRunning -and
            $Local.ControlRouteViaWg -and $Local.SplitDefaultsValid) {
        $wgHealth = 'HEALTHY'
    }
    else {
        $wgHealth = 'UNHEALTHY'
    }

    $remoteKnown = $Remote.ContainsKey('SshOk') -and $Remote.SshOk -and
        $Remote.ContainsKey('TargetIdentityOk') -and $Remote.TargetIdentityOk

    if (-not $remoteKnown) {
        $hy2Readiness = 'UNKNOWN'
        $realityReadiness = 'UNKNOWN'
    }
    else {
        $hy2Keys = @('Hy2ServiceActive','Udp8443Present')
        if (($hy2Keys | ForEach-Object { $Remote.ContainsKey($_) }) -contains $false -or
            -not $Local.ContainsKey('PhysicalEgressValid') -or
            -not $Local.ContainsKey('ClashServiceRunning') -or
            -not $Local.ContainsKey('Hy2RecoveryPresent') -or
            -not $Local.ContainsKey('P1RouteResidueAbsent')) {
            $hy2Readiness = 'UNKNOWN'
        }
        elseif ($Remote.Hy2ServiceActive -and $Remote.Udp8443Present -and
                $Local.PhysicalEgressValid -and $Local.ClashServiceRunning -and
                $Local.Hy2RecoveryPresent -and $Local.P1RouteResidueAbsent) {
            $hy2Readiness = 'READY_FOR_SEPARATE_ACTIVATION'
        }
        else {
            $hy2Readiness = 'NOT_READY'
        }

        $realityKeys = @('Tcp443Free','Tcp14443Free','G2cResidueAbsent')
        if (($realityKeys | ForEach-Object { $Remote.ContainsKey($_) }) -contains $false -or
            -not $Local.ContainsKey('PhysicalEgressValid') -or
            -not $Local.ContainsKey('ClashServiceRunning') -or
            -not $Local.ContainsKey('RealityClientPinned') -or
            -not $Local.ContainsKey('P1RouteResidueAbsent')) {
            $realityReadiness = 'UNKNOWN'
        }
        elseif ($Remote.Tcp443Free -and $Remote.Tcp14443Free -and $Remote.G2cResidueAbsent -and
                $Local.PhysicalEgressValid -and $Local.ClashServiceRunning -and
                $Local.RealityClientPinned -and $Local.P1RouteResidueAbsent) {
            $realityReadiness = 'READY_FOR_SEPARATE_ACTIVATION'
        }
        else {
            $realityReadiness = 'NOT_READY'
        }
    }

    return [pscustomobject]@{
        WireGuardCurrentHealth = $wgHealth
        Hy2Readiness = $hy2Readiness
        RealityReadiness = $realityReadiness
    }
}

function Invoke-H2ExpectedFailure {
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

function Invoke-H2SelfTest {
    $passed = 0

    $a = [pscustomobject]@{
        Physical = $true
        Status = 'Up'
        Alias = 'FixtureEthernet'
        InterfaceIndex = 41
        Gateway = '198.51.100.1'
        SourceIPv4 = '198.51.100.20'
        DefaultRouteMatch = $true
    }
    $egress = Resolve-H2PhysicalEgress -Candidates @($a)
    Assert-H2 ($egress.InterfaceIndex -eq 41) 'SELFTEST_EGRESS_VALID_FAILED'
    $passed++

    Invoke-H2ExpectedFailure -ExpectedCode 'PHYSICAL_EGRESS_MISSING' -Action {
        $null = Resolve-H2PhysicalEgress -Candidates @()
    }
    $passed++

    $b = [pscustomobject]@{
        Physical = $true
        Status = 'Up'
        Alias = 'FixtureWifi'
        InterfaceIndex = 42
        Gateway = '203.0.113.1'
        SourceIPv4 = '203.0.113.20'
        DefaultRouteMatch = $true
    }
    Invoke-H2ExpectedFailure -ExpectedCode 'PHYSICAL_EGRESS_AMBIGUOUS' -Action {
        $null = Resolve-H2PhysicalEgress -Candidates @($a,$b)
    }
    $passed++

    $healthyLocal = @{
        WgAdapterUp = $true
        WgManagerRunning = $true
        WgTunnelRunning = $true
        ControlRouteViaWg = $true
        SplitDefaultsValid = $true
        PhysicalEgressValid = $true
        ClashServiceRunning = $true
        Hy2RecoveryPresent = $true
        RealityClientPinned = $true
        P1RouteResidueAbsent = $true
    }
    $healthyRemote = @{
        SshOk = $true
        TargetIdentityOk = $true
        Hy2ServiceActive = $true
        Udp8443Present = $true
        Tcp443Free = $true
        Tcp14443Free = $true
        G2cResidueAbsent = $true
    }
    $healthy = Get-H2Classification -Local $healthyLocal -Remote $healthyRemote
    Assert-H2 ($healthy.WireGuardCurrentHealth -eq 'HEALTHY') 'SELFTEST_WG_HEALTHY_FAILED'
    Assert-H2 ($healthy.Hy2Readiness -eq 'READY_FOR_SEPARATE_ACTIVATION') 'SELFTEST_HY2_READY_FAILED'
    Assert-H2 ($healthy.RealityReadiness -eq 'READY_FOR_SEPARATE_ACTIVATION') 'SELFTEST_REALITY_COLD_READY_FAILED'
    $passed++

    $wgBadLocal = $healthyLocal.Clone()
    $wgBadLocal.WgAdapterUp = $false
    $wgBad = Get-H2Classification -Local $wgBadLocal -Remote $healthyRemote
    Assert-H2 ($wgBad.WireGuardCurrentHealth -eq 'UNHEALTHY') 'SELFTEST_WG_UNHEALTHY_FAILED'
    $passed++

    $hy2BadRemote = $healthyRemote.Clone()
    $hy2BadRemote.Hy2ServiceActive = $false
    $hy2Bad = Get-H2Classification -Local $healthyLocal -Remote $hy2BadRemote
    Assert-H2 ($hy2Bad.Hy2Readiness -eq 'NOT_READY') 'SELFTEST_HY2_NOT_READY_FAILED'
    $passed++

    $realityBusyRemote = $healthyRemote.Clone()
    $realityBusyRemote.Tcp443Free = $false
    $realityBusy = Get-H2Classification -Local $healthyLocal -Remote $realityBusyRemote
    Assert-H2 ($realityBusy.RealityReadiness -eq 'NOT_READY') 'SELFTEST_REALITY_BUSY_FAILED'
    $passed++

    $sshFail = @{ SshOk = $false }
    $unknown = Get-H2Classification -Local $healthyLocal -Remote $sshFail
    Assert-H2 ($unknown.Hy2Readiness -eq 'UNKNOWN' -and $unknown.RealityReadiness -eq 'UNKNOWN') 'SELFTEST_SSH_UNKNOWN_FAILED'
    $passed++

    $wgUnknownLocal = $healthyLocal.Clone()
    $null = $wgUnknownLocal.Remove('ControlRouteViaWg')
    $wgUnknown = Get-H2Classification -Local $wgUnknownLocal -Remote $healthyRemote
    Assert-H2 ($wgUnknown.WireGuardCurrentHealth -eq 'UNKNOWN') 'SELFTEST_WG_UNKNOWN_FAILED'
    $passed++

    Write-Output "H2_SELFTEST_CASES=$passed"
    Write-Output 'H2_SELFTEST_RESULT=PASS'
}

function Get-H2PhysicalCandidates {
    $items = [Collections.Generic.List[object]]::new()
    foreach ($adapter in @(Get-NetAdapter -Physical -ErrorAction Stop)) {
        if ([string]$adapter.Status -ne 'Up') { continue }

        $ifIndex = [int]$adapter.ifIndex
        $cfg = Get-NetIPConfiguration -InterfaceIndex $ifIndex -ErrorAction Stop
        $gateways = @($cfg.IPv4DefaultGateway | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.NextHop) })
        $addresses = @($cfg.IPv4Address | Where-Object {
            $null -ne $_ -and
            -not [string]::IsNullOrWhiteSpace([string]$_.IPAddress) -and
            [string]$_.IPAddress -notlike '169.254.*'
        })
        if ($gateways.Count -ne 1 -or $addresses.Count -ne 1) { continue }

        $gateway = [string]$gateways[0].NextHop
        $source = [string]$addresses[0].IPAddress
        $defaults = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop |
            Where-Object { [int]$_.InterfaceIndex -eq $ifIndex -and [string]$_.NextHop -eq $gateway })

        $items.Add([pscustomobject]@{
            Physical = $true
            Status = [string]$adapter.Status
            Alias = [string]$adapter.Name
            InterfaceIndex = $ifIndex
            Gateway = $gateway
            SourceIPv4 = $source
            DefaultRouteMatch = ($defaults.Count -eq 1)
        })
    }
    return @($items)
}

function Get-H2WinHttpAccessType {
    $typeSource = @'
using System;
using System.Runtime.InteropServices;
public static class G3aH2WinHttp {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct WINHTTP_PROXY_INFO {
        public int dwAccessType;
        public IntPtr lpszProxy;
        public IntPtr lpszProxyBypass;
    }
    [DllImport("winhttp.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern bool WinHttpGetDefaultProxyConfiguration(out WINHTTP_PROXY_INFO pProxyInfo);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GlobalFree(IntPtr hMem);
}
'@
    if (-not ('G3aH2WinHttp' -as [type])) {
        Add-Type -TypeDefinition $typeSource -ErrorAction Stop
    }

    $info = New-Object G3aH2WinHttp+WINHTTP_PROXY_INFO
    try {
        $ok = [G3aH2WinHttp]::WinHttpGetDefaultProxyConfiguration([ref]$info)
        if (-not $ok) { throw 'WINHTTP_READ_FAILED' }
        return [int]$info.dwAccessType
    }
    finally {
        if ($info.lpszProxy -ne [IntPtr]::Zero) { $null = [G3aH2WinHttp]::GlobalFree($info.lpszProxy) }
        if ($info.lpszProxyBypass -ne [IntPtr]::Zero) { $null = [G3aH2WinHttp]::GlobalFree($info.lpszProxyBypass) }
    }
}

function New-H2SshStartInfo {
    param([Parameter(Mandatory = $true)][string]$SshPath)

    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $SshPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    foreach ($arg in @(
        '-T',
        '-i', $identityPath,
        '-o', 'BatchMode=yes',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'UpdateHostKeys=no',
        '-o', "UserKnownHostsFile=$knownHostsPath",
        '-o', "HostKeyAlias=$publicVpsIp",
        '-o', "HostName=$controlIp",
        '-o', 'CheckHostIP=no',
        '-o', 'ControlMaster=no',
        '-o', 'ControlPath=none',
        '-o', 'ForwardAgent=no',
        '-o', 'ConnectTimeout=15',
        "root@$controlIp",
        'bash -s'
    )) {
        [void]$psi.ArgumentList.Add([string]$arg)
    }
    return $psi
}

function Invoke-H2RemoteReadOnly {
    param([Parameter(Mandatory = $true)][string]$SshPath)

    $remote = @'
set -eu
printf 'HOSTNAME=%s\n' "$(hostname)"
printf 'PUBLIC_IP_MATCH_COUNT=%s\n' "$(ip -o -4 addr show | awk '$4 ~ /^24\.199\.118\.137\// {n++} END {print n+0}')"
printf 'WG_SERVICE=%s\n' "$(systemctl is-active wg-quick@wg0 || true)"
printf 'HY2_SERVICE=%s\n' "$(systemctl is-active hysteria2-vpn-network-optimization.service || true)"
ss -H -lun | awk '$4 ~ /:51820$/ {a++} $4 ~ /:8443$/ {b++} END {printf "UDP_51820=%d\nUDP_8443=%d\n",a+0,b+0}'
ss -H -ltn | awk '$4 ~ /:14443$/ {a++} $4 ~ /:443$/ {b++} END {printf "TCP_14443=%d\nTCP_443=%d\n",a+0,b+0}'
printf 'G2C_RUNTIME_RESIDUE=%s\n' "$(find /run /tmp -maxdepth 1 \( -name 'vpn-network-optimization-g2c-r3-*' -o -name 'vpn-network-optimization-g2c-p1-*' \) -print -quit 2>/dev/null | wc -l | tr -d ' ')"
if command -v ufw >/dev/null 2>&1; then
  UFW_STATUS="$(ufw status 2>/dev/null | sed -n 's/^Status: //p' | head -n 1)"
else
  UFW_STATUS=not-installed
fi
printf 'UFW_STATUS=%s\n' "$UFW_STATUS"
if command -v iptables >/dev/null 2>&1; then
  IPTABLES_VERSION="$(iptables --version 2>/dev/null)" || exit 32
  case "$IPTABLES_VERSION" in
    *nf_tables*) IPTABLES_BACKEND=nf_tables ;;
    *legacy*) IPTABLES_BACKEND=legacy ;;
    *) IPTABLES_BACKEND=unknown ;;
  esac
else
  IPTABLES_BACKEND=not-installed
fi
printf 'IPTABLES_BACKEND=%s\n' "$IPTABLES_BACKEND"
if command -v nft >/dev/null 2>&1; then
  NFT_TEXT="$(nft -a list ruleset 2>/dev/null)" || exit 31
  if [ -z "$NFT_TEXT" ]; then
    NFT_INPUT_POLICY=EMPTY
  else
    NFT_INPUT_POLICY="$(printf '%s\n' "$NFT_TEXT" | awk '/hook input/ {seen=1; if ($0 ~ /policy drop/) drop=1; else if ($0 ~ /policy reject/) reject=1; else if ($0 ~ /policy accept/) accept=1; else unknown=1} END {if (drop) print "DROP"; else if (reject) print "REJECT"; else if (unknown) print "UNKNOWN"; else if (accept) print "ACCEPT"; else if (seen) print "UNKNOWN"; else print "NO_INPUT_HOOK"}')"
  fi
else
  NFT_INPUT_POLICY=not-installed
fi
printf 'NFT_INPUT_POLICY=%s\n' "$NFT_INPUT_POLICY"
'@

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = New-H2SshStartInfo -SshPath $SshPath
    [void]$process.Start()

    $crlf = [string][char]13 + [char]10
    $lf = [string][char]10
    $normalized = $remote.Replace($crlf,$lf).Replace([string][char]13,$lf)
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($normalized + $lf)

    try {
        $process.StandardInput.BaseStream.Write($bytes,0,$bytes.Length)
        $process.StandardInput.BaseStream.Flush()
    }
    finally {
        [Array]::Clear($bytes,0,$bytes.Length)
        $process.StandardInput.Close()
    }

    $outTask = $process.StandardOutput.ReadToEndAsync()
    $errTask = $process.StandardError.ReadToEndAsync()

    if (-not $process.WaitForExit(30000)) {
        $process.Kill()
        [void]$process.WaitForExit(5000)
        throw 'STRICT_SSH_READONLY_TIMEOUT'
    }

    $stdout = $outTask.GetAwaiter().GetResult()
    $stderr = $errTask.GetAwaiter().GetResult()

    if ($process.ExitCode -ne 0) {
        $safeClass = if ($stderr -match 'Permission denied') { 'AUTH' }
            elseif ($stderr -match 'Host key verification failed') { 'HOST_KEY' }
            elseif ($stderr -match 'timed out|Connection timed out') { 'TIMEOUT' }
            elseif ($stderr -match 'Connection refused') { 'REFUSED' }
            else { 'REMOTE_OR_TRANSPORT' }
        throw "STRICT_SSH_READONLY_FAILED_$safeClass"
    }

    $values = @{}
    foreach ($line in ($stdout -split "\r?\n")) {
        if ($line -match '^([A-Z0-9_]+)=(.*)$') {
            $values[$Matches[1]] = $Matches[2]
        }
    }
    return $values
}

if (-not $ValidateAndCollect) { throw 'VALIDATE_AND_COLLECT_REQUIRED' }

Write-Output 'PHASE=SELFTEST'
Invoke-H2SelfTest

Write-Output 'PHASE=LOCAL_READONLY'
Assert-H2 ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -eq 6 -and $PSVersionTable.PSVersion.Patch -eq 6) 'POWERSHELL_RUNTIME_MISMATCH'
Assert-H2 (Test-Path -LiteralPath $identityPath -PathType Leaf) 'SSH_IDENTITY_MISSING'
Assert-H2 (Test-Path -LiteralPath $knownHostsPath -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'

$physical = Resolve-H2PhysicalEgress -Candidates (Get-H2PhysicalCandidates)

$wgAdapter = @(Get-NetAdapter -Name $wireGuardAlias -ErrorAction Stop)
Assert-H2 ($wgAdapter.Count -eq 1) 'WG_ADAPTER_CARDINALITY_INVALID'
$wgIfIndex = [int]$wgAdapter[0].ifIndex
$wgAdapterUp = [string]$wgAdapter[0].Status -eq 'Up'

$wgManager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
$wgTunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
$wgManagerRunning = [string]$wgManager.Status -eq 'Running'
$wgTunnelRunning = [string]$wgTunnel.Status -eq 'Running'

$controlRoutes = @(Find-NetRoute -RemoteIPAddress $controlIp -ErrorAction Stop)
$controlRouteViaWg = $controlRoutes.Count -eq 1 -and
    [int]$controlRoutes[0].InterfaceIndex -eq $wgIfIndex -and
    [string]$controlRoutes[0].InterfaceAlias -eq $wireGuardAlias

$splitRoutes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop |
    Where-Object { $_.DestinationPrefix -in @('0.0.0.0/1','128.0.0.0/1') -and [int]$_.InterfaceIndex -eq $wgIfIndex })
$splitPrefixes = @($splitRoutes.DestinationPrefix | Sort-Object -Unique)
$splitDefaultsValid = $splitPrefixes.Count -eq 2 -and
    $splitPrefixes[0] -eq '0.0.0.0/1' -and
    $splitPrefixes[1] -eq '128.0.0.0/1'

$clashService = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
$clashServiceRunning = [string]$clashService.Status -eq 'Running'

$proxyState = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -ErrorAction Stop
$systemProxyEnabled = [int]$proxyState.ProxyEnable -ne 0
$winHttpAccessType = Get-H2WinHttpAccessType

$tunMatches = @(Get-NetAdapter -ErrorAction Stop | Where-Object {
    $_.Name -ne $wireGuardAlias -and
    ($_.Name -match 'Clash|Mihomo|TUN|TAP|Wintun' -or $_.InterfaceDescription -match 'Clash|Mihomo|TUN|TAP|Wintun')
})
$tunCount = $tunMatches.Count

$p1Prefix = "$publicVpsIp/32"
$p1Routes = @(Get-NetRoute -AddressFamily IPv4 -DestinationPrefix $p1Prefix -ErrorAction SilentlyContinue)
$p1RouteResidueAbsent = $p1Routes.Count -eq 0

$hy2RecoveryPresent = Test-Path -LiteralPath $hy2RecoveryPath -PathType Leaf
$realityClientPresent = Test-Path -LiteralPath $realityClientPath -PathType Leaf
$realityArchivePresent = Test-Path -LiteralPath $realityArchivePath -PathType Leaf
$realityHashPass = $false
if ($realityArchivePresent) {
    $actualHash = (Get-FileHash -LiteralPath $realityArchivePath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
    $realityHashPass = $actualHash -ceq $realityArchiveSha256
}
$realityClientPinned = $realityClientPresent -and $realityArchivePresent -and $realityHashPass

Write-Output 'PHASE=REMOTE_READONLY'
$sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
$remote = Invoke-H2RemoteReadOnly -SshPath $sshPath

$targetIdentityOk = $remote.ContainsKey('HOSTNAME') -and
    $remote.ContainsKey('PUBLIC_IP_MATCH_COUNT') -and
    [string]$remote['HOSTNAME'] -eq $expectedHostname -and
    [int]$remote['PUBLIC_IP_MATCH_COUNT'] -eq 1

$localFacts = @{
    WgAdapterUp = $wgAdapterUp
    WgManagerRunning = $wgManagerRunning
    WgTunnelRunning = $wgTunnelRunning
    ControlRouteViaWg = $controlRouteViaWg
    SplitDefaultsValid = $splitDefaultsValid
    PhysicalEgressValid = $true
    ClashServiceRunning = $clashServiceRunning
    Hy2RecoveryPresent = $hy2RecoveryPresent
    RealityClientPinned = $realityClientPinned
    P1RouteResidueAbsent = $p1RouteResidueAbsent
}
$remoteFacts = @{
    SshOk = $true
    TargetIdentityOk = $targetIdentityOk
    Hy2ServiceActive = $remote.ContainsKey('HY2_SERVICE') -and [string]$remote['HY2_SERVICE'] -eq 'active'
    Udp8443Present = $remote.ContainsKey('UDP_8443') -and [int]$remote['UDP_8443'] -ge 1
    Tcp443Free = $remote.ContainsKey('TCP_443') -and [int]$remote['TCP_443'] -eq 0
    Tcp14443Free = $remote.ContainsKey('TCP_14443') -and [int]$remote['TCP_14443'] -eq 0
    G2cResidueAbsent = $remote.ContainsKey('G2C_RUNTIME_RESIDUE') -and [int]$remote['G2C_RUNTIME_RESIDUE'] -eq 0
}
$class = Get-H2Classification -Local $localFacts -Remote $remoteFacts

Write-Output 'PHASE=RESULT'
Write-Output "POWERSHELL_RUNTIME=$($PSVersionTable.PSVersion)"
Write-Output "PHYSICAL_EGRESS=$($physical.Alias)|$($physical.InterfaceIndex)|$($physical.Gateway)|$($physical.SourceIPv4)"
Write-Output "WG_ADAPTER=$wireGuardAlias|$wgIfIndex|$([string]$wgAdapter[0].Status)"
Write-Output "WG_MANAGER_RUNNING=$($wgManagerRunning.ToString().ToUpperInvariant())"
Write-Output "WG_TUNNEL_RUNNING=$($wgTunnelRunning.ToString().ToUpperInvariant())"
Write-Output "WG_CONTROL_ROUTE_VALID=$($controlRouteViaWg.ToString().ToUpperInvariant())"
Write-Output "WG_SPLIT_DEFAULTS_VALID=$($splitDefaultsValid.ToString().ToUpperInvariant())"
Write-Output "CLASH_SERVICE_RUNNING=$($clashServiceRunning.ToString().ToUpperInvariant())"
Write-Output "SYSTEM_PROXY_ENABLED=$($systemProxyEnabled.ToString().ToUpperInvariant())"
Write-Output "WINHTTP_ACCESS_TYPE=$winHttpAccessType"
Write-Output "TUN_ADAPTER_COUNT=$tunCount"
Write-Output "P1_ROUTE_RESIDUE_COUNT=$($p1Routes.Count)"
Write-Output "HY2_RECOVERY_ARTIFACT_PRESENT=$($hy2RecoveryPresent.ToString().ToUpperInvariant())"
Write-Output "REALITY_PINNED_CLIENT_PRESENT=$($realityClientPresent.ToString().ToUpperInvariant())"
Write-Output "REALITY_PINNED_ARCHIVE_HASH_PASS=$($realityHashPass.ToString().ToUpperInvariant())"
Write-Output "TARGET_HOSTNAME=$($remote['HOSTNAME'])"
Write-Output "VPS_PUBLIC_IP_MATCH_COUNT=$($remote['PUBLIC_IP_MATCH_COUNT'])"
Write-Output "REMOTE_WG_SERVICE=$($remote['WG_SERVICE'])"
Write-Output "REMOTE_HY2_SERVICE=$($remote['HY2_SERVICE'])"
Write-Output "REMOTE_UDP_51820=$($remote['UDP_51820'])"
Write-Output "REMOTE_UDP_8443=$($remote['UDP_8443'])"
Write-Output "REMOTE_TCP_443=$($remote['TCP_443'])"
Write-Output "REMOTE_TCP_14443=$($remote['TCP_14443'])"
Write-Output "REMOTE_G2C_RUNTIME_RESIDUE=$($remote['G2C_RUNTIME_RESIDUE'])"
Write-Output "REMOTE_UFW_STATUS=$($remote['UFW_STATUS'])"
Write-Output "REMOTE_IPTABLES_BACKEND=$($remote['IPTABLES_BACKEND'])"
Write-Output "REMOTE_NFT_INPUT_POLICY=$($remote['NFT_INPUT_POLICY'])"
Write-Output "WIREGUARD_CURRENT_HEALTH=$($class.WireGuardCurrentHealth)"
Write-Output "HY2_READINESS=$($class.Hy2Readiness)"
Write-Output "REALITY_READINESS=$($class.RealityReadiness)"
Write-Output 'REALITY_INTEROP_REPROBED=NO'
Write-Output 'EXTERNAL_WORKLOAD_REQUEST_COUNT=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SERVICE_MUTATION=NO'
Write-Output 'SYSTEM_PROXY_MUTATION=NO'
Write-Output 'TUN_MUTATION=NO'
Write-Output 'VPS_MUTATION=NO'
Write-Output 'VPN_APPLICATION_SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'SSH_PRIVATE_KEY_VALUE_EXPOSED=NO'
Write-Output 'G3A_H2_READONLY_RESULT=COMPLETE'
