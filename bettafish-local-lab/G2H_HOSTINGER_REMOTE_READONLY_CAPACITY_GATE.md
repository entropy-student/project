# BettaFish G2H — Conditional Hostinger Read-Only Capacity and Isolation Preflight
> GATE_ID: BTFL-G2H-HOSTINGER-REMOTE-READONLY-CAPACITY-20261013
> STATUS: CONDITIONAL_OWNER_APPROVAL_REQUIRED
> MAX_ENDPOINT_THIS_ROUND: existing trusted SSH connection if verified, one bounded READ-ONLY environment/resource/isolation snapshot; no download/install/Docker actions/credential changes
> MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
Owner Windows Docker G2D returned `RETURN_RESOURCE_PRESSURE` even before image fully pulled. Evaluate whether **Owner's existing Hostinger KVM2 VPS** (historically 2 vCPU, 8 GB RAM; not fresh verification) has enough **currently available** capacity and isolation to safely host an isolated Docker BettaFish embedded-collector-first service, leaving Owner Windows Codex/Edge and other active projects untouched. This is only feasibility; no deploy and no XHS activity.

## TARGET_AND_SCOPE
- This Gate may run **ONLY AFTER OWNER explicitly says "允许对 Hostinger KVM2 做只读服务器资源检查" (or equivalent)**. Do not automatically SSH just because historical VPS is known. Do not use DigitalOcean SFO3 VPN server, Grok Bot cloud computer, Windows Docker or any fallback target.
- Executor: existing Owner Windows local Codex. If there is a previously verified SSH connection to this exact VPS with documented host key trust and intended operations identity, it may execute minimal noninteractive read-only probes. **Do not invent identity/path/IP/port/username, guess SSH endpoint, or promote an unknown server.** If no connection/trust metadata, RETURN `RETURN_SSH_CONNECTION_REQUIRED` asking Owner to choose an established route; don't ask for Secret content.
- Historical server size only; actual server identity, access/trust, running projects and current resource readings must be proven afresh in bounds without disclosing server name/address or credentials. No alteration to project management local Git checkout or existing G1L source.

## CONSTRAINTS
- `READ_ONLY`: no Docker installation, image pull, compose up/down, container stop, package/apt, swap, kernel, firewall, SSH/key/ACL, system resources, backup retention or existing production process mutation. No login to XHS, cookies, browser profile, API/model calls, downloading repositories or updating systems. No secret value read/output. No changes to Windows VPN/Clash/HY2/WG, Edge/ChatGPT/Codex, local Docker, VPS current services.
- Use strict verified SSH host key; no auto-accept of unknown fingerprint/trust. Existing unverified generic credential is not authority. Read only tool version, capacity and high-level process/container counts/total footprint. Avoid full process command lines, usernames, host names/identifiers, raw `docker inspect` environment values.
- Don't assume Docker installed or private ingress. If absent, report requirement for future Gate, do not install it.
- No public port/route opening or real customer data. Never mistake the 2 GB upstream machine recommendation for spare host RAM. No mandatory arbitrary 4GiB available free threshold; make resource-based recommendation considering existing workloads.

## READ_ONLY_PROBES
1. Verify Hostinger provider/instance identity against Owner-confirmed target and established access metadata using sanitized nonidentifying categories; read kernel/OS/arch, CPU cores, `free -b` MemTotal/MemAvailable, SwapTotal/SwapFree, `df -B1` app-volume free capacity, `uptime` load; optional `/proc/meminfo` category numbers. One-time resource snapshot and bounded 10–15-second recheck if feasible; no stress tests.
2. If allowed via existing account without privilege escalation, `docker version` / `docker info` summary and project-safe running container **count** plus total reported consumption, avoiding names, networks, mounts/env/secrets. If Docker absent/no permission, mark UNKNOWN/NOT_INSTALLED, not immediate permission escalation.
3. Non-sensitive read-only project collision/isolation feasibility: available CPU/RAM/disk vs existing high-level load, unused private Compose namespace and recovery requirements. Do not crawl whole file system or inspect existing private application config. Do not probe XHS/Douyin connectivity, no real social site requests.
4. Output two feasible next-stage variants: (A) slim container built from **BettaFish pinned embedded MediaCrawler** with Python+browser only, JSON/CSV persistent export plus later Codex analysis; (B) official full BettaFish + PostgreSQL guarded proxy. Compare likely resource classes and remaining unknowns; distinguish estimates from actual measurements. Assess backups, domain/ingress, image build/cache, private SSH forwarding vs public ports, no credentials.
5. If target evidence cannot positively establish noninterference, result RETURN; do not propose deployment PASS.

## REQUIRED_EVIDENCE
`GATE_ID`, `OWNER_REMOTE_APPROVAL=YES`, `TARGET_HOST_TRUST_VERIFIED_BOOL`, `SERVER_CLASS_HOSTINGER_KVM2_OR_RETURN`, `OS_ARCH_CPU`, `HOST_TOTAL_AVAILABLE_GiB`, `SWAP_TOTAL_FREE_GiB`, `STORAGE_FREE_GiB`, `LOAD_SNAPSHOT`, `DOCKER_PRESENT_AND_VERSION_OR_UNAVAILABLE`, `EXISTING_WORKLOAD_RISK`, `NETWORK_EXPOSURE_CHANGE=NONE`, `ACTUAL_CHANGES=NONE`, `PREFERRED_DEPLOYMENT_VARIANT`, `ANOMALIES`, `RESULT`, `STOP_AT_REVIEWER=YES`. No raw SSH details, account names, host IP, secret, full process args or raw logs.
`PASS_CANDIDATE` is only READ-ONLY resource/target feasibility, not permission to deploy or access XHS.

## ACCEPTANCE_CRITERIA
Same Owner-approved Hostinger VPS, verified existing SSH trust, sanitized measurements plus noninterference assessment, read-only no side effects. If uncertain target, SSH, permission, unstable resources or missing data, return precise `RETURN_*` and hand back to Reviewer. Even on PASS_CANDIDATE, STOP; Reviewer alone creates a subsequent explicit deployment Gate after Owner authorizes remote write/cost/network/account scope.

## ROLLBACK_STATUS_OR_PLAN
No writes, no rollback. Any unexpected changes cause stop and urgent precise report. Never cleanup unrelated VPS state.

## OWNER_ONLY_ACTIONS
Explicit approval to run read-only SSH capacity check on Hostinger. Further container installation, source transfer, browser/profile/login or any new host exposure NOT included. If Owner prefers an alternative, this Gate is not executed.

## REVIEWER_TO_EXECUTOR_RELAY
**仅在 Owner 明确同意对现有 Hostinger KVM2 进行只读资源检查时执行。** 读取 `entropy-student/project` 最新 main `bettafish-local-lab/G2H_HOSTINGER_REMOTE_READONLY_CAPACITY_GATE.md`。G2D 本地 Docker 镜像拉取期间内存跌至 0.587 GiB，已资源 RETURN，不准重试原部署。你是 Windows 11 本地 Codex；只通过此前验证过的 Hostinger SSH 信任路径，以非交互只读方式检查目标 VPS 当前 CPU/可用内存、磁盘、swap、Docker 是否存在、已有项目资源压力。未经确认不能猜 IP、账号、密钥或接受新的主机指纹。禁止任何安装、拉镜像、停服务、改网络/SSH/VPN/权限、登录社交平台或读取 Secret；尤其不碰 DigitalOcean VPN VPS 和 Grok Bot 云电脑。返回去敏容量与“轻量嵌入采集容器 vs 完整 BettaFish”可行性判断；`STOP_AT_REVIEWER=YES`，不得自行部署。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：NONE，远程严格只读。
验证：Hostinger 身份/SSH 信任类别、CPU/RAM/disk/swap/Docker 存在与原项目风险。
问题：NONE 或实际阻塞。
回滚：NONE。
请 Reviewer 检查：是否允许未来独立 Docker 采集容器资源/登录设计与远程部署 Gate。
Owner 转交：NONE 或仅缺失的既有 SSH 信任/入口信息；绝不传密码。
