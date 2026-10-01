# Reviewer Decision — M3B PASS / M3C Retirement Blocker Closure

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Executor result: `PASS_CANDIDATE_M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION`
- Evidence commit: `02dfb170b1f8dd6be044b22baa96c3c06ccc44e3`
- Executor Handoff commit: `00a4663deef7615de9369323a691f27d6d602b06`
- M3B execution contract
- current Shared VPS / Unified Pay truth

The PASS_CANDIDATE is accepted.

## Formal M3B result

```text
M3B_CADDY_UNIFIED_PAY_DEPENDENCY_RECONCILIATION=PASS

UNIFIED_PAY_REGISTERED_ACTIVE_CLIENTS=2
UNIFIED_PAY_LIVE_CALLERS=1
DUJIAO_UNIFIED_PAY_DEPENDENCY=NO

PAY_TUNNEL=spikersun-shared-private
PAY_TUNNEL_ORIGIN=http://unified-pay-app:8080
PAY_TUNNEL_HTTP_HOST_HEADER=NONE

AMBIGUOUS_PAYMENT_STATE=UNRESOLVED

CADDY_ACTIVE_ROUTE_CONSUMERS=1
CADDY_PORT_80_443_ACTIVE_DEPENDENCIES=1
CADDY_RETIREMENT_SAFE=NO

CURRENT_GATE=M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_READONLY_RECONCILIATION
```

## Accepted interpretation

The one Unified Pay "live caller" is proven only by durable payment-related audit activity within the last 30 days. Its identity/purpose is not yet classified, and its latest activity timestamp aligns with the same historical window as the unresolved provider-create attempt. Therefore it must not yet be treated as an ongoing production caller, but it also cannot be ignored.

Dujiao is now formally classified as not depending on Unified Pay in its current runtime/configuration.

The pay hostname is confirmed to route directly through the shared Cloudflare Tunnel to `http://unified-pay-app:8080`.

Caddy has no production reverse-proxy route. Its only proven active dependency is the scheduled Shared Infrastructure monitor:

`spikersun-infra-health.timer -> spikersun-infra-health.service -> check-shared-infra.sh -> https://localhost:443`

## M3C objective

M3C closes exactly three retirement blockers:

1. classify the one recent Unified Pay caller as current production dependency, historical/test-only dependency, or unresolved;
2. reconcile the one ambiguous provider-create state using one bounded provider read-only query if technically safe;
3. seal an exact replacement for the Caddy-dependent health timer so a later write Gate can migrate monitoring away from localhost:443.

M3C also performs a recovery-barrier preflight sufficient to design the later Unified Pay stop/observe Gate, but does not restore or mutate the runtime.

## Bounded provider read-only authorization

Reviewer authorizes **one read-only provider reconciliation attempt** for the single ambiguous Alipay create attempt, only if all of the following are true:

- the existing production Unified Pay runtime already has the required protected provider credential available;
- the codebase contains an existing provider-order/status query path, or the provider's official read-only query operation can be invoked through the current adapter without introducing new Secret handling;
- no Secret value, provider transaction identifier, merchant order identifier, amount, customer identifier, raw request, raw response or signature material is emitted;
- the operation cannot create, retry, cancel, refund or otherwise mutate a payment;
- the result is reduced immediately to a safe classification.

If any of these conditions are not satisfied, do not contact the provider and return `AMBIGUOUS_PAYMENT_STATE=UNRESOLVED`.

Allowed provider result classification only:

```text
PROVIDER_QUERY_PERFORMED=YES|NO
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL|PROVEN_NOT_COMMITTED|UNRESOLVED
PROVIDER_MUTATIONS=0
PAYMENT_ACTIONS=0
```

## Caller classification boundary

The one distinct recent caller may be mapped to an internal project/purpose classification if this can be done from current registration metadata without exposing raw client IDs, credentials or private user data.

Allowed output examples:

```text
LIVE_CALLER_CLASS=INTERNAL_PROJECT:<project-name>
LIVE_CALLER_CLASS=HISTORICAL_TEST_OR_CANARY
LIVE_CALLER_CLASS=EXTERNAL_OR_UNKNOWN
```

Do not output client ID, credential ID or secret.

Correlate the caller's recent audit activity with the ambiguous intent/create attempt by safe timestamps/event classes only.

Return:

```text
UNIFIED_PAY_LIVE_CALLERS=1|0|UNRESOLVED
LIVE_CALLER_CLASS=<safe classification>
LIVE_CALLER_RETIREMENT_BLOCKER=YES|NO|UNRESOLVED
```

## Caddy monitoring replacement design

M3C must inspect the active timer/service/script and determine the smallest safe replacement that no longer depends on Caddy or host 80/443.

Preferred target is to test the infrastructure that actually matters after Caddy retirement, such as:

- `cloudflared` container health/running state;
- shared Tunnel/private-network reachability;
- one or more current public production health endpoints through Cloudflare;
- target-host identity and Docker availability.

Do not change the timer/script in M3C.

Return:

```text
CADDY_MONITOR_REPLACEMENT_PLAN=SEALED|UNRESOLVED
REPLACEMENT_PROBES=<safe summary>
CADDY_DEPENDENT_PROBE_REMOVABLE=YES|NO|UNRESOLVED
```

## Recovery preflight

Without modifying or decrypting Secrets, establish whether a later reversible Unified Pay app-stop Gate can safely keep:

- PostgreSQL running;
- /srv/data/unified-pay intact;
- /srv/backups/unified-pay intact;
- current app image and Compose source intact;
- current Secret source files intact;
- Tunnel rollback metadata intact.

Return:

```text
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES|NO|UNRESOLVED
```

This is not a full permanent data-deletion recovery barrier and does not authorize backup deletion.

## Success boundary

```text
PASS_CANDIDATE_M3C_CADDY_UNIFIED_PAY_RETIREMENT_BLOCKER_CLOSURE
UNIFIED_PAY_LIVE_CALLERS=<0|1|UNRESOLVED>
LIVE_CALLER_CLASS=<safe classification>
LIVE_CALLER_RETIREMENT_BLOCKER=YES|NO|UNRESOLVED
PROVIDER_QUERY_PERFORMED=YES|NO
AMBIGUOUS_PAYMENT_STATE=RECONCILED_TERMINAL|PROVEN_NOT_COMMITTED|UNRESOLVED
CADDY_MONITOR_REPLACEMENT_PLAN=SEALED|UNRESOLVED
CADDY_DEPENDENT_PROBE_REMOVABLE=YES|NO|UNRESOLVED
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES|NO|UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

No Caddy/monitor write, Unified Pay shutdown, Tunnel/DNS mutation, database write, provider mutation, payment action, deletion or backup cleanup is authorized.
