[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$script:phase = 'INIT'
$script:localBefore = $null
$script:preRemoteMarkers = $null
$script:localAfter = $null
$script:failureCode = $null
$script:failureType = $null
$script:cleanupFailures = [Collections.Generic.List[string]]::new()
$script:runId = [guid]::NewGuid().ToString('N')
$script:runtimeDirectory = $null
$script:runtimeConfigPath = $null
$script:runtimeDirectoryCreated = $false
$script:runtimeConfigCreated = $false
$script:mihomoProcess = $null
$script:mihomoStopped = $false
$script:curlProcess = $null
$script:curlProcessStarted = $false
$script:remoteProcess = $null
$script:remoteProcessStarted = $false
$script:remoteSecretsSent = $false
$script:remoteReady = $false
$script:remoteAssetReady = $false
$script:remotePreflightPassed = $false
$script:sshHostKeyVerified = $false
$script:remoteStartRecord = $null
$script:remoteCleanupRecord = $null
$script:canaryPass = $false
$script:requestStarted = $false
$script:curlExit = $null
$script:httpStatus = $null
$script:curlTotal = $null
$script:curlConnect = $null
$script:curlAppConnect = $null
$script:curlErrorClass = 'NOT_CAPTURED'
$script:mihomoErrorClass = 'NOT_CAPTURED'
$script:singBoxErrorClass = 'NOT_CAPTURED'
$script:handshakeTargetTcp = 'NOT_RUN'
$script:handshakeTargetTls = 'NOT_RUN'
$script:handshakeTargetTlsVersion = 'NOT_AVAILABLE'
$script:privateListenerTcpReachable = $false
$script:requestCount = 0
$script:curlStdoutTask = $null
$script:curlStderrTask = $null
$script:mihomoCapture = $null
$script:singBoxDiagnosticReadback = $false
$script:singBoxDiagnosticAttempted = $false
$script:singBoxVersion = $null
$script:singBoxAssetVerified = $false
$script:serverConfigChecked = $false
$script:privateListenerVerified = $false
$script:publicListenerNegativeVerified = $false
$script:mihomoConfigChecked = $false
$script:mihomoProxyReady = $false
$script:realityProxyUsed = $false
$script:localPostcheckPass = $false
$script:remotePostcheckPass = $false
$script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$script:identityPath = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
$script:knownHostsPath = Join-Path $env:USERPROFILE '.ssh\known_hosts'
$script:mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$script:serverTunnelIp = '10.66.21.1'
$script:serverHost = 'root@10.66.21.1'
$script:hostKeyAlias = '24.199.118.137'
$script:expectedHostname = 'ubuntu-s-1vcpu-512mb-10gb-sfo3'
$script:serverPort = 14443
$script:localProxyPort = 17990
$script:apiEndpoint = 'https://api.openai.com/v1/models'
$script:realityHandshakeHost = 'www.microsoft.com'
$script:singBoxVersionExpected = '1.14.2'
$script:singBoxAssetName = 'sing-box-1.14.2-linux-amd64-glibc.tar.gz'
$script:singBoxAssetSha256 = '5c7bc18461827b28d0e5ee7e89d33b276d3ff7c818531104c8e8d26d85b0656e'
$script:runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$script:runtimeBase = Join-Path $script:runtimeRoot ('g2c-private-reality-' + $script:runId)
$script:runtimeDirectory = $script:runtimeBase
$script:runtimeConfigPath = Join-Path $script:runtimeBase 'mihomo.yaml'

function Assert-G2c {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Get-G2cSanitizedErrorClass {
    param([AllowEmptyString()][string]$Text, [int]$ExitCode = 0, [switch]$RequestSucceeded)
    $value = if ($null -eq $Text) { '' } else { $Text.ToLowerInvariant() }
    if ($value -match '(x25519.?mlkem|ml.?kem|key.?share|hybrid.?key)') { return 'KEY_SHARE_OR_MLKEM_MISMATCH' }
    if ($value -match '(invalid|unknown|rejected|failed).{0,40}(short.?id|reality|authentication)|((short.?id|reality|authentication).{0,40}(invalid|unknown|reject|fail))') { return 'REALITY_AUTH_OR_VERIFICATION_FAILED' }
    if ($value -match '(x509|certificate|cert verify|unknown ca|hostname.{0,20}mismatch|server.?name.{0,20}mismatch|sni.{0,20}mismatch)') { return 'SNI_OR_CERT_MISMATCH' }
    if ($value -match '(vless|vision|xtls-rprx-vision|flow).{0,40}(invalid|reject|unsupported|mismatch|fail)|(invalid|unknown).{0,30}(uuid|user)') { return 'VLESS_OR_VISION_REJECTED' }
    if ($value -match '(www\.microsoft\.com|handshake target).{0,60}(refused|unreachable|timeout|timed out|failed)|((refused|unreachable).{0,60}(www\.microsoft\.com|handshake target))') { return 'HANDSHAKE_TARGET_UNREACHABLE' }
    if ($value -match '(connection reset|reset by peer|unexpected eof|\beof\b|broken pipe|remote host closed)') { return 'CONNECTION_RESET_OR_EOF' }
    if ($ExitCode -eq 28 -or $value -match '(timed out|timeout|deadline exceeded)') { return 'TIMEOUT' }
    if ($RequestSucceeded -and [string]::IsNullOrWhiteSpace($value)) { return 'NONE_OBSERVED' }
    if ($value -match '(tls.{0,20}handshake|ssl_connect|curl: \(35\)|handshake failure)' -or $ExitCode -eq 35) { return 'UNKNOWN_TLS_HANDSHAKE_FAILURE' }
    if ([string]::IsNullOrWhiteSpace($value)) { return 'UNKNOWN_TLS_HANDSHAKE_FAILURE' }
    return 'UNKNOWN_TLS_HANDSHAKE_FAILURE'
}

function Get-G2cOptionalProperty {
    param([Parameter(Mandatory = $true)][object]$Object, [Parameter(Mandatory = $true)][string]$Name)
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return '' }
    return [string]$property.Value
}

function Get-G2cTunSignature {
    $matches = @(Get-NetAdapter -IncludeHidden -ErrorAction Stop | Where-Object {
        $_.Name -match '(?i)(mihomo|clash|meta.?tun|tun.*clash)' -or
        $_.InterfaceDescription -match '(?i)(mihomo|clash|meta.?tun|wintun)'
    } | Sort-Object ifIndex | ForEach-Object {
        '{0}|{1}|{2}|{3}' -f $_.Name, $_.InterfaceDescription, $_.Status, $_.ifIndex
    })
    return $matches
}

function Get-G2cLocalSnapshot {
    $integrityText = @(& whoami.exe /groups 2>$null)
    $integrityMatch = $integrityText | ForEach-Object {
        if ($_ -match 'S-1-16-(\d+)') { [int]$Matches[1] }
    } | Select-Object -Last 1
    Assert-G2c ($null -ne $integrityMatch) 'WINDOWS_INTEGRITY_READBACK_FAILED'

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $admin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wgAdapter = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
    $routeResult = @(Find-NetRoute -RemoteIPAddress $script:serverTunnelIp -ErrorAction Stop)
    $routeIfIndexes = @($routeResult | ForEach-Object { [int]$_.InterfaceIndex } | Sort-Object -Unique)
    $proxyReg = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-G2c ($null -ne $proxyReg.PSObject.Properties['ProxyEnable']) 'SYSTEM_PROXY_REQUIRED_PROPERTY_MISSING'
    $proxyServer = Get-G2cOptionalProperty -Object $proxyReg -Name 'ProxyServer'
    $proxyOverride = Get-G2cOptionalProperty -Object $proxyReg -Name 'ProxyOverride'
    $autoConfigUrl = Get-G2cOptionalProperty -Object $proxyReg -Name 'AutoConfigURL'
    $winHttpOutput = @(& netsh.exe winhttp show proxy 2>$null)
    $winHttpExit = $LASTEXITCODE
    $winHttpText = $winHttpOutput -join "`n"
    $mihomoProcesses = @(Get-Process -Name 'verge-mihomo', 'mihomo' -ErrorAction SilentlyContinue)
    $tunSignature = @(Get-G2cTunSignature)
    $tcpProxy = @(Get-NetTCPConnection -LocalPort $script:localProxyPort -State Listen -ErrorAction SilentlyContinue)
    $udpProxy = @(Get-NetUDPEndpoint -LocalPort $script:localProxyPort -ErrorAction SilentlyContinue)
    $runtimeResidue = @()
    if (Test-Path -LiteralPath $script:runtimeRoot -PathType Container) {
        $runtimeResidue = @(Get-ChildItem -LiteralPath $script:runtimeRoot -Force -ErrorAction Stop |
            Where-Object { $_.Name -like 'g2c-private-reality-*' })
    }
    $versionOutput = @(& $script:mihomoPath -v 2>&1)
    $versionExit = $LASTEXITCODE
    $versionText = $versionOutput -join "`n"

    return [pscustomobject]@{
        PowerShell = $PSVersionTable.PSVersion.ToString()
        IntegrityRid = [int]$integrityMatch
        Administrator = [bool]$admin
        IdentityExists = Test-Path -LiteralPath $script:identityPath -PathType Leaf
        KnownHostsExists = Test-Path -LiteralPath $script:knownHostsPath -PathType Leaf
        WireGuardManager = [string]$manager.Status
        WireGuardTunnel = [string]$tunnel.Status
        WireGuardAdapterStatus = [string]$wgAdapter.Status
        WireGuardIfIndex = [int]$wgAdapter.ifIndex
        RouteIfIndexes = $routeIfIndexes
        ProxyEnable = [int]$proxyReg.ProxyEnable
        ProxyServer = $proxyServer
        ProxyOverride = $proxyOverride
        AutoConfigURL = $autoConfigUrl
        WinHttpExit = [int]$winHttpExit
        WinHttpDirect = ($winHttpText -match 'Direct access \(no proxy server\)')
        MihomoVersionExit = [int]$versionExit
        MihomoVersionText = $versionText
        MihomoProcessCount = $mihomoProcesses.Count
        TunSignature = $tunSignature
        LocalTcpProxyCount = $tcpProxy.Count
        LocalUdpProxyCount = $udpProxy.Count
        RuntimeResidueCount = $runtimeResidue.Count
    }
}

function Assert-G2cLocalPreflight {
    param([Parameter(Mandatory = $true)][object]$Snapshot)
    Assert-G2c ($Snapshot.PowerShell -match '^7\.') 'POWERSHELL_7_REQUIRED'
    Assert-G2c ($Snapshot.IntegrityRid -ge 8192) 'MEDIUM_INTEGRITY_REQUIRED'
    Assert-G2c $Snapshot.IdentityExists 'SSH_IDENTITY_FILE_MISSING'
    Assert-G2c $Snapshot.KnownHostsExists 'SSH_KNOWN_HOSTS_FILE_MISSING'
    Assert-G2c ($Snapshot.WireGuardManager -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-G2c ($Snapshot.WireGuardTunnel -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-G2c ($Snapshot.WireGuardAdapterStatus -eq 'Up' -and $Snapshot.WireGuardIfIndex -eq 13) 'WIREGUARD_ADAPTER_STATE_INVALID'
    Assert-G2c ($Snapshot.RouteIfIndexes.Count -gt 0 -and @($Snapshot.RouteIfIndexes | Where-Object { $_ -ne 13 }).Count -eq 0) 'CONTROL_ROUTE_NOT_WIREGUARD'
    Assert-G2c ($Snapshot.ProxyEnable -eq 0) 'SYSTEM_PROXY_NOT_DISABLED'
    Assert-G2c ($Snapshot.WinHttpExit -eq 0 -and $Snapshot.WinHttpDirect) 'WINHTTP_READBACK_FAILED'
    Assert-G2c ($Snapshot.MihomoVersionExit -eq 0 -and $Snapshot.MihomoVersionText -match 'Mihomo Meta v1\.19\.31') 'MIHOMO_VERSION_NOT_ACCEPTED'
    Assert-G2c ($Snapshot.MihomoProcessCount -eq 0) 'MIHOMO_PROCESS_ALREADY_PRESENT'
    Assert-G2c ($Snapshot.TunSignature.Count -eq 0) 'MIHOMO_TUN_ADAPTER_PRESENT'
    Assert-G2c ($Snapshot.LocalTcpProxyCount -eq 0 -and $Snapshot.LocalUdpProxyCount -eq 0) 'LOCAL_TEST_PROXY_PORT_IN_USE'
    Assert-G2c ($Snapshot.RuntimeResidueCount -eq 0) 'LOCAL_PRIOR_G2C_RUNTIME_RESIDUE'
    Assert-G2c (-not (Test-Path -LiteralPath $script:runtimeBase)) 'LOCAL_RUNTIME_PATH_COLLISION'
    Assert-G2c (Test-Path -LiteralPath $script:mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
}

function New-G2cSshStartInfo {
    param([Parameter(Mandatory = $true)][string]$RemoteCommand)
    $sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $sshPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach ($sshArg in @(
        '-T', '-i', $script:identityPath,
        '-o', 'BatchMode=yes',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'UpdateHostKeys=no',
        '-o', "UserKnownHostsFile=$($script:knownHostsPath)",
        '-o', "HostKeyAlias=$($script:hostKeyAlias)",
        '-o', "HostName=$($script:serverTunnelIp)",
        '-o', 'CheckHostIP=no',
        '-o', 'ControlMaster=no',
        '-o', 'ControlPath=none',
        '-o', 'ForwardAgent=no',
        '-o', 'ConnectTimeout=15',
        '-o', 'ServerAliveInterval=10',
        '-o', 'ServerAliveCountMax=2',
        $script:serverHost,
        $RemoteCommand
    )) { [void]$psi.ArgumentList.Add($sshArg) }
    return $psi
}

function Invoke-G2cReadOnlyRemoteProbe {
    param([Parameter(Mandatory = $true)][string]$ProbeText)
    $psi = New-G2cSshStartInfo -RemoteCommand 'bash -s'
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $psi
    [void]$process.Start()
    $process.StandardInput.Write($ProbeText)
    $process.StandardInput.Close()
    $probeOutput = $process.StandardOutput.ReadToEnd()
    $probeError = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) {
        $null = $probeError
        throw 'STRICT_SSH_READONLY_PROBE_FAILED'
    }
    return $probeOutput
}

function ConvertFrom-G2cMarkerText {
    param([Parameter(Mandatory = $true)][string]$Text)
    $result = @{}
    foreach ($line in ($Text -split "\r?\n")) {
        $separator = $line.IndexOf('=')
        if ($separator -gt 0) { $result[$line.Substring(0, $separator)] = $line.Substring($separator + 1).Trim() }
    }
    return $result
}

function Get-G2cRemoteProbeText {
    param([Parameter(Mandatory = $true)][string]$RunId)
    return @"
set -eu
. /etc/os-release
printf 'REMOTE_HOSTNAME=%s\n' "`$(hostname -f)"
printf 'REMOTE_UID=%s\n' "`$(id -u)"
printf 'REMOTE_OS=%s\n' "`$PRETTY_NAME"
printf 'REMOTE_KERNEL=%s\n' "`$(uname -r)"
printf 'REMOTE_ARCH=%s\n' "`$(uname -m)"
if systemctl is-active --quiet wg-quick@wg0; then echo WG_SERVICE=active; else echo WG_SERVICE=inactive; fi
if systemctl is-active --quiet hysteria2-vpn-network-optimization.service; then echo HY2_SERVICE=active; else echo HY2_SERVICE=inactive; fi
ss -H -lun | awk '`$4 ~ /:51820$/ {a++} `$4 ~ /:8443$/ {b++} END {printf "UDP_51820_LISTENERS=%d\nUDP_8443_LISTENERS=%d\n", a+0, b+0}'
ss -H -ltn | awk '`$4 ~ /:14443$/ {a++} `$4 ~ /:443$/ {b++} END {printf "TCP_14443_LISTENERS=%d\nTCP_443_LISTENERS=%d\n", a+0, b+0}'
if command -v python3 >/dev/null 2>&1; then echo PYTHON3=YES; else echo PYTHON3=NO; fi
python3 - <<'PY'
import socket, ssl

host = "www.microsoft.com"
tcp = "FAIL"
tls = "FAIL"
version = "NOT_AVAILABLE"
error = "HANDSHAKE_TARGET_UNREACHABLE"
try:
    raw = socket.create_connection((host, 443), timeout=5)
    tcp = "PASS"
    try:
        with ssl.create_default_context().wrap_socket(raw, server_hostname=host) as conn:
            tls = "PASS"
            version = conn.version() or "NOT_AVAILABLE"
            error = "NONE_OBSERVED"
    except ssl.SSLCertVerificationError:
        error = "SNI_OR_CERT_MISMATCH"
    except (socket.timeout, TimeoutError):
        error = "TIMEOUT"
    except (ConnectionResetError, EOFError):
        error = "CONNECTION_RESET_OR_EOF"
    except Exception:
        error = "UNKNOWN_TLS_HANDSHAKE_FAILURE"
        try: raw.close()
        except Exception: pass
except (socket.timeout, TimeoutError):
    error = "TIMEOUT"
except (ConnectionResetError, EOFError):
    error = "CONNECTION_RESET_OR_EOF"
except Exception:
    error = "HANDSHAKE_TARGET_UNREACHABLE"
print("HANDSHAKE_TARGET_TCP=" + tcp)
print("HANDSHAKE_TARGET_TLS=" + tls)
print("HANDSHAKE_TARGET_TLS_VERSION=" + (version if version in ("TLSv1.2", "TLSv1.3") else "NOT_AVAILABLE"))
print("HANDSHAKE_TARGET_ERROR_CLASS=" + error)
PY
if command -v pgrep >/dev/null 2>&1; then echo SING_BOX_PROCESS_COUNT=`$(pgrep -cx sing-box 2>/dev/null || true); else echo SING_BOX_PROCESS_COUNT=`$(ps -eo comm= | awk '`$1 == "sing-box" {n++} END {print n+0}'); fi
if [ -e '/run/vpn-network-optimization-g2c-$RunId' ] || [ -L '/run/vpn-network-optimization-g2c-$RunId' ] || [ -e '/tmp/vpn-network-optimization-g2c-$RunId' ] || [ -L '/tmp/vpn-network-optimization-g2c-$RunId' ]; then echo G2C_RUN_PATH_COLLISION=YES; else echo G2C_RUN_PATH_COLLISION=NO; fi
printf 'REMOTE_DEFAULT_ROUTE=%s\n' "`$(ip -4 route show default | head -n 1 | sed 's/[[:space:]]*$//')"
printf 'REMOTE_WG_ROUTE=%s\n' "`$(ip -4 route show dev wg0 | head -n 1 | sed 's/[[:space:]]*$//')"
printf 'MEM_AVAILABLE_KIB=%s\n' "`$(awk '/MemAvailable:/ {print `$2}' /proc/meminfo)"
printf 'TMP_FREE_KIB=%s\n' "`$(df -Pk /tmp | awk 'NR==2 {print `$4}')"
"@
}

function Assert-G2cRemotePreflight {
    param([Parameter(Mandatory = $true)][hashtable]$Markers)
    Assert-G2c ($Markers['REMOTE_HOSTNAME'] -eq $script:expectedHostname) 'TARGET_HOSTNAME_MISMATCH'
    Assert-G2c ($Markers['REMOTE_UID'] -eq '0') 'REMOTE_ROOT_IDENTITY_NOT_PROVEN'
    Assert-G2c ($Markers['REMOTE_OS'] -eq 'Ubuntu 24.04.5 LTS') 'TARGET_OS_MISMATCH'
    Assert-G2c ($Markers['REMOTE_ARCH'] -eq 'x86_64') 'TARGET_ARCH_MISMATCH'
    Assert-G2c ($Markers['WG_SERVICE'] -eq 'active') 'REMOTE_WG_SERVICE_NOT_ACTIVE'
    Assert-G2c ($Markers['HY2_SERVICE'] -eq 'active') 'REMOTE_HY2_SERVICE_NOT_ACTIVE'
    Assert-G2c ([int]$Markers['UDP_51820_LISTENERS'] -ge 1) 'REMOTE_WG_UDP_LISTENER_MISSING'
    Assert-G2c ([int]$Markers['UDP_8443_LISTENERS'] -ge 1) 'REMOTE_HY2_UDP_LISTENER_MISSING'
    Assert-G2c ([int]$Markers['TCP_14443_LISTENERS'] -eq 0) 'REMOTE_PRIVATE_CANARY_PORT_ALREADY_LISTENING'
    Assert-G2c ([int]$Markers['TCP_443_LISTENERS'] -eq 0) 'REMOTE_TCP443_NOT_FREE'
    Assert-G2c ($Markers['PYTHON3'] -eq 'YES') 'REMOTE_PYTHON3_UNAVAILABLE'
    Assert-G2c ($Markers['SING_BOX_PROCESS_COUNT'] -eq '0') 'REMOTE_SING_BOX_PROCESS_ALREADY_PRESENT'
    Assert-G2c ($Markers['G2C_RUN_PATH_COLLISION'] -eq 'NO') 'REMOTE_G2C_PATH_COLLISION'
    Assert-G2c ($Markers['HANDSHAKE_TARGET_TCP'] -in @('PASS', 'FAIL')) 'HANDSHAKE_TARGET_TCP_READBACK_INVALID'
    Assert-G2c ($Markers['HANDSHAKE_TARGET_TLS'] -in @('PASS', 'FAIL')) 'HANDSHAKE_TARGET_TLS_READBACK_INVALID'
    Assert-G2c ($Markers['HANDSHAKE_TARGET_TLS_VERSION'] -match '^(TLSv1\.[23]|NOT_AVAILABLE)$') 'HANDSHAKE_TARGET_TLS_VERSION_INVALID'
    Assert-G2c ($Markers['HANDSHAKE_TARGET_ERROR_CLASS'] -in @('NONE_OBSERVED', 'HANDSHAKE_TARGET_UNREACHABLE', 'CONNECTION_RESET_OR_EOF', 'TIMEOUT', 'SNI_OR_CERT_MISMATCH', 'UNKNOWN_TLS_HANDSHAKE_FAILURE')) 'HANDSHAKE_TARGET_ERROR_CLASS_INVALID'
}

function Get-G2cRemoteSupervisorSource {
    return @'
import base64, hashlib, json, os, pathlib, re, shutil, signal, stat, subprocess, sys, tarfile, time, urllib.request

RUN_ID = sys.argv[1]
MODE = sys.argv[2] if len(sys.argv) > 2 else "run"
EXPECTED_SHA = "5c7bc18461827b28d0e5ee7e89d33b276d3ff7c818531104c8e8d26d85b0656e"
ASSET_URL = "https://github.com/SagerNet/sing-box/releases/download/v1.14.2/sing-box-1.14.2-linux-amd64-glibc.tar.gz"
ASSET_NAME = "sing-box-1.14.2-linux-amd64-glibc.tar.gz"
RUNTIME = pathlib.Path("/run") / ("vpn-network-optimization-g2c-" + RUN_ID)
WORKSPACE = pathlib.Path("/tmp") / ("vpn-network-optimization-g2c-" + RUN_ID)
CONFIG = RUNTIME / "server.json"
PID_FILE = RUNTIME / "sing-box.pid"
BINARY = WORKSPACE / "sing-box"
LOG_FILE = RUNTIME / "sing-box.log"
SERVER = None
RUNTIME_CREATED = False
WORKSPACE_CREATED = False
PRIVATE_KEY = None
PUBLIC_KEY = None
CLIENT_UUID = None
SHORT_ID = None
CLIENT_BYTES = None
FAILURE = None

class GateFailure(Exception):
    pass

def emit(obj):
    sys.stdout.write(json.dumps(obj, separators=(",", ":")) + "\n")
    sys.stdout.flush()

def exact_listener_state():
    result = subprocess.run(["ss", "-H", "-ltn"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, check=True, timeout=5)
    on_14443 = []
    on_443 = []
    for line in result.stdout.decode("utf-8", "replace").splitlines():
        fields = line.split()
        if len(fields) < 4:
            continue
        local = fields[3]
        if local.endswith(":14443"):
            on_14443.append(local)
        if local.endswith(":443"):
            on_443.append(local)
    return on_14443, on_443

def classify_core_error(text):
    value = text.lower()
    if re.search(r"x25519.?mlkem|ml.?kem|key.?share|hybrid.?key", value):
        return "KEY_SHARE_OR_MLKEM_MISMATCH"
    if re.search(r"(invalid|unknown|rejected|failed).{0,40}(short.?id|reality|authentication)|((short.?id|reality|authentication).{0,40}(invalid|unknown|reject|fail))", value):
        return "REALITY_AUTH_OR_VERIFICATION_FAILED"
    if re.search(r"x509|certificate|cert verify|unknown ca|hostname.{0,20}mismatch|server.?name.{0,20}mismatch|sni.{0,20}mismatch", value):
        return "SNI_OR_CERT_MISMATCH"
    if re.search(r"(vless|vision|xtls-rprx-vision|flow).{0,40}(invalid|reject|unsupported|mismatch|fail)|(invalid|unknown).{0,30}(uuid|user)", value):
        return "VLESS_OR_VISION_REJECTED"
    if re.search(r"(www\.microsoft\.com|handshake target).{0,60}(refused|unreachable|timeout|timed out|failed)|((refused|unreachable).{0,60}(www\.microsoft\.com|handshake target))", value):
        return "HANDSHAKE_TARGET_UNREACHABLE"
    if re.search(r"connection reset|reset by peer|unexpected eof|\beof\b|broken pipe|remote host closed", value):
        return "CONNECTION_RESET_OR_EOF"
    if re.search(r"timed out|timeout|deadline exceeded", value):
        return "TIMEOUT"
    if re.search(r"tls.{0,20}handshake|ssl_connect|handshake failure", value):
        return "UNKNOWN_TLS_HANDSHAKE_FAILURE"
    return "UNKNOWN_TLS_HANDSHAKE_FAILURE" if value.strip() else "NONE_OBSERVED"

def sing_box_error_class():
    try:
        info = LOG_FILE.stat(follow_symlinks=False)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != 0 or stat.S_IMODE(info.st_mode) != 0o600:
            return "UNKNOWN_TLS_HANDSHAKE_FAILURE"
        raw = LOG_FILE.read_bytes()
        text = raw.decode("utf-8", "replace")
        result = classify_core_error(text)
        raw = None
        text = None
        return result
    except OSError:
        return "UNKNOWN_TLS_HANDSHAKE_FAILURE"

def same_server_process(pid):
    try:
        proc = pathlib.Path("/proc") / str(pid)
        exe = os.readlink(str(proc / "exe"))
        argv = (proc / "cmdline").read_bytes().split(b"\0")
        argv = [item.decode("utf-8", "replace") for item in argv if item]
        expected = [str(BINARY), "run", "-c", str(CONFIG)]
        return exe == str(BINARY) and argv == expected
    except (OSError, ValueError):
        return False

def remove_marked_directory(path):
    if not path.exists() and not path.is_symlink():
        return True
    try:
        info = path.lstat()
        if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or info.st_uid != 0:
            return False
        marker = path / "owner"
        if not marker.is_file() or marker.is_symlink() or marker.read_text(encoding="ascii").strip() != RUN_ID:
            return False
        shutil.rmtree(path)
        return not path.exists() and not path.is_symlink()
    except OSError:
        return False

def stop_pid_exact(pid):
    if not same_server_process(pid):
        return not pathlib.Path("/proc", str(pid)).exists()
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        return True
    deadline = time.monotonic() + 5
    while time.monotonic() < deadline:
        if not pathlib.Path("/proc", str(pid)).exists():
            return True
        if not same_server_process(pid):
            return True
        time.sleep(0.1)
    if same_server_process(pid):
        try:
            os.kill(pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
    deadline = time.monotonic() + 3
    while time.monotonic() < deadline:
        if not pathlib.Path("/proc", str(pid)).exists() or not same_server_process(pid):
            return True
        time.sleep(0.1)
    return False

def matching_server_pids():
    try:
        return [int(entry.name) for entry in pathlib.Path("/proc").iterdir()
                if entry.name.isdigit() and same_server_process(int(entry.name))]
    except OSError:
        return None

def emergency_cleanup():
    failures = []
    matches = matching_server_pids()
    if matches is None:
        return {"status": "cleanup_failed", "phase": "SERVER_PROCESS_SCAN_FAILED"}
    if RUNTIME.exists() or RUNTIME.is_symlink():
        try:
            marker = RUNTIME / "owner"
            if RUNTIME.is_symlink() or not marker.is_file() or marker.is_symlink() or marker.read_text(encoding="ascii").strip() != RUN_ID:
                return {"status": "cleanup_failed", "phase": "RUNTIME_OWNER_MARKER_INVALID"}
            if PID_FILE.exists():
                raw_pid = PID_FILE.read_text(encoding="ascii").strip()
                if not raw_pid.isdigit():
                    return {"status": "cleanup_failed", "phase": "SERVER_PID_INVALID"}
                pid = int(raw_pid)
                if pathlib.Path("/proc", str(pid)).exists() and not same_server_process(pid):
                    return {"status": "cleanup_failed", "phase": "SERVER_PID_IDENTITY_MISMATCH"}
                if pid not in matches and pathlib.Path("/proc", str(pid)).exists():
                    matches.append(pid)
            for pid in matches:
                if not stop_pid_exact(pid):
                    return {"status": "cleanup_failed", "phase": "SERVER_PROCESS_STOP_FAILED"}
        except OSError:
            return {"status": "cleanup_failed", "phase": "RUNTIME_METADATA_READ_FAILED"}
    else:
        for pid in matches:
            if not stop_pid_exact(pid):
                return {"status": "cleanup_failed", "phase": "SERVER_PROCESS_STOP_FAILED"}
    if matching_server_pids() != []:
        return {"status": "cleanup_failed", "phase": "SERVER_PROCESS_REMAINS"}
    if WORKSPACE.exists() or WORKSPACE.is_symlink():
        try:
            marker = WORKSPACE / "owner"
            if WORKSPACE.is_symlink() or not marker.is_file() or marker.is_symlink() or marker.read_text(encoding="ascii").strip() != RUN_ID:
                return {"status": "cleanup_failed", "phase": "WORKSPACE_OWNER_MARKER_INVALID"}
        except OSError:
            return {"status": "cleanup_failed", "phase": "WORKSPACE_METADATA_READ_FAILED"}
    try:
        if RUNTIME.exists() and not remove_marked_directory(RUNTIME):
            failures.append("RUNTIME_REMOVE_FAILED")
        if WORKSPACE.exists() and not remove_marked_directory(WORKSPACE):
            failures.append("WORKSPACE_REMOVE_FAILED")
        if RUNTIME.exists() or RUNTIME.is_symlink() or WORKSPACE.exists() or WORKSPACE.is_symlink():
            failures.append("REMOTE_PATH_REMAINS")
    except Exception:
        failures.append("REMOTE_REMOVE_EXCEPTION")
    return {"status": "cleanup_failed" if failures else "cleaned", "cleanup_failures": failures,
            "server_process_stopped": True, "runtime_absent": not RUNTIME.exists(),
            "workspace_absent": not WORKSPACE.exists()}

def write_exclusive(path, data, mode):
    fd = os.open(str(path), os.O_WRONLY | os.O_CREAT | os.O_EXCL, mode)
    with os.fdopen(fd, "wb") as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())
    os.chmod(path, mode)
    info = path.stat(follow_symlinks=False)
    if info.st_uid != 0 or stat.S_IMODE(info.st_mode) != mode:
        raise GateFailure("REMOTE_FILE_OWNER_OR_MODE_INVALID")

def cleanup_supervisor():
    failures = []
    if SERVER is not None and SERVER.poll() is None:
        try:
            SERVER.terminate()
            SERVER.wait(timeout=5)
        except subprocess.TimeoutExpired:
            try:
                SERVER.kill()
                SERVER.wait(timeout=3)
            except Exception:
                failures.append("SERVER_PROCESS_STOP_FAILED")
        except Exception:
            failures.append("SERVER_PROCESS_STOP_FAILED")
    server_stopped = SERVER is None or SERVER.poll() is not None
    try:
        deadline = time.monotonic() + 3
        while time.monotonic() < deadline:
            listeners, public443 = exact_listener_state()
            if not listeners:
                break
            time.sleep(0.1)
        listeners, public443 = exact_listener_state()
        if listeners:
            failures.append("TCP14443_LISTENER_REMAINS")
        if public443:
            failures.append("TCP443_LISTENER_PRESENT")
    except Exception:
        failures.append("POSTSTOP_LISTENER_READBACK_FAILED")
    runtime_absent = remove_marked_directory(RUNTIME) if RUNTIME_CREATED else (not RUNTIME.exists() and not RUNTIME.is_symlink())
    workspace_absent = remove_marked_directory(WORKSPACE) if WORKSPACE_CREATED else (not WORKSPACE.exists() and not WORKSPACE.is_symlink())
    if not runtime_absent:
        failures.append("RUNTIME_REMOVE_FAILED")
    if not workspace_absent:
        failures.append("WORKSPACE_REMOVE_FAILED")
    return {"cleanup_failures": failures, "server_process_stopped": server_stopped,
            "tcp14443_absent": not bool(locals().get("listeners", ["unknown"])),
            "tcp443_free": not bool(locals().get("public443", ["unknown"])),
            "runtime_absent": runtime_absent, "workspace_absent": workspace_absent}

def on_signal(signum, frame):
    raise GateFailure("REMOTE_CONTROL_SIGNALLED")

def main_run():
    global SERVER, RUNTIME_CREATED, WORKSPACE_CREATED, PRIVATE_KEY, PUBLIC_KEY, CLIENT_UUID, SHORT_ID, CLIENT_BYTES, FAILURE
    if not re.fullmatch(r"[0-9a-f]{32}", RUN_ID):
        raise GateFailure("RUN_ID_INVALID")
    if RUNTIME.exists() or RUNTIME.is_symlink() or WORKSPACE.exists() or WORKSPACE.is_symlink():
        raise GateFailure("REMOTE_RUN_PATH_COLLISION")
    os.umask(0o077)
    RUNTIME.mkdir(mode=0o700)
    RUNTIME_CREATED = True
    os.chmod(RUNTIME, 0o700)
    write_exclusive(RUNTIME / "owner", (RUN_ID + "\n").encode("ascii"), 0o600)
    WORKSPACE.mkdir(mode=0o700)
    WORKSPACE_CREATED = True
    os.chmod(WORKSPACE, 0o700)
    write_exclusive(WORKSPACE / "owner", (RUN_ID + "\n").encode("ascii"), 0o600)

    archive = WORKSPACE / ASSET_NAME
    request = urllib.request.Request(ASSET_URL, headers={"User-Agent": "vpn-network-optimization-g2c-canary"})
    with urllib.request.urlopen(request, timeout=60) as response:
        fd = os.open(str(archive), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        digest = hashlib.sha256()
        total = 0
        with os.fdopen(fd, "wb") as stream:
            while True:
                chunk = response.read(1024 * 1024)
                if not chunk:
                    break
                total += len(chunk)
                if total > 100 * 1024 * 1024:
                    raise GateFailure("PINNED_ASSET_SIZE_LIMIT_EXCEEDED")
                digest.update(chunk)
                stream.write(chunk)
            stream.flush()
            os.fsync(stream.fileno())
    if digest.hexdigest() != EXPECTED_SHA:
        raise GateFailure("PINNED_ASSET_SHA256_MISMATCH")
    with tarfile.open(str(archive), "r:gz") as bundle:
        candidates = []
        for member in bundle.getmembers():
            path = pathlib.PurePosixPath(member.name)
            if path.is_absolute() or ".." in path.parts:
                continue
            if path.name == "sing-box" and member.isfile():
                candidates.append(member)
        if len(candidates) != 1:
            raise GateFailure("PINNED_ASSET_BINARY_CARDINALITY_INVALID")
        source = bundle.extractfile(candidates[0])
        if source is None:
            raise GateFailure("PINNED_ASSET_BINARY_MISSING")
        fd = os.open(str(BINARY), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o700)
        with source, os.fdopen(fd, "wb") as stream:
            shutil.copyfileobj(source, stream, 1024 * 1024)
            stream.flush()
            os.fsync(stream.fileno())
    os.chmod(BINARY, 0o700)
    version = subprocess.run([str(BINARY), "version"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                             timeout=10, check=False)
    version_text = version.stdout.decode("utf-8", "replace")
    if version.returncode != 0 or "1.14.2" not in version_text:
        raise GateFailure("SING_BOX_VERSION_MISMATCH")
    keypair = subprocess.run([str(BINARY), "generate", "reality-keypair"], stdout=subprocess.PIPE,
                             stderr=subprocess.DEVNULL, timeout=10, check=False)
    if keypair.returncode != 0:
        raise GateFailure("REALITY_KEYPAIR_GENERATION_FAILED")
    key_text = keypair.stdout.decode("ascii", "strict")
    private_match = re.search(r"PrivateKey:\s*([A-Za-z0-9_-]+)", key_text)
    public_match = re.search(r"PublicKey:\s*([A-Za-z0-9_-]+)", key_text)
    if private_match is None or public_match is None:
        raise GateFailure("REALITY_KEYPAIR_FORMAT_INVALID")
    PRIVATE_KEY = private_match.group(1)
    PUBLIC_KEY = public_match.group(1)
    for key_value in (PRIVATE_KEY, PUBLIC_KEY):
        decoded = base64.urlsafe_b64decode(key_value + "=" * ((4 - len(key_value) % 4) % 4))
        if len(decoded) != 32:
            raise GateFailure("REALITY_KEY_LENGTH_INVALID")
    key_text = None
    keypair = None
    emit({"status": "asset_ready", "sing_box_version": "1.14.2", "asset_sha256": "PASS", "public_key": PUBLIC_KEY})

    CLIENT_BYTES = bytearray(sys.stdin.buffer.readline())
    if not CLIENT_BYTES:
        raise GateFailure("CLIENT_SECRET_INPUT_MISSING")
    client_data = json.loads(CLIENT_BYTES)
    for index in range(len(CLIENT_BYTES)):
        CLIENT_BYTES[index] = 0
    CLIENT_BYTES = None
    if not isinstance(client_data, dict) or set(client_data.keys()) != {"uuid", "short_id"}:
        raise GateFailure("CLIENT_SECRET_ALLOWLIST_INVALID")
    CLIENT_UUID = client_data.get("uuid")
    SHORT_ID = client_data.get("short_id")
    if not isinstance(CLIENT_UUID, str) or not re.fullmatch(r"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}", CLIENT_UUID):
        raise GateFailure("CLIENT_UUID_FORMAT_INVALID")
    if not isinstance(SHORT_ID, str) or not re.fullmatch(r"[0-9a-f]{16}", SHORT_ID):
        raise GateFailure("CLIENT_SHORT_ID_FORMAT_INVALID")
    client_data = None

    config_data = {
        "log": {"level": "debug"},
        "inbounds": [{
            "type": "vless", "tag": "g2c-private-reality-in",
            "listen": "10.66.21.1", "listen_port": 14443,
            "users": [{"uuid": CLIENT_UUID, "flow": "xtls-rprx-vision"}],
            "tls": {"enabled": True, "server_name": "www.microsoft.com",
                    "reality": {"enabled": True,
                                "handshake": {"server": "www.microsoft.com", "server_port": 443},
                                "private_key": PRIVATE_KEY, "short_id": [SHORT_ID]}}
        }],
        "outbounds": [{"type": "direct", "tag": "direct"}, {"type": "block", "tag": "block"}]
    }
    config_bytes = json.dumps(config_data, separators=(",", ":")).encode("utf-8")
    write_exclusive(CONFIG, config_bytes, 0o600)
    config_bytes = None
    config_data = None
    PRIVATE_KEY = None
    CLIENT_UUID = None
    SHORT_ID = None
    checked = subprocess.run([str(BINARY), "check", "-c", str(CONFIG)], stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, timeout=20, check=False)
    if checked.returncode != 0:
        checked = None
        raise GateFailure("SERVER_CONFIG_CHECK_FAILED")
    checked = None
    log_fd = os.open(str(LOG_FILE), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    os.fchmod(log_fd, 0o600)
    try:
        SERVER = subprocess.Popen([str(BINARY), "run", "-c", str(CONFIG)], stdin=subprocess.DEVNULL,
                                  stdout=log_fd, stderr=subprocess.STDOUT, close_fds=True,
                                  start_new_session=True)
    finally:
        os.close(log_fd)
    log_info = LOG_FILE.stat(follow_symlinks=False)
    if log_info.st_uid != 0 or stat.S_IMODE(log_info.st_mode) != 0o600:
        raise GateFailure("SERVER_DIAGNOSTIC_LOG_OWNER_OR_MODE_INVALID")
    write_exclusive(PID_FILE, (str(SERVER.pid) + "\n").encode("ascii"), 0o600)
    deadline = time.monotonic() + 8
    while time.monotonic() < deadline:
        if SERVER.poll() is not None:
            raise GateFailure("SING_BOX_PROCESS_EXITED_BEFORE_LISTEN")
        listeners, public443 = exact_listener_state()
        if listeners == ["10.66.21.1:14443"] and not public443:
            break
        time.sleep(0.1)
    listeners, public443 = exact_listener_state()
    if listeners != ["10.66.21.1:14443"] or public443:
        raise GateFailure("PRIVATE_LISTENER_BOUNDARY_INVALID")
    emit({"status": "ready", "server_config_check": "PASS", "private_listener": "10.66.21.1:14443",
          "public_14443_listener": "NO", "public_tcp443_listener": "NO"})
    signal.signal(signal.SIGTERM, on_signal)
    signal.signal(signal.SIGHUP, on_signal)
    signal.signal(signal.SIGINT, on_signal)
    signal.alarm(90)
    control = sys.stdin.buffer.readline()
    signal.alarm(0)
    if control in (b"DIAGNOSTICS\n", b"DIAGNOSTICS\r\n"):
        emit({"status": "diagnostics", "sing_box_error_class": sing_box_error_class()})
        control = sys.stdin.buffer.readline()
    if control not in (b"CLEANUP\n", b"CLEANUP\r\n", b""):
        raise GateFailure("REMOTE_CONTROL_COMMAND_INVALID")

if MODE == "cleanup":
    if not re.fullmatch(r"[0-9a-f]{32}", RUN_ID):
        emit({"status": "cleanup_failed", "phase": "RUN_ID_INVALID"})
        sys.exit(1)
    result = emergency_cleanup()
    emit(result)
    sys.exit(0 if result.get("status") == "cleaned" else 1)

if not re.fullmatch(r"[0-9a-f]{32}", RUN_ID):
    emit({"status": "failed", "phase": "RUN_ID_INVALID"})
    sys.exit(1)
signal.signal(signal.SIGTERM, on_signal)
signal.signal(signal.SIGHUP, on_signal)
signal.signal(signal.SIGINT, on_signal)
try:
    main_run()
except GateFailure as exc:
    FAILURE = str(exc) if re.fullmatch(r"[A-Z0-9_]+", str(exc)) else "REMOTE_GATE_FAILURE"
except BaseException:
    FAILURE = "REMOTE_RUNTIME_FAILURE"
finally:
    cleanup = cleanup_supervisor()
    PUBLIC_KEY = None
    PRIVATE_KEY = None
    CLIENT_UUID = None
    SHORT_ID = None
    CLIENT_BYTES = None
    result = {"status": "failed" if FAILURE or cleanup["cleanup_failures"] else "cleaned",
              "phase": FAILURE or "NONE", "cleanup_failures": cleanup["cleanup_failures"],
              "server_process_stopped": cleanup["server_process_stopped"],
              "tcp14443_absent": cleanup["tcp14443_absent"], "tcp443_free": cleanup["tcp443_free"],
              "runtime_absent": cleanup["runtime_absent"], "workspace_absent": cleanup["workspace_absent"]}
    emit(result)
    sys.exit(1 if result["status"] != "cleaned" else 0)
'@
}

function New-G2cRemotePythonCommand {
    param([Parameter(Mandatory = $true)][string]$Source, [Parameter(Mandatory = $true)][string]$Mode)
    $sourceBytes = [Text.Encoding]::UTF8.GetBytes($Source)
    $encodedSource = [Convert]::ToBase64String($sourceBytes)
    [Array]::Clear($sourceBytes, 0, $sourceBytes.Length)
    return "python3 -c `"exec(__import__('base64').b64decode('$encodedSource'))`" $($script:runId) $Mode"
}

function Start-G2cSuppressedProcess {
    param([Parameter(Mandatory = $true)][string]$FilePath, [Parameter(Mandatory = $true)][string[]]$ArgumentList)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $FilePath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    foreach ($processArg in $ArgumentList) { [void]$psi.ArgumentList.Add($processArg) }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $psi
    [void]$process.Start()
    $stdoutCapture = $process.StandardOutput.ReadToEndAsync()
    $stderrCapture = $process.StandardError.ReadToEndAsync()
    return [pscustomobject]@{ Process = $process; StdoutCapture = $stdoutCapture; StderrCapture = $stderrCapture }
}

function New-G2cOwnerOnlyDirectoryAcl {
    $acl = [Security.AccessControl.DirectorySecurity]::new()
    $acl.SetOwner($script:ownerSid)
    $acl.SetAccessRuleProtection($true, $false)
    $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
                   [Security.AccessControl.InheritanceFlags]::ObjectInherit
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid, [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance, [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function New-G2cOwnerOnlyFileAcl {
    $acl = [Security.AccessControl.FileSecurity]::new()
    $acl.SetOwner($script:ownerSid)
    $acl.SetAccessRuleProtection($true, $false)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid, [Security.AccessControl.FileSystemRights]::FullControl,
        [Security.AccessControl.InheritanceFlags]::None,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-G2cOwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path, [switch]$Directory)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-G2c (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLIENT_RUNTIME_REPARSE_POINT'
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-G2c $acl.AreAccessRulesProtected 'CLIENT_RUNTIME_ACL_INHERITANCE_ENABLED'
    $actualOwner = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate([Security.Principal.SecurityIdentifier]).Value
    Assert-G2c ($actualOwner -eq $script:ownerSid.Value) 'CLIENT_RUNTIME_ACL_OWNER_INVALID'
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    Assert-G2c ($rules.Count -gt 0) 'CLIENT_RUNTIME_ACL_RULES_MISSING'
    $directRights = [long]0
    $containerRights = [long]0
    $objectRights = [long]0
    foreach ($rule in $rules) {
        Assert-G2c (-not $rule.IsInherited) 'CLIENT_RUNTIME_ACL_INHERITED_RULE_PRESENT'
        Assert-G2c ($rule.IdentityReference.Value -eq $script:ownerSid.Value) 'CLIENT_RUNTIME_ACL_ALLOWLIST_INVALID'
        Assert-G2c ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'CLIENT_RUNTIME_ACL_DENY_RULE_PRESENT'
        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $directRights = $directRights -bor $rights
        }
        if ($Directory) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) { $containerRights = $containerRights -bor $rights }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) { $objectRights = $objectRights -bor $rights }
        }
        else {
            Assert-G2c ($rule.InheritanceFlags -eq [Security.AccessControl.InheritanceFlags]::None -and
                        $rule.PropagationFlags -eq [Security.AccessControl.PropagationFlags]::None) 'CLIENT_RUNTIME_FILE_INHERITANCE_FLAGS_INVALID'
        }
    }
    $fullControl = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-G2c (($directRights -band $fullControl) -eq $fullControl) 'CLIENT_RUNTIME_OWNER_FULLCONTROL_MISSING'
    if ($Directory) {
        Assert-G2c (($containerRights -band $fullControl) -eq $fullControl -and
                    ($objectRights -band $fullControl) -eq $fullControl) 'CLIENT_RUNTIME_CHILD_ACL_INHERITANCE_MISSING'
    }
}

function New-G2cClientRuntime {
    param([Parameter(Mandatory = $true)][string]$Uuid, [Parameter(Mandatory = $true)][string]$PublicKey,
          [Parameter(Mandatory = $true)][string]$ShortId)
    [void][IO.Directory]::CreateDirectory($script:runtimeRoot)
    if (-not ('G2cCanaryNative' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class G2cCanaryNative {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool CreateDirectory(string path, IntPtr securityAttributes);
}
'@
    }
    if (-not [G2cCanaryNative]::CreateDirectory($script:runtimeDirectory, [IntPtr]::Zero)) {
        throw 'CLIENT_RUNTIME_DIRECTORY_CREATE_EXCLUSIVE_FAILED'
    }
    $script:runtimeDirectoryCreated = $true
    Set-Acl -LiteralPath $script:runtimeDirectory -AclObject (New-G2cOwnerOnlyDirectoryAcl) -ErrorAction Stop
    Assert-G2cOwnerOnlyAcl -Path $script:runtimeDirectory -Directory

    $yaml = @"
port: $($script:localProxyPort)
allow-lan: false
bind-address: 127.0.0.1
mode: rule
log-level: debug
tun:
  enable: false
proxies:
  - name: G2C-REALITY
    type: vless
    server: 10.66.21.1
    port: 14443
    uuid: $Uuid
    udp: false
    flow: xtls-rprx-vision
    network: tcp
    tls: true
    servername: www.microsoft.com
    client-fingerprint: chrome
    reality-opts:
      public-key: $PublicKey
      short-id: $ShortId
proxy-groups:
  - name: G2C-TEST
    type: select
    proxies:
      - G2C-REALITY
rules:
  - MATCH,G2C-TEST
"@
    $fileStream = [IO.File]::Open($script:runtimeConfigPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    $fileStream.Dispose()
    $script:runtimeConfigCreated = $true
    Set-Acl -LiteralPath $script:runtimeConfigPath -AclObject (New-G2cOwnerOnlyFileAcl) -ErrorAction Stop
    Assert-G2cOwnerOnlyAcl -Path $script:runtimeConfigPath
    $yamlBytes = [Text.UTF8Encoding]::new($false).GetBytes($yaml)
    try {
        $writer = [IO.File]::Open($script:runtimeConfigPath, [IO.FileMode]::Open, [IO.FileAccess]::Write, [IO.FileShare]::None)
        try { $writer.Write($yamlBytes, 0, $yamlBytes.Length); $writer.Flush($true) } finally { $writer.Dispose() }
    }
    finally {
        [Array]::Clear($yamlBytes, 0, $yamlBytes.Length)
        $yamlBytes = $null
        $yaml = $null
    }
    Assert-G2cOwnerOnlyAcl -Path $script:runtimeConfigPath
}

function Get-G2cRemoteReadyLine {
    param([Parameter(Mandatory = $true)][Diagnostics.Process]$Process, [Parameter(Mandatory = $true)][int]$TimeoutSeconds)
    $readTask = $Process.StandardOutput.ReadLineAsync()
    if (-not $readTask.Wait([TimeSpan]::FromSeconds($TimeoutSeconds))) { throw 'REMOTE_READY_TIMEOUT' }
    return $readTask.GetAwaiter().GetResult()
}

function Test-G2cPrivateListenerTcp {
    $client = [Net.Sockets.TcpClient]::new()
    try {
        $connect = $client.BeginConnect($script:serverTunnelIp, $script:serverPort, $null, $null)
        if (-not $connect.AsyncWaitHandle.WaitOne(3000)) { return $false }
        $client.EndConnect($connect)
        return $true
    }
    catch { return $false }
    finally { $client.Dispose() }
}

function Invoke-G2cRemoteDiagnosticSnapshot {
    if ($null -eq $script:remoteProcess -or -not $script:remoteProcessStarted -or
        -not $script:remoteSecretsSent -or $script:remoteProcess.HasExited -or $script:singBoxDiagnosticAttempted) { return }
    $script:singBoxDiagnosticAttempted = $true
    try {
        $script:remoteProcess.StandardInput.WriteLine('DIAGNOSTICS')
        $script:remoteProcess.StandardInput.Flush()
        $line = Get-G2cRemoteReadyLine -Process $script:remoteProcess -TimeoutSeconds 5
        $record = $line | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        $allowed = @('KEY_SHARE_OR_MLKEM_MISMATCH', 'REALITY_AUTH_OR_VERIFICATION_FAILED',
                     'SNI_OR_CERT_MISMATCH', 'VLESS_OR_VISION_REJECTED',
                     'HANDSHAKE_TARGET_UNREACHABLE', 'CONNECTION_RESET_OR_EOF',
                     'TIMEOUT', 'UNKNOWN_TLS_HANDSHAKE_FAILURE', 'NONE_OBSERVED')
        if ($record['status'] -eq 'diagnostics' -and $record['sing_box_error_class'] -in $allowed) {
            $script:singBoxErrorClass = [string]$record['sing_box_error_class']
            $script:singBoxDiagnosticReadback = $true
        }
    }
    catch { $script:singBoxErrorClass = 'UNKNOWN_TLS_HANDSHAKE_FAILURE' }
}

function Stop-G2cMihomoExact {
    if ($null -eq $script:mihomoProcess) { $script:mihomoStopped = $true; return }
    try {
        if (-not $script:mihomoProcess.HasExited) {
            $live = Get-Process -Id $script:mihomoProcess.Id -ErrorAction Stop
            Assert-G2c ($live.Path -eq $script:mihomoPath) 'MIHOMO_PROCESS_IDENTITY_CHANGED'
            $script:mihomoProcess.Kill()
            if (-not $script:mihomoProcess.WaitForExit(10000)) { throw 'MIHOMO_PROCESS_STOP_TIMEOUT' }
        }
        Assert-G2c $script:mihomoProcess.HasExited 'MIHOMO_PROCESS_REMAINS'
        if ($null -ne $script:mihomoCapture) {
            $stdoutText = $script:mihomoCapture.StdoutCapture.GetAwaiter().GetResult()
            $stderrText = $script:mihomoCapture.StderrCapture.GetAwaiter().GetResult()
            $combinedText = [string]$stdoutText + "`n" + [string]$stderrText
            $script:mihomoErrorClass = Get-G2cSanitizedErrorClass -Text $combinedText -ExitCode $script:mihomoProcess.ExitCode -RequestSucceeded:($script:requestStarted -and $script:curlExit -eq 0 -and $null -ne $script:curlAppConnect -and [double]$script:curlAppConnect -gt 0)
            $stdoutText = $null
            $stderrText = $null
            $combinedText = $null
            $script:mihomoCapture = $null
        }
        $script:mihomoStopped = $true
    }
    catch {
        $script:mihomoStopped = $false
        $script:cleanupFailures.Add('MIHOMO_STOP_FAILED')
    }
}

function Stop-G2cCurlExact {
    if ($null -eq $script:curlProcess -or -not $script:curlProcessStarted) { return }
    try {
        if (-not $script:curlProcess.HasExited) {
            $script:curlProcess.Kill()
            if (-not $script:curlProcess.WaitForExit(5000)) { throw 'CURL_PROCESS_STOP_TIMEOUT' }
        }
        Assert-G2c $script:curlProcess.HasExited 'CURL_PROCESS_REMAINS'
    }
    catch { $script:cleanupFailures.Add('CURL_PROCESS_STOP_FAILED') }
    if ($null -ne $script:curlStderrTask -and $script:curlStderrTask.IsCompleted) {
        try {
            $curlErrorText = $script:curlStderrTask.GetAwaiter().GetResult()
            $exit = if ($null -ne $script:curlProcess -and $script:curlProcess.HasExited) { $script:curlProcess.ExitCode } else { -1 }
            $script:curlErrorClass = Get-G2cSanitizedErrorClass -Text $curlErrorText -ExitCode $exit -RequestSucceeded:($script:requestStarted -and $exit -eq 0 -and $null -ne $script:curlAppConnect -and [double]$script:curlAppConnect -gt 0)
            $curlErrorText = $null
            $script:curlStderrTask = $null
        }
        catch { $script:curlErrorClass = 'UNKNOWN_TLS_HANDSHAKE_FAILURE' }
    }
}

function Remove-G2cLocalRuntimeExact {
    try {
        if ($script:runtimeConfigCreated -and (Test-Path -LiteralPath $script:runtimeConfigPath)) {
            [IO.File]::Delete($script:runtimeConfigPath)
        }
        if ($script:runtimeDirectoryCreated -and (Test-Path -LiteralPath $script:runtimeDirectory)) {
            $item = Get-Item -LiteralPath $script:runtimeDirectory -Force -ErrorAction Stop
            Assert-G2c (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'CLIENT_RUNTIME_CLEANUP_REPARSE_POINT'
            [IO.Directory]::Delete($script:runtimeDirectory, $true)
        }
        if (Test-Path -LiteralPath $script:runtimeDirectory) { throw 'CLIENT_RUNTIME_PATH_REMAINS' }
    }
    catch {
        $script:cleanupFailures.Add('CLIENT_RUNTIME_DELETE_FAILED')
    }
}

function Invoke-G2cRemoteSessionCleanup {
    if ($null -eq $script:remoteProcess -or -not $script:remoteProcessStarted) { return }
    try {
        if (-not $script:remoteProcess.HasExited) {
            if ($script:remoteSecretsSent) {
                $cleanupBytes = [Text.Encoding]::ASCII.GetBytes("CLEANUP`n")
                $script:remoteProcess.StandardInput.BaseStream.Write($cleanupBytes, 0, $cleanupBytes.Length)
                $script:remoteProcess.StandardInput.BaseStream.Flush()
                [Array]::Clear($cleanupBytes, 0, $cleanupBytes.Length)
            }
            $script:remoteProcess.StandardInput.Close()
            $cleanupWaitMs = if ($script:remoteAssetReady) { 15000 } else { 75000 }
            if (-not $script:remoteProcess.WaitForExit($cleanupWaitMs)) {
                $script:remoteProcess.Kill()
                [void]$script:remoteProcess.WaitForExit(5000)
            }
        }
        if (-not $script:remoteProcess.HasExited) { throw 'SSH_PROCESS_REMAINS' }
        $remainingStdout = $script:remoteProcess.StandardOutput.ReadToEnd()
        $remainingStderr = $script:remoteProcess.StandardError.ReadToEnd()
        $null = $remainingStderr
        foreach ($line in ($remainingStdout -split "\r?\n" | Where-Object { $_.StartsWith('{') })) {
            try {
                $record = $line | ConvertFrom-Json -AsHashtable -ErrorAction Stop
                if ($record['status'] -in @('cleaned', 'cleanup_failed')) { $script:remoteCleanupRecord = $record }
            }
            catch { }
        }
        if ($null -ne $script:remoteCleanupRecord -and $script:remoteCleanupRecord['status'] -eq 'cleaned' -and
            $script:remoteCleanupRecord['server_process_stopped'] -and $script:remoteCleanupRecord['tcp14443_absent'] -and
            $script:remoteCleanupRecord['tcp443_free'] -and $script:remoteCleanupRecord['runtime_absent'] -and
            $script:remoteCleanupRecord['workspace_absent'] -and @($script:remoteCleanupRecord['cleanup_failures']).Count -eq 0) {
            return
        }
        $script:cleanupFailures.Add('REMOTE_SUPERVISOR_CLEANUP_NOT_PROVEN')
    }
    catch {
        $script:cleanupFailures.Add('REMOTE_SESSION_CLEANUP_FAILED')
    }
}

function Invoke-G2cRemoteEmergencyCleanup {
    $source = Get-G2cRemoteSupervisorSource
    $command = New-G2cRemotePythonCommand -Source $source -Mode 'cleanup'
    try {
        $psi = New-G2cSshStartInfo -RemoteCommand $command
        $process = [Diagnostics.Process]::new()
        $process.StartInfo = $psi
        [void]$process.Start()
        $process.StandardInput.Close()
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        $null = $stderr
        $record = $null
        foreach ($line in ($stdout -split "\r?\n" | Where-Object { $_.StartsWith('{') })) {
            try { $record = $line | ConvertFrom-Json -AsHashtable -ErrorAction Stop } catch { }
        }
        if ($process.ExitCode -eq 0 -and $null -ne $record -and $record['status'] -eq 'cleaned') { return $true }
    }
    catch { }
    return $false
}

function Get-G2cPostCleanupRemoteProbeText {
    param([Parameter(Mandatory = $true)][string]$RunId)
    return @"
set -eu
if systemctl is-active --quiet wg-quick@wg0; then echo WG_SERVICE=active; else echo WG_SERVICE=inactive; fi
if systemctl is-active --quiet hysteria2-vpn-network-optimization.service; then echo HY2_SERVICE=active; else echo HY2_SERVICE=inactive; fi
ss -H -lun | awk '`$4 ~ /:51820$/ {a++} `$4 ~ /:8443$/ {b++} END {printf "UDP_51820_LISTENERS=%d\nUDP_8443_LISTENERS=%d\n", a+0, b+0}'
ss -H -ltn | awk '`$4 ~ /:14443$/ {a++} `$4 ~ /:443$/ {b++} END {printf "TCP_14443_LISTENERS=%d\nTCP_443_LISTENERS=%d\n", a+0, b+0}'
if command -v pgrep >/dev/null 2>&1; then echo SING_BOX_PROCESS_COUNT=`$(pgrep -cx sing-box 2>/dev/null || true); else echo SING_BOX_PROCESS_COUNT=`$(ps -eo comm= | awk '`$1 == "sing-box" {n++} END {print n+0}'); fi
if [ -e '/run/vpn-network-optimization-g2c-$RunId' ] || [ -L '/run/vpn-network-optimization-g2c-$RunId' ] || [ -e '/tmp/vpn-network-optimization-g2c-$RunId' ] || [ -L '/tmp/vpn-network-optimization-g2c-$RunId' ]; then echo G2C_RUN_PATHS_ABSENT=NO; else echo G2C_RUN_PATHS_ABSENT=YES; fi
printf 'REMOTE_DEFAULT_ROUTE=%s\n' "`$(ip -4 route show default | head -n 1 | sed 's/[[:space:]]*$//')"
printf 'REMOTE_WG_ROUTE=%s\n' "`$(ip -4 route show dev wg0 | head -n 1 | sed 's/[[:space:]]*$//')"
printf 'MEM_AVAILABLE_KIB=%s\n' "`$(awk '/MemAvailable:/ {print `$2}' /proc/meminfo)"
printf 'TMP_FREE_KIB=%s\n' "`$(df -Pk /tmp | awk 'NR==2 {print `$4}')"
"@
}

function Resolve-G2cDiagnosticClassification {
    if ($script:requestCount -ne 1) { return 'UNKNOWN_AFTER_DIAGNOSTIC' }
    if ($script:curlExit -eq 0 -and $null -ne $script:curlAppConnect -and [double]$script:curlAppConnect -gt 0) {
        return 'NO_FAILURE_REPRODUCED'
    }
    $candidates = [Collections.Generic.List[string]]::new()
    if ($null -ne $script:preRemoteMarkers -and $script:preRemoteMarkers['HANDSHAKE_TARGET_ERROR_CLASS'] -notin @('NONE_OBSERVED', 'UNKNOWN_TLS_HANDSHAKE_FAILURE')) {
        $candidates.Add([string]$script:preRemoteMarkers['HANDSHAKE_TARGET_ERROR_CLASS'])
    }
    foreach ($candidate in @($script:curlErrorClass, $script:mihomoErrorClass, $script:singBoxErrorClass)) {
        if ($candidate -notin @('NONE_OBSERVED', 'NOT_CAPTURED', 'UNKNOWN_TLS_HANDSHAKE_FAILURE')) { $candidates.Add([string]$candidate) }
    }
    $unique = @($candidates | Sort-Object -Unique)
    if ($unique.Count -eq 1) { return $unique[0] }
    return 'UNKNOWN_AFTER_DIAGNOSTIC'
}

try {
    $script:phase = 'LOCAL_PREFLIGHT'
    Assert-G2c (Test-Path -LiteralPath $script:mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $script:localBefore = Get-G2cLocalSnapshot
    Assert-G2cLocalPreflight -Snapshot $script:localBefore
    $script:curlPath = (Get-Command curl.exe -ErrorAction Stop).Source
    $script:localProxyPort = 17990

    $script:phase = 'REMOTE_READONLY_PREFLIGHT'
    $probeText = Get-G2cRemoteProbeText -RunId $script:runId
    $remoteProbeOutput = Invoke-G2cReadOnlyRemoteProbe -ProbeText $probeText
    $script:sshHostKeyVerified = $true
    $remoteMarkers = ConvertFrom-G2cMarkerText -Text $remoteProbeOutput
    $script:preRemoteMarkers = $remoteMarkers
    $script:handshakeTargetTcp = [string]$remoteMarkers['HANDSHAKE_TARGET_TCP']
    $script:handshakeTargetTls = [string]$remoteMarkers['HANDSHAKE_TARGET_TLS']
    $script:handshakeTargetTlsVersion = [string]$remoteMarkers['HANDSHAKE_TARGET_TLS_VERSION']
    Assert-G2cRemotePreflight -Markers $remoteMarkers
    $script:remotePreflightPassed = $true
    Write-Output 'G2C_CANARY_PREFLIGHT=PASS'
    Write-Output 'SSH_HOST_KEY_TRUST=PASS'

    $script:phase = 'REMOTE_PINNED_ASSET_AND_KEYPAIR'
    $remoteSource = Get-G2cRemoteSupervisorSource
    $remoteCommand = New-G2cRemotePythonCommand -Source $remoteSource -Mode 'run'
    $remotePsi = New-G2cSshStartInfo -RemoteCommand $remoteCommand
    $script:remoteProcess = [Diagnostics.Process]::new()
    $script:remoteProcess.StartInfo = $remotePsi
    [void]$script:remoteProcess.Start()
    $script:remoteProcessStarted = $true
    $assetLine = Get-G2cRemoteReadyLine -Process $script:remoteProcess -TimeoutSeconds 90
    $script:remoteAssetReady = $true
    Assert-G2c (-not [string]::IsNullOrWhiteSpace($assetLine)) 'REMOTE_ASSET_READY_MISSING'
    $script:remoteAssetRecord = $assetLine | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    $assetFailureCode = [string]$script:remoteAssetRecord['phase']
    if ([string]::IsNullOrWhiteSpace($assetFailureCode)) { $assetFailureCode = 'REMOTE_ASSET_READY_INVALID' }
    Assert-G2c ($script:remoteAssetRecord['status'] -eq 'asset_ready') $assetFailureCode
    Assert-G2c ($script:remoteAssetRecord['sing_box_version'] -eq $script:singBoxVersionExpected) 'SING_BOX_VERSION_MISMATCH'
    Assert-G2c ($script:remoteAssetRecord['asset_sha256'] -eq 'PASS') 'SING_BOX_ASSET_SHA256_NOT_PROVEN'
    $script:singBoxVersion = [string]$script:remoteAssetRecord['sing_box_version']
    $script:singBoxAssetVerified = $true

    $publicKey = [string]$script:remoteAssetRecord['public_key']
    Assert-G2c ($publicKey -match '^[A-Za-z0-9_-]{43}$') 'REALITY_PUBLIC_KEY_FORMAT_INVALID'
    $uuid = [guid]::NewGuid().ToString()
    $shortBytes = [byte[]]::new(8)
    [Security.Cryptography.RandomNumberGenerator]::Fill($shortBytes)
    $shortId = [Convert]::ToHexString($shortBytes).ToLowerInvariant()
    [Array]::Clear($shortBytes, 0, $shortBytes.Length)

    $script:phase = 'CLIENT_SECRET_RUNTIME'
    New-G2cClientRuntime -Uuid $uuid -PublicKey $publicKey -ShortId $shortId
    Write-Output 'CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS'

    $script:phase = 'MIHOMO_CONFIG_CHECK'
    $configCheck = Start-G2cSuppressedProcess -FilePath $script:mihomoPath -ArgumentList @('-t', '-d', $script:runtimeDirectory, '-f', $script:runtimeConfigPath)
    if (-not $configCheck.Process.WaitForExit(20000)) {
        $configCheck.Process.Kill()
        [void]$configCheck.Process.WaitForExit(5000)
        throw 'MIHOMO_CONFIG_CHECK_TIMEOUT'
    }
    $configCheckStdout = $configCheck.StdoutCapture.GetAwaiter().GetResult()
    $configCheckStderr = $configCheck.StderrCapture.GetAwaiter().GetResult()
    Assert-G2c ($configCheck.Process.ExitCode -eq 0) 'MIHOMO_CONFIG_CHECK_FAILED'
    $configCheckStdout = $null
    $configCheckStderr = $null
    $script:mihomoConfigChecked = $true

    $script:phase = 'REMOTE_SERVER_CONFIG_AND_LISTENER'
    $payloadText = [ordered]@{ uuid = $uuid; short_id = $shortId } | ConvertTo-Json -Compress
    $payloadBytes = [Text.UTF8Encoding]::new($false).GetBytes($payloadText + "`n")
    try {
        $script:remoteProcess.StandardInput.BaseStream.Write($payloadBytes, 0, $payloadBytes.Length)
        $script:remoteProcess.StandardInput.BaseStream.Flush()
        $script:remoteSecretsSent = $true
    }
    finally {
        [Array]::Clear($payloadBytes, 0, $payloadBytes.Length)
        $payloadBytes = $null
        $payloadText = $null
        $uuid = $null
        $shortId = $null
    }
    $readyLine = Get-G2cRemoteReadyLine -Process $script:remoteProcess -TimeoutSeconds 20
    Assert-G2c (-not [string]::IsNullOrWhiteSpace($readyLine)) 'REMOTE_SERVER_READY_MISSING'
    $script:remoteStartRecord = $readyLine | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    $script:serverConfigChecked = $script:remoteStartRecord['server_config_check'] -eq 'PASS'
    $script:privateListenerVerified = $script:remoteStartRecord['private_listener'] -eq '10.66.21.1:14443'
    $script:publicListenerNegativeVerified = $script:remoteStartRecord['public_14443_listener'] -eq 'NO' -and
                                             $script:remoteStartRecord['public_tcp443_listener'] -eq 'NO'
    $serverReadyFailureCode = [string]$script:remoteStartRecord['phase']
    if ([string]::IsNullOrWhiteSpace($serverReadyFailureCode)) { $serverReadyFailureCode = 'REMOTE_SERVER_READY_INVALID' }
    Assert-G2c ($script:remoteStartRecord['status'] -eq 'ready') $serverReadyFailureCode
    Assert-G2c ($script:remoteStartRecord['server_config_check'] -eq 'PASS') 'SERVER_CONFIG_CHECK_NOT_PROVEN'
    Assert-G2c ($script:remoteStartRecord['private_listener'] -eq '10.66.21.1:14443') 'PRIVATE_LISTENER_NOT_PROVEN'
    Assert-G2c ($script:remoteStartRecord['public_14443_listener'] -eq 'NO' -and
                $script:remoteStartRecord['public_tcp443_listener'] -eq 'NO') 'PUBLIC_LISTENER_NEGATIVE_CHECK_FAILED'
    $script:phase = 'PRIVATE_LISTENER_TCP_REACHABILITY'
    $script:privateListenerTcpReachable = Test-G2cPrivateListenerTcp
    Assert-G2c $script:privateListenerTcpReachable 'WINDOWS_PRIVATE_LISTENER_TCP_UNREACHABLE'
    $script:phase = 'MIHOMO_START_AND_PROXY_READY'
    $script:mihomoCapture = Start-G2cSuppressedProcess -FilePath $script:mihomoPath -ArgumentList @('-d', $script:runtimeDirectory, '-f', $script:runtimeConfigPath)
    $script:mihomoProcess = $script:mihomoCapture.Process
    $localReady = $false
    $deadline = [DateTime]::UtcNow.AddSeconds(10)
    while ([DateTime]::UtcNow -lt $deadline) {
        if ($script:mihomoProcess.HasExited) { throw 'MIHOMO_EXITED_BEFORE_PROXY_READY' }
        $listeners = @(Get-NetTCPConnection -LocalPort $script:localProxyPort -State Listen -ErrorAction SilentlyContinue)
        $udpListeners = @(Get-NetUDPEndpoint -LocalPort $script:localProxyPort -ErrorAction SilentlyContinue)
        if ($listeners.Count -gt 0) {
            Assert-G2c ($listeners.Count -eq 1 -and $listeners[0].LocalAddress -eq '127.0.0.1' -and
                        [int]$listeners[0].OwningProcess -eq $script:mihomoProcess.Id) 'MIHOMO_PROXY_BINDING_INVALID'
            Assert-G2c ($udpListeners.Count -eq 0) 'MIHOMO_UDP_LISTENER_UNEXPECTED'
            $localReady = $true
            break
        }
        Start-Sleep -Milliseconds 200
    }
    Assert-G2c $localReady 'MIHOMO_TEST_PROXY_NOT_READY'
    $script:mihomoProxyReady = $true

    $script:phase = 'ONE_REALITY_CANARY_REQUEST'
    $curlArgs = @(
        '--ipv4', '--http1.1',
        '--proxy', "http://127.0.0.1:$($script:localProxyPort)",
        '--connect-timeout', '10', '--max-time', '30', '--silent', '--show-error',
        '--output', 'NUL',
        '--write-out', '%{http_code}|%{time_total}|%{time_connect}|%{time_appconnect}',
        $script:apiEndpoint
    )
    $curlPsi = [Diagnostics.ProcessStartInfo]::new()
    $curlPsi.FileName = $script:curlPath
    $curlPsi.UseShellExecute = $false
    $curlPsi.RedirectStandardOutput = $true
    $curlPsi.RedirectStandardError = $true
    foreach ($curlArg in $curlArgs) { [void]$curlPsi.ArgumentList.Add($curlArg) }
    $script:curlProcess = [Diagnostics.Process]::new()
    $script:curlProcess.StartInfo = $curlPsi
    [void]$script:curlProcess.Start()
    $script:curlProcessStarted = $true
    $script:requestStarted = $true
    $script:requestCount = 1
    $script:realityProxyUsed = $true
    $script:curlStdoutTask = $script:curlProcess.StandardOutput.ReadToEndAsync()
    $script:curlStderrTask = $script:curlProcess.StandardError.ReadToEndAsync()
    if (-not $script:curlProcess.WaitForExit(35000)) {
        $script:curlProcess.Kill()
        [void]$script:curlProcess.WaitForExit(5000)
        throw 'REALITY_CANARY_CURL_TIMEOUT'
    }
    $curlText = $script:curlStdoutTask.GetAwaiter().GetResult().Trim()
    $script:curlExit = [int]$script:curlProcess.ExitCode
    if ($curlText -match '^(?<status>\d{3})\|(?<total>[0-9.]+)\|(?<connect>[0-9.]+)\|(?<appconnect>[0-9.]+)$') {
        $script:httpStatus = [int]$Matches.status
        $script:curlTotal = $Matches.total
        $script:curlConnect = $Matches.connect
        $script:curlAppConnect = $Matches.appconnect
    }
    $curlText = $null
    $script:curlStdoutTask = $null
    Stop-G2cCurlExact
    Invoke-G2cRemoteDiagnosticSnapshot
    Assert-G2c ($script:curlExit -eq 0 -and $script:httpStatus -eq 401) 'REALITY_CANARY_HTTP_RESULT_INVALID'
    $script:canaryPass = $true
}
catch {
    $script:failureType = $_.Exception.GetType().Name
    if ($_.Exception.Message -match '^[A-Z][A-Z0-9_]+$') { $script:failureCode = $_.Exception.Message }
    else { $script:failureCode = $script:failureType }
}
finally {
    Stop-G2cCurlExact
    if ($script:requestStarted -and -not $script:singBoxDiagnosticReadback) { Invoke-G2cRemoteDiagnosticSnapshot }
    Stop-G2cMihomoExact
    Remove-G2cLocalRuntimeExact
    Invoke-G2cRemoteSessionCleanup

    if ($script:cleanupFailures.Count -gt 0) {
        $emergencyOk = Invoke-G2cRemoteEmergencyCleanup
        if ($emergencyOk) { $script:cleanupFailures.Remove('REMOTE_SUPERVISOR_CLEANUP_NOT_PROVEN') | Out-Null }
    }

    if ($null -ne $script:localBefore) {
      try {
        $script:localAfter = Get-G2cLocalSnapshot
        if ($script:localAfter.WireGuardManager -ne 'Running' -or $script:localAfter.WireGuardTunnel -ne 'Running' -or
            $script:localAfter.WireGuardAdapterStatus -ne 'Up' -or $script:localAfter.WireGuardIfIndex -ne 13 -or
            @($script:localAfter.RouteIfIndexes | Where-Object { $_ -ne 13 }).Count -gt 0 -or
            $script:localAfter.ProxyEnable -ne $script:localBefore.ProxyEnable -or
            $script:localAfter.ProxyServer -cne $script:localBefore.ProxyServer -or
            $script:localAfter.ProxyOverride -cne $script:localBefore.ProxyOverride -or
            $script:localAfter.AutoConfigURL -cne $script:localBefore.AutoConfigURL -or
            $script:localAfter.WinHttpDirect -ne $script:localBefore.WinHttpDirect -or
            ($script:localAfter.TunSignature -join ';') -ne ($script:localBefore.TunSignature -join ';') -or
            $script:localAfter.MihomoProcessCount -ne 0 -or $script:localAfter.LocalTcpProxyCount -ne 0 -or
            $script:localAfter.LocalUdpProxyCount -ne 0 -or (Test-Path -LiteralPath $script:runtimeDirectory)) {
            $script:cleanupFailures.Add('LOCAL_POSTCLEANUP_STATE_MISMATCH')
        }
        else { $script:localPostcheckPass = $true }
      }
      catch { $script:cleanupFailures.Add('LOCAL_POSTCLEANUP_READBACK_FAILED') }
    }

    if ($script:remotePreflightPassed) {
      try {
        $postText = Get-G2cPostCleanupRemoteProbeText -RunId $script:runId
        $postMarkers = ConvertFrom-G2cMarkerText -Text (Invoke-G2cReadOnlyRemoteProbe -ProbeText $postText)
        if ($postMarkers['WG_SERVICE'] -ne 'active' -or $postMarkers['HY2_SERVICE'] -ne 'active' -or
            [int]$postMarkers['UDP_51820_LISTENERS'] -lt 1 -or [int]$postMarkers['UDP_8443_LISTENERS'] -lt 1 -or
            [int]$postMarkers['TCP_14443_LISTENERS'] -ne 0 -or [int]$postMarkers['TCP_443_LISTENERS'] -ne 0 -or
            $postMarkers['SING_BOX_PROCESS_COUNT'] -ne '0' -or $postMarkers['G2C_RUN_PATHS_ABSENT'] -ne 'YES' -or
            $postMarkers['REMOTE_DEFAULT_ROUTE'] -ne $script:preRemoteMarkers['REMOTE_DEFAULT_ROUTE'] -or
            $postMarkers['REMOTE_WG_ROUTE'] -ne $script:preRemoteMarkers['REMOTE_WG_ROUTE']) {
            $script:cleanupFailures.Add('REMOTE_POSTCLEANUP_STATE_MISMATCH')
        }
        else { $script:remotePostcheckPass = $true }
      }
      catch { $script:cleanupFailures.Add('REMOTE_POSTCLEANUP_READBACK_FAILED') }
    }

    $publicKey = $null
    $uuid = $null
    $shortId = $null
    $yaml = $null
    $payloadText = $null
    $curlText = $null
    if ($null -ne $script:curlProcess) { $script:curlProcess.Dispose() }
    if ($null -ne $script:remoteProcess) { $script:remoteProcess.Dispose() }
    if ($null -ne $script:mihomoProcess) { $script:mihomoProcess.Dispose() }
}

Write-Output "WINDOWS_POWERSHELL=$(if ($null -ne $script:localBefore) { $script:localBefore.PowerShell } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_INTEGRITY_RID=$(if ($null -ne $script:localBefore) { $script:localBefore.IntegrityRid } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_ADMINISTRATOR_TOKEN=$(if ($null -ne $script:localBefore) { $script:localBefore.Administrator } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_WG_ADAPTER=SFO2-A|ifIndex=$(if ($null -ne $script:localBefore) { $script:localBefore.WireGuardIfIndex } else { 'UNAVAILABLE' })|status=$(if ($null -ne $script:localBefore) { $script:localBefore.WireGuardAdapterStatus } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_CONTROL_ROUTE_IFINDEX=$(if ($null -ne $script:localBefore) { $script:localBefore.RouteIfIndexes -join ',' } else { 'UNAVAILABLE' })"
Write-Output "SYSTEM_PROXY_ENABLE=$(if ($null -ne $script:localBefore) { $script:localBefore.ProxyEnable } else { 'UNAVAILABLE' })"
Write-Output "WINHTTP_DIRECT=$(if ($null -ne $script:localBefore) { $script:localBefore.WinHttpDirect } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_TUN_ADAPTER_COUNT=$(if ($null -ne $script:localBefore) { $script:localBefore.TunSignature.Count } else { 'UNAVAILABLE' })"
Write-Output "MIHOMO_VERSION=$(if ($null -ne $script:localBefore) { ($script:localBefore.MihomoVersionText -split "`n")[0].Trim() } else { 'UNAVAILABLE' })"
Write-Output 'SSH_CONTROL_TARGET=10.66.21.1'
Write-Output "SSH_HOST_KEY_TRUST=$(if ($script:sshHostKeyVerified) { 'PASS' } else { 'UNVERIFIED' })"
Write-Output "TARGET_HOSTNAME=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['REMOTE_HOSTNAME'] } else { 'UNAVAILABLE' })"
Write-Output "TARGET_OS=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['REMOTE_OS'] } else { 'UNAVAILABLE' })"
Write-Output "TARGET_KERNEL=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['REMOTE_KERNEL'] } else { 'UNAVAILABLE' })"
Write-Output "WG_UDP51820_LISTENERS=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['UDP_51820_LISTENERS'] } else { 'UNAVAILABLE' })"
Write-Output "HY2_UDP8443_LISTENERS=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['UDP_8443_LISTENERS'] } else { 'UNAVAILABLE' })"
Write-Output "REMOTE_DEFAULT_ROUTE=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['REMOTE_DEFAULT_ROUTE'] } else { 'UNAVAILABLE' })"
Write-Output "REMOTE_WG_ROUTE=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['REMOTE_WG_ROUTE'] } else { 'UNAVAILABLE' })"
Write-Output "SING_BOX_VERSION=$($script:singBoxVersion)"
Write-Output "SING_BOX_ASSET_SHA256=$(if ($script:singBoxAssetVerified) { 'PASS' } else { 'NO' })"
Write-Output "SERVER_CONFIG_CHECK=$(if ($script:serverConfigChecked) { 'PASS' } else { 'NO' })"
Write-Output "PRIVATE_LISTENER_10_66_21_1_14443=$(if ($script:privateListenerVerified) { 'YES' } else { 'NO' })"
Write-Output "PUBLIC_14443_LISTENER=$(if ($script:publicListenerNegativeVerified) { 'NO' } else { 'UNVERIFIED' })"
Write-Output "PUBLIC_TCP443_UNCHANGED_FREE=$(if ($script:publicListenerNegativeVerified) { 'YES' } else { 'UNVERIFIED' })"
Write-Output "MIHOMO_CONFIG_CHECK=$(if ($script:mihomoConfigChecked) { 'PASS' } else { 'NO' })"
Write-Output "MIHOMO_TEST_PROXY_READY=$(if ($script:mihomoProxyReady) { 'YES' } else { 'NO' })"
Write-Output "REALITY_CANARY_PROXY_USED=$(if ($script:realityProxyUsed) { 'YES' } else { 'NO' })"
Write-Output "REALITY_CANARY_CURL_EXIT=$($script:curlExit)"
Write-Output "REALITY_CANARY_HTTP_STATUS=$($script:httpStatus)"
Write-Output "REALITY_CANARY_TIME_TOTAL=$($script:curlTotal)"
Write-Output "REALITY_CANARY_TIME_CONNECT=$($script:curlConnect)"
Write-Output "REALITY_CANARY_TIME_APPCONNECT=$($script:curlAppConnect)"
Write-Output "ONE_PROXIED_REQUEST_COUNT=$($script:requestCount)"
Write-Output "HANDSHAKE_TARGET_TCP=$($script:handshakeTargetTcp)"
Write-Output "HANDSHAKE_TARGET_TLS=$($script:handshakeTargetTls)"
Write-Output "HANDSHAKE_TARGET_TLS_VERSION=$($script:handshakeTargetTlsVersion)"
Write-Output "HANDSHAKE_TARGET_ERROR_CLASS=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['HANDSHAKE_TARGET_ERROR_CLASS'] } else { 'UNAVAILABLE' })"
Write-Output "WINDOWS_PRIVATE_LISTENER_TCP=$(if ($script:privateListenerTcpReachable) { 'PASS' } else { 'NO' })"
Write-Output "CURL_ERROR_CLASS=$($script:curlErrorClass)"
Write-Output "MIHOMO_ERROR_CLASS=$($script:mihomoErrorClass)"
Write-Output "SING_BOX_ERROR_CLASS=$($script:singBoxErrorClass)"
$script:realityDiagnosticClassification = Resolve-G2cDiagnosticClassification
Write-Output "REALITY_DIAGNOSTIC_CLASSIFICATION=$($script:realityDiagnosticClassification)"
Write-Output "TEST_MIHOMO_STOPPED=$(if ($script:mihomoStopped) { 'YES' } else { 'NO' })"
Write-Output "CLIENT_SECRET_RUNTIME_DELETED=$(if (-not (Test-Path -LiteralPath $script:runtimeDirectory)) { 'YES' } else { 'NO' })"
Write-Output "REMOTE_CANARY_CLEANUP=$(if ($script:remotePostcheckPass) { 'PASS' } elseif (-not $script:remotePreflightPassed) { 'NOT_REACHED' } else { 'FAIL' })"
Write-Output "LOCAL_BASELINE_RESTORED=$(if ($script:localPostcheckPass) { 'YES' } else { 'UNVERIFIED' })"
Write-Output "WG_HY2_PRESERVED=$(if ($script:localPostcheckPass -and $script:remotePostcheckPass) { 'YES' } else { 'UNVERIFIED' })"
Write-Output "VPS_MEM_AVAILABLE_KIB=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['MEM_AVAILABLE_KIB'] } else { 'UNAVAILABLE' })"
Write-Output "VPS_TMP_FREE_KIB=$(if ($null -ne $script:preRemoteMarkers) { $script:preRemoteMarkers['TMP_FREE_KIB'] } else { 'UNAVAILABLE' })"
Write-Output "PUBLIC_TCP443_LISTENER=$(if ($script:remotePostcheckPass) { 'ABSENT' } else { 'UNVERIFIED' })"
Write-Output 'FIREWALL_OR_ROUTE_MUTATION=NO'
Write-Output "SYSTEM_PROXY_UNCHANGED=$(if ($script:localPostcheckPass) { 'YES' } else { 'UNVERIFIED' })"
Write-Output "TUN_UNCHANGED=$(if ($script:localPostcheckPass) { 'YES' } else { 'UNVERIFIED' })"
Write-Output 'CURRENT_TRAFFIC_SWITCHED=NO'
Write-Output 'BENCHMARK_STARTED=NO'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'SECRET_VALUES_COMMITTED=0'

if ($script:requestCount -eq 1 -and $script:cleanupFailures.Count -eq 0 -and
    $script:realityDiagnosticClassification -ne 'UNKNOWN_AFTER_DIAGNOSTIC') {
    Write-Output 'G2C_REALITY_DIAGNOSTIC_RESULT=PASS_CANDIDATE_DIAGNOSTIC'
    exit 0
}

Write-Output "FAILED_PHASE=$($script:phase)"
Write-Output "FAILURE_CODE=$($script:failureCode)"
Write-Output "FAILURE_TYPE=$($script:failureType)"
Write-Output ('CLEANUP_FAILURES=' + $(if ($script:cleanupFailures.Count -gt 0) { $script:cleanupFailures -join ',' } else { 'NONE' }))
Write-Output 'G2C_REALITY_DIAGNOSTIC_RESULT=RETURN_G2C_REALITY_DIAGNOSTIC_INCONCLUSIVE'
exit 1
