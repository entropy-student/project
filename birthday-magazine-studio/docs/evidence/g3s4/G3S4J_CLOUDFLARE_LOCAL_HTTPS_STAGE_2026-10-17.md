# G3S4J — Cloudflare Tunnel / local HTTPS Stripe TEST preflight evidence

Date: 2026-10-17
Gate: [G3S4J read-only design Gate](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/G3S4J_CLOUDFLARE_TUNNEL_LOCAL_STRIPE_TEST_DESIGN_GATE_2026-10-17.md)
Reviewer route: [Cloudflare Tunnel preference](https://github.com/entropy-student/project/blob/main/birthday-magazine-studio/docs/REVIEWER_DECISION_G3S4J_PREFER_CLOUDFLARE_TUNNEL_LOCAL_HTTPS_2026-10-17.md)
PR #64 branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`
Pre-update PR head: `b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf`

## Result

~~~text
GATE=G3S4J_CLOUDFLARE_TUNNEL_LOCAL_STRIPE_TEST_DESIGN_20261017
EXECUTOR_RESULT=RETURN_CLOUDFLARE_DOMAIN_OR_LOCAL_PUBLICATION_SAFETY_UNKNOWN
ORIGINAL_8189_PUBLICATION=NOT_RECOMMENDED
RECOMMENDED_TARGET=FRESH_ISOLATED_SYNTHETIC_LOCAL_WOOCOMMERCE_STACK
CLOUDFLARE_ZONE_STATUS=UNKNOWN
CLOUDFLARE_ZONE_WRITE_PERMISSION=UNKNOWN
STRIPE_TEST_HOST_DNS_CONFLICT=UNKNOWN
CLOUDFLARE_TUNNEL_UI=UNKNOWN
PUBLIC_DNS_OR_TUNNEL_CREATED=NO
WORDPRESS_URL_OR_DATABASE_CHANGED=NO
STRIPE_OAUTH_WEBHOOK_PAYMENT_OR_REFUND=NOT_STARTED
PR64_MERGE=NO
STOP_AT_REVIEWER=YES
~~~

The read-only Gate did not establish an eligible, writable Cloudflare zone or confirm the candidate DNS slot. The current Windows Computer Use surface stopped before any Cloudflare page was read because it could not determine the active browser URL with enough confidence to enforce its safety policy. No alternate browser path was used. Per the main Reviewer Handoff, an Owner-supplied screenshot previously showed `spikersun.com` in the domain list; this is owner-reported context only, not this Executor's verification of active status, rights, DNS records, conflicts, or Tunnel controls.

## Local target — bounded read-only readback

Existing accepted G3S4M/G3S4H evidence was reused for WordPress/WooCommerce/plugin configuration, canonical URL, prior backup inventory, and source/CLI state; no backup, restore, install, broad host scan, database write, or source change was performed.

A narrow host read showed the retained Compose project containers up: WordPress `wordpress:7.1.1-php8.3-apache`, WP-CLI `wordpress:cli-php8.3`, and MariaDB `mariadb:11.4.7`; the database was healthy. WordPress is published only as `127.0.0.1:8189 -> 80/tcp`; MariaDB and WP-CLI have no host port. A no-proxy GET to `http://127.0.0.1:8189/` returned HTTP 200 from `127.0.0.1`; only status/address metadata was captured, no response body. `Invoke-WebRequest` did not produce a response in this shell, so the status-only direct GET is the successful endpoint readback.

Reused accepted local evidence records:

- WordPress `home` and `siteurl` are the loopback URL, not an HTTPS public hostname.
- One existing WooCommerce order was counted; prior isolated backup-restore inventory recorded 387 uploaded files. Their contents and sensitivity were not inspected, so the instance cannot be certified synthetic-only or safe to publish.
- The previously exposed local administrator password's private rotation remains `UNVERIFIED`.
- WooCommerce Stripe Gateway 11.1.0 is active, but its gateway is disabled and no Stripe account/options/webhook/payment configuration was recorded. No Live payment route was observed in that accepted readback.
- Existing local fulfillment/generation protections and backup hashes are retained from accepted evidence; they were not re-exercised.

These facts fail the Gate's required proof that the existing site contains no private/customer content and has a safe, reversible public HTTPS origin. Publishing the current site would also put its existing admin surface behind a new public hostname while the prior credential rotation is unverified. The safe route is a separate empty test installation; do not copy its users, orders, photos/uploads, database, source credentials, or old administrator credential.

~~~text
LOCAL_8189_CANONICAL_URL=LOOPBACK_HTTP
EXISTING_ORDERS=1_REUSED_EVIDENCE
PRIOR_RESTORE_UPLOAD_FILES=387_REUSED_EVIDENCE_CONTENTS_NOT_INSPECTED
ADMIN_PASSWORD_ROTATION=UNVERIFIED
ORIGINAL_SITE_SAFE_TO_PUBLISH=NO
FRESH_SYNTHETIC_STACK_REQUIRED=YES
~~~

## Cloudflare readback

~~~text
OWNER_SCREENSHOT_DOMAIN_LIST_IN_MAIN_HANDOFF=spikersun.com (OWNER_REPORTED_ONLY)
ZONE_ACTIVE_OR_AUTHORIZED=UNKNOWN
ZONE_WRITE_PERMISSION=UNKNOWN
stripe-test.spikersun.com=PROPOSED_ONLY_NOT_CREATED
EXISTING_DNS_RECORD_OR_TUNNEL_CONFLICT=UNKNOWN
TUNNEL_CONTROL_AVAILABILITY=UNKNOWN
~~~

No Cloudflare DNS, Tunnel, token, cookie, credential, or account setting was read or changed.

## Concrete next design — proposal only

After Reviewer acceptance and the exact future Owner authorization, create a fresh local-only Docker WordPress/WooCommerce test stack using synthetic fixtures only, with a candidate loopback origin `http://127.0.0.1:8190`. Port availability and stack compatibility remain to be checked before creation. Keep the existing 8189 project, database, credentials, and media untouched. The isolated test database should contain one virtual USD 39.99 product and only synthetic orders; generation and real fulfillment remain disabled. Use a new unique Owner-managed test administrator credential, never the old credential.

Candidate public hostname: `stripe-test.spikersun.com`, only if Owner confirms the `spikersun.com` zone is active/authorized and a read-only check proves the hostname has no conflicting record. Do not pick another domain automatically.

Candidate named-Tunnel ingress (not run; placeholders are intentionally non-secret):

~~~yaml
tunnel: <owner-created-named-tunnel-id>
credentials-file: <private-cloudflared-credentials-path>
ingress:
  - hostname: stripe-test.spikersun.com
    service: http://127.0.0.1:8190
  - service: http_status:404
~~~

Use one dedicated named Cloudflare Tunnel with only this hostname, no Quick Tunnel URL, router port-forwarding, VPS, Cloudflare Pages, or apex DNS change. TLS terminates at Cloudflare; the tunnel reaches the isolated origin over loopback HTTP. The new test site's `home` and `siteurl` must both be `https://stripe-test.spikersun.com`. Configure and verify trusted forwarded-HTTPS detection before OAuth; verify redirects, secure login cookies, checkout, and OAuth return from the public HTTPS origin. Do not change the canonical URL of the existing 8189 site.

Do not put Cloudflare Access, interactive authentication, bot challenges, or caching over the entire hostname: anonymous checkout and Stripe's unauthenticated signed webhook must remain reachable. Protect admin/private routes selectively, but validate the official Stripe OAuth return route before enabling a policy that could block it. The webhook endpoint must remain exactly `https://stripe-test.spikersun.com/?wc-api=wc_stripe`, bypassing interactive Access/challenge/cache while preserving normal plugin signature verification.

## Later bounded TEST validation and rollback

Owner privately completes the official WooCommerce Stripe TEST-mode OAuth flow in the supported admin UI; no keys or signing secrets are requested or recorded. Verify the official plugin's automatically registered TEST webhook in Stripe and Woo settings. Only after public host, TLS, origin, admin boundary, guest checkout, and callback paths pass, the later authorized Gate can run a single synthetic USD 39.99 order, authentic signed first event, exact replay/idempotency check, invalid-signature rejection, and one corresponding TEST refund with entitlement revocation. These are future acceptance checks, not results of G3S4J.

Keep the laptop and Docker host awake for delivery/retries during that later bounded test. Rollback is to disable the dedicated Tunnel, remove only the exact test DNS record if one was created and separately authorized, return the isolated test site to loopback/private mode, disable its gateway, disconnect only its TEST OAuth/webhook through supported controls, and restore its synthetic-only snapshot if needed. Leave 8189, PayPal, production/apex DNS, and all VPS resources untouched.

**Next Owner boundary after Reviewer acceptance:** one explicit, named scope for `stripe-test.spikersun.com`, creation of a dedicated named Tunnel and its exact DNS route, temporary public exposure of the fresh synthetic-only local test site, and the already bounded Stripe TEST OAuth/order/webhook/refund validation on that host. Owner handles Cloudflare and Stripe account login/consent privately. The current read-only request does not authorize any of those writes.

## Boundary

No tunnel or DNS record was created, no site was publicly exposed, no WordPress settings/database/plugin status was changed, no Stripe account was connected, and no payment, webhook, replay, refund, deployment, VPS access, backup, restore, or PR merge occurred.

Official source references already recorded in the Gate/Reviewer route:

- https://developers.cloudflare.com/tunnel/get-started/
- https://developers.cloudflare.com/tunnel/concepts/routing/
- https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/
- https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
- https://developer.woocommerce.com/docs/code-snippets/ssl_and_https_and_woocommerce_websites_behind_load_balanacers_or_reverse_proxies/

STOP_AT_REVIEWER=YES
