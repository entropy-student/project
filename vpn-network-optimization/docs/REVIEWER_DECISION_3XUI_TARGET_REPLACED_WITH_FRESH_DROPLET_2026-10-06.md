# Reviewer Decision — Replace Existing VPS Target with Fresh Droplet

Status: PASS / TARGET_REPLACED_BY_OWNER

Date: 2026-10-06

## Decision

Owner supplied a newly created DigitalOcean droplet and selected it as the new 3x-ui target.

The previously released Gate:

`3XUI_FASTPATH_P0_EXISTING_VPS_DISCOVERY`

is **SUPERSEDED_NOT_EXECUTED**.

No discovery or mutation of the old VPS is required for the new fast path.

## Owner-provided target facts

From the Owner screenshot:

```text
PROVIDER=DigitalOcean
DROPLET_STATUS=Active
HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
REGION=SFO3
PUBLIC_IPV4=143.198.159.233
PRIVATE_IPV4=10.124.0.2
OS_DISPLAY=Ubuntu 24.04 (LTS) x64
PLAN_LABEL=1vCPU / 512MB / 10GB
CREATED_AS_NEW_TARGET=YES
```

Old VPS `24.199.118.137` remains outside the active mutation scope and continues to provide the Owner's current working VPN path.

## Architecture decision

Use:

- fresh target `143.198.159.233`;
- 3x-ui stable `v3.9.0`;
- SQLite default;
- panel bound to loopback after installation;
- management through strict SSH / local tunnel / protected local API calls;
- target nodes: Hysteria2, WireGuard, VLESS + REALITY + Vision;
- Mihomo subscription for Clash Verge;
- no migration of legacy custom VPN configuration.

## Security boundary

Because this is a new SSH host, first-host trust must be explicitly established from an independently observed host-key fingerprint before automated SSH.

Owner supplies only the non-secret ED25519 host-key fingerprint from the DigitalOcean Web Console. Executor may then fetch the public host key, verify the fingerprint, add that exact verified key to the explicit known-host file, and proceed with strict SSH.

The private SSH key value is never emitted or copied.

## Legacy boundary

The old VPS and all legacy G1-G4/R19-R22 custom deployment material remain historical/reference-only and are not modified by this cutover.
