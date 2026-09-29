# Reviewer Decision — M2A-R6 RETURN Accepted / R7 Explicit Non-secret Compose Environment

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `f6d45a6a62205ddaece57736f704d993b95ccff9`
- Executor Handoff commit `f28dcfda75c0fc623a8151832d5dd04e03be9bb7`
- accepted historical Mini Craft K6 Evidence

R6 correctly returned before write.

## Accepted R6 facts

```text
TARGET_HOST=srv1970241
COMPOSE_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
BACKUP_SHA256=85abeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fded2110ea8c
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_COLLISIONS=0
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=healthy
M2A_WRITE_ENTERED=NO
```

The remaining blocker is Compose interpolation environment resolution.

## Historical environment fact

Accepted K6 evidence records that the sealed production Compose requires exactly two non-secret interpolation inputs for database name and application database user.

It also records the accepted deployed non-secret values:

```text
DATABASE=wordpress
APP_USER=mini_craft_app
```

and that the Compose rendered successfully when those two non-secret inputs were supplied.

Therefore R7 must not depend on discovering or reading any historical env-file values. It must derive the exact interpolation variable names from the current canonical Compose source and, only if they map unambiguously to those two accepted non-secret semantics, supply the accepted values explicitly to the Compose process.

## Current Gate

```text
CURRENT_GATE=M2A_R7_EXPLICIT_NONSECRET_COMPOSE_ENV_AND_CONDITIONAL_EXECUTION
CURRENT_GATE_STATUS=CONDITIONAL_BOUNDED_WRITE
```

## R7 environment rule

Read the canonical Compose source only to extract interpolation placeholder names and their safe structural context.

Require:

```text
INTERPOLATION_INPUT_COUNT=2
INTERPOLATION_INPUT_SEMANTICS=DATABASE_NAME+APP_DATABASE_USER
DATABASE_VALUE=wordpress
APP_USER_VALUE=mini_craft_app
```

Do not output any other environment values.

If the current source requires any additional interpolation input, or either input cannot be mapped safely to database name/app-user semantics:

```text
RETURN_COMPOSE_ENV_SCHEMA_DRIFT
STOP_AT_REVIEWER=YES
```

If exactly two inputs are proven, run Compose validation with those two accepted non-secret values supplied only to the Compose process environment. Do not create or modify an env file.

## Conditional M2A execution

Only if the compact runtime/hash preflight and explicit-env unmodified Compose validation PASS:

1. reuse existing verified backup;
2. modify only the canonical Compose;
3. add existing external `spikersun-private` to WordPress only;
4. add alias `mini-craft-night-kit-wordpress`;
5. keep MariaDB isolated;
6. validate edited Compose using the same explicit two-value non-secret process environment;
7. recreate WordPress only using the same explicit environment;
8. prove private endpoint/origin and current public Caddy regression.

No M2B action is authorized.

## Forbidden

No historical env-file content read, no Secret value/hash read, no new env file, no Cloudflare/DNS/Tunnel/Caddy/cloudflared mutation, no shared-network create/delete/recreate, no MariaDB write/recreate, no payment/provider action, no cleanup/prune, no unrelated-project mutation, no SSH retry.
