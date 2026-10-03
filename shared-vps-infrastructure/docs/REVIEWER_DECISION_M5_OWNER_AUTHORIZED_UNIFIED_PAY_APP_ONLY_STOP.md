# Reviewer Decision — M5 Owner Authorized Unified Pay App-Only Stop Observation

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner approved continuing to the next step, with an explicit request to re-check Dujiao/商城 Unified Pay coupling first.

That re-check is complete and does not introduce a blocker.

```text
OWNER_AUTHORIZES_M5=YES
OWNER_REQUESTED_DUJIAO_RECHECK=COMPLETED
```

## Dujiao re-check

Accepted current evidence:

- historical Dujiao project materials contain Unified Pay architecture/extraction documentation;
- Unified Pay was extracted from Dujiao payment-domain work and therefore historical references are expected;
- current Dujiao runtime uses its own app + PostgreSQL + Redis topology;
- fresh M3B readback found 3 payment channels, 0 active;
- channel_clients=0;
- downstream_order_refs=0;
- current deployed Compose and active non-secret source contain no Unified Pay/pay.spikersun.com reference;
- current mounted secret config was classified in memory with values suppressed and contains no Unified Pay reference.

Therefore:

```text
DUJIAO_UNIFIED_PAY_HISTORICAL_RELATION=YES
DUJIAO_UNIFIED_PAY_RUNTIME_DEPENDENCY=NO
DUJIAO_UNIFIED_PAY_BLOCKER_FOR_M5=NO
```

## Corrected Unified Pay retirement baseline

```text
PRODUCTION_CLIENT_A_PROVENANCE=INTERNAL_FIXED_BOOTSTRAP_CLIENT
PRODUCTION_CLIENT_B_PROVENANCE=INTERNAL_FIXED_BOOTSTRAP_CLIENT
AMBIGUOUS_INCIDENT_CONTEXT=OWNER_AUTHORIZED_INTERNAL_ALIPAY_CANARY
AMBIGUOUS_CREATE_EXTERNAL_PROVIDER_REQUEST=NO
OWNER_PAYMENT_EXECUTED=NO
PROVIDER_TRANSACTION_CALL_EXECUTED=NO
REAL_PAYMENT_ACTIONS=0
NEW_INDEPENDENT_BUSINESS_ACTIVITY_AFTER_CANARY=NO
STOP_OBSERVE_ROLLBACK_READY=YES
RESIDUAL_BLOCKERS_FOR_REVERSIBLE_APP_STOP=NONE
```

## Authorized action

Stop only the Unified Pay application service/container.

Keep all of:

- Unified Pay PostgreSQL running;
- /srv/data/unified-pay;
- /srv/backups/unified-pay;
- Secret sources/mounts;
- current app image;
- canonical Compose source;
- stopped app container;
- pay.spikersun.com Cloudflare Tunnel route;
- DNS;
- all unrelated projects.

## Rollback

If stopping Unified Pay causes any unexpected regression in Dujiao, Mini Craft, Shop, Xianyu or Shared Infrastructure, or produces credible evidence of an active current business caller, restart only the Unified Pay app service from the preserved canonical Compose source and return to Reviewer.

## Expected Pay behavior while stopped

pay.spikersun.com is expected to become unavailable because its Tunnel origin points directly to unified-pay-app:8080. That expected failure is not itself a rollback trigger.

## Hard limits

```text
UNIFIED_PAY_APP_STOP_AUTHORIZED=YES
UNIFIED_PAY_APP_START_AUTHORIZED=YES_ROLLBACK_ONLY
UNIFIED_PAY_DB_STOP_AUTHORIZED=NO
UNIFIED_PAY_CONTAINER_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_IMAGE_DELETE_AUTHORIZED=NO
UNIFIED_PAY_TUNNEL_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_DNS_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
UNIFIED_PAY_SECRET_DELETE_AUTHORIZED=NO
PROVIDER_CALLS_AUTHORIZED=NO
PAYMENT_ACTIONS_AUTHORIZED=NO
BROAD_PRUNE_AUTHORIZED=NO
```

## Success boundary

```text
PASS_CANDIDATE_M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION
DUJIAO_UNIFIED_PAY_RUNTIME_DEPENDENCY=NO
UNIFIED_PAY_APP_STATE=stopped
UNIFIED_PAY_APP_CONTAINER_PRESENT=YES
UNIFIED_PAY_POSTGRES_STATE=healthy
UNIFIED_PAY_DATA_PRESERVED=YES
UNIFIED_PAY_BACKUPS_PRESERVED=YES
UNIFIED_PAY_RECREATE_PATH_PRESERVED=YES
KNOWN_PROJECT_REGRESSION=NO
PAY_PUBLIC_ENDPOINT_EXPECTED_UNAVAILABLE=YES
ROLLBACK_USED=NO|YES
STOP_AT_REVIEWER=YES
```