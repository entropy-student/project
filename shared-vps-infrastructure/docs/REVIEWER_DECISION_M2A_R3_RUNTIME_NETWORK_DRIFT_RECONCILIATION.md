# Reviewer Decision — M2A-R3 Runtime Network Drift Reconciliation

Date: 2026-09-29  
Role: Reviewer / Architect / Gatekeeper

## Reviewed RETURN

```text
RESULT=RETURN_PREFLIGHT_DRIFT
TARGET_HOST=srv1970241
OBSERVED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
EXISTING_BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
MARIADB_NETWORKS=mini-craft-night-kit-database
COMPOSE_FILE_MODIFICATION=0
WORDPRESS_RECREATE=0
DOCKER_NETWORK_MUTATIONS_THIS_ATTEMPT=0
STOP_AT_REVIEWER=YES
```

The RETURN is correct.

## Current inconsistency

The canonical Compose source and its verified pre-change backup are byte-identical and remain on the sealed pre-M2A hash.

However, the running WordPress container is now attached to `spikersun-private`, while the sealed pre-M2A source does not declare that network.

Therefore:

```text
COMPOSE_SOURCE_DRIFT=NO_PROVEN_DRIFT
RUNTIME_NETWORK_DRIFT=YES_UNEXPLAINED
M2A_WRITE_AUTHORIZATION=SUSPENDED
```

No conclusion is made about cause. The extra network membership may have arisen from an earlier partial/manual network attachment, a previously unrecorded runtime operation, or another mechanism. It must be proven from read-only runtime evidence.

## Current Gate

```text
CURRENT_GATE=M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
CURRENT_GATE_STATUS=READ_ONLY_ONLY
```

## Goal

Determine:

1. whether `spikersun-private` was attached directly to the existing WordPress container or through a Compose-managed recreate;
2. the exact aliases currently assigned on `spikersun-private`;
3. whether the desired alias `mini-craft-night-kit-wordpress` is already present;
4. whether the current private origin is reachable;
5. whether the running container otherwise still matches the accepted Mini Craft deployment;
6. what exact minimal write is required to reconcile source-of-truth and runtime.

## Required read-only evidence

From `srv1970241` via accepted Hostinger Web Terminal:

- WordPress container ID/name, Created, StartedAt, restart count;
- exact network names and aliases per network;
- `spikersun-private` endpoint metadata for WordPress;
- MariaDB networks and health;
- current Compose source hash;
- current Compose network declarations only;
- Docker Compose project/config labels;
- filtered Docker event history around the M2A window if retained, limited to timestamps + network/container connect/disconnect/create/start/die/recreate actions;
- current public Home/Shop/REST smoke;
- private-origin DNS resolution and HTTP reachability for any currently present private alias.

Do not print environment values, Secret values, Docker command/env blocks, provider tokens, cookies, or raw broad logs.

## Classification

Return exactly one:

```text
RUNTIME_NETWORK_DRIFT_CLASS=DIRECT_RUNTIME_NETWORK_ATTACH
RUNTIME_NETWORK_DRIFT_CLASS=COMPOSE_MANAGED_RECREATE
RUNTIME_NETWORK_DRIFT_CLASS=PREVIOUSLY_ACCEPTED_OPERATION
RUNTIME_NETWORK_DRIFT_CLASS=UNRESOLVED
```

Also return:

```text
WORDPRESS_PRIVATE_ALIAS_PRESENT=YES|NO
WORDPRESS_PRIVATE_ALIAS_VALUE=
PRIVATE_ORIGIN_REACHABILITY=PASS|FAIL|NOT_TESTABLE
SOURCE_RUNTIME_RECONCILIATION_REQUIRED=YES|NO
```

## Compose validation note

The prior `docker compose config --quiet` failed because deployment environment variables were not supplied. R3 may identify the canonical non-secret Compose environment-file/reference metadata or use a no-interpolation structural validation path, but must not read Secret values.

No Compose render is required to PASS R3 if the source network declarations can be safely established read-only.

## Forbidden

No Compose edit, backup creation/deletion, service/container recreate/restart, Docker network connect/disconnect, Caddy/Cloudflare/DNS change, MariaDB/application write, payment/provider action, Secret access, cleanup, or SSH retry.

## Result

Success:

```text
PASS_CANDIDATE_M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION
RUNTIME_NETWORK_DRIFT_CLASS=<one allowed value>
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

R3 PASS does not itself authorize a write.
