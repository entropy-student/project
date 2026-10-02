[CmdletBinding()]
param(
    [string]$Target = '10.66.21.1',
    [string]$IdentityFile = (Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'),
    [string]$KnownHostsFile = (Join-Path $env:USERPROFILE '.ssh\known_hosts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

if ($PSVersionTable.PSVersion.ToString() -ne '7.6.6') {
    throw 'POWERSHELL_7_6_6_REQUIRED'
}
if (-not (Test-Path -LiteralPath $IdentityFile -PathType Leaf)) {
    throw 'SSH_IDENTITY_FILE_MISSING'
}
if (-not (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf)) {
    throw 'SSH_KNOWN_HOSTS_FILE_MISSING'
}

$sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source

$remote = @'
set -eu

UNIT='hysteria2-vpn-network-optimization.service'
CFG='/srv/apps/vpn-network-optimization/config/hysteria2-server.yaml'
BIN='/usr/local/lib/vpn-network-optimization/hysteria'
CERT='/srv/data/vpn-network-optimization/secrets/server.crt'
KEY='/srv/data/vpn-network-optimization/secrets/server.key'
EXPECTED_FP='8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18'
EXPECTED_SNI='hy2.sfo3-a.invalid'

echo "TARGET_HOSTNAME=$(hostname)"

active="$(systemctl is-active "$UNIT" 2>/dev/null || true)"
enabled="$(systemctl is-enabled "$UNIT" 2>/dev/null || true)"
exec_status="$(systemctl show "$UNIT" -p ExecMainStatus --value 2>/dev/null || true)"
nrestarts="$(systemctl show "$UNIT" -p NRestarts --value 2>/dev/null || true)"
svc_user="$(systemctl show "$UNIT" -p User --value 2>/dev/null || true)"
svc_group="$(systemctl show "$UNIT" -p Group --value 2>/dev/null || true)"

[ -n "$exec_status" ] || exec_status='UNKNOWN'
[ -n "$nrestarts" ] || nrestarts='UNKNOWN'
[ -n "$svc_user" ] || svc_user='UNKNOWN'
[ -n "$svc_group" ] || svc_group='UNKNOWN'

echo "HY2_SERVICE_ACTIVE=$active"
echo "HY2_SERVICE_ENABLED=$enabled"
echo "HY2_EXEC_MAIN_STATUS=$exec_status"
echo "HY2_NRESTARTS=$nrestarts"
echo "HY2_SERVICE_USER=$svc_user"
echo "HY2_SERVICE_GROUP=$svc_group"

listener_count="$(ss -H -lunp 2>/dev/null | awk '$5 ~ /:8443$/ {n++} END {print n+0}')"
listener_hysteria="$(ss -H -lunp 2>/dev/null | awk '$5 ~ /:8443$/ && /hysteria/ {n++} END {print n+0}')"
echo "HY2_UDP_8443_LISTENER_COUNT=$listener_count"
echo "HY2_UDP_8443_HYSTERIA_COUNT=$listener_hysteria"

if [ -x "$BIN" ]; then
  ver="$("$BIN" version 2>/dev/null | head -n 1 | tr -cd '[:alnum:].:_ -')"
  [ -n "$ver" ] || ver='UNKNOWN'
  echo "HY2_BINARY_PRESENT=YES"
  echo "HY2_BINARY_VERSION=$ver"
else
  echo "HY2_BINARY_PRESENT=NO"
  echo "HY2_BINARY_VERSION=UNKNOWN"
fi

python3 - "$CFG" "$CERT" "$KEY" "$EXPECTED_FP" "$EXPECTED_SNI" <<'PY'
import os, re, subprocess, sys

cfg, cert, key, expected_fp, expected_sni = sys.argv[1:]

def yn(v):
    return "YES" if v else "NO"

exists = os.path.isfile(cfg)
print("HY2_CONFIG_PRESENT=" + yn(exists))
if not exists:
    print("HY2_CONFIG_LISTEN_OK=NO")
    print("HY2_CONFIG_SNI_GUARD_STRICT=NO")
    print("HY2_CONFIG_AUTH_TYPE_PASSWORD=NO")
    print("HY2_CONFIG_AUTH_FORMAT_VALID=NO")
    print("HY2_CONFIG_CERT_PATH_OK=NO")
    print("HY2_CONFIG_KEY_PATH_OK=NO")
else:
    text = open(cfg, "r", encoding="utf-8").read()
    print("HY2_CONFIG_LISTEN_OK=" + yn(bool(re.search(r'(?m)^\s*listen:\s*["\']?:8443["\']?\s*$', text))))
    print("HY2_CONFIG_SNI_GUARD_STRICT=" + yn(bool(re.search(r'(?m)^\s*sniGuard:\s*strict\s*$', text))))
    print("HY2_CONFIG_AUTH_TYPE_PASSWORD=" + yn(bool(re.search(r'(?m)^\s*type:\s*password\s*$', text))))
    pw = re.search(r'(?m)^\s*password:\s*["\']?([0-9a-f]{64})["\']?\s*$', text)
    print("HY2_CONFIG_AUTH_FORMAT_VALID=" + yn(bool(pw)))
    cert_match = re.search(r'(?m)^\s*cert:\s*["\']?([^"\'\s]+)["\']?\s*$', text)
    key_match = re.search(r'(?m)^\s*key:\s*["\']?([^"\'\s]+)["\']?\s*$', text)
    print("HY2_CONFIG_CERT_PATH_OK=" + yn(bool(cert_match and cert_match.group(1) == cert)))
    print("HY2_CONFIG_KEY_PATH_OK=" + yn(bool(key_match and key_match.group(1) == key)))

print("HY2_CERT_PRESENT=" + yn(os.path.isfile(cert)))
print("HY2_KEY_PRESENT=" + yn(os.path.isfile(key)))

fp_ok = False
san_ok = False
if os.path.isfile(cert):
    try:
        out = subprocess.check_output(
            ["openssl", "x509", "-noout", "-fingerprint", "-sha256", "-in", cert],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        actual = out.split("=", 1)[1].strip() if "=" in out else ""
        fp_ok = actual.upper() == expected_fp.upper()
    except Exception:
        fp_ok = False
    try:
        out = subprocess.check_output(
            ["openssl", "x509", "-noout", "-ext", "subjectAltName", "-in", cert],
            stderr=subprocess.DEVNULL,
            text=True,
        )
        dns = re.findall(r'DNS:([^,\s]+)', out)
        san_ok = dns == [expected_sni]
    except Exception:
        san_ok = False

print("HY2_CERT_FINGERPRINT_MATCH=" + yn(fp_ok))
print("HY2_CERT_SAN_MATCH=" + yn(san_ok))
PY

if command -v ufw >/dev/null 2>&1; then
  ufw_first="$(ufw status 2>/dev/null | head -n 1 || true)"
  case "$ufw_first" in
    *inactive*) echo "UFW_ACTIVE=NO" ;;
    *active*) echo "UFW_ACTIVE=YES" ;;
    *) echo "UFW_ACTIVE=UNKNOWN" ;;
  esac
  ufw_8443_allow="$(ufw status 2>/dev/null | awk 'tolower($0) ~ /8443\/udp/ && tolower($0) ~ /allow/ {n++} END {print n+0}')"
  ufw_8443_deny="$(ufw status 2>/dev/null | awk 'tolower($0) ~ /8443\/udp/ && tolower($0) ~ /(deny|reject)/ {n++} END {print n+0}')"
  echo "UFW_8443_UDP_ALLOW_RULES=$ufw_8443_allow"
  echo "UFW_8443_UDP_DENY_RULES=$ufw_8443_deny"
else
  echo "UFW_ACTIVE=NOT_INSTALLED"
  echo "UFW_8443_UDP_ALLOW_RULES=0"
  echo "UFW_8443_UDP_DENY_RULES=0"
fi

if command -v nft >/dev/null 2>&1; then
  nft_rules="$(nft list ruleset 2>/dev/null || true)"
  nft_drop="$(printf '%s\n' "$nft_rules" | awk 'tolower($0) ~ /udp dport 8443/ && tolower($0) ~ /(drop|reject)/ {n++} END {print n+0}')"
  nft_accept="$(printf '%s\n' "$nft_rules" | awk 'tolower($0) ~ /udp dport 8443/ && tolower($0) ~ /accept/ {n++} END {print n+0}')"
  echo "NFT_8443_UDP_ACCEPT_RULES=$nft_accept"
  echo "NFT_8443_UDP_DROP_RULES=$nft_drop"
else
  echo "NFT_8443_UDP_ACCEPT_RULES=0"
  echo "NFT_8443_UDP_DROP_RULES=0"
fi

if command -v iptables >/dev/null 2>&1; then
  ipt="$(iptables-save 2>/dev/null || true)"
  ipt_drop="$(printf '%s\n' "$ipt" | awk 'tolower($0) ~ /--dport 8443/ && tolower($0) ~ /-p udp/ && tolower($0) ~ /-(j|g) (drop|reject)/ {n++} END {print n+0}')"
  ipt_accept="$(printf '%s\n' "$ipt" | awk 'tolower($0) ~ /--dport 8443/ && tolower($0) ~ /-p udp/ && tolower($0) ~ /-(j|g) accept/ {n++} END {print n+0}')"
  echo "IPTABLES_8443_UDP_ACCEPT_RULES=$ipt_accept"
  echo "IPTABLES_8443_UDP_DROP_RULES=$ipt_drop"
else
  echo "IPTABLES_8443_UDP_ACCEPT_RULES=0"
  echo "IPTABLES_8443_UDP_DROP_RULES=0"
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
    $stdout.TrimEnd() -split "[\r\n]+" | ForEach-Object { Write-Output $_ }
}

Write-Output "SSH_NATIVE_EXIT_CODE=$($p.ExitCode)"

if ($p.ExitCode -ne 0) {
    $safeClass = if ($stderr -match 'Host key verification failed') {
        'SSH_HOST_KEY_VERIFY_FAILED'
    }
    elseif ($stderr -match 'Permission denied') {
        'SSH_PERMISSION_DENIED'
    }
    elseif ($stderr -match 'Connection timed out|Connection refused|No route to host') {
        'SSH_CONNECTION_FAILED'
    }
    else {
        'SSH_REMOTE_PROBE_FAILED'
    }
    Write-Output "SERVER_READONLY_PROBE_RESULT=$safeClass"
    exit 1
}

Write-Output 'SERVER_READONLY_PROBE_RESULT=COMPLETE'
exit 0
