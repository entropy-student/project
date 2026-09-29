# Reviewer Decision — M2A-R5 RETURN Accepted / R6 Canonical Hash Correction + Conditional Execution

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Shared VPS Evidence commit `e262acc51c61a87b9c0decae7d2be0574ca1bc1a`
- Executor Handoff commit `071c3ad1769102dcf1213f58db8daab52915809c`
- Mini Craft accepted historical Evidence for `K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE`

R5 correctly returned before write.

## Root cause — Reviewer hash transcription error

R5 observed:

```text
OBSERVED_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
OBSERVED_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
```

The accepted historical Mini Craft K6 D-R2 Evidence records:

```text
RESOLVED_COMPOSE_SHA=85ABEAAE1C75D775937EA2DDD7395E39F364044CC03DCF317861FDED2110EA8C
```

Case-normalized, these values are identical.

The previously Reviewer-sealed value:

```text
85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
```

does not match the accepted historical K6 resolved Compose hash. It was introduced during the later Shared VPS migration review and is superseded.

Formal ruling:

```text
R5_RETURN_ACCEPTED=YES
R5_PREFLIGHT_DRIFT_REAL=NO
ROOT_CAUSE=REVIEWER_HASH_TRANSCRIPTION_ERROR
CURRENT_COMPOSE_DRIFT=NO_PROVEN_DRIFT

CANONICAL_PRE_M2A_COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
CANONICAL_PRE_M2A_BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c

SUPERSEDED_INCORRECT_HASH=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
```

Do not rewrite historical Evidence; this decision supersedes the incorrect later Reviewer seal.

## Accepted R5 stable runtime facts

Parser-independent two-round readback PASSed:

```text
READ_ROUNDS_SEMANTICALLY_EQUAL=YES
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
```

Therefore R6 does not need to repeat another two-round parser investigation unless a fresh compact readback shows material drift.

## Current Gate

```text
CURRENT_GATE=M2A_R6_CANONICAL_HASH_CORRECTION_AND_CONDITIONAL_EXECUTION
CURRENT_GATE_STATUS=CONDITIONAL_BOUNDED_WRITE
```

## R6 prewrite

Before write, fresh read only:

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

## Compose validation

From `/srv/apps/mini-craft-night-kit`, validate the unmodified canonical Compose using the project's normal deployment environment resolution.

Do not enumerate or output environment values or Secret values.

If required environment cannot be safely resolved:

```text
RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Conditional M2A write

Only after prewrite + unmodified Compose validation PASS:

1. reuse existing verified pre-M2A backup;
2. edit only `/srv/apps/mini-craft-night-kit/compose.production.yaml`;
3. declare existing external `spikersun-private`;
4. attach WordPress only;
5. assign alias `mini-craft-night-kit-wordpress`;
6. preserve project DB network and `spikersun-edge`;
7. keep MariaDB off `spikersun-private`;
8. validate edited Compose with the same deployment environment resolution;
9. recreate only WordPress, no pull/build/dependency recreate;
10. prove private endpoint + target alias;
11. prove MariaDB isolation/health;
12. verify private origin;
13. verify public Home/Shop/REST remain healthy through existing Caddy path.

No M2B action is authorized.

## Forbidden

No Cloudflare/DNS/Tunnel/Public Hostname/Caddy/cloudflared mutation. No shared-network create/delete/recreate. No MariaDB write/recreate. No payment/provider action. No cleanup/prune. No unrelated-project mutation. No SSH retry.

## Success

```text
PASS_CANDIDATE_M2A_R6_CANONICAL_HASH_CORRECTION_AND_CONDITIONAL_EXECUTION
WORDPRESS_PRIVATE_NETWORK_READY=PASS
PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_ISOLATION=PASS
CURRENT_CADDY_PUBLIC_PATH_REGRESSION=PASS
STOP_AT_REVIEWER=YES
```
