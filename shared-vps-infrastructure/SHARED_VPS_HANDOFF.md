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
IDENTITY_FILE_REFERENCE=PENDING_PROMOTION_FROM_ACCEPTED_OWNER_LOCAL_HANDOFF
EXPECTED_HOST_KEY_FINGERPRINTS=PENDING_PROMOTION_FROM_ACCEPTED_OWNER_LOCAL_HANDOFF
KNOWN_HOSTS_REFERENCE=OWNER_NORMAL_KNOWN_HOSTS
STRICT_OPTIONS=BatchMode=yes;IdentitiesOnly=yes;StrictHostKeyChecking=yes
```

The exact private-key path/value is intentionally not stored here. Historical accepted Mini Craft Evidence proves that an Owner-workstation Shared VPS handoff existed and that its identity reference, client public fingerprint and three pinned host-key entries were repeatedly verified. M1-R1 may use that historical local handoff only as a bounded bootstrap source to recover the exact non-secret trust metadata.

The local historical handoff is not a competing canonical project truth. After M1-R1 proves the current trust tuple, Reviewer should promote the exact non-secret identity reference / host-key fingerprints here.

## 3. Privilege model

```text
REMOTE_USER=ops
PASSWORDLESS_SUDO=PREVIOUSLY_ACCEPTED
DOCKER_ACCESS=VIA_REVIEWED_REMOTE_COMMANDS
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
SSH_CONNECTION_CONTRACT=PARTIAL_CANONICAL_METADATA_S1_RECOVERY_OPEN
NORMAL_MANAGEMENT_PATH=STRICT_SSH
CANONICAL_REMOTE_USER=ops
HOST_IDENTITY=ACCEPTED_HISTORICAL_srv1970241
SSH_SERVER_SIDE_HEALTH=PASS_FROM_M1_R2_BASELINE
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE_FOR_PRIOR_INTERMITTENT_CLIENT_FAILURES
FALLBACK_RECOVERY_ROUTE=HOSTINGER_WEB_TERMINAL
CURRENT_GATE=S1_RESTORE_CANONICAL_SSH_CONNECTION_CONTRACT
LAST_VERIFIED=2026-09-30
```
