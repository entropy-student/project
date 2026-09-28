# Mini Craft Night Kit

## Governance authority

通用 VPS / SSH / Shared Infra / Storage / Secret / Gate 规则统一以
`entropy-student/spike.skill/vps-project-governance` canonical latest 为准。
本项目文档中重复这些规则的内容只作历史/项目说明，不构成第二套 Governance。
项目专属事实仍以当前 Reviewer decision/Handoff + accepted Evidence 为准。

## 项目目标

用最少自建工作，把 Mini Craft Night Kit 做成一个可正式销售的英文独立站。

当前 MVP 路线：

```text
WordPress
→ Kadence Single Product
→ WooCommerce
→ Mini Craft 品牌化
→ WooCommerce PayPal Payments
→ QA
→ VPS
→ Production Canary
→ 上线
```

## 已确认原则

- Starter Template 是结构 Source of Truth；
- K1 前先由 Owner + Reviewer + Growth/Acquisition Framework 确认 UI / Offer / CTA / Trust；
- clone-ui 只负责视觉辅助，不可破坏 Gutenberg / responsive / WooCommerce；
- WooCommerce 已提供的 Cart / Checkout / Order / Account 不重复开发；
- Mini Craft MVP 的 canonical commerce/order system 是 WooCommerce；
- MVP 支付优先 WooCommerce PayPal Payments；
- Dujiao 不叠加为第二套订单系统；
- 插件按最小化原则安装；
- Reviewer 与 Executor 的长期结果写入本项目 GitHub 目录；
- 旧 01–05 保留作为视觉/文案/素材参考，不继续扩展 06–19；
- 本地 Release Candidate 通过前不部署 VPS。

## 当前状态

支付基础设施已经完成 Production readiness 封板：

```text
K7_PAYMENT_INFRASTRUCTURE_READINESS=PASS_WITH_DEFERRED_FIRST_LIVE_TRANSACTION_CANARY
REAL_MONEY_END_TO_END_VALIDATION=DEFERRED_NOT_PASS
FIRST_LIVE_TRANSACTION_CANARY=ARMED_FOR_FUTURE_REAL_TRANSACTION
```

当前生产基线：

- WooCommerce 币种：USD；
- Product 223：发布但无价格、不可购买；
- 隐藏 Canary Product 1224：USD 1.00；
- Canary Checkout：数量 1，总额 USD 1.00，运费/税费均为 0，PayPal 可见；
- PayPal Live / 当前 origin webhook / Resend 邮件基础：已有 accepted PASS；
- WordPress / MariaDB / 项目数据库备份：正常；
- 当前订单 / 真实付款 / 退款：0；
- Soft Launch：未授权。

因为当前无法完成 Owner-controlled 真钱支付，真实端到端验证被明确延期，而不是伪造 PASS。第一笔未来真实 PayPal 交易将自动成为 `FIRST_LIVE_TRANSACTION_CANARY`；届时必须核对 Provider、WooCommerce、签名 webhook 和交易邮件，任何不一致先开 bounded recovery Case，禁止盲目重付。退款仍需单独 Owner 授权。

当前无需 Owner 操作，也没有正在执行的 payment Gate。

## 文档索引

- `REVIEWER_HANDOFF.md` — 当前 Reviewer 项目 Truth / Gate
- `PROJECT_RECORD.md` — 长期项目记录
- `docs/PROJECT_PLAN_AND_ROADMAP.md` — 整体阶段、进度与工期
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md` — UI / 增长 / clone-ui 规则
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md` — 插件与运营能力计划
- `docs/PAYMENT_ARCHITECTURE_DECISION.md` — 支付架构决定
- `PROJECT_STORAGE_MANIFEST.md` — Shared VPS 项目存储/恢复地图
- `docs/GITHUB_HANDOFF_PROTOCOL.md` — Mini Craft 专属交接补充规则

## 原始 Roadmap 工期估计（历史参考）

若无外部账号审核阻塞：

> **约 3–5 个集中工作日达到可上线 MVP。**
