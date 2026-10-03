# S1 — Restore Canonical Shared VPS SSH Connection Contract

## Gate

```text
S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
READ_ONLY_ONLY=YES
SSH_NETWORK_INVOCATIONS_MAX=1
STOP_AT_REVIEWER=YES
```

## Read first

Read latest canonical Governance, especially:

```text
vps-project-governance/references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md
vps-project-governance/references/TARGET_HOST_REALITY_CONTRACT.md
```

Then read project canonical:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT.md
```

Do not use Hostinger Web Terminal in this Gate.

## Phase A — recover existing SSH trust metadata locally

Read the previously accepted Owner-workstation bootstrap handoff:

```text
$HOME/Documents/ChatGPT/VPS基建/SHARED_VPS_HANDOFF.md
```

or its exact equivalent path already used by the accepted M1-R1 run.

Extract only:

```text
IDENTITY_FILE_REFERENCE=
EXPECTED_CLIENT_PUBLIC_KEY_FINGERPRINT=
EXPECTED_HOST_KEY_FINGERPRINTS=
KNOWN_HOSTS_REFERENCE=
SSH_HOST=
SSH_PORT=
SSH_USER=
STRICT_OPTIONS=
```

Never output private-key contents.

If bootstrap handoff is unavailable:

```text
RETURN_SSH_CONNECTION_REQUIRED
SSH_NETWORK_INVOCATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase B — local no-network trust preflight

Verify:

```text
IDENTITY_FILE_EXISTS=YES
CLIENT_PUBLIC_KEY_FINGERPRINT=SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw
CLIENT_PUBLIC_KEY_FINGERPRINT_MATCH=YES
KNOWN_HOSTS_EXPECTED_PINS_MATCH=YES
```

Verify file permission/ACL metadata without reading private-key contents.

Do not edit the identity file or known_hosts.

Any trust mismatch:

```text
RETURN_SSH_TRUST_DRIFT
SSH_NETWORK_INVOCATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase C — exactly one strict SSH identity probe

Only after Phase A+B PASS, perform exactly one SSH invocation.

Target:

```text
ops@2.24.193.133
port=22
```

Required options include:

```text
BatchMode=yes
IdentitiesOnly=yes
StrictHostKeyChecking=yes
```

Use the recovered exact identity file and normal known_hosts.

Remote command must be read-only and return bounded safe metadata only:

```text
hostname
id -un
OS release/version summary
sudo -n true result only
bounded Docker read-only access result only
```

Do not dump environment, shell history, credentials, Docker env, Secrets, configs, database data, or tokens.

Explicitly capture native SSH exit status.

## Phase D — classify

PASS requirements:

```text
SSH_NATIVE_EXIT=0
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
TARGET_HOST_EXECUTION_PROVEN=PASS
```

Then return:

```text
PASS_CANDIDATE_S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
SSH_NORMAL_PATH=RESTORED
IDENTITY_FILE_REFERENCE=<non-secret exact reference>
CLIENT_PUBLIC_KEY_FINGERPRINT=SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw
EXPECTED_HOST_KEY_FINGERPRINTS=<non-secret exact fingerprints>
KNOWN_HOSTS_REFERENCE=<non-secret reference>
SSH_NATIVE_EXIT=0
REMOTE_HOSTNAME=srv1970241
REMOTE_USER=ops
SUDO_NONINTERACTIVE_AVAILABLE=YES|NO
DOCKER_READONLY_ACCESS=YES|NO
SSH_NETWORK_INVOCATIONS=1
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

If the one strict invocation fails:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
SSH_NATIVE_EXIT=<exact>
REMOTE_IDENTITY=UNPROVEN
SSH_NETWORK_INVOCATIONS=1
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not retry.

## Forbidden

No Hostinger Web Terminal; no browser-terminal fallback; no SSH repair; no key/known_hosts mutation; no service restart/reload; no VPS/Docker/Caddy/cloudflared/DNS/Tunnel/Compose/WordPress/MariaDB/payment/cleanup mutation.

## Evidence

If GitHub access is healthy, append the result once to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both.

If GitHub access fails, return the complete bounded result to Reviewer; do not use a stale local Git worktree as a substitute and do not change runtime state.
