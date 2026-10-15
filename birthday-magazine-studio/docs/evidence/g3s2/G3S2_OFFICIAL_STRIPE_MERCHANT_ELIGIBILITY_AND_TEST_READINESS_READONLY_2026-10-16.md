# G3S2 — Official Stripe merchant eligibility and WooCommerce Test readiness research

> Date: 2026-10-16
> Authorized Gate: `docs/G3S2_STRIPE_ACCOUNT_ELIGIBILITY_AND_TEST_READINESS_READONLY_2026-10-15.md`
> Evidence provenance: Reviewer DIRECT_READBACK of the public official sources linked below; project facts DIRECT_READBACK from GitHub main parent Reviewer decision and PR #64 retained Executor Evidence. **No private Owner account/host access.**
> Status: `PASS_READONLY_POLICY_RESEARCH` — actual merchant eligibility remains `UNKNOWN_OWNER_DECISION_REQUIRED`
> Account/provider/Windows/Stripe extension/payment mutations: **0**

## Answer: merchant account eligibility precedes bank payout choice

1. **Merchant-country eligibility:** Stripe's live global availability list includes **Hong Kong** and does **not** include mainland China among Stripe Payments supported merchant geographies. The regional selector may name "Mainland China" as a locale; **this does not add China to the supported payments merchant list**. Hong Kong country listing establishes availability **for qualifying HK-based businesses**, not automatic eligibility for anyone with an HK bank/Wise account. [S1]
2. **Actual HK identity/entity constraint:** Stripe's Hong Kong support explicitly says a Hong Kong individual-account merchant cannot use a **non-HK identity number** instead of HKID. For someone without HKID but with a genuine Business Registration Number (BRN), Stripe points to the **Sole Proprietorship** account type. For a business representative, other government-issued ID can be acceptable, but this is **not a waiver of legitimate entity registration/business and representative verification**. A genuine qualifying company/entity is subject to its actual Stripe onboarding, KYC/KYB and risk checks. No claim that any particular Owner entity is eligible. [S2][S3]
3. **Account verification:** Stripe verifies business identity (business address and website, product/risk category), business representative/controlling persons, and bank-account ownership as requested. A bank account only serves the settlement step; it does **not** create an eligible Stripe merchant identity or bypass a jurisdiction rule. The Owner's Stripe account status is `UNKNOWN` (the earlier conversation reported not yet registered, not independently re-confirmed). No fake HK address, virtual residency, or account opened for another entity. [S3][S4]
4. **Wise HK payout is not guaranteed:** Wise's generic help describes supported Stripe payouts to **some** Wise account details/currencies, conditioned on account region/currency [S5]. However, **Stripe's specific Singapore/Hong Kong USD payout policy says HK merchants cannot use TransferWise / virtual / neobank USD payout accounts for that payout feature**. It also says HK-based merchants first need successful account activation with a **local HKD payout account**; eligible USD payout bank details can be added **after** activation, subject to country-specific restrictions and fees. Thus `HKD_WISE_COMPATIBILITY=UNVERIFIED` and `HK_USD_TO_WISE_STRIPE_POLICY=NOT_SUPPORTED_IN_DESCRIBED_FEATURE`. Never promise Stripe HK → Wise HK USD acceptance; real payout-account suitability must be checked with Stripe for the actual **HKD/USD account identity/type** after lawful entity approval. [S5][S6][S7]
5. **US fallback:** Stripe's US official requirements distinguish registered US businesses from unregistered sole proprietors and require authentic US business/physical operating information; incorporation/corporate costs, compliance and payout are a separate entrepreneurial decision, not an easy automatic substitute for HK eligibility. This round does **not** recommend creating a US/HK entity just to work around a missing eligibility criterion. [S8]

## WooCommerce readiness: what already exists and what is missing

**Existing accepted local inventory (GitHub parent decision):**
- Owner's physical Windows 11 + Docker Desktop, project `birthday-magazine-g3c`.
- WordPress 7.1.1 / WooCommerce 11.1.2 / PHP 8.3.33. Official `woocommerce-gateway-stripe` v11.1.0 installed with native exit 0, but **inactive** and Stripe gateway IDs absent. Original virtual product #1113 USD 39.99. PayPal disabled; prior G3B PayPal sandbox results are historical.
- Private SQL backup's isolated MariaDB 11.4.7 restore yielded native exit 0, 58/58 tables. Stage accepted for *inactive installation only*; no snapshot-to-live record-level equivalence and **future Test/Live gateway activation requires a selected fresh recovery point**.
- Source package ZIP archives in Windows `%TEMP%` and WP-CLI container `/tmp` are deferred cleanup after a pre-process policy denial. Do not retry or elevate cleanup now.
- No owner-account enrollment, provider connection, live/test payment, webhook signature check, refund or payout proven.

**Official Woo extension requirements, after Owner verifies actual Stripe merchant eligibility** [S9][S10][S11][S12]:
1. Business must be in supported Stripe country and Woo site must have a valid SSL certificate and reachable HTTPS URL for standard integration; current `127.0.0.1:8189` loopback-only lab is **not a publicly reachable HTTPS Stripe webhook endpoint**. No public route or tunnel is authorized in this read-only Gate. Future sandbox chooses reviewed HTTPS staging or another officially supported local test delivery method as its own scoped Gate.
2. WooCommerce's connection normally starts in **Live mode**; **Test mode requires an explicit separate Test account connection and enabling Test mode**. Do not mistake installing a plugin for a working Stripe sandbox. The actual Owner needs a Stripe identity/account and consent. Owner's credentials/API/webhook signing secrets must remain off GitHub/chat/logs.
3. WooCommerce documents test-card transactions and test webhook configuration. Since extension 8.6.1, it can configure webhooks on connecting; review **Test** status separately from **Live** status. Standard webhook endpoint shape: `https://example.com/?wc-api=wc_stripe`. Do not activate Live mode by accident.
4. Later sandbox acceptance is more than card UI: one controlled Woo payment with confirmed Stripe test status, verified signed webhook and matching order/payment amount/currency/merchant, no duplicate fulfillment on webhook retries, then success/failure/3DS/cancellation/refund and paid entitlement revocation. Woo Stripe can initiate gateway refunds; merely setting WooCommerce order status to `Refunded` **does not necessarily send money back**. Test is simulated and never validates actual settlement/payout. [S13][S14][S15]

## Required Owner fact/decision checkpoint (not collected in this Gate)

- **A. Legitimate intended Stripe merchant country/region:** e.g. mainland business only, or genuinely registered HK entity, or another real supported country; **no invented address**.
- **B. Actual entity/ownership type:** qualifying HK business/sole proprietorship with BRN? HKID-based individual? Other legitimate supported registered company? If none, mark `NOT_YET_ELIGIBLE` and stop merchant integration rather than guess.
- **C. Actual Stripe account status:** whether an account exists, is verified/activated, and whether its Payment/Payout flags are enabled. Never ask for passwords, API keys, bank numbers, HKID photos or private registration documents in this repository/chat.
- **D. Settlement choice:** a country-compatible genuine bank account of matching payee name/currency. Verify HKD and (if needed) USD payout eligibility directly in Stripe for that exact bank account; **do not assume Wise HK USD works**.
- **E. Test-stage readiness:** Owner willingness to connect the test account through official Stripe/Woo authorization and separately approve isolated HTTPS test callback/controlled sandbox payments later; **not approved now**.

## Read-only outcome / blockers

```text
G3S2_RESEARCH=PASS
OFFICIAL_SUPPORTED_COUNTRIES=VERIFIED_HK_YES_MAINLAND_CN_NO
STRIPE_MERCHANT_ACCOUNT=UNKNOWN_UNCONFIRMED
OWNER_ENTITY_AND_MERCHANT_COUNTRY=UNKNOWN
OWNER_KYC_KYB=NOT_PROVEN
HK_PERSONAL_WITHOUT_HKID=NOT_ELIGIBLE_AS_INDIVIDUAL_PER_STRIPE
HK_SOLE_PROP=CONDITIONAL_GENUINE_BRN_AND_STRIPE_VERIFICATION
WISE_HK_USD_PAYOUT=DO_NOT_ASSUME_ACCEPTED_STRIPE_HK_POLICY_EXCLUDES_TRANSFERWISE_FOR_USD_FEATURE
HKD_PAYOUT_ACCOUNT_ACCEPTABILITY=UNKNOWN_REQUIRES_ACCOUNT_SPECIFIC_STRIPE_CHECK
CURRENT_WORDPRESS_STRIPE_PLUGIN=11_1_0_INSTALLED_INACTIVE_REVIEWER_ACCEPTED
LOCAL_HTTPS_PUBLIC_WEBHOOK=NOT_PRESENT_NOT_AUTHORIZED
FUTURE_TEST_GATE=BLOCKED_PENDING_OWNER_ELIGIBILITY_AND_SEPARATE_AUTHORIZATION
LIVE_PAYOUT_REFUND=UNVERIFIED
LOCAL_OR_PROVIDER_MUTATIONS=0
TEMP_INSTALLER_CLEANUP=DEFERRED_UNCHANGED
PR64_MERGE=NONE
```

## Official sources (verified via current public read-only web research)

- [S1] Stripe global payments merchant availability: https://stripe.com/global
- [S2] Stripe HK business representative and sole proprietor identity rules: https://support.stripe.com/questions/requirements-for-hong-kong-based-businesses?locale=zh-CN
- [S3] Stripe account verification overview: https://support.stripe.com/questions/what-do-i-need-to-do-to-verify-my-stripe-account/
- [S4] Stripe business identity, website and sector verification: https://support.stripe.com/questions/business-information-requirements-to-use-stripe
- [S5] Wise generic Stripe payout receiving: https://wise.com/help/articles/2977935/how-do-i-receive-money-from-stripe-with-wise
- [S6] Stripe USD payout restrictions specific to HK/SG: https://support.stripe.com/questions/receiving-usd-payouts-for-singapore-and-hong-kong-users
- [S7] Stripe adding an eligible payout bank account: https://support.stripe.com/questions/add-a-bank-account-for-payouts
- [S8] Stripe US entity/registration/physical business requirement: https://support.stripe.com/questions/requirements-for-having-a-us-stripe-account?locale=en-GB
- [S9] Woo official Stripe extension requirements (SSL/HTTPS, supported jurisdiction): https://woocommerce.com/document/stripe/setup-and-configuration/
- [S10] Woo connecting extension to account: https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/
- [S11] Woo official Test mode guide: https://woocommerce.com/document/stripe/customer-experience/testing/
- [S12] Woo official webhook endpoint/setup: https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
- [S13] Woo official Stripe refunds: https://woocommerce.com/document/stripe/admin-experience/refunding-orders/
- [S14] Woo official order statuses versus provider refunds: https://woocommerce.com/document/stripe/admin-experience/order-statuses/
- [S15] Woo ordinary refund vs manual store records: https://woocommerce.com/document/woocommerce-refunds/

## Stop and preservation

This was Reviewer public source research and Github readback only. **No new Codex prompt, Stripe/Wise plugin connection, local execution, project app mutation, real merchant application, payments or PayPal retirement.** Stop after recording Reviewer decision in main. 
