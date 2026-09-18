# Mini Craft Night Kit — PROJECT RECORD

Last updated: 2026-09-18

## 1. Current Truth

Strategic pivot approved:

```text
OLD_19_PAGE_HIGH_FIDELITY_ROUTE=PAUSED
OLD_PROJECT=KEEP
MANUAL_06_19_REBUILD=STOP
CURRENT_GATE=K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED
```

## 2. Why the route changed

旧路线从 CrossBorder / Medusa 视觉参考出发，手工迁移到 Gutenberg 并计划逐页复刻 01–19。

已完成：
- 01 Home：高保真旧路线 PASS
- 02–05：高保真旧路线 PASS

随后发现：
- Gutenberg Invalid Block；
- 超宽屏 / zoom-out 响应式迁移不完整；
- 继续手工实现 06–19 会重复建设 WooCommerce 已有能力。

因此转为成熟 WordPress 电商路线。

## 3. New Architecture

```text
WordPress
→ Kadence Theme
→ Kadence Blocks
→ Kadence Single Product Starter Template
→ WooCommerce
→ Minimal Brand Adaptation
→ Payment
→ Conversion / Trust
→ RC QA
→ VPS
→ Production Canary
```

## 4. Gate Plan

### K0 — Kadence Local PoC
只导入原版，不做品牌改造。验证 UI、Gutenberg、WooCommerce、手机/平板/桌面响应式。

### K1 — Mini Craft Brand Adaptation
Owner + Reviewer + Growth/Acquisition 判断页面内容与转化结构后，再下发给 Executor。原则是不改主骨架，只换品牌、图片、文案、必要视觉。

### K2 — WooCommerce Commerce Loop
Product → Cart → Checkout → Order → Confirmation。

### K3 — Payment
在以下方案中做正式决策：
- WooCommerce 官方 PayPal Payments；
- WooCommerce → Shared Payment Layer；
- Dujiao 作为外部订单/支付入口。

必须单独评审，不允许默认把 Dujiao 和 WooCommerce 两套订单体系同时启用。

### K4 — Conversion & Trust
Home / Product / FAQ / Shipping & Returns / Contact。

### K5 — Release Candidate QA
移动、平板、桌面、超宽压力测试；Gutenberg validity；Cart/Checkout；邮件；性能；SEO 基础；Secret 扫描。

### K6 — VPS Deployment
本地 RC PASS 后再做。

### K7 — Production Canary
低金额真实订单 → 支付 → 订单状态 → 邮件 → 退款/取消 → 上线。

## 5. UI Decision Rule

在 Executor 开始 K1 前，先由：

```text
Owner
+ Reviewer
+ Growth / Acquisition framework
```

共同确认：
- 页面信息层级；
- 首屏承诺；
- 核心 Offer；
- CTA；
- Trust 内容；
- 哪些模板区块 KEEP / ADAPT / DROP。

Executor 不自行决定营销信息架构。

## 6. UI Fidelity Rule

clone-ui 可以作为“局部高保真验证工具”，但不能成为网站架构控制器。

使用边界：
- 用于已经确认的页面/区块视觉；
- 必须同时做 Gutenberg validity、responsive、WooCommerce behavior 回归；
- 不允许为了视觉 parity 破坏模板原生响应式、Block validity、WooCommerce hooks 或编辑能力；
- Fidelity PASS 不能单独等价于 Project PASS。

最终 UI Gate 至少同时满足：

```text
VISUAL_FIDELITY=PASS
GUTENBERG_VALIDITY=PASS
RESPONSIVE=PASS
WOOCOMMERCE_BEHAVIOR=PASS
OWNER_EDITABILITY=PASS
NO_BUSINESS_TRUTH_FABRICATION=PASS
```

## 7. GitHub Handoff Workflow — Candidate

Reviewer：
- 写入 `REVIEWER_HANDOFF.md`
- 必要时写 Reviewer Decision
- 聊天仅返回“可查阅 xxx 文档”

Executor：
- 写 `EXECUTION_EVIDENCE.md`
- 写 `EXECUTOR_HANDOFF.md`
- 必要时提交截图/manifest 的索引，不提交 Secret
- 聊天仅返回“执行完成，可查阅 xxx 文档”

当前先在本项目试运行。连续稳定跑通后，再升级到全局 Governance 管理规范。

## 8. Open Decisions

1. K0 原版 Kadence Single Product UI 是否采用。
2. K1 最终 UI / Offer 信息结构。
3. MVP 必装插件最小集合。
4. Mini Craft 支付架构：WooCommerce direct PayPal vs Shared Payment vs Dujiao handoff。
5. 实物履约第一版是人工发货还是外接仓配。
