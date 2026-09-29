# Reviewer Decision — M1-R2 PASS / R3 Architecture Completion

Date: 2026-09-29  
Role: Reviewer / Architect / Gatekeeper

## R2 Owner-console checkpoint accepted

Reviewer accepts the Owner-local Hostinger Web Terminal read-only checkpoint.

Accepted facts:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root
KERNEL=Linux 6.8.0-139-generic x86_64 GNU/Linux

SSH_SERVICE_ACTIVE=active
SSH_PORT22_LISTENING=YES
SSH_PREAUTH_CLOSE_COUNT_LAST_2H=6
SSH_MAXSTARTUPS_OR_THROTTLE_COUNT=0
SSH_FATAL_COUNT=0
SSH_MAXSTARTUPS=10:30:100
SSH_MAXSESSIONS=10
SSH_MAXAUTHTRIES=6
SSH_LOGINGRACETIME=120
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE

MUTATIONS=0
SSH_NETWORK_INVOCATIONS=0
SECRET_CONTENT_READS=0
```

Current server-side SSH state is healthy enough that no SSH repair Gate is justified from current evidence. Direct SSH remains intermittently unavailable, but the concrete root cause is unresolved.

```text
SSH_SERVER_SIDE_HEALTH=PASS
SSH_DIRECT_PATH=INTERMITTENT_UNAVAILABLE
SSH_REPAIR_AUTHORIZED=NO
```

## Important Target Host Reality clarification

The R2 recovery path is an authenticated provider console. For this read-only recovery Gate, `root@srv1970241` proves the target host and execution boundary.

The original `ops@srv1970241` requirement applied to the normal SSH connection contract. It is not a universal requirement that all target-host evidence must be produced by the `ops` account.

Therefore:

```text
TARGET_HOST_EXECUTION_PROVEN=PASS
M1_B_I_MAY_RESUME_USING_ACCEPTED_CONSOLE_READONLY_EVIDENCE=YES
```

No claim is made that the normal SSH path is repaired.

## Accepted M1 host-topology facts

```text
MINICRAFT_WORDPRESS_NETWORKS=PROJECT_DB_NETWORK+spikersun-edge
MINICRAFT_MARIADB_NETWORKS=PROJECT_DB_NETWORK_ONLY
SPIKERSUN_PRIVATE_ATTACHMENTS=UNIFIED_PAY+DUJIAO+XIANYU+CLOUDFLARED
MINICRAFT_COMPOSE_SOURCE=/srv/apps/mini-craft-night-kit/compose.production.yaml
RELATED_CONTAINER_RESTART_COUNTS=0
CLOUDFLARED_TOKEN_OR_ENV_READ=NO
```

Exact per-network alias values and complete Compose rendered network declarations remain to be frozen before a mutation plan is authorized.

## Current Gate

```text
CURRENT_GATE=M1_R3_MINICRAFT_TUNNEL_ARCHITECTURE_COMPLETION
CURRENT_GATE_STATUS=READONLY_RECONCILIATION
```

R3 must finish only the remaining M1 architecture questions:

1. exact aliases / collision-safe origin naming;
2. exact Mini Craft Compose network declaration feasibility;
3. cloudflared local mode/network metadata;
4. Dujiao remote-managed Tunnel public-hostname -> service target;
5. temporary Tunnel canary feasibility;
6. target architecture selection;
7. exact M2 mutation units and rollback.

No runtime/control-plane mutation is authorized.

## Architecture decision boundary

R3 must return exactly one:

```text
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP
TARGET_ARCHITECTURE=TUNNEL_TO_CADDY
TARGET_ARCHITECTURE=OTHER_REVIEW_REQUIRED
TARGET_ARCHITECTURE=UNRESOLVED
```

If Cloudflare route metadata is necessary but no authenticated read-only Cloudflare session is available:

```text
RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

R3 PASS does not authorize M2.
