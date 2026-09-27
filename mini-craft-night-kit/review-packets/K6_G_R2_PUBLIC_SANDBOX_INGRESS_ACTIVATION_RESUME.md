# K6 Phase G-R2 — Public Sandbox Ingress Activation Resume

Gate:
K6_PHASE_G_R2_PUBLIC_SANDBOX_INGRESS_ACTIVATION_RESUME

Owner authorization remains valid:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R1_R1R1_PASS_G_R2_PUBLIC_SANDBOX_INGRESS_RESUME.md
- latest accepted Evidence/Handoff
- unique Shared VPS Handoff

## Goal

Resume the already-authorized Phase G transaction now that the authenticated Cloudflare Dashboard DNS path is qualified and persisted.

## 0 — Cloudflare prewrite check

Using the same already authenticated official Dashboard session:

- open spikersun.com
- DNS -> Records
- exact minicraft.spikersun.com
- require A/AAAA/CNAME absent

Require:
CLOUDFLARE_SESSION_PREWRITE=PASS

If login/2FA is requested:
RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED

No VPS write before PASS.

## 1 — fresh target reconciliation

Strict direct-native SSH.

Require:
- ops@srv1970241
- durable Caddyfile SHA frozen baseline
- active config SHA frozen baseline
- edge-test accepted fingerprint
- Mini Craft active route absent
- WordPress running
- MariaDB healthy/private
- edge -> wordpress:80 private reachability

Drift -> RETURN before writes.

## 2 — fresh PPCP safety

Fresh application readback must prove:
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO

No credentials emitted.

Failure -> RETURN before writes.

## 3 — Caddy rollback backup

Copy only /srv/infra/edge/Caddyfile to a dated backup under:

/srv/backups/mini-craft-night-kit/manifests/

Verify backup SHA equals:
12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

Record exact path.

## 4 — sealed candidate recheck

Rebuild/canonicalize exactly as F-R1R5R4.

Require:
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Require warning-free valid adapt and semantic parity.

Mismatch -> RETURN before Caddyfile mutation.

## 5 — atomic Caddyfile write

Preserve current owner/group/mode.

Write exact canonical bytes to same-filesystem temp.
Verify SHA.
Apply metadata.
Atomic rename over /srv/infra/edge/Caddyfile.
Verify final SHA.
Remove/verify temp absent.

On failure restore backup and RETURN.

## 6 — reload only

Validate written config.

Perform zero-downtime Caddy reload only.
Never restart/recreate.

If clear failure:
restore backup -> validate -> reload baseline -> prove localhost/edge-test restored -> RETURN.

If ambiguous due transport loss:
no blind retry; one bounded reconciliation readback is allowed.

## 7 — post-reload preservation

Before DNS:
- localhost PASS
- edge-test exact fingerprint PASS
- active Mini Craft route present
- private Host-header/SNI request reaches WordPress
- unrelated routes preserved
- MariaDB remains private
- Caddy restart count unchanged

Failure -> restore baseline/reload/verify and RETURN.

## 8 — indexing safety

Read current WordPress indexing state.

If already noindex/search-engine discouraged:
INDEXING_WRITE_REQUIRED=NO

If indexable:
- smallest WordPress-native write only
- expected blog_public 1 -> 0
- record pre/post state
- no content/product/payment changes

If write cannot be safely completed:
rollback Caddy and restore indexing pre-state if needed, then RETURN.

## 9 — Cloudflare pre-DNS check

Immediately before DNS creation re-open the official Dashboard path.

Require:
- session still authenticated
- spikersun.com zone accessible
- exact Mini Craft A/AAAA/CNAME still absent
- Add A record UI still available

Set:
CLOUDFLARE_SESSION_PRE_DNS=PASS

If session expired/login/2FA required:
- rollback Caddy baseline
- restore indexing pre-state if changed
- prove localhost/edge-test restored
- RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED_ROLLED_BACK

## 10 — exact DNS mutation

Create exactly one:

Type=A
Name=minicraft
FQDN=minicraft.spikersun.com
Target=2.24.193.133
Proxy=DNS only

Before Save verify exact tuple.

Save once.

No blind retry.

After Save:
- search exact hostname
- require exactly one A record
- target 2.24.193.133
- proxy DNS only
- no AAAA/CNAME

Record internal record ID if naturally surfaced; otherwise rollback selector remains exact zone/type/name/target.

## 11 — public readback

Require:
- authenticated Dashboard exact A record count=1
- public DNS A resolves 2.24.193.133
- no AAAA/CNAME conflict

## 12 — public Sandbox validation

Validate:
- HTTPS/TLS
- Home
- Shop
- Product 223
- Cart
- Checkout accepted rendering/redirect semantics
- My Account
- wp-json
- required media
- WooCommerce
- PPCP active/connected/Sandbox YES/Live NO

Do not place an order or initiate any payment/auth/capture/refund/webhook money-flow test.

## 13 — rollback

Material failure after DNS creation:

1. locate exact Mini Craft A record by exact tuple
2. delete only that record
3. prove Mini Craft A/AAAA/CNAME absent
4. restore pre-G Caddyfile backup
5. validate/reload baseline
6. prove localhost + edge-test restored
7. restore indexing pre-state if changed
8. keep WordPress/MariaDB private runtime intact

Any ambiguous Save/Delete/Reload:
reconcile before acting; no blind retry.

## Success

PASS_CANDIDATE_K6_PHASE_G_R2_PUBLIC_SANDBOX_INGRESS_ACTIVATION_RESUME

Return:
OWNER_AUTHORIZATION=AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION
DNS_EXECUTION_PATH=PASS_AUTHENTICATED_CLOUDFLARE_DASHBOARD
CLOUDFLARE_SESSION_PREWRITE=PASS
REMOTE_IDENTITY=ops@srv1970241
PREWRITE_DURABLE_CADDY_SHA=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
PREWRITE_ACTIVE_CONFIG_SHA=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
PREWRITE_EDGE_TEST_FINGERPRINT=PASS
PREWRITE_MINICRAFT_ROUTE=ABSENT
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
CADDY_BACKUP_PATH=
CADDY_BACKUP_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CADDYFILE_ATOMIC_WRITE=PASS
CADDY_RELOAD=PASS_ZERO_DOWNTIME
POST_RELOAD_LOCALHOST=PASS
POST_RELOAD_EDGE_TEST=PASS
POST_RELOAD_MINICRAFT_PRIVATE_ROUTE=PASS
INDEXING_PRE_STATE=
INDEXING_WRITE_REQUIRED=
INDEXING_POST_STATE=
CLOUDFLARE_SESSION_PRE_DNS=PASS
DNS_RECORD_TYPE=A
DNS_RECORD_NAME=minicraft.spikersun.com
DNS_RECORD_TARGET=2.24.193.133
DNS_PROXY_STATE=DNS_ONLY
DNS_EXACT_RECORD_COUNT=1
DNS_ACTIVATION=PASS
PUBLIC_DNS_A=2.24.193.133
PUBLIC_TLS=PASS
PUBLIC_HOME=PASS
PUBLIC_SHOP=PASS
PUBLIC_PRODUCT_223=PASS
PUBLIC_CART=PASS
PUBLIC_CHECKOUT=PASS_ACCEPTED_SEMANTICS
PUBLIC_MY_ACCOUNT=PASS
PUBLIC_WP_JSON=PASS
PUBLIC_MEDIA=PASS
PUBLIC_WOOCOMMERCE=PASS
PUBLIC_PPCP_SANDBOX=PASS
PAYPAL_LIVE=NO
REAL_PAYMENT_ACTIONS=0
UNRELATED_ROUTES_CHANGED=NO
UNRELATED_DNS_CHANGED=NO
SHARED_INFRA_SCOPE=EXACT_CADDYFILE_ONLY
DNS_SCOPE=EXACT_ONE_A_RECORD_ONLY
PUBLIC_SANDBOX_INGRESS=ACTIVE
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES

## Forbidden

No credential/token/cookie/session-value inspection or output, Cloudflare account/security/token changes, unrelated DNS mutation, Caddy restart/recreate, cloudflared/UFW/Docker daemon/network/Compose mutation, MariaDB exposure, Secret access/output/hash/copy, PayPal Live or money movement, Soft Launch/ads, unrelated project/service mutation.
