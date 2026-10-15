# Owner Decision — Retire PayPal only after verified Stripe end-to-end PASS

> Date: 2026-10-15
> Provenance: OWNER_REPORTED in Reviewer chat
> Project: Birthday Magazine Studio
> Prior Owner decision: `OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`
> Current Gate unaffected: `G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING`

## Conditional Owner authorization

Owner says: "stripe通过后就把PayPal删掉吧，提示词已发送。" The existing Stripe inactive-staging instruction has already been sent to Codex.

```text
TARGET_PRIMARY_AND_EVENTUAL_ONLY_PAYMENT_PROVIDER=STRIPE
OWNER_CONDITIONAL_PAYPAL_RETIREMENT_APPROVAL=YES_AFTER_VERIFIED_STRIPE_END_TO_END_PASS
CONDITION_AT_THIS_TIME=NOT_MET
CURRENT_GATE=G3S1S_POST_RECOVERY_OFFICIAL_STRIPE_GATEWAY_INACTIVE_STAGING_UNCHANGED
IMMEDIATE_PAYPAL_DISABLE_UNINSTALL_OR_PROVIDER_MUTATION=NO
PAYPAL_RETIREMENT_EXECUTION=DEFERRED_TO_SEPARATE_POST_STRIPE_REVIEWED_GATE
HISTORICAL_PAYPAL_EVIDENCE_ORDERS_REFUNDS_ACCOUNTING=RETAIN
WOOCOMMERCE_CANONICAL_ORDER_PAYMENT_RECORDS=RETAIN
STRIPE_ACCOUNT_TEST_LIVE_ENABLEMENT_PAYMENT_OR_REFUND=NOT_AUTHORIZED_BY_THIS_DECISION
G3C_CURRENT_PPCP_PLUGIN=NOT_PRESENT_AT_LAST_EXECUTOR_READBACK
PR64_MERGE=NOT_AUTHORIZED
```

This **updates/supersedes the former "considering/not authorized" Owner intention** only regarding the *future conditional PayPal retirement decision*. There is now **advance Owner agreement in principle** to decommission PayPal once Stripe has conclusively replaced its intended business functions. It does NOT immediately authorize an irreversible deletion, nor satisfy the conditions without fresh real evidence.

## What "Stripe PASS" must mean

**Installing the official Stripe plugin, even if installed/active in a local lab, is NOT Stripe PASS.** Before any PayPal removal:

1. Legitimate real merchant eligibility, legal entity/country/KYB and payout destination are independently confirmed under authorized Owner checkpoints. Do not assume a Wise account grants Stripe eligibility.
2. Stripe WooCommerce Test-mode payment, authentic signed webhook, exact merchant/environment/order/amount/currency correlation, durable paid state, replay/idempotency guards and failures/cancel paths have passed a separate Reviewer-accepted end-to-end Gate.
3. WooCommerce Stripe refund and corresponding entitlement revocation are independently tested and accepted; historical PayPal-specific G3B PASS cannot substitute.
4. For real cutover, actual Stripe live acceptance/settlement/payout readiness and operating refund/dispute/reconciliation/record retention obligations are demonstrated through appropriately Owner-authorized limited steps, before retiring a currently live PayPal payment option. No implied real-money authorization here.
5. Reviewer performs a **fresh same-target payment-inventory and dependency scan** (current project/runtime plus production if applicable), a project-scoped backup and feasible rollback, then opens a narrow PayPal retirement Gate. Confirm whether PayPal is actually installed/active anywhere in the relevant WordPress environment and whether pending orders/refunds/chargebacks/subscriptions or customers depend on it. Unknowns block deletion.

## How to retire safely

- Prefer an explicit staged disablement once Stripe has become the working primary, verify Stripe checkout continues and no unexpected existing order/refund dependency remains, then remove only the precisely identified PayPal plugin/gateway artifacts and provider-specific inactive configuration where safe, retaining required historical transaction/audit/recovery records. Deletion is **never** a blanket data reset.
- Preserve WooCommerce, WordPress, buyer data, completed orders, historical PayPal Sandbox evidence and applicable accounting/refund records; no global Docker/project cleanup.
- Existing G3C plugin readback already says **official PPCP is absent and legacy Woo PayPal disabled**. If this is still true after new source readback, mark that **specific G3C PayPal plugin uninstall as NOT_APPLICABLE**; do not install it merely to uninstall, and do not delete historical G3B evidence.
- If another target (e.g. future production) still has active PayPal, that exact live target needs its own reviewed, backup-safe cutover/retirement Gate. No cross-environment inference.
- **Owner will not need to restate the provider preference.** Any new consequence not covered by the declared conditional intent (such as destroying provider/account transaction history, irreversible deletion of unique data, live production account closure, or new actual charges) still needs a separately scoped explicit Owner action.

## Current execution instruction

The Codex G3S1S prompt was already sent. **Do not interrupt, expand or alter this current Gate**. Its `NO_PAYPAL_SETTINGS_OR_PLUGIN_MUTATION` restriction is retained. The next Reviewer should apply this Owner decision only when constructing future Stripe cutover/PayPal retirement Gates after the requisite PASS results.

No further Owner action now.
