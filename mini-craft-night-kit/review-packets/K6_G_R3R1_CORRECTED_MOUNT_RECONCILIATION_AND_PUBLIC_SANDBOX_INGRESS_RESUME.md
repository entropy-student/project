# K6 Phase G-R3R1 — Corrected Mount Reconciliation + Public Sandbox Ingress Resume

Gate:
K6_PHASE_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_AND_PUBLIC_SANDBOX_INGRESS_RESUME

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R3_RETURN_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_RESUME.md
- prior G-R3 Decision/Execution Pack
- latest accepted Evidence/Handoff

Owner authorization remains valid:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

## Core correction

Do not compare host inode/device values to container inode/device values.

Capture each view independently before write:
HOST_PRE_DEVICE
HOST_PRE_INODE
HOST_PRE_BYTES
HOST_PRE_SHA256

CONTAINER_PRE_DEVICE
CONTAINER_PRE_INODE
CONTAINER_PRE_BYTES
CONTAINER_PRE_SHA256

Require both content views independently equal the frozen 76-byte baseline hash.

Then continue the full G-R3 transaction without returning merely because host/container inode numbers differ.

## Prewrite

Cloudflare Dashboard session must still be authenticated and exact Mini Craft A/AAAA/CNAME absent before any new VPS/Shared Infra write.

Strict SSH requires:
- ops@srv1970241
- Caddy/WordPress running
- MariaDB healthy/private
- current host Caddyfile baseline
- current container-mounted Caddyfile baseline
- active config baseline
- edge-test fingerprint exact
- Mini Craft active route absent
- PPCP active/connected/Sandbox YES/Live NO
- blog_public=0
- rollback backup valid

## Correct baseline pass

Require:

HOST_PRE_BYTES=76
HOST_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

CONTAINER_PRE_BYTES=76
CONTAINER_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

CROSS_NAMESPACE_INODE_EQUALITY_CHECK=NOT_USED

No other inode relation is evaluated before write.

## Candidate

Rebuild the sealed candidate and require:

CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Adapt/semantic checks must pass.

## Same-inode write

Update only the existing host file inode:
/srv/infra/edge/Caddyfile

No rename/unlink/recreate.

Use the accepted no-create/no-truncate-on-open helper:
- open existing inode O_WRONLY
- verify inode == HOST_PRE_INODE
- write all bytes from offset 0
- handle short writes
- ftruncate only after full write
- fsync
- close

After write:

HOST_POST_INODE_EQUALS_HOST_PRE=PASS
HOST_POST_BYTES=199
HOST_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

CONTAINER_POST_INODE_EQUALS_CONTAINER_PRE=PASS
CONTAINER_POST_BYTES=199
CONTAINER_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Do not test host inode == container inode.

If either content/hash/inode-own-baseline check fails:
- no reload
- restore baseline in-place
- verify both host/container baseline hashes
- active config stays old baseline
- RETURN

## Reload and remainder

If post-write visibility passes:
- validate mounted /etc/caddy/Caddyfile
- reload exact canonical bytes from stdin using caddy reload --config - --adapter caddyfile
- never restart/recreate
- prove localhost/edge-test preserved
- prove Mini Craft private route
- confirm blog_public=0
- recheck Cloudflare session + exact DNS absence
- create exactly one DNS-only A record minicraft.spikersun.com -> 2.24.193.133
- validate public DNS/TLS/routes/WooCommerce/PPCP Sandbox
- no order/payment/auth/capture/refund
- rollback DNS first then same-inode Caddy baseline restore on material failure

Follow the prior G-R3 pack for all rollback and public-validation details except where this R3R1 pack supersedes the inode baseline logic.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_AND_PUBLIC_SANDBOX_INGRESS_RESUME

Required correction markers:

HOST_PRE_DEVICE=
HOST_PRE_INODE=
HOST_PRE_BYTES=76
HOST_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_PRE_DEVICE=
CONTAINER_PRE_INODE=
CONTAINER_PRE_BYTES=76
CONTAINER_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CROSS_NAMESPACE_INODE_EQUALITY_CHECK=NOT_USED
HOST_POST_INODE_EQUALS_HOST_PRE=PASS
CONTAINER_POST_INODE_EQUALS_CONTAINER_PRE=PASS

Then return all G-R3 success markers.

STOP_AT_REVIEWER=YES