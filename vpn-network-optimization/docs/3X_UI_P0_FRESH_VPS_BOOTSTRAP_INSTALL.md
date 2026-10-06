# 3x-ui Fast Path P0 — Fresh VPS Trust Bootstrap + Stable Install

Status: REVIEWER_RELEASED / EXECUTOR_P0

## GATE_ID

`3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL`

## OBJECTIVE

Establish explicit SSH trust for the fresh Owner-selected DigitalOcean droplet, verify fresh-target identity/resources, install pinned stable 3x-ui v3.9.0 non-interactively, bind the admin panel to loopback, and return sanitized installation evidence.

## TARGET

```text
PROVIDER=DigitalOcean
PUBLIC_IPV4=143.198.159.233
PRIVATE_IPV4=10.124.0.2
EXPECTED_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
EXPECTED_OS_ID=ubuntu
EXPECTED_OS_VERSION=24.04
EXPECTED_ARCH=x86_64_or_amd64
REGION=SFO3
OWNER_REPORTED_FRESH_TARGET=YES
```

The former VPS `24.199.118.137` is explicitly out of scope.

## PINNED SOFTWARE

```text
3X_UI_VERSION=v3.9.0
INSTALLER=https://raw.githubusercontent.com/MHSanaei/3x-ui/v3.9.0/install.sh
DATABASE=SQLite
```

Official release read-back before Gate creation confirmed `v3.9.0` as the latest stable release.

## MAX_ENDPOINT_THIS_ROUND

Owner host-key fingerprint relay -> exact public-host-key match -> explicit known-host trust -> strict SSH fresh-target preflight -> stable 3x-ui install -> panel loopback binding -> service/resource read-back -> Evidence -> STOP_AT_REVIEWER.

Do not create VPN inbounds in P0.

## MANDATORY_REVIEW_STOP

YES

## OWNER-ONLY ACTION BEFORE EXECUTOR RELEASE

In DigitalOcean **Web Console** for target `143.198.159.233`, Owner runs:

```bash
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub -E sha256
```

Owner returns only the single ED25519 fingerprint line. This is public trust metadata, not a Secret.

Owner-relayed ED25519 host-key fingerprint:

```text
SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ
```

Reviewer recorded the fingerprint and released the Gate:

```text
EXECUTOR_RELEASED=YES
```

## REVIEWER RELEASE CONDITION

Reviewer has recorded the exact Owner-relayed ED25519 SHA256 fingerprint:

`SHA256:KV23raBMofyz5I9FL9chXUR9yrX7V6ARUyhAS3awDRQ`

and released:

`EXECUTOR_RELEASED=YES`

No other Owner action should be needed unless the selected SSH private key is encrypted/locked or was not attached to the new droplet.

## SSH TRUST BOOTSTRAP AFTER RELEASE

Executor uses:

`C:\Users\34707\.ssh\digitalocean_ed25519`

and:

`C:\Users\34707\.ssh\known_hosts`

unless fresh local discovery proves a different already-recorded project-owned reference.

For the new IP only:

1. fetch the ED25519 public host key with `ssh-keyscan -t ed25519 143.198.159.233`;
2. compute the fetched key fingerprint locally;
3. require exact match to the Owner-relayed fingerprint;
4. only after exact match, add/update the exact new-IP ED25519 entry in the explicit known-host file;
5. all subsequent SSH uses `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, explicit identity file and explicit known-host file.

Any mismatch -> `RETURN_SSH_TRUST_DRIFT`. Never auto-accept mismatch.

## FRESH-TARGET PREFLIGHT

Before installation prove:

- hostname exactly `ubuntu-s-1vcpu-512mb-10gb-sfo3`;
- Ubuntu 24.04;
- supported amd64/x86_64 architecture;
- target ports TCP/443, UDP/8443, UDP/51820 are not already listening;
- no x-ui/3x-ui installation exists;
- no active WireGuard/Hysteria/Xray/legacy REALITY service exists;
- root filesystem has at least 2 GiB free;
- RAM/swap facts recorded;
- target is not the old public IP.

Unexpected pre-existing VPN/panel state -> `RETURN_PREFLIGHT_DRIFT`.

## INSTALLATION

Use the immutable-tag installer:

```bash
XUI_NONINTERACTIVE=1 bash <(curl -fsSL https://raw.githubusercontent.com/MHSanaei/3x-ui/v3.9.0/install.sh) v3.9.0
```

**Secret-output rule:** the official installer prints generated credentials. Executor must invoke it with stdout/stderr suppressed from the automation capture. Acceptance is based on exit status and post-install read-back, not installer console text.

Generated credentials/API token remain only in the official root-only:

`/etc/x-ui/install-result.env`

Verify metadata only:

- owner `root`;
- group `root`;
- mode `600`;
- file is regular and non-empty.

Do not print, hash, copy, commit or return its contents.

## PANEL EXPOSURE

Immediately after installation, before PASS:

```bash
x-ui setting -listenIP 127.0.0.1
systemctl restart x-ui
```

Suppress command output if it could contain settings.

Read back that:

- x-ui service is active;
- panel process has a TCP listener;
- the panel listener is loopback-only;
- no panel/admin listener is bound to `0.0.0.0` or public IP.

Do not expose the admin panel publicly in P0.

## RESOURCE POLICY

512 MB RAM is accepted as an Owner-selected low-cost starting size, but not assumed sufficient.

P0 does **not** create swap automatically.

After install record:

- RAM total/available;
- swap total;
- root free space;
- x-ui resident memory if available.

If the service is active and system remains healthy, continue. If installation/runtime shows OOM, severe memory pressure or unstable service, return `RETURN_RESOURCE_REVIEW_REQUIRED`; do not add swap or resize inside P0.

## TARGET PORTS RESERVED FOR P1

No inbounds are created yet.

Preferred future assignments:

```text
VLESS_REALITY_VISION=TCP/443
HYSTERIA2=UDP/8443
WIREGUARD=UDP/51820
```

## REQUIRED EVIDENCE

Persist only sanitized fields:

```text
OWNER_HOSTKEY_FINGERPRINT_MATCH=YES
KNOWN_HOSTS_EXPLICIT_TRUST=PASS
SSH_STRICT=PASS
TARGET_IDENTITY=PASS
HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
OS=Ubuntu_24.04
ARCH=<non-secret>
PUBLIC_IP_EXPECTED=143.198.159.233
TCP_443_PREFLIGHT=FREE
UDP_8443_PREFLIGHT=FREE
UDP_51820_PREFLIGHT=FREE
LEGACY_VPN_RUNTIME_PRESENT=NO
XUI_PREEXISTING=NO
XUI_VERSION=v3.9.0
XUI_SERVICE_ACTIVE=YES
INSTALL_RESULT_OWNER=root
INSTALL_RESULT_GROUP=root
INSTALL_RESULT_MODE=600
INSTALL_RESULT_NONEMPTY=YES
PANEL_LOOPBACK_ONLY=YES
PANEL_PUBLICLY_BOUND=NO
RAM_TOTAL_MB=<integer>
RAM_AVAILABLE_MB=<integer>
SWAP_TOTAL_MB=<integer>
ROOT_FREE_MB=<integer>
XUI_RSS_MB=<integer_or_UNKNOWN>
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
NEW_VPS_INSTALL_MUTATION=YES
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE CRITERIA

Formal Reviewer PASS requires:

- explicit host-key trust established by exact fingerprint match;
- fresh-target identity and empty target-port/runtime preflight;
- successful pinned v3.9.0 installation;
- root-only install-result metadata;
- active x-ui service;
- panel bound to loopback only;
- no Secret values emitted;
- no old-VPS mutation;
- no resource failure.

## ROLLBACK

Because this is a newly created dedicated VPS with no accepted business data, rollback for a failed install is:

1. stop further mutation;
2. preserve sanitized failure evidence;
3. Reviewer chooses either exact uninstall/repair or Owner destroys/recreates the disposable droplet.

Do not mutate the old VPS as rollback.

## APPLICABLE CRITICAL CONSTRAINTS

- old VPS `24.199.118.137` remains untouched;
- explicit SSH host trust required;
- no Secret output;
- no public admin panel;
- no inbounds in P0;
- no firewall/sysctl/route tuning in P0;
- no broad optimization;
- no legacy VPN scripts.

## REVIEWER_TO_EXECUTOR_RELAY

After `EXECUTOR_RELEASED=YES`, read only:

1. this Gate;
2. current `REVIEWER_HANDOFF.md`;
3. exact target/install source necessary for execution.

Do not reread legacy VPN history.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：在全新 143.198.159.233 上完成严格 SSH trust bootstrap 与 3x-ui v3.9.0 安装；旧 VPS 未动。
验证：目标身份、端口、版本、服务、loopback-only 面板、资源与 Secret 输出均已核对。
问题：NONE 或精确阻塞原因。
回滚：新 VPS 可按 Gate 精确修复或重建；旧 VPS 保持原状。
请 Reviewer 检查：P0 安装与安全暴露证据。
Owner 转交：NONE，除非 SSH trust/private-key 可用性需要 Owner。
```
