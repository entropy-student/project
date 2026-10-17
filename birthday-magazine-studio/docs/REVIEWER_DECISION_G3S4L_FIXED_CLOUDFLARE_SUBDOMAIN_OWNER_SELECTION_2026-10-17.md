# G3S4L Reviewer — Owner selects a fixed Cloudflare hostname

Date: 2026-10-17
Owner: "直接用一个固定域名吧。"
Authority: canonical `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7; most recent explicit Owner direction overrides the formerly proposed Quick Tunnel research option, not the security/Secret/real-host guards.
PR #64 latest G3S4L Evidence head at decision time: `bb04c27ba0dca4dd3ea081f265bdedf852090106`, open/unmerged.

## Binding decision (current active route)

```text
ROUTE=OWNER_FIXED_CLOUDFLARE_SUBDOMAIN
CANDIDATE_EXACT_HOST=stripe-test.spikersun.com
OWNER_HOST_SELECTION=FIXED_HOST_REQUIRED;CANDIDATE_FROM_REPEATED_PRIOR_DESIGN
ZONE=spikersun.com_OWNER_REPORTED_ACTIVE;WRITE_PERMISSION_UNVERIFIED
DNS_RECORD_COLLISION=OWNER_REPORTED_FREE;PROVIDER_READBACK_PENDING
TUNNEL_MODEL=OFFICIAL_NAMED_REMOTELY_MANAGED_CLOUDFLARE_TUNNEL
TUNNEL_OR_DNS=NOT_CREATED
ORIGIN=EXISTING_OWNER_WINDOWS_WORDPRESS_HTTP_127.0.0.1_8189
CLOUDFLARE_QUICK_TUNNEL=NOT_SELECTED;DO_NOT_RUN
WORDPRESS_COM_NETLIFY_OR_VPS=NOT_SELECTED
APPDATA_WRITES=HOLD_PENDING_NORMAL_OWNER_WINDOWS_PATH_PROVENANCE
G3S4L_NEW_EMPTY_CONNECTOR_TOKEN=EXECUTOR_REPORTED;REAL_NATIVE_HOST_PATH_UNVERIFIED
STRIPE_TEST=NOT_CONNECTED_OR_TESTED
PRODUCTION_LIVE_REAL_CHARGES=PROHIBITED
PR64=OPEN_UNMERGED
```

**Clarification:** `stripe-test.spikersun.com` is the sole preferred dedicated FIXED test subdomain, not a public URL already shown to work. No root `spikersun.com` DNS or unrelated site should be changed. The Owner's message chooses **fixed rather than ephemeral**; it does not mean that Cloudflare DNS write permission, hostname availability, valid TLS, public-private access boundaries, OAuth success or Stripe account consent have already been verified. Record exact provider readback. If this exact candidate is occupied or zone is not eligible, stop with one clear change-choice for Owner rather than invent another name.

## Immediate Codex contract — no unnecessary backtracking

1. Retain the accepted **pre-publication privacy** results (43 raster reviewed, 20 SVG, Woo private/order/admin anonymous negative probes) and Owner-reported previous WP admin password rotation. Do not rescan/reinstall/rebackup.
2. **First fix the actual location proof:** §11B Windows packaged-app `%LOCALAPPDATA%` redirection risk. The previous G3S4L PR Evidence claims a 0-byte token file and helper were written under `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4L\remote-managed-tunnel-20261017`, but there is no independent same-file normal-Owner-shell readback. Check the exact ordinary path and `Packages\OpenAI.Codex_*\LocalCache\Local\...` counterpart **read-only**, plus actual signed `cloudflared` EXE location. Do not classify those files as missing or installed on Owner's real path based on the packaged shell alone. Do not create further AppData files, copy/delete/migrate unknown objects or enter an actual token until provenance verified.
3. For any future project nonsecret binary/config, prefer an Owner-visible **verified actual Windows ordinary project tools path**, outside app package virtualization and outside protected Git/caches. For the eventual named-Tunnel scoped connector token, use a **separately verified Owner-private secure local location**, not an unverified AppData path or Git worktree; retain restricted ACL and a documented rollback/recovery model. Zero-byte old token-file is **not** a usable credential.
4. Use **official dashboard-created remotely managed named Cloudflare Tunnel**; candidate route `https://stripe-test.spikersun.com` → `http://127.0.0.1:8189`, with only this test subdomain and a dedicated connector. Cloudflare dashboard can create its DNS route when publishing an application. Do not repeat prior interrupted `cloudflared tunnel login` or bypass Codex Computer Use failed active-URL safety check using alternate browser automation. Once zone write and account authorization verified through a supported authorized channel, Codex handles all non-secret runnable setup. Owner should have **one consolidated Cloudflare permission/connector token checkpoint** only if the account cannot be handled through an already-authorized connection. Never collect secrets in chat/PR/ordinary logs, argv, env or the agent transcript.
5. Keep the original WP `home/siteurl=http://127.0.0.1:8189` until fixed HTTPS route and tested rollback exist; migrate only the original site in a bounded reversible step to `https://stripe-test.spikersun.com` with forwarded HTTPS trust and admin/login/cookie/checkout/proxy checks. Immediately after internet publication prove actual external negative access to private Woo orders/uploads/auth, and keep native signed `/?wc-api=wc_stripe` POST available without blanket Cloudflare Access/interactive captcha/caching.
6. After **verified fixed HTTPS site**, Owner privately consents to supported Woo Stripe **TEST-only** OAuth; Codex verifies one USD 39.99 synthetic Woo order, signed first/replay/invalid Webhook and one corresponding TEST refund and entitlement revocation within the existing Gate's payment bounds. No real/Live money, no repeat after ambiguous result.
7. Append sanitized current-state Evidence to the existing G3S4L PR64 Evidence and stop at Reviewer at the next material boundary. **Do not start Quick Tunnel even as a diagnostic**, since Owner explicitly prefers a fixed hostname.

## What this is not

No new WordPress, no WordPress.com subscription, no VPS, no static Netlify replacement, no disclosure/reuse of an exposed password, no transfer of Cloudflare token into Codex conversation, no automatic resurrection of empty AppData scaffolding, no overwrite of active DNS, no PR merge. A Cloudflare fixed name only remains reachable while Owner Windows + Docker + cloudflared are running.

Official sources:
- https://developers.cloudflare.com/tunnel/get-started/
- https://developers.cloudflare.com/tunnel/concepts/routing/
- https://developers.cloudflare.com/tunnel/reference/tunnel-tokens/
