[CmdletBinding()]
param(
    [string]$Target = '10.66.21.1',
    [string]$IdentityFile = (Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'),
    [string]$KnownHostsFile = (Join-Path $env:USERPROFILE '.ssh\known_hosts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

function Assert-Preflight {
    param(
        [Parameter(Mandatory=$true)][bool]$Condition,
        [Parameter(Mandatory=$true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$admin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Assert-Preflight $admin 'ADMINISTRATOR_ELEVATION_REQUIRED'
Write-Output 'WINDOWS_ADMINISTRATOR=YES'
Write-Output "POWERSHELL_VERSION=$($PSVersionTable.PSVersion)"

Assert-Preflight (Test-Path -LiteralPath $IdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_MISSING'
Assert-Preflight (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_FILE_MISSING'
$sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
Write-Output 'SSH_LOCAL_FILES=PASS'

$wgManager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
$wgTunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
$wgAdapter = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
Assert-Preflight ($wgManager.Status -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
Assert-Preflight ($wgTunnel.Status -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
Assert-Preflight ($wgAdapter.Status -eq 'Up') 'WIREGUARD_ADAPTER_NOT_UP'
Write-Output 'WINDOWS_WIREGUARD_BASELINE=PASS'

$remote = @'
set -eu

echo "SSH_CONNECTION_OK=YES"
echo "REMOTE_USER=$(id -un)"
echo "REMOTE_UID=$(id -u)"
echo "REMOTE_HOSTNAME=$(hostname)"
if [ -r /etc/os-release ]; then
  . /etc/os-release
  echo "REMOTE_OS=${PRETTY_NAME:-UNKNOWN}"
else
  echo "REMOTE_OS=UNKNOWN"
fi
echo "REMOTE_KERNEL=$(uname -r)"
echo "REMOTE_ARCH=$(uname -m)"

if ip link show wg0 >/dev/null 2>&1; then
  echo "WG0_PRESENT=YES"
else
  echo "WG0_PRESENT=NO"
fi

if systemctl is-active --quiet wg-quick@wg0.service 2>/dev/null; then
  echo "WG_SERVICE_ACTIVE=YES"
else
  echo "WG_SERVICE_ACTIVE=NO"
fi

if ss -H -lunp 2>/dev/null | awk '$5 ~ /:51820$/ {found=1} END{exit !found}'; then
  echo "UDP_51820_LISTENER=YES"
else
  echo "UDP_51820_LISTENER=NO"
fi

if systemctl is-active --quiet hysteria2-vpn-network-optimization.service 2>/dev/null; then
  echo "HY2_SERVICE_ACTIVE=YES"
else
  echo "HY2_SERVICE_ACTIVE=NO"
fi

if ss -H -lunp 2>/dev/null | awk '$5 ~ /:8443$/ {found=1} END{exit !found}'; then
  echo "UDP_8443_LISTENER=YES"
else
  echo "UDP_8443_LISTENER=NO"
fi

TCP443_LINES="$(ss -H -ltnp 2>/dev/null | awk '$4 ~ /:443$/ {print}')"
if [ -n "$TCP443_LINES" ]; then
  echo "TCP_443_FREE=NO"
  echo "$TCP443_LINES" | wc -l | awk '{print "TCP_443_LISTENER_COUNT="$1}'
  echo "$TCP443_LINES" | sed -n 's/.*users:(("\([^"]*\)".*/\1/p' | sort -u | paste -sd, - | awk '{print "TCP_443_OWNER_NAMES="$0}'
else
  echo "TCP_443_FREE=YES"
  echo "TCP_443_LISTENER_COUNT=0"
  echo "TCP_443_OWNER_NAMES=NONE"
fi

if command -v sing-box >/dev/null 2>&1; then
  echo "SING_BOX_PRESENT=YES"
  sing-box version 2>/dev/null | head -n 1 | sed 's/^/SING_BOX_VERSION=/'
else
  echo "SING_BOX_PRESENT=NO"
  echo "SING_BOX_VERSION=NONE"
fi

if command -v xray >/dev/null 2>&1; then
  echo "XRAY_PRESENT=YES"
  xray version 2>/dev/null | head -n 1 | sed 's/^/XRAY_VERSION=/'
else
  echo "XRAY_PRESENT=NO"
  echo "XRAY_VERSION=NONE"
fi

if command -v mihomo >/dev/null 2>&1; then
  echo "MIHOMO_SERVER_PRESENT=YES"
  mihomo -v 2>/dev/null | head -n 1 | sed 's/^/MIHOMO_SERVER_VERSION=/'
else
  echo "MIHOMO_SERVER_PRESENT=NO"
  echo "MIHOMO_SERVER_VERSION=NONE"
fi

NTP_SYNC="$(timedatectl show -p NTPSynchronized --value 2>/dev/null || true)"
if [ -z "$NTP_SYNC" ]; then NTP_SYNC=UNKNOWN; fi
echo "NTP_SYNCHRONIZED=$NTP_SYNC"

awk '/MemAvailable:/ {print "MEM_AVAILABLE_KIB="$2}' /proc/meminfo
df -Pk / | awk 'NR==2 {print "ROOT_FREE_KIB="$4}'

if command -v ufw >/dev/null 2>&1; then
  UFW_LINE="$(ufw status 2>/dev/null | head -n1 || true)"
  case "$UFW_LINE" in
    *inactive*) echo "UFW_STATE=INACTIVE" ;;
    *active*) echo "UFW_STATE=ACTIVE" ;;
    *) echo "UFW_STATE=UNKNOWN" ;;
  esac
else
  echo "UFW_STATE=NOT_INSTALLED"
fi

if command -v nft >/dev/null 2>&1; then
  NFT443="$(nft list ruleset 2>/dev/null | grep -E 'tcp dport .*443|tcp dport 443' | wc -l || true)"
  echo "NFT_TCP443_RULE_COUNT=${NFT443:-0}"
else
  echo "NFT_TCP443_RULE_COUNT=UNKNOWN"
fi

if command -v iptables >/dev/null 2>&1; then
  IPT443="$(iptables -S 2>/dev/null | grep -- '--dport 443' | wc -l || true)"
  echo "IPTABLES_TCP443_RULE_COUNT=${IPT443:-0}"
else
  echo "IPTABLES_TCP443_RULE_COUNT=UNKNOWN"
fi

echo "READ_ONLY_MUTATION=NO"
echo "SECRET_VALUES_EMITTED=0"
'@

$psi = [Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $sshPath
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

foreach ($arg in @(
    '-T',
    '-i', $IdentityFile,
    '-o', 'BatchMode=yes',
    '-o', 'IdentitiesOnly=yes',
    '-o', 'StrictHostKeyChecking=yes',
    '-o', 'UpdateHostKeys=no',
    '-o', "UserKnownHostsFile=$KnownHostsFile",
    '-o', 'HostKeyAlias=24.199.118.137',
    '-o', 'HostName=10.66.21.1',
    '-o', 'CheckHostIP=no',
    '-o', 'ControlMaster=no',
    '-o', 'ControlPath=none',
    '-o', 'ForwardAgent=no',
    '-o', 'ConnectTimeout=15',
    '-o', 'ServerAliveInterval=10',
    '-o', 'ServerAliveCountMax=2',
    "root@$Target",
    'bash -s'
)) {
    [void]$psi.ArgumentList.Add($arg)
}

$p = [Diagnostics.Process]::new()
$p.StartInfo = $psi
[void]$p.Start()
$p.StandardInput.Write($remote)
$p.StandardInput.Close()
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()
$p.WaitForExit()

if (-not [string]::IsNullOrWhiteSpace($stdout)) {
    $stdout.TrimEnd() -split "\r?\n" | ForEach-Object { Write-Output $_ }
}
Write-Output "SSH_NATIVE_EXIT=$($p.ExitCode)"

if ($p.ExitCode -ne 0) {
    if (-not [string]::IsNullOrWhiteSpace($stderr)) {
        Write-Output "SSH_ERROR_CLASS=REMOTE_OR_TRANSPORT_FAILURE"
    }
    throw 'STRICT_SSH_PREFLIGHT_FAILED'
}

Assert-Preflight ($stdout -match '(?m)^SSH_CONNECTION_OK=YES$') 'SSH_SUCCESS_MARKER_MISSING'
Assert-Preflight ($stdout -match '(?m)^REMOTE_UID=0$') 'REMOTE_ROOT_IDENTITY_NOT_PROVEN'
Assert-Preflight ($stdout -match '(?m)^WG0_PRESENT=YES$') 'REMOTE_WG0_NOT_PRESENT'
Assert-Preflight ($stdout -match '(?m)^WG_SERVICE_ACTIVE=YES$') 'REMOTE_WG_SERVICE_NOT_ACTIVE'
Assert-Preflight ($stdout -match '(?m)^UDP_51820_LISTENER=YES$') 'REMOTE_WG_LISTENER_NOT_PRESENT'
Assert-Preflight ($stdout -match '(?m)^HY2_SERVICE_ACTIVE=YES$') 'REMOTE_HY2_SERVICE_NOT_ACTIVE'
Assert-Preflight ($stdout -match '(?m)^UDP_8443_LISTENER=YES$') 'REMOTE_HY2_LISTENER_NOT_PRESENT'
Assert-Preflight ($stdout -match '(?m)^READ_ONLY_MUTATION=NO$') 'READ_ONLY_MARKER_MISSING'
Assert-Preflight ($stdout -match '(?m)^SECRET_VALUES_EMITTED=0$') 'SECRET_SAFETY_MARKER_MISSING'

if ($stdout -match '(?m)^TCP_443_FREE=YES$') {
    Write-Output 'G2C_TCP443_PREFLIGHT=PASS'
}
else {
    Write-Output 'G2C_TCP443_PREFLIGHT=RETURN_PORT_443_OCCUPIED'
}

Write-Output 'OWNER_G2C_VLESS_REALITY_PREFLIGHT_RESULT=COMPLETE'
