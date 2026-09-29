# Shared VPS Portfolio

> 当前 Shared VPS 项目索引。  
> 本表只提供 summary + pointer；项目深层当前状态以对应项目 `REVIEWER_HANDOFF.md` 为准。

| Project | Role | Lifecycle | Apps path | Data path | Backup path | Runtime | Public host | Ingress | Current truth |
|---|---|---|---|---|---|---|---|---|---|
| Shared VPS Infrastructure | Shared | ACTIVE | `/srv/infra` | Shared infra scoped | Shared infra scoped | Caddy + cloudflared | multiple | Mixed | [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) |
| Xianyu | Application | ACTIVE_RUNTIME | `/srv/apps/xianyu` | `/srv/data/xianyu` | `/srv/backups/xianyu` | app healthy | UNKNOWN | UNKNOWN | [REVIEWER_HANDOFF.md](../xianyu/REVIEWER_HANDOFF.md) |
| Dujiao-Next | Commerce runtime | ACTIVE_RUNTIME / PROJECT_STAGE_CLOSED | `/srv/apps/dujiao-next` | `/srv/data/dujiao-next` | `/srv/backups/dujiao-next` | app + PostgreSQL + Redis healthy | `shop.spikersun.com` | CF Tunnel likely, unverified | [REVIEWER_HANDOFF.md](../dujiao-next/REVIEWER_HANDOFF.md) |
| Unified Pay | Payment infrastructure | ACTIVE_RUNTIME / LIFECYCLE_REVIEW | `/srv/apps/unified-pay` | `/srv/data/unified-pay` | `/srv/backups/unified-pay` | app + PostgreSQL healthy | `pay.spikersun.com` | CF Tunnel likely, unverified | [REVIEWER_HANDOFF.md](../unified-pay-system/REVIEWER_HANDOFF.md) |
| Mini Craft Night Kit | Ecommerce runtime | K9_CLOSED / RUNTIME_RETAINED / PRECOMMERCE | `/srv/apps/mini-craft-night-kit` | `/srv/data/mini-craft-night-kit` | `/srv/backups/mini-craft-night-kit` | WordPress + MariaDB | `minicraft.spikersun.com` | Caddy direct | [REVIEWER_HANDOFF.md](../mini-craft-night-kit/REVIEWER_HANDOFF.md) |

## Lifecycle notes

### Xianyu

- `AUTOMATION_SAFE_MODE=false`
- pre-X6 source/build trees remain retention review
- 8 backup generations remain retention review
- `xianyu_xianyu-network` is a delete candidate but not authorized

### Dujiao-Next

- R16 ephemeral runtime absent
- R16/history recovery material retained
- fresh payment channel state UNKNOWN
- Unified Pay runtime dependency UNKNOWN

### Unified Pay

Current split truth:

```text
RUNTIME_STATE=ACTIVE_HEALTHY
PUBLIC_HEALTH_READY=ACTIVE
DOWNSTREAM_DEPENDENCY=UNKNOWN
HISTORICAL_ROLE=FROZEN_BACKUP
CURRENT_LIFECYCLE_DECISION=PENDING
```

Do not infer active business dependency from health endpoints alone.

### Mini Craft Night Kit

```text
K9_CLOSEOUT=PASS
PUBLIC_PLATFORM_STATUS=ONLINE
REAL_COMMERCE_ENABLED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

## Cleanup rule

This portfolio does not authorize deletion. Cleanup requires a separate bounded Gate after exact ownership, reference and recovery checks.
