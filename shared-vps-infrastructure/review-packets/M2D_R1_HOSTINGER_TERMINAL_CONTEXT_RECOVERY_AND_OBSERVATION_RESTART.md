# M2D-R1 — Hostinger Terminal Context Recovery + Observation Restart

## Gate

```text
M2D_R1_HOSTINGER_TERMINAL_CONTEXT_RECOVERY_AND_OBSERVATION_RESTART
OWNER_BROWSER_CHECKPOINT=YES
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Owner action first

Open the Hostinger browser terminal for the target VPS and wait until the shell is visibly ready. Leave that tab open.

Do not send credentials, tokens, private keys, or Secret values to chat.

## Executor read first

Read latest canonical Governance and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2D_RETURN_R1_HOSTINGER_TERMINAL_CONTEXT_RECOVERY.md
shared-vps-infrastructure/review-packets/M2D_PUBLIC_REGRESSION_AND_OBSERVATION.md
```

## Phase A — terminal context proof

Bind to the active Hostinger terminal.

Run only bounded read-only identity output sufficient to prove:

```text
HOSTINGER_TERMINAL_CONTEXT=VERIFIED
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=<safe username>
```

Do not inspect shell history, environment values, credentials, or Secret files.

If binding/read still fails:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
T0=NOT_STARTED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not retry direct SSH.

## Phase B — restart original M2D from fresh T0

Only after Phase A PASS, execute:

`shared-vps-infrastructure/review-packets/M2D_PUBLIC_REGRESSION_AND_OBSERVATION.md`

from the beginning.

The previous incomplete attempt counts as zero checkpoints.

Required real observation cadence:

```text
T0
T+5 minutes
T+10 minutes
```

Do not compress these into one instant.

## Hard boundary

All operations remain read-only:

```text
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
```

No rollback. No M2E.

## Result

If terminal context cannot be recovered, return the precise failure above.

If recovered, return the normal original M2D result after all three actual checkpoints.
