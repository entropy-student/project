#!/usr/bin/env bash
set -u

# Non-invasive state check. It does not create traffic and does not alter services.
WG_INTERFACE="${WG_INTERFACE:-wg0}"
WG_PORT="${WG_PORT:-51820}"
HY2_PORT="${HY2_PORT:-8443}"
HY2_UNIT="${HY2_UNIT:-hysteria2-vpn-network-optimization.service}"

fail=0
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf 'PASS %s\n' "$label"
  else
    printf 'FAIL %s\n' "$label"
    fail=1
  fi
}

check "wg interface exists: $WG_INTERFACE" ip link show dev "$WG_INTERFACE"
check "wg service active" systemctl is-active --quiet "wg-quick@$WG_INTERFACE.service"
check "wg listen port present: $WG_PORT" bash -c "ss -H -lun 'sport = :$WG_PORT' | grep -q ."

# HY2 is intentionally optional; only assert it when the unit is installed.
if systemctl list-unit-files "$HY2_UNIT" --no-legend 2>/dev/null | grep -q "$HY2_UNIT"; then
  check "HY2 service active" systemctl is-active --quiet "$HY2_UNIT"
  check "HY2 listen port present: $HY2_PORT" bash -c "ss -H -lun 'sport = :$HY2_PORT' | grep -q ."
else
  printf 'INFO HY2 service not installed; current path remains WireGuard\n'
fi

printf 'PRIVATE_KEYS_READ=NO\n'
printf 'TRAFFIC_GENERATED=NO\n'
printf 'LIVE_TUNING_APPLIED=NO\n'
exit "$fail"

