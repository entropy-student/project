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

## 当前 Gate

`K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION`

当前状态：

- K0–K5：PASS；
- K6 VPS Deployment：**PASS**；
- `https://minicraft.spikersun.com`：公网 Sandbox ingress ACTIVE；
- PayPal：Sandbox accepted baseline，**Live=NO**；
- Resend sending domain `minicraft.spikersun.com`：Verified / Sending enabled；
- 官方 Resend WordPress 插件：Active；
- Owner 已在 WordPress 中直接录入 Resend API key，站点 UI 显示 connected；Secret 未进入 GitHub/聊天；
- Canary 商品：已准备草稿，尚未发布；
- Product 223：未修改；
- 邮件真实投递验证：待完成；
- populated Checkout ¥500/运费0/税0/总额¥500 + PayPal method：待验证；
- 真实订单/支付/refund：均为 0；
- Soft Launch：未授权。

当前无需 Owner 操作。Executor 继续同一个 K7 R1 Gate；只有新的 Owner-only 身份/支付/Secret 交互才再次中断 Owner。

## 文档索引

- `REVIEWER_HANDOFF.md` — 当前 Reviewer 项目 Truth / Gate
- `PROJECT_RECORD.md` — 长期项目记录
- `docs/PROJECT_PLAN_AND_ROADMAP.md` — 整体阶段、进度与工期
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md` — UI / 增长 / clone-ui 规则
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md` — 插件与运营能力计划
- `docs/PAYMENT_ARCHITECTURE_DECISION.md` — 支付架构决定
- `PROJECT_STORAGE_MANIFEST.md` — Shared VPS 项目存储/恢复地图
- `docs/GITHUB_HANDOFF_PROTOCOL.md` — Mini Craft 专属交接补充规则

## 当前预计周期

若无外部账号审核阻塞：

> **约 3–5 个集中工作日达到可上线 MVP。**
