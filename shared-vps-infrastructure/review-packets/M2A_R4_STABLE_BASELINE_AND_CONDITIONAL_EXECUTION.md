# M2A-R4 — Stable Baseline + Conditional M2A Execution

## Gate

```text
M2A_R4_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
TARGET_HOST=srv1970241
CONDITIONAL_WRITE_GATE=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2A_R3_PASS_R4_STABLE_BASELINE_CONDITIONAL_EXECUTION.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

## Phase A — same-session stable prewrite

Use accepted Hostinger Web Terminal only. No SSH retry.

Require:

```text
TARGET_HOST=srv1970241
COMPOSE_FILE=/srv/apps/mini-craft-night-kit/compose.production.yaml
COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
BACKUP=/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak
BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=HEALTHY
```

Capture exact WordPress container ID.

Perform read A and read B, separated by a short bounded interval, using both:

- `docker inspect` of that exact container ID;
- `docker network inspect spikersun-private`.

Both reads must agree:

```text
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
```

If any conflict:

```text
RETURN_RUNTIME_READBACK_UNSTABLE
STOP_AT_REVIEWER=YES
```

## Phase B — canonical Compose environment validation

Operate from:

`/srv/apps/mini-craft-night-kit`

Identify the canonical deployment environment resolution used by the project without emitting values.

Allowed readback:

- env file path/name if present;
- file owner/group/mode/bytes;
- required variable names only;
- Compose project/config labels.

Forbidden readback:

- environment values;
- Secret contents/hashes;
- password/token/key/cookie material.

Validate the unmodified Compose using the canonical project directory/environment resolution.

Do not emit rendered environment or Secret values.

If validation cannot be completed safely:

```text
RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Phase C — bounded M2A write

Only after A+B PASS.

Reuse the existing verified backup. Do not create another unless the backup no longer matches the source.

Modify only:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

Target:

```text
wordpress:
  networks:
    - database
    - edge
    - spikersun-private

spikersun-private:
  external: true

wordpress alias on spikersun-private:
  mini-craft-night-kit-wordpress
```

Preserve all existing non-network semantics.

MariaDB must remain only on the project DB network.

## Phase D — validation before recreate

Using the same canonical deployment environment resolution:

- validate/render the edited Compose;
- confirm exactly WordPress + MariaDB;
- confirm no host ports;
- confirm WordPress networks are exactly DB + edge + private;
- confirm MariaDB remains DB only;
- confirm no image/build/mount/secret/restart-policy drift outside the intended network addition.

Any unexpected semantic difference -> restore source from backup before any recreate, verify hash, and RETURN.

## Phase E — recreate WordPress only

Recreate only the WordPress service:

- explicit project;
- explicit canonical Compose file;
- no dependency recreate;
- no pull;
- no build.

Do not recreate MariaDB.

## Phase F — post-write proof

Require:

```text
WORDPRESS_RUNNING=YES
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_HEALTH=HEALTHY
MARIADB_ON_SPIKERSUN_PRIVATE=NO
WORDPRESS_HOST_PORTS=NONE
MARIADB_HOST_PORTS=NONE
```

Verify private endpoint from both container and network views.

Use one bounded probe from `spikersun-private` with an already-present suitable image/tool if needed; no pull/build, no mounts, no Secret/environment inheritance. Probe only:

`http://mini-craft-night-kit-wordpress:80`

Record status/redirect metadata only.

Also verify:

```text
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
```

Current public ingress must remain DNS A -> Caddy.

## Rollback

If post-write checks fail:

1. restore exact pre-M2A Compose from verified backup;
2. validate with canonical deployment environment resolution;
3. recreate only WordPress;
4. verify WordPress returns to DB + edge only;
5. verify MariaDB remained isolated;
6. verify public Caddy path healthy;
7. RETURN and stop.

## Forbidden

No Cloudflare/DNS/Tunnel/Public Hostname/Caddy/cloudflared change. No shared network create/delete/recreate. No MariaDB write/recreate. No payment/provider action. No cleanup/prune. No other project changes. No M2B.

## Evidence

Append to Shared VPS Execution Evidence and Executor Handoff. Do not edit Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2A_R4_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
TARGET_HOST_EXECUTION_PROVEN=PASS
STABLE_PREWRITE_RUNTIME=PASS
COMPOSE_ENV_RESOLUTION=PASS
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
