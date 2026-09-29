# M2A-R1 — Compose Baseline Reconciliation

## Gate

```text
M2A_R1_COMPOSE_BASELINE_RECONCILIATION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest, then:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_RETURN_R1_COMPOSE_BASELINE_RECONCILIATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Accepted historical hash:

```text
85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
```

Do not assume the current file should match it. Prove current state.

## Target-host read-only checkpoint

Use the already accepted Hostinger Web Terminal path. Do not retry direct SSH.

Prove:

```text
TARGET_HOST=srv1970241
COMPOSE_FILE=/srv/apps/mini-craft-night-kit/compose.production.yaml
```

Capture:

```text
CURRENT_COMPOSE_SHA256=
CURRENT_COMPOSE_BYTES=
CURRENT_COMPOSE_MTIME=
CURRENT_COMPOSE_OWNER_GROUP_MODE=
```

## Safe semantic extraction

Inspect only non-secret Compose structure.

Return:

```text
SERVICE_NAMES=
WORDPRESS_IMAGE=
MARIADB_IMAGE=
WORDPRESS_NETWORKS=
WORDPRESS_ALIASES_BY_NETWORK=
MARIADB_NETWORKS=
NETWORK_DECLARATIONS=
HOST_PUBLISHED_PORTS=
RESTART_POLICIES=
MOUNT_METADATA=
SECRET_REFERENCE_PATHS_ONLY=
COMPOSE_PROJECT_LABEL=
COMPOSE_CONFIG_SOURCE_LABEL=
```

Do not print environment blocks or Secret contents.

Also read current container metadata and confirm whether runtime topology still matches the pre-M2A accepted state:

```text
WORDPRESS_RUNNING=
WORDPRESS_RESTART_COUNT=
WORDPRESS_CURRENT_NETWORKS=
MARIADB_HEALTH=
MARIADB_CURRENT_NETWORKS=
WORDPRESS_HOST_PORTS=
MARIADB_HOST_PORTS=
```

## Historical candidate metadata

List metadata/hash only for project-scoped Compose/manifest backup candidates under:

```text
/srv/backups/mini-craft-night-kit
```

Do not restore or copy anything.

If a candidate hash equals the historical accepted hash, note its path and metadata.

## Drift classification

Compare the current non-secret semantics against historical accepted baseline and current running state.

Return exactly one:

```text
COMPOSE_DRIFT_CLASS=BYTE_ONLY_NONSEMANTIC
COMPOSE_DRIFT_CLASS=PREVIOUSLY_ACCEPTED_SEMANTIC_CHANGE
COMPOSE_DRIFT_CLASS=MATERIAL_UNEXPLAINED
COMPOSE_DRIFT_CLASS=UNRESOLVED
```

Do not guess the cause.

## Forbidden

No writes of any kind. No backup creation. No Compose edit/recreate. No Docker network changes. No Caddy, Cloudflare, DNS, application, database, payment, cleanup, Secret or SSH mutation.

## Evidence

Append execution facts to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not edit Reviewer Handoff.

## Result

```text
PASS_CANDIDATE_M2A_R1_COMPOSE_BASELINE_RECONCILIATION
CURRENT_COMPOSE_SHA256=<exact>
COMPOSE_DRIFT_CLASS=<one allowed value>
MUTATIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Or return one precise fail-closed reason.
