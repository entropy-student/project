# Reviewer Decision — S1 Restore Canonical Shared VPS SSH Connection Contract

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Reason

Governance review confirmed that normal Shared VPS management is SSH-first. Hostinger Web Terminal / provider console is a recovery route, not the default management path.

During Mini Craft M1, one strict SSH probe failed before remote identity output and M1-R2 opened Hostinger Web Terminal as a bounded recovery path. Subsequent Gates continued using that recovery path longer than intended.

This decision corrects that execution-path drift.

## Current state

```text
TARGET_HOST=srv1970241
ADDRESS=2.24.193.133
SSH_PORT=22
CANONICAL_LOGIN_ROLE=ops

SSH_SERVER_SIDE_HEALTH=PASS_FROM_ACCEPTED_M1_R2
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE
PREVIOUS_DIRECT_SSH_FAILURE=PRE_IDENTITY_EXIT_255
HOSTINGER_WEB_TERMINAL=FALLBACK_RECOVERY_ONLY

M2E_ACTIVE_RUNTIME_RETIREMENT=PASS
M2E_RESTART_PERSISTENCE=NOT_PROVEN
M2E_FINAL_PASS=NO
M2E_R1_R3_TERMINAL_CAPTURE=STOPPED_INCOMPLETE
```

No Mini Craft runtime rollback is required from this correction.

## Governance basis

Canonical SSH contract requires the recovery order:

1. read `SHARED_VPS_HANDOFF.md`;
2. recover/verify the existing identity-file reference without reading private-key contents;
3. verify client public-key fingerprint;
4. verify expected host-key fingerprints from normal `known_hosts`;
5. perform one bounded strict read-only SSH identity probe;
6. compare target host/user/OS to the accepted baseline.

Canonical strict options remain:

```text
BatchMode=yes
IdentitiesOnly=yes
StrictHostKeyChecking=yes
```

Host-key mismatch must fail closed.

## Current Gate

```text
CURRENT_GATE=S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY

DIRECT_SSH_INVOCATIONS_AUTHORIZED=1
SSH_REPAIR_AUTHORIZED=NO
HOSTINGER_TERMINAL_USE_AUTHORIZED=NO_FOR_NORMAL_EXECUTION
```

## Source recovery

The exact non-secret SSH trust metadata is still pending promotion in canonical Shared VPS Handoff.

Executor may read the previously accepted Owner-workstation bootstrap handoff at:

```text
$HOME/Documents/ChatGPT/VPS基建/SHARED_VPS_HANDOFF.md
```

or the equivalent exact Owner-workstation path already used by the prior accepted M1-R1 run.

Allowed metadata extraction only:

- identity-file reference/path;
- client public-key fingerprint;
- expected SSH host-key fingerprints;
- normal known_hosts reference;
- canonical SSH user/host/port/options.

Do not read, print, copy, hash, or otherwise expose private-key contents.

If the bootstrap handoff is absent or inconsistent:

```text
RETURN_SSH_CONNECTION_REQUIRED
SSH_NETWORK_INVOCATIONS=0
STOP_AT_REVIEWER=YES
```

## Local trust preflight

Before any network invocation:

1. verify identity file exists;
2. verify permissions/ownership sufficiently restrictive for the platform;
3. derive the public key fingerprint from the private key without emitting private-key data;
4. require fingerprint to match:
   `SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw`;
5. verify normal known_hosts entries match all recorded expected host-key fingerprints for `2.24.193.133:22` / canonical hostname as applicable.

Any mismatch:

```text
RETURN_SSH_TRUST_DRIFT
SSH_NETWORK_INVOCATIONS=0
STOP_AT_REVIEWER=YES
```

Do not auto-accept a changed host key and do not modify known_hosts.

## Single bounded SSH probe

Only after local trust preflight PASS, perform exactly one strict non-interactive read-only SSH connection to:

```text
ops@2.24.193.133:22
```

using the recovered identity reference and canonical strict options.

Remote command may emit only safe identity/runtime metadata sufficient to prove:

```text
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
REMOTE_OS=Ubuntu 24.04 compatible baseline
SUDO_NONINTERACTIVE_AVAILABLE=YES|NO
DOCKER_READONLY_ACCESS=YES|NO
```

No mutation command.

Check native SSH exit status explicitly.

## Result classification

If connection succeeds and identity matches:

```text
PASS_CANDIDATE_S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
SSH_NORMAL_PATH=RESTORED
TARGET_HOST_EXECUTION_PROVEN=PASS
SSH_NETWORK_INVOCATIONS=1
STOP_AT_REVIEWER=YES
```

If the single connection again fails before remote identity:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
SSH_NORMAL_PATH=UNAVAILABLE
SSH_NETWORK_INVOCATIONS=1
STOP_AT_REVIEWER=YES
```

Do not retry in the same Gate.

If host/user identity differs:

```text
RETURN_TARGET_HOST_IDENTITY_MISMATCH
STOP_AT_REVIEWER=YES
```

## Hard boundary

No SSH repair; no `authorized_keys`, sshd, sudo, UFW, fail2ban, known_hosts, key creation/rotation, Docker, Caddy, cloudflared, DNS, Tunnel, Compose, WordPress, MariaDB, payment, cleanup, or other VPS mutation.

## After PASS

Reviewer will:

1. promote the exact non-secret identity reference and expected host-key fingerprints into canonical `SHARED_VPS_HANDOFF.md`;
2. mark SSH as the normal path;
3. retain Hostinger Web Terminal as fallback only;
4. reopen the unfinished M2E persistence/restart-safe reconciliation through SSH rather than browser-terminal automation.
