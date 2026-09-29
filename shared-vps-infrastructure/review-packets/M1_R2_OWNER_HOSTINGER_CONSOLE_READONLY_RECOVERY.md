# M1-R2 — Owner Hostinger Console Read-only Recovery

## Gate

```text
M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY
OWNER_LOCAL_READONLY_CHECKPOINT=YES
STOP_AT_REVIEWER=YES
```

## Why this Gate exists

Two bounded attempts have failed to prove target-host execution:

1. browser automation could see Hostinger Web Terminal but could not type into it;
2. direct strict SSH then passed all local trust prechecks but the server closed the connection before remote identity output.

Do not repeat either failure path blindly.

## Owner action

Reviewer/Executor must provide exactly one read-only Bash command block for the Owner to paste into the already-open Hostinger Web Terminal.

The block must:

- emit only bounded non-secret metadata;
- prove `hostname=srv1970241`;
- report current console user;
- report ssh service/listener health;
- report safe effective sshd pre-auth limits;
- classify recent SSH failures by count/pattern without dumping secrets or broad logs;
- report Mini Craft/Caddy/cloudflared/Docker network topology required by M1;
- avoid cloudflared command/env output because it may contain a Tunnel token;
- perform zero writes.

If any command would expose token/env/Secret content, omit that probe.

## Required markers

```text
TARGET_HOST=
CONSOLE_USER=
SSH_SERVICE_ACTIVE=
SSH_PORT22_LISTENING=
SSH_SERVER_SIDE_HEALTH=
SSH_PREAUTH_CLOSE_COUNT=
SSH_MAXSTARTUPS_OR_THROTTLE_COUNT=

MINICRAFT_WORDPRESS_CONTAINER=
MINICRAFT_WORDPRESS_NETWORKS=
MINICRAFT_WORDPRESS_ALIASES=
MINICRAFT_MARIADB_NETWORKS=
WORDPRESS_HOST_PORTS=
MARIADB_HOST_PORTS=

SPIKERSUN_PRIVATE_ATTACHMENTS=
SPIKERSUN_PRIVATE_ALIAS_COLLISION_CANDIDATE=

CLOUDFLARED_CONTAINER=
CLOUDFLARED_STATE=
CLOUDFLARED_IMAGE=
CLOUDFLARED_NETWORKS=
CLOUDFLARED_TOKEN_OR_ENV_READ=NO

CADDY_CONTAINER=
CADDY_STATE=
CADDY_IMAGE=
CADDY_NETWORKS=

MUTATIONS=0
```

## Stop rules

Wrong host:

```text
RETURN_TARGET_HOST_IDENTITY_MISMATCH
STOP_AT_REVIEWER=YES
```

Concrete server-side SSH blocker:

```text
RETURN_SSH_SERVER_SIDE_REPAIR_REQUIRED
STOP_AT_REVIEWER=YES
```

Healthy server side:

```text
PASS_CANDIDATE_M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY
SSH_SERVER_SIDE_HEALTH=PASS
STOP_AT_REVIEWER=YES
```

Do not repair SSH or continue to M2.
