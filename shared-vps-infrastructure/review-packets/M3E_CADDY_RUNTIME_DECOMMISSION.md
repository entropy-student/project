# M3E — Caddy Runtime Decommission

## Gate

```text
GATE=M3E_CADDY_RUNTIME_DECOMMISSION
MODE=BOUNDED_SHARED_INFRA_DELETE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3D_R1_PASS_M3E_CADDY_DECOMMISSION_CHECKPOINT.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3E_OWNER_AUTHORIZED_CADDY_RUNTIME_DECOMMISSION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

## Goal

Delete only the already-stopped Shared Caddy container. Preserve every rollback asset.

## Phase A — preflight

Freshly verify:

- target identity;
- Caddy container is still stopped;
- exact Caddy container ID/name;
- Caddy image still local;
- canonical Compose source exists;
- Caddyfile exists;
- /srv/infra/edge/data exists;
- /srv/infra/edge/config exists;
- spikersun-edge exists;
- cloudflared running;
- monitor latest result success;
- Mini Craft Home/Shop/wp-json healthy;
- shop.spikersun.com healthy.

If Caddy is running again or any production baseline regresses, do not remove anything. Return to Reviewer.

## Phase B — remove stopped Caddy container only

Remove exactly one stopped Caddy container/service instance.

Preferred: exact canonical Compose service removal if it does not touch dependencies or network lifecycle.

Otherwise use exact container removal by verified container identity.

Forbidden:

- compose down;
- docker system prune;
- docker container prune;
- image prune;
- network prune;
- volume prune;
- image rm;
- network rm;
- rm -rf;
- deleting Compose/Caddyfile/data/config;
- modifying Cloudflare/DNS/Tunnel;
- touching Unified Pay.

## Phase C — verify preserved rollback path

Require:

```text
CADDY_CONTAINER_PRESENT=NO
CADDY_IMAGE_PRESENT=YES
CADDY_COMPOSE_SOURCE_PRESENT=YES
CADDYFILE_PRESENT=YES
CADDY_DATA_PRESENT=YES
CADDY_CONFIG_PRESENT=YES
SPIKERSUN_EDGE_PRESENT=YES
CADDY_RECREATE_PATH_PRESERVED=YES
```

## Phase D — regression

Verify:

- Mini Craft Home;
- Mini Craft Shop;
- Mini Craft wp-json;
- Shop public endpoint;
- cloudflared;
- spikersun-private;
- monitor manual run.

Require normal TLS verification.

If regression appears after container removal, do not improvise. Recreate only the Caddy service from preserved canonical Compose/image/config if needed for rollback, then return evidence.

## Unified Pay boundary

```text
UNIFIED_PAY_MUTATIONS=0
```

No stop/restart/config/database/provider/payment/backup/Secret action is allowed.

## Evidence

Append to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both after persistence.

## Success return

```text
PASS_CANDIDATE_M3E_CADDY_RUNTIME_DECOMMISSION
CADDY_CONTAINER_PRESENT=NO
CADDY_IMAGE_PRESENT=YES
CADDY_RECREATE_PATH_PRESERVED=YES
PUBLIC_TUNNEL_REGRESSION=PASS
MONITOR_MANUAL_RUN=PASS
UNIFIED_PAY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```