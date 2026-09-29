# M2A-R7 — Explicit Non-secret Compose Environment + Conditional Execution

## Gate

```text
M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
TARGET_HOST=srv1970241
CONDITIONAL_WRITE_GATE=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_R6_RETURN_R7_EXPLICIT_NONSECRET_ENV_EXECUTION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

Use Hostinger Web Terminal only. Do not retry SSH.

## Phase A — compact prewrite continuity

Using parser-independent readback, require:

```text
TARGET_HOST=srv1970241
OBSERVED_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
OBSERVED_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
```

Any mismatch -> `RETURN_PREFLIGHT_DRIFT`.

## Phase B — interpolation schema extraction

Read only the canonical Compose source:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

Extract Compose interpolation variable names and only enough non-sensitive structural context to classify what each variable feeds.

Do not emit full Compose, environment values, Secret contents, mount source content, or credentials.

Require exactly two interpolation semantics:

```text
DATABASE_NAME
APP_DATABASE_USER
```

The accepted values are:

```text
DATABASE_NAME_VALUE=wordpress
APP_DATABASE_USER_VALUE=mini_craft_app
```

The exact variable names may differ; derive them from the source.

Return metadata only:

```text
INTERPOLATION_INPUT_COUNT=2
DATABASE_NAME_VARIABLE=<name>
APP_DATABASE_USER_VARIABLE=<name>
INTERPOLATION_SCHEMA=PASS
```

If additional required interpolation variables exist, or mapping is ambiguous:

```text
RETURN_COMPOSE_ENV_SCHEMA_DRIFT
STOP_AT_REVIEWER=YES
```

## Phase C — unmodified Compose validation with explicit non-secret process environment

Operate from:

`/srv/apps/mini-craft-night-kit`

Supply only the two derived variables to the Compose command process:

- database-name variable -> `wordpress`
- app-database-user variable -> `mini_craft_app`

Do not create/edit `.env` or any env file.

Do not print rendered config.

Run:

- explicit project `mini-craft-night-kit`;
- explicit canonical Compose file;
- `config --quiet`.

Return only:

```text
EXPLICIT_NONSECRET_ENV=PASS
UNMODIFIED_COMPOSE_VALIDATION=PASS
```

plus a non-secret error class if it fails.

## Phase D — bounded source edit

Only if A+B+C PASS.

Reuse the existing backup:

`/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak`

Do not create another duplicate backup.

Modify only:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

Required semantic change only:

- declare existing external `spikersun-private`;
- attach WordPress to it;
- assign alias `mini-craft-night-kit-wordpress`.

Preserve every other semantic.

MariaDB remains only on the project DB network.

## Phase E — edited validation

Use the same exact two explicit non-secret process environment variables.

Validate without printing rendered config or environment.

Prove metadata only:

```text
SERVICES=wordpress+mariadb
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_NETWORKS=mini-craft-night-kit-database
HOST_PORTS=NONE
UNEXPECTED_SEMANTIC_DRIFT=NO
```

If validation or semantic comparison fails, restore exact backup before recreate, verify restored hash, RETURN and stop.

## Phase F — recreate WordPress only

Using the same explicit two-value process environment:

- explicit project;
- explicit canonical Compose file;
- recreate WordPress only;
- no dependency recreate;
- no pull;
- no build.

Do not recreate MariaDB.

## Phase G — post-write proof

Using parser-independent JSON extraction, require:

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

Verify private origin:

`http://mini-craft-night-kit-wordpress:80`

with a bounded no-secret probe and no image pull/build.

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
2. validate with the same two explicit non-secret variables;
3. recreate WordPress only;
4. prove WordPress returns to DB + edge only;
5. prove MariaDB isolation;
6. prove Caddy public path healthy;
7. RETURN and stop.

## Forbidden

No historical env-file content read. No Secret value/hash read. No env-file creation/modification. No Cloudflare/DNS/Tunnel/Caddy/cloudflared mutation. No shared-network create/delete/recreate. No MariaDB write/recreate. No payment/provider action. No cleanup/prune. No unrelated-project mutation. No M2B.

## Evidence

Append to Shared VPS Execution Evidence and Executor Handoff only. Do not edit Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
TARGET_HOST_EXECUTION_PROVEN=PASS
INTERPOLATION_SCHEMA=PASS
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

Otherwise return one precise fail-closed reason.
