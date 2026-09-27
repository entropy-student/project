# Reviewer Decision — K6 Phase G Public Sandbox Ingress Activation Authorized

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Owner authorization

Owner provided the exact required authorization marker:

AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Authorization is accepted.

This authorizes only the bounded Sandbox-public-ingress mutation described below. It does not authorize PayPal Live, real payment, commercial launch, advertising, Secret disclosure, or unrelated Shared Infra mutation.

## Preceding accepted state

K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN=PASS
K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL=PASS

Sealed canonical Caddy candidate:

CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Frozen pre-mutation baseline:

DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
EDGE_TEST_STATUS=200
EDGE_TEST_BODY_BYTES=30
EDGE_TEST_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
CURRENT_MINICRAFT_ROUTE=ABSENT
CURRENT_MINICRAFT_DNS=NXDOMAIN
MINICRAFT_EDGE_UPSTREAM=wordpress:80
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO

## Current Gate

CURRENT_GATE=K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Core transaction ordering

Phase G is a bounded transaction with fail-closed checkpoints.

The order is mandatory:

1. local/DNS execution-path preflight;
2. fresh remote no-write reconciliation;
3. fresh PayPal Sandbox/Live readback;
4. exact rollback backup;
5. reconstruct and verify the sealed canonical candidate;
6. atomically write only the shared Caddyfile;
7. validate and zero-downtime reload;
8. prove unrelated routes preserved and Mini Craft private Host-header ingress works;
9. check indexing state and, only if required, apply bounded noindex;
10. create exactly one DNS-only A record;
11. public TLS/Sandbox-route validation;
12. PASS or rollback.

No public DNS write may occur before Caddy route preservation and indexing safety pass.

## Phase 0 — DNS execution path preflight

Before any remote/VPS write, prove there is an authorized DNS mutation path for the Cloudflare zone containing spikersun.com.

Accepted execution path characteristics:
- can read the specific zone/record state and create/delete exactly one DNS record;
- uses an already authenticated credential/session opaquely;
- does not print, copy, inspect, hash, commit or expose the credential value;
- can return the created record identifier or another exact rollback handle without exposing Secret material.

Opaque use of an already authenticated credential/session solely for this Owner-authorized DNS mutation is permitted.

Direct reading/copying of an API token/password/cookie value is not permitted.

If no such path exists:

RETURN_OWNER_DNS_EXECUTION_PATH_REQUIRED

This RETURN must occur before:
- Caddyfile backup/write;
- noindex write;
- any DNS write.

Also fresh-read current DNS:
minicraft.spikersun.com
and require no A/AAAA/CNAME record.

Any pre-existing record -> RETURN_REVIEWER_G_DNS_DRIFT.

## Phase A — fresh remote prewrite reconciliation

Use the proven direct-native strict SSH transport.

Before sudo:
- whoami=ops;
- id -un=ops;
- UID nonzero;
- hostname=srv1970241.

Fresh prove:
- durable /srv/infra/edge/Caddyfile SHA equals frozen baseline;
- Caddy container-loopback Admin GET works;
- active config SHA equals frozen baseline;
- active localhost route present;
- active edge-test route present;
- active Mini Craft route absent;
- edge-test behavior still 200 / 30 bytes / accepted body hash;
- WordPress and MariaDB are running; MariaDB healthy;
- Mini Craft private upstream wordpress:80 is reachable from current shared-edge context;
- MariaDB remains private.

Any material mismatch -> RETURN_REVIEWER_G_PREWRITE_DRIFT.

No write before all checks pass.

## Phase B — fresh payment-mode safety

Before any Shared Infra write, fresh-read WooCommerce PayPal Payments state using the already accepted non-secret authoritative application path.

Require:
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO

Do not output client IDs, secrets, tokens, webhook secrets or raw provider responses.

If Live is enabled or Sandbox cannot be proven:
RETURN_REVIEWER_G_PAYMENT_MODE_UNSAFE

No write before this check passes.

## Phase C — exact rollback backup

Create exactly one project-scoped rollback copy of the current shared Caddyfile under:

/srv/backups/mini-craft-night-kit/manifests/

Suggested name:
k6-g-pre-public-ingress-Caddyfile-<UTC>.bak

Requirements:
- source is exactly /srv/infra/edge/Caddyfile;
- backup bytes SHA-256 equals the frozen durable baseline;
- backup path is recorded;
- owner/mode metadata is recorded without exposing Secret content;
- no unrelated Shared Infra file is copied.

If backup verification fails:
RETURN_REVIEWER_G_CADDY_BACKUP_FAILED

No Caddyfile mutation after a failed backup.

## Phase D — reconstruct exact sealed canonical candidate

Rebuild from fresh active semantics using the accepted F-R1R5R4 method:
- exact durable baseline;
- edge-test status/body;
- only headers explicitly configured in active static_response (expected none);
- Mini Craft reverse_proxy wordpress:80;
- caddy fmt canonicalization.

Require exact:
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

Adapt the canonical bytes and require:
- native exit 0;
- valid JSON;
- stderr empty;
- localhost parity;
- edge-test parity;
- Mini Craft upstream wordpress:80;
- exact user hostname scope localhost, edge-test.spikersun.com, minicraft.spikersun.com.

Mismatch -> RETURN_REVIEWER_G_CANONICAL_CANDIDATE_DRIFT

No write on mismatch.

## Phase E — atomic shared Caddyfile mutation

This is the first authorized Shared Infra mutation.

Read and record current owner/group/mode of:
/srv/infra/edge/Caddyfile

Create a temporary file in the same filesystem/directory, write only the exact sealed canonical candidate bytes, verify its SHA, apply the original owner/group/mode, then atomically rename it over:

/srv/infra/edge/Caddyfile

Requirements:
- no unrelated file write;
- final file SHA equals canonical sealed SHA;
- temp artifact absent after rename;
- no Caddy restart.

If final readback hash differs:
- restore backup immediately;
- verify restored baseline hash;
- RETURN_REVIEWER_G_CADDY_ATOMIC_WRITE_FAILED.

## Phase F — validate and zero-downtime reload

Before reload:
- caddy fmt/adapt the written mounted config;
- require valid JSON and no material warning/error.

Determine the exact mounted Caddyfile destination in spikersun-edge-caddy-1 by a bounded read-only mount lookup if needed.

Reload only with the current Caddy process/container.

Never restart/recreate the Caddy container.

Require reload native exit 0.

If reload outcome is ambiguous due transport loss:
- do not blind retry;
- use at most one strict reconciliation SSH to read active config and route behavior;
- classify committed vs not committed before any further action.

If reload clearly fails:
- restore backup;
- validate baseline;
- reload baseline;
- prove edge-test/localhost restored;
- RETURN_REVIEWER_G_CADDY_RELOAD_FAILED_ROLLED_BACK.

## Phase G — immediate post-reload preservation

Before any DNS write, prove:
- Caddy container remains running;
- localhost route behavior matches prewrite baseline;
- edge-test HTTPS behavior remains:
  status 200
  body bytes 30
  body SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824;
- active Mini Craft route now exists;
- Host-header/SNI-private Mini Craft request reaches wordpress:80 and returns the expected WordPress site behavior;
- no unrelated active hostname was lost;
- MariaDB remains private.

If preservation fails:
- restore prior Caddyfile backup;
- reload baseline;
- prove localhost/edge-test restored;
- RETURN_REVIEWER_G_POST_RELOAD_ROUTE_PRESERVATION_FAILED_ROLLED_BACK.

## Phase H — indexing safety

Still before public DNS:

Read current WordPress search-engine visibility/noindex state.

If already launch-safe:
INDEXING_WRITE_REQUIRED=NO

If indexable:
- use the previously validated in-place WP-CLI PHAR method or another current authoritative WordPress-native method;
- make only the smallest write required to set WordPress search-engine discouragement/noindex state;
- record the pre-value and post-value, not unrelated options;
- do not change content/product/commercial state.

Expected bounded option if applicable:
blog_public: 1 -> 0

Require fresh readback.

If the indexing write is required but cannot be safely completed:
- restore Caddyfile backup/reload baseline;
- restore any partially changed indexing value to its pre-value if deterministically safe;
- RETURN_REVIEWER_G_INDEXING_SAFETY_FAILED_ROLLED_BACK.

## Phase I — DNS creation

Only after Phases A-H PASS.

Create exactly one record:

Type=A
Name=minicraft
FQDN=minicraft.spikersun.com
Target=2.24.193.133
Proxy=DNS only

No AAAA.
No CNAME.
No cloudflared route.
No unrelated DNS change.

Record the exact created DNS rollback handle/record ID if the execution path provides one.

Immediately read back authoritative/public DNS and require it resolves to 2.24.193.133.

If DNS creation/readback fails or is ambiguous:
- reconcile exact record state before retrying;
- do not create duplicates;
- if a record was created, delete only that exact record;
- verify DNS absent;
- restore Caddyfile baseline and indexing pre-value if changed;
- RETURN_REVIEWER_G_DNS_ACTIVATION_FAILED_ROLLED_BACK.

## Phase J — public Sandbox validation

With DNS active, validate:

- HTTPS/TLS for https://minicraft.spikersun.com;
- Home;
- Shop;
- Product 223;
- Cart;
- Checkout rendering/redirect semantics;
- My Account;
- wp-json;
- media needed by tested pages;
- WooCommerce core state;
- PayPal Payments active/connected/Sandbox YES/Live NO;
- no provider API payment/capture/refund action.

Product 223 may be publicly visible only as Sandbox canary data. This does not authorize Soft Launch, promotion or real sales.

Do not place an order.
Do not initiate PayPal authorization.
Do not use a real or Sandbox buyer transaction.
Do not trigger webhook/provider money-flow tests in this Gate.

## Phase K — rollback policy

A material public-canary failure requires rollback in this order:

1. delete only the exact Mini Craft DNS A record;
2. verify Mini Craft DNS is absent;
3. restore the exact pre-G Caddyfile backup;
4. validate baseline config;
5. zero-downtime reload baseline;
6. prove localhost and edge-test restored;
7. if this Gate changed blog_public/noindex, restore its recorded pre-value after public DNS is absent and verify;
8. leave WordPress/MariaDB private runtime running;
9. no unrelated rollback.

If any rollback step is ambiguous:
- no blind retry;
- perform bounded readback/reconciliation;
- return precise partial/ambiguous state to Reviewer.

## Success contract

PASS_CANDIDATE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION
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

PASS_CANDIDATE does not authorize PayPal Live or Soft Launch.

## Hard forbidden

No:
- PayPal Live;
- real payment/order/capture/refund;
- buyer transaction;
- Soft Launch/advertising;
- cloudflared mutation;
- UFW/firewall mutation;
- Docker daemon/network/Compose mutation;
- MariaDB exposure;
- Secret value read/output/hash/copy;
- product 223 commercial truth modification;
- unrelated Caddy/DNS/project/service mutation;
- Caddy restart/recreate;
- blind retry after ambiguous write.
