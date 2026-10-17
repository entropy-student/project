# Reviewer decision — G3S4M CLI staging PASS; conditional supported manual TEST-key path

> Date: 2026-10-17
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, §§0–10/11B/11C/11D/11E/12–13
> PR #64 evidence source/head: `5ee2531818b8cdf79f03cca8860f297152ac9d09`
> Evidence: `docs/evidence/g3s4/G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md`
> Gate: `docs/G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_2026-10-17.md`
> This Reviewer operation: source review + scoped GitHub documentation. No host, Stripe, Docker, secrets, payment or VPS write.

## Classification and decision

```text
G3S4M_LOCAL_COMPATIBILITY_AND_CLI_STAGING=REVIEWER_PASS_BOUNDED
EVIDENCE_COMMIT=5ee2531818b8cdf79f03cca8860f297152ac9d09
EVIDENCE_FILE_DELTA=ONE_EXISTING_MARKDOWN_ONLY
WOO_STRIPE_11_1_0_LOCAL_TEST_WEBHOOK_ADAPTER=SOURCE_COMPATIBILITY_ACCEPTED_NOT_RUNTIME_VERIFIED
STRIPE_CLI_1_53_1_WINDOWS=OFFLINE_STAGED_OWNER_LOCAL_EXECUTOR_READBACK
PLUGIN_ACTIVATION=NO
OWNER_TEST_KEYS_OR_STRIPE_CLI_LOGIN=NOT_STARTED
WEBHOOK_FIRST_DELIVERY_OR_REPLAY=NOT_STARTED
STRIPE_TEST_ORDER_REFUND=NOT_STARTED
APPROVED_ROUTE=CONDITIONAL_NATIVE_PLUGIN_MANUAL_TEST_ONLY_AND_OUTBOUND_STRIPE_CLI
STANDARD_OAUTH_ON_LOOPBACK=NOT_VALIDATED;HTTPS_PRECONDITION_DEMONSTRATED_IN_VERSION_SOURCE
PAYMENT_OR_PROVIDER_WRITE_AUTHORIZATION=NOT_RECORDED_FOR_G3S4M
PRIVATE_ADMIN_PASSWORD_ROTATION=UNVERIFIED
NEXT=EXPLICIT_OWNER_TEST_WRITE_SCOPE_AND_PRIVATE_ROTATION_THEN_ONE_BOUNDED_G3S4M_EXECUTION
VPS_OR_PUBLIC_TUNNEL=NO
PR64=OPEN_UNMERGED
```

**PASS applies only to version-specific source compatibility + reversible official CLI staging.** The full G3S4M Stripe TEST checkout, webhook and refund Gate has **NOT PASSED**.

## Review evidence

- GitHub current PR #64 head equals `5ee2531818b8cdf79f03cca8860f297152ac9d09`, open/unmerged. That commit modifies exactly one existing G3S4M Evidence Markdown file; no app/source modification.
- Executor local evidence: installed `woocommerce-gateway-stripe` 11.1.0, Woo `woocommerce_api_wc_stripe`, active Test secret key `test_webhook_secret`, signed raw-body HMAC `Stripe-Signature` verification, `E2E_TESTING` unset. Source reviewed independently at official tag: https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/class-wc-stripe-webhook-handler.php .
- Versioned settings include `testmode`, `test_publishable_key`, `test_secret_key`, `test_webhook_secret`: https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/stripe-settings.php . Versioned account-key controller includes distinct TEST-key validation and account-key saving methods: https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/admin/class-wc-rest-stripe-account-keys-controller.php . **Presence of a stored setting/controller does not prove the normal current admin UI exposes a supported merchant workflow.**
- The controller also handles manual key change by invalidating configured webhooks and may sync enabled payment methods through Stripe. Such writes are **not** read-only, and manually calling this REST API/setting WP options is **not** authorized merely because the code exists. A later narrow approved test must account for every remote/DB side effect and prove no Live config or other merchant is touched.
- Standard OAuth `get_oauth_url()` has HTTPS gating and local browser return/callback dependence: https://github.com/woocommerce/woocommerce-gateway-stripe/blob/11.1.0/includes/connect/class-wc-stripe-connect.php . Woo official connection docs warn local/unreachable/HTTP sites may fail: https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/ . Its current documentation prioritizes OAuth and re-authentication for merchants, not manual-key production onboarding: https://woocommerce.com/document/stripe/admin-experience/updated-requirements-for-stripe-plugin-mid-2025/ . **Do not force OAuth by spoofing HTTPS or public routing.**
- Stripe CLI v1.53.1 Windows x86_64 official ZIP/hash/manifest and protected user-scoped staging were inspected through the Executor Evidence. `stripe version` and `listen --help` passed offline; no listener, login, account pairing, secret or provider event. Stripe documentation supports outbound local delivery with `--forward-to` and an ephemeral listener signing secret: https://docs.stripe.com/cli/listen .
- The webhook handler's account-context check is permissive when the provider event account or locally cached connected account is unknown; plugin signature verification alone must **not** substitute for test merchant/account/order/amount/currency correlation at Gate acceptance. Race/replay changes in release 11.1.0 remain untested.

## Approved design only: first local Test checkout candidate

Reviewer selects a **conditional developer TEST-only path** using the installed official plugin and outbound official Stripe CLI on existing `127.0.0.1:8189`, before any remotely deployed HTTPS stage. This is not permission to write yet.

**Preconditions before TEST writes (single bounded authorization checkpoint):**

1. Owner confirms **private rotation** of the WordPress admin password previously exposed in conversation; only non-secret yes/no confirmation may enter chat/PR.
2. Owner gives explicit **fresh G3S4M TEST-only write consent**: activate *this installed plugin on this verified local WordPress*, configure supported Test-only connection/keys/CLI listener secret, Owner-only Stripe TEST authorization, run one bounded synthetic product #1113 USD39.99 checkout with signed first/duplicate/invalid webhook verification and one bounded TEST refund/revocation. Any real/Live charge, production or unrelated provider is excluded.
3. Recheck the already identified exact Windows/Docker/site/product and selected unchanged rollback baseline **without repeating unrelated host scans or restores**. Inspect plugin settings and checkout activation behavior *before* mutation: no Live key, Live checkout, unexpected OAuth endpoint creation or unintended payment-method sync, and no auto fulfillment. Activation itself can mutate DB and must be read back.
4. **Supported configuration control:** use only the plugin's supported Owner-visible administrative TEST UI to configure TEST keys and TEST signing secret, or another subsequently **specifically reviewed** bounded secure supported interface. Do not bypass UI by direct SQL/WP option mutation, arbitrary WP-CLI eval, raw REST key writes by agent, custom plugin patch, modified signature code, fake connection status, or browser impersonation. If the current UI hides/blocks TEST keys or mandates OAuth with an unreachable callback, STOP **before credentials or gateway write** and return `RETURN_MANUAL_TEST_UI_UNAVAILABLE` for Reviewer to choose isolated HTTPS staging.
5. Signing secret from a specific outbound Stripe CLI **TEST-mode** listener must match the exact accepted Woo TEST setting; account and mode must be independently correlated to the **same** Owner-approved Stripe TEST account. Do not output key, listener secret, pairing/session token, account identifiers or raw provider payload to chat, Codex, logs, argv or GitHub. Owner-authenticated local/private interaction only, with no automation of Owner browser account actions.
6. Stripe CLI connected TEST event forwarding is outbound only to the known native Woo local handler; **no public tunnel or public WordPress route**. Prove signed original-body delivery, ack, invalid-signature negative and duplicate/replay; use one native Woo checkout-created, provider-verified TEST payment for the actual order/currency/amount and no duplicate job/entitlement. CLI `stripe trigger` alone is insufficient proof. A disconnected/ambiguous checkout/provider result stops without replaying payment.
7. Before any TEST refund, classify the original TEST payment state; a TEST refund is included only in the expressly authorized bounded test scenario, verify Provider TEST terminal refund + local state/revocation, and never equate simulated Provider status with real settlement/payout. Preserve original backup, isolate TEST-only post-change secrets and precise reversal plan.
8. If official supported manual test operation cannot be made to work without weakening account, webhook or signature enforcement, **stop and propose a separate Gate for an isolated Owner-controlled HTTPS TEST instance**. Do not deploy to the old or replacement VPS using the old deployment recipe.

**Scope:** no mass backup, reset, deletion, source redesign, PR merge, public deployment, other-provider changes or real money. Handoff remains mandatory to Reviewer after one bounded test or precise stop. Reuse current G3S4M Gate rather than introducing an extra execution Gate for this in-Gate, Reviewer-approved path.

## Reviewer → Executor after Owner's bounded TEST authorization

Use `REVIEWER_HANDOFF.md` top latest entry, this decision, existing G3S4M Gate, and the PR #64 Evidence at `5ee25318...`. Do not repeat completed compatibility/staging/preflight. First verify the supported official plugin TEST-key UI and absence of hidden Live/provider side effects (narrow prewrite inspect); if unavailable STOP with `RETURN_MANUAL_TEST_UI_UNAVAILABLE` rather than forcing OAuth. If supported and all preconditions recorded, perform one scoped **TEST-only** plugin/account/listener/checkout/signed-webhook/refund sequence, Owner personally handles all Stripe account/secret steps, and append sanitized observation to **the same G3S4M PR Evidence**. Distinguish actual Provider TEST status, callback signature, local Woo order, entitlements, refunds, and duplicate count. Mandatory Reviewer stop.

## Owner action

Private WordPress password rotation confirmation and the single specific G3S4M local synthetic TEST-write approval are the only Owner decisions currently needed for the next payment test. No VPS details or secrets should be provided.
