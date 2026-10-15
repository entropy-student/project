# G3S2 — Stripe merchant eligibility and Woo test-readiness, read-only planning

> Date: 2026-10-15
> Parent PASS: `docs/REVIEWER_DECISION_G3S1SVE_AND_G3S1SV_PASS_INACTIVE_STRIPE_STAGING_2026-10-15.md`
> Governance: VPS Project Governance v0.2.7
> Target: Birthday Magazine Studio local Windows Docker Desktop G3C, **no active gateway**, no returned Hostinger VPS.

## Gate contract

```text
GATE_ID=G3S2_STRIPE_ACCOUNT_ELIGIBILITY_AND_TEST_READINESS_READONLY
OBJECTIVE=Determine factual merchant Stripe eligibility and the minimum Owner prerequisites to enter a later sandbox Woo checkout/webhook/refund Gate, without touching account, plugin, data or provider.
MAX_ENDPOINT_THIS_ROUND=Reviewer/Executor read-only eligibility/readiness report and explicit Owner action checklist; no host/provider/payment mutation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Official Stripe region/business requirements, official WooCommerce Stripe setup/testing documentation, existing local WordPress/Woo/site and prior accepted G3S1SV stage; no remote VPS/SSH.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_STRIPE_LOGIN_REGISTER_CONNECT_OAUTH_KYC_BANK_LINK; NO_PLUGIN_ACTIVATION_CONFIG_OR_UPGRADE; NO_PUBLIC_WEBHOOK_TUNNEL; NO_PAYMENT_CHECKOUT_REFUND; NO_DB_OR_VOLUME_CHANGE; NO_PAYPAL_REMOVAL; NO_PR64_MERGE; NO_CUSTOMER_DATA_OR_SECRET_DISCLOSURE.
PREFLIGHT=Read parent Reviewer PASS, current Owner Stripe intent, current project Handoff and official Stripe eligibility/support policy; historical owner report said Stripe account not yet registered, treat current actual account as UNKNOWN until confirmed.
REQUIRED_EVIDENCE=MERCHANT_ELIGIBLE_COUNTRY_BUSINESS_ENTITY_AND_SETTLEMENT_REQUIREMENTS_WITH_OFFICIAL_SOURCES; STRIPE_ACCOUNT_STATUS_AS_OWNER_CONFIRMED_OR_UNKNOWN; EXPLAIN_BANK_ACCOUNT_ALONE_DOES_NOT_GRANT_STRIPE_MERCHANT_STATUS; WHAT_OWNER_MUST_DECIDE_OR_DO; TEST_GATE_PRECONDITIONS; PROTECTION_OF_LOCAL_BACKUP_AND_DEFERRED_TEMP_PACKAGES; NO_MUTATIONS.
ACCEPTANCE_CRITERIA=Actionable and accurate read-only plan that distinguishes actual Stripe merchant eligibility/account verification from Woo plugin being installed inactive. No account/identity fabrication or promised payouts. Stop for Owner decision before activation.
ROLLBACK_STATUS_OR_PLAN=No mutation. Existing plugin remains installed inactive and local site unchanged; retained backup and temp ZIP classification unchanged. A later Test Gate must establish an adequately fresh verified current recovery point before changes.
OWNER_ONLY_ACTIONS=At future separate checkpoint Owner chooses legitimate business country/legal entity and performs real Stripe signup/KYC/login and merchant consent if eligible; none performed in this read-only Gate.
```

## Accepted facts / no repetition

- G3S1SV/G3S1SVE Reviewer accepted only **official WooCommerce Stripe 11.1.0 staged inactive** and durable Executor Evidence. No provider account, payment/webhook/refund/payout tested. Original Woo product #1113 virtual USD39.99.
- Original G3S1S DB/WordPress backup isolated restore proof is accepted for **local inactive installation only**; no record-level snapshot-versus-live comparison was preserved. Before enabling a payment gateway or consequential Test/Live action, define and verify a fresh selected recovery point and explicit rollback.
- Existing ZIP installer packages at known local Windows temp/WP-CLI tmp paths remain **deferred cleanup** due execution policy. Do not retry denied command or convert this small cleanup issue into a new installation/backup round. Leave them alone.
- Current G3C PPCP plugin absent at prior inventory and legacy PayPal disabled; historical G3B PayPal Sandbox PASS retained. Owner conditional PayPal removal is **after full Stripe end-to-end PASS and separate safe cutover Gate**, never now.

## Executor / Reviewer relay

Read current parent PASS and latest Owner Stripe decision, then **official** Stripe supported merchant region/legal requirements and WooCommerce Stripe test setup. Report clearly:

1. Can a legitimate **specific country/legal entity** meet Stripe merchant eligibility? If unknown, list exact Owner-provided fields needed **without requesting credentials, private legal documents or address fabrication**.
2. Does Owner actually have an eligible Stripe account? If not confirmed: `UNKNOWN_OR_NOT_REGISTERED_OWNER_LAST_REPORT`, no implied registration.
3. Which real steps must Owner perform before Codex may activate Test-only Stripe, validate signed webhook and run controlled mock/sandbox Woo order/refund/entitlement testing? Also note a future live payout and rollback Gate.
4. No WordPress or local shell operations are required in this Gate. Save sanitized report and stop for Reviewer/Owner. If official policy is not independently confirmed, RETURN rather than assert an unsupported route.

```text
EXECUTOR_RESULT=PASS_CANDIDATE_G3S2_READONLY_PLAN / RETURN_*
OWNER_MERCHANT_ACCOUNT=UNKNOWN_OR_CONFIRMED_ELIGIBLE_STATUS
WORDPRESS_STRIPE_PLUGIN=11_1_0_INACTIVE_ACCEPTED
SITE_PAYMENT_ACTIVITY=NONE
LOCAL_MUTATIONS=0
DEFERRED_TEMP_CLEANUP=UNCHANGED
STOP_AT_REVIEWER=YES
```
