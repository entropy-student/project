# Reviewer decision — G3S4J narrow result accepted; separate localhost synthetic WP instead of exposing 8189

Date: 2026-10-17
PR #64 evidence head: `9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956`
Evidence: `docs/evidence/g3s4/G3S4J_CLOUDFLARE_LOCAL_HTTPS_STAGE_2026-10-17.md`
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 (especially §§5–9, 11B/11C/11D/11E)
No Cloudflare/Windows/Provider actions by Reviewer; GitHub source/evidence-only review.

## Reviewer classification

```text
G3S4J_REVIEWER_DISPOSITION=PARTIAL_ACCEPT_WITH_EXACT_UNVERIFIED_CLOUDFLARE
G3S4J_LOCAL_INTERNET_EXPOSURE_ANALYSIS=PASS_NEGATIVE;ORIGINAL_8189_UNSAFE_TO_PUBLISH_UNVERIFIED_PRIVATE_DATA
G3S4J_CLOUDFLARE_ZONE_CONTROL=UNVERIFIED_TOOL_SAFE_STOP
COMPUTER_USE_BROWSER_FAILURE=TARGET_URL_CONFIDENCE_FAILURE;NOT_EVIDENCE_OF_BAD_DOMAIN
NEXT_ARCHITECTURE=FRESH_ISOLATED_LOCAL_WP_WOO_STRIPE_TEST_SYNTHETIC_ONLY
PR64_EVIDENCE_COMMIT=9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956
PR64_DELTA=ONLY_ONE_ADDED_G3S4J_EVIDENCE_FILE
ORIGINAL_WP=127.0.0.1:8189_UNCHANGED
ORIGINAL_STRIPE_PLUGIN=ACTIVE_GATEWAY_DISABLED
ORIGINAL_ADMIN_ROTATION=UNVERIFIED
STAGING_LOCAL_PORT=TO_BE_VERIFIED;8190_PROPOSED_BY_EXECUTOR_BUT_NOT_RESERVED
CLOUDFLARE_CANDIDATE_HOST=stripe-test.spikersun.com_UNVERIFIED_NOT_CREATED
PUBLIC_ROUTE_STRIPE_OAUTH_PAYMENT=NOT_STARTED
NEW_LOCAL_STACK_WRITE_AUTH=NOT_YET_SPECIFICALLY_RECORDED
EXTERNAL_PUBLICATION_DNS_AUTH=NOT_YET_SPECIFICALLY_RECORDED
WORDPRESS_COM_PAID_HOST=NOT_REQUIRED
VPS=OUT_OF_SCOPE
PR64=OPEN_UNMERGED
```

The latest PR commit is one addition of a single Markdown G3S4J Evidence file, no code/runtime/config writes. Verified prior local WordPress PHP Docker and database remain present and reachable only through `127.0.0.1:8189`. The original WP site has at least one existing order and prior backup records 387 uploads whose sensitivity has **not** been inspected; WordPress `home/siteurl` are loopback HTTP; a previously disclosed administrator password is not verified rotated. Do not publish the original 8189 or change its global canonical URL just to test Stripe. Retain existing database, credentials, uploads, PayPal Sandbox state and backups unchanged.

Codex Computer Use could not sufficiently determine active browser URL; stopping without bypass is conformant. The screenshot from the Owner shows Cloudflare dashboard and `spikersun.com` in a domain list, **but this is only Owner-supplied visual evidence**; no active zone/write permission/tunnel/DNS record status is verified. This unknown affects public route provisioning **only**, not the separate synthetic localhost Woo stage. Do not replay Computer Use in the same failed state, demand a new screenshot, or make recurring `RETURN_CLOUDFLARE_DOMAIN_OR_LOCAL_PUBLICATION_SAFETY_UNKNOWN` the blocker for safe local preparation.

## Chosen next implementation

**Proceed toward one project-owned, entirely separate localhost synthetic WooCommerce/Stripe TEST stack.** Design it from the existing already accepted WordPress/Woo/official Stripe versions without importing original WP DB, users/admin, uploads, orders, WP options/keys, Woo Stripe account, PayPal credentials, saved cookies or background generation workers. A fresh unique private test administrator password is required; it can be created by the Owner in their own local browser/session without entering it in agent args/chat, and must never equal the exposed original password.

- Dedicated unique Docker Compose project/network, WP and MariaDB volumes; address `127.0.0.1:<checked-available-port>` (prefer no pre-fixed port without verification; Codex suggested 8190 but that port may belong to another local service). Never bind `0.0.0.0`, expose DB, create a public endpoint or reconfigure original Compose stack.
- Reuse version-pinned accepted images if still available, official supported Woo and Woo Stripe installed but checkout/payment disabled. Add one synthetic virtual product USD39.99 equivalent (new product ID, not assumed 1113). Set generation/AI fulfillment and entitlements in safe disabled/test-only state. No real accounts/photos/customers.
- Site canonical URL at the earliest public-ready configuration checkpoint will be `https://stripe-test.spikersun.com` **only after the approved named hostname is verified and published**. For initial localhost proof, keep the synthetic site's internally tested local origin; do not prematurely change original 8189.
- Minimal site-local snapshot/rollback of **only** new synthetic stack and private credentials: never repeat the accepted original 8189 full backup/restore. Read back container/port isolation, disabled gateway, synthetic user/order count and negative access to original volumes.
- Cloudflare named outbound Tunnel can later bind `stripe-test.spikersun.com` to that new private loopback origin. Use no Cloudflare Access login wall/site-wide bot challenge that blocks guest Woo checkout or signed POST to `/?wc-api=wc_stripe`. Owner can verify zone and hostname availability with their own dashboard/manual minimal action if Computer Use URL confidence remains unusable; no Cloudflare token extraction or alternative uncontrolled browser bypass.
- This **is a TEST environment, not a production migration**. Keep the laptop powered on during Stripe callback; do not confuse SSL-terminated public route with safe production readiness.
- The original WP compromised-password rotation remains strongly recommended but **is not a prerequisite for a truly isolated staging site** that neither exposes nor reads/reuses original WP credentials; do not silently mark it completed. If any shared secret/host/media is discovered, this isolation assumption fails.

## Authorization boundaries and next Gate

Current read-only G3S4J is closed as `PARTIAL_ACCEPT`; its missing Cloudflare ownership evidence is a deferred public-route checkpoint.

**NEXT Gate:** `docs/G3S4K_ISOLATED_LOCAL_STRIPE_TEST_STACK_GATE_2026-10-17.md`. It prepares local-only synthetic WordPress/Woo/Stripe stack using an explicit target-bound, project-only local write authorization. User's earlier approval was for Stripe TEST on the original `8189`, not for a new Compose project or public domain; the current Executor Evidence is a handoff, not an explicit new permission. No automatic new local stack or DNS write from this document alone. Prefer a single Owner message that authorizes both (1) building a fresh isolated loopback-only test stack and (2) later controlled temporary named `stripe-test.spikersun.com` public route + official Stripe TEST OAuth, payment, webhook and one TEST refund; nevertheless, the public phase remains separately gated on verified exact zone/domain, local-stack PASS and callable signed webhook, with no implicit production or Live consent.

The next G3S4K run must avoid another all-read-only cloud browser cycle. If Owner authorizes the new **loopback-only** stack, Codex can build and test it independently of Cloudflare account UI. Then hand off a short exact subdomain/Cloudflare manual checkpoint (non-secret) and a protected public route Gate; preserve PR #64 unmerged. A copy of generated config in GitHub does not prove real Windows/Docker runtime.

No paid hosting/subscription, old/new VPS, original site publication, WordPress.com, real/Live payment, or PR merge. Record one sanitized G3S4K PR Evidence and stop as required for local acceptance.
