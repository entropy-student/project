# K9B-R2R2A-R1 — Target Host Access Recovery

Status: AUTHORIZED_READONLY_TRANSPORT_DIAGNOSTICS
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R2R2A_RETURN_TARGET_ACCESS_RECOVERY.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract rev2

## Purpose

Restore a trustworthy strict SSH target-host execution boundary.

No Product 1224 mutation in this Gate.
No local cleanup.
No Docker mutation.

## Phase A — local SSH baseline

Read-only record:

```text
LOCAL_SSH_CLIENT_VERSION=
LOCAL_TARGET_ALIAS_OR_HOST_METADATA=
LOCAL_TARGET_USER=
LOCAL_TARGET_PORT=
LOCAL_KEY_PATH_EXISTS=
LOCAL_KEY_PUBLIC_FINGERPRINT=
LOCAL_KNOWN_HOST_ENTRY_PRESENT=
LOCAL_KNOWN_HOST_FINGERPRINT=
```

Compare only against previously accepted non-secret project Evidence.

Do not print private-key content or credential material.

## Phase B — network reachability

Check:
- target DNS resolution if hostname-based;
- TCP reachability to configured SSH port.

Record normalized result only.

Do not scan unrelated ports.

## Phase C — bounded strict identity attempt

Maximum 2 new SSH network attempts for the whole Gate.

Required strict properties:
- BatchMode yes;
- IdentitiesOnly yes;
- explicit accepted key;
- StrictHostKeyChecking yes;
- explicit known_hosts file;
- bounded timeout / keepalive;
- identity-only remote command.

Desired remote command is equivalent to:
`hostname && id -un`

Do not send application or mutation commands.

## Safe correction

If local read-only baseline proves a non-secret local invocation mismatch against accepted project Evidence, correct only that local invocation and retry once.

Do not:
- disable host-key checking;
- auto-accept a new host key;
- rewrite known_hosts;
- rotate keys;
- edit server configuration;
- use password auth;
- touch VPS firewall/sshd.

Host-key mismatch => immediate RETURN.

## PASS

```text
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
STRICT_HOST_KEY_MATCH=PASS
NATIVE_EXIT=0
TARGET_HOST_EXECUTION_PROVEN=PASS
```

Then persist Evidence/Handoff and stop at Reviewer.

Do not resume Product 1224 containment in the same execution.

## RETURN classes

```text
RETURN_K9B_R2R2A_R1_SSH_TRANSPORT_UNAVAILABLE
RETURN_K9B_R2R2A_R1_HOST_KEY_MISMATCH
RETURN_K9B_R2R2A_R1_LOCAL_SSH_CONFIGURATION_UNRESOLVED
```

## Evidence

```text
GATE=K9B_R2R2A_R1_TARGET_HOST_ACCESS_RECOVERY
LOCAL_SSH_CLIENT_VERSION=
LOCAL_TARGET_CONFIG_MATCHES_ACCEPTED_BASELINE=
LOCAL_KEY_PUBLIC_FINGERPRINT_MATCH=
LOCAL_KNOWN_HOST_METADATA_MATCH=
DNS_RESOLUTION=
SSH_TCP_REACHABILITY=
SSH_NETWORK_ATTEMPTS=
SSH_FAILURE_CLASS=
REMOTE_HOSTNAME=
REMOTE_USER=
STRICT_HOST_KEY_MATCH=
NATIVE_EXIT=
TARGET_HOST_EXECUTION_PROVEN=
VPS_MUTATIONS=0
PRODUCT_MUTATIONS=0
LOCAL_FILESYSTEM_MUTATIONS=0
LOCAL_DOCKER_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
STOP_AT_REVIEWER=YES
```
