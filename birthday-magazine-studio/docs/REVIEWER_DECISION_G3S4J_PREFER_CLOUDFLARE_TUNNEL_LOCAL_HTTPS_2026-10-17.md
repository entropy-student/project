# Reviewer decision — prefer Owner-local WordPress + Cloudflare Tunnel over paid WordPress.com

Date: 2026-10-17
Owner direction: "先部署在我自己的电脑或者用cloudflare不行吗，我的域名就是在上面买的。"
Governance: entropy-student/spike.skill/main/vps-project-governance/VNEXT.md v0.2.7; specialists 11B/11C/11D/11E
Parent: G3S4H discovery PASS @ PR #64 head b0a2e7cd0d2488fde87eb9f0db4f3b20738394bf
Actions this Reviewer round: official Cloudflare + WooCommerce documentation verified, main documentation only. No Cloudflare/DNS/host/provider/WordPress write.

## Decision

```text
REVIEWER_ROUTE=OWNER_LOCAL_WINDOWS_DOCKER_WP_VIA_CLOUDFLARE_NAMED_TUNNEL_PUBLIC_HTTPS
DEFAULT_EXTRA_HOST_SUBSCRIPTION=NONE
WORDPRESS_COM_BUSINESS_USD40_OPTION=DEFERRED_NOT_REQUIRED
WORDPRESS_COM_PERSONAL_USD9_OPTION=DEFERRED
CURRENT_TECHNICAL_GATE=G3S4J_CLOUDFLARE_TUNNEL_LOCAL_TEST_DESIGN_AND_SAFETY_PREFLIGHT
EXACT_OWNER_CLOUDFLARE_ZONE_SUBDOMAIN=NOT_YET_INDEPENDENTLY_VERIFIED
PUBLIC_DNS_TUNNEL_ROUTE_CREATED=NO
LOCAL_WP_URL_OR_DB_MODIFIED=NO
STRIPE_CONNECTED_OR_PAYMENT_TESTED=NO
CURRENT_LOCAL_WOO_STRIPE_PLUGIN=ACTIVE;PAYMENT_GATEWAY_DISABLED;SETTINGS_ABSENT
OWNER_PUBLIC_HOSTNAME_AND_TEMPORARY_PUBLICATION_SCOPE=NOT_YET_AUTHORIZED_BY_QUESTION
OWNER_PRIVATE_LOCAL_WP_PASSWORD_ROTATION=UNVERIFIED
LIVE_PAYMENT=PROHIBITED
VPS=OUT_OF_SCOPE
PR64=OPEN_UNMERGED
```

**Correction:** Previously passing G3S4H `WordPress.com Business` plan discovery does not mean buying a $40/month WordPress host is necessary. The user already operates a local Windows/Docker WordPress 7.1.1/WooCommerce 11.1.2 at 127.0.0.1:8189 and owns a domain on Cloudflare. Official Cloudflare Tunnel supports binding a stable hostname in an existing Cloudflare zone to a private local HTTP service via an outbound cloudflared connector without opening router ports. Cloudflare Tunnel publishing does not require an additional paid hosting subscription (normal domain registration/renewal and possible optional paid security extras are separate).

The correct intended path is **Cloudflare-managed public HTTPS hostname -> Cloudflare Tunnel -> private local WordPress**, then WooCommerce Stripe official TEST OAuth on a publicly reachable and WordPress-recognized HTTPS site, then official provider-created TEST webhook `https://<approved-host>/?wc-api=wc_stripe`. Cloudflare Tunnel **alone does not prove** Woo OAuth/Stripe callback compatibility: verify exact stable HTTPS host, origin mapping, WordPress `home/siteurl` and HTTPS reverse proxy handling, cookies/nonce/login, guest checkout, signature POST and actual external reachability *before* provider Test connection.

## Direct existing instance vs local synthetic clone

- **Preferred minimal operational effort:** reuse existing running 127.0.0.1:8189 only if pre-publication data/security inspection proves no private pictures, customer records, admin secrets, debug/plugin routes or other sensitive content become publicly accessible, no Live/other-provider channels enabled, and the exact WordPress URL/base-host change is reversible with verified same-runtime readback. Keep current protected project backups and do not repeat prior full restores.
- **Conditional safer local alternative:** if the original 8189 instance contains any non-synthetic data or its canonical URL must be preserved, create a minimal **separate localhost Docker WordPress/Woo test instance** using synthetic data, isolated DB/ports/auth and only the known compatible official plugin plus the virtual $39.99 fixture, and publish **only that** instance. Do not copy real orders/photos/users/admin credentials or expose both environments. Such creation is a later specifically authorized host mutation, not part of read-only design.
- No Cloudflare Pages/Workers static deployment as a replacement for PHP WordPress/Woo backend. No Stripe CLI local listener-secret injection needed: standard official Test OAuth produces normal account-created Test webhook at stable HTTPS site. No WordPress.com purchase, public VPS, ad hoc trycloudflare ephemeral URL or router port-forwarding.
- Cloudflare Zero Trust/Access applied to the entire hostname will normally prevent Stripe's unauthenticated webhook and anonymous checkout. Protect admin/login with properly tested, selective security controls; leave signed webhook route externally reachable and able to POST without interactive auth/bot challenge. Public route potentially exposes all current published pages; robots `noindex` is not access control. Before publication verify a synthetic-only exposure inventory, admin auth/2FA and test-only gateway.
- WordPress behind reverse proxy must correctly detect HTTPS from forwarded proto (with trusted proxy handling), prevent redirect loops/mixed content, and use the intended HTTPS hostname for OAuth return/cookies. Woo official reverse-proxy docs: https://developer.woocommerce.com/docs/code-snippets/ssl_and_https_and_woocommerce_websites_behind_load_balanacers_or_reverse_proxies/ .
- Local Windows must stay running with Docker and cloudflared connected for Stripe callback/retries; a laptop sleeping/offline will interrupt webhook delivery. This is for TEST, not suitable proof of 24/7 production uptime.
- The previously exposed local administrator password rotation remains UNVERIFIED. Before any public route or credential reuse, Owner privately rotates; no old/new password/token to chat, GitHub or agent logs.
- Exact Cloudflare domain/zone and DNS record are not yet independently inspected. User says their domain was purchased via Cloudflare, but do not guess its name or assume DNS zone privileges. Choose a dedicated test subdomain with Owner in Cloudflare account UI; no change to apex/production DNS.

## Official source basis

- Cloudflare named Tunnel setup: https://developers.cloudflare.com/tunnel/get-started/
- Cloudflare published application mappings to localhost / DNS record: https://developers.cloudflare.com/tunnel/concepts/routing/
- HTTPS local origin protocol support: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/routing-to-tunnel/protocols/
- Woo Stripe OAuth needs HTTPS and public reachability: https://woocommerce.com/document/stripe/setup-and-configuration/connecting-to-stripe/
- Woo Stripe automatic webhook configuration and route: https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
- Woo WordPress reverse proxy HTTPS requirements: https://developer.woocommerce.com/docs/code-snippets/ssl_and_https_and_woocommerce_websites_behind_load_balanacers_or_reverse_proxies/

## Immediate next boundary

Current next Gate: `docs/G3S4J_CLOUDFLARE_TUNNEL_LOCAL_STRIPE_TEST_DESIGN_GATE_2026-10-17.md`. It authorizes **no Cloudflare DNS/public ingress write yet**, only minimal read-only compatibility/domain/source exposure inspection and a precise single implementation proposal. Given the user's strong preference, do not initiate another paid-host discovery or repeat already accepted runtime/backup/CLI work.

The prior G3S4I WordPress.com paid hosted Gate is **shelved / superseded for active planning**, not deleted from history. Before publishing a new Cloudflare public hostname, Owner must explicitly authorize the named public test hostname and temporary synthetic-only exposure (and Owner-controlled Cloudflare credential checkpoint), not a new hosting purchase. After that, execute bounded Cloudflare Tunnel test route and normal Woo Stripe TEST OAuth/payment under a separate reviewed write scope. No Live/real buyer, no public site before URL and security verification.
