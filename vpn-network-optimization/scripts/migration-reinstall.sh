#!/usr/bin/env bash
set -u

# Portable migration/reinstall helper. Default is a plan; no host write occurs.
# --apply is a later, separately authorized project-local write Gate.

PROJECT_NAME="${PROJECT_NAME:-vpn-network-optimization}"
APP_ROOT="${APP_ROOT:-/srv/apps/$PROJECT_NAME}"
DATA_ROOT="${DATA_ROOT:-/srv/data/$PROJECT_NAME}"
BACKUP_ROOT="${BACKUP_ROOT:-/srv/backups/$PROJECT_NAME}"

plan() {
  printf 'MIGRATION_PLAN=G1_NON_DESTRUCTIVE\n'
  printf '1. fresh read-only inspect target identity, WG, ports, firewall, NAT, qdisc and offload\n'
  printf '2. verify canonical paths: %s / %s / %s\n' "$APP_ROOT" "$DATA_ROOT" "$BACKUP_ROOT"
  printf '3. validate external Secret/certificate metadata without reading values\n'
  printf '4. render non-secret templates and validate before any service action\n'
  printf '5. install optional HY2 unit only after DNS/cloud-firewall/Secret checkpoint\n'
  printf '6. health-check, record read-back, and keep WG as current path\n'
  printf '7. preserve rollback point; never broad-prune or overwrite unknown Secret files\n'
  printf 'WRITE_PERFORMED=NO\nWG_TOUCHED=NO\nCURRENT_TRAFFIC_SWITCHED=NO\n'
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

