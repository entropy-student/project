# Mini Craft Night Kit — Payment Architecture Decision

Decision date: 2026-09-18  
Status: **OWNER APPROVED — PROJECT-SPECIFIC ARCHITECTURE CHANGE**

## 1. Context

全局历史默认准则曾规定：

> 简单实物商品也优先接 Dujiao，支付渠道统一复用 Shared Payment Layer。

Mini Craft 当前已改为：

```text
WordPress
+ Kadence
+ WooCommerce
```

WooCommerce 已经负责：
- product；
- cart；
- checkout；
- order；
- customer-facing commerce state。

如果再把 Dujiao 作为第二套商品/订单系统放在 WooCommerce 后面，会形成双订单中心和额外同步复杂度。

## 2. MVP Decision

Mini Craft MVP 默认采用：

```text
Kadence / WordPress
        ↓
WooCommerce
Product / Cart / Checkout / Order
        ↓
WooCommerce PayPal Payments
        ↓
PayPal
```

原则：

- WooCommerce 是 Mini Craft MVP 的 canonical commerce/order system；
- 不自行实现 PayPal API；
- 不把 Dujiao 作为第二套 canonical order system；
- 正式 PayPal 授权、Secret、生产开启仍为 Owner-only。

## 3. Fulfillment Semantics

Mini Craft 是实物商品。

因此：

```text
payment succeeded
≠
shipped
```

MVP 流程：

```text
Order created
→ PayPal success
→ WooCommerce order = paid / processing
→ 人工或后续履约系统发货
→ WooCommerce shipment / completion state
```

不得把数字产品的 automatic fulfillment 语义直接套到实物商品。

## 4. Why Dujiao Is Not the MVP Path

不采用：

```text
WooCommerce
→ Dujiao
→ PayPal
```

主要原因：

- WooCommerce 与 Dujiao 会同时拥有订单状态；
- 需要同步商品、金额、订单、退款和异常状态；
- 增加 webhook / idempotency / reconciliation 复杂度；
- 与本项目“减少自建、尽快上线”的新目标冲突。

Dujiao 继续适用于：
- 虚拟产品；
- 自动发卡；
- License；
- 报告；
- 下载权益；
- 其他已有 Dujiao 场景。

## 5. Long-term Option

如果 Mini Craft 被验证，并且“所有业务共享同一支付层”的收益开始超过集成成本，可以升级为：

```text
WooCommerce
        ↓
Thin WooCommerce Payment Gateway Adapter
        ↓
Shared Payment Layer
        ↓
PayPal / Alipay / other providers
```

此时：

- WooCommerce 仍为订单系统；
- Shared Payment Layer 只负责 payment/refund/provider state；
- 不复制 WooCommerce 商品/订单到 Dujiao；
- Provider Secret 仍集中管理。

## 6. Migration Gate

从 WooCommerce direct PayPal 切换到 Shared Payment Layer 前，必须单独评估：

- 已有真实订单量；
- Provider 数量；
- 退款；
- reconciliation；
- 支付维护成本；
- adapter 开发成本；
- outage / rollback；
- canonical order ownership。

没有真实收益证据，不迁移。

## 7. Current Payment Gate

K0 不做支付。

Payment 决策实际执行在 K3：

1. WooCommerce commerce loop 先跑通；
2. PayPal Sandbox；
3. webhook / order state；
4. refund；
5. Owner 批准一个低金额 production canary；
6. 再开放正式支付。
