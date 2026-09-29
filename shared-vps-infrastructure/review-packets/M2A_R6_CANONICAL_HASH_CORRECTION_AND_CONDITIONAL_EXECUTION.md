# M2A-R6 — Canonical Hash Correction + Conditional Execution

## Gate

```text
M2A_R6_CANONICAL_HASH_CORRECTION_AND_CONDITIONAL_EXECUTION
TARGET_HOST=srv1970241
CONDITIONAL_WRITE_GATE=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_R5_RETURN_R6_CANONICAL_HASH_CORRECTION_AND_EXECUTION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Use accepted Hostinger Web Terminal only. Do not retry SSH.

## Canonical pre-M2A source identity

The only current accepted source/backup SHA is:

```text
85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
```

The prior later Reviewer seal beginning `85abae...` is superseded and must not be used.

Existing backup:

`/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak`

## Phase A — compact fresh prewrite

Using parser-independent JSON extraction only, prove:

```text
TARGET_HOST=srv1970241
OBSERVED_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
OBSERVED_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
COMPOSE_EQUALS_BACKUP=YES
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
```

If any differs:

```text
RETURN_PREFLIGHT_DRIFT
STOP_AT_REVIEWER=YES
```

## Phase B — unmodified Compose validation

Change directory to:

`/srv/apps/mini-craft-night-kit`

Use the project's normal Compose environment resolution from this canonical directory.

Do not enumerate or output environment values.

Run validation of the unmodified exact canonical Compose.

Record only:

```text
UNMODIFIED_COMPOSE_VALIDATION=PASS|FAIL
COMPOSE_ENV_RESOLUTION=PASS|FAIL
```

plus a non-secret error class if needed.

If environment resolution is unavailable:

```text
RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Phase C — bounded source change

Only if A+B PASS.

Reuse the existing verified backup. Do not create another duplicate backup.

Modify only:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

Required semantic change only:

- declare `spikersun-private` as existing external network;
- attach WordPress to it;
- assign alias `mini-craft-night-kit-wordpress`.

Preserve every other Compose semantic.

MariaDB remains only on `mini-craft-night-kit-database`.

## Phase D — edited validation

Using the same environment resolution, prove metadata only:

```text
SERVICES=wordpress+mariadb
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_NETWORKS=mini-craft-night-kit-database
HOST_PORTS=NONE
UNEXPECTED_SEMANTIC_DRIFT=NO
```

If unexpected difference exists, restore the exact backup before recreate, verify restored hash, RETURN and stop.

## Phase E — recreate WordPress only

Use explicit project + canonical Compose file.

- no dependency recreate;
- no pull;
- no build;
- do not recreate MariaDB.

## Phase F — post-write proof

Using parser-independent JSON extraction:

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

Verify private-origin HTTP for:

`http://mini-craft-night-kit-wordpress:80`

using a bounded no-secret probe without pull/build.

Then verify:

```text
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
CURRENT_PUBLIC_INGRESS=DNS_A_TO_CADDY
```

## Rollback

On post-write failure:

1. restore exact verified backup;
2. validate;
3. recreate WordPress only;
4. prove DB+edge-only WordPress state;
5. prove MariaDB isolation;
6. prove public Caddy path healthy;
7. RETURN and stop.

## Forbidden

No Cloudflare/DNS/Tunnel/Caddy/cloudflared mutation. No shared-network create/delete/recreate. No MariaDB write/recreate. No payment/provider action. No cleanup/prune. No other-project change. No M2B.

## Evidence

Append to Shared VPS Execution Evidence and Executor Handoff only. Do not edit Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2A_R6_CANONICAL_HASH_CORRECTION_AND_CONDITIONAL_EXECUTION
TARGET_HOST_EXECUTION_PROVEN=PASS
STABLE_PREWRITE_RUNTIME=PASS
UNMODIFIED_COMPOSE_VALIDATION=PASS
WORDPRESS_PRIVATE_NETWORK_READY=PASS
PRIVATE_ALIAS=mini-craft-night-kit-wordpress
PRIVATE_ORIGIN_REACHABILITY=PASS
MARIADB_ISOLATION=PASS
CURRENT_CADDY_PUBLIC_PATH_REGRESSION=PASS
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
CADDY_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Otherwise one precise RETURN.
