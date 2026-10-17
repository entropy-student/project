# Reviewer decision — G3S4L media precheck accepted; eliminate duplicate CLI login

Date: 2026-10-17
G3S4L PR evidence HEAD: `f05d667c6f47eb43873695756cdffb485ac64aea`
PR #64 discussion: https://github.com/entropy-student/project/pull/64#issuecomment-6233227919
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, especially §§5–9 and 11B/11C/11E.
Reviewer operations: GitHub evidence plus Cloudflare **official** docs. No Cloudflare, Windows, WordPress or Stripe write has been executed by Reviewer.

## Review determination

```text
G3S4L_REVIEWER=PARTIAL_PASS_PREPUBLICATION_AUDIT_ONLY
EVIDENCE_COMMIT=f05d667c6f47eb43873695756cdffb485ac64aea
COMMIT_DELTA=ONLY_EXISTING_G3S4L_EVIDENCE_FILE
LOCAL_PUBLICATION_MEDIA_SENSITIVITY=PASS_CANDIDATE_LIMITED_TO_REVIEWED_OBJECTS
RASTER_REVIEW=43_VISUAL_CHECKS
SVG_REVIEW=20_STATIC_CHECKS
MEDIA_REST_ITEMS=63
MEDIA_UPLOAD_FILES=389_METADATA_ONLY_INCLUDING_VARIANTS_AND_PRIVATE
ANONYMOUS_PRIVATE_ORDER_ADMIN_CHECKS=PRIOR_READ_ONLY_PASS_CANDIDATE
OWNER_PRIVATE_WP_PASSWORD_ROTATION=OWNER_REPORTED_YES_NOT_INDEPENDENT_SECRET_READBACK
OFFICIAL_CLOUDFLARED_VERSION=2026_10_1_SIGNED_AND_STAGED_OWNER_LOCAL
OLD_CLOUDFLARED_TUNNEL_LOGIN=INTERRUPTED_EXIT_1_NO_AUTH_SUCCESS
CLOUDFLARE_ZONE_ACTIVE=OWNER_REPORTED_YES
CLOUDFLARE_CANDIDATE_DNS_UNUSED=OWNER_REPORTED_YES
TUNNEL_CREATION_OR_TOKEN=NOT_STARTED
CLOUDFLARE_ZONE_WRITE_PERMISSION=UNVERIFIED
PREFERRED_NEW_CONNECTION=REMOTELY_MANAGED_DASHBOARD_TUNNEL_WITH_PROTECTED_TOKEN_FILE
ORIGINAL_WORDPRESS_SITE=127_0_0_1_8189_PRESERVE
STRIPE_OAUTH_TEST_WEBHOOK_REFUND=NOT_STARTED
PR64=OPEN_UNMERGED
```

**PASS is limited:** Owner-local media check inspected the 63 REST-exposed images/assets (43 raster visually, 20 SVG statically) and reported no sensitive content; earlier protected Woo REST order, My Account, admin, private uploads and debug probes returned anonymous denial/login redirects. No sensitive media observed, plus Owner reported the site contains no private images. This **does not independently prove** every one of 389 filesystem upload assets, unlinked files, origin HTTP server paths, future published routes, or post-Tunnel public access is safe. Freeze earlier negative checks as accepted **prepublication candidates**, run only exact public-facing negative smoke after the Tunnel goes live; don't repeat 43+20 media audit or original G3S4J checks without changed data. The latest appended update in the Evidence supersedes its earlier `MEDIA_PIXEL_REVIEW=UNKNOWN` and `RETURN_PUBLICATION_SAFETY_NOT_CERTIFIED` interim blocks.

Owner reported that the previously exposed original WP admin credential **was privately rotated**, without disclosing its value. Accept as `OWNER_REPORTED_YES`; don't misreport as independently proven but don't ask Owner to repeat rotation or password reveal. If an actual password/authorization issue is discovered, scope that as a new specific failure domain.

## Interaction friction classification

The official `cloudflared tunnel login` attempted **locally-managed Tunnel** administration and paused at a separate browser approval/link. Owner objected to this extra terminal login workflow while already signed in to the Cloudflare dashboard and requested a Reviewer assessment. Stopping the process before authorization and revoking the request to continue in that round was correct. Signed official `cloudflared` v2026.10.1 has already been staged on Windows; **do not redownload, reinstall, rerun `cloudflared tunnel login`, repeat media review or require a second full browser account login**. The previous Computer Use active-URL-confidence safety failure must not be bypassed by another browser automation engine.

Cloudflare supports an independent, official lower-friction model:
1. **Remotely-managed named Tunnel created in the already signed-in Cloudflare dashboard**, `Networking > Tunnels > Create a tunnel`, with its dedicated public hostname route (dashboard normally creates the corresponding DNS record). This is a normal Owner-controlled account operation, without `cloudflared tunnel login` / downloaded account-wide `cert.pem`.
2. Its connector needs only a **scoped tunnel run token**. Official run parameters support `cloudflared tunnel run --token-file <PRIVATE_FILE_PATH>` from 2025.4.0 onwards, including already staged 2026.10.1. The credential must be inserted **by Owner privately in the local host environment**, into one protected file whose ACL confines read access to intended current user/process and SYSTEM, not chat/Codex/command argv/env/repo/temp files or logs. CLI should accept a **path only**, never `--token ACTUAL_TOKEN`. Validate locally installed `run --help` before use, no claim that token-file is tested already.
3. The Owner has to **authorize creation of a Tunnel and privately provide its connector token to the trusted host** at least once; an existing Cloudflare browser session by itself does not grant `cloudflared` unattended account-wide access. There is no policy-compliant fully silent OAuth or generic browser-automation bypass. Avoid repeatedly requesting the same account approval. If Owner is not willing to perform the minimum Owner-controlled credential action now, leave Cloudflare writes **PENDING** with completed local preparation; no new RETURN/research loop.
4. The exact proposed Cloudflare zone is `spikersun.com` and DNS hostname `stripe-test.spikersun.com`, Owner-reported Active/unused but not verified for *write*. Before making DNS/Tunnel changes, use native dashboard error-free create/readback or a direct Owner manual control-plane confirmation; do not overwrite any other record/zone or assume permissions based on listing.
5. Exact ingress is `stripe-test.spikersun.com` HTTPS to `http://127.0.0.1:8189`, only with original WP private/admin/media readiness, reversible `home/siteurl` and reverse-proxy HTTPS trust, and temporary TEST-only exposure. Existing PR64 Gate Owner publication direction covers choosing this target; Owner's explicit stop applies to **further account actions this round**, not permission to silently continue Cloudflare auth.

Official sources:
- https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/get-started/create-remote-tunnel/
- https://developers.cloudflare.com/tunnel/reference/run-parameters/ (remotely-managed `--token-file`)
- https://developers.cloudflare.com/tunnel/concepts/routing/ (dashboard publishes hostname and DNS record)
- https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/configure-tunnels/remote-tunnel-permissions/ (token grants connection, protect it)

## Next bounded Executor scope (reuse existing G3S4L, no new full Gate)

**G3S4L-PREP only, without Owner action:** verify installed `cloudflared 2026.10.1` normal help for `--token-file` and exact host/Owner-user secret-storage ACL contract; prepare a small, reproducible one-Owner-interaction checklist on `Networking > Tunnels` and the private connector-token-file transfer, and preflight only existing WP reverse-proxy URL/rollback read-only. No secrets, no Tunnel/DNS/WordPress writes, no public data, no Stripe or login wait, no other host/VPS and no new WordPress. Reuse accepted media/privacy checks and original backups.

If Owner later wants to finish and verifies the scoped candidate hostname, they perform the minimum Cloudflare dashboard remote-Tunnel creation/approval and private connector credential entry themselves **only after the exact public-safety and rollback preconditions**. Executor may then run the connector with the path-only token-file, validate TLS/domain/callback/admin/private media, and proceed to official Owner-only Woo Stripe TEST account/oauth/payment canary only within the existing authorized TEST scope, with Reviewer stop on material boundary. Do not claim this has occurred.

**Evidence/reporting:** If preparing new Executor evidence, append to the **same existing** PR64 `docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md` once, minimal sanitized proof of `--token-file` support and protected-path prep, then STOP Reviewer only if preparation itself uncovered a material blocker. The current Executor burden escalation can be Reviewer-accepted without requiring another full Codex round before the Owner is ready.

**No new payment/provider write has been authorized by this Reviewer decision.** No demand that Owner paste Cloudflare authentication URL, tunnel token, password or Stripe key into conversation. Live/real payments, public VPS, paid WordPress.com, blanket Access wall in front of Woo checkout/Webhook, or blind merge PR64 are forbidden.
