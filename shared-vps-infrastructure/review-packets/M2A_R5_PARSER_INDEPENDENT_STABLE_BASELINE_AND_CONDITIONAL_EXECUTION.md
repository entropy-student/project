# M2A-R5 — Parser-independent Stable Baseline + Conditional Execution

## Gate

```text
M2A_R5_PARSER_INDEPENDENT_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
TARGET_HOST=srv1970241
CONDITIONAL_WRITE_GATE=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_R4_RETURN_R5_PARSER_INDEPENDENT_CONDITIONAL_EXECUTION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Use accepted Hostinger Web Terminal only. Do not retry SSH.

## Phase A — parser-independent stable runtime readback

Do not use Go-template iteration for network or alias extraction.

Use raw JSON plus an already-installed JSON parser such as `python3`.

Perform two read rounds separated by a short bounded interval.

For the exact WordPress container ID, extract only:

```text
container_id
restart_count
network_names
aliases_by_network
```

For `spikersun-private`, extract only:

```text
container IDs/names attached
aliases for those endpoints
```

For MariaDB, extract only:

```text
network_names
health
```

Do not output environment values, command arrays, mounts containing credentials, Secret contents, or broad inspect JSON.

Both rounds must prove:

```text
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS=mini-craft-night-kit-wordpress
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
```

If any parser fails or the two semantic results differ:

```text
RETURN_RUNTIME_READBACK_UNSTABLE
STOP_AT_REVIEWER=YES
```

## Phase B — source/backup seal

Require:

```text
COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
```

Existing backup:

`/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak`

Do not create a second backup if this one matches.

## Phase C — unmodified Compose validation

Operate from:

`/srv/apps/mini-craft-night-kit`

Do not enumerate environment-file contents or values.

Use the canonical project directory and file:

```text
project=mini-craft-night-kit
file=/srv/apps/mini-craft-night-kit/compose.production.yaml
```

Run an unmodified Compose validation using the normal project environment resolution from that directory.

Allowed output is only:

```text
UNMODIFIED_COMPOSE_VALIDATION=PASS|FAIL
```

plus non-secret error classification if it fails.

If required variables cannot be resolved safely:

```text
RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

Do not print resolved config or environment values.

## Phase D — bounded M2A source edit

Only if A+B+C PASS.

Reuse the verified existing backup.

Modify only:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

Required semantic change only:

- declare existing external `spikersun-private`;
- attach WordPress to it;
- assign alias `mini-craft-night-kit-wordpress`.

Preserve:

- project DB network;
- `spikersun-edge`;
- all images;
- mounts;
- secrets;
- tmpfs/logging/restart semantics;
- zero host ports.

MariaDB remains only on the project DB network.

## Phase E — edited Compose validation

Using the same canonical project-directory/environment resolution, validate without printing resolved Secret/environment values.

Prove metadata only:

```text
SERVICES=wordpress+mariadb
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_NETWORKS=mini-craft-night-kit-database
HOST_PORTS=NONE
UNEXPECTED_SEMANTIC_DRIFT=NO
```

If validation or semantic comparison fails, restore exact backup before recreate, verify source hash restored, RETURN and stop.

## Phase F — recreate WordPress only

Recreate only WordPress with explicit project/file selection and no dependency recreation, pull, or build.

Do not recreate MariaDB.

## Phase G — post-write proof

Using parser-independent JSON extraction, prove from both container and network views:

```text
WORDPRESS_RUNNING=YES
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
MARIADB_ON_SPIKERSUN_PRIVATE=NO
WORDPRESS_HOST_PORTS=NONE
MARIADB_HOST_PORTS=NONE
```

Use a bounded private-network HTTP probe only if possible without pulling/building or inheriting Secret/env state. Probe:

`http://mini-craft-night-kit-wordpress:80`

Record status/redirect metadata only.

Verify public continuity:

```text
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
CURRENT_PUBLIC_INGRESS=DNS_A_TO_CADDY
```

## Rollback

If post-write verification fails:

1. restore exact verified backup;
2. validate from canonical project directory;
3. recreate only WordPress;
4. prove WordPress returns to DB + edge only;
5. prove MariaDB remained isolated;
6. prove current Caddy public path healthy;
7. RETURN and stop.

## Forbidden

No Cloudflare/DNS/Tunnel/Public Hostname/Caddy/cloudflared mutation. No shared-network create/delete/recreate. No MariaDB write/recreate. No payment/provider action. No cleanup/prune. No unrelated-project mutation. No M2B.

## Evidence

Append to Shared VPS Execution Evidence and Executor Handoff only. Do not modify Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2A_R5_PARSER_INDEPENDENT_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
TARGET_HOST_EXECUTION_PROVEN=PASS
STABLE_PREWRITE_RUNTIME=PASS
UNMODIFIED_COMPOSE_VALIDATION=PASS
WORDPRESS_PRIVATE_NETWORK_READY=PASS
PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_ISOLATION=PASS
CURRENT_CADDY_PUBLIC_PATH_REGRESSION=PASS
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
CADDY_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Otherwise return one precise fail-closed reason.
