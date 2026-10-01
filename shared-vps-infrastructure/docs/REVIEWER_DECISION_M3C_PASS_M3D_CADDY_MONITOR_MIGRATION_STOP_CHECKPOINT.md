# Reviewer Decision — M3C PASS / M3D Caddy Monitor Migration + Stop Observation Checkpoint

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

- Executor result: PASS_CANDIDATE_M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
- Evidence commit: af3797e80f4fd2daaaeece5e4a0bfb41087b857e
- Executor Handoff commit: 00dfcf9b5375005b05c44665253ba74f9515abf5
- M3C execution contract
- current Shared VPS and Unified Pay Reviewer truth

The PASS_CANDIDATE is accepted.

## Formal M3C result

```text
M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE=PASS

UNIFIED_PAY_LIVE_CALLERS=1
LIVE_CALLER_CLASS=EXTERNAL_OR_UNKNOWN
LIVE_CALLER_ACTIVITY_AFTER_AMBIGUOUS_WINDOW=NO
LIVE_CALLER_RETIREMENT_BLOCKER=YES

PROVIDER_QUERY_PATH_PROVEN_READONLY=NO
PROVIDER_QUERY_PERFORMED=NO
AMBIGUOUS_PAYMENT_STATE=UNRESOLVED

CADDY_MONITOR_REPLACEMENT_PLAN=SEALED
CADDY_DEPENDENT_PROBE_REMOVABLE=YES

UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES

CADDY_RETIREMENT_READY_FOR_REVERSIBLE_STOP_SEQUENCE=YES
UNIFIED_PAY_RETIREMENT_READY=NO
```

## Unified Pay disposition

Unified Pay remains blocked from shutdown or removal.

Reasons:

1. one recent caller remains EXTERNAL_OR_UNKNOWN;
2. no independent activity occurred after the ambiguous transaction window, but caller ownership/purpose is still unproven;
3. the one provider-create attempt remains ambiguous;
4. no safely proven Alipay read-only inquiry path exists.

Therefore:

```text
UNIFIED_PAY_STOP_AUTHORIZED=NO
UNIFIED_PAY_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_INGRESS_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
```

## Caddy disposition

Caddy has no production reverse-proxy routes and no Mini Craft dependency. Its only proven active dependency is the Shared Infrastructure health timer probing https://localhost:443. A replacement monitoring design is sealed.

The next safe sequence is:

```text
STEP_1=BACKUP_CURRENT_MONITOR_SCRIPT
STEP_2=REPLACE_ONLY_CADDY_DEPENDENT_LOCALHOST_HTTPS_PROBE_WITH_SEALED_REPLACEMENT_PROBES
STEP_3=RUN_MONITOR_ONESHOT_AND_OBSERVE_SCHEDULED_TIMER
STEP_4=IF_MONITOR_PASS_STOP_CADDY_CONTAINER_ONLY
STEP_5=OBSERVE_PUBLIC_PRODUCTION_ENDPOINTS_AND_MONITOR_WITH_CADDY_STOPPED
STEP_6=RETURN_TO_REVIEWER
```

This sequence is reversible and does not delete Caddy, its image, Compose source, configuration, data/config binds, or spikersun-edge.

## Owner checkpoint

The following bounded Shared Infrastructure writes require explicit Owner authorization:

1. modify only /srv/infra/monitoring/check-shared-infra.sh to remove the Caddy-dependent localhost probe and add the sealed replacement probes;
2. preserve an exact rollback copy in the existing Shared Infrastructure recovery scope;
3. validate one manual oneshot plus at least two scheduled timer runs;
4. if monitoring is healthy, stop only the current Shared Caddy container/service without removing it;
5. observe public Mini Craft / Shop and remaining required production endpoints while Caddy is stopped;
6. do not remove Caddy, modify DNS/Tunnel/Cloudflare, delete files/networks, or touch Unified Pay.

Until explicit authorization:

```text
CURRENT_GATE=M3D_CADDY_MONITOR_MIGRATION_AND_STOP_OBSERVATION_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=WAITING_FOR_EXPLICIT_OWNER_AUTHORIZATION

MONITOR_SCRIPT_MUTATION_AUTHORIZED=NO
CADDY_STOP_AUTHORIZED=NO
CADDY_REMOVE_AUTHORIZED=NO
CADDY_DELETE_AUTHORIZED=NO
```