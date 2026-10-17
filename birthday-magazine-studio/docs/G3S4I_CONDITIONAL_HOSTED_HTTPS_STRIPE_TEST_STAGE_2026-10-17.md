# G3S4I — conditional isolated HTTPS Woo/Stripe TEST staging setup and bounded Canary

Date: 2026-10-17
Status: `PREPARED_HOLD_OWNER_EXTERNAL_COST_AND_PUBLIC_HOST_AUTHORIZATION`
Parent Reviewer PASS: `docs/REVIEWER_DECISION_G3S4H_READONLY_PASS_BUSINESS_STAGE_CANDIDATE_2026-10-17.md`
Parent PR Evidence: `docs/evidence/g3s4/G3S4H_HTTPS_STAGE_DISCOVERY_2026-10-17.md` at `b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf`
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7; 11A/11B/11C/11D/11E

## Gate contract

```text
GATE_ID=G3S4I_CONDITIONAL_HOSTED_HTTPS_STRIPE_TEST_STAGE_20261017
OBJECTIVE=One externally hosted, isolated synthetic WooCommerce/Stripe TEST payment+Webhook+refund validation using supported HTTPS OAuth with no original local site or Live impact
NEXT_CANDIDATE=WORDPRESS_COM_BUSINESS_MONTHLY_US$40_EX_TAX
EXACT_HOST_ID_AND_URL=UNKNOWN_UNTIL_OWNER_CREATES
HOST_SUBSCRIPTION_AND_PUBLIC_EXPENSE=NOT_AUTHORIZED
PUBLIC_SITE_EXPOSURE=NOT_AUTHORIZED
STRIPE_ACCOUNT_PROVIDER_WRITE_REMOTE=NOT_AUTHORIZED
WRITES_ALLOWED_NOW=NONE;DOCUMENTATION_ONLY
MANDATORY_OWNER_AUTH=FRESH_EXPLICIT_WORDPRESS_COM_BUSINESS_MONTHLY_PRICE_CEILING_AND_PUBLIC_TEST_SITE_APPROVAL
SECOND_OWNER_ACTION=OWNER_ONLY_STRIPE_TEST_LOGIN_OAUTH_CONSENT_IF_SAFE_STAGE_IS_VERIFIED
LOCAL_ADMIN_EXPOSED_PASSWORD_PRIVATE_ROTATION=UNCONFIRMED;NEVER_REUSE
LOCAL_WP_GATEWAY=DISABLED;LOCAL_PLUGIN_ACTIVE;DO_NOT_MUTATE
CROSS_PROJECT_OR_VPS=NO
MANDATORY_REVIEW_STOP=YES
```

## Trigger and budget boundary

This Gate is **prepared only** until the Owner explicitly accepts the exact **new WordPress.com Business monthly** subscription (published US$40/month excluding tax; checkout's true taxes, renewal, refund/cancellation checked by Owner before confirming purchase), new standalone site with provider-assigned HTTPS hostname, narrowly bounded public synthetic checkout/webhook exposure, and TEST-only Stripe account connection/payment/refund. The earlier G3S4M localhost-specific approval cannot be reused to buy/publish an external site. No automatic purchase, account creation, card submission, DNS/API call or Provider/OAuth until that approval. If Owner prefers the US$9 WordPress.com Personal alternative, REVIEWER must first resolve missing managed backup/restore and adapt this Gate before purchase.

## Ordered execution, only AFTER scoped Owner approval

1. Owner, not assistant, confirms account/subscription eligibility and makes any authorized checkout on WordPress.com privately; no payment card/password/token through agent/chat. Freeze exact billed price, auto-renew terms, staging host ownership and site creation as non-secret evidence. If plan, feature, price, region or billing deviates from approved bound, STOP before purchase.
2. Capture verifiable site identity and exact provider-assigned URL/certificate, HTTP->HTTPS handling, admin security/MFA, plugin policies, original local host untouched, rollback/teardown plan and synthetic-only data. Use a **fresh standalone WordPress.com Business site used for testing**, not an automatic clone or sync of the real local WordPress or a production customer's Woo site. Do not treat WordPress.com optional staging clone as a suitable public production endpoint without independently proving it.
3. Owner sets unique new admin password stored privately; never reuse compromised local WP credential. Do not ask for or transmit secrets. Before remote code/Provider/test payment, prove fresh-site snapshot + one-click restore/replay on a disposable synthetic-only copy where supported and exact target backup recovery, or return precise `RETURN_RECOVERY_PROOF_UNAVAILABLE` for Reviewer. No migrating photos, orders, existing users, DB, provider keys or full app.
4. Install only the verified compatible current WordPress, WooCommerce, official Stripe extension v11.1.0 if still supported, and minimal versioned entitlement test adapter needed to test exactly-one job/access and cancellation. Record exact plugin/version and product fixture currency USD39.99, fresh product ID. Generation/rendering and recurring jobs **disabled**; original project and other Providers untouched.
5. Keep site Coming Soon/private during setup. Before Owner OAuth or sending TEST events, switch to the minimum bounded public exposure necessary. **Anonymous shopper and real Stripe webhook must reach the exact HTTPS route** `https://<verified-stage-host>/?wc-api=wc_stripe`; Coming Soon/private can prevent those accesses. Verify no sensitive admin, debug, logs or uploaded content; do not claim all published pages stay private while site is Public. Return to non-public after test.
6. Owner-only browser manually completes Woo Stripe official **TEST** OAuth/account verification and official Stripe-side webhook connection for this isolated site only. Record non-secret account/mode/site relation. If portal attempts Live or reuses a conflicting merchant/app/account, STOP rather than creating accidental duplicate account or leaking credentials; no bypass via raw key/REST or hidden options.
7. After verified authenticated Test connected account, provider-side TEST endpoint status and rollback, Owner performs exactly one synthetic buyer checkout (virtual USD39.99), and bounded failure/cancel as independently safe; check Provider terminal status, local Woo order/entitlement and generation-disabled guard. Deliver actual Provider-signed first event, invalid-signature rejection, exact same-event replay idempotent side effect, account/order/amount/currency correlation and actual ack contract. A CLI test fixture not linked to Woo checkout is not payment PASS.
8. Only if TEST capture settled and reconciled, perform one explicitly approved matching TEST refund, verify Provider refund terminal status plus local revoked entitlement, no stale fulfillment and no double refund. Ambiguous outcome STOP, do not retry a charge or refund blindly; reconcile read-only.
9. Freeze sanitized Evidence, non-target/Live-negative checks, approved-test expenses, cleanup/reversion status, teardown/renewal cancellation decision, local original stack untouched. Do not delete the site, backup, webhooks or account connections without separate exact scope if preserving for troubleshooting or future production migration is important.
10. Mandatory Reviewer STOP at one bounded outcome or precise technical RETURN; record only allowlisted non-secret state and references. No PR #64 blind merge; source edits would require their own reviewed scope.

## Evidence and strict exclusions

`OWNER_APPROVAL | REAL_HOST_ID_AND_URL | SUBSCRIPTION_COST | TLS_AND_ANONYMOUS_CHECKS | BACKUP_RESTORE_READBACK | EXACT_SYNTHETIC_PRODUCT | STRIPE_TEST_ACCOUNT_AND_WEBHOOK_MODE | FIRST_SIGNED_CALLBACK_ACK | NEGATIVE_SIGNATURE | REPLAY_IDEMPOTENCY | ONE_TEST_ORDER_AND_ONE_REFUND | LOCAL_ENTITLEMENT_REVOCATION | LIVE_OTHER_HOST_NEGATIVE_DELTA | CLEANUP_STATUS | NEEDED_NEXT_APPROVAL`.

No real money/Live, real buyer data, owner real site migration, PayPal changes, local WordPress modifications, shared Docker/VPS, uncontrolled domain/DNS, bulk backup/restore of old local stack, plugin source patch to bypass UI, signing bypass, broad cleanup, background automation, or secret output.

Current status of this Gate is **HOLD**, not permission to deploy. The Executor can read it and produce an action checklist, but may not begin stage creation, subscription, domain exposure, OAuth or Provider TEST checkout without the specified Owner decision.
