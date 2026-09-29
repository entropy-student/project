# Reviewer Decision — M1-R1 RETURN Accepted / R2 Owner Console Read-only Recovery

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

```text
GATE=M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME
RESULT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
EVIDENCE_COMMIT=0f9f5674dfa4202d1ac67b71bf2af6e6a3cad8e8
EXECUTOR_HANDOFF_COMMIT=16d15b55bf26af5e7e6708557812fad0e75d8a0d
```

Independent GitHub review confirms:

- Owner-local SSH bootstrap handoff was present;
- identity-file presence passed;
- client public-key fingerprint matched;
- all three recorded normal known_hosts pins matched locally;
- exactly one strict SSH invocation occurred;
- native SSH exit was 255;
- connection closed before any remote identity output;
- no retry or alternate access path occurred;
- M1 B-I did not start;
- all mutation counters remained zero.

```text
M1_R1_RETURN=ACCEPTED
SSH_CLIENT_TRUST_PREFLIGHT=PASS
REMOTE_IDENTITY=UNPROVEN
ARCHITECTURE=UNRESOLVED
RUNTIME_DRIFT_PROVEN=NO
MUTATIONS=0
```

This is now a repeated pre-identity SSH transport failure. Do not continue blind SSH retries.

## Current Gate

```text
CURRENT_GATE=M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY
CURRENT_GATE_STATUS=OWNER_LOCAL_READONLY_CHECKPOINT
```

## Goal

Use the already-authenticated Hostinger Web Terminal / provider console as the accepted target-host recovery path to:

1. prove the actual target host;
2. collect a fresh server-side SSH health classification without changing SSH;
3. collect the host-local Docker/network facts required by M1 where safely possible;
4. decide whether SSH needs a separate repair Gate or M1 can continue through the console/read-only evidence path.

## Owner operation boundary

Owner performs one bounded read-only command block prepared by Reviewer/Executor.

Owner is not asked to diagnose, edit config, restart services, modify firewall, or choose architecture.

No secret values, cloudflared token, private key, environment dump, database content, or provider credentials may be output.

## Required read-only facts

### Target identity

```text
hostname
current console user
OS/kernel
```

Expected host: `srv1970241`.

### SSH server-side health

Read only:

- ssh service active state;
- TCP 22 listener;
- effective safe non-secret sshd limits relevant to pre-auth connection closure;
- recent bounded count/classification of SSH log events related to pre-auth close / MaxStartups / throttling / fatal errors.

Do not output raw client IPs if avoidable.
Do not change sshd, authorized_keys, UFW, fail2ban, systemd, or socket state.

### M1 host topology

Read only:

- relevant running container names/state/restart count;
- WordPress and MariaDB networks;
- WordPress aliases per network;
- `spikersun-private` attached containers and aliases;
- cloudflared networks/image/state, without command/env/token values;
- Caddy networks/image/state;
- Mini Craft current Compose source label/path where available;
- no host-published WordPress/MariaDB ports.

## Result classes

If target host is not `srv1970241`:

```text
RETURN_TARGET_HOST_IDENTITY_MISMATCH
```

If server-side SSH health shows a concrete blocking condition:

```text
RETURN_SSH_SERVER_SIDE_REPAIR_REQUIRED
```

Do not repair in R2.

If server-side SSH is healthy but direct SSH remains unavailable:

```text
SSH_SERVER_SIDE_HEALTH=PASS
SSH_DIRECT_PATH=UNAVAILABLE
```

This permits Reviewer to continue M1 read-only reconciliation from authoritative target-host console evidence without pretending SSH is fixed.

## Hard forbidden

No:

- SSH/sshd/authorized_keys/sudo/UFW/fail2ban mutation;
- service restart/reload;
- Docker lifecycle/network mutation;
- Caddy/cloudflared mutation;
- DNS/Tunnel/Cloudflare mutation;
- application/database mutation;
- Secret/private-key/token/session output;
- payment/provider action;
- cleanup/deletion/prune.

## Success boundary

```text
PASS_CANDIDATE_M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY
TARGET_HOST_EXECUTION_PROVEN=PASS
SSH_SERVER_SIDE_HEALTH=PASS|RETURN_REPAIR_REQUIRED
M1_HOST_TOPOLOGY_READBACK=PASS|PARTIAL
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

R2 does not authorize M2 ingress migration.
