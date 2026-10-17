# SaaS System Lab — REVIEWER_HANDOFF

> UPDATED=2026-10-17
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> CANONICAL_PROJECT=`entropy-student/project@main:saas-system/`
> REVIEWER_OWNERS_CURRENT_TRUTH=YES
> STOP_AT_REVIEWER=YES

## PROJECT_GOAL
顺序实测 **Velobase Harness → Open SaaS → Wave**，挑选能够长期复用、迅速部署/体验且免费开源的 SaaS 模板。前台、用户中心、平台 Admin、Stripe、客户裂变与奖励回撤是主要判断标准。**Docker 是可选方式，不是硬性要求**。优先用原生功能，其次评估可靠的免费开源扩展，最后才考虑付费服务或自研。

## PROJECT_STAGE
`G0_PROJECT_RECORD_PASS / G1_VELOBASE_PREFLIGHT_REVIEWED_RETURN_RESOURCE_HEADROOM_INSUFFICIENT / RUNTIME_NOT_TESTED`。
项目创建仅建立 GitHub 文档和导航。尚未授权/执行任何本机下载、安装、构建、服务启动、插件采购、Stripe 测试或真实资金操作。

## SYSTEM_MAP
- **GitHub**：当前项目只管理项目状态、方案、Gate 与脱敏 Evidence；候选源码独立上游，不直接复制进入项目主仓库。
- **候选入口**：`velobase/velobase-harness`（Next.js/Prisma/Postgres/Redis/Worker；`compose.demo.yml`）；`wasp-lang/open-saas`（Wasp/React/Prisma/Postgres；Railway/Fly.io 等部署路线）；`thedevdojo/wave`（Laravel/Filament/Stripe；Herd/常规 PHP 部署路线）。
- **执行目标**：未来优先 Owner 本地 Windows 11 + Codex，或经 Owner 另行确定的隔离云测试环境。**本轮未有新的环境身份证明，目标主机/项目路径/资源余量均为 UNKNOWN。**
- **存储与服务**：尚未创建 DB、容器、文件卷、工作树、密钥、域名、公共端口、任务队列或线上资源。`ACTUAL_RUNTIME=NONE`。
- **外部 Provider**：候选具有 Stripe 相关源代码；没有为本实验授权、绑定或测试任何 Stripe 商户。外部邮件/身份/API/AI 依赖及免费额度视具体候选核实。
- **依赖与影响**：不得触碰 Paymenter 已结束实验、其他项目工作树、Docker 共享资源、既有数据库、共享 VPS、反代、网络/代理、已使用端口、GitHub 其他子树。

## CURRENT_ACCEPTED_STATE
**G1 Reviewer 决定（2026-10-17）：** 接受本机 Codex 只读报告及 GitHub 上游源码交叉核对；静态事实已核验，Windows 内存/磁盘/端口属于 **OWNER_RELAYED_EXECUTOR_REPORT**，并非 Reviewer 直接操作物理电脑。返回 `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`，不批准安装或运行。报告中两次可用 RAM 为 **1.12/1.55 GiB**；Docker 引擎约 7.40 GiB 内存与 Web `mem_limit: 8g` 不能当作最低需求或独立硬性失败指标。详细 [G1 Reviewer 决定](./docs/G1_REVIEWER_DECISION_20261017.md)。

0. **G0 初始化正式接受**：GitHub Commit [`90b40c3`](https://github.com/entropy-student/project/commit/90b40c397f84dbbecbb35f3eb9abc1ce789a29c1) 仅更改项目独立目录内 5 个文档和根 README 导航，当前 main 已回读全部文件。并行的 Birthday Magazine 提交作为后继 commit 独立存在，无本项目覆盖。
1. **研究基线，非运行证明**：2026-10-17 已在对话中审阅两组严格 SaaS-only 资料；9 个候选模板中本轮选 3 个按序实验。研究数据的 Stars/功能/收费随上游变更，运行前锁定确切 commit。
2. **Velobase 静态源码发现**：有用户/管理员/推广页面、Stripe 和 Affiliate 核心、积分兑换及一条全栈 Docker 演示命令。示例规则含 30% 佣金、30 天冻结、$4.99 推广资格、$50 最低提现；**部分退款状态/佣金回撤及事件失败补偿有明显待验证风险**。已读源码不是本机可运行 PASS。
3. **Open SaaS**：自带 Stripe/订阅/管理员/基础额度实现，缺可证实的原生客户推广佣金，需评估自研或集成；一键云部署不等于 Docker 全栈。
4. **Wave**：Laravel/Filament 用户/套餐/后台 + Stripe；无已证实免费原生裂变，Stripe Checkout 缓存去重及重试语义需要测试。
5. 原 Paymenter 试验已结束，不得未经独立授权重建。

## CURRENT_GATE
`NONE — SAAS-G1-VH-READONLY-PREFLIGHT-20261017 REVIEWED_RETURN_RESOURCE_HEADROOM_INSUFFICIENT`。
[历史 G1 Gate](./docs/G1_VELOBASE_READONLY_GATE.md) 已收到只读本机回报并完成 Reviewer 结论。**无安装/运行 Gate 获授权；不自动重试或切换云端、VPS、下一个模板。**

## CRITICAL_CONSTRAINTS
- 项目顺序固定 Velobase → Open SaaS → Wave；不并行安装，不因候选失败立刻切换并部署。
- 采用**可快速使用**作为首要部署指标；Docker、Railway、Herd、VPS 均是可选实现，不推定账户、域名或支付许可。
- 功能/插件只以免费源码真实存在与测试证明计算，不把团队邀请、点击分析或 Stripe SDK 存在当成完整裂变收款。
- 全部测试先私有/隔离，演示账号永不公网暴露；禁止 Live 收款、真实退款/转账、KYC/商户启用和未授权第三方付费。
- 禁止查看/输出真实 Secret、Cookie、客户数据；不能对已有 Docker、VPN、支付/WordPress/共享 VPS 做系统级重配、清理或删除。
- 即使 Owner 批准候选方向，也不放宽完整 Gate、资源/回滚/证据的要求；实际机器状态必须新鲜核验。

## DEFAULT_EXECUTION_CHANNEL
`PROPOSED_OWNER_WINDOWS_LOCAL_CODEX; NOT_YET_VERIFIED`。目标身份/可执行权限和可用资源由 G1 只读证据确认。GitHub 连接仅用于项目文档，不声称代替 Owner 真实本机执行。

## CURRENT_ROLLBACK_STATUS
`DOCUMENTATION_ONLY_REVERSIBLE_VIA_GIT; RUNTIME_NOT_APPLICABLE`。G0 仅新增 `saas-system/` 与根 README 导航一行；其他项目无需回滚。后续运行 Gate 必须另定义隔离数据、备份/恢复和项目专属撤销方式。

## UNRESOLVED
- `TARGET_LOCAL_PROOF=OWNER_RELAYED_EXECUTOR_REPORT`；物理主机已由本机 Codex 只读采样，当前可用内存仅 1.12/1.55 GiB；后续安装前需新鲜资源读回，Docker 数据盘剩余量仍 UNKNOWN。
- `G1_CANDIDATE_EXACT_SHA=e88e259b974f883913f68ac74a9b8377765d005d`；上游构建耗时/性能/可访问页面=UNVERIFIED。
- 本机 pnpm 11.25.0 vs 仓库声明 10.12.1、本机 Node 24 vs Demo Node 22；将来运行时使用项目独立固定工具链，不做系统全局升级。
- Velobase 部分退款/返佣异常重试；Stripe TEST 联调；现金佣金打款与积分/会员奖励路径=UNVERIFIED。
- Open SaaS/Wave 与现成免费裂变模块的技术兼容、成本、授权=UNVERIFIED。
- 真实 Stripe 可开通地区/经营主体/商户权限=OUT_OF_SCOPE，不能由模板支持推定。

## NEXT_STEP
保留 G1 已确认事实，不重复源码审核。等待本机资源状态实质改善后只读复采 RAM/运行环境，或经 Owner 选择另一个隔离的测试环境后做新的环境/费用预检；Reviewer 再单独制定私有运行 Gate。运行前不清理、关闭或改动其他项目，不执行 Stripe 或裂变测试。严格顺序仍为 Velobase → Open SaaS → Wave。

## OWNER_ACTION_REQUIRED
当前 **NONE**：无需清理 Docker 或关闭既有项目、无需购买/开通 Stripe。将来资源改善可告知 Reviewer，或由 Owner 另行指定隔离云测试环境；这两种路径都需新的审核边界，不可自动转运行。

## EVIDENCE_POINTERS
[G1 Reviewer 决定与回报摘要](./docs/G1_REVIEWER_DECISION_20261017.md)；[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 记录 G0；实验路线 [SERIAL_EXPERIMENT_PLAN.md](./docs/SERIAL_EXPERIMENT_PLAN.md)。上游基线链接： [Velobase](https://github.com/velobase/velobase-harness) / [Open SaaS](https://github.com/wasp-lang/open-saas) / [Wave](https://github.com/thedevdojo/wave)。
