# G3S4H — isolated HTTPS WordPress / WooCommerce Stripe TEST stage discovery

Date: 2026-10-17  
Gate: [G3S4H read-only discovery](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/G3S4H_ISOLATED_HTTPS_STRIPE_TEST_STAGE_DISCOVERY_GATE_2026-10-17.md)  
Parent Reviewer decision: [G3S4M RETURN](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/REVIEWER_DECISION_G3S4M_RETURN_MANUAL_UI_SELECT_HTTPS_STAGE_2026-10-17.md)  
Existing PR #64 branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`  
Pre-update head: `40dd505c85a60482b471663a808a2caf3fb04c2d`

## Gate decision fields

```text
EXECUTOR_RESULT=PASS_CANDIDATE_PROVIDER_PLAN_ONLY;NO_EXTERNAL_WRITES
RECOMMENDED_STAGE_TARGET=WORDPRESS.COM_BUSINESS_MONTHLY;FRESH_STANDALONE_SYNTHETIC_TEST_SITE
HOST_VERIFICATION=NO_EXISTING_OWNER_CONTROLLED_WP_PHP_HTTPS_HOST_OR_DOMAIN_RECORDED_IN_PROJECT_INVENTORY;OWNER_ACCOUNT_NOT_SEARCHED;SITE_NOT_PROVISIONED
COST=USD_40_PER_MONTH_MONTH_TO_MONTH_BEFORE_TAX;CURRENT_PUBLISHED_PRICE;RECHECK_AT_OWNER_CHECKOUT
DNS_HTTPS=WORDPRESS.COM_PROVIDER_ASSIGNED_SITE_HOSTNAME;NO_CUSTOM_DOMAIN_OR_EXTERNAL_DNS;FREE_SSL;EXACT_HOSTNAME_UNKNOWN_UNTIL_OWNER_CREATES_SITE
DATA_SCOPE=NEW_EMPTY_SITE;SYNTHETIC_VIRTUAL_PRODUCT_AND_ORDER_ONLY;NO_REAL_USERS_ORDERS_ADMIN_CREDENTIALS_PHOTOS_OR_OLD_DB
SECURITY_EXPOSURE=PUBLIC_ONLY_FOR_BOUNDED_TEST_WINDOW;SYNTHETIC_PRODUCT_CHECKOUT_AND_SIGNED_WEBHOOK;ADMIN_PROTECTED;NO_DEBUG_OR_RAW_PAYMENT_LOGS
PROVIDER_ACCOUNT_SEPARATION=OWNER_PRIVATE_TEST_MODE_OAUTH;STAGE_SPECIFIC_TEST_ACCOUNT_OR_INTEGRATION;NO_LIVE_CONNECTION;STOP_ON_ACCOUNT_CONFLICT
MINIMAL_STAGE_ARTIFACT=MANAGED_CURRENT_WORDPRESS;WOOCOMMERCE;OFFICIAL_STRIPE_GATEWAY_11.1.0_AFTER_COMPATIBILITY_CHECK;ONE_VIRTUAL_USD_39.99_FIXTURE;MINIMAL_ENTITLEMENT_TEST_ADAPTER;GENERATION_DISABLED
ROLLBACK=PREWRITE_BUSINESS_BACKUP_AND_RESTORE_TEST_ON_SYNTHETIC_COPY;DISABLE_GATEWAY;RESTORE_SNAPSHOT;DISCONNECT_ONLY_STAGE_TEST_OAUTH_AND_TEST_WEBHOOK;RETURN_SITE_TO_PRIVATE
OWNER_REQUIRED=NEW_EXPLICIT_APPROVAL_FOR_MONTHLY_CHARGE_PUBLIC_SITE_PROVISIONING_AND_REMOTE_TEST_PROVIDER_WRITE;G3S4M_LOCAL_APPROVAL_DOES_NOT_COVER
NEXT_TEST_GATE=VERIFY_OWNER_TARGET_IDENTITY_HOSTNAME_TLS_BACKUP_RESTORE_VERSION_COMPATIBILITY_LIVE_NEGATIVE_AND_TEST_ONLY_OAUTH;THEN_VALID_REPLAY_INVALID_REFUND_REVOKE
STOP_AT_REVIEWER=YES
```

## Findings and recommendation

The latest handoff identifies `https://birthday-magazine-original.netlify.app/` as a static frontend, not a PHP/WooCommerce payment host. The replaced VPS identity and replacement VPS details are unknown and were not accessed. No eligible owner-controlled managed WordPress/PHP HTTPS service or domain is recorded in the reviewed non-secret project inventory; this does not claim Owner accounts outside that inventory were searched.

**Recommendation:** a new WordPress.com Business site, billed monthly, used as the test site itself. Do not clone or migrate the real Birthday Magazine site. Business is selected because the current plan information includes real-time backups, one-click restore and staging; paid lower plans support plugins/WooCommerce, but do not provide the same documented restore/staging controls.

- **Cost:** USD $40/month on the published monthly option, before tax. No annual or multi-year prepayment. The provider-assigned site address avoids custom domain registration and external DNS cost. Recheck the exact amount at Owner checkout; no purchase or trial was started.
- **Domain/TLS:** WordPress.com provides a unique site address under `.wordpress.com` or `.wpcomstaging.com`; the exact slug/hostname is unknown until created. WordPress.com states that it supplies free SSL for its hosted domains/subdomains and redirects HTTP to HTTPS. A later Gate must verify the exact assigned host, certificate, redirect, and public reachability before any Stripe connection.
- **Compatibility:** install WooCommerce and official WooCommerce Stripe Gateway 11.1.0 only after the later Gate verifies the host’s managed WordPress/Woo versions are currently compatible. Existing accepted local readback is WordPress 7.1.1 / WooCommerce 11.1.2 / Stripe Gateway 11.1.0; these local versions were reused as reference, not rechecked or copied.
- **Data/artifact:** one new virtual product equivalent to the existing USD 39.99 fixture and one synthetic buyer/order. No real customer/order/admin records, credentials, source photos, old DB, or media. Use only the minimal payment/entitlement test adapter; generation/model/provider fulfillment remains disabled.
- **Public boundary:** keep the site private/Coming Soon during setup. For the bounded test window, expose only the synthetic product/checkout and required webhook route; keep admin authenticated with a new unique Owner-managed password and MFA. No debug endpoints, raw payment logs, public private content, or uploaded media. Restore private/Coming Soon status after evidence capture.
- **Unresolved local credential checkpoint:** the handoff still marks Owner-private rotation of the previously exposed local WordPress password **UNVERIFIED**. Rotate it privately before reusing any credential; do not reuse it on the new site.

## TEST OAuth, webhook, and rollback design

WooCommerce documents a separate Stripe Test-mode connection initiated from its supported settings UI; the Owner alone performs sign-in/consent and any credential entry. Use an isolated stage-specific Test account/integration and do not configure Live mode. WooCommerce advises that each operated website use its own Stripe account; if the available Test account is already connected to another integration or the target account is ambiguous, stop before authorization.

For WooCommerce Stripe 11.1.0, the documented webhook path is `https://<verified-host>/?wc-api=wc_stripe`; the official extension automatically configures webhooks on connection (since 8.6.1). Later acceptance must verify the Test webhook status in the plugin and Stripe Test view, then demonstrate: authentic signed first delivery accepted; exact event replay causes no duplicate order/entitlement/generation action; invalid signature rejected; one WooCommerce-initiated Test refund revokes the same synthetic order’s entitlement. These are future acceptance criteria, not actions/results from G3S4H.

Before any later plugin/provider write, take a Business backup and prove restore on a disposable synthetic-only copy. If a safety check fails, keep the gateway disabled, restore that snapshot, disconnect only this site’s Test OAuth through the supported UI, remove only its Test webhook through supported controls, and return the site to private. Preserve evidence; cancel/delete the test-only service only after Reviewer acceptance and separate Owner authorization. Do not change the local site, PayPal, or any VPS.

The G3S4M authorization was localhost-only. A new explicit Owner authorization is required before any hosted monthly charge, public hostname/checkout exposure, provisioning, or remote Stripe Test/provider write. G3S4H provides no such authority.

## Sources

- [WordPress.com pricing](https://wordpress.com/pricing/) — monthly Business price and plan features.
- [WordPress.com WooCommerce guide](https://wordpress.com/support/introduction-to-woocommerce/) — WooCommerce can be installed on paid plans.
- [WordPress.com SSL / HTTPS](https://wordpress.com/support/domains/https-ssl/) — free SSL for hosted domains/subdomains.
- [WordPress.com site addresses](https://wordpress.com/support/getting-started-with-wordpress-com/) — provider-assigned site address.
- [WooCommerce Stripe setup requirements](https://woocommerce.com/document/stripe/setup-and-configuration/) — current WordPress/Woo requirements and accessible HTTPS.
- [WooCommerce Stripe account connection](https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/) — supported Test connection and per-site account considerations.
- [WooCommerce Stripe Test mode](https://woocommerce.com/document/stripe/customer-experience/testing/) — separate Test connection and simulated payments.
- [WooCommerce Stripe webhooks](https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/) — automatic configuration since 8.6.1 and endpoint format.
- [Project MVP product contract](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/MVP_PRODUCT_CONTRACT.md) — payment-before-generation boundary.
- [Accepted G3S4M evidence on PR #64](https://github.com/entropy-student/project/blob/40dd505c85a60482b471663a808a2caf3fb04c2d/birthday-magazine-studio/docs/evidence/g3s4/G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md) — prior runtime/backup/local findings reused; no re-execution.

G3S4H did not provision hosting, change DNS, connect Stripe, activate a plugin, create a checkout/payment/webhook/refund, operate a VPS, or change the local Docker/WordPress state.  
`STOP_AT_REVIEWER=YES`.
