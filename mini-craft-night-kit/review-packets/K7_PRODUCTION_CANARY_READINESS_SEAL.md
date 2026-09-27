# K7 Production Canary Readiness Seal

Gate:
K7_PRODUCTION_CANARY_READINESS_SEAL

Read:
- current REVIEWER_HANDOFF.md
- current PROJECT_RECORD.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R4_PASS_K6_DEPLOYMENT_PASS_K7_READINESS.md
- latest accepted K6 Evidence/Handoff
- canonical VPS Governance latest
- payment-integration governance where applicable

## Goal

Prepare one exact real-money production-canary plan without performing any consequential payment/provider action.

Do not redo K6 deployment QA.

## Read-only checks

1. Reconcile the accepted launch path and current Product 223 truth.
2. Determine whether Product 223 is acceptable only for a controlled canary or whether a separate hidden low-value canary SKU must be created later.
3. Seal proposed amount/currency and exact order target.
4. Inspect current public checkout/payment presentation without placing an order.
5. Inspect PPCP settings/state and identify the exact transition from Sandbox to Live without performing it.
6. Determine whether Owner must complete interactive PayPal login/account authorization.
7. Seal buyer-account separation requirement.
8. Seal expected WooCommerce order/payment state transition.
9. Identify transactional-email evidence path without sending mail.
10. Seal refund/cancel procedure and provider/local-state reconciliation.
11. Define no-blind-replay handling for ambiguous payment/callback outcomes.
12. Define exact post-canary safe state; Soft Launch remains blocked.

## Forbidden

No Live enablement/login/account authorization, product write, order creation, payment/auth/capture/refund, email send, DNS/Caddy/VPS mutation, Soft Launch, or Secret output.

## Success

PASS_CANDIDATE_K7_PRODUCTION_CANARY_READINESS_SEAL

Return:
CANARY_TARGET=SEALED
CANARY_AMOUNT_CURRENCY=SEALED
PRODUCT_223_CANARY_CLASSIFICATION=
PAYPAL_LIVE_ENABLEMENT_PATH=SEALED
OWNER_INTERACTIVE_PAYPAL_ACTION_REQUIRED=YES|NO
BUYER_ACCOUNT_SEPARATION=SEALED
EXPECTED_ORDER_STATE=SEALED
EMAIL_VALIDATION_PATH=SEALED
REFUND_CANCEL_VALIDATION_PATH=SEALED
NO_BLIND_REPLAY_POLICY=SEALED
SOFT_LAUNCH_AUTHORIZED=NO
PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
