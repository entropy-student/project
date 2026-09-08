<div align="center">

# Unified Pay System · 统一支付中台

**一次部署，多产品复用。**

[English](./README_EN.md) · [项目记录](./PROJECT_RECORD.md) · [共享支付架构](./docs/SHARED_PAYMENT_HUB.md)

</div>

---

## 这是什么

Unified Pay System 是一个可复用的支付与权益编排层。它不是某一个插件或网站专属的支付代码，而是所有产品共用的内部支付基础设施。

```text
GPT View+ ───────┐
未来网站 A ──────┤
未来 App B ──────┤
其他插件 / 服务 ─┤
                 ↓
          Unified Pay Hub
                 ↓
     Provider Routing / Checkout
      ├─ Alipay
      ├─ PayPal
      ├─ GMPay / USDT
      └─ future providers
                 ↓
       PAID / REFUND / DISPUTE
                 ↓
  License / Entitlement / Webhook
```

## 核心原则

- **支付系统只部署一次。**
- 每个新产品只登记 `app_id`、SKU、价格、允许来源、履约方式。
- 价格由服务端掌握，客户端不能自行指定真实成交金额。
- Provider Secret 只保存在支付中台的 Secret Store 中。
- 简单数字权益可直接由统一 License/Entitlement 层履约。
- 复杂业务通过签名 Fulfillment Webhook 通知对应产品后端。
- 支付、退款、争议、对账与权益撤销集中记录。

## 新产品如何接入

理想情况下，新产品只需要完成四件事：

1. 在 Unified Pay 中登记一个 App。
2. 登记 SKU / 价格 / 币种。
3. 选择履约模式：`license` 或 `webhook`。
4. 产品端调用统一 Checkout API / Hosted Checkout。

不再重复搭建：PayPal SDK、GMPay 验签、退款账本、数据库、Webhook 重试、License 系统等。

## 当前能力（V0.18）

- App / SKU 服务端定价
- Checkout / 幂等 / 过期
- PayPal REST Adapter
- GMPay HMAC-SHA256 Adapter
- Alipay 接入骨架与产品审批门禁
- PostgreSQL 状态与账本
- Webhook 验证与主动对账
- License / Entitlement
- Partial / Full Refund Ledger
- Dispute / Chargeback Ledger
- Outbox / Retry / Dead-letter
- Merchant Profile / Provider Credential Rotation
- Background Worker

## 当前生产路线

```text
GMPay Edge ✅
TRON / USDT ✅
Supabase PostgreSQL ✅
Railway Service ✅ 已创建
Railway Build ⏳ 排错中
公网域名 ⏳
GMPay Webhook ⏳
真实小额 E2E ⏳
```

## 目录

```text
unified-pay-system/
├── README.md
├── README_EN.md
├── CHANGELOG.md
├── PROJECT_RECORD.md
├── Dockerfile
├── .dockerignore
├── BUNDLE_SHA256.txt
├── config/                   # 非敏感生产配置
├── bundle/                   # 经校验的 V0.18 运行源码包分片
├── railway/                  # Railway 部署说明
├── docs/
│   └── SHARED_PAYMENT_HUB.md
└── _archive/                 # 历史部署中间产物，不作为当前入口
```

## 安全

仓库中不得出现：

- GMPay Secret
- PayPal Client Secret
- Alipay 应用私钥
- 数据库密码 / 完整含密码 DATABASE_URL
- 钱包私钥 / 助记词
- Admin Token / License Encryption Key

这些信息必须只存在于 Railway / Secret Manager 等运行环境中。

## 当前入口

生产部署以本目录的 `Dockerfile + bundle/ + config/` 为唯一当前入口。`_archive/` 仅用于保留历史部署中间产物。
