# Shared VPS Portfolio

> 当前 Shared VPS 项目索引。  
> 本表只提供 summary + pointer；项目深层当前状态以对应项目 `REVIEWER_HANDOFF.md` 为准。

| Project | Role | Lifecycle | Apps path | Data path | Backup path | Runtime | Public host | Ingress | Current truth |
|---|---|---|---|---|---|---|---|---|---|
| Shared VPS Infrastructure | Shared | ACTIVE | `/srv/infra` | Shared infra scoped | Shared infra scoped | cloudflared + monitoring; Caddy runtime retired | multiple | Cloudflare Tunnel direct-to-app for verified routes | [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) |
| Xianyu | Application | ACTIVE_RUNTIME | `/srv/apps/xianyu` | `/srv/data/xianyu` | `/srv/backups/xianyu` | app healthy | UNKNOWN | UNKNOWN | [REVIEWER_HANDOFF.md](../xianyu/REVIEWER_HANDOFF.md) |
| Dujiao-Next | Commerce runtime | ACTIVE_RUNTIME / PROJECT_STAGE_CLOSED | `/srv/apps/dujiao-next` | `/srv/data/dujiao-next` | `/srv/backups/dujiao-next` | app + PostgreSQL + Redis healthy | `shop.spikersun.com` | Cloudflare Tunnel direct-to-app | [REVIEWER_HANDOFF.md](../dujiao-next/REVIEWER_HANDOFF.md) |
| Unified Pay | Payment infrastructure | RETIRED_WITH_UNRESOLVED_RECOVERY_ASSET_INCIDENT | `/srv/apps/unified-pay` (empty parent retained) | `/srv/data/unified-pay` (empty parent retained) | `/srv/backups/unified-pay` (empty parent retained) | app + PostgreSQL containers absent; images retained | `pay.spikersun.com` retained but origin unavailable | Cloudflare Tunnel route retained; no live app origin | [REVIEWER_HANDOFF.md](../unified-pay-system/REVIEWER_HANDOFF.md) |
| Mini Craft Night Kit | Ecommerce runtime | K9_CLOSED / RUNTIME_RETAINED / PRECOMMERCE | `/srv/apps/mini-craft-night-kit` | `/srv/data/mini-craft-night-kit` | `/srv/backups/mini-craft-night-kit` | WordPress + MariaDB | `minicraft.spikersun.com` | Cloudflare Tunnel direct-to-app; legacy Caddy route retired (M2E PASS) | [Shared infra current truth](./REVIEWER_HANDOFF.md) |

## Lifecycle notes

### Xianyu

- `AUTOMATION_SAFE_MODE=false`
- pre-X6 source/build trees remain retention review
- 8 backup generations remain retention review
- `xianyu_xianyu-network` is a delete candidate but not authorized

### Dujiao-Next

- R16 ephemeral runtime absent
- R16/history recovery material retained
- payment channels currently inactive
- Unified Pay runtime dependency NO (M3B)

### Unified Pay

Current truth:

```text
RUNTIME_STATE=DECOMMISSIONED
APP_CONTAINER=ABSENT
POSTGRES_CONTAINER=ABSENT
APP_IMAGE=RETAINED
POSTGRES_IMAGE=RETAINED
EXACT_DB_RECOVERY_SOURCE=NONE
COMPOSE_RECOVERY_SOURCE=NONE
SECRET_RECOVERY_SOURCE=WINDOWS_DPAPI
CURRENT_LIFECYCLE_DECISION=RETIRED_WITH_UNRESOLVED_RECOVERY_ASSET_INCIDENT
FURTHER_DESTRUCTIVE_CLEANUP=FROZEN
```

No current Dujiao or other known production runtime depends on Unified Pay. The unexplained recovery-asset loss is preserved as an incident record; do not continue destructive cleanup for neatness.

### Mini Craft Night Kit

```text
K9_CLOSEOUT=PASS
PUBLIC_PLATFORM_STATUS=ONLINE
REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
LEGACY_CADDY_ROUTE=RETIRED_M2E_PASS
```

## Cleanup rule

This portfolio does not authorize deletion. Cleanup requires a separate bounded Gate after exact ownership, reference and recovery checks.
