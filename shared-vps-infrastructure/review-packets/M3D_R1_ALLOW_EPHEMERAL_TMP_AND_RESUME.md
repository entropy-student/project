# M3D-R1 — Allow Ephemeral Tempfile + Resume Caddy Stop Observation

## Gate

```text
GATE=M3D_R1_ALLOW_EPHEMERAL_TMP_AND_RESUME
MODE=BOUNDED_SHARED_INFRA_WRITE
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3D_OWNER_AUTHORIZED_CADDY_STOP_OBSERVATION.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3D_RETURN_R1_ALLOW_EPHEMERAL_TMP_AND_RESUME.md
shared-vps-infrastructure/review-packets/M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use canonical strict SSH to ops@srv1970241.

## Accepted preflight facts

Do not reopen these unless fresh drift is observed:

```text
MONITOR_EXTERNAL_NOTIFICATION=NO
MONITOR_AUTO_REMEDIATION=NO
MONITOR_HTTP_POST_OR_PROVIDER_WRITE=NO
MONITOR_EPHEMERAL_TMPFILE_LIFECYCLE=ALLOWED
CADDY_STATE=running
CLOUDFLARED_RUNNING_COUNT=1
SPIKERSUN_PRIVATE_PRESENT=YES
PREFLIGHT_MINICRAFT_HOME=HTTP_200_TLS_VERIFY_0
PREFLIGHT_MINICRAFT_SHOP=HTTP_200_TLS_VERIFY_0
PREFLIGHT_MINICRAFT_WP_REST=HTTP_200_TLS_VERIFY_0
PREFLIGHT_SHOP_HOME=HTTP_200_TLS_VERIFY_0
```

Freshly verify the monitor script hash and Caddy/runtime identity still match the accepted preflight before writing.

## Tempfile clarification

The existing mktemp response-body file under /tmp is explicitly allowed provided it remains ephemeral and removed by the existing EXIT trap.

Do not redesign this behavior unless required for the already-authorized probe change.

## Resume Phase B — rollback copy

Create and verify an exact rollback copy of /srv/infra/monitoring/check-shared-infra.sh in the existing scoped Shared Infrastructure recovery area.

Require source SHA256 == rollback SHA256 before continuing.

## Resume Phase C — monitor script

Modify only /srv/infra/monitoring/check-shared-infra.sh.

Remove the Caddy-dependent https://localhost:443 probe.

Preserve:
- host/basic health;
- Docker availability;
- cloudflared running/restart check;
- spikersun-private existence.

Add only:
- Mini Craft Home verified TLS;
- Mini Craft Shop verified TLS;
- Mini Craft wp-json verified TLS;
- shop.spikersun.com public endpoint verified TLS.

Do not add Unified Pay as a required probe.

Do not modify timer/service unit files.

## Validation

1. syntax check;
2. manual monitor run PASS;
3. at least two actual scheduled timer runs PASS.

If any fails: restore exact monitor rollback copy, do not stop Caddy, return to Reviewer.

## Caddy stop

Only after monitor validation passes, stop only the current Shared Caddy service/container using canonical Compose/service identity.

Do not remove anything.

Fresh-read:

```text
CADDY_STATE=stopped
CADDY_CONTAINER_PRESENT=YES
CADDY_IMAGE_PRESENT=YES
```

## Regression while stopped

Verify:
- Mini Craft Home;
- Mini Craft Shop;
- Mini Craft wp-json;
- Shop public endpoint;
- cloudflared;
- spikersun-private;
- manual monitor run;
- at least one scheduled monitor run if practical.

If a production regression appears, start only Caddy again and return rollback evidence.

## Hard boundaries

```text
UNIFIED_PAY_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
CADDY_REMOVE=NO
CADDY_DELETE=NO
CADDY_IMAGE_DELETE=NO
CADDY_CONFIG_DELETE=NO
CADDY_DATA_DELETE=NO
SPIKERSUN_EDGE_DELETE=NO
BROAD_PRUNE=NO
```

## Evidence

Append to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, then fresh-read both.

## Success return

```text
PASS_CANDIDATE_M3D_R1_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
MONITOR_EPHEMERAL_TMPFILE_LIFECYCLE=ALLOWED
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