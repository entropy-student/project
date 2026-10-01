# M4B — Unified Pay Client Provenance Final

## Gate

```text
GATE=M4B_UNIFIED_PAY_CLIENT_PROVENANCE_FINAL
MODE=READ_ONLY
ACCESS_PATH=CANONICAL_STRICT_SSH_PLUS_CANONICAL_GITHUB_SOURCE
STOP_AT_REVIEWER=YES
```

## Read first

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M4A_PASS_M4B_UNIFIED_PAY_CLIENT_PROVENANCE_FINAL.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
unified-pay-system/REVIEWER_HANDOFF.md
unified-pay-system/Dockerfile
unified-pay-system/BUNDLE_SHA256.txt
unified-pay-system/PROJECT_RECORD.md
unified-pay-system/config/apps.gmpay.production.json
```

# Part A — reconstruct canonical source bundle read-only

Reconstruct the canonical source archive from unified-pay-system/bundle/source.b64.part-* exactly as the Dockerfile specifies.

Verify:

```text
SOURCE_ARCHIVE_SHA256=653b511bd98595d0ad21fbb5729e1a41055a41c59f7b9c4c8b7ca21a791104a8
SOURCE_ARCHIVE_SHA256_MATCH=YES
```

Extract only into an ephemeral local/work area. Do not change GitHub or VPS runtime.

# Part B — search source provenance

Search the extracted reviewed source, migrations, seed/bootstrap scripts, deployment helpers and docs for:

```text
production-client-a
production-client-b
gpt-view-plus
client registration
client credential
seed
bootstrap
canary
real-canary
```

Return file paths and safe semantic findings only. Do not output secrets, credential literals or raw protected values.

Determine whether production-client-a/b are hard-coded bootstrap registrations, examples, test/canary clients, or user-created production principals.

# Part C — correlate DB registration provenance

Read-only inspect safe columns for the two current client registrations, if schema provides them:

- created_at / updated_at;
- display name;
- status;
- creator/source/mode classification;
- public/server/test flag;
- non-secret metadata keys;
- credential creation timestamps without credential values.

Correlate those timestamps with:

- deployment history;
- pre-alipay-real-canary backups;
- R4/R5/R6 backup sequence;
- 2026-09-14 ambiguous incident.

Do not output client UUIDs if treated as sensitive identifiers.

# Part D — final classification

Return:

```text
PRODUCTION_CLIENT_A_PROVENANCE=GPT_VIEW_PLUS|INTERNAL_CANARY_OR_TEST|OTHER_KNOWN_INTERNAL|EXTERNAL_PRODUCTION|UNKNOWN
PRODUCTION_CLIENT_B_PROVENANCE=GPT_VIEW_PLUS|INTERNAL_CANARY_OR_TEST|OTHER_KNOWN_INTERNAL|EXTERNAL_PRODUCTION|UNUSED_INTERNAL|UNKNOWN
AMBIGUOUS_INCIDENT_CONTEXT=CANARY_OR_TEST|PRODUCTION|UNKNOWN
PROVENANCE_EVIDENCE=<safe concise summary>
```

Then determine:

```text
UNIFIED_PAY_STOP_OBSERVATION_RESIDUAL_RISK=LOWERED|UNCHANGED
```

Do not decide permanent deletion in this Gate.

# Hard boundaries

```text
UNIFIED_PAY_RUNTIME_MUTATIONS=0
DATABASE_WRITES=0
PROVIDER_CALLS=0
PROVIDER_MUTATIONS=0
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

Append result to shared-vps-infrastructure/EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md, then fresh-read both.

# Success return

```text
PASS_CANDIDATE_M4B_UNIFIED_PAY_CLIENT_PROVENANCE_FINAL
PRODUCTION_CLIENT_A_PROVENANCE=<classification>
PRODUCTION_CLIENT_B_PROVENANCE=<classification>
AMBIGUOUS_INCIDENT_CONTEXT=CANARY_OR_TEST|PRODUCTION|UNKNOWN
UNIFIED_PAY_STOP_OBSERVATION_RESIDUAL_RISK=LOWERED|UNCHANGED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

If provenance remains UNKNOWN, do not create M4C or another investigation yourself. Stop at Reviewer.