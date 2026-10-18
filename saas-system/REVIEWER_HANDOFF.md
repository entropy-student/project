# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-18
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE

`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_HISTORICAL_RETURN_EXISTING_WORKLOAD / G2R1_CAUSE_UNKNOWN_CLOSED / G2I1_OWNER_REJECTED_NEVER_EXECUTED / G2L1_REVIEWED_RETURN_LOGIN_UI_MISSING / G2L2_REVIEWED_RETURN_AFFILIATE_BLANK_AND_HTTP_000 / G2L3_REVIEWED_PARTIAL_WEB_RESPONSIVE_AFFILIATE_UNVERIFIED / G2L4_READY_NOT_EXECUTED`。

Velobase 固定 SHA `e88e259b974f883913f68ac74a9b8377765d005d` 已在 Owner Windows 本机运行：正常官方 Demo 管理员登录、Dashboard、Admin Users 经 G2L2 验收；G2L3 Windows 禁代理和 Web 容器内 HTTP 当前均 200，未重启。Affiliate 个人页面仍无法评价且需要资格分类。后续 Open SaaS → Wave 串行 PENDING。

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：本轮 G2/G2R1 已由 Owner 的真实 Windows 11 家庭版主机 + 本机 Codex 执行，2026-10-18 本机报告已验证运行环境；Reviewer 未直接登录真实主机，所有宿主机状态按 `OWNER_RELAYED_EXECUTOR_REPORT` 记录。今后其他环境需独立证明身份。
- **存储与服务**：G2 曾创建项目隔离源目录、镜像、Web/Postgres/Redis 容器、两个命名卷与网络；最新 G2L1 本机报告表明该项目 web/postgres/redis 已复用原容器恢复至 running，3003 首页 HTTP 200，Postgres/Redis healthy，源码/镜像/卷/网络保留；其他非目标容器起止基线一致。仅属于 Owner 转交的本机执行记录，非 Reviewer 实时宿主直读；历史旧容器精确身份连续性及退出原因 UNKNOWN。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE

**最新 G2L3 正式裁定（2026-10-18）：** [Reviewer 独立审核](./docs/G2L3_REVIEWER_DECISION_20261018.md) `PARTIAL_G2L3_WEB_RESPONSIVE_AFFILIATE_UNVERIFIED`；[本机执行证据](./docs/G2L3_EXECUTION_EVIDENCE_20261018.md) 为 Owner 转交 Codex 报告，不是 Reviewer 亲自操控 Windows。本机 `curl.exe --noproxy '*'` 连续 HTTP 200（首个 TTFB 5.05 秒，后约 0.2–0.31 秒），容器内 Node HTTP 200，Postgres/Redis healthy；Web restart 0 次，原有容器/镜像/卷/网络保留。G2L2 历史 HTTP 000 的失败原因 UNKNOWN，代理变量存在不能证明它是历史故障根因。Web CPU 曾 388.84% 后回落，内存约 5.73–5.77 GiB，宿主可用内存 1.4–2.15 GB；未观察到 OOM。本轮非目标容器未执行更改，但未采集结束库存，**其实际前后状态差异 UNKNOWN**。

**已验收与未验收：** G2L2 已用原生桌面 Demo 按钮登录管理员，真实 Dashboard 与 Admin Users（33 条演示用户）读屏正例保留，不再重复登录调查。G2L3 登录状态下 `/account/affiliate` 空白、重载返回首页，未读得 Affiliate status query 的资格/错误布尔或 HTTP 状态，不能断定为代码崩溃。普通用户 Admin 负例与 Worker 真实任务仍 UNVERIFIED。Stripe/佣金/部分退款未接入/运行。

**固定上游源码新增结论（直接 GitHub 回读）：** `services/demo/seed.ts` 创建本地管理员但不授予个人推广资格；`src/server/api/routers/affiliate.ts` 的 `getStatus` 依据累计支付达到 $4.99、推广开通或佣金余额计算 `eligible`。管理员身份不等于有资格；`src/app/account/affiliate/page.tsx` 在缺资格/缺 query 数据时执行 render 期 `router.push('/404')` 和 `return null`，与空白及跳转相容，但**本机实际资格尚未经只读证实**。已存在独立后台推广佣金页与提现管理页，可在当前原生管理员界面只读验收。为避免第 4 轮泛化抓错，新 Gate 直接核实已知合成管理员的资格分类及两个 Admin Affiliate 页的真实 UI。

**不变决策：** Owner 拒绝 Codespaces，仅用本机原有 Velobase，历史三个未知旧容器不恢复不诊断；历史 G1/G2/G2R1/G2I1/G2L1/G2L2 原判定及 Evidence 保留。镜像 ID `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef` 延续，Compose 历史 image 标签差异尚不构成重建理由。

## CURRENT_GATE

`G2L4 — SAAS-G2L4-AFFILIATE-ELIGIBILITY-AND-ADMIN-READONLY-20261018 / REVIEWER_READY / NOT_EXECUTED`。

[唯一当前 G2L4 Gate](./docs/G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md)：只读核实隔离 Demo 管理员**是否真正满足个人 Affiliate 资格**（只输出合成账号布尔资格摘要，绝不写数据库），并通过官方 UI 实测 `/admin/affiliate/commissions` 与 `/admin/affiliate/payouts` 两个真实后台页面，明确个人页面是权限资格受限还是已有资格却出错。保持原 Web/DB/Redis 运行，无源码/镜像修改、无 Docker 重启、无资格绕过、无真实支付。完成这次分类即交 Reviewer 决定 Velobase 候选结论/后续产品，不再追加同类泛化 CDP 抓错 Gate。G2L3 及更早 Gates 全部 HISTORICAL_CLOSED。

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

`G2L3_WEB_HTTP_200_HOST_NO_PROXY_AND_CONTAINER / WEB_POSTGRES_REDIS_RUNNING_AT_EXECUTOR_END / NO_RESTART / ORIGINAL_VOLUMES_IMAGES_RETAINED / NO_PAYMENT / OTHER_PROJECT_END_STATE_UNVERIFIED`。

G2L3 全程只读，未操作其它容器、没有 Web 重启、也没有回滚；合成管理员浏览器会话原样保留。Web 无容器级 healthcheck，HTTP 200 是本轮时点的两个访问通路成功，不能虚构永久稳定。G2L4 仍为只读，数据库只能访问隔离 Demo 并使用 read-only transaction；任何意外真实项目风险 STOP，不得停止 Docker Engine、改其它项目或清卷。

## UNRESOLVED

- **Affiliate 个人页：** 空白+跳转路径现象确定，但 G2L3 仍无法获得 `affiliate.getStatus` 的资格布尔与错误类。本轮优先查**合成演示管理员是否有推广资格**及后台官方推广页面，避免反复抓通用客户端错误。
- **Web 历史 HTTP 000：** G2L2 原因 UNKNOWN；G2L3 Windows 禁代理与容器内 HTTP 都是 200，当前没有证据需要重启或改代理。首个请求 TTFB 5.05 秒和 5.7GiB Web 内存值得继续观察，未观测 OOM。
- **权限与 Worker：** 普通用户 Admin 负面授权未测试、Worker 真实队列处理没有证据；不能给整个 SaaS 业务/安全 PASS。
- **隔离证据：** G2L3 未操作非目标容器，但只采起始而未采结束数量；真实前后差异 UNKNOWN，G2L4 补足只读清单。
- **镜像元数据：** 实际 Web image ID 延续 9ab2468d...，旧 Compose label 为 88bb7e...，原因 UNKNOWN，不据此 rebuild/recreate。
- **历史三个其它容器**退出的根因/连续身份 UNKNOWN，Owner 暂不恢复；Stripe TEST、推广转化与结算/退款等尚未实测。

## NEXT_STEP

**执行 G2L4 资格归类和现有推广后台 UI 验收**：[当前 Gate](./docs/G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md)。本机 Codex 不重启、不 build、不改资格，先用只读 DB 合成演示管理员布尔摘要判断是否有推广资格，再用正常 Admin 浏览器打开佣金和提现管理页。结果有明确分类后由 Reviewer决定是需要一个具体单文件 UI 改进、接受模板的产品限制，还是按原串行计划评估 Open SaaS。

## OWNER_ACTION_REQUIRED

仅需将当前 G2L4 Gate 链接转交本机 Codex，执行结束反馈脱敏 Evidence。无需密码、付款、额外账号或逐项审批。

## EVIDENCE_POINTERS
[G2L4 当前 Gate](./docs/G2L4_AFFILIATE_ELIGIBILITY_AND_ADMIN_READONLY_GATE_20261018.md)；[G2L3 Reviewer 裁定](./docs/G2L3_REVIEWER_DECISION_20261018.md)；[G2L3 执行证据](./docs/G2L3_EXECUTION_EVIDENCE_20261018.md)；[G2L3 当前 Gate](./docs/G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md)；[G2L2 Reviewer 正式裁定](./docs/G2L2_REVIEWER_DECISION_20261018.md)；[G2L2 本机 Evidence](./docs/G2L2_EXECUTION_EVIDENCE_20261018.md)；[当前 G2L2 Gate](./docs/G2L2_LOCAL_DESKTOP_AUTH_AND_UI_RECHECK_GATE_20261018.md)；[G2L1 正式审核](./docs/G2L1_REVIEWER_DECISION_20261018.md)；[G2L1 Executor 证据](./docs/G2L1_EXECUTION_EVIDENCE_20261018.md)；[最新 G2L1 本机现有实例恢复与 UI 验收 Gate](./docs/G2L1_LOCAL_EXISTING_DEMO_RESUME_GATE_20261018.md)；[已拒绝的 G2I1 Codespaces 历史 Gate](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[G2I1 Codespaces 隔离 UI 执行 Gate（2026-10-18）](./docs/G2I1_VELOBASE_CODESPACES_PRIVATE_PREVIEW_GATE_20261018.md)；[2026-10-18 独立接手审核与部署建议](./docs/REVIEWER_TAKEOVER_AUDIT_20261018.md)；[下一位 Reviewer 完整交接（2026-10-18）](./docs/NEXT_REVIEWER_RELAY_20261018.md)；[G2R1 Reviewer 审核](./docs/G2R1_REVIEWER_DECISION_20261018.md)；[G2R1 已结束的只读 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；[G2 Reviewer 决定](./docs/G2_REVIEWER_DECISION_20261018.md)；[G2R1 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
