# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-18
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE
`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_REVIEWED_RETURN_EXISTING_WORKLOAD_REGRESSION / G2R1_REVIEWED_PARTIAL_CAUSE_AND_OWNER_UNKNOWN / OWNER_DECISION_PENDING`。
G2 已在 Owner Windows 真机执行：固定 SHA 构建完成，Web/Postgres/Redis 曾启动且首页短时可用；因原先三个运行中容器异常退出，G2 按 Gate 停止，容器/卷/网络/镜像及源码保留。**G2 未达到完整验收，当前 3003 不可访问。**

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：未来优先 Owner 本地 Windows 11 + Codex，或经 Owner 另行确定的隔离云测试环境。**本轮未有新的环境身份证明，目标主机/项目路径/资源余量均为 UNKNOWN。**
- **存储与服务**：G2 曾创建项目隔离源目录、镜像、Web/Postgres/Redis 容器、两个命名卷与网络；据本机 Codex 回报，G2 的 3 个容器现在 stopped、3003 无监听，卷/镜像/网络保留；其他三旧容器在 G2R1 中再次报告为 exited。现状以 2026-10-18 本机报告为准，后续有漂移时再读回；旧三容器所属业务未知。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE
**G2R1 Reviewer 最新结论（2026-10-18）：** [独立审核](./docs/G2R1_REVIEWER_DECISION_20261018.md) — `PARTIAL_G2R1_OWNER_CLASSIFICATION_UNKNOWN`，原因调查到此停止。三个原容器当前仍报告 `exited`，退出码 137/0/0；处于同一 Compose 项目，5.9 秒内退出，根因 `CAUSE_UNKNOWN`。没有证据证明 Docker 重启、OOM 或 Velobase 的直接因果；旧项目所属业务仍 `UNKNOWN`，因此**不宣称 G2R1 整轮正式 PASS**。没有额外本机写入。下一步需要 Owner 决定旧容器是否需要恢复；不再反复诊断退出原因。

**G2 Reviewer（2026-10-18）：** `RETURN_EXISTING_WORKLOAD_REGRESSION`。已审 [执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；构建/首页 200/登录入口均为 Executor 报告的阶段性进展，Dashboard/Admin/Affiliate/Worker 未完成。既有三个容器相近 6 秒退出（137、0、0，OOMKilled=false）；**时间相关但因果未知**。运行影响已触发 Gate 的停止条件。[决定](./docs/G2_REVIEWER_DECISION_20261018.md)。

**2026-10-18 Owner 最新决策：**“内存不设为限制条件，继续推进”。此决策仅撤销 G1 基于低剩余 RAM 的**事前拒绝运行门槛**，并授权为 Velobase 私有本机演示设立新 Gate；**不等于要求忽视实际 OOM、Windows 不稳定或其他项目受损**。历史 G1 RETURN 保留为当时实测事实；后续用实时运行证据验收。

**G1 Reviewer 决定（2026-10-17）：** 接受本机 Codex 只读报告及 GitHub 上游源码交叉核对；静态事实已核验，Windows 内存/磁盘/端口属于 **OWNER_RELAYED_EXECUTOR_REPORT**，并非 Reviewer 直接操作物理电脑。返回 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`，不批准安装或运行。报告中两次可用 RAM 为 **1.12/1.55 GiB**；Docker 引擎约 7.40 GiB 内存与 Web `mem_limit: 8g` 不能当作最低需求或独立硬性失败指标。详细 [G1 Reviewer 决定](./docs/G1_REVIEWER_DECISION_20261017.md)。

0. **G0 初始化正式接受**：GitHub Commit [`90b40c3`](https://github.com/entropy-student/project/commit/90b40c397f84dbbecbb35f3eb9abc1ce789a29c1) 仅更改项目独立目录内 5 个文档和根 README 导航，当前 main 已回读全部文件。并行的 Birthday Magazine 提交作为后继 commit 独立存在，无本项目覆盖。
1. **研究基线，非运行证明**：2026-10-17 已在对话中审阅两组严格 SaaS-only 资料；9 个候选模板中本轮选 3 个按序实验。研究数据的 Stars/功能/收费随上游变更，运行前锁定确切 commit。
2. **Velobase 静态源码发现**：有用户/管理员/推广页面、Stripe 和 Affiliate 核心、积分兑换及一条全栈 Docker 演示命令。示例规则含 30% 佣金、30 天冻结、$4.99 推广资格、$50 最低提现；**部分退款状态/佣金回撤及事件失败补偿有明显待验证风险**。已读源码不是本机可运行 PASS。
3. **Open SaaS**：自带 Stripe/订阅/管理员/基础额度实现，缺可证实的原生客户推广佣金，需评估自研或集成；一键云部署不等于 Docker 全栈。
4. **Wave**：Laravel/Filament 用户/套餐/后台 + Stripe；无已证实免费原生裂变，Stripe Checkout 缓存去重及重试语义需要测试。
5. 原 Paymenter 试验已结束，不得未经独立授权重建。

## CURRENT_GATE
`NONE — G2R1 REVIEWED_PARTIAL / CAUSE_UNKNOWN / OWNER_PROJECT_UNKNOWN`。
G2R1 已交 Reviewer 且针对原因的有界只读调查结束；**无新的主机、容器或支付执行授权**。旧容器是否需恢复属于独立项目决策，Velobase 后续隔离演示也须新 Gate。禁止沿用已经结束的 G2/G2R1 权限。

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
`G2_EXPERIMENT_STOPPED / ARTIFACTS_RETAINED / ORIGINAL_WORKLOAD_RECOVERY_UNKNOWN`。执行器报告仅停止新 `saasvh-e88e259` 项目，未恢复其他已退出容器；未清除任何镜像、网络或卷。旧负载现状尚需只读核对。

## UNRESOLVED
- G2R1 复查确认（来自 Owner 转交的本机 Codex 脱敏报告）：三个旧容器依旧全部 `exited`，分别 137/0/0，且同属一个 Compose 项目；业务类别和恢复必要性 `UNKNOWN`。Docker/Windows 事件不足以证明任何直接因果，不能单凭低内存或退出码判定 OOM。
- `TARGET_LOCAL_PROOF=OWNER_RELAYED_EXECUTOR_REPORT`；历史空闲 RAM 仅 1.12/1.55 GiB，**不再构成固定前置门槛**。运行时资源影响、Docker 数据盘剩余量和新项目隔离仍需新鲜验证。
- `G1_CANDIDATE_EXACT_SHA=e88e259b974f883913f68ac74a9b8377765d005d`；上游构建耗时/性能/可访问页面=UNVERIFIED。
- 本机 pnpm 11.25.0 vs 仓库声明 10.12.1、本机 Node 24 vs Demo Node 22；将来运行时使用项目独立固定工具链，不做系统全局升级。
- Velobase 部分退款/返佣异常重试；Stripe TEST 联调；现金佣金打款与积分/会员奖励路径=UNVERIFIED。
- Open SaaS/Wave 与现成免费裂变模块的技术兼容、成本、授权=UNVERIFIED。
- 真实 Stripe 可开通地区/经营主体/商户权限=OUT_OF_SCOPE，不能由模板支持推定。

## NEXT_STEP
不再重复原容器退出原因诊断。等待 Owner 确认旧三个容器是需要恢复、可暂时保留停止，还是有另一优先级；若要求恢复，先在 Owner 本机确定真实 Compose 项目归属及启动影响，**再签发受限的原项目恢复 Gate**。SaaS 后续优先研究**独立于当前 Docker Engine 的临时隔离环境**，经明确费用/账号与启动 Gate 后再完成 Velobase 的 Dashboard/Admin/Affiliate 演示，三候选顺序不变。

## OWNER_ACTION_REQUIRED
**需要一个决策：原有三个 Docker 容器是否需要恢复运行？** 若需要，先按项目归属与服务影响制定一次有界恢复 Gate；若不需要，记录为有意暂停。无需重复 G2R1、清理 Docker、提供密码或购买服务。SaaS 改为独立环境时另行确认费用与目标。

## EVIDENCE_POINTERS
[G2R1 Reviewer 审核](./docs/G2R1_REVIEWER_DECISION_20261018.md)；[G2R1 已结束的只读 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；[G2 Reviewer 决定](./docs/G2_REVIEWER_DECISION_20261018.md)；[G2R1 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
