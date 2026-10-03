# M2E-R2 — Caddy Recreate Preflight

## Gate

```text
M2E_R2_CADDY_RECREATE_PREFLIGHT
READ_ONLY_ONLY=YES
NORMAL_ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

Read:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R1_PASS_R2_CADDY_RECREATE_PREFLIGHT.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use strict SSH to `ops@2.24.193.133:22` from canonical Handoff. Use bounded `sudo docker ...` read-only commands as needed.

No Hostinger Web Terminal.

## Phase A — exact Caddy deployment identity

Freshly prove the current Caddy container still matches:

```text
CADDY_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE=running
CADDY_RESTART_COUNT=0
```

Read only the safe Docker/Compose metadata needed to identify:

```text
CADDY_COMPOSE_PROJECT=
CADDY_COMPOSE_SERVICE=
CADDY_COMPOSE_WORKING_DIR=
CADDY_CANONICAL_COMPOSE_PATH=
CADDY_IMAGE_REFERENCE=
CADDY_IMAGE_ID=
CADDY_RESTART_POLICY=
```

Do not print environment values or broad raw inspect JSON.

If the running Caddy is not Compose-managed or the canonical config source is ambiguous, return the deployment-source unresolved result.

## Phase B — recreate-critical runtime shape

Read safe structural metadata only:

```text
CADDY_PUBLISHED_PORTS=
CADDY_NETWORKS=
CADDY_MOUNTS=
```

For mounts, record only type/source/destination/read-write semantics and named volume identities. Do not read Secret contents.

Identify persistence-critical Caddy data/config volumes and prove they are external/persistent across service recreate where applicable.

## Phase C — canonical Compose semantic validation

Without mutation:

1. verify the canonical Compose file exists;
2. run quiet/non-rendering validation appropriate to the current deployment;
3. verify the Caddy service in that definition reproduces the running service's relevant image, ports, networks and mounts;
4. prove the current host Caddyfile remains:
   - 143 bytes;
   - SHA-256 `f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358`;
   - Mini Craft matcher absent;
5. validate the current host Caddy config without reloading or writing.

Do not output Secret-bearing rendered configuration.

If semantic drift is material or validation cannot be done safely:

```text
RETURN_M2E_R2_CADDY_DEPLOYMENT_DRIFT
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase D — exact future command proposal

Construct but do not run an exact command proposal that recreates only the Caddy service.

It must guarantee:

```text
RECREATE_SCOPE=CADDY_ONLY
DEPENDENCY_RECREATE=NO
PULL=NO
BUILD=NO
OTHER_SERVICE_RECREATE=NO
```

Prefer the current canonical Compose definition and an explicit no-dependency force-recreate operation. If the installed Compose version supports an explicit no-build/no-pull control, include it. Otherwise prove from command semantics that no build/pull is triggered.

Record:

```text
CADDY_RECREATE_COMMAND_PROPOSAL=
```

Do not execute.

## Phase E — regression baseline

Identify and read-only check all public endpoints currently served by shared Caddy that can be safely derived from the current host config, without exposing config contents wholesale.

At minimum preserve the previously accepted edge-test/localhost route semantics where applicable.

Also verify Mini Craft remains healthy independently via Tunnel:

```text
MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY=0
```

## Phase F — future rollback/recovery proposal

Return a concise future failure plan, without executing it.

The future write Gate must avoid blind repeated recreate.

If the recreated Caddy does not become healthy:

- fresh-read container/service state first;
- use the same canonical Compose definition to restore the Caddy service only;
- preserve the current 143-byte host Caddyfile;
- do not restore the old 199-byte Mini Craft matcher merely to recover Caddy;
- do not change Cloudflare/DNS/Tunnel.

Record:

```text
CADDY_RECREATE_FAILURE_RECOVERY_PLAN=<concise proposal>
```

## Hard boundary

```text
CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
CADDY_RECREATES=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
SSH_REPAIR_MUTATIONS=0
PAYMENT_ACTIONS=0
```

## Evidence

If GitHub connector is healthy, append once to Evidence/Handoff and fresh-read. If transport fails, return the complete result to Reviewer; do not use a stale local worktree.

## Result

```text
PASS_CANDIDATE_M2E_R2_CADDY_RECREATE_PREFLIGHT
CADDY_COMPOSE_PROJECT=<exact>
CADDY_COMPOSE_SERVICE=<exact>
CADDY_CANONICAL_COMPOSE_PATH=<exact>
PRE_RECREATE_CADDY_CONFIG_VALID=PASS
CADDY_RECREATE_COMMAND_PROPOSAL=<exact>
RECREATE_SCOPE=CADDY_ONLY
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
OTHER_SERVICE_RECREATE=NO
MUTATIONS=0
STOP_AT_REVIEWER=YES
```
