# Mini Craft Night Kit — PROJECT PLAN & ROADMAP

Last updated: 2026-09-18  
Status: **ACTIVE — K0 NEXT**

## 1. Final Goal

尽快上线一个可真实销售 Mini Craft Night Kit 的英文独立站，并避免重复建设成熟电商能力。

正式 MVP 技术路线：

```text
WordPress
→ Kadence Single Product Starter Template
→ WooCommerce
→ Mini Craft Brand Adaptation
→ WooCommerce PayPal Payments
→ Conversion / Trust
→ Multi-device QA
→ VPS
→ Production Canary
→ Launch
```

## 2. Confirmed Decisions

Owner 已确认：

- 停止旧 01–19 手工高保真扩张路线；
- 旧项目保留，不删除；
- Kadence Single Product 作为新 MVP 模板候选；
- K0 先完整导入原版，再决定品牌改造；
- K1 之前必须由 Owner + Reviewer + Growth/Acquisition Framework 先确认 UI / Offer / CTA / Trust；
- clone-ui 只作为高保真辅助与视觉验收工具，不作为 WordPress 架构控制器；
- UI PASS 必须同时满足视觉、Gutenberg、响应式、WooCommerce、可编辑性和业务真实性；
- 插件遵循 minimal-plugin policy；
- Mini Craft MVP 订单系统以 WooCommerce 为 canonical；
- MVP 支付优先 WooCommerce PayPal Payments，不把 Dujiao 叠成第二套订单系统；
- 长期若统一支付收益明确，再考虑 WooCommerce → Shared Payment Layer Adapter；
- Reviewer / Executor 的长期结果写入 GitHub 项目目录，聊天只做短通知；
- 上述 GitHub handoff 连续稳定跑通至少 3 个 Gate 后，再提议写入全局 Governance。

## 3. Current Position

```text
Product / positioning        PASS
Old visual exploration 01–05 PASS / archived as reference
Kadence route decision        PASS
UI/Growth governance          PASS
Fidelity governance           PASS
Plugin policy                 PASS
Payment architecture          PASS
GitHub handoff protocol       TRIAL APPROVED

CURRENT:
K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC
```

## 4. Execution Gates

### K0 — Kadence Single Product Local PoC
目标：完整导入原版，验证真实 UI 和 WooCommerce 基线。

预计：**2–4 小时**

Owner checkpoint：
- 看 Home / Product / Cart / Checkout；
- 决定模板“用 / 不用”。

### K1 — UI / Growth Decision + Brand Adaptation
先由 Reviewer + Growth/Acquisition Framework 定义：
- KEEP / ADAPT / DROP；
- Hero；
- Offer hierarchy；
- CTA；
- Trust；
- 必要产品事实；
- 视觉边界。

随后 Executor 一次性进行 Mini Craft 品牌替换。

预计：**4–8 小时**

### K2 — WooCommerce Commerce Loop
跑通：

```text
Product
→ Cart
→ Checkout
→ Order
→ Confirmation
```

配置商品、SKU、库存策略、运费、订单状态。

预计：**3–6 小时**

### K3 — PayPal
默认路线：

```text
WooCommerce
→ WooCommerce PayPal Payments
→ PayPal
```

流程：
- Sandbox；
- webhook / order state；
- refund；
- production canary。

预计开发：**3–6 小时**

注：PayPal 账号审核、身份验证或外部审批等待时间不计入开发工时。

### K4 — Conversion & Trust
只补影响购买的内容：
- Home；
- Product；
- FAQ；
- Shipping & Returns；
- Contact；
- Trust copy。

预计：**2–4 小时**

### K5 — Release Candidate QA
验证：
- Gutenberg validity；
- Mobile / Tablet / Desktop / ultra-wide；
- WooCommerce；
- 图片；
- 邮件；
- SEO 基础；
- 性能；
- Secret hygiene。

预计：**3–5 小时**

### K6 — VPS Deployment
本地 RC PASS 后：
- Shared VPS project namespace；
- WordPress / DB / uploads；
- domain / HTTPS；
- backup / restore baseline；
- production smoke test。

预计：**3–5 小时**

### K7 — Production Canary & Launch
一笔低金额真实订单：

```text
order
→ payment
→ webhook
→ WooCommerce state
→ email
→ refund / cancel validation
→ launch
```

预计：**1–3 小时**

## 5. Total Estimate

在：
- 模板可正常导入；
- Mini Craft 文案/图片可直接使用；
- WooCommerce 无特殊业务定制；
- PayPal 账号可正常进入 Sandbox / Production；
- VPS/域名无额外阻塞；

的情况下：

> **约 3–5 个集中工作日，可完成从 K0 到可上线 MVP。**

其中：
- **1–2 天**：可看到完整 Mini Craft 品牌化电商站；
- **2–3 天**：可跑通本地 WooCommerce + PayPal Sandbox；
- **3–5 天**：完成 QA、VPS、真实 canary 并具备上线条件。

外部账号审核 / PayPal KYC / provider review 等等待不计入上述周期。

## 6. Current Next Action

唯一下一步：

`K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`

Executor 应：
1. 新建独立本地 WordPress PoC；
2. 不修改旧 mini-craft-night-kit；
3. 导入 Kadence Single Product；
4. 验证 WooCommerce；
5. 验证 Gutenberg；
6. 验证 mobile / tablet / desktop；
7. 将结果写入：
   - `EXECUTION_EVIDENCE.md`
   - `EXECUTOR_HANDOFF.md`
8. 停在 Reviewer。

Owner 当前无需进行其他操作。
