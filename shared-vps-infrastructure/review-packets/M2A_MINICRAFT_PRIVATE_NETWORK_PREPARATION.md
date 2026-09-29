# M2A — Mini Craft Private Network Preparation

## Gate

```text
M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
WRITE_GATE=YES
TARGET_HOST=srv1970241
STOP_AT_REVIEWER=YES
```

## Goal

Prepare Mini Craft WordPress for direct Cloudflare Tunnel origin reachability without changing the public ingress.

Final M2A state:

```text
WordPress:
  mini-craft-night-kit-database
  spikersun-edge
  spikersun-private
    alias=mini-craft-night-kit-wordpress

MariaDB:
  mini-craft-night-kit-database only
```

Public traffic remains on the existing DNS A -> Caddy route.

## Required read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M1_R4_PASS_M1_ARCHITECTURE_SEALED_M2A_AUTHORIZED.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
```

## Execution boundary

Prefer an execution path that can prove target-host identity and perform post-write host-local readback.

Do not blindly retry the historically intermittent direct SSH path.

If the Executor cannot directly control the accepted Hostinger Web Terminal, prepare one bounded Owner-local command/script and stop at Owner checkpoint. Owner only pastes/runs it once; Owner does not design or troubleshoot the change.

## Preflight — no write yet

Prove:

```text
TARGET_HOST=srv1970241
COMPOSE_FILE=/srv/apps/mini-craft-night-kit/compose.production.yaml
COMPOSE_PROJECT=mini-craft-night-kit
WORDPRESS_RUNNING=YES
MARIADB_HEALTHY=YES
WORDPRESS_CURRENT_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_CURRENT_NETWORKS=mini-craft-night-kit-database
SPIKERSUN_PRIVATE_EXISTS=YES
MINICRAFT_ALIAS_ON_SPIKERSUN_PRIVATE=ABSENT
UNIQUE_ALIAS=mini-craft-night-kit-wordpress
CADDY_ROUTE_REMAINS_PRESENT=YES
```

Freshly confirm that no current container on `spikersun-private` owns alias `mini-craft-night-kit-wordpress`.

If any baseline differs materially:

```text
RETURN_PREFLIGHT_DRIFT
STOP_AT_REVIEWER=YES
```

## Backup / rollback

Before editing, create a project-scoped pre-change backup of the exact current Compose manifest under:

```text
/srv/backups/mini-craft-night-kit/manifests/
```

Record path, bytes and checksum only.

Rollback for any M2A failure:

1. restore exact pre-M2A Compose manifest;
2. recreate only the WordPress service using the explicit canonical Compose file/project;
3. verify WordPress returns to project DB network + `spikersun-edge` only;
4. verify MariaDB remained project-private;
5. verify current Caddy public route still works.

No Caddy/DNS/Tunnel rollback should be necessary because M2A must not touch them.

## Authorized write

Modify only:

`/srv/apps/mini-craft-night-kit/compose.production.yaml`

so that:

- existing `spikersun-private` is declared as an external network;
- WordPress joins it;
- WordPress receives alias `mini-craft-night-kit-wordpress` on that network;
- existing DB network stays unchanged;
- existing `spikersun-edge` stays unchanged;
- MariaDB is not attached to `spikersun-private`.

Do not rename existing services, volumes, networks, secrets, mounts, ports or project name.

## Compose safety

Before recreate:

- explicitly render/validate the exact canonical Compose file;
- confirm the resolved WordPress networks are exactly the intended three;
- confirm MariaDB remains exactly project DB network;
- confirm no unexpected host port appears;
- confirm no image/build/reference drift.

Then recreate only WordPress with the explicit canonical Compose project/file and no dependency recreation. Do not pull/build new images.

## Post-write verification

Must prove from target host:

```text
WORDPRESS_RUNNING=YES
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_HEALTHY=YES
MARIADB_ON_SPIKERSUN_PRIVATE=NO
WORDPRESS_HOST_PORTS=NONE
MARIADB_HOST_PORTS=NONE
```

From a disposable bounded probe attached to `spikersun-private` or from the existing cloudflared network namespace if possible without exposing config/token, verify:

```text
http://mini-craft-night-kit-wordpress:80
```

is reachable and returns expected WordPress HTTP behavior.

Do not read cloudflared env/command/token.

Also verify current public Mini Craft canonical hostname is still served by the existing Caddy route and basic Home/Shop/REST checks remain good.

## Forbidden

No:

- Cloudflare Dashboard write;
- DNS change;
- Tunnel/Public Hostname create/edit/delete;
- cloudflared restart/recreate;
- Caddyfile/write/reload/restart/recreate;
- shared network create/delete/recreate;
- MariaDB network attachment change;
- DB write/migration;
- WordPress content/config/business write;
- payment/provider/webhook action;
- Secret/token/private-key/session output;
- cleanup/prune;
- Unified Pay/Xianyu change.

## Evidence

Append execution facts to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not modify Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
TARGET_HOST_EXECUTION_PROVEN=PASS
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

Otherwise return one precise fail-closed reason and stop.
