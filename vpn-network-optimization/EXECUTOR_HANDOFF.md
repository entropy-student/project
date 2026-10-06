# VPN Network Optimization — EXECUTOR HANDOFF

## Current execution status — 3x-ui Existing VPS Discovery P0

```text
GATE_ID=3XUI_FASTPATH_P0_EXISTING_VPS_DISCOVERY
STATE=READY_FOR_EXECUTOR
TARGET=24.199.118.137
TARGET_HOSTNAME_EXPECTED=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_OS_EXPECTED=Ubuntu_24.04
EXECUTION_MODE=STRICT_SSH_READONLY
TARGET_MUTATION_ALLOWED=NO
SECRET_OUTPUT_ALLOWED=NO
STOP_AT_REVIEWER=YES
```

## REVIEWER_TO_EXECUTOR_RELAY

Start only from:

1. `docs/3X_UI_P0_EXISTING_VPS_DISCOVERY.md`
2. current `REVIEWER_HANDOFF.md`

Do not reconstruct the old VPN project.

Use the existing local SSH identity/known-host metadata if available. Do not auto-accept a host-key change.

Run only the bounded read-only target discovery defined by the Gate, append sanitized proof to `EXECUTION_EVIDENCE.md`, and return the standard completion packet.

Do not install 3x-ui, stop old VPN services, change ports, change firewall, or enter P1.

## Owner relay

NONE unless strict SSH itself cannot proceed safely.
