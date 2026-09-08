# Shared Payment Hub Architecture

## Goal

Turn Unified Pay into a shared internal payment platform that is deployed once and reused by every current and future product.

## Recommended architecture

```text
Product A / Product B / Extension / App
               │
               │ app_id + sku_id
               ▼
        Unified Pay Public API
               │
       ┌───────┴────────┐
       │                │
 Hosted Checkout    Direct API/SDK
       │                │
       └───────┬────────┘
               ▼
        Checkout Service
               │
        Provider Router
       ┌───────┼────────┐
       ▼       ▼        ▼
    Alipay   PayPal   GMPay
       │       │        │
       └───────┴────────┘
               ▼
      Canonical Payment Ledger
               │
     PAID / REFUND / DISPUTE
               │
       ┌───────┴────────┐
       ▼                ▼
 License/Entitlement   Signed Fulfillment Webhook
```

## Core entities

### App
Represents one product or application.

Examples:
- `gpt-view-plus`
- `relationship-quiz`
- `pet-routine-store`

Recommended fields:
- `app_id`
- display name
- allowed origins
- client type: public / server
- default merchant profile
- status

### SKU
Represents what is being sold.

Examples:
- `pro-lifetime`
- `monthly-pro`
- `report-single`

Recommended fields:
- `sku_id`
- `app_id`
- server-owned amount
- currency
- entitlement / fulfillment config
- refund policy

### Merchant Profile
Separates payment credentials or legal/settlement contexts without deploying a new payment service.

Use a new merchant profile only when needed, for example:
- different legal entity
- different PayPal / Alipay merchant account
- different country or settlement strategy
- strong risk isolation requirement

### Provider Route
Controls which provider can serve a checkout.

Example:

```text
CNY + China → Alipay
USD + overseas → PayPal
Optional crypto → GMPay
```

### Fulfillment
Two standard modes:

#### `license`
Unified Pay directly issues/revokes a generic entitlement.

Best for:
- browser extensions
- desktop software
- one-time digital purchases

#### `webhook`
Unified Pay signs and posts a lifecycle event to the product backend.

Best for:
- SaaS accounts
- credits / quotas
- physical-order side effects
- complex account state

## New-product onboarding flow

```text
1. Register App
2. Register SKU(s)
3. Configure allowed origins
4. Choose merchant profile / provider route
5. Choose license or webhook fulfillment
6. Integrate shared Checkout API or Hosted Checkout
7. Run one low-value E2E
8. Go live
```

No new payment database, webhook framework, provider SDK, refund ledger or reconciliation worker should be created for each product.

## Hosted Checkout recommendation

Long-term, prefer a centralized checkout page:

```text
POST /v1/checkouts
→ checkout_token
→ https://pay.example.com/c/<checkout_token>
```

Benefits:
- product clients do not embed provider-specific UI
- provider routing can change without updating every product
- CSP / origin / security behavior is centralized
- analytics and conversion events are centralized
- adding a provider becomes a payment-hub change instead of N product changes

## Client integration layers

Provide thin clients rather than full payment implementations:

- Browser / Extension JS SDK
- Server SDK
- REST API
- Hosted Checkout URL

A client SDK should only:
- create checkout
- open checkout
- query canonical status
- retrieve entitlement / license where allowed

It must never contain provider secrets.

## One deployment vs multiple deployments

### Default: one shared deployment
Use one Unified Pay deployment for products under the same operational owner.

### Split only when necessary
Create a separate deployment only for hard isolation requirements such as:
- separate company / legal entity
- strict data residency boundary
- regulatory separation
- unrelated operator with separate admin trust boundary
- very high-risk product that should not share blast radius

Different products alone are **not** a reason to create another deployment.

## Evolution path

### V0.18 — current
Config-file-backed App/SKU registration and shared payment core.

### Next recommended iteration
Convert product registration into a small Control Plane / Admin UI:

```text
Create App
→ Add SKU
→ Select provider routing
→ Select fulfillment
→ issue client credential
```

This turns product onboarding from a coding task into a configuration task.

## Success criterion

When a future product needs payment, the answer should be:

> “Add an App and SKU to Unified Pay, then use the shared checkout.”

not:

> “Build another payment project.”
