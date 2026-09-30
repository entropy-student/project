# Shared VPS — SHARED VPS HANDOFF

> Maintainer: Shared Infrastructure Reviewer  
> Secret/private-key values: NEVER record here

## 1. Host identity

```text
HOSTNAME=srv1970241
ADDRESS=2.24.193.133
SSH_PORT=22
LOGIN_ROLE=ops
OS=Ubuntu 24.04
```

Last accepted server-side read-only baseline: 2026-09-29.

## 2. SSH trust metadata

```text
CLIENT_PUBLIC_KEY_FINGERPRINT=SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw
IDENTITY_FILE_REFERENCE=C:\Users\34707\.ssh\xianyu_hostinger_codex_ed25519
EXPECTED_HOST_KEY_FINGERPRINTS=SHA256:yr2b1z2fZmMU+8IwnTB8M94H1VlO+U3CIZk1S3FOa+o;SHA256:L7lXm/ssbbeeHG6OlRis2dreMW+SGzeJoMeGu6xzngw;SHA256:QS8B89XaTDpt3s+74W55W4jQzrjwfrEc/Q0FfWp8uZc
KNOWN_HOSTS_REFERENCE=C:\Users\34707\.ssh\known_hosts
STRICT_OPTIONS=BatchMode=yes;IdentitiesOnly=yes;StrictHostKeyChecking=yes;UserKnownHostsFile=C:\Users\34707\.ssh\known_hosts;ConnectionAttempts=1;ConnectTimeout=10;ForwardAgent=no
```

The private-key contents are never stored here. S1 on 2026-09-30 re-verified the existing Owner-workstation identity reference, client public-key fingerprint and all three normal known_hosts pins, then completed exactly one strict SSH probe to ops@srv1970241 with native exit 0. The metadata above is now the canonical non-secret SSH connection contract.

## 3. Privilege model

```text
REMOTE_USER=ops
PASSWORDLESS_SUDO=YES_VERIFIED_2026-09-30
DIRECT_DOCKER_SOCKET_ACCESS=NO
DOCKER_ACCESS=VIA_REVIEWED_SUDO_DOCKER_COMMANDS
```

Fresh privilege state must be re-read before consequential writes.

## 4. Shared infrastructure inventory

```text
HOST_PORT_80_443_OWNER=shared Caddy
REVERSE_PROXY=Caddy
TUNNEL=cloudflared
SHARED_NETWORKS=spikersun-edge;spikersun-private
```

Current project/runtime detail belongs in `REVIEWER_HANDOFF.md` and `SHARED_VPS_PORTFOLIO.md`.

## 5. Connection recovery

Preferred:

1. Read this canonical handoff.
2. For the still-unpromoted exact identity/host-key fields, read the previously accepted Owner-workstation local Shared VPS handoff at `$HOME/Documents/ChatGPT/VPS基建/SHARED_VPS_HANDOFF.md` if present.
3. Verify identity-file existence and public fingerprint without reading private-key contents.
4. Verify the normal `known_hosts` pins.
5. Attempt one bounded strict read-only SSH probe.
6. Promote exact non-secret trust metadata here only after Reviewer acceptance.

If the local bootstrap handoff is missing/unusable:

```text
RETURN_SSH_CONNECTION_REQUIRED
```

If strict SSH cannot prove target-host identity:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
```

Provider-panel recovery route: authenticated Hostinger Browser Terminal / Web Console, bounded metadata/read-only unless a separate mutation Gate authorizes more.

This provider-panel route is **fallback/recovery only**. It is not the normal management path. Normal Shared VPS management should use the verified strict SSH contract whenever that contract is available.

## 6. Change boundaries

Shared Caddy, cloudflared/Tunnel, shared networks, host 80/443, SSH, UFW and Docker daemon are Shared Infrastructure and require a Shared Infra Gate.

Owner-only remains required for irreversible deletion, account/identity authorization, Secret authority/rotation, real payment/refund and material production enablement.

## 7. Current status

```text
SSH_CONNECTION_CONTRACT=PASS_VERIFIED_2026-09-30
NORMAL_MANAGEMENT_PATH=STRICT_SSH
CANONICAL_REMOTE_USER=ops
TARGET_HOST=srv1970241
SSH_NATIVE_EXIT=0
TARGET_HOST_EXECUTION_PROVEN=PASS
PASSWORDLESS_SUDO=YES
DIRECT_DOCKER_SOCKET_ACCESS=NO
DOCKER_ACCESS_METHOD=SUDO_DOCKER
FALLBACK_RECOVERY_ROUTE=HOSTINGER_WEB_TERMINAL
HOSTINGER_WEB_TERMINAL_ROLE=FALLBACK_ONLY
LAST_VERIFIED=2026-09-30
```
