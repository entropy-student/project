# K6 Phase G — Public Sandbox Ingress Activation

Gate:
K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Owner authorization:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION_AUTHORIZED.md
- latest accepted Evidence/Handoff
- unique Shared VPS Handoff

## Goal

Activate the first bounded public Sandbox ingress for Mini Craft without enabling real commerce.

## Mandatory order

0. DNS execution-path preflight
1. fresh remote drift checks
2. fresh PPCP Sandbox/Live readback
3. Caddy rollback backup
4. rebuild exact sealed canonical candidate
5. atomic Caddyfile write
6. validate + zero-downtime reload
7. route preservation checks
8. indexing safety
9. exact DNS-only A record
10. public Sandbox validation
11. PASS or rollback

## DNS execution path preflight

Before any remote write, prove an existing authenticated DNS path can create/delete exactly one Cloudflare DNS record without exposing credential values.

Opaque authenticated use is allowed.
Reading/copying/logging an API token/password/cookie value is forbidden.

If unavailable:
RETURN_OWNER_DNS_EXECUTION_PATH_REQUIRED
and perform no Caddy/noindex/DNS write.

Require current minicraft.spikersun.com A/AAAA/CNAME absent.

## Fresh prewrite

Strict direct-native SSH.
Require ops@srv1970241.

Fresh exact baselines:
- durable Caddyfile SHA:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
- active config SHA:
  206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
- edge-test:
  200 / 30 bytes /
  2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- active Mini Craft route absent
- wordpress:80 private edge reachability PASS
- MariaDB private

Drift -> RETURN before writes.

## Fresh payment safety

Fresh authoritative non-secret app readback must prove:
- PPCP_ACTIVE=YES
- PPCP_MERCHANT_CONNECTED=YES
- PPCP_SANDBOX_ENABLED=YES
- PPCP_LIVE_ENABLED=NO

Do not emit credentials/raw provider secrets.

Failure -> RETURN before writes.

## Backup

Copy only current /srv/infra/edge/Caddyfile to a dated rollback artifact under:

/srv/backups/mini-craft-night-kit/manifests/

Verify backup SHA equals frozen baseline.

Record exact backup path.

## Canonical candidate

Rebuild using F-R1R5R4 accepted semantics and caddy fmt.

Require:
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Adapt before write:
- exit 0
- valid JSON
- empty stderr
- localhost parity
- edge-test parity
- minicraft -> wordpress:80
- exact hostname scope

Mismatch -> RETURN before mutation.

## Atomic Caddy write

Preserve current Caddyfile owner/group/mode.
Create same-filesystem temp, write exact canonical bytes, verify SHA, apply metadata, atomic rename over /srv/infra/edge/Caddyfile.

Verify final SHA.
No unrelated file write.

Write failure -> restore/verify backup and RETURN.

## Reload

Validate mounted config.
Use Caddy reload only.
Never restart/recreate Caddy.

If transport becomes ambiguous after reload:
- no blind retry
- at most one reconciliation SSH/readback
- classify committed vs not committed first

Clear reload failure -> restore backup + reload baseline + prove localhost/edge-test restored + RETURN.

## Post-reload

Before DNS:
- localhost unchanged
- edge-test accepted fingerprint unchanged
- active Mini Craft route exists
- private Host-header/SNI Mini Craft route reaches WordPress
- unrelated route set preserved
- MariaDB private

Failure -> restore Caddy baseline + reload + verify + RETURN.

## Indexing safety

Before DNS:
- read WordPress blog_public/noindex state

If already launch-safe:
INDEXING_WRITE_REQUIRED=NO

If indexable:
- use accepted in-place WP-CLI/native WordPress method
- smallest write only, expected blog_public 1 -> 0
- record pre/post value
- no content/product change

Failure -> rollback Caddy and restore index pre-value if deterministically needed, then RETURN.

## DNS

Create exactly:
- Type A
- Name minicraft
- FQDN minicraft.spikersun.com
- Target 2.24.193.133
- Proxy DNS only

No AAAA/CNAME/cloudflared change.

Record exact rollback handle/record ID if available.

Read back and require 2.24.193.133.

Ambiguous/failure:
- reconcile exact record state
- do not duplicate
- delete only created record if present
- verify DNS absent
- rollback Caddy and indexing
- RETURN

## Public Sandbox validation

Validate:
- HTTPS/TLS
- Home
- Shop
- Product 223
- Cart
- Checkout accepted semantics
- My Account
- wp-json
- media
- WooCommerce
- PPCP active/connected/Sandbox YES/Live NO

Do not:
- place order
- initiate PayPal authorization
- perform Sandbox buyer transaction
- capture/refund
- trigger money-flow webhook test

Product 223 is Sandbox-canary-only and still blocks Soft Launch.

## Rollback

On material public-canary failure:
1. delete exact Mini Craft DNS A
2. verify DNS absent
3. restore Caddy backup
4. validate and reload baseline
5. prove localhost + edge-test restored
6. restore blog_public/noindex pre-value if changed
7. keep private WordPress/MariaDB running

No unrelated rollback.
No blind retry after ambiguous write.

## Success

PASS_CANDIDATE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Required evidence:
OWNER_AUTHORIZATION=AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION
DNS_EXECUTION_PATH=PASS_OPAQUE_AUTHENTICATED
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
DNS_RECORD_TYPE=A
DNS_RECORD_NAME=minicraft.spikersun.com
DNS_RECORD_TARGET=2.24.193.133
DNS_PROXY_STATE=DNS_ONLY
DNS_ACTIVATION=PASS
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
SHARED_INFRA_SCOPE=EXACT_CADDYFILE_ONLY
DNS_SCOPE=EXACT_ONE_A_RECORD_ONLY
PUBLIC_SANDBOX_INGRESS=ACTIVE
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES

## Forbidden

No PayPal Live, real payment/order/capture/refund, buyer transaction, Soft Launch/ads, cloudflared/UFW/Docker daemon/network/Compose mutation, MariaDB exposure, Secret value read/output/hash/copy, product commercial-truth change, unrelated Caddy/DNS/service mutation, Caddy restart/recreate, or blind retry after ambiguous write.
