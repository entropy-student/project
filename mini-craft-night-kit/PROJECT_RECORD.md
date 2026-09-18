# Mini Craft Night Kit — PROJECT RECORD

Last updated: 2026-09-18

## Current Truth

```text
STRATEGIC_PIVOT_TO_KADENCE_SINGLE_PRODUCT=APPROVED
OLD_19_PAGE_HIGH_FIDELITY_ROUTE=PAUSED
OLD_PROJECT=KEEP
MANUAL_06_19_REBUILD=STOP

UI_GROWTH_PRE_REVIEW=APPROVED
CLONE_UI_ROLE=VISUAL_ASSIST_ONLY
MINIMAL_PLUGIN_POLICY=APPROVED
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
MVP_PAYMENT=WOOCOMMERCE_PAYPAL_PAYMENTS
DUJIAO_SECOND_ORDER_SYSTEM=NO
GITHUB_HANDOFF_PROTOCOL=TRIAL_APPROVED

CURRENT_GATE=K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED
```

## Why the route changed

旧路线从 CrossBorder / Medusa 视觉参考出发，手工迁移到 Gutenberg 并计划逐页复刻 01–19。

旧路线已完成：
- 01 Home：高保真 PASS；
- 02–05：高保真 PASS。

随后发现：
- Gutenberg Invalid Block；
- 超宽屏 / zoom-out 响应式迁移不完整；
- 继续实现 06–19 会重复建设 WooCommerce 已有能力。

因此转为成熟 WordPress 电商路线。

## New Architecture

```text
WordPress
→ Kadence Theme
→ Kadence Blocks
→ Kadence Single Product Starter Template
→ WooCommerce
→ Minimal Brand Adaptation
→ WooCommerce PayPal Payments
→ Conversion / Trust
→ RC QA
→ VPS
→ Production Canary
```

## Gate Plan

### K0 — Kadence Local PoC
只导入原版，不做品牌改造。验证 UI、Gutenberg、WooCommerce、手机/平板/桌面响应式。

### K1 — UI/Growth Decision + Brand Adaptation
Owner + Reviewer + Growth/Acquisition Framework 先确认 Offer / Hero / CTA / Trust / KEEP-ADAPT-DROP，再交给 Executor。

### K2 — WooCommerce Commerce Loop
Product → Cart → Checkout → Order → Confirmation。

### K3 — Payment
MVP 固定为 WooCommerce + WooCommerce PayPal Payments。

Dujiao 不作为 Mini Craft 的第二套 canonical order system。

长期若统一支付收益明确，再评估 WooCommerce → Shared Payment Layer Adapter。

### K4 — Conversion & Trust
Home / Product / FAQ / Shipping & Returns / Contact。

### K5 — Release Candidate QA
移动、平板、桌面、超宽；Gutenberg validity；Cart/Checkout；邮件；性能；SEO；Secret hygiene。

### K6 — VPS Deployment
本地 RC PASS 后再做。

### K7 — Production Canary
低金额真实订单 → 支付 → 状态 → 邮件 → 退款/取消 → 上线。

## UI Governance

Executor 开始 K1 前必须先有 Reviewer-approved UI Decision。

clone-ui 只用于已确认 UI 的视觉收敛，不得牺牲：
- Gutenberg validity；
- responsive；
- WooCommerce hooks / behavior；
- Owner editability；
- business truth。

UI Gate 同时要求：

```text
VISUAL_FIDELITY=PASS
GUTENBERG_VALIDITY=PASS
RESPONSIVE=PASS
WOOCOMMERCE_BEHAVIOR=PASS
OWNER_EDITABILITY=PASS
BUSINESS_TRUTH=PASS
```

## Plugin Policy

插件最小化。

K0 只允许 Kadence / Starter Template / WooCommerce 基础组件。

后续按需增加：
- PayPal Payments；
- transactional email；
- 单一 SEO 插件；
- analytics；
- 必要 backup/migration。

Reviews、CRM、弃购、affiliate、loyalty、A/B test、ERP/OMS/WMS 等全部等真实需求出现后再开 Gate。

## GitHub Handoff

Reviewer owns：
- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- `docs/*DECISION*.md`

Executor owns：
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- bounded evidence indexes

连续至少 3 个 Gate 跑通后，再通过 Governance Change Gate 推广到全局规范。

## Current Documents

- `docs/PROJECT_PLAN_AND_ROADMAP.md`
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md`
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md`
- `docs/PAYMENT_ARCHITECTURE_DECISION.md`
- `docs/GITHUB_HANDOFF_PROTOCOL.md`

## Current Next Action

`K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`

开发总周期预估：**3–5 个集中工作日**，不含 PayPal/KYC 等外部审批等待。
