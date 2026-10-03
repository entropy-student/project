# M2E-R1-R3 — Missing Caddy Runtime Identity Capture

## Gate

```text
M2E_R1_R3_MISSING_CADDY_RUNTIME_IDENTITY_CAPTURE
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R1_R2_RETURN_R3_MISSING_RUNTIME_IDENTITY_CAPTURE.md
```

## Objective

Do not retry GitHub persistence.

Use the already-open accepted Hostinger Web Terminal to capture only:

```text
TARGET_HOST=
CADDY_CONTAINER_ID=
CADDY_CONTAINER_NAME=
CADDY_STATE=
CADDY_RESTART_COUNT=
```

No broad Docker JSON/output is needed.

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
VPS_MUTATIONS=0
PAYMENT_ACTIONS=0
```

Do not use direct SSH.

## Result

```text
PASS_CANDIDATE_M2E_R1_R3_MISSING_CADDY_RUNTIME_IDENTITY_CAPTURE
TARGET_HOST=srv1970241
CADDY_CONTAINER_ID=<exact>
CADDY_CONTAINER_NAME=<exact>
CADDY_STATE=running
CADDY_RESTART_COUNT=0
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Reviewer will perform GitHub persistence after these two missing identity fields are returned.
