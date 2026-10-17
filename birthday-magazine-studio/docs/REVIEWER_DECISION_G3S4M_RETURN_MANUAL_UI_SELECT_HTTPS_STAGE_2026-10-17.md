# Reviewer Decision — G3S4M RETURN, select isolated HTTPS Stripe TEST staging

Date: 2026-10-17
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
Evidence: PR #64 `3d460070f8eb61f4e47118e41a398fa14cc5b53f`, `docs/evidence/g3s4/G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md`
Parent Gate: `docs/G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_2026-10-17.md`
Reviewer role: independent GitHub/document review; no direct Owner Windows/browser/Provider access.

## Determination

```text
G3S4M_LOCAL_SUPPORTED_TEST_CONNECT=RETURN_MANUAL_TEST_UI_UNAVAILABLE
EVIDENCE_VERIFIED=YES; ONE_EXISTING_EVIDENCE_FILE_CHANGED
LOCAL_WOO_STRIPE_11_1_0_PLUGIN=ACTIVE_EXECUTOR_READBACK
LOCAL_WOO_STRIPE_GATEWAY=DISABLED
STRIPE_SAVED_OPTIONS=NONE_REPORTED
STRIPE_OAUTH_CONNECTION=NOT_STARTED
STRIPE_CLI_LISTENER=NOT_STARTED
STRIPE_WEBHOOK_SIGNED_DELIVERY=NOT_STARTED
STRIPE_TEST_CHECKOUT_REFUND=NOT_STARTED
WORDPRESS_ADMIN_PRIVATE_PASSWORD_ROTATION=UNVERIFIED
EXECUTION_GATE_DEVIATION=PLUGIN_ACTIVATED_WITHOUT_REQUIRED_PASSWORD_ROTATION_CONFIRMATION
LOCAL_TEST_SIGNING_SECRET_UI=UNAVAILABLE_IN_STANDARD_DISCONNECTED_11_1_0_SETTINGS
G3S4M_TEST_PAYMENT_PASS=NO
NEXT_TECHNICAL_ROUTE=ISOLATED_HTTPS_WP_STAGING_WITH_OFFICIAL_WOO_TEST_OAUTH_AND_WEBHOOK
NEXT_EXECUTION_SCOPE=READ_ONLY_STAGING_TARGET_DISCOVERY_AND_DESIGN
NEW_PUBLIC_DEPLOYMENT_AUTHORIZATION=NOT_GRANTED
PR64=OPEN_UNMERGED
OLD_OR_NEW_VPS=DO_NOT_TOUCH
```

The Executor's scope stop is **correct**: the installed version's standard unconnected UI offers TEST OAuth, but not an editable TEST Webhook signing secret needed for the locally forwarded Stripe CLI event. The “Configure webhooks” control manages Stripe-side endpoint configuration and is not the CLI secret control. Settings/REST/controller fields in source do not prove a permitted UI route. A local listener that receives events is not adequate when the official plugin cannot accept the listener signature through its supported UI. Do not resume that route using raw REST/WP options, SQL, WP-CLI eval, hacked UI, custom signature bypass or a proxy that fakes trusted events.

The latest PR commit changed **only** the existing G3S4M Evidence. Plugin activation was a real host/database action. Evidence says the plugin is active while the payment gateway remains disabled, no Stripe credential/options or account connection, no payment or webhook. This is a **bounded recorded outcome, not full Gate PASS**. The prior Gate required a private rotation confirmation **before plugin mutation**; Owner's general approval of this TEST project did not automatically waive that control. Evidence also reports a later Owner direction not to block, whose authority/scope the Reviewer has not independently confirmed; record the deviation without treating rotation as completed or retroactively conformant. Do **not** blindly deactivate, delete/recreate, reinstall or reset WordPress merely for procedural tidiness: gateway remains disabled and the safest narrow action now is to freeze configuration and confirm that state read-only before future change. If evidence of a Live key, unintended side effect or public checkout emerges, contain it first under a separate exact-scope Gate.

## Reviewer route selection

**Stop local-only G3S4M TEST checkout attempts.** Adopt a **separate short-lived, isolated, publicly routable HTTPS WordPress/WooCommerce TEST staging site** on a freshly identified target with no production buyers/data. This does **not** mean moving the real Birthday Magazine application or using the previously replaced VPS. A static Netlify visual site is **not** a WordPress/PHP/WooCommerce payment backend.

The staging site must use:
- its own exact DNS/TLS/HTTPS identity (no guessed domain or host); no old/new VPS reuse without independent approval/discovery;
- an isolated WordPress/Woo 11.1.x plus the same reviewed official Woo Stripe 11.1.0 version where possible, synthetic test virtual product #1113-equivalent USD39.99, minimum required local Woo checkout/proof plugin and no real customer photos/orders/secrets;
- safe data/storage/backups with project isolation; protected WP admin, minimal anonymous site exposure, explicit allowlisted public checkout and signed `https://<verified-stage-host>/?wc-api=wc_stripe` provider endpoint, denied admin/private content, no global tunnel;
- normal Woo Stripe **TEST** account OAuth connection in Owner-controlled browser, official auto-created TEST webhook with Provider-side identity/secret verification, exact TEST-only configuration, and separately authorized one synthetic checkout -> valid signature/first/replay/invalid negative -> refund/revoke;
- correct merchant/account identity. Distinguish stage TEST account and any other Stripe integration, do not silently bind a second site to the same account where connection conflicts; no Provider Live, no real money, no payout claim.

Authoritative public supporting docs (checked 2026-10-17):
- https://woocommerce.com/document/stripe/setup-and-configuration/ : HTTPS and SSL accessible site required.
- https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/ : account OAuth, site internet/HTTPS prerequisites and multiple-site account constraints.
- https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/ : official endpoint `https://.../?wc-api=wc_stripe`, automatic webhook configuration since plugin 8.6.1.
- https://woocommerce.com/document/stripe/customer-experience/testing/ : TEST account connection is distinct from Live.
These describe a technically credible **candidate**, not current deployed site or validated payment proof.

## Next bounded Gate — G3S4H discovery, not deployment authority

A separate material target/public-exposure boundary is required; read `docs/G3S4H_ISOLATED_HTTPS_STRIPE_TEST_STAGE_DISCOVERY_GATE_2026-10-17.md`. The immediate Executor next step is **read-only plan + target discovery** only:
1. Inspect current project structure/accepted local proof once, choose the minimal WordPress/Woo synthetic checkout subset needed for a test staging site, with no copy of real buyer/order/admin/secret data.
2. Investigate existing hosting/domain resources and options strictly from accessible non-secret inventory; give one concrete recommended HTTPS WordPress host/environment candidate with requirements, cost if verified, data/storage/recovery, access boundary and teardown. Do not assume ownership of a domain/new VPS; if none exists, mark `HOST_NOT_SELECTED` and give a conditional choice.
3. Produce exact preflight, provider webhook path, test OAuth, rollback, negative admin/private URL checks and ordered acceptance. Define explicit authorization for deployment/ingress/possible charges separately from the previously approved local TEST-only action.
4. Stop at Reviewer with a compact evidence/design packet; do **not** buy hosting, provision, open public ports, deploy, migrate WordPress, touch old/new VPS, log into Stripe or create a provider webhook.
5. Current local plugin remains installed+active / gateway disabled as recorded; do not change it or retry local CLI listener.
6. Require Owner-private rotation of the previously exposed WP admin password before use. No secret in chat, Codex tools, shell arguments, Evidence or GitHub.

Reviewer-to-Executor: Keep PR #64 open and source/evidence untouched except a bounded new design Evidence if the G3S4H discovery Gate specifies it; write material Reviewer decision to main. No repeated local password-reset script, Docker re-create, backup or 44-file comparison. No fresh approval required for read-only discovery; public HTTPS staging deployment will require explicit Owner authorization of the new target and external exposure.
