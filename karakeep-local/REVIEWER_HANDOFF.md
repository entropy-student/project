# Karakeep Local · Reviewer Handoff

> 当前状态：`NOT_DEPLOYED` · 2026-10-16
> 治理权威：`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> 本文件是 Reviewer 接受的当前状态；历史事实只读引用 `EXECUTION_EVIDENCE.md`，不得覆盖历史。

## PROJECT_GOAL
在 Owner Windows 11 本机最小改动部署 Karakeep 官方 Docker Compose 三服务，使用原生 Web UI，仅 `http://127.0.0.1:3000` 访问。首轮只验证服务和登录页；Owner 首次注册、中文设置、收藏测试在通过后开展。不改上游源码、不接 AI API/Codex、不发布公网、不改其它 Docker 项目。

## PROJECT_STAGE
`G1C_STOPPED-WORKLOAD-RECONCILE-AND-DEPLOY` 待本机 Executor。
- G0/G1/G1R 历史及 RETURN 保留在 Evidence；G1R 已创建安全目录、官方 Compose 和两个新随机密钥，磁盘/ACL 验证通过；上轮失败的拉取网络原因不明。
- **G1N 已经由 Reviewer 查验**：`EXECUTION_EVIDENCE.md` `main` blob `2e8df6d432bdf00c4abe5f28d4faa22afaee444d`（提交 `d399c8776c188f3a153b4e6e95f4d5bf371a53f2`）。接受其事实和停机决定：仅只读检查、Karakeep 未启动、20 个 Docker 容器均 `exited`，而先前其中 3 个运行；Host GHCR 可达、Host Docker Hub 超时，**daemon 真正拉取路径未测试**。结果 `RETURN_PREFLIGHT_DRIFT_EXISTING_CONTAINERS_STOPPED + RETURN_REGISTRY_HOST_TIMEOUT`，不追溯修改。
- Reviewer 裁决：`20 exited / 0 running` 是**本机其他服务当前观测状态**，不能自动归因 Karakeep，也**不要求恢复旧的 3 个容器**。先用最小只读检查判断是否存在 Docker Engine 整体故障/非目标数据风险；若没有积极的异常证据且项目边界仍清晰，可将非目标容器的停止状态作为 G1C 的新对照基线，允许受限 Karakeep 拉取与安装。若 Engine 不稳、OOM/存储故障、异常的自动重启/服务状态变化、或用户既有数据完整性风险无法排除，则 RETURN。禁止仅凭 Docker 容器数量变化推测原因。

## SYSTEM_MAP
- Owner Windows 11 原生 PowerShell 7.6.5、Docker Desktop Linux Engine 29.7.2、Compose v5.4.0、context `desktop-linux`；G1N 已核实，G1C 部署前新鲜复核。
- Karakeep 本机配置：受保护的 `$env:USERPROFILE\KarakeepLocal\docker-compose.yml` 和 `.env`。Compose SHA-256：`cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；官方 Compose blob `865bb147cef972926d5dc32e50645876fd110555`。
- Compose 项目 `karakeep-local`：官方 `web` (`ghcr.io/karakeep-app/karakeep:release`), `chrome` (`ghcr.io/karakeep-app/karakeep-chrome:release`), `meilisearch` (`getmeili/meilisearch:v1.41.0`)。仅 web 发布 `127.0.0.1:3000:3000`，其它服务无 host ports。
- 持久卷（尚未创建）：`karakeep-local_data`、`karakeep-local_meilisearch`；以 `docker compose -p karakeep-local` 隔离。G1R 验证的 Docker Engine/数据盘映射允许初装（要求可靠空余 >=8 GiB），但不构成未来用户数据的备份验证。
- 已有新 Secret：NEXTAUTH_SECRET、MEILI_MASTER_KEY，严格保护；不得显示、再生、替换、复制或输出 hash；无 AI API key。文件 ACL 仅当前用户、SYSTEM、Administrators。
- 非目标：既有 WordPress CLI/Web（历史发布 8189）、MariaDB 等容器；G1N 记录 20 个全部退出且原因时间未知。**不自动启动/停止/重建**它们、改变其 restart policy，或清理其卷/镜像。
- NETWORK：Windows Host `ghcr.io` DNS/TCP/TLS 成功、`/v2/` 返回预期 401；`registry-1.docker.io` Host 443 超时；WinHTTP 直连，Windows/Engine HTTP 代理均存在（未输出详情）；Docker Desktop daemon pull 行为仍未知。
- BACKUP/RESTORE：项目尚无真实收藏；若启动异常只允许停止项目容器并保留 `.env`/卷；不 `down -v` 或 `prune`。Secret 异机恢复和真实资料备份恢复仍 `UNVERIFIED`。

## CURRENT_ACCEPTED_STATE
G1N `DIRECT_READBACK`：Compose 内容 fingerprint、leaf ACL、四个 env key 格式、端口与卷声明均有效；无 Karakeep images/container/volume，Windows 3000 未监听；宿主可用内存 2064 MiB（仅观测，不作为启动门槛）、C: 剩余 188.5 GiB；20 个其它 Docker 容器均 exited；既有三项此前运行状态的原因 `UNKNOWN`。
G1N 对 Host GHCR 的访问成功和 Docker Hub 连接超时只能证明 **Host 路径**，不能证明 Docker Desktop daemon 的 pull 路径。没有执行 pull/up。
**Reviewer 接受 G1N 的 RETURN**，历史 Evidence 不修改；下一 Gate 先核实非目标状态，再按独立项目边界推进。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1C-EXISTING-STATE-AND-PULL-20261016`
**OBJECTIVE**：不碰其他服务的情况下，核实 Docker Engine 能否安全运行新的隔离项目，并尽可能完成 Karakeep 官方三镜像拉取和 localhost Web 启动。

**MAX_ENDPOINT_THIS_ROUND**：
1. 只读确认 Owner Windows 原生 PowerShell、本机 Docker Desktop context/Engine、Karakeep 原始配置/Secret ACL/hash 和 `config --quiet`，项目无碰撞、3000 空闲、Docker 实际可用磁盘、当前内存（数值只记录）。
2. 仅对**原 G1N 记录中的 3 个非目标容器**（执行环境内部辨认原 WordPress CLI/Web 和 MariaDB）做小范围 `docker inspect`，读取 `State.Status/ExitCode/OOMKilled/StartedAt/FinishedAt`、restart policy、必要的 daemon 近期事件元数据及引擎错误/状态；可用时用不包含 Secret 的系统元数据对照。不得查看/回传环境值、业务数据库内容、原始业务 logs。不能确定停止原因时标 `UNKNOWN`，不以猜测定为健康或人为操作。
3. **Reviewer 预定义的新基线规则**：若 Engine 可用且稳定、目标没有对象冲突、非目标对象现状可明确固定，未发现 Docker 系统性异常、OOM/持续非预期重启或影响既有数据的活动故障，则接受当下非目标容器为 `EXISTING_EXITED_BASELINE`（不要求 3 个重新启动），并允许继续下一步。即使停止原因 `UNKNOWN`，也不得仅因它们不是 running 而再次返回。若有积极的高风险异常迹象/本机不稳则 RETURN，不擅自修复他项目。
4. 只读检查 Docker Desktop 代理模式/目标 registry reachability 的脱敏分类。若允许本轮诊断 pull，**仅对冻结 Compose 中的官方镜像执行有边界的单次 pull**：先 GHCR 目标镜像，若成功再其余两个官方镜像（含 Docker Hub）。捕获并在本机内当场脱敏分类 DNS/TCP/TLS/cert/proxy/401/403/timeout/rate-limit 等；单一镜像失败即停止，无同一错误的无依据重试。
5. 全部目标镜像有确实可用的 digest、目标安全前提仍通过、无现有项目状态恶化时，允许 `docker compose -p karakeep-local up -d --pull never`（先核实 Compose 版本支持该语义）只部署 Karakeep，并验证 Web 登录页、内部服务及负面端口边界、容器重启/OOM/宿主稳定性。绝不注册账户、接 AI API、导入真实资料或进入下一 Gate。

**MANDATORY_REVIEW_STOP**：G1C 执行结束（包括失败）必须追加 Evidence、提交并从 main 读回，停在 Reviewer；不得自动继续。

**TARGET_AND_SCOPE**：仅 Owner Windows 本机、已存在的安全配置目录、官方 Compose 三镜像、新 `karakeep-local` 项目及明确的两个专用命名卷。非目标 Docker 项目、主机网络、代理/Clash/VPN、Docker Desktop daemon/WSL、证书/安全设置一律只读且禁止修改。

**APPLICABLE_CRITICAL_CONSTRAINTS**：
- 复用旧 `.env` 和 Compose，不输出/再造/改密钥；ACL、hash 必须吻合已接受数据，若不符 RETURN。
- 不允许 Executor 自动恢复那三个停止的非目标容器，亦不可以因为它们退出就假定有故障。要记录并固定 **进入本 Gate 时的真实状态**，部署后证明目标以外的对象未被本次执行改变；非目标原本已停止时不能声称其业务服务可用。
- 取消所有自定的固定剩余 RAM 2GiB/0.8GiB 阈值。实时观测即可；一旦有实际 OOM、系统明显失稳、持续重启或非目标对象出现新的退化，立即仅停止 Karakeep 并 RETURN。
- Host 对 Docker Hub 超时不等于 Engine 拉取必然失败；镜像必须走官方原始地址。不得 `insecure-registries`、证书跳过、镜像替换、代理设置修改或重建已停项目。
- 仅本机 127.0.0.1:3000 暴露 Web；无公网/局域网服务端口。
- 任何原始 Docker 错误、Secret-bearing 日志、代理 URL/凭据只在受保护本机分析；Evidence 只保留脱敏错误类别/非私人可审证据。
- 仓库存储端仅项目级 Evidence 更新；严禁对 GitHub 提交 `.env`、Secret、数据卷及原始系统 logs。

**PREFLIGHT**：本机/Engine 正常；安全配置 read-back；磁盘后端剩余 >=8 GiB；端口未占用且项目无对象碰撞；非目标状态/故障类已只读归类，没有实际高风险异常；网络探测不改变宿主设置。无强制宿主空闲 RAM 数值。

**REQUIRED_EVIDENCE**：追加 `karakeep-local/EXECUTION_EVIDENCE.md` 的 G1C，明确三个原有容器开始/结束状态（无名字/私密内容）、`ExitCode/OOMKilled` 的汇总、停止原因的证据等级、未恢复它们、Docker Engine 健康分类、Host vs daemon registry 可达性分类、镜像 pull 尝试数/结果与 digest（成功才写）、新的 Karakeep 容器及卷状态、localhost 访问和非 loopback 负面检查、资源前后与仅项目级回滚情况。按已有字段组织，提交 main 并读回。

**ACCEPTANCE_CRITERIA**：
- 诊断分支：说明基线漂移是否可接纳与具体证据；若不能部署，具体指出安全/网络/引擎的阻碍和是否做过 pull，不含猜测。
- 部署分支：已存在安全配置完整、三个官方服务成功运行、数据库/搜索/浏览器依赖和本机登录页可用、3000 仅回环、其它服务 host ports 未新增、既有 Docker 容器/卷/网络未被改动，运行稳定且无真实 OOM；提交可审镜像身份/digest 和 Evidence 读回。无账户/收藏数据。
- 不能以 `docker ps running` 或 HTTP 200 单一信号替代完整检查。Executor `PASS_CANDIDATE` 不等于 Reviewer PASS。

**ROLLBACK_STATUS_OR_PLAN**：镜像 pull 失败则保留已经拉取的官方目标镜像、不额外清理；服务启动后如异常，确认项目 label/name 后仅 `docker compose -p karakeep-local down`（绝不 `-v`），保留现有 Secret/Compose/独立卷。禁止 `prune`，不可触碰非目标数据。唯一业务数据仍为空，备份/跨设备恢复未验证。

**OWNER_ONLY_ACTIONS**：Owner 转交本轮明确授权：仅限 Karakeep 三个官方镜像受限拉取和合格前提下的项目级首次启动；不授权重新启动任何原有 WordPress/MariaDB 服务，不授权任何全局代理/daemon/证书/ACL 改变，不授权注册或真实数据导入。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Windows 本机 Codex Executor。读取最新 main `karakeep-local/REVIEWER_HANDOFF.md` 的 CURRENT_GATE、SYSTEM_MAP、CURRENT_ACCEPTED_STATE、CRITICAL_CONSTRAINTS，并读取 `karakeep-local/EXECUTION_EVIDENCE.md` 最新 G1N 小节作为现有证据。不要重做 G0/G1/G1R。执行 `KARAKEEP-WIN-G1C-EXISTING-STATE-AND-PULL-20261016`：先只读核实 3 个原有容器为何/如何退出（未知如实标 UNKNOWN），没有明确系统故障时以当前 exited 状态作为非目标基线，不为此自动恢复。按 Gate 新鲜检查安全配置、端口、磁盘和 Docker 稳定；允许诊断和**每目标镜像一次**受限官方 pull，失败分类后停止。若三个镜像拉取并验证成功，按现有 Compose 只启动 `karakeep-local`，核验 `127.0.0.1:3000` 与资源和隔离；禁止改其他容器、代理/VPN/WSL/daemon/证书/密钥。输出脱敏 Evidence 到 main 并读回，完成后在 Reviewer 处停止。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
原生 Windows 本机；仅官方原版、localhost；沿用既有受保护配置/Secret；严禁修改非目标三容器及数据/网络/全局设置；不因 RAM 静态数值或既有容器单纯 exited 反复终止；但主动发现系统性危险则停。未达到部署证据不得声称成功。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 本机 PowerShell Codex（G0–G1N 已验证有效）。

## CURRENT_ROLLBACK_STATUS
当前没有任何 Karakeep 容器或项目卷，现有安全配置/密钥保留；真实业务资料尚无。项目级 `down` 无 `-v` 为恢复计划 `PLAN_ONLY`，实际远程备份/恢复 `UNVERIFIED`。

## UNRESOLVED
既有三个容器退出的准确原因/发生时间未确认；需新鲜只读核验是否安全；Docker Desktop daemon 真实 pull 路径、Docker Hub timeout 是否仍现、目标官方镜像能否拉取；Karakeep 服务还未跑起来。

## NEXT_STEP
Owner 转交 G1C 给 Windows 本机 Codex；通过非目标状态判定后对官方镜像有边界拉取并视结果启动，复核 Evidence。

## OWNER_ACTION_REQUIRED
Owner 需明确授权本 G1C 的仅项目镜像拉取和合格后的初装；无需提供 Secret，无需恢复/关闭其他 Docker 应用。

## EVIDENCE_POINTERS
`karakeep-local/EXECUTION_EVIDENCE.md`：G0、G1、G1R、G1N（最新提交 `d399c8776c188f3a153b4e6e95f4d5bf371a53f2`，blob `2e8df6d432bdf00c4abe5f28d4faa22afaee444d`），后续 G1C 追加。
