# Reviewer Decision — M4B PASS / M5 Unified Pay App-Only Stop Owner Checkpoint

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

- Executor result: PASS_CANDIDATE_M4B_UNIFIED_PAY_CLIENT_PROVENANCE_FINAL
- Evidence commit: 7ba1d87f39c8677405ee2e61a878f9292e1fdc54
- Executor Handoff commit: 6304b38d4bddc69efe6c01b30441d52734aaae0a

The PASS_CANDIDATE is accepted.

## Formal M4B result

```text
M4B_UNIFIED_PAY_CLIENT_PROVENANCE_FINAL=PASS
SOURCE_ARCHIVE_SHA256_MATCH=YES
PRODUCTION_CLIENT_A_PROVENANCE=UNKNOWN
PRODUCTION_CLIENT_B_PROVENANCE=UNKNOWN
AMBIGUOUS_INCIDENT_CONTEXT=UNKNOWN
UNIFIED_PAY_STOP_OBSERVATION_RESIDUAL_RISK=UNCHANGED
NO_FURTHER_INVESTIGATION_GATE=YES
```

## Accepted residual facts

```text
DUJIAO_UNIFIED_PAY_DEPENDENCY=NO
UNIFIED_PAY_NEW_BUSINESS_ACTIVITY_SINCE_2026_09_14_AMBIGUOUS_WINDOW=NO
UNIFIED_PAY_LATEST_INDEPENDENT_ACTIVITY=NONE
PRODUCTION_CLIENT_A_LAST_DURABLE_ACTIVITY=2026-09-14T16:45:03.234414Z
PRODUCTION_CLIENT_B_DURABLE_PAYMENT_ACTIVITY=NONE
AMBIGUOUS_LOCAL_COMMIT_CLASS=IRREDUCIBLY_AMBIGUOUS
PROVIDER_CALLS_DURING_RECONCILIATION=0
UNIFIED_PAY_STOP_OBSERVE_ROLLBACK_READY=YES
```

## Reviewer assessment

A reversible app-only stop observation is technically reasonable to propose, but not proven risk-free.

Known risk if Owner authorizes the stop:

1. pay.spikersun.com health/API will become unavailable while the app is stopped.
2. Any still-existing unknown caller would receive failures during the observation.
3. The historical ambiguous Provider create is not resolved; stopping the app does not cancel, refund, settle, or reconcile it.
4. If a late Provider callback arrived while the app is stopped, the app would not process it until service is restored/retried externally.

Known containment:

- PostgreSQL remains running.
- /srv/data/unified-pay remains untouched.
- /srv/backups/unified-pay remains untouched.
- Secret sources remain untouched.
- local app image remains present.
- canonical Compose remains present.
- pay Tunnel/DNS remain unchanged.
- restoring the app is a bounded Compose/service start.
- known Dujiao runtime has no Unified Pay dependency.
- no independent durable business activity has been observed since the single 2026-09-14 incident window.

## M5 proposed scope

```text
M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION
STOP_APP_ONLY=YES
STOP_POSTGRES=NO
REMOVE_CONTAINER=NO
REMOVE_IMAGE=NO
REMOVE_TUNNEL=NO
DELETE_DATA=NO
DELETE_BACKUPS=NO
DELETE_SECRETS=NO
PROVIDER_CALLS=NO
PAYMENT_ACTIONS=NO
```

Pre-stop snapshot must capture safe runtime identity, current DB aggregates, app restart count, Tunnel/public baseline, and rollback command/source. Stop only the app service. Immediately verify PostgreSQL and all unrelated projects remain healthy. Observe public Pay failure shape and local request/error telemetry without changing state. If any unexpected dependency or material request activity appears, restart only the app and return.

## Owner checkpoint

```text
CURRENT_GATE=M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=WAITING_FOR_EXPLICIT_OWNER_AUTHORIZATION

UNIFIED_PAY_APP_STOP_AUTHORIZED=NO
UNIFIED_PAY_APP_START_AUTHORIZED=NO_EXCEPT_ROLLBACK_AFTER_SEPARATE_M5_AUTHORIZATION
UNIFIED_PAY_DB_STOP_AUTHORIZED=NO
UNIFIED_PAY_CONTAINER_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_TUNNEL_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
UNIFIED_PAY_PROVIDER_ACTION_AUTHORIZED=NO
```