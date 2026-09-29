# M2A-R3 — Runtime Network Membership Reconciliation

## Gate

```text
M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_R3_RUNTIME_NETWORK_DRIFT_RECONCILIATION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Do not resume M2A writes.

## Accepted source facts

```text
COMPOSE_FILE=/srv/apps/mini-craft-night-kit/compose.production.yaml
SEALED_PRE_M2A_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
BACKUP=/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak
BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
```

## Target-host readback

Use the accepted Hostinger Web Terminal path only.

Capture safe metadata:

```text
TARGET_HOST=
WORDPRESS_CONTAINER=
WORDPRESS_CONTAINER_ID=
WORDPRESS_CREATED=
WORDPRESS_STARTED_AT=
WORDPRESS_RESTART_COUNT=
WORDPRESS_NETWORKS=
WORDPRESS_ALIASES_BY_NETWORK=
MARIADB_NETWORKS=
MARIADB_HEALTH=
CURRENT_COMPOSE_SHA256=
COMPOSE_PROJECT_LABEL=
COMPOSE_CONFIG_SOURCE_LABEL=
```

Read only the Compose network declarations / service network membership. Do not print environment values.

## Runtime-drift provenance

Inspect retained Docker events for the relevant M2A time window, if available.

Emit only:

```text
timestamp | type | action | container_or_network_name
```

for relevant WordPress / `spikersun-private` create/start/die/connect/disconnect/destroy events.

Do not dump full event actor attributes or labels.

If event retention cannot prove cause, say so.

## Private alias / reachability

Freshly establish:

```text
WORDPRESS_PRIVATE_ALIAS_PRESENT=
WORDPRESS_PRIVATE_ALIAS_VALUE=
TARGET_ALIAS=mini-craft-night-kit-wordpress
TARGET_ALIAS_COLLISIONS=
```

If a safe existing alias is present, perform only a read-only DNS/HTTP probe from a bounded container/network namespace already on `spikersun-private`, without reading cloudflared command/env/token.

Return:

```text
PRIVATE_ORIGIN_REACHABILITY=
PRIVATE_ORIGIN_HTTP_STATUS=
```

Do not create a disposable container if that would be a Docker mutation. Prefer an existing suitable container/network namespace. If no safe probe exists, return NOT_TESTABLE.

## Public continuity

Read-only:

```text
PUBLIC_HOME_HTTP=
PUBLIC_SHOP_HTTP=
PUBLIC_WP_REST_HTTP=
```

## Classification

Return exactly one:

```text
RUNTIME_NETWORK_DRIFT_CLASS=DIRECT_RUNTIME_NETWORK_ATTACH
RUNTIME_NETWORK_DRIFT_CLASS=COMPOSE_MANAGED_RECREATE
RUNTIME_NETWORK_DRIFT_CLASS=PREVIOUSLY_ACCEPTED_OPERATION
RUNTIME_NETWORK_DRIFT_CLASS=UNRESOLVED
```

And:

```text
SOURCE_RUNTIME_RECONCILIATION_REQUIRED=YES|NO
MINIMAL_RECONCILIATION_PLAN=<metadata only; do not execute>
```

## Forbidden

No writes. No Compose edit. No backup create/delete. No network connect/disconnect. No container restart/recreate. No Caddy/Cloudflare/DNS/database/payment/cleanup/SSH mutation.

## Evidence

Append facts to Shared VPS Execution Evidence and Executor Handoff only. Do not modify Reviewer Handoff.

## Result

```text
PASS_CANDIDATE_M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
RUNTIME_NETWORK_DRIFT_CLASS=<one allowed value>
MUTATIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Or precise RETURN.
