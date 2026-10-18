# SaaS System Lab — EXECUTION_EVIDENCE

> APPEND-ONLY。任何未来 Gate 的预检、实际修改、脱敏输出和 Reviewer 判定均在后续章节追加；不要用无证据的 `PASS` 代替实际读取。

## 2026-10-17 — G0_PROJECT_INITIALIZATION

- `AUTHORIZED_GATE`: Owner 在本对话明确要求“单独建一个 SaaS 系统的项目，在项目库里按顺序实验三个项目；先通读项目管理规范”。本轮 Reviewer 将最大端点界定为**项目初始化和只读 G1 Gate 的文档落库**，不是候选安装。
- `PREFLIGHT_FACTS`: GitHub `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 完整读取 609 行；`entropy-student/project@main` 根目录无 `saas-system/`；既有 Paymenter 子项目当前根目录未见；项目库根 README 指定项目目录独立与 Handoff 为状态权威。
- `ACTUAL_CHANGES`: 新增 `saas-system/README.md`、`REVIEWER_HANDOFF.md`、`EXECUTION_EVIDENCE.md`、`docs/SERIAL_EXPERIMENT_PLAN.md`、`docs/G1_VELOBASE_READONLY_GATE.md`；根 `README.md` 增加一个导航项目条目。其他仓库和项目不变。
- `OBJECTIVE_READBACK`: GitHub main 当前版本和新文档需要在完成提交后逐项独立核验；提交身份参见 GitHub 历史。**不要把当前记录当成尚未发生的运行实测。**
- `VALIDATION`: 计划/范围级自检：串行次序 Velobase → Open SaaS → Wave；Docker 非硬要求；G1 只读；未经启动/支付/账号授权。新项目 Handoff 唯一真相。
- `ANOMALIES`: 无已知既有项目修改；候选执行环境实际状态 UNKNOWN。
- `EVIDENCE_ARTIFACTS_AND_PURPOSE`: 本文件留存初始化事实；Handoff 与 G1 Gate 提供后续交接和验收标准；GitHub 提交+路径回读作为持久化证明。
- `ROLLBACK_EFFECT`: 文档级 Git 回滚可恢复；没有 DB、Docker、VPS 或 Provider 侧回滚动作。
- `RESOURCE_OR_BUSINESS_DELTA`: 新增文档 5 个与根导航 1 行；真实服务/容器/数据库/支付/费用均 0。
- `EXECUTOR_RESULT`: `PASS_CANDIDATE_DOCUMENTATION_ONLY`，实际 GitHub read-back 前不主张正式 PASS。

## 2026-10-17 — G0_REVIEWER_READBACK_AND_PASS

- `REVIEWER_DECISION`: `PASS_G0_DOCUMENTATION_INITIALIZATION_ONLY`。**不包含** Velobase/Open SaaS/Wave 的任何安装、运行或支付验收。
- `DIRECT_READBACK`: 初始化 Commit [`90b40c397f84dbbecbb35f3eb9abc1ce789a29c1`](https://github.com/entropy-student/project/commit/90b40c397f84dbbecbb35f3eb9abc1ce789a29c1) 的 changed paths 仅 `saas-system/` 下 5 个 Markdown 和根 `README.md`；6 个路径已通过 GitHub main 重新读取，内容和导航链接存在。
- `CONCURRENT_UPDATE_RECONCILED`: readback 时 main 为 `744f11f290ce50ea5cec291126af826a77f6d2e1`，GitHub compare 表明这是本项目初始化 commit 的后继，新增内容仅是 `birthday-magazine-studio/` 独立文档；不归属、不修改或回滚那个项目。
- `VALIDATION`: 6/6 路径成功回读；项目原不存在，新建后未触碰其他项目内容；G1 仍为只读预检，串行实验尚未进入运行。
- `ROLLBACK`: 文档级 Git 回退可恢复；不涉及任何运行资源、Secret、支付或业务数据。

## 2026-10-17 — G1_VELOBASE_LOCAL_PREFLIGHT_REVIEWED_RETURN_RESOURCE

- `AUTHORIZED_GATE`: `SAAS-G1-VH-READONLY-PREFLIGHT-20261017`，只读。
- `PREFLIGHT_FACTS`: Owner 在会话转交本机 Codex 报告，Windows 11 Home build 26300、PS 7.6.5、非管理员；可用内存 1.12/1.55 GiB，磁盘余量 169.70 GiB；Docker 9 个项目/35 容器，运行中 3 个；端口 3003/54333/56380 未见冲突。**来源为 OWNER_RELAYED_EXECUTOR_REPORT，非本 Reviewer 对真实主机的直接读回**。
- `SOURCE_DIRECT_READBACK`: Reviewer 经 GitHub 读取固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d`，核对 MIT、Compose、Dockerfile、Demo 脚本、退款处理、Affiliate 事件模块。
- `ACTUAL_CHANGES`: 本机 Codex 报告 `OWNER_SIDE_EFFECT_COUNT=0`；无下载、安装、构建、启动、服务停止、支付或运行时修改。GitHub 本轮仅追加文档结论与更新 Handoff。
- `VALIDATION`: 静态源码结果确认，但 `RUNTIME_PASS=NOT_TESTED`；Web `mem_limit: 8g` 为上限非最低；Node/pnpm 版本需隔离匹配。
- `ANOMALIES`: 少量 RAM 导致本轮预检无法安全进入演示。源码部分退款整笔置 `REFUNDED`、事件错误仅记录日志存在后续风险；未实测。
- `REVIEWER_DECISION`: **`RETURN_RESOURCE_HEADROOM_INSUFFICIENT`**，接受已取得的 G1 事实，不批准新的运行 Gate；详见 [Reviewer 决定](./docs/G1_REVIEWER_DECISION_20261017.md)。
- `ROLLBACK_EFFECT`: 无本机/Provider 更改，运行时回滚 `NOT_APPLICABLE`；文档变更通过 Git 记录。
- `RESOURCE_OR_BUSINESS_DELTA`: 仅项目文档修改，无成本、端口、账户、数据库或业务动作。
- `NEXT`: 等待资源改善后增量复测，或经 Owner 另行指定云端候选并进行只读费用/环境预检；不自动切换项目或修改已有系统。


## 2026-10-18 — OWNER_OVERRIDE_AND_G2_PRIVATE_DEMO_GATE_ISSUED

- `OWNER_DECISION`: Owner 明确指示「内存不设为限制条件，继续推进」；这是**取消固定空闲 RAM 作为 Gate 阻塞条件**的授权，不允许忽略实际 OOM/OS 异常/其他项目回归。
- `PREVIOUS_STATE`: G1 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT` 仍是 2026-10-17 只读报告的历史事实，不删除、不伪改成 PASS。
- `REVIEWER_ACTION`: 签发 [G2 Velobase 私有演示 Gate](./docs/G2_VELOBASE_PRIVATE_PREVIEW_GATE_20261018.md)，锁定源码 commit `e88e259b974f883913f68ac74a9b8377765d005d` 和本机新 Docker Compose 项目 `saasvh-e88e259`，只做本地 UI/健康验证；动态资源实际异常触发停止，支付动作 0。
- `ACTUAL_RUNTIME_EXECUTION`: `NOT_STARTED`。本轮 ChatGPT 只操作 GitHub 项目文档，未访问 Owner 物理 Windows，不宣称本地安装/网页可达。
- `GOVERNANCE`: GitHub 当前 `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 已读取，Owner 不要求也未授权修改治理规范。
- `NEXT`: 本地 Codex 直接执行已审 G2 Gate；结果返回后 Reviewer 依据真实证据判断是否完成首次预览，再进入 Stripe/裂变独立测试。


## 2026-10-18 — G2_REVIEWER_EXISTING_WORKLOAD_REGRESSION
- `AUTHORIZED_GATE`: `SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018`
- `EXECUTOR_EVIDENCE`: [G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md) 已被 Reviewer 直接读取；本文是 `OWNER_RELAYED_EXECUTOR_REPORT`，不是对本机 Windows 的独立直接回读。相关截图尚未在可独立审查的文件中提供。
- `ACTUAL_CHANGES`: 以固定 SHA 构建/创建 G2 Web/Postgres/Redis、2 命名卷和网络，首页曾 200；三个原容器退出后执行器停止 G2。报告 G2 端口已关闭、源/镜像/卷/网络保留、未触碰旧项目配置。Reviewer 本轮只修改 GitHub 文档。
- `VALIDATION`: BUILD_CANDIDATE=PASS；UI_LANDING=PARTIAL；SIGNIN=PARTIAL；DASHBOARD/ADMIN/AFFILIATE/WORKER=UNVERIFIED；STRIPE/COMMISSION/REFUND=NOT_TESTED。
- `ANOMALY`: 三旧容器约 6 秒内退出（137/0/0），OOMKilled=false 且查询时间窗无 OOM event；根因 `UNKNOWN`，不能武断判定为内存/OOM 或直接归咎 Velobase。
- `REVIEWER_DECISION`: **`RETURN_EXISTING_WORKLOAD_REGRESSION`**；[详细审核](./docs/G2_REVIEWER_DECISION_20261018.md)。
- `ROLLBACK`: G2 容器停机并留资产；原容器仍退出的事实只限 G2 末次报告，不知现在是否恢复。
- `NEXT`: [G2R1 只读诊断 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)。禁止重启/恢复现有业务或重试 G2。

## 2026-10-18 — G2R1_REVIEWER_CAUSE_UNKNOWN_AND_OWNER_CLASSIFICATION_PENDING

- `AUTHORIZED_GATE`: `SAAS-G2R1-EXISTING-WORKLOAD-READONLY-20261018`，仅 Owner 本机只读检查。
- `EXECUTOR_EVIDENCE`: Owner 通过当前对话转交本机 Codex 全文结果，`READONLY_SIDE_EFFECT_COUNT=0`，没有启动/修改/清理；本 Reviewer 无法直接读取个人电脑 Docker control-plane 原始数据。保留脱敏结论于 [G2R1 Reviewer 决定](./docs/G2R1_REVIEWER_DECISION_20261018.md)。
- `OBJECTIVE_READBACK`: 三原容器仍 `exited`，退出码 `137,0,0`，UTC FinishedAt `16:32:30.385 / 16:32:33.652 / 16:32:36.264`（2026-10-17），均 `OOMKilled=false`，restart policy no / count 0；同一匿名化 Compose 项目，但业务类别 `UNKNOWN`。
- `DIAGNOSTIC_SCOPE`: Docker 事件历史当前查询 0 但覆盖率 UNKNOWN；Windows 窄窗无有关直接记录，相关 WSL/Hyper-V 部分通道不可用，G2 无当时 Engine ID，无法支持 Engine 重启/OOM/Velobase 直接致因推论。根因 `CAUSE_UNKNOWN`。
- `G2_RESIDUAL`: G2 Velobase Web/Postgres/Redis stopped、3003 无监听；两个卷/镜像/网络保留，无支付。
- `REVIEWER_DECISION`: **`PARTIAL_G2R1_OWNER_CLASSIFICATION_UNKNOWN`**。退出原因有界诊断完成；原 Gate 的旧业务归属/恢复必要性仍未知，不能宣称完整 PASS。**无需重新排查根因**。
- `ROLLBACK_EFFECT`: 本轮只读，原服务未恢复、原项目数据未删除；Reviewer 仅更新 GitHub 项目文档，可通过 Git 回退。
- `NEXT`: `CURRENT_GATE=NONE`，等待 Owner 确认是否要恢复这三个原容器；若要则另定旧项目特定恢复 Gate。Velobase 后续先比较独立隔离环境与费用，暂不重启同一 Docker Engine 演示或自动切换第二款。


## 2026-10-18 — CROSS_SESSION_HANDOFF_RECONCILIATION

- `PURPOSE`: Owner 要求对话交接前将当前项目进展写入 `entropy-student/project@main` 并交付下一位 Reviewer 可用完整传递材料。
- `EXISTING_CANONICAL_STATE`: 已在 main 核实此前 Commit `0ae53f9f4b2dfe46742763fb3af7831b2e1bce4d` 包含 G2R1 Reviewer 结论 `PARTIAL_G2R1_OWNER_CLASSIFICATION_UNKNOWN`、`CAUSE_UNKNOWN` 和三原容器仍退出的报告；不重复制造第二套裁定。
- `GOVERNANCE`: `entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 已读取；本轮不更改 Governance 或其他项目。
- `DOCUMENTATION_CHANGES`: 更新本项目 Handoff 中数处 G2 后过时描述（执行目标身份、现有资产/旧负载状态、源码运行证据）；新增 [下一位 Reviewer 完整交接](./docs/NEXT_REVIEWER_RELAY_20261018.md)。G2R1 原 Reviewer 决定、原 Executor Evidence、G2/G1 历史材料原封保留。
- `EVIDENCE_PROVENANCE`: 本轮直接核验 GitHub 中已归档文档；物理 Windows 容器现状来自 Owner 转交的本机 Codex 报告，后续事实漂移需在同机 read-back，不能把历史退出状态当永久状态。
- `ACTUAL_HOST_OR_BUSINESS_MUTATIONS`: 0；没有任何容器启动/停止、重试、删卷、支付/退款、账号或外部服务动作。GitHub 仅改本项目文档。
- `CURRENT_GATE`: NONE；下一步为 Owner 决定三个旧容器是否需要恢复，SaaS 下一测试环境须独立选择/授权。


## 2026-10-18 — OWNER_DEFERS_OLD_CONTAINERS_AND_G2I1_CODESPACES_GATE_ISSUED

- `OWNER_LATEST_DIRECTION`: “我手动暂定的貌似是，请你继续下一步，不要因此暂停。”Reviewer 仅按「Owner 认为可能是手动暂停且要求无需恢复即可推进」处理，`OWNER_DEFERRED_RECOVERY`；不认为已证明 Docker 三容器当初的具体退出原因，`CAUSE_UNKNOWN` 不改写，旧三个容器无启动/恢复/删除。
- `ACCEPTED_BOUNDARY`: Velobase 优先继续，不以 G2R1 旧业务归属未识别阻塞 **独立环境的 SaaS 实验**；若未来另有旧业务恢复请求仍需原项目独立 Gate。
- `RESEARCH_SOURCE_DIRECT_READBACK`: GitHub 读取固定 `velobase/velobase-harness@e88e259b974f883913f68ac74a9b8377765d005d` 的 `compose.demo.yml`/`Dockerfile.demo`/`services/demo/start.mjs`；Demo 是 Web/Postgres/Redis，Web `SERVICE_MODE=web,worker`，`AUTH_URL=http://localhost:3003` 和 `APP_URL=http://localhost:3003`，源启动器有 localhost 硬校验。这一条件是 Codespaces 远程转发浏览器身份来源的新增兼容性风险，需实测而不能默认放开保护。
- `EXTERNAL_DOCUMENTATION_READBACK`: 2026-10-18 GitHub Docs 的 Codespaces 个人账户月配额 Free 120 core-hour/15 GB-month、Pro 180 core-hour/20 GB-month，计算/存储分别计费；私有转发端口需要 GitHub 身份认证，默认不匿名公开；支持 Docker-in-Docker 但不等于本 Demo 已兼容。用户账户类型、余额、权限、价格暴露和实例规格均 `UNKNOWN`。
- `DECISION`: **G2I1 Codespaces zero-billing private preview Gate** [已签发](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)。先证实个人账户有零新增收费的免费额度并有足够存储，再限单个隔离 Codespace 和固定源码一次演示；有实际收费可能性立即停在创建动作之前。4vCPU/8GiB 只是资源试验起点，不是最低 RAM 事实。
- `ACTUAL_CHANGES`: 仅通过 GitHub 为 `saas-system/` 新增 G2I1 Gate，更新唯一 Handoff 与本 append-only Evidence；没有创建 Codespace、构建镜像、启动容器、停止其他项目、改动 Windows、绑定账号、支付/退款或改变 Governance。
- `VALIDATION`: Gate 文档以及旧容器 Owner 决策将由 GitHub main 独立回读；未获得任何云主机/浏览器运行或费用 0 的真实账号侧证据，`RUNTIME_PASS=NOT_TESTED`。
- `ROLLBACK`: GitHub 文档可按提交恢复；运行环境没有更改。新云端资源保留/清理操作必须在后续实测和单独授权边界执行。
- `REVIEWER_RESULT`: `PASS_G2I1_GATE_PREPARATION_ONLY`，`CURRENT_GATE=G2I1_REVIEWER_READY_NOT_EXECUTED`；后续执行结果仍须 Reviewer 独立审核。
- `REFERENCE_URLS`: [官方 Codespaces 计费](https://docs.github.com/en/billing/concepts/product-billing/github-codespaces)，[官方私有端口转发](https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)，[上游启动器](https://github.com/velobase/velobase-harness/blob/e88e259b974f883913f68ac74a9b8377765d005d/services/demo/start.mjs)。

## 2026-10-18 — OWNER_REJECTS_CODESPACES_AND_G2L1_LOCAL_ASSETS_GATE_ISSUED

- `OWNER_DECISION`: Owner 明确说“我拒绝这个方案，现在不是已经部署在我自己的电脑上了吗？”；正式拒绝 Codespaces 方案，要求复用本机已有 Velobase。上轮“旧容器可能是自己手动暂停”的表述仍非已证实因果；`CAUSE_UNKNOWN` 保留。
- `G2I1_CANCELLED`: [Codespaces Gate](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md) 顶部状态改为 `CLOSED_OWNER_REJECTED / NOT_EXECUTED`；无 Codespace 创建、计费、Docker 或数据/公网变更。保留 Gate 正文仅供历史审计，禁止按其执行。
- `PRIOR_LOCAL_EVIDENCE`: 依 [G2 原始执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md) 的 Owner 本机回报，Velobase SHA `e88e259b974f883913f68ac74a9b8377765d005d` 已在 `%USERPROFILE%/Documents/ChatGPT/Velobase-Harness-e88e259` 构建，独立 `saasvh-e88e259` 的 Web/Postgres/Redis 曾运行、首页 200；随后按原 Gate 仅停止实验容器，源码、镜像、两卷、网络保留。该事实截至 G2R1 的本机报告，**非这次接手的实时本机直接读回**。
- `DECISION`: 本机优先，签发 [G2L1 现有 Demo 复用与 UI 验收 Gate](./docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md)。先新鲜核实真实 Windows 主机/旧 project/三容器/两卷/镜像/端口与当前其他运行中负载，然后只用 `docker compose ... start` 顺序恢复**已有** Postgres/Redis/Web，不重新 clone、不重新 build、不 up/create/recreate、不重置 DB；登录、Dashboard、Admin 正反例、Affiliate 与 Web/DB/Redis/Worker 健康为验收目标。
- `SHARED_WORKLOAD_BOUNDARY`: 其他三个历史旧容器仍不在当前恢复范围；重新启动 Velobase 不能被解释为已经诊断旧容器事故。出现本轮实际新工作负载回退，精确停止本轮 Velobase 服务，记录而不触碰旧业务。Owner 已取消硬性空闲 RAM 最低门槛，不取消真实资源故障 STOP。
- `ACTUAL_CHANGES`: 仅编辑 GitHub `saas-system/` 下历史 Gate 状态、唯一 Handoff、创建 G2L1 Gate、追加本记录；**未操作 Owner Windows、Docker、任何 VPS/云服务、Provider、账号、用户数据或真实支付**。
- `REVIEWER_RESULT`: `PASS_G2L1_GATE_PREPARATION_ONLY`，`CURRENT_GATE=G2L1_REVIEWER_READY_NOT_EXECUTED`。需要 Owner Windows 本机 Codex 执行后转交新的 Evidence 才能得出运行 PASS。
- `ROLLBACK`: 此轮仅 GitHub 文档级写入，Git 提交可审可恢复；无真实业务运行变动。新 Gate 的运行回滚限定于 Velobase 自身既有容器，不能删除数据卷。

## 2026-10-18 — G2L1_OPTIONAL_DOCKER_DESKTOP_NORMAL_START_AUTHORIZED

- `OWNER_INPUT`: Owner reports Docker Desktop may have been manually closed and wants local Codex to start it if necessary.
- `GATE_SCOPE_CHANGE`: G2L1 now permits one ordinary launch of the already-installed Docker Desktop application when verified closed. After engine readiness, inspect unrelated workloads for automatic restart effects before starting Velobase.
- `EXCLUSIONS`: No daemon/WSL reset, repair, upgrade, configuration changes, cleanup, other-project container operations, Codespaces, or payment activity. If startup unexpectedly changes unrelated workloads, stop the SaaS sequence without stopping the shared engine.
- `EXECUTION_STATUS`: DOCUMENTATION_ONLY / NOT_EXECUTED. Docker Desktop state and application health have not been checked from this GitHub Reviewer.
- `REVIEWER_DECISION`: G2L1 remains the active Gate, owner-local Codex is the execution channel; historic G2/G2R1 cause remains UNKNOWN.
- `EVIDENCE`: [G2L1 current Gate](./docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md) and [canonical Handoff](./REVIEWER_HANDOFF.md).

## 2026-10-18 — G2L1_REVIEWER_RETURN_AND_G2L2_VIEWPORT_RECHECK_READY

- `AUTHORIZED_GATE`: `SAAS-G2L1-LOCAL-EXISTING-DEMO-RESUME-20261018`; [Executor Evidence](./docs/G2L1_EXECUTION_EVIDENCE_20261018.md) committed as `34ea48b7cdf2a35335f7af322666fa9d9503c5f2` and reviewed from GitHub `main`.
- `PROVENANCE`: G2L1 runtime, Docker and browser result is `OWNER_RELAYED_EXECUTOR_REPORT`; fixed upstream source and project Evidence are directly read by Reviewer. Executor-session screenshots have not been independently reviewed by current Reviewer.
- `ACCEPTED_EXECUTION_FACTS`: Docker Desktop/Engine was already running; no Desktop restart. Existing Velobase project `saasvh-e88e259` used `compose start postgres redis` followed by `compose start web` (both exit 0), reused original Web/Postgres/Redis, image/volumes/network; Postgres/Redis healthy, landing GET 200; worker startup marker found; no external actions, Docker-wide changes, builds or other container state delta. As-of G2L1 evidence Web ~4.42GiB, host available ~0.99GiB; no reported actual OOM.
- `BLOCKER`: Login UI offers Google/GitHub/Email but lacks local administrator demo button; /dashboard and /admin authenticated access unverified. Anonymous /admin and /affiliate redirect; anonymous /account/affiliate shows empty page and Next.js issue marker. Ordinary-user admin authorization and worker actual jobs untested.
- `SOURCE_DIRECT_READBACK`: At pinned upstream SHA `e88e259b974f883913f68ac74a9b8377765d005d`, `src/components/auth/login-modal.tsx` chooses Mobile when window width <768px, Desktop otherwise. Desktop `login-content.tsx` contains localDemoEnabled login button, Mobile `login-modal-mobile.tsx` has no equivalent button. Server `local-demo` provider is gated by environment and loopback conditions in `src/server/auth/local-demo.ts` and `config.ts`. The G2L1 browser's actual CSS viewport is missing, so **mobile rendering is plausible, not proven as this occurrence's cause**. Client-build/env mismatch also remains not proved.
- `AFFILIATE_SOURCE_RECHECK`: `src/app/account/affiliate/page.tsx` depends on `useSession` and API affiliate status and redirects unauthenticated sessions. It also has a `router.push('/404')` during render for ineligible status, a candidate React navigation issue, not proven cause of the observed Next.js issue.
- `REVIEWER_DECISION`: [Formal independent G2L1 verdict](./docs/G2L1_REVIEWER_DECISION_20261018.md) `RETURN_LOCAL_DEMO_LOGIN_UI_MISSING`; runtime recovery a verified-in-Executor-report partial success, not full application PASS. G2L1 historical Gate marked CLOSED. No rollback; Velobase left running.
- `NEXT_AUTHORIZED_GATE`: [G2L2 desktop viewport-first read-only/UI exercise](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md) with `STATUS=REVIEWER_READY_NOT_EXECUTED`. Prioritize genuine >=1024px desktop UI; if local demo login is available, verify actual Dashboard/Admin/Affiliate; otherwise only collect provider IDs and minimal environment-switch metadata. No source patch/build/recreate/payment permitted.
- `ACTUAL_REVIEWER_SIDE_EFFECT`: GitHub project documentation updates only. Reviewer did not change Windows, Docker, Codespaces, Stripe, or other projects. Historical G2/G2R1 `CAUSE_UNKNOWN` unchanged.
