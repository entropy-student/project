# Reviewer Decision — K6R1 SSH Transport Diagnosis and Preflight Recovery

Date: 2026-09-23
Status: SUPERSEDED

> **Authority notice:** This Gate is historical and must not be executed.
> It is superseded by `REVIEWER_DECISION_K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY.md`.
> Any overlapping SSH/Shared VPS rule defers to the canonical
> `entropy-student/spike.skill/vps-project-governance` latest.
Parent: K6_VPS_PRODUCTION_DEPLOYMENT
Executor return: 82962230c984767a65bbd675df2c2b9698cb5496

## Reviewer finding

The K6 Phase A return is valid, but this is NOT yet proven Shared VPS configuration drift and NOT proven host-key drift.

Observed fact:
- TCP connection reached the approved SSH endpoint.
- The remote side closed during SSH key exchange before presenting a host key.
- Therefore no remote identity verification or authenticated session occurred.
- VPS/Shared Infra mutation count remains zero.

Classify this as:
SSH_TRANSPORT_PREFLIGHT_UNAVAILABLE

Do not weaken host-key verification and do not use an alternate credential.

## Gate

GATE=K6R1_SSH_TRANSPORT_DIAGNOSIS

## Objective

Determine whether the failure is:
- transient SSH transport failure;
- local OpenSSH/config/proxy interference;
- server-side sshd/security/rate-limit problem;
- broader VPS reachability problem.

No remote mutation is authorized.

If strict SSH becomes available and the host key matches the recorded pin, complete the original K6 Phase A read-only inventory in the same Gate, then stop at Reviewer.

Do not proceed to K6 deployment writes.

## A. Local client/config truth

Record:
- Windows OpenSSH client path/version
- effective ssh command/options used
- whether SSH config applies ProxyCommand/ProxyJump/Host aliases
- whether environment/system proxy is relevant to raw SSH (normally not, prove rather than assume)
- local identity path exists and permissions are usable
- known_hosts exact target entries exist

Do not emit private key contents.

Use ssh -G / equivalent config expansion where useful.

## B. Bounded TCP/SSH transport probes

Maximum three SSH connection attempts total in this Gate.

Use the same approved endpoint and identity.

Attempt 1:
- strict host-key checking
- approved known_hosts
- approved identity
- BatchMode
- IdentitiesOnly
- verbose diagnostics
- one connection attempt
- bounded timeout

Attempt 2 may bypass user SSH config only if Attempt 1 shows config involvement or remains ambiguous.
Retain:
- strict host-key checking
- same known_hosts
- same identity
- no password fallback
- no alternate account

Attempt 3 may use the alternate installed local OpenSSH client implementation (for example Windows vs WSL) only to isolate client behavior. It must use the same endpoint/account/key/pinned host keys and remain read-only.

Do not retry indefinitely.

Also run non-auth transport checks:
- TCP port 22 reachability
- SSH banner observation if safely possible
- connection timing / close point
- optional path traceroute only if it adds diagnostic value

Do not port-scan the host broadly.

## C. Classification

Return one exact category:

1. SSH_RECOVERED
   Strict SSH succeeds, host key matches recorded pin.

2. LOCAL_CLIENT_CONFIG_CAUSE
   A local client/config issue is proven and a strict corrected invocation succeeds.

3. REMOTE_PRE_HOSTKEY_CLOSE_REPRODUCIBLE
   TCP 22 reachable but all bounded strict clients are closed before host-key presentation.

4. TCP_22_UNREACHABLE
   TCP 22 cannot be reached.

5. HOST_KEY_MISMATCH
   Remote presents a host key and it differs from recorded pin.
   STOP immediately; no acceptance/update of new key.

6. UNKNOWN

## D. Conditional Phase A recovery

Only if classification is SSH_RECOVERED or LOCAL_CLIENT_CONFIG_CAUSE:

Immediately complete original K6 Phase A read-only Shared VPS preflight:

- hostname
- OS/kernel
- CPU/RAM/disk
- Docker/Compose versions
- current containers
- networks
- host port bindings
- 80/443 owner
- UFW
- reverse proxy/Caddy
- cloudflared
- /srv/apps
- /srv/data
- /srv/backups
- Mini Craft path/container/network collision
- resource headroom
- unrelated project protection

No writes.

Then return:
PASS_CANDIDATE_K6R1_SSH_TRANSPORT_DIAGNOSIS

Do not enter Phase B/C/D deployment.

## E. If remote pre-hostkey close remains reproducible

Do not keep retrying.

Return:
RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED

Provide Owner a minimal bounded action only:
- open Hostinger VPS control panel / browser console;
- confirm VPS power/running state;
- if a web/serial console is available, check whether ssh.service/sshd is active and whether port 22 is listening;
- report only status/output, no password/key/token.

Do not ask Owner to rotate keys or change firewall yet.

Do not authorize reboot automatically.

## F. If TCP 22 unreachable

Return:
RETURN_OWNER_HOSTINGER_NETWORK_CHECK_REQUIRED

Owner action:
- confirm VPS running in Hostinger panel;
- confirm provider firewall/network status if visible.

No SSH/firewall mutation yet.

## G. If host key mismatch

Return:
RETURN_REVIEWER_SSH_HOST_KEY_MISMATCH

Do not:
- delete known_hosts entry
- accept new key
- use StrictHostKeyChecking=no
- proceed.

## Safety

VPS_ACTIONS=0
DOCKER_ACTIONS=0
FIREWALL_ACTIONS=0
SSH_SERVER_ACTIONS=0
DNS_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0

No secrets in GitHub/evidence.

## Return

GATE=K6R1_SSH_TRANSPORT_DIAGNOSIS
RESULT=<PASS_CANDIDATE_K6R1_SSH_TRANSPORT_DIAGNOSIS | RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED | RETURN_OWNER_HOSTINGER_NETWORK_CHECK_REQUIRED | RETURN_REVIEWER_SSH_HOST_KEY_MISMATCH | RETURN_REVIEWER_*>
SUMMARY=
SSH_CLASSIFICATION=
WINDOWS_OPENSSH_VERSION=
SSH_EFFECTIVE_CONFIG=
LOCAL_IDENTITY_CHECK=
KNOWN_HOSTS_CHECK=
TCP_22=
SSH_BANNER=
ATTEMPT_1=
ATTEMPT_2=
ATTEMPT_3=
REMOTE_HOST_KEY_PRESENTED=
REMOTE_HOST_KEY_MATCH=
SHARED_VPS_PREFLIGHT=
HOSTNAME=
OS_KERNEL=
CPU_RAM_DISK=
DOCKER_VERSION=
COMPOSE_VERSION=
CURRENT_CONTAINERS=
CURRENT_NETWORKS=
CURRENT_HOST_PORTS=
CURRENT_80_443_OWNER=
UFW_STATE=
REVERSE_PROXY=
CADDY_STATE=
CLOUDFLARED_STATE=
SRV_APPS=
SRV_DATA=
SRV_BACKUPS=
MINICRAFT_PATH_COLLISION=
MINICRAFT_CONTAINER_COLLISION=
MINICRAFT_NETWORK_COLLISION=
RESOURCE_HEADROOM=
EXISTING_PROJECTS_PROTECTED=
VPS_ACTIONS=0
DOCKER_ACTIONS=0
FIREWALL_ACTIONS=0
SSH_SERVER_ACTIONS=0
WORKSPACE_TEMP_CLEANUP=
EVIDENCE=
COMMIT=
OWNER_ACTION=<NONE | CHECK_HOSTINGER_CONSOLE | CHECK_HOSTINGER_NETWORK>
NEXT=STOP_AT_REVIEWER

Do not deploy.
