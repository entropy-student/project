# Reviewer Decision — G3S2 PASS for read-only Stripe merchant eligibility and Test planning; Owner entity unknown

> Date: 2026-10-16
> Governance: vps-project-governance v0.2.7 ACTIVE_PROVISIONAL
> Original Gate: `docs/G3S2_STRIPE_ACCOUNT_ELIGIBILITY_AND_TEST_READINESS_READONLY_2026-10-15.md`
> Public-research Evidence: `docs/evidence/g3s2/G3S2_OFFICIAL_STRIPE_MERCHANT_ELIGIBILITY_AND_TEST_READINESS_READONLY_2026-10-16.md`
> Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S1SVE_AND_G3S1SV_PASS_INACTIVE_STRIPE_STAGING_2026-10-15.md`

## Decision

```text
GATE_ID=G3S2_STRIPE_ACCOUNT_ELIGIBILITY_AND_TEST_READINESS_READONLY
REVIEWER_DECISION=PASS_READONLY_POLICY_RESEARCH_AND_ACTIONABLE_READINESS_PLAN
READINESS_TO_ACTIVATE_OR_CONNECT_STRIPE=NO
STRIPE_COUNTRY_MERCHANT_AVAILABILITY_HK=YES_QUALIFYING_BUSINESS_ONLY
STRIPE_COUNTRY_MERCHANT_AVAILABILITY_CN_MAINLAND=NO_STANDARD_STRIPE_PAYMENTS
STRIPE_HK_NON_HKID_INDIVIDUAL=NOT_ELIGIBLE_INDIVIDUAL_PER_OFFICIAL_STRIPE_RULE
STRIPE_HK_SOLE_PROPRIETOR_BRN=CONDITIONAL_REAL_BRN_AND_STRIPE_KYB
WISE_HK_USD_SETTLEMENT=NOT_SAFE_TO_ASSUME_HK_STRIPE_USD_FEATURE_EXCLUDES_TRANSFERWISE
WISE_HK_HKD_SETTLEMENT=UNKNOWN_ACCOUNT_SPECIFIC
OWNER_REAL_COUNTRY_ENTITY_IDENTITY_ELIGIBILITY=UNKNOWN
STRIPE_ACCOUNT_EXISTENCE=UNKNOWN_NOT_OWNER_RECONFIRMED
WOOCOMMERCE_STRIPE=OFFICIAL_11_1_0_INSTALLED_INACTIVE_PARENT_PASS
LOCAL_WEBHOOK_PRODUCTION_PUBLIC_HTTPS=NOT_CONFIGURED
TEST_GATE_READY=NO_SEPARATE_GATE_AND_OWNER_AUTHORIZATION_REQUIRED
TEMP_ZIP_PACKAGE_CLEANUP=DEFERRED
HOST_ACCOUNT_PROVIDER_OR_PAYMENT_MUTATION=0
NEW_CODEX_EXECUTOR_PROMPT=NONE_OWNER_REQUESTED
PR64=OPEN_UNMERGED
NEXT_STATUS=PAUSED_BEFORE_OWNER_MERCHANT_ELIGIBILITY_DECISION
```

## Direct Reviewer review

Reviewer read current GitHub project Gate/Handoff/Parent PASS and the publicly available official Stripe/Woo/Wise sources listed individually in the G3S2 Evidence. All verified assertions are **requirements/policy facts**, not a claim to have inspected or validated the Owner's Stripe/Wise/identity/merchant status. No authentication, enrollment, identity documents or bank details were requested. No source snippets were promoted into account facts.

**Key eligibility determination:** Hong Kong is a Stripe Payments supported **business jurisdiction**; mainland China is not in the standard merchant country list. A Stripe Hong Kong individual-account merchant must meet Stripe's HKID rule; a non-HKID representative with a real HK Business Registration Number may be assessed under the appropriate Sole Proprietorship structure subject to identity/business verification. A Wise HK bank account alone is not an eligible merchant entity. Separately, Stripe HK USD payout feature expressly excludes TransferWise/virtual/neobank USD bank accounts; Wise's generic payout-receiving article cannot override this jurisdiction-specific exception. Exact Wise HKD bank detail treatment is UNKNOWN, not silently accepted.

**Technical determination:** The already-installed inactive WooCommerce Stripe 11.1.0 extension meets this Gate's code-side prerequisite only. Real sandbox order testing requires a legitimate Owner-managed account, separately configured Test mode, authentic signed webhooks and a reviewed HTTPS delivery/reachability path; Owner Windows loopback `127.0.0.1:8189` is not itself a public webhook URL. A future controlled test must also cover payment/order/fulfillment/refund/entitlement idempotence and record a fresh rollback point. No activation, provider connection, public tunnel, real payment, refund or PayPal deletion authorized by this decision.

## Explicit blocker and stop

The Owner has **not yet supplied a confirmed legitimate merchant country/legal structure or current verified Stripe merchant account state in this round**; no specific Owner eligibility PASS/FAIL can be inferred. Do not progress to setting up accounts, test checkout, key handling or a new execution prompt in absence of Owner plan and separate authorization. This is a **PASS for read-only research and planning**, while the actual merchant decision remains pending.

No new project Gate is opened automatically: next Owner decision chooses legitimate business jurisdiction/entity and confirms Stripe account status; only then Reviewer scopes a separate eligible Test-only Gate and HTTPS strategy. Preserved previous Stripe inactive install PASS and PR #64 Open state remain unchanged. Installer ZIP cleanup deferred by policy and not relevant to merchant eligibility.

## User-facing facts

- Main barrier: legitimate Stripe merchant registration and country/entity/identity verification, not local plugin installation.
- For HK-based merchants, HKD and USD payout bank compatibility must be verified separately. Do not assume Wise HK USD.
- The Owner can pursue alternative arrangements without this Gate initiating them.
- No prompt is produced as Owner explicitly requested none.

```text
NEXT_REVIEWER=CHECK_OWNER_CONFIRMED_COUNTRY_ENTITY_STRIPE_ACCOUNT_STATUS_WHEN_PROVIDED
OWNER_ACTION_NOW=NONE_FOR_THIS_READONLY_REPORT
REVIEWER_STOP=YES
```
