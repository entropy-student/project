# Reviewer Decision — M2A RETURN Accepted / R1 Compose Baseline Reconciliation

Date: 2026-09-29  
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

```text
GATE=M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
RESULT=RETURN_PREFLIGHT_DRIFT
EVIDENCE_COMMIT=83ba42bc92947ed1a95d1302784cde8193c95b3d
EXECUTOR_HANDOFF_COMMIT=0d139b98592d8514b9187231f161d25ade55f91e
```

Independent GitHub review confirms the Executor stopped before backup or mutation.

```text
COMPOSE_FILE_MUTATION=0
WORDPRESS_RECREATE=0
SHARED_NETWORK_MUTATIONS=0
MARIADB_CHANGE=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
CADDY_MUTATIONS=0
PAYMENT_ACTIONS=0
```

The RETURN is correct.

## Historical baseline reconciliation

The expected hash is not arbitrary. Historical accepted Mini Craft K6 evidence records:

```text
RESOLVED_COMPOSE_SHA=85ABEAAE1C75D775937EA2DDD7395E39F364044CC03DCF317861FDED2110EA8C
```

and the resolved semantic baseline:

```text
SERVICES=wordpress+mariadb
HOST_PORTS=NONE
DB_NETWORK=INTERNAL
EDGE_NETWORK=EXTERNAL
```

Later accepted Evidence does not record an authorized Mini Craft Compose mutation. Therefore the fresh mismatch must be reconciled rather than ignored or re-baselined by assumption.

## Current Gate

```text
CURRENT_GATE=M2A_R1_COMPOSE_BASELINE_RECONCILIATION
CURRENT_GATE_STATUS=READ_ONLY_ONLY
M2A_WRITE_AUTHORIZATION=SUSPENDED_PENDING_R1
```

## Goal

Determine the exact current Compose source hash and whether the difference is:

1. byte-only/non-semantic drift;
2. a previously accepted but incompletely recorded semantic change;
3. material unexplained configuration drift.

No write is authorized.

## Required evidence

From `srv1970241`, read only:

- exact current SHA-256, size, mtime and owner/mode of `/srv/apps/mini-craft-night-kit/compose.production.yaml`;
- current running WordPress/MariaDB image identities, mounts, host ports and networks;
- targeted non-secret Compose structure:
  - service names;
  - image references/digests;
  - network declarations and external/internal status;
  - per-service network membership and aliases;
  - mounts by source/destination/type only;
  - secret/config file path references only, never values;
  - restart policy;
  - published ports;
- current Docker Compose labels that identify the canonical project/config source;
- project-scoped backup/manifest candidates that may contain an older Compose copy: list metadata/hash only unless a candidate is needed for safe semantic comparison.

Do not emit environment values, Secret values, credentials, or cloudflared token material.

## Comparison

Compare current semantic structure against the accepted deployed baseline and the M2A expected pre-change topology.

Return exactly one:

```text
COMPOSE_DRIFT_CLASS=BYTE_ONLY_NONSEMANTIC
COMPOSE_DRIFT_CLASS=PREVIOUSLY_ACCEPTED_SEMANTIC_CHANGE
COMPOSE_DRIFT_CLASS=MATERIAL_UNEXPLAINED
COMPOSE_DRIFT_CLASS=UNRESOLVED
```

If byte-only/non-semantic, provide the exact current SHA so Reviewer can decide whether to re-baseline M2A.

If semantic, identify only the changed fields needed for review.

## Forbidden

No backup creation, Compose edit, service recreate, Docker network change, Caddy/Cloudflare/DNS change, DB/app write, payment, Secret access, cleanup or SSH retry.

## Success

```text
PASS_CANDIDATE_M2A_R1_COMPOSE_BASELINE_RECONCILIATION
CURRENT_COMPOSE_SHA256=<exact>
COMPOSE_DRIFT_CLASS=<one allowed value>
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

R1 PASS does not itself resume M2A writes.
