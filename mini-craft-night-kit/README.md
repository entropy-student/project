# Mini Craft Night Kit

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

## 当前 Gate

`K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`

先确认原版 Kadence Single Product 的真实 UI、WooCommerce 基线、Gutenberg 可编辑性和多设备响应式。

## 文档索引

- `PROJECT_RECORD.md` — 当前唯一项目 Truth
- `REVIEWER_HANDOFF.md` — 当前 Reviewer Gate
- `docs/PROJECT_PLAN_AND_ROADMAP.md` — 整体阶段、进度与工期
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md` — UI / 增长 / clone-ui 规则
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md` — 插件与运营能力计划
- `docs/PAYMENT_ARCHITECTURE_DECISION.md` — 支付架构决定
- `docs/GITHUB_HANDOFF_PROTOCOL.md` — Reviewer / Executor GitHub 交接机制

## 当前预计周期

若无外部账号审核阻塞：

> **约 3–5 个集中工作日达到可上线 MVP。**
