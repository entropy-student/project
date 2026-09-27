# Reviewer Decision — K6 G-R4 Shared Caddy Service Recreate Authorized

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly approved proceeding after reviewing:
- the shared Caddy-only recreate scope;
- expected brief interruption on shared 80/443;
- preserved routes;
- rollback path;
- continued prohibition on PayPal Live / payment / Soft Launch.

Reviewer normalizes the Owner approval as:

AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE

## Current Gate

CURRENT_GATE=K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE_AND_PUBLIC_SANDBOX_ACTIVATION
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Authority inherited from prior PASS

Accepted from G-R3R2R2:

STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED

Legacy active rollback source:
LEGACY_MOUNTED_CADDYFILE_BYTES=153
LEGACY_MOUNTED_CADDYFILE_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837
LEGACY_MOUNTED_TO_ACTIVE_SEMANTIC_PARITY=PASS

Target:
TARGET_CANONICAL_CANDIDATE_BYTES=199
TARGET_CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
TARGET_PRESERVES_ALL_UNRELATED_ACTIVE_ROUTES=PASS

Compose:
CADDY_COMPOSE_SHA256=22abbe0b6eee42edee068605b19a4c7168284446bbf723715ff3a27c360cfef5
CADDY_COMPOSE_PROJECT=spikersun-edge
CADDY_SERVICE_NAME=caddy
CADDY_IMAGE=caddy:2-alpine
CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge
CADDY_CERT_STATE_PERSISTENCE=PASS
CADDY_CONFIG_STATE_PERSISTENCE=NOT_REQUIRED_BY_STARTUP_PATH

Sealed recreate command:

sudo -n docker compose -p spikersun-edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never caddy

## Authorized transaction

This Gate authorizes, in this order:

1. Fresh Cloudflare Dashboard session + exact Mini Craft A/AAAA/CNAME absence.
2. Fresh strict SSH identity/runtime/PPCP safety check.
3. Persist exact 153-byte legacy mounted Caddyfile as project-scoped rollback artifact.
4. Rebuild/verify exact 199-byte target candidate.
5. Atomically replace host /srv/infra/edge/Caddyfile with exact target candidate.
6. Validate host target.
7. Recreate only the caddy service using the sealed command.
8. Prove new container mounted Caddyfile equals target hash.
9. Prove old unrelated routes preserved and Mini Craft private route active.
10. Prove no unrelated container was recreated.
11. Prove certificate state/TLS healthy.
12. Confirm blog_public=0.
13. Fresh Cloudflare Dashboard session + exact DNS absence.
14. Create exactly one DNS-only A:
    minicraft.spikersun.com -> 2.24.193.133
15. Public Sandbox validation.
16. Persist Evidence/Handoff and STOP_AT_REVIEWER.

## Fresh prewrite requirements

Before any Shared Infra write require:

CLOUDFLARE_SESSION_PREWRITE=PASS
AUTHENTICATED_ZONE_MINICRAFT_A=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_AAAA=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_CNAME=ABSENT

REMOTE_IDENTITY=ops@srv1970241

Fresh runtime:
- caddy running;
- WordPress running;
- MariaDB healthy/private;
- Mini Craft WordPress reachable privately;
- no public DB/WordPress host ports.

Fresh payment safety:
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO

Fresh source invariants:
- host Caddyfile remains 76-byte SHA 12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb;
- running mounted legacy remains 153-byte SHA 126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837;
- Compose SHA remains 22abbe0b6eee42edee068605b19a4c7168284446bbf723715ff3a27c360cfef5;
- active route inventory remains exactly localhost + edge-test.spikersun.com;
- edge-test behavior remains exact accepted fingerprint;
- Mini Craft active route remains absent;
- blog_public=0.

Any material drift -> RETURN before write.

## Legacy rollback artifact

Before touching shared Caddyfile, copy the exact bytes currently mounted in the running Caddy container:

/etc/caddy/Caddyfile

to exactly one new project-scoped dated artifact under:

/srv/backups/mini-craft-night-kit/manifests/

Suggested name:

k6-g-r4-legacy-active-Caddyfile-<UTC>.bak

Require:

LEGACY_ROLLBACK_BACKUP_BYTES=153
LEGACY_ROLLBACK_BACKUP_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837

No unrelated backup writes.

## Target host Caddyfile write

Rebuild/verify exact target candidate:
TARGET_CANONICAL_CANDIDATE_BYTES=199
TARGET_CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Use atomic same-filesystem host-path replacement because the next authorized step recreates the Caddy service and therefore remounts the current host pathname.

Preserve owner/group/mode.

After write require:
HOST_TARGET_CADDYFILE_BYTES=199
HOST_TARGET_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Validate target before recreate.

## Caddy-only recreate

Before recreate capture:
- old Caddy container ID;
- bounded running-container name->ID inventory sufficient to prove unrelated containers unchanged;
- old Caddy restart count;
- current edge-test HTTPS behavior.

Execute exactly once:

sudo -n docker compose -p spikersun-edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never caddy

No blind retry.

If command result is ambiguous:
- reconcile container state first;
- do not rerun until classified.

Require after recreate:
- Caddy running;
- new Caddy container ID differs from old;
- service/project labels unchanged;
- image ID remains accepted immutable image;
- ports 80/443 published;
- network spikersun-edge attached;
- mounted /etc/caddy/Caddyfile bytes=199 and target SHA;
- /data and /config mounts point to the accepted persistent host sources;
- unrelated container IDs unchanged;
- no network recreate;
- no unrelated container recreate.

## Post-recreate route validation

Require:
POST_RECREATE_LOCALHOST=PASS
POST_RECREATE_EDGE_TEST=PASS
POST_RECREATE_MINICRAFT_PRIVATE_ROUTE=PASS
POST_RECREATE_UNRELATED_ROUTES_PRESERVED=PASS
POST_RECREATE_CERT_STATE=PASS

Edge-test must preserve accepted status/body fingerprint.

Mini Craft private Host/SNI route must reach wordpress:80.

Confirm:
INDEXING_PRE_BLOG_PUBLIC=0
INDEXING_WRITE_REQUIRED=NO
INDEXING_POST_BLOG_PUBLIC=0

## Pre-DNS Cloudflare recheck

Immediately before DNS mutation require:
CLOUDFLARE_SESSION_PRE_DNS=PASS
AUTHENTICATED_ZONE_MINICRAFT_A=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_AAAA=ABSENT
AUTHENTICATED_ZONE_MINICRAFT_CNAME=ABSENT

If Cloudflare auth is unavailable after recreate but before DNS:
- restore legacy rollback Caddyfile to host;
- recreate only Caddy;
- prove legacy routes restored;
- RETURN_OWNER_CLOUDFLARE_DASHBOARD_SESSION_REQUIRED_ROLLED_BACK.

## DNS activation

Create exactly one:

TYPE=A
NAME=minicraft
FQDN=minicraft.spikersun.com
TARGET=2.24.193.133
PROXY=DNS only

Save once.

No blind retry.

Read back exact zone state:
DNS_EXACT_RECORD_COUNT=1
DNS_RECORD_TARGET=2.24.193.133
DNS_PROXY_STATE=DNS_ONLY
AAAA=ABSENT
CNAME=ABSENT

## Public Sandbox validation

Allow bounded DNS/TLS propagation waiting without further mutation.

Require:
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

No order/payment/auth/capture/refund/webhook money-flow test.

## Rollback

### Failure before DNS

1. Restore exact 153-byte legacy rollback artifact to host Caddyfile.
2. Validate legacy file.
3. Recreate only Caddy using the same sealed command.
4. Prove mounted legacy hash restored.
5. Prove edge-test + localhost restored.
6. DNS remains absent.

### Failure after DNS

1. Delete only exact Mini Craft A.
2. Verify A/AAAA/CNAME absent.
3. Restore exact 153-byte legacy rollback artifact to host.
4. Recreate only Caddy.
5. Prove mounted legacy hash restored.
6. Prove legacy routes restored.

No blind retry after ambiguous recreate or DNS result.

## Hard forbidden

No:
- Compose file mutation;
- Docker network/daemon config mutation;
- unrelated container recreate;
- cloudflared/UFW mutation;
- MariaDB exposure;
- Secret/credential output;
- PayPal Live;
- real order/payment/auth/capture/refund;
- Sandbox buyer transaction;
- Soft Launch/advertising;
- unrelated Shared Infra mutation.

## Success

PASS_CANDIDATE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE_AND_PUBLIC_SANDBOX_ACTIVATION

Return at least:

OWNER_AUTHORIZATION=AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE
CLOUDFLARE_SESSION_PREWRITE=PASS
REMOTE_IDENTITY=ops@srv1970241
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO

LEGACY_ROLLBACK_BACKUP_PATH=
LEGACY_ROLLBACK_BACKUP_BYTES=153
LEGACY_ROLLBACK_BACKUP_SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837

TARGET_CANONICAL_CANDIDATE_BYTES=199
TARGET_CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
HOST_TARGET_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

CADDY_OLD_CONTAINER_ID=
CADDY_NEW_CONTAINER_ID=
CADDY_ONLY_RECREATE=PASS
UNRELATED_CONTAINER_IDS_UNCHANGED=PASS
NEW_CONTAINER_MOUNTED_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
POST_RECREATE_LOCALHOST=PASS
POST_RECREATE_EDGE_TEST=PASS
POST_RECREATE_MINICRAFT_PRIVATE_ROUTE=PASS
POST_RECREATE_UNRELATED_ROUTES_PRESERVED=PASS
POST_RECREATE_CERT_STATE=PASS

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
SOFT_LAUNCH_AUTHORIZED=NO

COMPOSE_FILE_MUTATION=NO
NETWORK_RECREATE=NO
DOCKER_DAEMON_MUTATION=NO
UNRELATED_CONTAINER_RECREATE=NO
DNS_SCOPE=EXACT_ONE_A_RECORD_ONLY
SHARED_INFRA_SCOPE=EXACT_CADDYFILE_AND_CADDY_SERVICE_ONLY
PUBLIC_SANDBOX_INGRESS=ACTIVE
STOP_AT_REVIEWER=YES
