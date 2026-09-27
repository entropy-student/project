# Reviewer Decision — K6 Phase F PASS / Phase G Public Sandbox Ingress Owner Checkpoint

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Formal acceptance

Reviewed:

GATE=K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL
RESULT=PASS_CANDIDATE_K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL
EVIDENCE_COMMIT=7e73ba1542c7e142a9323c99b8c9d3a876833bdb
HANDOFF_COMMIT=e62ce28e295e81cacd5ec1cf0d7015a3610d2aaa

Reviewer decision:

K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL=PASS
K6_PHASE_F_PUBLIC_SANDBOX_INGRESS_READINESS_AND_CHANGE_PLAN=PASS

## Accepted sealed facts

REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_CURRENT_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
EDGE_TEST_ACTIVE_EXPLICIT_HEADERS_PRESENT=NO
CANONICAL_CANDIDATE_BYTES=199
CANONICAL_CANDIDATE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
CANONICAL_ADAPT_NATIVE_EXIT=0
CANONICAL_ADAPT_STDOUT_JSON=PASS
CANONICAL_ADAPT_STDERR=EMPTY
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80
CANDIDATE_HOSTNAME_SCOPE=PASS
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH

No mutation occurred in Phase F.

## Why Owner authorization is now required

The next step crosses from read-only planning into:
- Shared Infra durable Caddyfile mutation;
- Caddy zero-downtime reload;
- possible bounded WordPress noindex write if current indexing is unsafe;
- public DNS creation;
- first public Sandbox exposure of the Mini Craft site.

These are material public-ingress changes and require an explicit Owner checkpoint.

## Exact proposed Phase G mutation scope

Only after explicit Owner authorization, Reviewer may open a separate bounded execution Gate for the following sequence:

1. Fresh prewrite reconciliation:
   - strict target identity;
   - durable Caddyfile SHA still equals the sealed baseline;
   - active Caddy config / edge-test fingerprint still matches;
   - active Mini Craft route still absent;
   - Mini Craft DNS still absent.

2. Shared Infra backup:
   - create a dated backup of the current /srv/infra/edge/Caddyfile under the accepted Shared Infra backup convention;
   - verify backup bytes/hash;
   - no unrelated Shared Infra file touched.

3. Install the exact sealed canonical Caddy candidate:
   - canonical candidate SHA-256 must equal:
     cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
   - atomically replace only /srv/infra/edge/Caddyfile;
   - no other Caddy/shared-edge file write.

4. Validate before reload:
   - caddy fmt/adapt or equivalent validation;
   - candidate hash must remain exact;
   - no material warning/error.

5. Zero-downtime Caddy reload:
   - reload only;
   - never restart the Caddy container/service.

6. Immediate post-reload preservation:
   - localhost behavior unchanged;
   - edge-test HTTPS behavior still 200 / 30 bytes / accepted body SHA;
   - Mini Craft Host-header route reaches wordpress:80;
   - no unrelated route loss.

7. Indexing safety:
   - read current WordPress search-engine visibility/noindex state;
   - if already launch-safe, no application write;
   - if indexable, apply only the smallest bounded noindex/search-engine-discouragement write required for the Sandbox canary;
   - no content/product/commercial change.

8. DNS creation:
   - create exactly one DNS record:
     Type=A
     Name=minicraft
     FQDN=minicraft.spikersun.com
     Target=2.24.193.133
     Proxy=DNS only
   - no cloudflared change.

9. Public Sandbox validation:
   - DNS resolution;
   - TLS issuance/HTTPS;
   - Home;
   - Shop;
   - test Product 223;
   - Cart;
   - Checkout rendering;
   - My Account;
   - wp-json;
   - PayPal Sandbox UI/config rendering only.
   - no real order/payment/capture/refund.

10. Rollback on material failure:
   - remove Mini Craft DNS first;
   - restore the prior Caddyfile backup;
   - zero-downtime reload;
   - prove localhost and edge-test are restored;
   - if a bounded noindex write was made solely for canary safety, Reviewer decides whether to retain or revert it based on resulting exposure state;
   - unrelated Shared Infra remains untouched.

## Explicitly excluded

No:
- PayPal Live;
- real payment;
- real commercial launch;
- paid traffic/advertising;
- cloudflared mutation;
- firewall/UFW mutation;
- Docker daemon mutation;
- Docker network mutation;
- Compose mutation;
- MariaDB exposure;
- Secret mutation/access;
- product 223 commercial truth change;
- unrelated project/service mutation.

## Current checkpoint

CURRENT_GATE=K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=AWAIT_OWNER
OWNER_ACTION=EXPLICIT_AUTHORIZATION_REQUIRED

Exact approval marker:

AUTHORIZE_K6_PHASE_G_PUBLIC_SANDBOX_INGRESS_ACTIVATION

Anything else does not authorize the mutation Gate.

After this exact authorization, Reviewer will open a separate bounded Phase G execution pack. Authorization does not itself execute any mutation.
