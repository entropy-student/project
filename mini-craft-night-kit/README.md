# Mini Craft Night Kit

## 项目目标

用最少自建工作，把 Mini Craft Night Kit 做成一个可正式销售的英文独立站。

当前 MVP 路线：

```text
WordPress
→ Kadence Theme
→ Kadence Single Product Starter Template
→ WooCommerce
→ Mini Craft 最小品牌化
→ 支付
→ 本地 QA
→ VPS
→ Production Canary
→ 上线
```

## 当前原则

- Starter Template 是结构 Source of Truth。
- WooCommerce 已提供的 Cart / Checkout / Order / Account 不重复开发。
- 旧 01–05 高保真 WordPress 实现保留为视觉、文案、素材参考，不继续扩展 06–19。
- 本地 Release Candidate 通过前不部署 VPS。
- 正式支付、Secret、账号授权、生产开启由 Owner 决策。
- Reviewer 结果写入本项目；Executor 执行结果写入本项目，聊天仅返回可查阅文档。

## 当前 Gate

`K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`

先确认原版 Kadence Single Product 的真实 UI、WooCommerce 基线、Gutenberg 可编辑性和多设备响应式，再决定是否进入品牌替换。

详见：
- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
