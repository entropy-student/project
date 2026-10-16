# Owner Authorization — G3S4 Stripe TEST-only checkout and refund

> Date: 2026-10-16
> Authority source: Owner's explicit reply in the current Reviewer conversation: **"授权通过"**
> Previous explicit question: "是否授权进入 G3S4，仅连接 Stripe 测试环境并执行模拟支付、测试退款？正式收款不会启用，也不会使用真实资金。"
> Provenance: OWNER_REPORTED authorization, **not** Stripe account/provider or Windows host readback
> Scope: `docs/G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_2026-10-16.md` only
> Parent Reviewer PASS: `docs/REVIEWER_DECISION_G3S3R_PASS_LOCAL_RUNTIME_RECOVERY_2026-10-16.md`
> One round; expires at G3S4 Reviewer stop/RETURN/PASS. No reuse for later Gates.

## Authorized bounded scope

The Owner approves **only the test mode** for the already-defined G3S4 Gate. Executor may:
1. Inspect the existing local Windows Docker G3C source/runtime and preserve dirty/untracked files; establish and validate a **new protected consistent recoverable** DB + WordPress/uploads + relevant configuration point before any Stripe connection, checkout or mutation.
2. Have Owner authenticate and consent inside their own Stripe account when needed, **TEST environment only**, and connect/configure the official WooCommerce Stripe gateway in TEST mode, verifying LIVE mode cannot be used and secrets never leave protected storage.
3. Set up a temporary, bounded, authenticated **TEST webhook forwarding path** if the reviewed Gate permits it and compatible with plugin 11.1.0. Confirm source and Test secret coexistence before creating any provider endpoint; no public live production exposure.
4. Run the smallest necessary **synthetic WooCommerce TEST checkout/payment** on virtual Woo product #1113 at USD 39.99, one success path plus controlled negative/cancel/failure and replay/invalid-signature checks, then a corresponding **TEST refund** and entitlement-revocation test. Zero real money, no real buyer photos/answers, and no uncontrolled repeated tests.
5. Save sanitized append-only Evidence within G3S4 project scope and STOP for independent Reviewer acceptance.

```text
GATE_ID=G3S4_STRIPE_TEST_ONLY_PAYMENT_READINESS_AND_CYCLE_20261016
OWNER_AUTHORIZATION=APPROVED_OWNER_EXPLICIT
ENVIRONMENT=STRIPE_TEST_MODE_ONLY
MERCHANT_ACCOUNT_TEST_CONNECTION=AUTHORIZED_CONDITIONALLY_WITH_OWNER_LOGIN_AND_CONSENT
WC_STRIPE_TEST_GATEWAY_CONFIG=AUTHORIZED_CONDITIONALLY_AFTER_SOURCE_AND_RECOVERY_PREFLIGHT
SYNTHETIC_WOO_TEST_CHECKOUT_USD_39_99=AUTHORIZED_BOUNDED
SYNTHETIC_STRIPE_TEST_REFUND=AUTHORIZED_BOUNDED
SIGNED_WEBHOOK_TEST_VALID_INVALID_REPLAY=AUTHORIZED_BOUNDED
TEST_WEBHOOK_FORWARDING=AUTHORIZED_ONLY_IF_EXACT_REVIEWED_GATE_TECHNIQUE_SAFE
PRECONDITIONS=EXACT_TARGET_SOURCE_AND_RUNTIME_VERIFIED;DIRTY_WORKTREE_PRESERVED;FRESH_RECOVERABLE_DB_WP_UPLOADS_BACKUP_VERIFIED;SEPARATE_TEST_LIVE_GUARDS_PASS
LIVE_PAYMENT_LIVE_GATEWAY_LIVE_REFUND_PAYOUT=NOT_AUTHORIZED
REAL_CUSTOMER_OR_PRODUCTION_DATA=NOT_AUTHORIZED
PAYPAL_RETIREMENT=NOT_AUTHORIZED
NETLIFY_OR_PRODUCTION_DEPLOYMENT=NOT_AUTHORIZED
GIT_RESET_CLEAN_STASH_REBASE_PR_MERGE=NOT_AUTHORIZED
WORDPRESS_REINSTALL_OLD_BACKUP_REIMPORT=NOT_AUTHORIZED
SPENDING_OR_HOSTING_PURCHASE=NOT_AUTHORIZED
FINAL_RESULT=STOP_AT_REVIEWER
AUTHORIZATION_EXPIRY=ON_G3S4_ONE_ROUND_STOP
```

## Safeguards and non-promises

This document records consent but does NOT prove current Stripe merchant eligibility, Checkout functionality, payout capability, real payments or completed test orders. If the Owner-authenticated Stripe account cannot safely separate Test and Live, if source/backup/target identity fails, if a gateway webhook secret would be unexpectedly overwritten, or if a provider result is ambiguous, STOP rather than extending authority, repeated charge attempts or altering real settings. Authentication and account approvals remain Owner-only checkpoints; no credentials, sensitive payment or customer identifiers, bank details or ID documents go in GitHub, chat, Evidence or logs.

G3S3R's one-time existing-container-start permission was already exercised and is not renewed by this authorization. Stripe live cutover, any true money transaction/refund, production publication, P1–P12 generation spend, PayPal deletion, and PR #64 merge remain separate Owner decisions.
