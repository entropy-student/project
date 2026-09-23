# Reviewer Decision — K6R2 Owner Hostinger Console Check

Date: 2026-09-23
Status: OWNER CHECKPOINT
Parent Gate: K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
Executor commit: fe0c5910bbce8d8858ef5273b0d808d2dfa2cac3

## Reviewer finding

K6R1 correctly followed canonical Governance.

Accepted facts:
- local SSH identity reference exists;
- public fingerprint matches the recorded Shared VPS metadata;
- known_hosts pins are present;
- exactly one canonical strict SSH probe was executed;
- the remote closed before presenting any host key;
- therefore neither SSH trust drift nor Shared VPS material drift is proven;
- no authenticated remote session was established;
- no VPS, Docker, Shared Infra, payment or Live mutation occurred.

Current classification:
REMOTE_CLOSED_PRE_HOST_KEY

## Current checkpoint

GATE=K6R2_OWNER_HOSTINGER_CONSOLE_CHECK

Owner action is intentionally limited to one failure domain: provider-side VPS/SSH service status.

Do NOT change configuration yet.

## Owner check

In Hostinger VPS control panel:

1. Confirm the VPS state is Running.
2. Open the Hostinger browser/Web/Serial console if available.
3. Read only:
   - whether ssh / sshd service is active;
   - whether TCP port 22 is listening;
   - whether the Hostinger panel shows an obvious network/security/abuse/firewall block affecting SSH.
4. Report only status/output.

Do NOT:
- reboot;
- reinstall;
- regenerate/replace SSH keys;
- edit authorized_keys;
- edit sshd_config;
- edit UFW/firewall;
- accept a new host key;
- expose password, private key, token or Secret.

## Preferred console commands

If a shell console is available, use read-only commands:

```bash
systemctl is-active ssh || systemctl is-active sshd
sudo ss -lntp | grep ':22'
sudo systemctl status ssh --no-pager -l || sudo systemctl status sshd --no-pager -l
```

If sudo is unavailable in the console, run the non-sudo variants and report that limitation.

Do not run restart/start/stop commands.

## Return

Owner can reply with:

```text
VPS_STATE=RUNNING|STOPPED|UNKNOWN
HOSTINGER_CONSOLE=AVAILABLE|UNAVAILABLE
SSH_SERVICE=ACTIVE|INACTIVE|FAILED|UNKNOWN
PORT_22_LISTENING=YES|NO|UNKNOWN
PROVIDER_NETWORK_OR_SECURITY_BLOCK=YES|NO|UNKNOWN
NOTABLE_MESSAGE=<sanitized short message or NONE>
```

Reviewer will choose the next bounded Gate from that evidence.

K6 deployment remains paused.
