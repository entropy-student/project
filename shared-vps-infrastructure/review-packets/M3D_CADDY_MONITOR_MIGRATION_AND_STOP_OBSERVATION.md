# M3D — Caddy Monitor Migration + Stop Observation

## Gate

```text
GATE=M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
MODE=BOUNDED_SHARED_INFRA_WRITE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

Read completely:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3C_PASS_M3D_CADDY_MONITOR_MIGRATION_STOP_CHECKPOINT.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3D_OWNER_AUTHORIZED_CADDY_STOP_OBSERVATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

Unified Pay is out of scope.

# Phase A — fresh preflight

Freshly prove target identity, Caddy current state/container identity, current Caddyfile hash, current monitor timer/service/script paths and hashes, timer enabled/active, current script semantics, public Mini Craft and Shop endpoint baseline, cloudflared running, and spikersun-private present.

Before any write, inspect the monitor script, service and timer for external notification delivery, HTTP POST alerting, systemctl/docker restart/start/stop, automatic remediation, file writes beyond normal logging, or provider/API mutations.

Return:

```text
MONITOR_EXTERNAL_NOTIFICATION=YES|NO|UNRESOLVED
MONITOR_AUTO_REMEDIATION=YES|NO|UNRESOLVED
```

If either is YES or UNRESOLVED:

```text
RETURN_M3D_MONITOR_SIDE_EFFECTS_UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

# Phase B — rollback copy

Create an exact rollback copy of /srv/infra/monitoring/check-shared-infra.sh inside the existing Shared Infrastructure scoped recovery/backup location.

Record source path, rollback path, source SHA256, rollback SHA256, byte count, mode and owner metadata. Hashes must match before continuing.

Do not alter timer/service unit files.

# Phase C — modify monitor script only

Modify only /srv/infra/monitoring/check-shared-infra.sh.

Remove the Caddy-dependent probe https://localhost:443.

Preserve the existing checks that matter: target host/basic health, Docker availability, cloudflared running/restart state, and spikersun-private existence.

Add only these sealed replacement checks:
- Mini Craft public Home over verified TLS;
- Mini Craft Shop over verified TLS;
- Mini Craft wp-json over verified TLS;
- Shop public endpoint over verified TLS.

Do not add Pay as a required probe because Unified Pay is under separate retirement review.

Validate script syntax before execution.

# Phase D — monitor validation

Run the monitor manually once and require MONITOR_MANUAL_RUN=PASS.

Then observe at least two actual scheduled timer runs and require MONITOR_SCHEDULED_RUNS_PASS>=2 and healthy timer state.

If any run fails: do not stop Caddy; restore the exact rollback script; validate restoration; return precise failure.

# Phase E — stop Caddy only

Only after Phase D passes, stop only the current Shared Caddy service/container using the canonical Compose project/service.

Do not remove it, remove the image, edit Caddyfile, edit Compose, delete /srv/infra/edge/data, delete /srv/infra/edge/config, or delete spikersun-edge.

After stop, fresh-read:

```text
CADDY_STATE=stopped
CADDY_CONTAINER_PRESENT=YES
CADDY_IMAGE_PRESENT=YES
```

# Phase F — regression while Caddy is stopped

Verify Mini Craft Home, Mini Craft Shop, Mini Craft wp-json, Shop public endpoint, cloudflared, spikersun-private, monitor manual run, and at least one subsequent scheduled monitor run if practical within the Gate.

If any required production regression occurs: start only Caddy again, re-check the affected endpoint, restore monitor script only if required, return rollback result, and do not delete anything.

Unified Pay must remain untouched throughout.

# Hard boundaries

```text
CADDY_REMOVE=NO
CADDY_DELETE=NO
CADDY_IMAGE_DELETE=NO
CADDY_CONFIG_DELETE=NO
CADDY_DATA_DELETE=NO
SPIKERSUN_EDGE_DELETE=NO
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
UNIFIED_PAY_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
BROAD_PRUNE=NO
```

# Evidence persistence

Append result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both GitHub writes.

# Success return

```text
PASS_CANDIDATE_M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
MONITOR_EXTERNAL_NOTIFICATION=NO
MONITOR_AUTO_REMEDIATION=NO
CADDY_DEPENDENT_PROBE_REMOVED=YES
MONITOR_MANUAL_RUN=PASS
MONITOR_SCHEDULED_RUNS_PASS=<n>=2
CADDY_STATE=stopped
CADDY_CONTAINER_PRESENT=YES
CADDY_IMAGE_PRESENT=YES
PUBLIC_TUNNEL_REGRESSION=PASS
UNIFIED_PAY_MUTATIONS=0
CADDY_DELETIONS=0
STOP_AT_REVIEWER=YES
```