# 3x-ui Fast Path P0 — Existing VPS Read-only Discovery

Status: REVIEWER_RELEASED / EXECUTOR_READONLY

## GATE_ID

`3XUI_FASTPATH_P0_EXISTING_VPS_DISCOVERY`

## OBJECTIVE

Re-establish the current reality of the Owner-selected existing DigitalOcean VPS before installing 3x-ui. Determine whether 3x-ui can be added without disrupting the currently working VPN path and identify the fastest safe port/resource plan for three managed nodes.

## OWNER-PROVIDED TARGET FACTS

Source: Owner screenshot, 2026-10-06.

```text
PROVIDER=DigitalOcean
DROPLET_STATUS=Active
HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
REGION=SFO3
PUBLIC_IPV4=24.199.118.137
PRIVATE_IPV4=10.124.0.3
OS_DISPLAY=Ubuntu 24.04 (LTS) x64
PLAN_LABEL=1vCPU / 512MB / 10GB
```

These facts identify the intended target but do not prove current runtime state.

Historical material says this same VPS previously hosted WireGuard and Hysteria2. Therefore it is **not a fresh target**.

## TARGET AND SCOPE

Read-only only:

- strict SSH target identity;
- OS / architecture / uptime;
- CPU, RAM, swap and root-disk capacity;
- current TCP/UDP listeners;
- existing WireGuard/Hysteria2/REALITY/Xray/x-ui related services;
- presence/absence metadata for existing 3x-ui paths;
- current WireGuard interface names only;
- host firewall status summary if available;
- exact occupancy of candidate ports 443/TCP, 8443/UDP, 51820/UDP;
- identify other unoccupied candidate ports only if one of those is occupied.

Do not read Secret-bearing configs.

## MAX_ENDPOINT_THIS_ROUND

Fresh read-only reality classification -> persist sanitized Evidence -> `PASS_CANDIDATE` or precise `RETURN_*` -> STOP_AT_REVIEWER.

No installation or mutation in P0.

## MANDATORY_REVIEW_STOP

YES

## APPLICABLE_CRITICAL_CONSTRAINTS

- Existing working VPN paths must not be stopped, restarted, edited or rebound.
- No package install/update.
- No firewall/UFW/nftables change.
- No systemd enable/disable/start/stop/restart.
- No file writes on VPS except no-op transport artifacts intrinsic to SSH; preferably none.
- No route/address/sysctl change.
- No panel install.
- No Secret/config file content reads.
- No broad historical project reconstruction.
- Strict SSH trust; host-key mismatch fails closed.
- Never emit private keys, VPN credentials, UUIDs, passwords, tokens or subscription IDs.
- Legacy custom-deployment project remains reference-only.

## PREFLIGHT

Executor must use the existing Owner-local SSH identity reference if present:

`C:\Users\34707\.ssh\digitalocean_ed25519`

Preferred known-host file:

`C:\Users\34707\.ssh\known_hosts`

Try strict direct SSH to:

`root@24.199.118.137`

with behavior equivalent to:

`BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, explicit identity file and explicit known-host file.

If strict public-IP trust is not already valid, do not auto-accept a new host key. RETURN `RETURN_SSH_TRUST_DRIFT`.

Before collecting runtime facts, prove:

```text
hostname == ubuntu-s-1vcpu-512mb-10gb-sfo3
OS ID == ubuntu
VERSION_ID == 24.04
```

Any mismatch -> `RETURN_TARGET_IDENTITY_MISMATCH`.

## ALLOWED READ-ONLY PROBES

Use only bounded read operations such as:

- `hostname`, `uname -m`, `uptime`
- `/etc/os-release`
- `nproc`, `free -m`, `swapon --show --bytes`, `df -B1 /`
- `ss -H -lntup`
- `systemctl is-active/is-enabled/show`
- bounded `systemctl list-unit-files` / `list-units` filters
- `wg show interfaces` / `wg show` only if installed, with output reduced to interface names and peer counts; do not expose keys
- `command -v`
- metadata-only `test -e`, `stat` for `/etc/x-ui`, `/usr/local/x-ui`, service unit presence
- `ufw status` or read-only nftables summary only if already available.

Do not cat known VPN/3x-ui config files.

## REQUIRED EVIDENCE

Persist only sanitized fields:

```text
TARGET_IDENTITY=PASS|FAIL
SSH_STRICT=PASS|FAIL
HOSTNAME=<non-secret>
OS=<non-secret>
ARCH=<non-secret>
CPU_COUNT=<integer>
RAM_TOTAL_MB=<integer>
RAM_AVAILABLE_MB=<integer>
SWAP_TOTAL_MB=<integer>
ROOT_FREE_MB=<integer>
PORT_TCP_443=FREE|OCCUPIED
PORT_UDP_8443=FREE|OCCUPIED
PORT_UDP_51820=FREE|OCCUPIED
XUI_PRESENT=YES|NO
XUI_ACTIVE=YES|NO
XRAY_ACTIVE=YES|NO
WIREGUARD_ACTIVE=YES|NO
WIREGUARD_INTERFACE_COUNT=<integer>
HYSTERIA_ACTIVE=YES|NO
REALITY_PROJECT_SERVICE_ACTIVE=YES|NO
OTHER_RELEVANT_LISTENERS=<sanitized count/port-owner classes>
HOST_FIREWALL_CLASS=INACTIVE|ACTIVE|UNKNOWN
MUTATION_COUNT=0
SECRET_VALUES_EMITTED=0
CURRENT_CLASSIFICATION=READY_NO_CONFLICT|READY_WITH_PORT_REMAP|EXISTING_VPN_MIGRATION_REQUIRED|RESOURCE_REVIEW_REQUIRED|AMBIGUOUS
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE CRITERIA

P0 can be `PASS_CANDIDATE` only when:

- strict target identity is proven;
- all required resource and listener facts are known;
- no target mutation occurred;
- Secret output is zero;
- a deterministic classification can be made.

Classification guidance:

- `READY_NO_CONFLICT`: target ports free and existing services do not conflict.
- `READY_WITH_PORT_REMAP`: existing working services occupy target ports but sufficient alternate ports/resources exist; preserve old services during 3x-ui canary.
- `EXISTING_VPN_MIGRATION_REQUIRED`: old services must eventually be retired/rebound, but no action is taken in P0.
- `RESOURCE_REVIEW_REQUIRED`: RAM/disk constraints require swap/resource planning before install.
- `AMBIGUOUS`: any material state cannot be proven.

## ROLLBACK STATUS OR PLAN

Not applicable. P0 is read-only.

## OWNER_ONLY_ACTIONS

NONE unless strict SSH requires an unavailable passphrase/unlock or trust repair. Executor must RETURN rather than asking Owner to debug interactively.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `vpn-network-optimization/REVIEWER_HANDOFF.md`;
3. target-specific source needed for the read-only probe.

Accepted facts:

- target is Owner-selected DigitalOcean droplet `24.199.118.137`, SFO3;
- screenshot identifies Ubuntu 24.04 x64 and hostname `ubuntu-s-1vcpu-512mb-10gb-sfo3`;
- this host is historical, not fresh;
- legacy project state must not be treated as current runtime truth;
- current goal after P0 is 3x-ui stable fast path, not repair of legacy custom runners.

Do not reread old G1-G4/R19-R22/Baidu material unless one specific P0 fact requires a narrow lookup.

## EXECUTOR_TO_REVIEWER_RELAY

Use the standard short completion packet:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：只读；无目标 mutation。
验证：目标身份、资源、端口和既有 VPN/3x-ui 服务状态已核对并持久化。
问题：NONE 或精确阻塞原因。
回滚：不适用；本轮只读。
请 Reviewer 检查：CURRENT_CLASSIFICATION 与端口/资源事实。
Owner 转交：NONE，除非严格 SSH 本身不可用。
```
