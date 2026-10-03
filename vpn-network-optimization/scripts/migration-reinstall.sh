#!/usr/bin/env bash
set -u

# Portable migration/reinstall helper. Default is a plan; no host write occurs.
# --apply is a later, separately authorized project-local write Gate.

PROJECT_NAME="${PROJECT_NAME:-vpn-network-optimization}"
APP_ROOT="${APP_ROOT:-/srv/apps/$PROJECT_NAME}"
DATA_ROOT="${DATA_ROOT:-/srv/data/$PROJECT_NAME}"
BACKUP_ROOT="${BACKUP_ROOT:-/srv/backups/$PROJECT_NAME}"

plan() {
  printf 'MIGRATION_PLAN=G3B_STAGED_NEW_TO_OLD\n'
  printf '1. freeze source and target VPS identity metadata; source remains authoritative\n'
  printf '2. fresh read-only inspect target hostname/public IP/WAN, WG, free ports, firewall/NAT and resources\n'
  printf '3. verify canonical target paths: %s / %s / %s\n' "$APP_ROOT" "$DATA_ROOT" "$BACKUP_ROOT"
  printf '4. validate non-secret migration metadata and repository templates\n'
  printf '5. enter a separate Owner-authorized Secret transfer checkpoint; never print/hash/overwrite unknown Secret values\n'
  printf '6. render protected WG/HY2 runtime config on target and validate before enablement\n'
  printf '7. qualify target WG and HY2 without changing the Owner production client\n'
  printf '8. keep REALITY as cold candidate: prove TCP/443 readiness and required metadata, do not create persistence merely for migration\n'
  printf '9. target health/read-back PASS before any client cutover\n'
  printf '10. perform bounded Owner-side candidate/cutover only in a later consequential Gate\n'
  printf '11. keep source VPS healthy and available throughout the rollback window\n'
  printf '12. source VPS deletion/decommission is a later Closeout Gate, never part of migration PASS\n'
  printf 'WRITE_PERFORMED=NO\n'
  printf 'SOURCE_VPS_MUTATED=NO\nTARGET_VPS_MUTATED=NO\n'
  printf 'SECRET_TRANSFER_PERFORMED=NO\nCURRENT_TRAFFIC_SWITCHED=NO\n'
  printf 'SOURCE_DECOMMISSIONED=NO\n'
}

if [[ "${1:-}" == --plan || $# -eq 0 ]]; then
  plan
  exit 0
fi

if [[ "${1:-}" != --apply ]]; then
  printf 'usage: %s [--plan|--apply]\n' "$0"
  exit 2
fi

[[ "${CONFIRM_MIGRATION_WRITE:-}" == APPLY_PROJECT_LOCAL_MIGRATION_ONLY ]] || {
  printf 'RETURN_OWNER_ACTION_REQUIRED: set CONFIRM_MIGRATION_WRITE=APPLY_PROJECT_LOCAL_MIGRATION_ONLY\n' >&2
  exit 2
}
[[ "$(id -u)" == 0 ]] || { printf 'RETURN_OWNER_ACTION_REQUIRED: root required\n' >&2; exit 2; }

mkdir -p "$APP_ROOT/config" "$APP_ROOT/scripts" "$APP_ROOT/templates" "$DATA_ROOT" "$BACKUP_ROOT"
printf 'PROJECT_PATHS_CREATED=YES\n'
printf 'SERVICE_ENABLEMENT=NO\nSECRET_GENERATION=NO\nWG_TOUCHED=NO\n'
printf 'NEXT_CHECKPOINT=render_and_validate_then_reviewer_review\n'

