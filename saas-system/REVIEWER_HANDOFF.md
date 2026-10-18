# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-18
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE
`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_REVIEWED_RETURN_EXISTING_WORKLOAD_REGRESSION / G2R1_REVIEWED_PARTIAL_CAUSE_AND_OWNER_UNKNOWN / OWNER_DEFERRED_OLD_CONTAINER_RECOVERY / G2I1_CLOSED_OWNER_REJECTED / G2L1_REVIEWED_RETURN_LOGIN_UI_MISSING / G2L2_READY_NOT_EXECUTED`。
G2L1 已由 Owner Windows 本机 Codex 复用旧 Velobase Web/Postgres/Redis 容器恢复运行；据执行报告三个容器仍 running、首页 HTTP 200、两服务 healthy，未重新构建。**正式 G2L1 功能结论仍为 RETURN：本地管理员入口缺失，Dashboard/Admin/Affiliate 未完成验收。**

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：本轮 G2/G2R1 已由 Owner 的真实 Windows 11 家庭版主机 + 本机 Codex 执行，2026-10-18 本机报告已验证运行环境；Reviewer 未直接登录真实主机，所有宿主机状态按 `OWNER_RELAYED_EXECUTOR_REPORT` 记录。今后其他环境需独立证明身份。
- **存储与服务**：G2 曾创建项目隔离源目录、镜像、Web/Postgres/Redis 容器、两个命名卷与网络；最新 G2L1 本机报告表明该项目 web/postgres/redis 已复用原容器恢复至 running，3003 首页 HTTP 200，Postgres/Redis healthy，源码/镜像/卷/网络保留；其他非目标容器起止基线一致。仅属于 Owner 转交的本机执行记录，非 Reviewer 实时宿主直读；历史旧容器精确身份连续性及退出原因 UNKNOWN。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE

**最新 G2L1 审核（2026-10-18）：** [正式 Reviewer 决定](./docs/G2L1_REVIEWER_DECISION_20261018.md) `RETURN_LOCAL_DEMO_LOGIN_UI_MISSING`；[本机执行证据](./docs/G2L1_EXECUTION_EVIDENCE_20261018.md) 证明的范围限于 Owner 转交的 Codex 实测：Docker Desktop/Engine 原已正常运行（未重新启动），现有 Velobase Web/Postgres/Redis 原容器已通过 `compose start` 恢复，首页实测 HTTP 200，Postgres/Redis healthy，Web 约 4.42 GiB、系统可用 RAM 约 0.99 GiB，未观察到其他容器状态回退。当前服务在报告时保留运行，未经本 Reviewer 直接访问 Owner 电脑复核。

**功能阻塞：** 登录弹窗只有 Google/GitHub/Email，没有本地管理员 Demo 入口；Dashboard/Admin 正例、普通用户 Admin 负例未验收，Affiliate 登录后功能未验收，匿名 `/account/affiliate` 空白且 Next.js 提示 Issue（具体异常类别未知）。Worker 启动标记已见，但未测试队列任务；Stripe/支付/退款/佣金均未触碰。

**新静态源码证据：** 固定 Velobase SHA 的 Desktop 登录组件有 `NEXT_PUBLIC_LOCAL_DEMO` 控制的本地 Demo 按钮，而 Mobile 登录组件没有；视口小于 768px 时切 Mobile。G2L1 未报告浏览器 CSS viewport，不能认定客户端开关错误或直接重建镜像。已签发 [G2L2](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)，先用 ≥1024px 桌面视口无构建复测，再按 UI 结果决定下一步。

**不变决策：** Owner 明确拒绝 Codespaces（从未执行），选择原 Windows 本机；Owner 暂不恢复历史旧容器，不再调查历史退出原因（`CAUSE_UNKNOWN`）。G0 文档初始化已 PASS，G1 历史资源 RETURN 已由 Owner 撤销固定 RAM 门槛；G2 历史 `RETURN_EXISTING_WORKLOAD_REGRESSION` 保留；不影响按 Velobase → Open SaaS → Wave 的顺序实验。完整历史证据保存在 [EXECUTION_EVIDENCE](./EXECUTION_EVIDENCE.md) 与原 G1/G2/G2R1/G2L1 决策中。

## CURRENT_GATE

`G2L2 — SAAS-G2L2-LOCAL-DESKTOP-LOGIN-AND-UI-RECHECK-20261018 / REVIEWER_READY / NOT_EXECUTED`。

[唯一当前 G2L2 Gate](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)：仅以已经运行的原 Velobase 容器，检查登录 Desktop/Mobile 渲染分支及 ≥1024px 视口；如本地 Demo 按钮可见，则通过正常 UI 登录并测试 Dashboard/Admin/Affiliate；如按钮仍不存在，则只读比较公开 provider IDs 和 Demo 开关元数据，形成明确诊断并 RETURN。禁止重建、改源码/数据库、重启 Docker、操作旧业务容器或支付。G2L1 及之前 Gate 全部历史关闭，不可复用授权。

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

`G2L1_RUNTIME_RECOVERED / EXISTING_WEB_POSTGRES_REDIS_RUNNING_AS_OF_G2L1 / ORIGINAL_IMAGES_VOLUMES_NETWORK_RETAINED / NO_ROLLBACK_EXECUTED / NO_OTHER_WORKLOAD_DELTA_OBSERVED`。

G2L1 只恢复其已有项目容器，没有源码/镜像重建；Executor 报告仍保持运行供 Owner 查看。G2L2 以无持久业务写入的 UI/健康复测为主，默认保留运行。如本轮新增实际系统/其他项目健康回退，只允许精准停止 Velobase 本身，保留旧项目、Docker Engine 与全部卷。历史三旧容器身份连续性与 G2 退出根因仍 UNKNOWN。

## UNRESOLVED

- 登录弹窗缺本地 Demo 入口：固定上游 Desktop 组件有对应按钮，Mobile 组件没有，浏览器 CSS viewport 和实际渲染分支 **UNKNOWN**；客户端编译环境是否一致也 UNKNOWN。新 Gate 优先先验视口。
- Dashboard / Admin 正向、普通用户 Admin 负例、Affiliate 登录后功能尚未完成；匿名 Affiliate 空白及 Next.js "1 Issue" 的具体堆栈 UNKNOWN。Worker 只有启动证据，后台任务处理没有运行。
- G2L1 资源采样 Web 约 4.42 GiB，主机可用 RAM 结束约 0.99 GiB；未发现本轮 OOM/其它项目状态回退，但仍需持续记录实际运行代价，不以硬阈值阻断。
- 原三个历史容器所属业务及退出机制 `CAUSE_UNKNOWN`；Owner 认为可能手动停止且暂不要求恢复，身份连续性未知，不是当前 SaaS 实验的阻塞项。
- 固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d` 的退款部分回撤、佣金重试/幂等、Stripe TEST、现金佣金提现及额外服务适配仍 UNVERIFIED。Open SaaS / Wave 尚未运行。
- 本机状态由 OWNER_RELAYED_EXECUTOR_REPORT 支持，Reviewer 未直接操作 Windows；最新物理状态有漂移时由 Codex 做有界新鲜读回。

## NEXT_STEP

**继续 G2L2 桌面登录与页面复测：** [当前 Gate](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)。本机 Docker 已报告运行，不重复启动、下载、构建。通过 ≥1024px 浏览器验证本地 Demo 按钮，正常登录后验收 Dashboard、Admin 权限与 Affiliate；若桌面仍缺入口只采最小可审差异，下一轮再针对确证原因进行单点修复。Stripe/裂变结算留待 UI 可操作后另设 Gate；Open SaaS、Wave 按既定串行次序。

## OWNER_ACTION_REQUIRED

将当前 G2L2 Gate 链接交给本机 Codex 执行即可；不需要新的账户、付款、Stripe Key、Docker 重启或额外审批。

## EVIDENCE_POINTERS
[当前 G2L2 Gate](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)；[G2L1 正式审核](./docs/G2L1_REVIEWER_DECISION_20261018.md)；[G2L1 Executor 证据](./docs/G2L1_EXECUTION_EVIDENCE_20261018.md)；[最新 G2L1 本机现有实例恢复与 UI 验收 Gate](./docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md)；[已拒绝的 G2I1 Codespaces 历史 Gate](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[G2I1 Codespaces 隔离 UI 执行 Gate（2026-10-18）](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[2026-10-18 独立接手审核与部署建议](./docs/REVIEWER_TAKEOVER_AUDIT_20261018.md)；[下一位 Reviewer 完整交接（2026-10-18）](./docs/NEXT_REVIEWER_RELAY_20261018.md)；[G2R1 Reviewer 审核](./docs/G2R1_REVIEWER_DECISION_20261018.md)；[G2R1 已结束的只读 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；[G2 Reviewer 决定](./docs/G2_REVIEWER_DECISION_20261018.md)；[G2R1 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
