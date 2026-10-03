# Reviewer Decision — M3D Owner Authorized Caddy Monitor Migration + Stop Observation

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly authorized proceeding with the bounded Caddy monitor cleanup and reversible stop observation, with the instruction to report any problem if encountered.

```text
OWNER_AUTHORIZES_M3D=YES
OWNER_DIRECTION=PROCEED_AND_REPORT_IF_PROBLEM
UNIFIED_PAY_TOUCH_AUTHORIZED=NO
CADDY_DELETE_AUTHORIZED=NO
```

## Authorized sequence

1. Fresh-read current target/runtime and exact monitor files.
2. Prove whether the current monitor has external notification, alert delivery, auto-remediation, restart, or mutation side effects.
3. If any such behavior is present or unresolved, perform no monitor write and return to Reviewer.
4. If absent, preserve an exact rollback copy of the current monitor script in the existing scoped recovery area.
5. Modify only the Caddy-dependent localhost HTTPS probe in /srv/infra/monitoring/check-shared-infra.sh.
6. Keep existing host/Docker/cloudflared/private-network checks.
7. Add only the previously sealed replacement public/Tunnel health checks needed to validate current architecture.
8. Run one manual monitor execution.
9. Observe at least two scheduled timer executions.
10. If monitoring remains healthy, stop only the Shared Caddy service/container.
11. With Caddy stopped, verify Mini Craft, Shop and required current public Tunnel endpoints plus monitor health.
12. Return to Reviewer. Do not remove Caddy.

## Explicit limits

```text
MONITOR_SCRIPT_MUTATION_AUTHORIZED=YES_EXACT_SCOPE
MONITOR_UNIT_MUTATION_AUTHORIZED=NO_UNLESS_REQUIRED_BY_EXISTING_SCRIPT_EXECUTION
CADDY_STOP_AUTHORIZED=YES_CONDITIONAL_AFTER_MONITOR_PASS
CADDY_START_AUTHORIZED=YES_ROLLBACK_ONLY_IF_REGRESSION
CADDY_REMOVE_AUTHORIZED=NO
CADDY_IMAGE_DELETE_AUTHORIZED=NO
CADDY_CONFIG_DELETE_AUTHORIZED=NO
CADDY_DATA_DELETE_AUTHORIZED=NO
SPIKERSUN_EDGE_DELETE_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_MUTATION_AUTHORIZED=NO
BROAD_PRUNE_AUTHORIZED=NO
```

## Fail closed

Return immediately if monitor side effects are present/unresolved, rollback copy cannot be verified, replacement monitor fails, any scheduled run fails, any required production endpoint regresses, or Caddy stop causes an unexpected dependency failure.

If Caddy was already stopped when regression is discovered, rollback permits starting only Caddy again and restoring the exact pre-change monitor script if necessary.

## Success boundary

```text
PASS_CANDIDATE_M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION
MONITOR_EXTERNAL_NOTIFICATION=NO
MONITOR_AUTO_REMEDIATION=NO
CADDY_DEPENDENT_PROBE_REMOVED=YES
MONITOR_MANUAL_RUN=PASS
MONITOR_SCHEDULED_RUNS_PASS>=2
CADDY_STATE=stopped
PUBLIC_TUNNEL_REGRESSION=PASS
UNIFIED_PAY_MUTATIONS=0
CADDY_DELETIONS=0
STOP_AT_REVIEWER=YES
```