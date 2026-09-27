# Reviewer Decision — K6 G-R2 RETURN Accepted / G-R3 Same-Inode Caddyfile Write + Stdin Reload Resume

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_G_R2_PUBLIC_SANDBOX_INGRESS_ACTIVATION_RESUME
RESULT=RETURN_REVIEWER_G_CADDY_BINDMOUNT_ATOMIC_REPLACEMENT_NOT_VISIBLE
EVIDENCE_COMMIT=c1c4623f83e9ea1e8e911e4fbffbe9d225a542b2
HANDOFF_COMMIT=0c2b50e4241f372683983ec9c562e16de3e67270

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted facts

- strict SSH / ops@srv1970241 PASS;
- Cloudflare authenticated prewrite session PASS;
- exact Mini Craft A/AAAA/CNAME absent;
- durable Caddyfile baseline SHA PASS;
- active Caddy config baseline SHA PASS;
- edge-test baseline fingerprint PASS;
- PPCP active/connected/Sandbox YES/Live NO PASS;
- canonical candidate reconstructed:
  bytes=199
  SHA-256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8;
- adapt + localhost + edge-test + Mini Craft semantic validation PASS;
- blog_public=0, so no indexing write is required;
- project-scoped rollback backup exists:
  /srv/backups/mini-craft-night-kit/manifests/k6-g-pre-public-ingress-Caddyfile-20260927T082846Z.bak
- backup SHA equals the frozen 76-byte baseline;
- Caddyfile is a read-only single-file bind mount:
  host /srv/infra/edge/Caddyfile
  -> container /etc/caddy/Caddyfile;
- no Caddyfile write/reload, DNS write, public ingress change, payment action, or Live action occurred.

## Reviewer interpretation

The prior Phase G write method required atomic host-path replacement. For a single-file bind mount, replacing the host pathname can leave the container mount attached to the previously mounted file object. Therefore atomic rename is not an acceptable reload source update for this deployment.

The mutation scope itself remains unchanged and is still covered by the existing Owner authorization:

AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

The technical write mechanism is revised, not the business/public-ingress scope.

## Official operational facts

Docker bind mounts directly expose a host file/directory to the container; a read-only bind prevents container-side writes but does not prevent host-side modification of the mounted source.

Caddy supports:
- `caddy reload --config - --adapter caddyfile`, reading the replacement Caddyfile from stdin;
- graceful configuration replacement through the Admin API with zero downtime;
- rollback to the previous active configuration if loading the replacement fails.

Therefore G-R3 uses:
1. same-inode host-file update for durable persistence and bind-mount visibility;
2. explicit host + container hash readback before reload;
3. Caddy reload from stdin rather than reopening the mounted path.

## Current Gate

CURRENT_GATE=K6_PHASE_G_R3_SAME_INODE_CADDYFILE_WRITE_AND_PUBLIC_SANDBOX_INGRESS_RESUME
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Transaction invariants

Sealed canonical candidate:
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Frozen baseline:
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
EDGE_TEST_STATUS=200
EDGE_TEST_BODY_BYTES=30
EDGE_TEST_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
BLOG_PUBLIC=0

## Phase 0 — Cloudflare prewrite session check

Before any new VPS/shared-infra mutation:
- use the already qualified official Cloudflare Dashboard path;
- open spikersun.com -> DNS -> Records;
- require session authenticated;
- require exact Mini Craft A/AAAA/CNAME still absent.

If login/2FA is required:
RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED

No new VPS/shared-infra write.

## Phase A — fresh remote and backup reconciliation

Use strict direct-native SSH.

Fresh require:
- ops@srv1970241;
- host Caddyfile SHA frozen baseline;
- container-mounted /etc/caddy/Caddyfile SHA frozen baseline;
- active Admin config SHA frozen baseline;
- localhost + edge-test present;
- Mini Craft route absent;
- edge-test fingerprint exact;
- PPCP active/connected/Sandbox YES/Live NO;
- WordPress running;
- MariaDB healthy/private;
- edge -> wordpress:80 private reachability;
- blog_public=0.

Reverify the existing rollback backup path and SHA.

If missing/mismatched, a new project-scoped dated backup may be created before the Shared Infra write and must hash to the baseline.

Record host source inode and container mount inode before write.

Any material drift -> RETURN before Shared Infra mutation.

## Phase B — reconstruct exact canonical candidate

Rebuild and caddy-fmt in memory using the already accepted F-R1R5R4 semantics.

Require exact:
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Require warning-free adapt + localhost/edge-test/Mini Craft semantic parity.

Mismatch -> RETURN before Shared Infra mutation.

## Phase C — same-inode durable Caddyfile update

Do not rename, unlink, replace, recreate, or move the host Caddyfile.

Update only the bytes of the existing inode:

/srv/infra/edge/Caddyfile

Use a bounded root helper that:
1. opens the existing file with O_WRONLY, without O_CREAT and without O_TRUNC;
2. verifies the opened file inode equals the recorded prewrite host inode;
3. writes the complete canonical candidate from offset 0, handling partial writes;
4. only after all candidate bytes are written, ftruncate() to exact length 199;
5. fsync() the file;
6. closes it.

Because the inode is preserved, owner/group/mode remain unchanged; read them back and require unchanged.

Do not create a Caddyfile temp/replacement in /srv/infra/edge.

Immediately after write, before any reload, require:

HOST_CADDYFILE_INODE_UNCHANGED=PASS
HOST_CADDYFILE_BYTES=199
HOST_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

From inside spikersun-edge-caddy-1, read the read-only mounted path and require:

CONTAINER_CADDYFILE_INODE_UNCHANGED=PASS
CONTAINER_CADDYFILE_BYTES=199
CONTAINER_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

This is the mandatory proof that the bind mount sees the durable update.

If either host/container readback fails:
- do not reload;
- restore the baseline backup bytes into the same host inode using the same no-create/no-truncate-on-open helper;
- fsync;
- require host + container mounted path both return the baseline 76-byte SHA;
- require active Admin config still equals the old baseline;
- RETURN_REVIEWER_G_R3_BINDMOUNT_VISIBILITY_FAILED_ROLLED_BACK.

## Phase D — mounted-file pre-reload validation

Before reload, from inside the Caddy container:
- adapt /etc/caddy/Caddyfile;
- require valid JSON;
- require no material warning;
- require localhost/edge-test/Mini Craft semantics equal the sealed candidate.

Failure:
restore baseline in-place, prove host/container baseline readback, do not reload, RETURN.

## Phase E — zero-downtime reload from stdin

Do not rely on Caddy reopening /etc/caddy/Caddyfile for the reload operation.

Pipe the exact in-memory 199-byte canonical candidate into:

caddy reload --config - --adapter caddyfile

inside spikersun-edge-caddy-1.

This is a remote-shell-local stdin pipeline, not SSH stdin.

Never restart/recreate/stop the Caddy container.

Require native reload exit 0.

If reload returns a clear failure:
- restore baseline backup bytes in-place to the same host inode;
- require host/container mounted baseline SHA;
- feed the exact baseline Caddyfile bytes to:
  caddy reload --config - --adapter caddyfile
- prove localhost + edge-test restored;
- RETURN_REVIEWER_G_R3_RELOAD_FAILED_ROLLED_BACK.

If SSH/transport fails after the reload request and commit state is ambiguous:
- no blind retry;
- at most one strict reconciliation SSH is allowed;
- read active Admin config and host/container Caddyfile hashes;
- classify committed/not-committed/partial;
- rollback to baseline if state cannot be safely completed;
- return precise reconciliation status.

## Phase F — post-reload proof

Before DNS:
- Caddy restart count unchanged;
- active localhost route behavior preserved;
- edge-test exact accepted fingerprint preserved;
- active Mini Craft route present;
- private Mini Craft Host-header/SNI request reaches wordpress:80;
- unrelated active hostname routes preserved;
- host durable Caddyfile and container mount still equal canonical candidate hash;
- MariaDB remains private;
- blog_public still 0.

Require:
POST_RELOAD_LOCALHOST=PASS
POST_RELOAD_EDGE_TEST=PASS
POST_RELOAD_MINICRAFT_PRIVATE_ROUTE=PASS
INDEXING_WRITE_REQUIRED=NO

Failure -> in-place Caddy baseline restore + stdin baseline reload + route proof + RETURN.

## Phase G — Cloudflare pre-DNS recheck

Immediately before DNS creation:
- re-prove authenticated Dashboard session;
- exact Mini Craft A/AAAA/CNAME absent.

If login/2FA is required:
- restore baseline Caddyfile in-place;
- stdin reload baseline;
- prove localhost/edge-test restored;
- RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED_ROLLED_BACK.

## Phase H — exact DNS creation

Create once, through the official Dashboard:

Type=A
Name=minicraft
FQDN=minicraft.spikersun.com
Target=2.24.193.133
Proxy=DNS only

Before Save verify exact tuple and no unrelated change.

After Save require exactly one matching A record, target 2.24.193.133, DNS-only, no AAAA/CNAME.

No blind Save retry.

## Phase I — public validation

Require public DNS A -> 2.24.193.133.

Allow bounded propagation/TLS issuance waiting without further mutation.

Validate:
- HTTPS/TLS;
- Home;
- Shop;
- Product 223;
- Cart;
- Checkout accepted semantics;
- My Account;
- wp-json;
- required media;
- WooCommerce;
- PPCP active/connected/Sandbox YES/Live NO.

Do not place any order or initiate payment/auth/capture/refund/webhook money flow.

## Phase J — rollback after DNS

On material failure after DNS creation:

1. delete only the exact Mini Craft A record by exact zone/type/name/target tuple;
2. prove Mini Craft A/AAAA/CNAME absent;
3. restore baseline Caddyfile bytes in-place to the same host inode;
4. prove host + container mounted baseline SHA;
5. feed baseline bytes to caddy reload --config - --adapter caddyfile;
6. prove localhost + edge-test restored;
7. blog_public remains 0;
8. leave private WordPress/MariaDB runtime intact.

No blind retry after ambiguous DNS or reload mutation.

## SSH budget

Normal path: one strict SSH transaction for remote prewrite/write/reload/post-reload work.

One additional strict SSH is authorized only for ambiguity reconciliation or rollback after transport loss/public failure.

No unrelated SSH sessions.

## Success contract

PASS_CANDIDATE_K6_PHASE_G_R3_SAME_INODE_CADDYFILE_WRITE_AND_PUBLIC_SANDBOX_INGRESS_RESUME
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

## Hard forbidden

No:
- atomic rename/unlink/recreate of the Caddyfile;
- Caddy restart/recreate/stop;
- Admin /load direct scripting when caddy reload stdin path is available;
- cloudflared/UFW/Docker daemon/network/Compose mutation;
- MariaDB exposure;
- credential/token/cookie/session-value inspection/output;
- unrelated DNS/Shared Infra mutation;
- Secret access/output/hash/copy;
- PayPal Live or money movement;
- Soft Launch/advertising;
- unrelated project/service mutation.
