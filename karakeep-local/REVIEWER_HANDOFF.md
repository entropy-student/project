# Karakeep Local · Reviewer Handoff

> REVIEWER_DATE=2026-10-16
> PROJECT_STATUS=`NOT_DEPLOYED`
> NEXT_GATE=`KARAKEEP-WIN-G1I-SCOPED-PROXY-RECOVERY-20261016`
> GATE_AUTHORIZATION_STATUS=`AWAIT_OWNER_EXPLICIT_AUTHORIZATION`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> This is the sole Reviewer-accepted current state; execution history is append-only `EXECUTION_EVIDENCE.md`.

## PROJECT_GOAL
在 Owner Windows 11 实体本机使用已冻结官方 Docker Compose、原 Secret 与官方三个镜像，首次启动独立 `karakeep-local` 并验证仅 `http://127.0.0.1:3000` 可访问的登录页。初装不注册账号、不加 AI key、不导入真实收藏、不改 Karakeep 上游源码/其他 Docker 项目。

## PROJECT_STAGE
- G0–G1R：Docker Desktop/Windows 运行路径、项目隔离、存储检查及安全 Compose/.env/随机 Secret 创建等成果已经保存；首次部署未通过。
- G1C：Karakeep Web 和 Chrome 官方 GHCR 镜像成功 pull，两个 RepoDigest 读回匹配；保留，不重复下载。
- G1E：受保护的 Compose/.env 当前存在、权限和格式有效，网络当前稳定；本轮诊断正式 PASS。G1D 的旧文件可见性差异未解释，但目前不是部署阻碍。
- G1F：官方 `getmeili/meilisearch:v1.41.0` 单次拉取退出码 1（<10秒），归类 `LAYER_DOWNLOAD_OR_EXTRACT` 但无实际下载进度证据，根因 UNKNOWN；未创建目标容器/卷；此 Gate RETURN。
- G1G：仅只读 Docker Desktop 代理证据审查，Reviewer 正式 PASS（只读范围），不是安装 PASS。既有日志只在推测时段观察到 registry/auth CONNECT，没有已确认 CDN 或失败阶段；Docker Desktop 模式未能从 settings JSON 读出。
- **G1H Owner UI readback 完成（本轮接收）：** Owner 提供 Docker Desktop → Settings → Resources → Proxies 界面截图，`OWNER_REPORTED` 可读状态：**Docker Desktop proxy = System proxy**；**Containers proxy = Same as host proxy**；Apply 灰色。此行为仅截图/查看，没有报告修改任何设置。**G1H Reviewer 接受为模式检查 PASS**，不能证明 Windows 代理自身有效或 Meilisearch pull 必然成功。
- **NEXT：G1I scoped proxy recovery**，等待 Owner 明确授权后交本机 Codex 执行。不得把 Owner 发送设置截图视作批准修改设置、pull 或 up。

## SYSTEM_MAP
- HOST：Owner Windows 11 native PowerShell 7.6.5、Docker Desktop Linux Engine 29.7.2、Compose v5.4.0、context `desktop-linux`（最近已接受）；本机技术 Executor = Owner PowerShell Codex。
- CONFIG：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`，官方源 blob `865bb147cef972926d5dc32e50645876fd110555`；同目录安全 `.env` 四键 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL`；NEXTAUTH_SECRET、MEILI_MASTER_KEY 当前为两个不同 64-hex Secret，禁止输出值、hash、重生成或替换。历史字节连续性 UNVERIFIED，但无历史真实业务依赖。
- TARGET：Compose project `karakeep-local` 三服务 web/chrome/meilisearch，唯一 web Host bind `127.0.0.1:3000:3000`；后两服务 Host 无端口。计划新命名卷 `karakeep-local_data` 与 `karakeep-local_meilisearch`，目前均未创建；无项目容器/业务数据。
- ACCEPTED_WEB_IMAGE：`ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`.
- ACCEPTED_CHROME_IMAGE：`ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`.
- MISSING_IMAGE：官方 `getmeili/meilisearch:v1.41.0`（Docker Hub）；先前多次 pull 失败，完整 image tag 不存在，可能存在未清理部分 layer。
- NON_TARGET_BASELINE：此前 20 容器（1 created，19 exited，0 running）、12 既有卷、11 网络；其它 WordPress/MariaDB 等服务现状由它们各自项目管理，不自动恢复、更改或清理。
- PROXY_OWNER_UI_G1H：Docker Desktop proxy = `System proxy`；Containers proxy = `Same as host proxy`。依据 Docker 官方设置文档 `https://docs.docker.com/desktop/settings-and-maintenance/settings/`：Containers proxy 控制所有 `docker image pull`；`Same as host proxy` 复用 Docker Desktop proxy 设置，后者 `System proxy` 会读取 Windows 静态系统代理。因此当前 pull 路由**取决于 Windows 系统代理是否正确、启用且 Docker Desktop 可用**，尚不能断定具体失败原因。
- PROXY_OS_HIST：G1E WinINET proxy disabled，G1F/G1G enabled，WinHTTP direct；Docker Engine presence flags 已存在但不证明实际 pull 代理选项。Windows 直连 Docker Hub registry/auth/CDN 曾 443 timeout。某次通过 GHCR 不等于 Docker Hub 会成功。
- PROXY_COMPAT：官方文档说明 Docker Desktop 支持 HTTP/HTTPS，SOCKS5 需 Business 订阅；当前 Docker Desktop UI 为 PERSONAL，**不应把仅 SOCKS5 的端口当 HTTP/HTTPS 代理提交**。当前本机实际代理协议/可访问性必须内部核对，不输出地址或私人凭据。
- STORAGE：G1F 后 C: 约 184.7 GiB free；此前 Docker volume/data root 所在后端验证通过。无任何固定剩余 RAM 下限（Owner 已取消）。关注实际 OOM/反复重启/系统异常。
- RECOVERY：尚未创建真实资料，后续出故障只针对 `karakeep-local` 执行 `down` 不带 `-v`，保留卷、Compose 与 Secret；异机 Secret 恢复和真实数据备份仍 `UNVERIFIED`，不得宣称可恢复。
- DEFAULT_EXECUTION_CHANNEL：Owner 真实 Windows 本机的原生 PowerShell Codex。

## CURRENT_ACCEPTED_STATE
G1H OWNER_REPORTED UI 两模式已明确（截图当前选择）：`Containers proxy=Same as host proxy`, `Docker Desktop proxy=System proxy`。该组合解释 *代理选择的继承关系*，**不是 Meilisearch 失败根因证明**。目前 Docker Hub registry/auth/CDN 实际经 Docker Desktop daemon 的访问和代理协议/兼容性仍 UNKNOWN。
Karakeep NOT_DEPLOYED，两 GHCR 官方镜像成功且可复用，官方 Meilisearch 仍缺，原密钥和受保护配置继续使用。历史 G1F 原始错误没有留存，禁止事后猜测。
**Reviewer next decision**：避免再来一轮只有泛化只读报告的 Gate；提出**单轮诊断→必要时临时代理修复→单次 Meili pull→条件独立启动→回退代理** 的严格顺序，但 Docker Desktop 代理修改会影响该桌面 Engine 的其它镜像拉取/容器外连规则，必须 Owner 显式授权后才可执行。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1I-SCOPED-PROXY-RECOVERY-20261016`
**GATE_STATUS**：`DRAFT_AWAIT_OWNER_AUTHORIZATION`。本 Gate 在 Owner 明确下达下面 OWNER_ONLY_ACTIONS 之前**不得执行任何本机技术动作**。

**OBJECTIVE**：在不改变 Windows 系统代理、Clash/VPN、证书、WSL/daemon、其他 Docker 项目的前提下，识别 Docker Hub 可用的现有 HTTP/HTTPS 代理路径；有必要时**临时、可逆**调整 Docker Desktop `Containers proxy`，仅下载缺失的官方 Meilisearch 镜像；然后恢复先前 Docker Desktop 代理模式并只启动 Karakeep，验证 localhost Web。

**MAX_ENDPOINT_THIS_ROUND**：
1. 事先确认本轮 Owner 明确授权；新鲜核对 Windows native target、Docker Engine/context、原 Compose SHA/安全 ACL/Secret 格式（仅本机受保护内存、不回传值）、两已有 GHCR image digest、目标缺碰撞、port 3000 空闲、磁盘可用和非目标 Docker 对象快照。当前 Owner UI 接受的两模式是基线，执行前再核实选择是否已改变；无关历史检查不重跑。
2. 在 Owner 本机受保护执行环境中，核验**当前 Windows 系统代理指向的协议与实际可用性**，特别区分 HTTP/HTTPS CONNECT 与仅 SOCKS5；若本机已有的可信 HTTP/mixed 代理可用，以只读方式针对 Docker Hub `registry-1.docker.io`、`auth.docker.io` 和必要的官方 layer CDN 做**小范围无登录、无镜像拉取**的 CONNECT/TLS/HTTP reachability 检查（401 若为 Registry 正常认证挑战）。不新安装软件、不创建代理、不修改 Clash/VPN，也不读取/输出私有凭据/代理地址。若没可信可用的 HTTP 代理直接 RETURN，告知具体阻碍。
3. **优先无全局修改路径**：只有当现有 Docker Desktop 继承代理对应真实验证的可用 HTTP/HTTPS 路径，而且有新的直接证据支持可成功经过 Docker Desktop，才允许使用**原代理设置**做一次指定 Meili pull。不能把 Host HTTP 检测独自当成 Engine 成功证明；若缺证据可优先走本 Gate 的可逆代理改动分支。
4. **条件临时设置分支**（需此 Gate 明确 Owner 代理修改授权）：如果确认确有可信、可访问的既有 HTTP/HTTPS 代理，而当前继承链路无效或协议不兼容，允许仅通过 Docker Desktop 官方 UI/API 安全设置途径，将 **Containers proxy** 从 `Same as host proxy` 临时改为 `Manual configuration`，使用经验证的已有 HTTP/HTTPS 代理；保持 `Docker Desktop proxy=System proxy` 不变。修改前在受保护本机记录可回退的非 Secret 模式元数据和必要的**受保护本机私有配置恢复信息**，不得让 URL/凭据离开机内；不得直接编辑 `settings-store.json`/daemon.json。如 GUI 无法可控操作或要求不受控的 Docker Desktop 重启/会影响当前其他用户项目，停并 RETURN，不用 CLI/私自重写代替。
5. 本轮最多一次官方 `docker pull getmeili/meilisearch:v1.41.0`；绝不重拉另两 GHCR 镜像。拉取前用无 Secret fixture 检测错误分类（内层 timeout/TLS/auth 应优先于笼统 `failed to copy`），记录本机真实开始时间/结束时间、返回码、官方 image digest（成功才写）、脱敏错误内层类别和是否出现 layers/CDN，不保存/上传原始 stderr/代理值/Secret；如失败不得再试。拉取前如做过临时代理设置，**在退出目标 pull 分支后首先恢复原来的 Containers proxy = Same as host proxy**、Docker Desktop proxy=System proxy 并 read-back；恢复失败立即 RETURN 和提示 Owner，严禁部署。
6. 如果三个官方镜像均 present 且 digest readback、代理状态恢复并被证明与 G1H 原始选择一致、非目标 Docker 对象无变化、实际无 OOM/失稳，则仅对 `karakeep-local` 运行 `docker compose -p karakeep-local up -d --pull never`，检查 Web 登录页/localhost only 的正负边界、Chrome/Meili 依赖、项目卷和服务 identity、资源稳定/现有 Docker 项目无新退化。不得注册账号或导入收藏。遇到异常仅 project-only `down` 不带 `-v`，保护安全文件和卷。
7. 任何阶段不得隐式修改 Windows System proxy、VPN/Clash、证书、Docker daemon/WSL、非目标 Docker 项目；不换镜像源/tag、不修改 Compose、不显示/轮换 Secret、不 `prune`。若可用的兼容 HTTP proxy 不存在或 Docker Desktop 不支持当前代理，报告精确未满足的条件/一项下一决策，不连续迭代无意义镜像拉取。

**MANDATORY_REVIEW_STOP**：首次达到诊断 RETURN 或 Karakeep `PASS_CANDIDATE` 后，向 GitHub `EXECUTION_EVIDENCE.md` append 规范脱敏记录并读回 main，停 Reviewer；不自动注册账号、不继续下一 Gate。

**TARGET_AND_SCOPE**：Owner Windows 本机现有 `USERPROFILE\KarakeepLocal` 和三个冻结官方镜像；可选仅临时 Docker Desktop `Containers proxy` 单项，禁止更改 Docker Desktop proxy（System proxy 原样）、Windows/System/Clash/VPN/Cert/daemon 设置、其它 Docker 对象。此代理切换虽有回滚，仍是同一桌面 Engine 的**共享设置**，执行前要证明当前不存在其它同时进行的 image pull/容器关键网络依赖。

**APPLICABLE_CRITICAL_CONSTRAINTS**：真实 Owner host、密钥受保护、同官方镜像/哈希、read-before-write、无固定 RAM 下限但监测真实 OOM/重启、网络/业务负面验证、共享代理的 Owner 独立授权、失败先复原代理再停目标项目、原配置和成功镜像全部保留、Evidence 仅白名单脱敏事实。

**PREFLIGHT**：Owner 明确授权两件事（本 Gate 必需）：①允许最小项目镜像下载/启动；②必要时临时改动并恢复 Docker Desktop `Containers proxy`。需要已有 HTTP/HTTPS 代理地址与协议**仅机内可靠发现和验证**，不要求 Owner 将地址或口令发给 Reviewer。若没有可验证现成合法安全路径，停而不改。Docker Desktop UI/API 可控、共享活动不受影响与回退机制必须在设置改动前有证据。

**REQUIRED_EVIDENCE**：在 `EXECUTION_EVIDENCE.md` 追加 `G1I` 固定规范字段（AUTHORIZED_GATE、PREFLIGHT_FACTS、ACTUAL_CHANGES、OBJECTIVE_READBACK、VALIDATION、ANOMALIES、EVIDENCE_ARTIFACTS_AND_PURPOSE、ROLLBACK_EFFECT、RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT、EXECUTOR_RESULT）。最少记录两代理模式 Owner UI 基线和本机结果、候选代理**协议/可用性类别**（无地址）、registry/auth/CDN 只读检查结论、共享代理是否有临时设置/回退验证、仅一次目标 pull 的时间/状态/RepoDigest/内层脱敏错误、项目级启动/localhost/非目标快照、实际资源/秘密边界。只提交脱敏证据，所有秘密停留在本机受保护执行环境。

**ACCEPTANCE_CRITERIA**：条件诊断必须为可行动事实；不能把 Windows Host 直连超时推定为 daemon 根因。若设置修改发生，必须完成双模式原样恢复以及非目标 Docker 无回归证据才可部署或报告该分支通过。若完成部署：三服务官方 image identity 已读回、Web 登录页实际可达、只 localhost:3000、内部 Chrome/Meili 依赖可用、只产生本项目专用对象、无实际 OOM/失稳、无 Secret 泄漏、Evidence main 读回。任何无法满足的要求用精准 RETURN；Executor PASS_CANDIDATE != Reviewer PASS。

**ROLLBACK_STATUS_OR_PLAN**：Docker Desktop 代理模式恢复先于新应用启动，设置写入前冻结 G1H 原始值：Containers proxy=Same as host proxy，Desktop proxy=System proxy。仅允许项目专用 `down`（无 `-v`）恢复 Karakeep 初装；原项目未运行，原配置/.env/两 GHCR 镜像和可能部分 Meili layers 均保留。若代理恢复失败，立即停止任何后续写入并向 Owner 报告，不擅自重置整个 Docker Desktop。

**OWNER_ONLY_ACTIONS**：Owner 需明确授权：“我授权 G1I 在必要时临时修改并恢复 Docker Desktop Containers proxy（影响 Docker Desktop 共享代理设置），仅拉取官方 Meilisearch 一次，成功后只启动本地 Karakeep；不改 Windows 系统代理/VPN/其他 Docker 项目。”无该授权不得执行此 Gate。Owner 原来的 G1H 截图不构成本授权。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner Windows 本机 Codex Executor。仅在 Owner 明确授权 G1I 两项边界后执行。读取 GitHub `entropy-student/project` main 的 `karakeep-local/REVIEWER_HANDOFF.md` 中 CURRENT_GATE、SYSTEM_MAP、CURRENT_ACCEPTED_STATE 和 CRITICAL_CONSTRAINTS，及 `EXECUTION_EVIDENCE.md` 最新 G1G 小节。G1H 经 Owner 截图：Docker Desktop proxy=System proxy；Containers proxy=Same as host proxy。首先验证当前 Windows 系统代理是否为真正可用的 HTTP/HTTPS 代理、Docker Hub registry/auth/CDN 是否经该现有代理安全可达；若需且存在合格本机 HTTP proxy，本轮经 Owner 明确授权可**临时只更改 Containers proxy** 为 Manual，其他代理/Windows 系统/Clash/VPN/证书/daemon 不变，安全验证后对官方 `getmeili/meilisearch:v1.41.0` 只 pull 一次；无论成功失败都必须恢复 G1H 原模式并读回，恢复失败严禁继续部署。原两个 GHCR 镜像和受保护 Compose/.env 复用，既有其它 Docker 项目绝不可修改。只有所有三镜像就绪、恢复与状态验证合格，才可只启动 `karakeep-local` 且 Web 仅 127.0.0.1:3000，验证三服务/其它项目不变。若任何条件不满足则精准 RETURN，不盲目重试。G1I Evidence 脱敏 append main/read-back 后停 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
仅 Owner 实体 Windows 本机；现有原版 Compose/.env/Secret 与 GHCR 镜像复用；仅官方 Meili；不改其它 Docker 项目、Windows System proxy、Clash/VPN、证书/WSL/daemon；Docker Desktop Containers proxy 只可在明确授权下临时改动且必须复原；无任意 RAM 数值门槛；项目 localhost-only；只提交脱敏证据，严守 Reviewer stop。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 本机原生 PowerShell Codex。G1I 仍需 Owner 新一轮明确授权。

## CURRENT_ROLLBACK_STATUS
Karakeep 未启动、无项目卷或真实资料，现有两 GHCR 镜像/原 Compose/.env 受保护。G1I 计划：代理设置 G1H 原值回退、目标项目级 `down` 不带 `-v`；尚未验证实际回滚功能，状态 `PLAN_ONLY`，不能声称已执行。后续真实数据/Secret 异机恢复仍 UNVERIFIED。

## UNRESOLVED
当前 System proxy 与 Docker Desktop 实际 pull 路径的 HTTP/SOCKS 协议兼容与外网可达性；Docker Hub Meilisearch 上次失败的具体内层错误；是否能以可逆 Desktop-only 代理覆盖恢复下载。历史 WinINET 变化原因没有证据，暂不单独追究。

## NEXT_STEP
等待 Owner 对 G1I 的最小权限明确授权；然后本机 Codex 在一轮内按证据验证 HTTP/HTTPS 代理路径、必要时临时设置 Containers proxy、一次下载官方 Meili、恢复原代理并条件启动 Karakeep。任何原因无法执行则精准 RETURN，不改其它项目。

## OWNER_ACTION_REQUIRED
**授权前不运行 Codex**。Owner 若同意 G1I 共享 Docker Desktop 代理的临时可逆修改及一次目标下载/条件启动，请明确回复授权；未授权时保持 Docker Desktop 当前 System / Same as host 两模式不变，无需提供任何密钥/代理地址。

## EVIDENCE_POINTERS
G1G `EXECUTION_EVIDENCE.md` commit `2a2ba90bafe0c68048720b87cbba5ddce77c150b` blob `9c77c352eb2766c308f7dfe1aa7c011fb62a0db4`。Owner G1H 代理模式取自 2026-10-16 当前对话截图（OWNER_REPORTED，只记录两枚模式名称，不上传截图或任何代理值）。历史 G0–G1F 保留原 append-only Evidence。
