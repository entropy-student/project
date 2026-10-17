# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-17
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE
`G0_PASS / G1_PREFLIGHT_REVIEWED / G2_VELOBASE_LOCAL_PRIVATE_PREVIEW_GATE_READY_NOT_EXECUTED`。
项目创建仅建立 GitHub 文档和导航。尚未授权/执行任何本机下载、安装、构建、服务启动、插件采购、Stripe 测试或真实资金操作。

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：未来优先 Owner 本地 Windows 11 + Codex，或经 Owner 另行确定的隔离云测试环境。**本轮未有新的环境身份证明，目标主机/项目路径/资源余量均为 UNKNOWN。**
- **存储与服务**：尚未创建 DB、容器、文件卷、工作树、密钥、域名、公共端口、任务队列或线上资源。`ACTUAL_RUNTIME=NONE`。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE
**2026-10-18 Owner 最新决策：**“内存不设为限制条件，继续推进”。此决策仅撤销 G1 基于低剩余 RAM 的**事前拒绝运行门槛**，并授权为 Velobase 私有本机演示设立新 Gate；**不等于要求忽视实际 OOM、Windows 不稳定或其他项目受损**。历史 G1 RETURN 保留为当时实测事实；后续用实时运行证据验收。

**G1 Reviewer 决定（2026-10-17）：** 接受本机 Codex 只读报告及 GitHub 上游源码交叉核对；静态事实已核验，Windows 内存/磁盘/端口属于 **OWNER_RELAYED_EXECUTOR_REPORT**，并非 Reviewer 直接操作物理电脑。返回 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`，不批准安装或运行。报告中两次可用 RAM 为 **1.12/1.55 GiB**；Docker 引擎约 7.40 GiB 内存与 Web `mem_limit: 8g` 不能当作最低需求或独立硬性失败指标。详细 [G1 Reviewer 决定](./docs/G1_REVIEWER_DECISION_20261017.md)。

0. **G0 初始化正式接受**：GitHub Commit [`90b40c3`](https://github.com/entropy-student/project/commit/90b40c397f84dbbecbb35f3eb9abc1ce789a29c1) 仅更改项目独立目录内 5 个文档和根 README 导航，当前 main 已回读全部文件。并行的 Birthday Magazine 提交作为后继 commit 独立存在，无本项目覆盖。
1. **研究基线，非运行证明**：2026-10-17 已在对话中审阅两组严格 SaaS-only 资料；9 个候选模板中本轮选 3 个按序实验。研究数据的 Stars/功能/收费随上游变更，运行前锁定确切 commit。
2. **Velobase 静态源码发现**：有用户/管理员/推广页面、Stripe 和 Affiliate 核心、积分兑换及一条全栈 Docker 演示命令。示例规则含 30% 佣金、30 天冻结、$4.99 推广资格、$50 最低提现；**部分退款状态/佣金回撤及事件失败补偿有明显待验证风险**。已读源码不是本机可运行 PASS。
3. **Open SaaS**：自带 Stripe/订阅/管理员/基础额度实现，缺可证实的原生客户推广佣金，需评估自研或集成；一键云部署不等于 Docker 全栈。
4. **Wave**：Laravel/Filament 用户/套餐/后台 + Stripe；无已证实免费原生裂变，Stripe Checkout 缓存去重及重试语义需要测试。
5. 原 Paymenter 试验已结束，不得未经独立授权重建。

## CURRENT_GATE
`SAAS-G2-VH-PRIVATE-DOCKER-PREVIEW-20261018` — [当前私有运行 Gate](./docs/G2_VELOBASE_PRIVATE_PREVIEW_GATE_20261018.md)。
**已由 Reviewer 制定、待 Owner 本机 Codex 执行；结果必须回 Reviewer。** 本 Gate 仅授权固定 SHA 的项目隔离安装与本机 Docker 演示、基础 Web/Admin/UI 验收及项目独有资源恢复。不上线、不接入 Stripe、不创建真实付费/推广业务。

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
`G2_NOT_EXECUTED; SCOPED_ROLLBACK_PLANNED`。当前仅 GitHub 文档变更。G2 若执行，限定新 `saasvh-e88e259` Compose 项目与独立源码/命名卷；失败时先停止**本项目**进程/容器，默认保留数据库卷与源码以便复核；不得全局 prune 或触碰已有项目。

## UNRESOLVED
- `TARGET_LOCAL_PROOF=OWNER_RELAYED_EXECUTOR_REPORT`；历史空闲 RAM 仅 1.12/1.55 GiB，**不再构成固定前置门槛**。运行时资源影响、Docker 数据盘剩余量和新项目隔离仍需新鲜验证。
- `G1_CANDIDATE_EXACT_SHA=e88e259b974f883913f68ac74a9b8377765d005d`；上游构建耗时/性能/可访问页面=UNVERIFIED。
- 本机 pnpm 11.25.0 vs 仓库声明 10.12.1、本机 Node 24 vs Demo Node 22；将来运行时使用项目独立固定工具链，不做系统全局升级。
- Velobase 部分退款/返佣异常重试；Stripe TEST 联调；现金佣金打款与积分/会员奖励路径=UNVERIFIED。
- Open SaaS/Wave 与现成免费裂变模块的技术兼容、成本、授权=UNVERIFIED。
- 真实 Stripe 可开通地区/经营主体/商户权限=OUT_OF_SCOPE，不能由模板支持推定。

## NEXT_STEP
Owner 本机 Codex 依据 [G2 私有演示 Gate](./docs/G2_VELOBASE_PRIVATE_PREVIEW_GATE_20261018.md) 在新项目路径试运行固定 SHA 的 Velobase；报告首页/用户后台/Admin/推广页面、服务健康、资源和其他项目无回归证据。失败时只做单次有针对性的本项目修正或停在 Reviewer；不先验限制 RAM，不自动改用云端、VPS 或第二候选。

## OWNER_ACTION_REQUIRED
**仅将 G2 Gate 链接交给本机 Codex 即可执行**。无需释放内存、无需账号密码/API Key/Stripe 注册、无需逐项批准项目内已授权的安装和运行操作。若实际出现项目以外的安全/资源影响才停在 Reviewer。

## EVIDENCE_POINTERS
[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
