# Reviewer Decision — M4B-R1 Historical Record Reconciliation / M5 Rebase

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Why this correction exists

After M4B, the Owner directed Reviewer to inspect the existing Unified Pay project-space history. That historical Evidence contains materially stronger provenance than the current GitHub project summary and current database schema alone.

## Newly reconciled historical facts

Historical Unified Pay execution evidence records:

1. production runtime code included an idempotent production-only bootstrap for exactly two fixed client IDs;
2. client_a_secret and client_b_secret were generated directly on srv1970241 during the Owner-authorized Unified Pay deployment;
3. deployment readback reported ACTIVE_FIXED_CLIENTS=2, ACTIVE_FIXED_CREDENTIALS=2, CLIENT_A_AUTH=200 and CLIENT_B_AUTH=200;
4. current PostgreSQL contains exactly two active registrations, production-client-a and production-client-b, created together with credentials at the deployment-era timestamp;
5. therefore the two current registrations are classified as the deployment-created fixed internal Unified Pay clients, not independent external customer registrations;
6. the sole ambiguous create attempt matches the Owner-authorized one-target CNY 0.01 Alipay real-canary sequence;
7. that canary used the computer-website adapter, which generated a browser form locally and made no external Alipay API transaction request;
8. local handoff validation rejected the generated form with HTTP 502 because HandoffAllowedHosts was not populated;
9. no payment handoff was returned, no Owner payment was requested, no retry occurred, callback/query were not executed, EXTERNAL_PROVIDER_TRANSACTION_CALLS=0 and REAL_PAYMENT_ACTIONS=0.

## Corrected classification

```text
PRODUCTION_CLIENT_A_PROVENANCE=INTERNAL_FIXED_BOOTSTRAP_CLIENT
PRODUCTION_CLIENT_B_PROVENANCE=INTERNAL_FIXED_BOOTSTRAP_CLIENT
EXTERNAL_OR_UNKNOWN_CALLER_BLOCKER=RESOLVED
GPT_VIEW_PLUS_MAPPING=UNPROVEN_AND_NOT_REQUIRED_FOR_RETIREMENT

AMBIGUOUS_INCIDENT_CONTEXT=OWNER_AUTHORIZED_INTERNAL_ALIPAY_CANARY
AMBIGUOUS_CREATE_EXTERNAL_PROVIDER_REQUEST=NO
AMBIGUOUS_CREATE_FAILURE_CLASS=LOCAL_HANDOFF_VALIDATION_HTTP_502
OWNER_PAYMENT_EXECUTED=NO
PROVIDER_PAYMENT_ACTION_EXECUTED=NO
PROVIDER_TRANSACTION_CALL_EXECUTED=NO
PROVIDER_CALLBACK_EXECUTED=NO
PROVIDER_QUERY_EXECUTED=NO
```

## Supersession

The M4B fields PRODUCTION_CLIENT_A_PROVENANCE=UNKNOWN, PRODUCTION_CLIENT_B_PROVENANCE=UNKNOWN, AMBIGUOUS_INCIDENT_CONTEXT=UNKNOWN and the corresponding residual external-caller/provider-create blockers are superseded by this historical-record reconciliation.

This does not claim that GPT View+ was actually connected to either client. Project documentation still indicates GPT View+ was intended as the first formal product integration; that mapping is unnecessary to establish that the fixed clients themselves were internal deployment principals.

## Revised retirement posture

Accepted carry-forward:

```text
DUJIAO_UNIFIED_PAY_DEPENDENCY=NO
NEW_INDEPENDENT_BUSINESS_ACTIVITY_AFTER_CANARY=NO
STOP_OBSERVE_ROLLBACK_READY=YES
```

With the two former blockers resolved, a reversible Unified Pay app-only stop observation is now technically ready to offer to Owner.

Permanent data/backup/Secret deletion remains a later Owner checkpoint.

## Current checkpoint

```text
CURRENT_GATE=M5_UNIFIED_PAY_APP_ONLY_STOP_OBSERVATION_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=WAITING_FOR_EXPLICIT_OWNER_AUTHORIZATION
UNIFIED_PAY_APP_STOP_CANDIDATE=YES
RESIDUAL_BLOCKERS_FOR_REVERSIBLE_APP_STOP=NONE
UNIFIED_PAY_APP_STOP_AUTHORIZED=NO
UNIFIED_PAY_DB_STOP_AUTHORIZED=NO
UNIFIED_PAY_CONTAINER_REMOVE_AUTHORIZED=NO
UNIFIED_PAY_TUNNEL_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_DATA_DELETE_AUTHORIZED=NO
UNIFIED_PAY_BACKUP_DELETE_AUTHORIZED=NO
```