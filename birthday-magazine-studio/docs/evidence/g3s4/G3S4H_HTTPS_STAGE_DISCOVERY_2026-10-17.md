# G3S4H — Isolated HTTPS WordPress / Stripe TEST staging discovery

Date: 2026-10-17  
Gate: [G3S4H read-only discovery](../G3S4H_ISOLATED_HTTPS_STRIPE_TEST_STAGE_DISCOVERY_GATE_2026-10-17.md)  
Parent Reviewer decision: [G3S4M RETURN — select isolated HTTPS stage](../REVIEWER_DECISION_G3S4M_RETURN_MANUAL_UI_SELECT_HTTPS_STAGE_2026-10-17.md)  
PR #64 existing branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`  
Pre-write PR head: `3d460070f8eb61f4e47118e41a398fa14cc5b53f`

## Result

```text
EXECUTOR_RESULT=PASS_CANDIDATE_PROVIDER_PLAN_ONLY
RECOMMENDED_STAGE_TARGET=WORDPRESS.COM_BUSINESS_MONTH_TO_MONTH;FRESH_STANDALONE_TEST_SITE
HOST_OWNER_ACCOUNT_VERIFICATION=UNKNOWN_NOT_IN_PROJECT_INVENTORY
SITE_PROVISIONED=NO
EXACT_ASSIGNED_HOSTNAME=UNKNOWN_UNTIL_OWNER_CREATES_SITE
COST=USD_40_PER_MONTH_BEFORE_TAX;MONTH_TO_MONTH_PRICE
CUSTOM_DOMAIN_OR_DNS_PURCHASE=NO;USE_PROVIDER_ASSIGNED_SITE_ADDRESS
HTTPS=PROVIDER_FREE_SSL;MUST_VERIFY_ASSIGNED_HOST_CERT_AND_PUBLIC_REACHABILITY_LATER
REAL_USER_DATA_OR_OLD_DB=NO
STRIPE_OAUTH_WEBHOOK_PAYMENT_REFUND=NOT_STARTED
DEPLOYMENT_OR_PUBLIC_ENDPOINT_CREATED=NO
LOCAL_WP_DOCKER_STRIPE_STATE_CHANGED=NO
STOP_AT_REVIEWER=YES
```

## Existing resource findings

- The current project inventory identifies `https://birthday-magazine-original.netlify.app/` as a static visual frontend; it does not provide PHP, WordPress, WooCommerce, or a Stripe payment backend.
- The previously used VPS was replaced. The new VPS identity, ownership, configuration, and backups are unknown and were not accessed.
- No already-owned managed WordPress/PHP HTTPS staging service or domain is recorded in the reviewed non-secret project inventory. This does **not** claim that Owner accounts outside that inventory were searched.
- The last accepted local readback recorded WordPress 7.1.1, WooCommerce 11.1.2, and the official WooCommerce Stripe Gateway 11.1.0. Existing local state remains outside this discovery and was not rechecked or changed.

## Recommended target

Use a new **WordPress.com Business, month-to-month** site as the test host itself. It is a standalone synthetic-only site, not a clone or migration of the live/local project. Business is selected because WordPress.com documents real-time backups and one-click restores for Business/Commerce/Enterprise, and staging support for Business/Commerce; lower paid plans allow plugins and WooCommerce, but do not provide the same documented restore/staging controls.

- **Cost:** WordPress.com currently lists Business at **US$40/month** on the monthly billing option, before tax. Do not select an annual or multi-year prepayment option. The exact checkout total remains subject to the Owner’s account/region and must be rechecked before any purchase.
- **Address/domain:** use the new site’s provider-assigned address (WordPress.com documents site addresses under `.wordpress.com` or `.wpcomstaging.com`). Do not buy or connect a custom domain. The exact unique slug/hostname is unavailable until the Owner creates the site and is therefore **UNKNOWN**, not reserved or claimed.
- **DNS/TLS:** no external DNS change is needed for the provider-assigned address. WordPress.com states that it automatically supplies free SSL for hosted domains/subdomains and redirects insecure HTTP to HTTPS. Before any Stripe connection, a later Gate must verify the exact assigned hostname, valid certificate, HTTPS redirect, and internet reachability from the provider.
- **Minimal platform contents:** managed current WordPress core; WooCommerce; official WooCommerce Stripe Gateway 11.1.0 only after a later compatibility check; a minimal project payment/entitlement test adapter if required. No Blocksy site migration, business pages, user/admin imports, old database, media uploads, production credentials, or local source changes.
- **Synthetic fixture:** one newly created virtual WooCommerce product equivalent to the recorded `#1113` fixture at USD 39.99; one synthetic buyer/order only. No real buyer profile, email, order, photos, or payment data. No model/provider generation; payment proof must not dispatch real fulfillment.

## TEST OAuth, webhooks, and isolation

- Keep the Stripe gateway disabled until the later test Gate proves the exact stage identity and Live-negative predicates. Use only the official plugin’s Owner-controlled **Test** connection flow; the Owner performs all Stripe sign-in/consent privately. Prefer a stage-specific TEST account/integration. WooCommerce documents per-website Stripe account separation; if the account is already bound to another integration or the exact Test account is ambiguous, stop before OAuth.
- WooCommerce documents a separate Test-mode account connection and Test-mode switch. For the official Stripe extension (11.1.0 is later than 8.6.1), WooCommerce documents automatic webhook setup on connection and the endpoint format `https://<verified-host>/?wc-api=wc_stripe`. A future Gate must verify the Test webhook status in both WooCommerce and Stripe’s Test view.
- Future acceptance must use provider-signed events only: valid first delivery accepted, same event replay produces no duplicate order/entitlement/generation action, and an invalid signature is rejected. Then issue exactly one WooCommerce-initiated **Test** refund and confirm the same synthetic order’s entitlement is revoked/cancelled. This is a test plan; none of these events or writes occurred in G3S4H.
- Keep the site in Coming Soon/private mode during setup. Expose only the synthetic product/checkout and the required signed webhook route for the bounded test window; protect WordPress admin with a new unique Owner-managed password and MFA. Do not expose debug pages, raw payment logs, uploaded media, or private content. Return the site to private/Coming Soon after evidence capture.
- Owner-private rotation of the previously exposed local WordPress password remains **UNVERIFIED** in current handoff. Complete it privately before reusing any credential. Do not reuse the exposed password for this new host.

## Rollback and next authorization

Before any future plugin/provider write, the next Gate must record the exact hostname/site identity, confirm the Owner controls it, verify HTTPS and the Test/Live separation, and demonstrate that the Business backup can be restored to a disposable synthetic-only copy. The deployment manifest must contain only the minimal test artifact.

If any check fails: leave or return the test gateway disabled; restore the pre-write synthetic snapshot; disconnect only this site’s TEST OAuth connection through the supported UI; remove only its Test webhook through the supported plugin/provider controls; preserve the evidence, then return the site to private/Coming Soon. After Reviewer acceptance and separate Owner approval, the test-only site/subscription may be deleted/cancelled. No cleanup of local WordPress, PayPal, or any VPS is part of this plan.

G3S4M’s localhost-only authorization does not cover this hosted service. **A separate explicit Owner authorization is required before** the $40/month service charge, public hostname/checkout exposure, provisioning, plugin/account mutation, or remote Stripe Test connection. G3S4H itself authorizes none of those actions.

`STOP_AT_REVIEWER=YES`

## Sources

- [WordPress.com plans and pricing](https://wordpress.com/pricing/) — Business pricing, paid-plan plugin support, and plan features.
- [WordPress.com introduction to WooCommerce](https://wordpress.com/support/introduction-to-woocommerce/) — WooCommerce can be installed on any paid plan.
- [WordPress.com SSL / HTTPS](https://wordpress.com/support/domains/https-ssl/) — free SSL for hosted domains/subdomains and HTTPS behavior.
- [WordPress.com site addresses](https://wordpress.com/support/getting-started-with-wordpress-com/) — provider-assigned `.wordpress.com` / `.wpcomstaging.com` address.
- [WooCommerce Stripe setup requirements](https://woocommerce.com/document/stripe/setup-and-configuration/) — current WordPress/Woo requirements and externally accessible HTTPS.
- [WooCommerce Stripe account connection](https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/) — supported Test account connection and per-site account considerations.
- [WooCommerce Stripe Test mode](https://woocommerce.com/document/stripe/customer-experience/testing/) — separate Test connection and simulated payments.
- [WooCommerce Stripe webhooks](https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/) — automatic webhook configuration since 8.6.1 and endpoint format.
- [Project MVP product contract](../MVP_PRODUCT_CONTRACT.md) — payment-before-generation and synthetic entitlement boundaries.
- [Accepted G3S4M evidence on PR #64](./G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md) — prior local readback reused; no repeat execution.
