# Unified Pay System V0.18.0

Reusable payment orchestration infrastructure for browser extensions, websites, Apps, mini-program backends and future products.

## Current capabilities

- server-owned App/SKU pricing;
- provider abstraction: Mock / PayPal REST / GMPay crypto / Alipay gated / WorldFirst gated / WeChat deferred;
- deterministic checkout + idempotency + expiry;
- payment webhook verification boundary + proactive reconciliation;
- PostgreSQL relational store + migrations + row locks;
- durable fulfillment retry/dead-letter;
- License issuance, activation, verification, revocation and customer device self-service;
- partial/full refunds + refund reconciliation + automatic entitlement revocation;
- Admin RBAC, audit, metrics, alerts, backup/restore;
- durable lifecycle event Outbox with HMAC delivery/retry/dead-letter;
- per-app scoped server credentials;
- multi-project / multi-merchant `merchant_profile` routing;
- dispute / chargeback ledger, webhook lifecycle, Admin visibility and metrics;
- provider-statement settlement/reconciliation ledger with durable difference findings;
- provider credential versioning with `active` + `verify_only` rotation and secret-reference resolution;
- Admin `static` / `sso` / `hybrid` authentication boundary with local RBAC;
- local or injected distributed rate-limit adapter with fail-closed backend errors;
- same-origin License Customer Portal without a new account system;
- Outbox terminal-event replay + payload retention while preserving dedupe tombstones;
- SDK structured errors + TypeScript declarations.

## Architecture

```text
Plugin / Website / App / Mini-program backend
                  ↓
            Unified Pay API
                  ↓
       App auth / origin policy
                  ↓
          Checkout + ledgers
                  ↓
       Provider + merchant profile
          ├─ Mock
          ├─ PayPal (Sandbox-ready / Live gated)
          ├─ GMPay / EPUSDT (adapter ready / self-host E2E gated)
          ├─ Alipay (product onboarding in progress)
          ├─ WorldFirst (Global Checkout gated)
          └─ WeChat (deferred)
                  ↓
             PAID ledger
                  ↓
             Fulfillment
                  ↓
      License / downstream service
                  ↓
        Durable lifecycle Outbox
                  ↓
        App event webhooks

Provider statements → canonical rows → settlement findings
Provider disputes   → dispute ledger  → operational review
```

## Start locally

```powershell
Copy-Item .env.example .env
npm install
npm test
npm start
```

Default local URL: `http://127.0.0.1:8787`.

## Important

PayPal has a real REST adapter but Live remains gated until Sandbox buyer approval/capture/refund is completed. GMPay/EPUSDT has a native HMAC-SHA256 adapter but remains gated until a self-hosted gateway, wallet/API key and low-value on-chain E2E exist. Alipay remains at Computer Website Payment product onboarding; WorldFirst Global Checkout and WeChat remain gated/deferred. Mock/canonical tests are not real-money evidence.

Read **`00_HANDOFF.md` first** when continuing this project in another conversation. It is the only handoff document.

Detailed docs are under `docs/`, especially `ARCHITECTURE.md`, `SECURITY.md`, `PAYPAL.md`, `GMPAY.md`, `PROVIDER_CREDENTIALS.md`, `ADMIN_SSO.md`, `DISTRIBUTED_RATE_LIMIT.md`, `CUSTOMER_PORTAL.md`, `OUTBOX.md`, `DISPUTES.md`, `SETTLEMENT_RECONCILIATION.md`, and `ROADMAP.md`.


## V0.18 provider strategy

Domestic priority remains **Alipay**. PayPal is now the current overseas buyer-checkout implementation and begins in Sandbox. The normal WorldFirst account is retained for collection/settlement/FX; buyer-facing WorldFirst Global Checkout remains gated unless Enterprise onboarding explicitly approves it. GMPay/EPUSDT is added as an optional self-hosted crypto rail and is not the default domestic payment method. WeChat Pay remains deferred. See `docs/PROVIDER_STRATEGY.md`, `docs/PAYPAL.md`, and `docs/GMPAY.md`.

## V0.15.1 production pre-provider hardening

Production now fails fast on an enabled Mock provider, insecure browser origins, HTTP product-fulfillment webhooks, or weak/missing fulfillment HMAC secrets. PostgreSQL `pg` is a required runtime dependency because production requires the PostgreSQL store.
