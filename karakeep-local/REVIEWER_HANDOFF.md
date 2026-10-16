# Karakeep Local · Reviewer Handoff

> DATE=2026-10-16 | PROJECT_STATUS=`NOT_DEPLOYED`
> CURRENT_GATE_ID=`KARAKEEP-WIN-G1J-REAL-BROWSER-PATH-REVALIDATION-20261016`
> GATE_STATUS=`READY_FOR_FRESH_OWNER_RELAY`
> GOVERNANCE=`entropy-student/spike.skill` main `vps-project-governance/VNEXT.md` v0.2.7
> Current authoritative project state is here; execution history remains append-only in `EXECUTION_EVIDENCE.md`.

## PROJECT_GOAL
在 Owner Windows 11 实体本机以 Karakeep 官方三容器 Compose 最小改动部署 Web + Chrome + Meilisearch，仅 Web 发布 `127.0.0.1:3000`。本轮只验证服务/实际浏览器依赖与登录页，不注册账户/新增真实收藏/AI API key，不对其它 Docker 项目做写入。

## PROJECT_STAGE
- **G0–G1R**：Windows / Docker / 配置目录 / 存储 / 项目边界已调查；已建立受保护 Compose 和原 `.env` 两 Secret。历史 RETURN 保留，不回放。
- **G1C/G1E**：Karakeep Web、Chrome 两 GHCR 官方镜像已下载且 digest 经核对；Compose SHA/Secret ACL 当前有效，网络现状稳定。G1E 只读范围 PASS。
- **G1F/G1G/G1H**：曾发生 Meilisearch Docker Hub pull 失败，代理诊断后 Owner 确认 Docker Desktop proxy System / Containers proxy Same as host，Clash UI 端口 7897（协议当时未明）。这些为历史和已解决下载路径，不再诊断。
- **G1I Reviewer accepted RETURN**：已实际读取 `main:karakeep-local/EXECUTION_EVIDENCE.md` G1I commit `e760ea202fe2e46560dd0692218a8fe8178a8bac`，blob `c300dc5d422cbbcbacc554a1bf8acdaf92e2a531`。**官方 Meilisearch 镜像一次 pull 成功**（30.2 秒），整个三镜像集合齐全。原 Compose 无改动、Windows/Docker Desktop 代理无改动。三容器曾成功启动，Web `http://localhost:3000` 及 Meili /health 200、仅 Web 发布 loopback、无 OOM/重启。但 G1I 的**人工直接 HTTP 访问 Chrome `chrome:9222`** 返回 500，`Host:127.0.0.1` 200，故依原 Gate 被返回且仅对本项目 `docker compose down`（无 -v），保留 2 volumes/3 镜像/.env。该 Gate 未证明应用实际 Worker 浏览器连接失败。
- **Reviewer 新发现（官方源事实）**：Karakeep 官方 `apps/workers/workers/utils/browser.ts` main blob `96192428e232c375680d989a49abb58bb897a6fb` 中 `startBrowserInstance()` 对 `BROWSER_WEB_URL=http://chrome:9222` 会先 `dns.promises.lookup(webUrl.hostname)`，将 hostname 替换为解析出的**实际 IP**，才 `chromium.connectOverCDP`。官方 `packages/trpc/routers/admin.ts` main blob `393114942bd4cc1c6778d12489068db6215d767f` 的状态检查同样先将 Host 替换成 IP。官方 `docker/docker-compose.yml` blob `865bb147cef972926d5dc32e50645876fd110555` 和 Chrome migration guide 保留 `BROWSER_WEB_URL=http://chrome:9222`。因此**直接用 `Host:chrome` 的裸 HTTP 探针被拒绝，只证实 Chrome 的 DevTools Host 安全限制，不证明 Karakeep 实际无法连接**。这是 Reviewer 发现的先前 Gate 检查方法局限，历史原始证据不改写。以上是 upstream main 行为，**冻结的 Web 镜像内是否同一逻辑需要目标行为/版本 read-back 才能判定**。
- **NEXT G1J**：原配置/原三镜像不变，重新启动项目，检查*实际 Karakeep Worker* 通过 IP 解析后的 Chrome 连接是否可用。若 PASS 则让服务保持运行供 Owner 访问；若真正失败则仅项目 down，不在本轮盲改 Compose。先修验收方法，再决定是否有修复必要。

## SYSTEM_MAP
- Host / Executor：Owner 原生 Windows 11 PowerShell 7.6.5；Docker Desktop 4.95.0 Personal、Linux Engine 29.7.2、Compose v5.4.0、context `desktop-linux`（G1I read-back）。默认渠道为 Owner Windows 本机 Codex。
- 原本机配置：`$env:USERPROFILE\KarakeepLocal\docker-compose.yml` SHA-256 `cc51edb50dde3b8e921c37bd5fb569f911ead291982e67df385190b1eede2b16`；官方源 Compose blob `865bb147cef972926d5dc32e50645876fd110555`，仅发布改为 `127.0.0.1:3000:3000`。目录 `.env` 包含 `KARAKEEP_VERSION`、`NEXTAUTH_SECRET`、`MEILI_MASTER_KEY`、`NEXTAUTH_URL`，严格保护已有 Secret，绝不显示/重生/替换/提交。
- **三镜像已全部在本机且通过 G1I RepoDigest read-back**：
  - Web `ghcr.io/karakeep-app/karakeep@sha256:b069e4307dec06ea06d16989c6861c30a1ff208568be44ed5fb5d422cd3e950c`
  - Chrome `ghcr.io/karakeep-app/karakeep-chrome@sha256:c51a8c8e6c3c1040a50fa0ecfd0b2fc298401b4229262636552458151f6f18fa`
  - Meilisearch `getmeili/meilisearch@sha256:860fa4baed04ae1c235de870edab0c8006227546dea1bbb6411fbfc5e27cf1db`（tag `v1.41.0`）。
- 项目 `docker compose -p karakeep-local`；服务 `web`、`chrome`、`meilisearch`。Chrome TCP 9222 和 Meili 7700 只在项目内部可达，**无**主机映射；Web 唯一 host 端口为 `127.0.0.1:3000`。
- **当前运行真相**：G1I 结束时项目 `down`，目标容器=0、项目网络无、3000 空闲；已有两项目命名卷 `karakeep-local_data` / `karakeep-local_meilisearch` 保留，未注册账户、未导入真实收藏。非目标 20 容器（0 running）/12 卷/11 网络基线；项目完成 down 后总卷数 14。
- Docker Desktop 当前代理 G1I 实际读回保持 `Docker Desktop proxy=System proxy` / `Containers proxy=Same as host proxy`；不需要再改。此前代理兼容问题不是当前阻碍。Docker Hub pull 成功证据已冻结。
- 资源：启动时约 1315 MiB available（仅观测，无任意静态最低 RAM 门槛），Web 368MiB / Chrome 332MiB / Meili 28MiB；5 分钟运行无观察到 OOM 和 restart。G1J 要继续观察真实系统稳定性。
- 恢复：两个本项目卷和原 Secret 保留。异常只允许精确 `docker compose -p karakeep-local down` 且**绝不 -v**，不 `prune`。真实收藏与 Secret 离机备份/恢复仍 `UNVERIFIED`，首次真实资料前另立 Gate。

## CURRENT_ACCEPTED_STATE
G1I **部署验收 RETURN** 已接受，镜像拉取与项目级回滚**均为有效成果**。重要限定：G1I 的 Chrome alias `Host` HTTP 500 和 IP Host 200 是真实观测，但不能推出在用户应用里实际 Chrome 不工作；Karakeep 上游代码有内建 DNS→IP 规避。**目前实际 Worker 浏览器状态 = UNVERIFIED；绝不再把裸 `Host:chrome` HTTP 500 当作 Gate 的独立失败标准**。G1I 完成后没有 Karakeep 运行实例，不得声称目前可访问 localhost:3000。

## CURRENT_GATE
**GATE_ID**：`KARAKEEP-WIN-G1J-REAL-BROWSER-PATH-REVALIDATION-20261016`

**OBJECTIVE**：在不改任何现有配置/镜像/Secret/代理的情况下，按 Karakeep 真正的浏览器连接实现重新验收 Chrome。若现有原官方部署确实可工作，直接保持三个服务运行并停在 Reviewer，避免额外反复修复不存在的问题。

**MAX_ENDPOINT_THIS_ROUND**：
1. 接受 G1I 事实和新 Reviewer 官方源依据，不重跑代理/镜像下载。按新 Gate 先确认本轮新鲜 Owner 明确授权（由 Owner 下发的 G1J Executor 指令提供），Owner 本机 PowerShell + Docker Engine/Compose context、受保护 Compose 指纹/ACL/Secret 形状仅本机安全校验、**三**镜像 digest read-back、两个项目卷已存在且对应本项目、端口 3000 空闲、非目标容器/卷/网络 baseline 与实际资源状态。无配置 drift、其它项目异常时才继续。
2. 若可从官方 Web 镜像的已记录 image labels/revision 或本机受限只读运行代码证明启动代码的 DNS 解析→IP 机制，则记录与官方 main 的对应关系；**不要求**与当前上游 main 完全相同。不能读出精确版本时如实 `UNVERIFIED`，后续以实际 Worker 行为为主。
3. 用**原封不动**的 Compose/.env、**仅本项目**执行 `docker compose -p karakeep-local up -d --pull never`（目录/命令需确保选中冻结配置）。禁止新 pull、构建、更新 tag 或调整 `BROWSER_WEB_URL`。容器启动后，控制适当稳定观察窗，核验三个容器 image identity、web 登录页 HTTP 200 + Karakeep 标记、Meili health 200、Host 仅 127.0.0.1:3000，Chrome 9222 仅 Docker 项目内部可达，卷及非目标对象未被变更、无 OOM/持续重启。
4. **本 Gate 的关键新验收**：观察 Karakeep **实际 Worker/内建 browser connection**（以及可用的内建 admin 浏览器状态读回）是否把 `chrome` 解析为容器 IP 并成功建立 CDP/Playwright 会话。允许在确认日志类别/脱敏边界后**短窗口**只读查看 `karakeep-local` 的 Worker/Chrome 日志，提取 `Connecting`、`Successfully resolved IP`（结果仅记录成功类别，不复制 IP）、`Failed to connect`、`retry`、`disconnected`、`browser connected` 等布尔/计数；不能仅凭日志中未出现失败证明成功。若应用端内建状态或工作进程可给出明确正面连接结果，结合 IP 形式 `/json/version` 200 的内部只读正面探针（Host 要采用客户端正常形式而不是手动伪造成功）方可判 browser dependency PASS。可用时限定应用自身现有接口或同镜像内已存在的官方依赖进行只读 CDP 握手来确认，不能安装工具/加无来源新脚本、不能产生真实收藏或修改持久数据。
5. 直接使用 `Host:chrome` 的人工 HTTP `/json/version` 返回 500 是 Chromium 已知 Host 安全保护，**不得单独导致 Return 或要求修改 Compose**。如实际 Worker 解析 IP 后仍出现反复真实连接失败，则分类 DNS/IP family/CDP websocket/应用版本/Host 等最窄子域并 `RETURN`；在该 Gate **不擅自修改** Chrome 启动参数、固定 IP、改网络/改环境变量、使用无保护 HTTP 代理或发布 9222。
6. 若所有真实连接/安全/服务/资源检查均通过，保持 **Karakeep 三容器运行**并报 `PASS_CANDIDATE`、当前 localhost URL + 验收证据，停 Reviewer；**不要因为历史 alias 裸 HTTP 500 再 down**。若真实 browser dependency 确实不通过、Docker/非目标对象有新异常、或无法得到必要的正面证据，则执行仅目标 `docker compose -p karakeep-local down`（不带 `-v`）并记录明确 `RETURN`；保留镜像、卷、Compose/.env。若无法证明目标身份或安全，先停进一步写入并报告。
7. 本轮不改 Docker Desktop/Windows/Clash/VPN/证书/daemon/WSL、不拉镜像、不建代理、不改其它 Docker 项目、不启动其它容器、不注册账号/导入收藏/AI key、不重置或输出 Secret、无 `prune` / `down -v`。

**MANDATORY_REVIEW_STOP**：G1J 一次执行完成（部署候选或 RETURN）后 append 脱敏 `karakeep-local/EXECUTION_EVIDENCE.md`，提交 GitHub main + read-back，立即停止 Reviewer；不自动进入用户首次注册/收藏阶段。

**TARGET_AND_SCOPE**：Owner Windows 本机已受保护 `USERPROFILE\KarakeepLocal`，原冻结 Compose/.env、三已拉镜像及两现有项目卷；唯一新写入为 `karakeep-local` 的三个运行容器/项目网络与其空应用内部状态。共享 Docker Desktop /代理、其它项目、外网端口不变。

**APPLICABLE_CRITICAL_CONSTRAINTS**：需要本轮明确授权重新启动；无配置/源码/Secret 改动；对真实 browser/CDP 层证明，不强迫裸 hostname Host 检查；项目仅 loopback、其它依赖仅内部；无固定空闲 RAM 数值门槛、关注真实 OOM/重启/稳定性；仅项目恢复，保护已有卷；证据脱敏。

**PREFLIGHT**：收到 Owner 转交的本 Gate 明确授权、Windows 本机身份/Engine/context、3 镜像 digest、两旧卷属于目标项目、原受保护配置 SHA/ACL、无端口或 project-object 冲突、磁盘/实际系统状态允许；失败返回不重构或清理。

**REQUIRED_EVIDENCE**：`EXECUTION_EVIDENCE.md` append G1J：规范字段 `AUTHORIZED_GATE / PREFLIGHT_FACTS / ACTUAL_CHANGES / OBJECTIVE_READBACK / VALIDATION / ANOMALIES / EVIDENCE_ARTIFACTS_AND_PURPOSE / ROLLBACK_EFFECT / RESOURCE_OR_BUSINESS_DELTA_WHEN_RELEVANT / EXECUTOR_RESULT`。包括接受 G1I 镜像身份、应用与官方 main 浏览器解析证据的来源及版本范围、有效容器工作进程浏览器连接正/反证据、真实 Web/Meili/Chrome 健康与访问安全/负面端口测试、项目/非目标 before-after、资源稳定性、若失败时 project-only rollback/卷保留、当前是否可访问 URL；只允许经脱敏白名单统计，绝无原始日志/IP/密钥/代理值/GitHub 大包。main commit/blob read-back。

**ACCEPTANCE_CRITERIA**：G1J 证明原本 G1I 的裸 HTTP 500 不是应用实际连接失败的充分证据；若目标运行时的 Worker/browser 实际 CDP 可用，三服务/登录页/loopback/资源/对象隔离 PASS、镜像 hash identity/原配置持续有效，则 `PASS_CANDIDATE` 且留项目运行，等待 Reviewer 独立判 PASS。若真实 Worker/CDP 证据失败或不足，按目标级 down 返回可行动精确 RETURN。无法观察某一项不编造成功。

**ROLLBACK_STATUS_OR_PLAN**：项目源 Compose 和旧两卷/三镜像可保留恢复；异常且目标 identity 确认后只执行 `docker compose -p karakeep-local down`（无 -v），不会删除卷/重置 Secret。正常验收不 down，保持本机监听 127.0.0.1:3000。没有真实用户资料，跨设备恢复仍 UNVERIFIED。

**OWNER_ONLY_ACTIONS**：G1I 失败后此次是新的项目启动写入，必须有**新一轮** Owner 对 G1J 的有边界授权，Owner 转发含“我授权本次 G1J 仅复用原配置/原镜像重启 Karakeep、验证真实浏览器连接；失败仅项目 down，成功保持运行”的 Codex 指令即作为授权。不需改代理、不需提供 Secret，跨 Gate 新敏感动作仍需单独审核。

**REVIEWER_TO_EXECUTOR_RELAY**：
> 你是 Owner 实体 Windows 本机 Codex Executor。Owner 本次转交 G1J 指令就是本轮鲜明授权。阅读最新 main `karakeep-local/REVIEWER_HANDOFF.md` CURRENT_GATE、CURRENT_ACCEPTED_STATE、SYSTEM_MAP、CRITICAL_CONSTRAINTS，以及 `EXECUTION_EVIDENCE.md` **仅 G1I 最新段落**。G1I 的 Meili 下载/三镜像/read-back/回滚已验证，不可重做 pull/代理排查。Reviewer 核查 Karakeep 官方 `apps/workers/workers/utils/browser.ts` main（blob `96192428e232c375680d989a49abb58bb897a6fb`）：真实 Worker 会先将 `BROWSER_WEB_URL=http://chrome:9222` 的 hostname DNS 解析成 IP，再 `connectOverCDP`；官方 `admin.ts` 类似。**G1I 的直接 `Host:chrome` HTTP 500 并不证明真实 Worker 失败**。在原配置/原 3 镜像/2 卷完好、仅 127.0.0.1:3000 无冲突与其它项正常后，执行 `docker compose -p karakeep-local up -d --pull never`，优先验证 Web、Meili、**真实 Karakeep Worker/CDP** 的连接读回，短窗口脱敏核验日志、浏览器正面结果、非目标/资源/loopback。不可强制 Chrome 裸 alias HTTP 200；没有证据不得自行修改 Chrome 参数/Compose/IP/Host/代理。确实真实 Worker 失败或正面证据不足则本项目 `down` 不删卷并 RETURN；真实依赖 PASS 则**保持服务运行**、报 `PASS_CANDIDATE` 与 `http://127.0.0.1:3000`，追加 Evidence main 读回，停 Reviewer，不进入注册/收藏。

**EXECUTOR_TO_REVIEWER_RELAY**：结果；改动；验证；问题；回滚；请 Reviewer 检查；Owner 转交。

## CRITICAL_CONSTRAINTS
三镜像已下载、两命名卷保留；原安全 Compose/.env/Secret 不改、无新拉取/代理变化；仅本项目容器写入、仅 Web loopback；Chrome 裸别名 Host 500 不等于 Worker 失败；实际 CDP 读回为准；无固定静态空闲 RAM 门槛；出现真实 OOM/非目标状态影响按项目级回滚；Evidence 脱敏、Reviewer stop。

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 原生 PowerShell Codex；新 G1J 由 Owner 发送执行指令建立本轮授权。

## CURRENT_ROLLBACK_STATUS
G1I 已验证仅 `karakeep-local down` 不带 `-v` 成功：3 个 target 容器、target 网络和监听已移除，2 项目卷/3 官方镜像保留；其他容器/网络无变化，20/0/11 与以前一致；卷总数 14。后续继续以项目 down 非破坏恢复为真实已测试方法，业务数据异机备份/Secret 恢复仍 UNVERIFIED。

## UNRESOLVED
Karakeep 已下载 Web release 镜像的真实 Worker/CDP 浏览器连接状态在 G1I 未被验证。官方 main 代码已具备 hostname→IP 处理，但当前 release 镜像是否具备以及真实 CDP 能否工作尚 UNKNOWN。当前没有运行服务。

## NEXT_STEP
Owner 将 G1J 一次授权指令下发本机 Codex，复用原配置无更改再启动，优先按实际工作进程浏览器连接验收；真正通过则让项目保持运行。Reviewer 审核最新 G1J Evidence 判定首装 PASS 或最小返工。旧 Docker Hub/代理问题已解决。

## OWNER_ACTION_REQUIRED
Owner 把包含本次 G1J 明确启动授权的 Relay 交本机 Codex。无需 Owner 手动操作 Docker、下载镜像、改 Clash/VPN 或提供任何密钥。

## EVIDENCE_POINTERS
G1I `karakeep-local/EXECUTION_EVIDENCE.md` commit `e760ea202fe2e46560dd0692218a8fe8178a8bac` blob `c300dc5d422cbbcbacc554a1bf8acdaf92e2a531`; 历史 G0–G1H 保持原 append-only。官方依据 Web upstream `karakeep-app/karakeep` `apps/workers/workers/utils/browser.ts` blob `96192428e232c375680d989a49abb58bb897a6fb`、admin 检查 blob `393114942bd4cc1c6778d12489068db6215d767f`、官方 Compose blob `865bb147cef972926d5dc32e50645876fd110555`。不是目标镜像内部源码已验证证据。
