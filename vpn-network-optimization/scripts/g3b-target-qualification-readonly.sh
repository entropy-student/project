#!/usr/bin/env bash
set -euo pipefail

EXPECTED_PUBLIC_IPV4=""
EXPECTED_HOSTNAME=""

usage() {
  printf 'usage: %s --expected-public-ip <ipv4> --expected-hostname <hostname>\n' "$0"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --expected-public-ip)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      EXPECTED_PUBLIC_IPV4="$2"
      shift 2
      ;;
    --expected-hostname)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      EXPECTED_HOSTNAME="$2"
      shift 2
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$EXPECTED_PUBLIC_IPV4" ]] || { printf 'RETURN_EXPECTED_PUBLIC_IP_REQUIRED\n' >&2; exit 2; }
[[ -n "$EXPECTED_HOSTNAME" ]] || { printf 'RETURN_EXPECTED_HOSTNAME_REQUIRED\n' >&2; exit 2; }

HOSTNAME_ACTUAL="$(hostname)"
OS_ID="unknown"
OS_VERSION_ID="unknown"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  OS_ID="${ID:-unknown}"
  OS_VERSION_ID="${VERSION_ID:-unknown}"
fi

KERNEL="$(uname -r)"
ARCH="$(uname -m)"
PUBLIC_IP_MATCH_COUNT="$(ip -o -4 addr show scope global | awk -v ip="$EXPECTED_PUBLIC_IPV4" '$4 ~ ("^" ip "/") {n++} END {print n+0}')"
DEFAULT_ROUTE_COUNT="$(ip -4 route show default | awk 'END {print NR+0}')"
WAN_INTERFACE="$(ip -4 route show default | awk 'NR==1 {print $5}')"
WAN_GATEWAY="$(ip -4 route show default | awk 'NR==1 {print $3}')"
MEM_AVAILABLE_KIB="$(awk '/^MemAvailable:/ {print $2; found=1} END {if (!found) print 0}' /proc/meminfo)"
ROOT_FREE_KIB="$(df -Pk / | awk 'NR==2 {print $4}')"
IP_FORWARD="$(sysctl -n net.ipv4.ip_forward 2>/dev/null || printf 'UNKNOWN')"

count_udp_port() {
  local port="$1"
  ss -H -lun | awk -v p=":$port" '$4 ~ (p "$") {n++} END {print n+0}'
}

count_tcp_port() {
  local port="$1"
  ss -H -ltn | awk -v p=":$port" '$4 ~ (p "$") {n++} END {print n+0}'
}

UDP_51820="$(count_udp_port 51820)"
UDP_8443="$(count_udp_port 8443)"
TCP_443="$(count_tcp_port 443)"
TCP_14443="$(count_tcp_port 14443)"

process_count() {
  local pattern="$1"
  pgrep -af "$pattern" 2>/dev/null | awk 'END {print NR+0}'
}

WG_RUNTIME_COUNT="$(systemctl list-unit-files 'wg-quick@*.service' --no-legend 2>/dev/null | awk 'NF {n++} END {print n+0}')"
HY2_RUNTIME_COUNT="$(process_count '(^|/)(hysteria|hysteria2)( |$)')"
MIHOMO_RUNTIME_COUNT="$(process_count '(^|/)(mihomo|clash-meta)( |$)')"
SING_BOX_RUNTIME_COUNT="$(process_count '(^|/)sing-box( |$)')"
XRAY_RUNTIME_COUNT="$(process_count '(^|/)xray( |$)')"

APP_ROOT='/srv/apps/vpn-network-optimization'
DATA_ROOT='/srv/data/vpn-network-optimization'
BACKUP_ROOT='/srv/backups/vpn-network-optimization'
LIB_ROOT='/usr/local/lib/vpn-network-optimization'
HY2_UNIT_PATH='/etc/systemd/system/hysteria2-vpn-network-optimization.service'

path_exists() {
  if [[ -e "$1" ]]; then printf '1'; else printf '0'; fi
}

PROJECT_APP_EXISTS="$(path_exists "$APP_ROOT")"
PROJECT_DATA_EXISTS="$(path_exists "$DATA_ROOT")"
PROJECT_BACKUP_EXISTS="$(path_exists "$BACKUP_ROOT")"
PROJECT_LIB_EXISTS="$(path_exists "$LIB_ROOT")"
PROJECT_HY2_UNIT_EXISTS="$(path_exists "$HY2_UNIT_PATH")"

if command -v ufw >/dev/null 2>&1; then
  UFW_STATUS="$(ufw status 2>/dev/null | sed -n 's/^Status: //p' | head -n 1)"
  [[ -n "$UFW_STATUS" ]] || UFW_STATUS=UNKNOWN
else
  UFW_STATUS=not-installed
fi

if command -v iptables >/dev/null 2>&1; then
  IPTABLES_VERSION="$(iptables --version 2>/dev/null || true)"
  case "$IPTABLES_VERSION" in
    *nf_tables*) IPTABLES_BACKEND=nf_tables ;;
    *legacy*) IPTABLES_BACKEND=legacy ;;
    *) IPTABLES_BACKEND=unknown ;;
  esac
else
  IPTABLES_BACKEND=not-installed
fi

if command -v nft >/dev/null 2>&1; then
  NFT_TEXT="$(nft -a list ruleset 2>/dev/null)" || {
    printf 'RETURN_NFT_READ_FAILED\n' >&2
    exit 31
  }
  if [[ -z "$NFT_TEXT" ]]; then
    NFT_INPUT_POLICY=EMPTY
  else
    NFT_INPUT_POLICY="$(printf '%s\n' "$NFT_TEXT" | awk '
      /hook input/ {
        seen=1
        if ($0 ~ /policy drop/) drop=1
        else if ($0 ~ /policy reject/) reject=1
        else if ($0 ~ /policy accept/) accept=1
        else unknown=1
      }
      END {
        if (drop) print "DROP"
        else if (reject) print "REJECT"
        else if (unknown) print "UNKNOWN"
        else if (accept) print "ACCEPT"
        else if (seen) print "UNKNOWN"
        else print "NO_INPUT_HOOK"
      }')"
  fi
else
  NFT_INPUT_POLICY=not-installed
fi

printf 'EXPECTED_HOSTNAME=%s\n' "$EXPECTED_HOSTNAME"
printf 'TARGET_HOSTNAME=%s\n' "$HOSTNAME_ACTUAL"
printf 'EXPECTED_PUBLIC_IPV4=%s\n' "$EXPECTED_PUBLIC_IPV4"
printf 'PUBLIC_IP_MATCH_COUNT=%s\n' "$PUBLIC_IP_MATCH_COUNT"
printf 'OS_ID=%s\n' "$OS_ID"
printf 'OS_VERSION_ID=%s\n' "$OS_VERSION_ID"
printf 'KERNEL=%s\n' "$KERNEL"
printf 'ARCH=%s\n' "$ARCH"
printf 'DEFAULT_ROUTE_COUNT=%s\n' "$DEFAULT_ROUTE_COUNT"
printf 'WAN_INTERFACE=%s\n' "${WAN_INTERFACE:-UNKNOWN}"
printf 'WAN_GATEWAY=%s\n' "${WAN_GATEWAY:-UNKNOWN}"
printf 'MEM_AVAILABLE_KIB=%s\n' "$MEM_AVAILABLE_KIB"
printf 'ROOT_FREE_KIB=%s\n' "$ROOT_FREE_KIB"
printf 'IP_FORWARD=%s\n' "$IP_FORWARD"
printf 'UDP_51820=%s\n' "$UDP_51820"
printf 'UDP_8443=%s\n' "$UDP_8443"
printf 'TCP_443=%s\n' "$TCP_443"
printf 'TCP_14443=%s\n' "$TCP_14443"
printf 'WG_RUNTIME_COUNT=%s\n' "$WG_RUNTIME_COUNT"
printf 'HY2_RUNTIME_COUNT=%s\n' "$HY2_RUNTIME_COUNT"
printf 'MIHOMO_RUNTIME_COUNT=%s\n' "$MIHOMO_RUNTIME_COUNT"
printf 'SING_BOX_RUNTIME_COUNT=%s\n' "$SING_BOX_RUNTIME_COUNT"
printf 'XRAY_RUNTIME_COUNT=%s\n' "$XRAY_RUNTIME_COUNT"
printf 'PROJECT_APP_EXISTS=%s\n' "$PROJECT_APP_EXISTS"
printf 'PROJECT_DATA_EXISTS=%s\n' "$PROJECT_DATA_EXISTS"
printf 'PROJECT_BACKUP_EXISTS=%s\n' "$PROJECT_BACKUP_EXISTS"
printf 'PROJECT_LIB_EXISTS=%s\n' "$PROJECT_LIB_EXISTS"
printf 'PROJECT_HY2_UNIT_EXISTS=%s\n' "$PROJECT_HY2_UNIT_EXISTS"
printf 'UFW_STATUS=%s\n' "$UFW_STATUS"
printf 'IPTABLES_BACKEND=%s\n' "$IPTABLES_BACKEND"
printf 'NFT_INPUT_POLICY=%s\n' "$NFT_INPUT_POLICY"
printf 'PRIVATE_KEYS_READ=NO\n'
printf 'APPLICATION_SECRET_VALUES_READ=0\n'
printf 'NETWORK_MUTATION=NO\n'
printf 'SERVICE_MUTATION=NO\n'
printf 'PACKAGE_MUTATION=NO\n'
printf 'FIREWALL_MUTATION=NO\n'
printf 'FILESYSTEM_MUTATION=NO\n'
printf 'G3B_TARGET_PROBE_RESULT=COMPLETE\n'
