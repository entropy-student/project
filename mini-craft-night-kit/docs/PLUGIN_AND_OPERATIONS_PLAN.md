# Mini Craft Night Kit — Plugin & Operations Plan

Last reviewed: 2026-09-18  
Status: **OWNER_APPROVED / MINIMAL-PLUGIN POLICY**

## 1. Principle

插件不是越多越好。

每一个插件安装前必须回答：

> 如果没有它，当前 MVP 哪项功能无法实现？

不能回答则不安装。

## 2. K0 Required

只允许 Starter Template 跑通所需组件：

- Kadence Theme
- Kadence Blocks
- Starter Templates / Kadence 导入所需免费组件
- WooCommerce（模板/电商基线需要时）

K0 不安装运营类插件。

## 3. K2 / K3 Required

### Commerce
- WooCommerce

### Payment
MVP 默认候选：
- WooCommerce PayPal Payments（官方）

不要自己实现 PayPal API。

## 4. Pre-launch Minimum Operations Stack

只在功能确有需要时加入：

### Transactional Email
目标：订单确认、状态更新、退款等邮件可靠送达。

要求：
- 使用 SMTP / transactional provider；
- 不依赖默认 PHP mail 作为正式生产方案。

具体插件在 K5 前确定，优先免费、轻量、可维护方案。

### SEO
目标：
- title / meta；
- sitemap；
- canonical；
- 基础 schema。

只选一个 SEO 插件，禁止并行安装多个 SEO 套件。

### Analytics
上线后至少需要：
- GA4；
- Google Search Console；
- 基础 conversion event。

投放广告后再加 Meta / Google Ads 对应追踪。

### Backup / Migration
VPS 正式上线时优先使用：
- 项目级数据库备份；
- uploads；
- theme / plugin manifest；
- 可恢复流程。

不因为“有备份插件”就替代 Shared VPS 的正式备份与恢复规范。

## 5. Deferred Until Evidence Exists

以下全部延后：

- Reviews；
- abandoned cart；
- CRM；
- newsletter automation；
- affiliate；
- loyalty；
- advanced coupons；
- upsell / cross-sell；
- advanced analytics；
- heatmap；
- A/B testing；
- complex shipping SaaS；
- ERP / OMS / WMS。

出现真实需求或真实流量后再开 Gate。

## 6. Plugin Budget

MVP 目标：

> 除 Kadence / WooCommerce 基础组件外，额外运营插件尽量控制在 3–5 个。

任何新增插件必须记录：
- 目的；
- 替代方案；
- 数据访问范围；
- 性能影响；
- 是否付费；
- 删除/回滚路径。

## 7. Operations Sequence

```text
先有可卖网站
→ 再有真实支付
→ 再有真实订单
→ 再根据真实运营问题增加插件
```

不要反过来先搭“未来运营平台”。
