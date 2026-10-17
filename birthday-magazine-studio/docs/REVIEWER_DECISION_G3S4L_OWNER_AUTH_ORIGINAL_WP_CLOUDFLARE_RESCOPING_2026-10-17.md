# Reviewer decision — Owner directs original 8189 WordPress publication via Cloudflare, not a new clone

Date: 2026-10-17
Owner current instruction: “原网站可以公开继续走cloudfare的方案。无法识别的原因是什么？我已经在内置浏览器里打开了，这不足够吗？”
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, §§5–9, 11B/11C/11D/11E.
PR #64 latest reviewed Evidence @ `9461d5c5f8fa3c7b1bb570dc8f2f810e9bf67956`; open/unmerged.
This Reviewer writes only project GitHub docs; no actual Owner browser, Cloudflare or Windows/WordPress/provider action.

## Latest Owner-scope override

```text
CURRENT_OWNER_ROUTE=ORIGINAL_WINDOWS_DOCKER_WORDPRESS_127_0_0_1_8189_VIA_CLOUDFLARE_NAMED_TUNNEL
OWNER_PUBLIC_ORIGINAL_SITE_DIRECTION=YES
NEW_ISOLATED_LOCAL_WP_STACK=DEFERRED_NOT_REQUIRED_BY_OWNER
PREVIOUS_G3S4K_NEW_STACK_GATE=SUPERSEDED_NO_EXECUTION
STRIPE_TEST_INTENT=CONTINUES_PREVIOUS_OWNER_TEST_ONLY_AUTH
PUBLIC_HOSTNAME_CANDIDATE=stripe-test.spikersun.com_NOT_YET_VERIFIED_OR_PUBLISHED
CLOUDFLARE_ZONE_DNS_TUNNEL_PERMISSION=UNKNOWN
COMPUTER_USE_ROOT_CAUSE=UNKNOWN_ACTIVE_URL_SAFETY_CHECK_FAILED
COMPUTER_USE_CLOUDFLARE_WRITES=NONE
ORIGINAL_8189_PRIVACY_AND_AUTH_READINESS=UNVERIFIED
PREVIOUS_EXPOSED_WP_ADMIN_PASSWORD_ROTATION=UNVERIFIED
NEW_WRITES_CURRENTLY_SAFE=NONE_UNTIL_PREPUBLICATION_CHECKS
NEXT_GATE=G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE
PAID_WORDPRESS_COM=NO
VPS=OUT_OF_SCOPE
LIVE_REAL_PAYMENT=NO
PR64=OPEN_UNMERGED
```

This latest explicit Owner direction replaces the Reviewer-preferred G3S4K *new isolated WP stack* design as the active route. Do not create a duplicate WordPress, database or compose project by default. Keep all accepted original 8189 Docker/Woo/site/product/PayPal/backup evidence; do not reset, wipe, re-import or repeatedly re-inspect already proved runtime invariants. The Owner's consent to publish their site establishes project direction, **but cannot prove that existing order/customer uploads/admin credentials are appropriate to expose publicly**. Actual anonymous access before launch must exclude private/order/media download content, all known exposed passwords must be rotated privately, and there must be a tested return to loopback-only. Sensitive data or active sensitive endpoints mean HOLD PUBLICATION pending a narrow containment (access control, private media route, credential rotation), not a forced architecture change.

## What the browser failure proves, and what it does not

Codex G3S4J Evidence says its Windows Computer Use capability could not identify the active browser tab URL with sufficient confidence to satisfy its URL safety check. Thus its attempted Cloudflare browse stopped before reading the page. The Owner-supplied screenshot clearly shows a Codex internal browser UI displaying `dash.cloudflare.com`, and the list of domain names including `spikersun.com`, but this **does not prove that Codex's Computer Use adapter can machine-bind to or verify the currently active controlled tab URL**. No further diagnostic (why URL determination failed: tool integration, active tab identity, browser focus/context etc.) has been established; do not claim a particular failure cause, Cloudflare rejection, wrong login, missing domain or user mistake.

Respect that tool's safe stop; do not use an alternate browser automation to evade the same safety check. A **separate authorized Owner-manual workflow** is acceptable: Owner navigates the existing Cloudflare UI and confirms the domain zone status, candidate unused DNS slot, and exact Tunnel route, or explicitly completes an official cloudflared browser-based `tunnel login` flow in the Owner session if safe and supported. Owner manual UI is **not** the failing Computer Use adapter, and does not require putting tokens/credentials in chat/terminal/PR. Executor may prepare/check local host and present one concise click sequence, and may use officially supported native `cloudflared` under a later reviewed scoped write boundary and private credential custody. Do not retry browser tool loops.

## Original WP public safety boundary before Tunnel

Evidence for the original instance: WordPress 7.1.1/Woo 11.1.2 + official Stripe 11.1.0 plugin active but gateway disabled/unconnected, one existing Woo order, 387 files in historical upload inventory with unknown content sensitivity, `home/siteurl=http://127.0.0.1:8189`, WordPress loopback host binding, previously exposed admin password with rotation UNVERIFIED. **Public Internet publication without inspection would risk exposing customer/admin content.**

A single narrowly scoped read-only prepublish audit must classify:
1. Woo order(s) + private attachments: ensure no actual user data becomes anonymously accessible, and no public REST API, media URL or Woo/my-account/download route discloses personal or customer content. Sanitize only the nature of risks; never print raw order/customer/user/media/password data.
2. WP admin: Owner independently rotates previously disclosed password and confirms only `ROTATED_YES`, or executes an approved narrow private rotation with Owner-only secret entry. Before successful rotation, **do not publish original site**. Original site admin and maintenance endpoints must remain authenticated and protected, without placing a blanket Access wall that blocks Stripe signed webhook or buyer checkout.
3. External URL correctness: plan reversible `home/siteurl` to Owner-approved stable HTTPS subdomain, forwarded proto/trusted proxy handling, login redirect/cookies/nonce, admin, public checkout, WordPress AJAX/rest and Woo Stripe OAuth return. Do not leave loopback-origin canonical URL when attempting provider onboarding. Prove reverse and forward routing with actual external readback before declaring PASS. Save prewrite readback for restoration.
4. DNS/tunnel: prove actual active Owner zone/permissions and no existing candidate `stripe-test.spikersun.com` record/tunnel conflict before writing; do not guess from screenshot. No apex or unrelated zone changes. Proposed native ingress only to `http://127.0.0.1:8189` using outbound-only Cloudflare Tunnel; no router port forward, no public exposure of DB or WordPress admin by bypass.
5. Signed `/?wc-api=wc_stripe` external POST must remain reachable without Cloudflare Access challenge, caching or bot interstitial; verify Woo official TEST-only account OAuth and signed first/negative/duplicate callbacks before claiming payment readiness. Owner does all Provider/Cloudflare authentication privately. No Stripe or Live writes in an unverified site.
6. Avoid exposing preexisting real customers/content without informed Owner scope; if anonymous/private-content negative checks cannot pass, STOP and recommend a specific containment or revert to isolated test only as a last resort. Owner saying "can publish" is not consent to arbitrary disclosure of third-party records.
7. Local Windows Docker plus Tunnel must remain running and awake for test webhook retries. This route is adequate for bounded TEST, not a production uptime guarantee.

## Immediate next step

`docs/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_GATE_2026-10-17.md` is the single combined gated project route. Begin with minimal no-write public safety/host URL and Cloudflare Owner-manual domain checkpoint, then only proceed to consequential DNS/Tunnel/WP settings/Stripe TEST writes if the exact verified named target, privacy/security/rollback checks and scoped Owner private actions are satisfied. The currently expressed Owner direction approves choosing the original site for Cloudflare publication; it is not proof of security readiness, domain ownership or authority to overwrite existing Cloudflare entries. Do not reask the Owner generic permission to continue their approved route, but do require accurate account/hostname selection and private credential rotation if not yet done. No new Docker/test stack or paid WordPress.com by default.

Next Executor: read only latest main Handoff top, this decision, current G3S4L Gate, PR64 G3S4J Evidence. Stop only at the material risk boundary, not because the previously failed Computer Use adapter cannot inspect the Owner's already-open tab. Keep PR64 open; sanitized evidence and Reviewer STOP.
