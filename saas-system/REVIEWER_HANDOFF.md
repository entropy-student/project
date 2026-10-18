# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-18
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE

`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_HISTORICAL_RETURN_EXISTING_WORKLOAD / G2R1_CAUSE_UNKNOWN_CLOSED / G2I1_OWNER_REJECTED_NEVER_EXECUTED / G2L1_REVIEWED_RETURN_LOGIN_UI_MISSING / G2L2_REVIEWED_RETURN_AFFILIATE_BLANK_AND_HTTP_000 / G2L3_READY_NOT_EXECUTED`。

Velobase 固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d` 已在 Owner Windows 本机既有 Docker 中实际恢复并经 G2L2 使用原生 UI 登录本地管理员，打开 Dashboard 和 Admin Users；Affiliate 空白且 Web 随后出现 HTTP 000，持续可访问性尚未证实。历史三个未知旧容器暂不恢复。后续 Open SaaS → Wave 仍待本候选阶段收束。

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：本轮 G2/G2R1 已由 Owner 的真实 Windows 11 家庭版主机 + 本机 Codex 执行，2026-10-18 本机报告已验证运行环境；Reviewer 未直接登录真实主机，所有宿主机状态按 `OWNER_RELAYED_EXECUTOR_REPORT` 记录。今后其他环境需独立证明身份。
- **存储与服务**：G2 曾创建项目隔离源目录、镜像、Web/Postgres/Redis 容器、两个命名卷与网络；最新 G2L1 本机报告表明该项目 web/postgres/redis 已复用原容器恢复至 running，3003 首页 HTTP 200，Postgres/Redis healthy，源码/镜像/卷/网络保留；其他非目标容器起止基线一致。仅属于 Owner 转交的本机执行记录，非 Reviewer 实时宿主直读；历史旧容器精确身份连续性及退出原因 UNKNOWN。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE

**2026-10-18 G2L2 Reviewer 正式裁定：** [独立审核](./docs/G2L2_REVIEWER_DECISION_20261018.md) `RETURN_AFFILIATE_BLANK_AND_WEB_HTTP_EMPTY_REPLY`。Owner 转交本机 Codex 的 [G2L2 Evidence](./docs/G2L2_EXECUTION_EVIDENCE_20261018.md) 表明 desktop viewport 1280×900 时真实本地管理员按钮可见、正常 UI 登录成功，Dashboard 和 Admin 用户管理页读屏通过（33 条演示数据）；因此 G2L1 的 **登录入口问题已解决并且不再是阻塞**。

**仍有关键故障：** `/account/affiliate` 登录后空白并跳走，安全化日志仅报告 Next.js console-error，错误类型/栈 UNKNOWN；`/affiliate` 导向首页。随后三个以上 Windows 回环 curl 请求报 HTTP 000/空响应，**Web 当时可用性失败但不能证明进程 crash**。Web/Postgres/Redis 容器仍 running，DB/Redis healthy，Web CPU 曾达到约 289.77% 后回落、内存约 5.208 GiB，未报告 OOM 或其它项目状态回退；Worker 任务与普通用户 Admin 反例仍 UNVERIFIED。Stripe/佣金/真实支付从未执行。

**镜像真实性独立交叉核对：** G2L2 运行 Web 实际 Image ID 为 `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`，G2L1 此镜像的 SHA256 再摘要截断 `1552F1BBB39573BA` 已独立计算一致，因此实际运行镜像跨轮稳定；Compose `com.docker.compose.image` 标签 88bb... 的差异仅说明元数据不匹配，确切成因未知，不授权据此重建。

**固定源码风险：** Affiliate 页面 `src/app/account/affiliate/page.tsx` 在 render 内调用 `router.push('/404')` 且 `return null`，属于潜在客户端副作用问题，但尚无堆栈证实即此次空白原因。Web `services/demo/start.mjs` 每次启动会触发 `prisma db push --skip-generate` 和基于标记的可选初始化，因此并非可盲目反复重启。

**Owner 明确决策与边界：** Codespaces 被拒绝、从未运行；继续使用本机现有实例，不重装，不调查旧三容器退出旧案。G0/G1/G2/G2R1/G2I1/G2L1/G2L2 的历史证据保留原判定，已完成的 UI 验收成果不重来。Windows/Docker/浏览器状态为 `OWNER_RELAYED_EXECUTOR_REPORT` 而非 Reviewer 真机直接读回。

## CURRENT_GATE

`G2L3 — SAAS-G2L3-LOCAL-WEB-AFFILIATE-TARGETED-RECOVERY-20261018 / REVIEWER_READY / NOT_EXECUTED`。

[唯一当前 G2L3 Gate](./docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)：先用 Windows `curl.exe --noproxy "*"` 与容器内独立 Node HTTP 对照，确定 HTTP 000 的错误类别和故障域；读取窄范围脱敏 Next.js/Worker 信息。**仅当 Web 进程双通路持续不响应且原 Demo auth-secret/seed markers、镜像、容器与数据卷完全核实安全时**，允许至多一次同一个现存 Web 容器的受控 restart；该启动脚本可能进行原隔离 Demo 数据库 schema sync，不得误称为纯只读。然后再复测 Web 稳定访问、Dashboard/Admin 和 Affiliate 错误类。绝不重新构建、改源码/共享 Docker、启动旧容器或支付。历史 G2L2 Gate 已关闭。

## CRITICAL_CONSTRAINTS
- 项目顺序固定 Velobase → Open SaaS → Wave；不并行安装，不因候选失败立刻切换并部署。
- 采用**可快速使用**作为首要部署指标；Docker、Railway、Herd、VPS 均是可选实现，不推定账户、域名或支付许可。
- 功能/插件只以免费源码真实存在与测试证明计算，不把团队邀请、点击分析或 Stripe SDK 存在当成完整裂变收款。
- 全部测试先私有/隔离，演示账号永不公网暴露；禁止 Live 收款、真实退款/转账、KYC/商户启用和未授权第三方付费。
- 禁止查看/输出真实 Secret、Cookie、客户数据；不能对已有 Docker、VPN、支付/WordPress/共享 VPS 做系统级重配、清理或删除。
- Owner 已明确移除**固定空闲内存最低值**作为 Velobase 实验前提；仍需采样实际资源，出现实际 OOM、Windows/现有业务卡死或其他项目健康回退时停止并只针对本项目回滚。
- 即使 Owner 批准候选方向，也不放宽完整 Gate、实际异常停止、回滚/证据的要求；实际机器状态必须新鲜核验。

## DEFAULT_EXECUTION_CHANNEL
`OWNER_WINDOWS_LOCAL_CODEX / TARGET_FRESH_PROOF_REQUIRED_BEFORE_WRITE`。G1 已有 Owner 转交的真实本机只读报告，G2 写入前仍需同机核验主机、Git/workspace/Compose 名称/端口状态，不能在 ChatGPT 云端容器代行。

## CURRENT_ROLLBACK_STATUS

`G2L2_WEB_POSTGRES_REDIS_RUNNING_AS_REPORTED / HTTP_NOT_HEALTHY_AT_LAST_PROBE / DB_REDIS_HEALTHY / NO_ROLLBACK_PERFORMED / OTHER_WORKLOAD_COUNTS_UNCHANGED`。

G2L2 结束时 Executor 保留三目标容器 running，Web 对宿主 HTTP 请求没有有效响应，DB/Redis healthy。两命名卷、现有镜像、网络保留，无其他 Docker 项目主动变更。G2L3 允许的可选 Web-only 重启前先收集日志、核实不可用及原 Demo 数据状态标记；若不满足条件不能重启。真实新异常只能停本项目 Web，绝不停止 Docker Desktop/WSL/其它项目。

## UNRESOLVED

- **Web HTTP 000**：未提供 curl 的退出码、禁代理直连结果、连接/TTFB/超时阶段和容器内请求对照；根因 UNKNOWN，G2L3 优先定位。
- **Affiliate 空白/跳转**：已认证时发生，Next.js 错误类别未取得；源码存在 render 期 `router.push('/404')` 潜在问题，关联但无证明；需捕获脱敏错误类与资格状态。
- **Admin 权限与 Worker**：普通用户角色 Admin 负例 UNVERIFIED；Worker 进程/队列任务实证 UNVERIFIED。不得将 Admin UI 可读误等同授权矩阵或全 SaaS PASS。
- **资源与持久化**：Web 一次 5.208 GiB/CPU 289.77%，无实测 OOM，继续关注真实运行压力；原 Demo 三个持久化密钥/seed marker 是否满足安全重启条件要在 G2L3 读取存在性（不读值）。
- **Compose 镜像标签**：旧标签 88bb... 与实际 ImageID 9ab... 不一致，但 G2L1→G2L2 实际 Web 镜像摘要已一致；元数据演变原因 UNKNOWN，不作为重建依据。
- **历史三旧容器**：归属/身份连续性与历史 G2 退出机制 UNKNOWN，Owner 本轮不恢复、不诊断；无需阻塞 SaaS。
- **项目未完**：Stripe TEST、佣金/积分、提现、退款/幂等、客户裂变闭环与 Open SaaS/Wave 实际功能仍 UNVERIFIED；在当前 UI 稳定之前不接支付。

## NEXT_STEP

让 Owner 的**本机 Codex 直接执行** [G2L3 Web 000 / Affiliate 定向诊断与条件恢复 Gate](./docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)。先区分禁代理 Host 与容器内连接情况，不盲目重启；确认应用本身挂起且隔离 Demo 安全标记俱全时仅一次现有 Web 单容器恢复，随后验收稳定性并收集 Affiliate 精确报错。必要时再做单点源码补丁 Gate，**不得先进行整站重建或切换 Codespaces/VPS**。

## OWNER_ACTION_REQUIRED

只需将 [G2L3 当前 Gate](./docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md) 转交本机 Codex；无需逐命令审批、密码、云端部署、Docker 全局修改或 Stripe 信息。

## EVIDENCE_POINTERS
[G2L3 当前 Gate](./docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)；[G2L2 Reviewer 正式裁定](./docs/G2L2_REVIEWER_DECISION_20261018.md)；[G2L2 本机 Evidence](./docs/G2L2_EXECUTION_EVIDENCE_20261018.md)；[当前 G2L2 Gate](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)；[G2L1 正式审核](./docs/G2L1_REVIEWER_DECISION_20261018.md)；[G2L1 Executor 证据](./docs/G2L1_EXECUTION_EVIDENCE_20261018.md)；[最新 G2L1 本机现有实例恢复与 UI 验收 Gate](./docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md)；[已拒绝的 G2I1 Codespaces 历史 Gate](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[G2I1 Codespaces 隔离 UI 执行 Gate（2026-10-18）](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[2026-10-18 独立接手审核与部署建议](./docs/REVIEWER_TAKEOVER_AUDIT_20261018.md)；[下一位 Reviewer 完整交接（2026-10-18）](./docs/NEXT_REVIEWER_RELAY_20261018.md)；[G2R1 Reviewer 审核](./docs/G2R1_REVIEWER_DECISION_20261018.md)；[G2R1 已结束的只读 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；[G2 Reviewer 决定](./docs/G2_REVIEWER_DECISION_20261018.md)；[G2R1 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
