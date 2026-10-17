# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-18
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE
`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_REVIEWED_RETURN_EXISTING_WORKLOAD_REGRESSION / G2R1_READONLY_DIAGNOSTIC_NEXT`。
G2 已在 Owner Windows 真机执行：固定 SHA 构建完成，Web/Postgres/Redis 曾启动且首页短时可用；因原先三个运行中容器异常退出，G2 按 Gate 停止，容器/卷/网络/镜像及源码保留。**G2 未达到完整验收，当前 3003 不可访问。**

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：未来优先 Owner 本地 Windows 11 + Codex，或经 Owner 另行确定的隔离云测试环境。**本轮未有新的环境身份证明，目标主机/项目路径/资源余量均为 UNKNOWN。**
- **存储与服务**：G2 曾创建项目隔离源目录、镜像、Web/Postgres/Redis 容器、两个命名卷与网络；据本机 Codex 回报，G2 的 3 个容器现在 stopped、3003 无监听，卷/镜像/网络保留；其他三旧容器在停止 G2 后仍 exited。所有真实当前状态需要下一次本机复核。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE
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
`SAAS-G2R1-EXISTING-WORKLOAD-READONLY-20261018` — [当前只读诊断 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)。
G2 私有部署 Gate 因旧负载回归已结束，**原 Gate 的部署许可不能再复用**。本轮不得重启 Velobase 或三个旧容器，只读查明原有工作负载现状与退出事件。

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
- G2 前三个运行中容器在 G2 期间一起退出，退出原因、Docker Engine 是否重启、其他项目的目前恢复情况及业务影响 `UNKNOWN`。不能仅凭 exit 137 或 RAM 极低判定 OOM；现有记录不存在证明的直接因果关系。
- `TARGET_LOCAL_PROOF=OWNER_RELAYED_EXECUTOR_REPORT`；历史空闲 RAM 仅 1.12/1.55 GiB，**不再构成固定前置门槛**。运行时资源影响、Docker 数据盘剩余量和新项目隔离仍需新鲜验证。
- `G1_CANDIDATE_EXACT_SHA=e88e259b974f883913f68ac74a9b8377765d005d`；上游构建耗时/性能/可访问页面=UNVERIFIED。
- 本机 pnpm 11.25.0 vs 仓库声明 10.12.1、本机 Node 24 vs Demo Node 22；将来运行时使用项目独立固定工具链，不做系统全局升级。
- Velobase 部分退款/返佣异常重试；Stripe TEST 联调；现金佣金打款与积分/会员奖励路径=UNVERIFIED。
- Open SaaS/Wave 与现成免费裂变模块的技术兼容、成本、授权=UNVERIFIED。
- 真实 Stripe 可开通地区/经营主体/商户权限=OUT_OF_SCOPE，不能由模板支持推定。

## NEXT_STEP
Owner 本机 Codex 执行 [G2R1 只读诊断](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)，核对原三个容器退出和现状、Docker Engine 生命周期及系统事件。审查后决定能否恢复原负载、转移 Velobase 到隔离环境，或停止该候选的本机实验。**不重跑 G2、不切换 Open SaaS/Wave、不自动恢复旧项目。**

## OWNER_ACTION_REQUIRED
仅把新 [G2R1 只读 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md) 链接交给本机 Codex。无需密码、付款或清理 Docker；真实恢复其他项目另立 Gate。

## EVIDENCE_POINTERS
[G2 执行证据](./docs/G2_EXECUTION_EVIDENCE_20261018.md)；[G2 Reviewer 决定](./docs/G2_REVIEWER_DECISION_20261018.md)；[G2R1 Gate](./docs/G2R1_EXISTING_WORKLOAD_READONLY_GATE_20261018.md)；[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
