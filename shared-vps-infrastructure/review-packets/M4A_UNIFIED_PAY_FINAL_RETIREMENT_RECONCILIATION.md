# M4A — Unified Pay Final Retirement Reconciliation

## Gate

```text
GATE=M4A_UNIFIED_PAY_FINAL_RETIREMENT_RECONCILIATION
MODE=READ_ONLY
ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/SHARED_VPS_PORTFOLIO.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M3E_PASS_M4A_UNIFIED_PAY_FINAL_RECONCILIATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md

unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/PROJECT_STORAGE_MANIFEST.md
unified-pay-system/PROJECT_RECORD.md
unified-pay-system/config/apps.gmpay.production.json
unified-pay-system/docs/NEW_PRODUCT_ONBOARDING.md
unified-pay-system/docs/SHARED_PAYMENT_HUB.md
```

Use canonical strict SSH to ops@srv1970241.

Strictly read-only.

# Part A — map the one recent caller to an app/project

Accepted baseline:

```text
REGISTERED_ACTIVE_CLIENTS=2
RECENT_DISTINCT_CLIENT_REFERENCES=1
LATEST_ACTIVITY=2026-09-14T16:45:03Z
INDEPENDENT_ACTIVITY_AFTER_AMBIGUOUS_WINDOW=NO
```

Use safe DB joins between audit/client/application registration tables to classify the recent caller.

Output only non-secret identity/classification fields such as:

```text
CALLER_APP_ID=<app slug or UNKNOWN>
CALLER_DISPLAY_NAME=<safe display name or UNKNOWN>
CALLER_CLIENT_TYPE=PUBLIC|SERVER|TEST|UNKNOWN
CALLER_STATUS=ACTIVE|INACTIVE|UNKNOWN
CALLER_ENVIRONMENT=PRODUCTION|TEST|CANARY|UNKNOWN
```

Do not output credentials, raw secrets, tokens, private customer data, payment IDs or transaction IDs.

Compare safely against known canonical config, including the documented GPT View+ registration.

If direct mapping is impossible, determine whether the second registered client can be safely classified and whether either registration is historical/test-only.

# Part B — prove whether there was any independent later activity

Read-only aggregate all relevant business/audit tables after 2026-09-14T16:45:03Z.

Return safe counts by event/status class only.

Do not output record identifiers.

Return:

```text
UNIFIED_PAY_NEW_BUSINESS_ACTIVITY_SINCE_AMBIGUOUS=YES|NO|UNRESOLVED
UNIFIED_PAY_LATEST_INDEPENDENT_ACTIVITY=<timestamp or NONE>
```

# Part C — local forensic classification of ambiguous create

For the single ambiguous provider-create attempt, inspect only safe metadata columns/derived flags.

Determine, if schema permits:

```text
REQUEST_SENT=YES|NO|UNKNOWN
PROVIDER_RESPONSE_RECEIVED=YES|NO|UNKNOWN
HTTP_STATUS_CLASS=<safe class/code or UNKNOWN>
TRANSPORT_ERROR_CLASS=<safe class or NONE/UNKNOWN>
PROVIDER_REFERENCE_PRESENT=YES|NO|UNKNOWN
PROVIDER_SUCCESS_SIGNAL_PRESENT=YES|NO|UNKNOWN
PROVIDER_FAILURE_SIGNAL_PRESENT=YES|NO|UNKNOWN
ATTEMPT_RETRYABLE=YES|NO|UNKNOWN
ATTEMPT_TERMINAL=YES|NO
```

Do not output raw request/response, provider reference value, merchant order ID, amount, customer info, credential, private key, signature or token.

Also inspect safe application logs/archived local execution evidence around the attempt timestamp if available. Use only event/error classes and timestamps.

Inspect backup filenames/timestamps and historical project evidence for test/canary context, but do not modify or restore backups.

Classify:

```text
AMBIGUOUS_LOCAL_COMMIT_CLASS=LIKELY_COMMITTED
```

or

```text
AMBIGUOUS_LOCAL_COMMIT_CLASS=LIKELY_NOT_COMMITTED
```

or

```text
AMBIGUOUS_LOCAL_COMMIT_CLASS=IRREDUCIBLY_AMBIGUOUS
```

Explain with safe metadata only.

# Part D — retirement proposal decision

Correlate caller class + no/new activity + local ambiguous-attempt evidence.

Return:

```text
UNIFIED_PAY_APP_STOP_OBSERVATION_CANDIDATE=YES|NO|UNRESOLVED
STOP_OBSERVATION_BLOCKERS=<safe semicolon-separated list or NONE>
```

Remember: app-stop observation is reversible and would preserve PostgreSQL/data/backups/Secrets/image/Compose/Tunnel rollback material, but M4A itself does not stop anything.

# Hard boundaries

```text
UNIFIED_PAY_RUNTIME_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_CALLS=0
PAYMENT_ACTIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
SECRET_VALUES_OUTPUT=0
BACKUP_MUTATIONS=0
FILE_DELETIONS=0
DOCKER_MUTATIONS=0
BROAD_PRUNE=NO
```

# Evidence

Append to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, then fresh-read both.

# Success return

```text
PASS_CANDIDATE_M4A_UNIFIED_PAY_FINAL_RETIREMENT_RECONCILIATION
LIVE_CALLER_CLASS=<safe classification>
LIVE_CALLER_ACTIVITY_AFTER_2026_09_14=YES|NO|UNRESOLVED
AMBIGUOUS_LOCAL_COMMIT_CLASS=LIKELY_COMMITTED|LIKELY_NOT_COMMITTED|IRREDUCIBLY_AMBIGUOUS
UNIFIED_PAY_NEW_BUSINESS_ACTIVITY_SINCE_AMBIGUOUS=YES|NO|UNRESOLVED
UNIFIED_PAY_APP_STOP_OBSERVATION_CANDIDATE=YES|NO|UNRESOLVED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```