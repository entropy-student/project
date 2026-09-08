<div align="center">

# Unified Pay System

**Deploy once, reuse across products.**

[中文](./README.md) · [Project Record](./PROJECT_RECORD.md) · [Shared Payment Architecture](./docs/SHARED_PAYMENT_HUB.md)

</div>

---

## What it is

Unified Pay System is a reusable payment and entitlement orchestration layer. It is not payment code owned by one extension or one website; it is shared internal infrastructure for many products.

```text
GPT View+ ───────┐
Future Website A ┤
Future App B ────┤
Other Products ──┤
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

## Core principles

- **Deploy the payment platform once.**
- New products register an `app_id`, SKUs, prices, allowed origins and fulfillment behavior.
- Prices are server-owned; clients cannot submit arbitrary payable amounts.
- Provider secrets live only in the payment hub's secret store.
- Simple digital entitlements can be fulfilled by the shared License/Entitlement layer.
- Complex products receive signed fulfillment webhooks.
- Payments, refunds, disputes, reconciliation and entitlement revocation are centralized.

## Adding a new product

A new product should normally require only:

1. Register an App.
2. Register SKU / price / currency.
3. Choose fulfillment mode: `license` or `webhook`.
4. Call the shared Checkout API / Hosted Checkout.

It should not require rebuilding PayPal integration, GMPay signing, refund ledgers, payment databases, webhook retry logic or licensing infrastructure.

## Current V0.18 capabilities

- App / SKU server-owned pricing
- Checkout / idempotency / expiry
- PayPal REST adapter
- GMPay HMAC-SHA256 adapter
- Alipay integration scaffold with onboarding gates
- PostgreSQL ledgers
- Webhook verification and proactive reconciliation
- License / Entitlement
- Partial / full refund ledger
- Dispute / chargeback ledger
- Outbox / retry / dead-letter
- Merchant profiles / credential rotation
- Background worker

## Current production path

```text
GMPay Edge ✅
TRON / USDT ✅
Supabase PostgreSQL ✅
Railway Service ✅ created
Railway Build ⏳ troubleshooting
Public domain ⏳
GMPay Webhook ⏳
Low-value real E2E ⏳
```

## Directory layout

```text
unified-pay-system/
├── README.md
├── README_EN.md
├── CHANGELOG.md
├── PROJECT_RECORD.md
├── Dockerfile
├── .dockerignore
├── BUNDLE_SHA256.txt
├── config/
├── bundle/
├── railway/
├── docs/
│   └── SHARED_PAYMENT_HUB.md
└── _archive/
```

## Security

Never commit provider secrets, database passwords, wallet private keys, Alipay private keys, admin tokens or license encryption keys. Runtime secrets belong only in Railway / a secret manager.

## Active deployment entrypoint

The active production entrypoint is `Dockerfile + bundle/ + config/` in this directory. `_archive/` contains historical deployment intermediates only.
