#!/usr/bin/env bash
set -u

# Read-only G1 inspection. It never writes sysctl, qdisc, firewall, routes, WG, or services.
# It deliberately uses `wg show`, not `wg showconf`/`wg dump`, so private keys are not read.

WG_INTERFACE="${WG_INTERFACE:-wg0}"
WAN_INTERFACE="${WAN_INTERFACE:-auto}"
HY2_PORT="${HY2_PORT:-8443}"

section() { printf '\n===== %s =====\n' "$1"; }
run() {
  printf '$ %s\n' "$1"
  bash -lc "$1" 2>&1 || true
}

if [[ "$WAN_INTERFACE" == auto ]]; then
  WAN_INTERFACE="$(ip -4 route show default 2>/dev/null | awk 'NR==1 {print $5}')"
fi

section TARGET
run 'hostname'
run 'id'
run 'uname -a'
run '. /etc/os-release && printf "OS=%s VERSION=%s\\n" "$PRETTY_NAME" "$VERSION_ID"'
run 'ip -4 route show default'
run 'ip -o -4 addr show scope global'
run 'uptime'
run 'free -h'
run 'df -hT /'

section WIREGUARD
run "wg show $WG_INTERFACE"
run "ip -br addr show dev $WG_INTERFACE"
run "ip -d link show dev $WG_INTERFACE"
run "ip -4 route show dev $WG_INTERFACE"

section ROUTING_FORWARDING_FIREWALL
run 'ip -4 route show'
run 'sysctl net.ipv4.ip_forward net.ipv6.conf.all.forwarding'
run 'command -v ufw >/dev/null && ufw status verbose || true'
run 'command -v nft >/dev/null && nft -a list ruleset | sed -n "1,240p" || true'
run 'command -v iptables-save >/dev/null && iptables-save -c | sed -n "1,240p" || true'

section PORTS
run 'ss -H -lntup'
run "ss -H -lunp 'sport = :$HY2_PORT'"
run 'ss -H -lunp "sport = :51820"'

section QDISC_CONGESTION
run 'tc -s qdisc show'
run "tc -s qdisc show dev $WAN_INTERFACE"
run 'sysctl net.ipv4.tcp_congestion_control net.ipv4.tcp_available_congestion_control net.ipv4.tcp_allowed_congestion_control net.core.default_qdisc'
run 'sysctl net.core.rmem_max net.core.wmem_max net.core.netdev_max_backlog net.ipv4.tcp_mtu_probing net.ipv4.udp_rmem_min net.ipv4.udp_wmem_min'
run 'modinfo tcp_bbr | sed -n "1,24p"'

section NIC_OFFLOAD_GRO
run "ethtool -i $WAN_INTERFACE"
run "ethtool -k $WAN_INTERFACE"
run "ethtool -c $WAN_INTERFACE"
run "sysctl -a 2>/dev/null | grep -E 'udp.*gro|gro.*forward|gro.*list'"

section SERVICES
run 'systemctl is-enabled wg-quick@wg0.service'
run 'systemctl is-active wg-quick@wg0.service'
run 'systemctl list-unit-files "hysteria*" --no-legend'

printf '\nPREFLIGHT_READ_ONLY=YES\n'
printf 'WAN_INTERFACE_DETECTED=%s\n' "${WAN_INTERFACE:-UNKNOWN}"
printf 'HY2_PORT=%s\n' "$HY2_PORT"
printf 'PRIVATE_KEYS_READ=NO\n'
printf 'LIVE_TUNING_APPLIED=NO\n'

