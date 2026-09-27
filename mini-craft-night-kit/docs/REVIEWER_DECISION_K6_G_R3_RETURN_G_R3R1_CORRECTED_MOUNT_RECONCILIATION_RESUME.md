# Reviewer Decision — K6 G-R3 RETURN Accepted / G-R3R1 Corrected Mount Reconciliation + Resume

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

GATE=K6_PHASE_G_R3_SAME_INODE_CADDYFILE_WRITE_AND_PUBLIC_SANDBOX_INGRESS_RESUME
RESULT=RETURN_REVIEWER_G_CADDY_MOUNT_BASELINE_RECONCILIATION_UNRESOLVED
EVIDENCE_COMMIT=fe5da8e99acdeaae926ef25ecc2bfc3e156a40db
HANDOFF_COMMIT=03c3019ccf3a676013daeccef021ebccf17ee617

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

HELPER_LOGIC_ERROR_CROSS_NAMESPACE_INODE_EQUALITY

The helper incorrectly bundled:
- mounted-file content/hash validation; and
- host/container inode-number equality.

The Gate never required host inode == container inode.

The intended invariants are:
- HOST_POST_INODE == HOST_PRE_INODE
- CONTAINER_POST_INODE == CONTAINER_PRE_INODE

Each namespace/file view is compared only with its own prewrite snapshot.

No actual Caddy drift is proven.

## Accepted no-write facts

REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME=RUNNING;RESTART_COUNT=0
WORDPRESS_RUNTIME=RUNNING;RESTART_COUNT=0
MARIADB_HEALTH=HEALTHY;RESTART_COUNT=0
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
PREWRITE_DURABLE_CADDYFILE=PASS;76_BYTES;SHA256_12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
PREWRITE_ROLLBACK_BACKUP=PASS;SHA256_12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CADDYFILE_WRITE=0
CADDY_RELOAD=0
INDEXING_WRITE=0
DNS_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SHARED_INFRA_WRITES=0
VPS_WRITES=0

The prior Owner authorization remains valid:
AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

## Current Gate

CURRENT_GATE=K6_PHASE_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_AND_PUBLIC_SANDBOX_INGRESS_RESUME
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Corrected mount-baseline model

Before any write, record separately:

HOST_PRE_DEVICE=
HOST_PRE_INODE=
HOST_PRE_BYTES=
HOST_PRE_SHA256=

CONTAINER_PRE_DEVICE=
CONTAINER_PRE_INODE=
CONTAINER_PRE_BYTES=
CONTAINER_PRE_SHA256=

Do not compare host device/inode numbers to container device/inode numbers.

Baseline requires only:

HOST_PRE_BYTES=76
HOST_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

CONTAINER_PRE_BYTES=76
CONTAINER_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

and active config baseline remains exact.

If both content baselines pass, continue the already-authorized mutation transaction in the same Gate.

## Same-inode write invariants

After in-place write:

HOST_POST_INODE must equal HOST_PRE_INODE.
CONTAINER_POST_INODE must equal CONTAINER_PRE_INODE.

No cross-namespace equality test is allowed.

Also require:

HOST_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CONTAINER_POST_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

and both sizes=199.

If either post hash fails:
- do not reload;
- restore baseline bytes in-place;
- prove host/container baseline hash;
- active config must still be old baseline;
- RETURN.

## Resume

After corrected baseline PASS, continue exactly the accepted G-R3 sequence:
- fresh PPCP Sandbox/Live check;
- sealed canonical candidate check;
- same-inode host Caddyfile write;
- host/container visibility proof;
- mounted-file validation;
- stdin Caddy reload;
- post-reload route preservation;
- blog_public=0 confirmation;
- Cloudflare session pre-DNS check;
- exact DNS-only A creation;
- public Sandbox validation;
- defined rollback on material failure.

## Success

PASS_CANDIDATE_K6_PHASE_G_R3R1_CORRECTED_MOUNT_RECONCILIATION_AND_PUBLIC_SANDBOX_INGRESS_RESUME

Required new evidence includes:

HOST_PRE_DEVICE=
HOST_PRE_INODE=
HOST_PRE_BYTES=76
HOST_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_PRE_DEVICE=
CONTAINER_PRE_INODE=
CONTAINER_PRE_BYTES=76
CONTAINER_PRE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

HOST_POST_INODE_EQUALS_HOST_PRE=PASS
CONTAINER_POST_INODE_EQUALS_CONTAINER_PRE=PASS
CROSS_NAMESPACE_INODE_EQUALITY_CHECK=NOT_USED

plus all previously defined G-R3 success markers.

## Forbidden

No:
- host/container inode equality assertion;
- atomic rename/unlink/recreate of Caddyfile;
- Caddy restart/recreate;
- unrelated Shared Infra/DNS mutation;
- PayPal Live/money movement;
- Soft Launch;
- Secret/credential inspection or output.
