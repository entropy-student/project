#!/usr/bin/env bash
set -u

# Remove only the project-owned optional HY2 artifacts. WireGuard, routes, NAT,
# firewall, system proxy, and unrelated services are deliberately out of scope.

PROJECT_ROOT="${PROJECT_ROOT:-/srv/apps/vpn-network-optimization}"
DATA_ROOT="${DATA_ROOT:-/srv/data/vpn-network-optimization}"
HY2_UNIT="${HY2_UNIT:-hysteria2-vpn-network-optimization.service}"
HY2_CONFIG="${HY2_CONFIG:-$PROJECT_ROOT/config/hysteria2-server.yaml}"
HY2_SERVICE_PATH="${HY2_SERVICE_PATH:-/etc/systemd/system/$HY2_UNIT}"

if [[ "${1:-}" != --apply ]]; then
  printf 'DRY_RUN_ONLY=YES\n'
  printf 'would stop/disable/remove unit: %s\n' "$HY2_UNIT"
  printf 'would remove config only: %s\n' "$HY2_CONFIG"
  printf 'would preserve data/secrets unless separately authorized: %s\n' "$DATA_ROOT"
  printf 'WG_TOUCHED=NO\nROUTES_TOUCHED=NO\nFIREWALL_TOUCHED=NO\n'
  exit 0
fi

[[ "${CONFIRM_ROLLBACK:-}" == REMOVE_PROJECT_OWNED_HY2_ONLY ]] || {
  printf 'RETURN_OWNER_ACTION_REQUIRED: set CONFIRM_ROLLBACK=REMOVE_PROJECT_OWNED_HY2_ONLY\n' >&2
  exit 2
}
[[ "$(id -u)" == 0 ]] || { printf 'RETURN_OWNER_ACTION_REQUIRED: root required\n' >&2; exit 2; }

systemctl stop "$HY2_UNIT"
systemctl disable "$HY2_UNIT"
rm -f -- "$HY2_SERVICE_PATH" "$HY2_CONFIG"
systemctl daemon-reload

printf 'ROLLBACK_APPLIED=YES\n'
printf 'WG_TOUCHED=NO\nROUTES_TOUCHED=NO\nFIREWALL_TOUCHED=NO\n'

