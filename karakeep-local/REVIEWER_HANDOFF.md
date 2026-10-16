# Karakeep Local · Reviewer Handoff

> 2026-10-16 · `NOT_DEPLOYED` · Reviewer accepted Gate: `KARAKEEP-WIN-G1G-HUB-PROXY-ROOTCAUSE-20261016`
> Governance: `entropy-student/spike.skill` `main:vps-project-governance/VNEXT.md` v0.2.7
> Current project truth in this Handoff; historical execution proof in append-only `EXECUTION_EVIDENCE.md`.

## PROJECT_GOAL
在 Owner Windows 11 本机部署原版 Karakeep 官方 Docker Compose 三服务；首次网页只绑定 `127.0.0.1:3000`。最小改动，不开发、不加 AI key、不注册或导入真实收藏、不影响其它 Docker 项目。

## PROJECT_STAGE
**当前：G1G 只读代理根因诊断（NEXT）；应用仍 `NOT_DEPLOYED`。**

| 阶段 | 经 Reviewer 接受的有效结果 | 当前判定 |
|---|---|---|
| G0–G1 | 本机 Windows / Docker 环境、端口、项目边界识别；原失败证据保留 | PARTIAL |
| G1R | 创建受保护原版 Compose、.env 和两个随机 Secret，完成目录权限与存储检查 | PARTIAL（部署未通过） |
| G1C | 成功拉取并核对 Karakeep Web、Chrome 两个官方 GHCR 镜像 RepoDigest | PARTIAL（Meilisearch 未下载） |
| G1E | 原位置配置和 Secret 当前可安全读取；Docker 网络新鲜快照稳定 | PASS（仅诊断） |
| G1F | 官方 Meilisearch 单次 pull 在 10 秒内失败，错误归类宽泛，未启动 | RETURN |
| G1G | 确认 Docker Desktop `Containers proxy` 实际模式及已有日志，给出一个可执行的修复决定 | NEXT |
| 后续部署 | 取得官方 Meili 镜像后，仅启动独立 `karakeep-local` 并验收 localhost:3000 | PENDING |
| 后续使用 | Owner 注册/中文界面/收藏测试，以及真实数据前的恢复准备 | PENDING |

**已接受的当前事实**：G1F Evidence commit `620137a07297cee3d5cd5716fab42685b06b89b6` / blob `02b69eae4c6470094d9383b26300c5c60eadc623` 已由 Reviewer 核验。G1F 的 `RETURN_MEILI_PULL_LAYER_DOWNLOAD_OR_EXTRACT` 是有效停止，但分类没有实际下载进度旁证，根因仍 UNKNOWN。之前历史记录不改写、不重跑 G0–G1F。
**当前真正阻碍**：仅 Meilisearch 官方 Docker Hub 镜像不能成功拉取；不允许把 Windows 直连超时直接归因为 Docker Desktop daemon 故障，不允许无新增证据地反复 pull。
**本轮策略**：优先让诊断带来一项明确的下一步决定；G1G 只读，不修改代理、不 pull、不 up。如果必须更改共享代理，下一步必须事先给 Owner 影响范围和回滚计划，不能在 G1G 隐式扩大权限。
## SYSTEM_MAP
- TARGET: Owner Windows 11，原生 PowerShell 7.6.5，Docker Desktop Linux Engine 29.7.2 / Compose v5.4.0 / `desktop-linux`（G1F）；云端 Reviewer 不能直接改实体主机。
- CONFIG: `$env:USERPROFILE\KarakeepLocal\docker-compose.yml`，本地 SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`，官方 Compose blob `865bb147cef972926d5dc32e50645876fd110555`；同目录保护的 `.env` 仅含四键 `KARAKEEP_VERSION/NEXTAUTH_SECRET/MEILI_MASTER_KEY/NEXTAUTH_URL`。G1F ACL 和两 Secret 格式通过，历史 Secret 字节连续性仍 `UNVERIFIED` 但首装无实际数据依赖，允许复用。值不入聊天/GitHub/日志。
- TARGET_IMAGES_ACCEPTED:
  - `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  `getmeili/meilisearch:v1.41.0` 来自官方 Docker Hub，尚未成功。不要重新拉 GHCR 镜像/替换官方 Meili 镜像或 tag。
- PROJECT: `docker compose -p karakeep-local`; 服务 web/chrome/meilisearch；Web 仅 `127.0.0.1:3000:3000`，其他服务无 Host port；预期 named volumes `karakeep-local_data`、`karakeep-local_meilisearch`，均尚未创建。
- NON_TARGET: G1F 结束 20 容器（1 created /19 exited /0 running）、12 volumes、11 networks，连同其它 WordPress/MariaDB 均为当前非目标基线，不自动启动、清理或修改。原 MariaDB 历史 unhealthy 与退出原因未明，不归因本项目。
- NETWORK: GHCR 使用 Docker Desktop daemon pull 已成功；Windows Host 直连 `registry-1.docker.io`/auth/layer CDN 的 443 曾超时，不等于 daemon 内部代理一定失效。Windows Internet proxy 在 G1E disabled、G1F enabled（没有本项目设置写入）；WinHTTP direct，Docker Engine 存在 HTTP/HTTPS 代理，先前只读分类为 Docker Desktop internal alias。Docker Desktop `Containers proxy` 对所有 `docker pull` 生效。
- DIAG_SOURCES: Docker 官方文档给出 Windows `%LOCALAPPDATA%\Docker\log\host\httpproxy.log` 代理日志与 `%APPDATA%\Docker\settings-store.json` 配置位置作为可选只读候选路径（仅在 Owner 真实 Windows 目标存在时使用，不假定固定路径必存在）；参考 `https://docs.docker.com/desktop/troubleshoot-and-support/faqs/general/`、`https://docs.docker.com/desktop/troubleshoot-and-support/troubleshoot/topics/`、`https://docs.docker.com/desktop/settings-and-maintenance/settings/`。真实代理值、日志、证书、内部 URL、凭据严格私有，项目 Evidence 只能记录 allowlisted 模式/结果。
- STORAGE: 本机约 184.7 GiB C: 余量，Docker storage mapping 先前通过。内存最近 2495 MiB（G1F 后），**Owner 已取消任何固定空闲 RAM 限制**；未发生实际 OOM；只在真正部署时观察稳定性。
- RECOVERY: 尚无数据库/账号/收藏；受保护 .env 保留。后续仅 Karakeep 部署故障可 `docker compose -p karakeep-local down`，禁 `-v`，保留卷。未来真实收藏前须有 Secret 恢复和数据备份，均 `UNVERIFIED`。
- EXECUTION_CHANNEL: Owner 本机 Codex / PowerShell。

## CURRENT_ACCEPTED_STATE
G1F 完成了本轮授权的一次指定 Meili pull，失败且确实停止；两个原官方 GHCR 镜像的 RepoDigest 仍在；安全配置、项目隔离和本机 3000 空闲均已读回；没有 Compose up/down、容器/卷创建，也没有其它项目改动。此为 **正式 RETURN**，不是 G1F PASS；现场错误因原始消息丢弃而尚不能细分。
G1E 早先 file visibility/network identity 历史差异仍 UNKNOWN，但当前配置通过，非目标对象稳定，均不作为重复诊断目标。
下一步须定位究竟是 Docker Desktop proxy 的模式/CONNECT、Hub registry/auth、镜像 layer CDN、还是无日志可核实；尚未批准再次 pull，更未批准代理修改。

## CURRENT_GATE
**GATE_ID**: `KARAKEEP-WIN-G1G-HUB-PROXY-ROOTCAUSE-20261016`

**OBJECTIVE**: 以一次尽可能充分但有界的**只读**诊断，形成 Meilisearch Docker Hub 拉取失败的可行动原因与下一步修复选择，避免继续拉取同一失败镜像却仍只能返回模糊错误。

**DIAGNOSTIC_PRIORITY / EVIDENCE_LIMIT**:
- 按 Docker 官方设置语义，**先确定 `Containers proxy` 的 mode**（其控制所有 image pull）；它没有专属配置时才检查 `Docker Desktop proxy` 的 fallback。区分 Windows Internet proxy 开关与 Docker Desktop 代理实际模式，不以 Windows 直连失败判断 daemon。
- 用现有 Docker Desktop 代理设置与 G1F 时段日志做有界只读分类；只写到 Evidence 的非秘密结论。没有日志或无法读出关键代理模式时明确 `UNVERIFIED`，不虚构根因，也不扩大为无穷查找。
- **必须输出唯一下一动作**：A. 有直接证据支持的 Docker Desktop 代理修复方案（待 Owner 单独授权并可回滚）；B. 有必要且可收敛的一次新的目标网络验证（列出明确新增信息与授权边界）；C. 已确认无需改共享配置的正常下载路径（也只能留待下一 Gate 授权执行）。若三者都没有证据支持，则给出具体缺失的证据和一项最小可行 Owner 本机核验，不得笼统要求“再试一次”或扩大项目范围。

**MAX_ENDPOINT_THIS_ROUND**:
1. 最小 read-only preflight：确认原 Owner Windows 本机、Docker Engine/context、既有 Compose 与安全文件当前存在（仅存在性/哈希与保护 metadata）、两个 GHCR 镜像仍在；无需再跑旧 G0-G1F、旧文件丢失/网络 ID 追溯；不得读取 .env 明文或检查 Secret 值。
2. 优先检查 Docker Desktop 官方支持的 **Settings > Resources > Proxies** 的 `Docker Desktop proxy` 与 `Containers proxy` 模式（`system | no_proxy | manual | same_as_host | unknown` 等），本机 `%APPDATA%\Docker\settings-store.json` 如实际存在，**只分析 allowlisted proxy-mode 键**；Windows Internet proxy/WinHTTP 模式、Docker Engine 内部 proxy 存在性、当前是否处于同一个网络上下文。不得输出/复制代理地址、PAC 正文、cookie/凭据、环境值或未经审查的配置文件。
3. 仅在本机真实存在时读取 `%LOCALAPPDATA%\Docker\log\host\httpproxy.log` 的**局部只读**相关窗口及同目录官方可识别的 proxy/engine 日志候选；优先关联 G1F 镜像拉取对应近时段。原始日志仅在本机受保护进程内处理，保留**非敏感 allowlist 结果**：有无相关请求、`registry/auth/CDN` 的域名类别、通过哪条代理模式、是否 CONNECT、HTTP 代码或 TLS/EOF/timeout/identity 等错误类别、证据时间区间、是否存在日志路径。绝不将原始日志行、URL/IP、鉴权/令牌、用户名、证书细节上传 GitHub。若日志无对应时段则 `HISTORICAL_LOG_UNAVAILABLE`，不得伪造。
4. 若官方路径不存在，可只读使用 Docker Desktop 现有 CLI/Engine 提供的**非破坏性诊断/代理状态查询**，不得采集/上传大包或导致敏感内容进入普通报告；只能收集本地一次经过脱敏的分类。新网络连通性查询必须无认证/无镜像拉取，不访问第三方服务或其它用户项目。可对 Docker Hub `registry-1.docker.io`、`auth.docker.io`、公开 image-layer CDN 用**本机安全且已验证的代理/直连测试**区分是否可达，不能通过 Windows Host 失败推断 daemon 失败；代理凭据不能出进程边界。
5. 对 G1F `LAYER_DOWNLOAD_OR_EXTRACT` 的宽泛匹配做**无 Secret 的模拟测试审计**，确认分类器是否将 `failed to copy` / `failed to do request` 等网络错误误分为解压；不能凭 fixture 宣称 G1F 的真实错误已被重分类。
6. **本 Gate 禁止 `docker pull`、`docker compose up/down`、更改项目配置或 Secret、修改 Docker Desktop/Windows/Clash/VPN/证书/DNS/daemon/WSL、启动停止其它 Docker 容器、pull 其他镜像或 prune。** 若因缺少历史日志不能细分，输出证据限制以及**唯一最小下一动作**的选择：Owner 授权受限 Desktop proxy 设置修复（若有直接证据）、Owner 授权另一种有限新诊断（若必要）或明确外部网络阻塞；不要只返回 `UNKNOWN`。

**MANDATORY_REVIEW_STOP**：G1G 无本机写入，完成诊断后仅向 GitHub `karakeep-local/EXECUTION_EVIDENCE.md` append 脱敏证据，提交 main 读回，停在 Reviewer。

**TARGET_AND_SCOPE**：Owner 本机 PowerShell、明确 Docker Desktop 的官方 settings/log 文件与代理模式/registry connectivity metadata、已接受项目 Docker 只读 metadata；不能进入其它容器、读取业务数据库/用户数据或用代理控制面写设置。

**APPLICABLE_CRITICAL_CONSTRAINTS**:
- 不修改 Docker/Windows/共享服务任何设置，不生成新文件、临时日志、诊断 zip、Secret 恢复物，也不输出敏感网络/账户细节到聊天/GitHub；本 Gate 只允许 GitHub Evidence append。
- 只读日志解析本身不能导致原始 Secret 漏出；按白名单抽取结果，若无法可靠脱敏，停止该探针并记录 `UNVERIFIED`。
- 无需证明历史代理切换的因果，只需报告本次当前有效模式及和 G1F 记录的关系。
- 不以静态空闲 RAM 数字阻断诊断；不触及既有 20 容器/12 卷/11 网络。
- 没有新的 pull 授权，本轮**不允许条件部署**；明确诊断结论后再设计小范围的修复/部署 Gate。

**PREFLIGHT**：Docker Engine/Owner Windows 本机身份可复核；官方配置存在且未发生未经允许变化；日志/Settings 路径先检视元数据，确定权限/敏感信息边界后才局部读取。

**REQUIRED_EVIDENCE**：
- 追加 `EXECUTION_EVIDENCE.md` G1G section，包含正式 Gate、真实本机边界、proxy `mode only`、日志可用性/时间窗口、G1F 真实错误是否有进一步可审旁证（或不能）、Host 与 Desktop/daemon 路径分别是否可证、模拟分类器问题（如有）、准确下一步需要的 Owner 权限范围、零本机变更/其它项目不变/rollback NONE、最小 Evidence pointer。
- 保留规范固定字段与 `DIRECT_READBACK | INFERRED | UNVERIFIED` 分类；GitHub main append-only + read-back。

**ACCEPTANCE_CRITERIA**：
- 即使日志不可用，也至少明确**为什么不能确认** Meili 拉取低层原因，当前 Desktop `Containers proxy` 模式是否能验证、是否能排除/定位为网络代理子域，给出不是“盲重试”的**一项具体下一步建议**；不能靠 `LAYER_DOWNLOAD_OR_EXTRACT` 假设磁盘故障。
- 无 Docker pull/up、无本机设置/文件/非目标项目写入；Evidence 脱敏 main 读回；历史未证实事实不冒充 PASS。
- G1G 诊断范围可 `PASS_CANDIDATE` 供 Reviewer 判断；整个 Karakeep 部署依旧 `NOT_DEPLOYED`。

**ROLLBACK_STATUS_OR_PLAN**：全部只读本机（GitHub Evidence append 除外），无 Docker/Windows 回滚；保留受保护配置/Secret、两个 GHCR 镜像及所有非目标对象，禁止主动清理部分下载层。

**OWNER_ONLY_ACTIONS**：Owner 不需提供任何 Secret 或亲自操作 Docker Desktop；只需转交本 Gate 的只读诊断给本机 Codex。后续若确需修改 Docker Desktop 全局 proxy/证书等，Reviewer 需先给 Owner 明确范围、影响、回退方式和授权请求。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner Windows 11 本机 PowerShell Codex Executor。仅读 `entropy-student/project` 最新 main 中 `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、SYSTEM_MAP、CURRENT_ACCEPTED_STATE、CRITICAL_CONSTRAINTS，以及 `karakeep-local/EXECUTION_EVIDENCE.md` **仅最新 G1F 段落**。执行 `KARAKEEP-WIN-G1G-HUB-PROXY-ROOTCAUSE-20261016`。G1F Docker Hub Meilisearch pull 失败，分类器给的是宽泛 layer 类，但无实际层进度；不能把它当已证实的解压问题。按 Docker 官方文档优先查看 Windows Docker Desktop settings 的 Resources > Proxies 模式及存在时的 `%APPDATA%\Docker\settings-store.json`、`%LOCALAPPDATA%\Docker\log\host\httpproxy.log`，只读在本机进行**脱敏分类**（不输出 URL/IP、凭据或原始日志）。限定原 G1F 时间附近的 registry/auth/CDN/CONNECT/timeout/TLS 类，必要时最小无凭据网络检查。**优先区分控制 docker pull 的 Containers proxy 模式与仅作回退的 Docker Desktop proxy 模式**；若无法直接核实，明确报告能和不能得知什么、证据缺口，并给出**唯一可执行的最小 Owner 决策/下一修复动作（含范围、风险、回退）**，禁止空泛 UNKNOWN 或重复旧检查。严禁再次 pull、up、修改任何代理/系统/密钥、动其它 Docker 项目。仅追加脱敏 Evidence、提交 main 并读回，按固定 Executor 结果汇报后停 Reviewer。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
受保护本机配置/Secret 复用；两个已成功 GHCR 镜像不重拉；缺失的 Meili 保留官方镜像身份；G1G 不允许新的 pull/up 或全局代理变更；日志只脱敏分类；不动别的 Docker 项目；没有人为 RAM 数值门槛，保持当前 `NOT_DEPLOYED`。

## DEFAULT_EXECUTION_CHANNEL
Owner 实体 Windows 11 的本机 PowerShell Codex。

## CURRENT_ROLLBACK_STATUS
尚无 Karakeep 运行容器、volumes 或真实资料；现有安全配置、2 个 GHCR 镜像保留。本轮仅只读无回滚。未来只停止本项目的回滚为 `PLAN_ONLY`；真实数据/密钥异机恢复 `UNVERIFIED`。

## UNRESOLVED
Docker Hub `getmeili/meilisearch:v1.41.0` pull 的实际底层网络/认证/CDN/TLS/存储子原因；Docker Desktop `Containers proxy` 模式和 G1F 时间日志是否可恢复。历史 Windows proxy 变化原因不归因 Codex，也不单独触发旧项目修复。

## NEXT_STEP
Owner 将本文件 G1G 交给本机 Codex，**一次性**定位 Docker Desktop `Containers proxy` 的有效模式、历史拉取失败可获得的旁证，并产出唯一下一步修复/核验选项。Reviewer 读回 G1G Evidence 后决定是否授权最小代理修复与 Meilisearch 完成下载，随后进入 Karakeep 本机部署；不无证据重试。

## OWNER_ACTION_REQUIRED
转发本轮 G1G 只读指令，不需 Owner 提供 Secret/修改系统。如得到证据表明必须改全局代理，Owner 在下一 Gate 单独决定。

## EVIDENCE_POINTERS
G1F `main:karakeep-local/EXECUTION_EVIDENCE.md` commit `620137a07297cee3d5cd5716fab42685b06b89b6`，blob `02b69eae4c6470094d9383b26300c5c60eadc623`；G0–G1E 历史保留。
