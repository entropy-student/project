# K6 Phase G-R3 — Same-Inode Caddyfile Write + Public Sandbox Ingress Resume

Gate:
K6_PHASE_G_R3_SAME_INODE_CADDYFILE_WRITE_AND_PUBLIC_SANDBOX_INGRESS_RESUME

Owner authorization remains valid:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R2_RETURN_G_R3_SAME_INODE_RELOAD_RESUME.md
- latest accepted Evidence/Handoff
- unique Shared VPS Handoff

## Goal

Resolve the single-file bind-mount/atomic-rename conflict without restarting Caddy or changing Compose.

Use:
- same-inode durable host-file update;
- host + container mounted-file hash readback before reload;
- caddy reload from stdin.

## Prewrite browser check

Before any new VPS/shared-infra write:
- Cloudflare Dashboard session authenticated;
- zone spikersun.com accessible;
- exact Mini Craft A/AAAA/CNAME absent.

Login/2FA required -> RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED.

## Fresh remote baseline

Strict direct-native SSH.

Require:
- ops@srv1970241
- host Caddyfile SHA baseline
- container /etc/caddy/Caddyfile SHA baseline
- active config SHA baseline
- localhost + edge-test present
- Mini Craft absent
- edge-test fingerprint exact
- PPCP active/connected/Sandbox YES/Live NO
- WordPress running
- MariaDB healthy/private
- wordpress:80 private reachability
- blog_public=0

Reverify existing rollback backup:
/srv/backups/mini-craft-night-kit/manifests/k6-g-pre-public-ingress-Caddyfile-20260927T082846Z.bak

If missing/mismatched, create a new project-scoped dated backup before Shared Infra write.

Record host + container mounted inode values before write.

## Candidate

Rebuild/canonicalize exact candidate.

Require:
- bytes=199
- SHA-256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
- warning-free adapt
- localhost parity
- edge-test parity
- minicraft -> wordpress:80
- exact hostname scope

## Same-inode write

Do NOT:
- rename
- unlink
- recreate
- move
- atomic replace

Update only existing /srv/infra/edge/Caddyfile inode.

Use a root helper that:
- opens with O_WRONLY only, no O_CREAT/O_TRUNC;
- verifies current inode;
- writes all canonical bytes from offset 0, handling short writes;
- after complete write, ftruncate to 199;
- fsync;
- close.

Require unchanged owner/group/mode.

Before reload, verify:
- host inode unchanged
- host size/hash canonical
- container mount inode unchanged
- container mount size/hash canonical

If container mount does not see canonical content:
- no reload
- restore baseline bytes in-place to same inode
- fsync
- verify host/container baseline hash
- verify active config still baseline
- RETURN_REVIEWER_G_R3_BINDMOUNT_VISIBILITY_FAILED_ROLLED_BACK

## Mounted-file validation

Inside Caddy container, adapt /etc/caddy/Caddyfile.

Require:
- valid JSON
- no material warning
- exact sealed route semantics

Failure -> same-inode baseline restore, no reload, RETURN.

## Reload from stdin

Pipe exact canonical bytes into:

caddy reload --config - --adapter caddyfile

inside spikersun-edge-caddy-1.

This reload source is stdin, not the mounted pathname.

Require:
CADDY_RELOAD=PASS_ZERO_DOWNTIME

Never restart/recreate/stop Caddy.

Clear reload failure:
- same-inode restore baseline
- verify host/container baseline
- pipe baseline bytes to caddy reload stdin
- prove localhost + edge-test restored
- RETURN_REVIEWER_G_R3_RELOAD_FAILED_ROLLED_BACK

Ambiguous transport after reload:
- no blind retry
- at most one reconciliation SSH
- read active config + host/container hashes
- classify then rollback if needed

## Post-reload

Before DNS:
- restart count unchanged
- localhost preserved
- edge-test exact fingerprint preserved
- Mini Craft route active
- private Host/SNI route reaches WordPress
- unrelated routes preserved
- host/container mounted file still canonical
- MariaDB private
- blog_public=0

Failure -> baseline same-inode restore + stdin reload + route proof + RETURN.

## Cloudflare pre-DNS

Immediately before DNS creation:
- Dashboard session authenticated
- exact Mini Craft A/AAAA/CNAME absent

If session expired:
- rollback Caddy baseline
- prove localhost/edge-test restored
- RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED_ROLLED_BACK

## DNS

Create exactly one:
- A
- minicraft
- minicraft.spikersun.com
- 2.24.193.133
- DNS only

Save once.

Read back:
- exact record count=1
- target exact
- DNS only
- no AAAA/CNAME

No unrelated DNS change.

## Public validation

Wait boundedly for DNS/TLS propagation without further mutation.

Validate:
- public A=2.24.193.133
- TLS
- Home
- Shop
- Product 223
- Cart
- Checkout accepted semantics
- My Account
- wp-json
- media
- WooCommerce
- PPCP Sandbox YES / Live NO

No order/payment/auth/capture/refund/webhook money-flow action.

## Rollback after DNS

On material failure:
1. delete exact Mini Craft A only
2. verify A/AAAA/CNAME absent
3. same-inode baseline Caddyfile restore
4. verify host/container baseline hash
5. baseline caddy reload --config - --adapter caddyfile
6. prove localhost + edge-test restored
7. blog_public remains 0

No blind retry.

## SSH budget

Normal path: one strict SSH for remote transaction.
One extra strict SSH only for ambiguity reconciliation/rollback.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3_SAME_INODE_CADDYFILE_WRITE_AND_PUBLIC_SANDBOX_INGRESS_RESUME

Return at least:
OWNER_AUTHORIZATION=AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION
DNS_EXECUTION_PATH=PASS_AUTHENTICATED_CLOUDFLARE_DASHBOARD
CLOUDFLARE_SESSION_PREWRITE=PASS
REMOTE_IDENTITY=ops@srv1970241
PREWRITE_DURABLE_CADDY_SHA=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
PREWRITE_ACTIVE_CONFIG_SHA=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
PREWRITE_EDGE_TEST_FINGERPRINT=PASS
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
CADDY_BACKUP_PATH=
CADDY_BACKUP_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
HOST_CADDYFILE_INODE_UNCHANGED=PASS
HOST_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_CADDYFILE_INODE_UNCHANGED=PASS
CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CADDY_MOUNTED_FILE_VALIDATION=PASS
CADDY_RELOAD_METHOD=STDIN_ADMIN_API
CADDY_RELOAD=PASS_ZERO_DOWNTIME
POST_RELOAD_LOCALHOST=PASS
POST_RELOAD_EDGE_TEST=PASS
POST_RELOAD_MINICRAFT_PRIVATE_ROUTE=PASS
INDEXING_PRE_BLOG_PUBLIC=0
INDEXING_WRITE_REQUIRED=NO
INDEXING_POST_BLOG_PUBLIC=0
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
SHARED_INFRA_SCOPE=EXACT_EXISTING_CADDYFILE_INODE_ONLY
DNS_SCOPE=EXACT_ONE_A_RECORD_ONLY
PUBLIC_SANDBOX_INGRESS=ACTIVE
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES

## Forbidden

No atomic rename/unlink/recreate of Caddyfile, Caddy restart/recreate/stop, unrelated Shared Infra/DNS mutation, cloudflared/UFW/Docker daemon/network/Compose mutation, MariaDB exposure, credential/Secret inspection/output, PayPal Live/money flow, Soft Launch/ads, or unrelated project/service mutation.