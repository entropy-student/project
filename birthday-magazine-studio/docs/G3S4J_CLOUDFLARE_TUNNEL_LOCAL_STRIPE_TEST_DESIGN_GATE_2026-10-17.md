# G3S4J — Owner-local WordPress + Cloudflare Tunnel Stripe TEST staging (read-only design)

Date: 2026-10-17
Status: `READ_ONLY_SAFE_PREP_AUTHORIZED; PUBLIC_CLOUDFLARE_TUNNEL_DNS_AND_STRIPE_WRITES_NOT_YET_AUTHORIZED`
Reviewer route: `docs/REVIEWER_DECISION_G3S4J_PREFER_CLOUDFLARE_TUNNEL_LOCAL_HTTPS_2026-10-17.md`
Latest accepted PR #64: `b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf`, OPEN/unmerged.
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, 11B/11C/11D/11E.

## Current Gate

```text
GATE_ID=G3S4J_CLOUDFLARE_TUNNEL_LOCAL_STRIPE_TEST_DESIGN_20261017
GOAL=Confirm low-cost local Docker WP + stable Cloudflare HTTPS subdomain for official Woo Stripe TEST OAuth and authentic provider webhook without buying WordPress.com or using VPS
LOCAL_SOURCE=127.0.0.1:8189_WP_7_1_1_WOO_11_1_2_OFFICIAL_WOO_STRIPE_11_1_0_ACTIVE_GATEWAY_DISABLED
OWNER_CLOUDFLARE_ZONE_DOMAIN=EXISTS_BY_OWNER_REPORT_BUT_EXACT_ZONE_UNVERIFIED
HOST_PUBLICATION=NOT_AUTHORIZED
DNS_TUNNEL_CREATION=NOT_AUTHORIZED
WP_SETTINGS_DB_OR_SOURCE_MUTATION=NOT_AUTHORIZED
PROVIDER_STRIPE_OAUTH_OR_WEBHOOK_PAYMENT=NOT_AUTHORIZED_FOR_PUBLIC_ROUTE
OWNER_PRIVATE_WP_ADMIN_PASSWORD_ROTATION=UNVERIFIED
PR64_MERGE=NO
NEXT=SAFE_READ_ONLY_CHECK_AND_ONE_CONCRETE_PUBLIC_TUNNEL_DEPLOYMENT_PROPOSAL
MANDATORY_REVIEW_STOP=YES
```

## Read-only checks, one narrow pass

1. Read main authoritative Handoff, current Reviewer Cloudflare route, G3S4M local plugin status and accepted prior runtime/backup evidence. Do not repeat full host scans, ZIP CLI installation or password resets.
2. Verify **non-secret** Cloudflare domain zone ownership/control using an available read-only method when possible; else report `CLOUDFLARE_ZONE_OWNER_REPORTED_ONLY` and instruct Owner to select the exact zone/subdomain later in their Cloudflare dashboard. Do not fetch or expose Cloudflare API key/tunnel token.
3. Inspect existing local WordPress 8189 **safely and narrowly** for personal records/media, live gateways, anonymous private/plugin routes, admin credential exposure and whether canonical `home/siteurl`/Woo callback cookies support temporary public HTTPS route without mutating original data. Report a simple `USE_EXISTING_8189_WITH_REVERSIBLE_URL` or `USE_FRESH_MINIMAL_SYNTHETIC_LOCAL_STACK` decision with exact grounds. No content or secret output.
4. Verify expected Cloudflare Tunnel service mapping design: one dedicated stable hostname in approved Owner Cloudflare zone -> `http://127.0.0.1:8189` **only if existing site passes security check**, else new test-only localhost port chosen later; never publish existing WordPress admin/media without reviewed access boundary. Only official named Tunnel, no trycloudflare random URL, no router firewall/port forwarding, no VPS, no Cloudflare Pages static replacement.
5. Define WordPress `home/siteurl` consistency and HTTPS forwarded-proxy handling; ephemeral public and localhost URLs are different site origins, so validate nonbreaking reversible strategy. Do not blindly change original DB; if reverse-proxy/URL changes would break original local project or leak content, select isolated synthetic stack. Define public TLS/callback, guest checkout, admin/private negative access, bot/challenge/cache bypass on signed `/?wc-api=wc_stripe` and OAuth return. Cloudflare Access login wall on whole site blocks webhooks, so do not use it on the webhook unless a supported path bypass is specifically validated.
6. Spell out minimal official Woo Stripe normal TEST-mode OAuth and Stripe account-side automatic endpoint path, authenticated provider webhook first/replay/invalid, one $39.99 synthetic order and one bounded TEST refund/revoke; Owner manages Cloudflare/Stripe login privately. Distinguish source compatibility from proven runtime.
7. Define public-route stop/rollback, tunnel off + Cloudflare DNS cleanup approved by Owner, WordPress canonical URL restoration if changed, no unreviewed site/domain/Provider deletion; local laptop stays on until callback settlement. Owner-private rotation of compromised local WP admin password **must be confirmed before new public route**, no values or hashes collected.
8. Give Owner one clear next approval boundary: exact test subdomain, temporary internet publication with synthetic-only site, cloudflared tunnel creation, and one existing bounded Stripe TEST OAuth/payment/refund scope applied to approved tunnel host. Owner asking whether Cloudflare is possible is **not by itself** proof of approval to publish content or manipulate DNS.

## STOP / evidence

Do not create any Cloudflare tunnel, DNS record, local hosting/WordPress option, Docker stack, Stripe OAuth login, signing secret, test order, or payment in this read-only gate. No paid WordPress.com, no VPS. After read-only inspection update only one sanitized `birthday-magazine-studio/docs/evidence/g3s4/G3S4J_CLOUDFLARE_LOCAL_HTTPS_STAGE_2026-10-17.md` to PR #64 branch and stop Reviewer, or if project scope cannot be verified, record `RETURN_CLOUDFLARE_DOMAIN_OR_LOCAL_PUBLICATION_SAFETY_UNKNOWN` precisely. The later public route and provider write Gate requires named Owner consent; do not ask another generic permission or repeat predecessor discovery.

## Source references

- https://developers.cloudflare.com/tunnel/get-started/
- https://developers.cloudflare.com/tunnel/concepts/routing/
- https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/
- https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
- https://developer.woocommerce.com/docs/code-snippets/ssl_and_https_and_woocommerce_websites_behind_load_balanacers_or_reverse_proxies/
