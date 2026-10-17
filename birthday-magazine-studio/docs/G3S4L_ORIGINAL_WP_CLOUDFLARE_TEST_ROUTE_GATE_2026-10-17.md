# G3S4L — existing local WordPress 8189 via Cloudflare Tunnel, official Stripe TEST OAuth

Date: 2026-10-17
State: `OWNER_CHOSE_ORIGINAL_SITE_CLOUDFLARE_ROUTE; BEFORE_PUBLICATION_SECURITY_AND_EXACT_HOST_CONFIRMATION_REQUIRED`
Reviewer decision: `docs/REVIEWER_DECISION_G3S4L_OWNER_AUTH_ORIGINAL_WP_CLOUDFLARE_RESCOPING_2026-10-17.md`
PR #64 G3S4J Evidence baseline: `9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956`
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7; §§5–9/11B/11C/11D/11E.

## Gate contract

```text
GATE_ID=G3S4L_ORIGINAL_LOCAL_WP_CLOUDFLARE_TEST_20261017
OBJECTIVE=Make Owner-existing Docker WordPress/Woo 127.0.0.1:8189 safely usable for owner-domain HTTPS Stripe TEST account/checkout/Webhook/refund with no new hosting/WordPress install
OWNER_APPROVAL=YES_ORIGINAL_SITE_PUBLICATION_DIRECTION_AND_EXISTING_BOUNDED_TEST_INTENT
MAX_ENDPOINT_THIS_ROUND=EXACT_SITE_PRIVACY_PASSWORD_AND_ROLLBACK_PREFLIGHT -> OWNER_VERIFIED_UNCONFLICTED_CLOUDFLARE_TEST_HOST -> BOUNDED_NAMED_TUNNEL_AND_REVERSIBLE_WP_HTTPS_CANARY -> OWNER_TEST_OAUTH -> ONE_SYNTHETIC_39_99_WOO_ORDER_WEBHOOK_REPLAY_NEGATIVE_REFUND -> REVIEWER_STOP
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=EXISTING_OWNER_WIN11_WORDPRESS_WOO_8189_ONLY;OFFICIAL_STRIPE_11_1_0_CURRENTLY_PLUGIN_ACTIVE_GATEWAY_DISABLED;OWNER_CLOUDFLARE_ZONE_spikersun.com_REQUIRES_OWNER_VERIFICATION;CANDIDATE_stripe-test.spikersun.com
CRITICAL_BOUNDARY=NO_PUBLICATION_UNTIL_PRIVATE_ORDER_MEDIA_SECURITY_AND_OLD_COMPROMISED_ADMIN_PASSWORD_ROTATION_VERIFIED;NO_CLOUDFLARE_DNS_OVERWRITE_OR_UNVERIFIED_ZONE;NO_LIVE_OR_REAL_MONEY;NO_VPS;NO_PAID_HOST;NO_SECOND_WP_STACK_BY_DEFAULT
PREFLIGHT=OWNED_SITE_AND_EXISTING_BACKUPS_READBACK_REUSED;SELECTED_PUBLIC_HOST_CLOUDFLARE_OWNER_CONFIRMATION;EXACT_ORIGINAL_WP_RESTORE_POINT;EXPOSED_ADMIN_PASSWORD_PRIVATELY_ROTATED;PUBLIC_NEGATIVE_ACCESS_SAFETY;NO_OTHER_PAYMENT_GATEWAY_OR_AUTO_WORKER_SIDE_EFFECT
REQUIRED_EVIDENCE=EXACT_CLOUDFLARE_ZONE_AND_DNS_SLOT_PROVEN;OWNER_ACCOUNT_ACTION_SOURCE;SECURE_EXISTING_ORDERS_UPLOADS_NO_ANONYMOUS_LEAK;CREDENTIAL_ROTATED_YES_ONLY;ORIGINAL_WP_URL_BASELINE;BOUNDED_SECURE_TUNNEL_WP_PUBLIC_URL;HTTPS_REDIRECT_LOGIN_CHECKOUT_CALLBACK_REACHABILITY;PROVIDER_TEST_ACCOUNT_MODE_AND_SIGNED_EVENT_ACK;ONE_REAL_TEST_ORDER_AND_ONE_TEST_REFUND_WITH_REVOKE;NON_TARGET_NEGATIVE_DELTA;ROLLBACK_READBACK
ACCEPTANCE=REAL_EXTERNAL_PUBLIC_HTTPS_HOST_WITH_VALID_CERT_AND_STABLE_WP_HTTPS_CANONICAL_URL;NO_EXPOSED_PRIVATE_MEDIA_ORDERS_USERS_OR_ADMIN;STRIPE_TEST_ONLY_SUPPORTED_CONNECT;PROVIDER_FIRST_SIGNED_WEBHOOK_POSITIVE_AND_INVALID_NEGATIVE_AND_REPLAY_IDEMPOTENT;EXACT_SYNTHETIC_ORDER_USD_39_99_REFUND_REVOKE;ORIGINAL_BACKUPS_RETAINED;NO_LIVE
ROLLBACK=DISABLE_ONLY_NEW_TUNNEL_ROUTE;RESTORE_SITEURL_HOME_PROXY_SETTINGS_FROM_VERIFIED_PREWRITE_VALUES_IF_NEEDED;UNDO_ONLY_NEW_TEST_PROVIDER_WEBHOOK_AND_GATEWAY_SAFE_STATE;DO_NOT_DESTROY_EXISTING_8189_DB_UPLOADS_MEDIA_ORDERS_OR_DOMAIN_RECORDS
OWNER_ONLY=ROTATE_OLD_EXPOSED_ADMIN_PASSWORD_PRIVATELY;CONFIRM_ONE_EXACT_CLOUDFLARE_ZONE_AND_UNUSED_TEST_HOST;HANDLE_CLOUDFLARE_AND_STRIPE_LOGIN_CONSENT_WITHOUT_CREDENTIAL_DISCLOSURE;PERFORM_CHECKOUT_MANUAL_CONFIRMATION
REVIEWER_TO_EXECUTOR_RELAY=READ_MAIN_HANDOFF_LATEST_TOP_PLUS_THIS_GATE_AND_G3S4J_PR64_EVIDENCE;BEGIN_WITH_SINGLE_SMALL_PREPUBLICATION_CHECK;NO_REPEATED_BROWSER_URL_CONFIDENCE_AUTOMATION;AFTER_SECURE_PRECONDITIONS_USE_OFFICIAL_OWNER_MANUAL_CLOUDFLARE_OR_SCOPED_NATIVE_CLOUDFLARED_ONLY;SANITIZE_EVIDENCE_PR64_AND_STOP
EXECUTOR_TO_REVIEWER_RELAY=EXACT_GATE_ID;PHASE_REACHED;PUBLICATION_PRIVACY_RESULT;ROTATION_BOOLEAN;CLOUDFLARE_OWNER_MANUAL_CHECK;ACTUAL_TUNNEL_DNS_SITEURL_PROVIDER_TEST_RESULT;NON_TARGET_DELTA;CORRESPONDING_COMMIT_SHA;STOP_AT_REVIEWER
```

## Phase 1 — narrow pre-publication safety / no external write

1. Reuse accepted G3S4J readback: local `127.0.0.1:8189`, WordPress 7.1.1/Woo 11.1.2, one existing order, 387 uploads in prior backup inventory of unknown sensitivity, site URL still HTTP loopback and Woo Stripe plugin active but gateway disabled. Do **not** repeat original backups/restore/machine survey or create another WordPress.
2. Check *only the publication attack surface*: allowlisted Woo guest REST/order endpoint permissions, private uploads/downloads, photo URLs, admin/login access, any old live/PayPal gateways, logs/debug/legacy endpoints, and existing user-content that would become public. Inspect sensitive values locally but emit **only aggregated redacted booleans/counts**, not secrets/private contents. Do not overwrite the old orders/files.
3. Previously exposed WP admin password rotation status is UNVERIFIED. Owner personally rotates it to a new unique credential **without sending value in chat/agent tools**, then confirms only completion. **Do not publish original host before this checkpoint.** If not completed, executor can prepare non-secret host-side tunnel design but cannot enable public DNS/Tunnel.
4. Freeze actual original WP `home/siteurl`, reverse proxy/HTTPS trust behavior, backup identity/preservation and safe rollback. Confirm local-only binding and original private access until Cloudflare prewrite conditions are met. Require a secure plan for admin path access with no insecure blanket Cloudflare Access on Stripe POST or guest checkout.
5. If private orders/uploads would be publicly retrievable or publication would expose personal data, classify one precise risk and **STOP before public write** pending narrowly scoped redaction/access-control, even though Owner wishes to publish. Do not conflate ordinary existing Woo records in a protected DB with necessarily public disclosure: only actual anonymous exposure fails the test.

## Phase 2 — Cloudflare Owner-manual control, no browser safety bypass

1. Previous Codex Computer Use failed **only because its active-tab URL could not be machine-verified**. The Owner screenshot displays `dash.cloudflare.com`; root cause of automation adapter failure remains unknown. This is not evidence that Cloudflare login/domain is bad. **Do not retry the same failing browser tool or substitute a different automated browser to bypass the safety control**.
2. Owner may use the already open Cloudflare dashboard **manually** to check `spikersun.com` zone `Active`, correct account and permission, exact available DNS label `stripe-test` and any existing Tunnel route collision. Owner can report only `ACTIVE_YES/NO`, `HOST_FREE_YES/NO`, and chosen exact hostname, no screenshots/API key/token. If neither can be established, keep publication disabled; do not guess.
3. Once host is Owner-confirmed and no collision, use reviewed officially supported named Cloudflare Tunnel **after** phase 1 PASS. Owner may perform exact Cloudflare dashboard creation/routing clicks or a supported `cloudflared tunnel login` owner-browser approval plus private credentials file. Cloudflare secret/certificate/tunnel token never appears in command-line arguments, public shell environment, chat, repo or evidence. No general API token extraction or uncontrolled automation; native host tools may verify only exact local connector service/port/version/route.
4. Proposed ingress: dedicated `stripe-test.spikersun.com` HTTPS to `http://127.0.0.1:8189` only; no apex rewrite, router port forwarding, alternate DNS zone, or old/new VPS. Only one DNS record/route after Owner confirmation; do not override an existing object. Cloudflare Access/captcha/cache must not block native `/?wc-api=wc_stripe` signed POST or guest Woo checkout.
5. Configure WordPress canonical HTTPS address on the existing project only after exact backup/reversion evidence. Validate forwarded HTTPS/proxy trust, cookie/nonce admin login, local CLI WP health, mixed content and OAuth redirect with both internal and public readbacks. A Tunnel connector `RUNNING` is not equivalent to externally reachable Stripe webhook.

## Phase 3 — official TEST canary (conditional)

1. After tested stable public HTTPS and order/media/admin negative access, Owner-only supported Woo Stripe Test OAuth (no raw REST/SQL/WP-option key injection); verify authentic Test account, no Live and no unexpected other-provider mutation.
2. One synthetic Woo product ID #1113 **only if current effective USD39.99 virtual product still matches**; actual Woo order one TEST payment and provider amount/currency/account correlation, first signed official webhook ACK, invalid-signature rejection, same-event replay produces no double fulfillment/entitlement; generation/real durable worker remains disabled.
3. One corresponding TEST refund and entitlement revocation; Provider Test refund and local Woo state reconciled, no second retry after ambiguous status. Report only sanitized results, no provider/account secret; no real charge/payout claims.
4. Preserve historic PayPal Sandbox and existing user order/media contents, run negative non-target tests, document exact tunnel/local/webhook rollback without deletion of unrelated Cloudflare resources. Mandatory Reviewer stop with one Evidence in PR64.

## Stop conditions and iteration policy

**Exact stop, not generic redo:** `RETURN_PRIVATE_DATA_PUBLIC_ROUTE` on proven anonymous private leak; `RETURN_WP_ADMIN_PASSWORD_ROTATION_PENDING` only immediately before public exposure; `RETURN_CLOUDFLARE_EXACT_ZONE_UNVERIFIED` only at publication after local checks; `RETURN_TUNNEL_CALLBACK_OR_WP_CANONICAL_ERROR` only after documented exact technical state. These are named material blockers, never reasons to reset/uninstall/reinstall full original WordPress. Preserve partial safe work. If a publication write has ambiguous outcome, reconcile that exact DNS/tunnel state before retry. One bounded diagnosis per failure domain; no redundant rounds.

No public user content disclosure is approved by the mere preference for publication. Source PR #64 remains open/unmerged. Existing G3S4K isolated new-site Gate is superseded for active work, not deleted; consider it only after an actual proven uncontainable original-site exposure.
