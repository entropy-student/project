# Reviewer Decision — K6 F-R1R4 RETURN Accepted / F-R1R5 Behavioral Route Preservation

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R4_CONTAINER_LOOPBACK_CADDY_ADMIN_RECOVERY_AND_CANDIDATE_ADAPT
RESULT=RETURN_REVIEWER_F_R1R4_EDGE_TEST_NOT_RECONSTRUCTABLE
EVIDENCE_COMMIT=f2975b766bc6c21d11ff554004e2d9231f9ee27e
HANDOFF_COMMIT=de1b289b3638b9254b2fcccb0340699208b23b40

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted facts

- one strict SSH session PASS;
- container-loopback Caddy Admin GET PASS;
- active config bytes=610;
- active config SHA-256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd;
- active localhost route FOUND;
- active edge-test.spikersun.com route FOUND;
- active Mini Craft route ABSENT;
- durable Caddyfile bytes=76;
- durable Caddyfile SHA-256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb;
- fresh Mini Craft DNS NXDOMAIN;
- no Shared Infra/DNS/app/product/payment mutation;
- no persistent temp artifact.

The RETURN only says the bounded JSON reconstructor did not classify the active edge-test handler shape safely. It does not prove drift.

## Historical accepted edge-test behavior fingerprint

From accepted Phase F evidence:

EDGE_TEST_STATUS=200
EDGE_TEST_BODY_BYTES=30
EDGE_TEST_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824

No canonical durable source or historical GitHub definition for edge-test.spikersun.com was found. It is therefore treated as an unrelated runtime route whose observable behavior must be preserved before any Caddy reload.

## Reviewer design correction

F-R1R5 preserves behavior, not internal JSON shape.

Primary method:
- locate the edge-test host route in active JSON;
- within that route subtree, generically search for a descendant handler with handler=static_response;
- if exactly one safely extractable static_response handler exists, use its status/body/configured non-sensitive headers.

Behavioral fallback:
- if internal handler classification remains ambiguous, make local requests against the currently running Caddy using edge-test.spikersun.com as Host/SNI;
- recover status/body/redirect behavior from the live server;
- require the fresh HTTPS/static body fingerprint to equal the historical accepted 200 / 30 bytes / SHA-256 above;
- exact body remains only in process memory;
- no public DNS or external request is required.

Caddyfile supports heredoc tokens for multiline response bodies, and caddy adapt can validate the reconstructed candidate without loading it.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT
OWNER_ACTION=NONE

Read-only only.

## SSH boundary

Exactly one canonical strict SSH session.

Pre-sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

## Phase A — frozen-state checks

Read-only confirm:
- Caddy/WordPress running;
- MariaDB healthy;
- fresh Mini Craft DNS NXDOMAIN;
- durable Caddyfile SHA exact:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb;
- container-loopback active config GET succeeds;
- active config SHA exact:
  206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd.

If active config hash changed:
RETURN_REVIEWER_F_R1R5_ACTIVE_CONFIG_DRIFT

No restart-count claim is required in this Gate.

## Phase B — primary generic static-response extraction

Parse the fresh active JSON in memory.

Find the smallest route-like dictionary subtree which contains the exact host matcher:
edge-test.spikersun.com

Within that subtree, recursively find dictionaries where:
handler == "static_response"

Do not assume route indices, server names or fixed nesting.

If exactly one static_response handler is found and its body is textual/UTF-8 and status is safely determined:
- recover status;
- recover exact body bytes in memory;
- recover configured static-response headers only if present and non-sensitive;
- compute body bytes + SHA-256;
- classify PRIMARY_JSON_EXTRACTION=PASS.

If not, do not RETURN yet. Enter behavioral fallback.

## Phase C — behavioral fallback

Run only if primary extraction is unavailable/ambiguous.

All requests are local to the existing Caddy container.

### HTTPS behavior

From inside spikersun-edge-caddy-1, request:

https://edge-test.spikersun.com/

with edge-test.spikersun.com resolved to 127.0.0.1 for this curl invocation and TLS verification disabled only for this local diagnostic.

Capture in process memory:
- HTTP status;
- body exact bytes;
- body SHA-256;
- body byte length;
- response header names/values filtered for non-sensitive semantics.

Require:

status=200
body_bytes=30
body_sha256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824

If fingerprint differs:
RETURN_REVIEWER_F_R1R5_EDGE_TEST_BEHAVIOR_DRIFT

### HTTP behavior

Also issue a local HTTP request using the same host.

Classify only:
- status;
- same-origin HTTPS redirect location if redirect;
- or same static body fingerprint if HTTP directly serves it.

Allowed current forms:
A. HTTP redirects to https://edge-test.spikersun.com/... and HTTPS serves the accepted static body;
B. HTTP directly serves the same accepted static body.

Anything else:
RETURN_REVIEWER_F_R1R5_EDGE_TEST_PROTOCOL_BEHAVIOR_UNRESOLVED

### Header safety

Ignore volatile/transport-generated headers when reconstructing:
- Date
- Server
- Content-Length
- Connection
- Alt-Svc

If other configured-looking headers exist, preserve them only if clearly non-sensitive and representable. Otherwise RETURN rather than guessing.

Exact body must never be emitted to Evidence/GitHub.

## Phase D — build edge-test Caddyfile-equivalent behavior

If HTTPS form A:
use a normal site address:
edge-test.spikersun.com

If HTTP-only/direct form B with no working HTTPS:
use the appropriate explicit http:// site address.

Construct the response with:
- Caddy respond directive;
- exact recovered body;
- exact status;
- required non-sensitive configured headers if any.

Use an in-memory Caddyfile heredoc marker not present in the body.
Account for Caddy heredoc trailing-newline semantics.

Candidate encoding may be adapted up to two in-memory attempts solely to correct text-token/trailing-newline encoding. This is not a runtime retry and performs no write.

## Phase E — candidate

Candidate =
1. exact current durable Caddyfile bytes unchanged;
2. behaviorally equivalent edge-test block;
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Candidate remains memory/stdin only.

No temp candidate file.

Record bytes + SHA-256.

## Phase F — adapt only

Use:

docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -

with candidate on stdin.

No /load.
No reload/restart.

Require native success and no material warning.

Parse adapted JSON generically.

## Phase G — adapted semantic proof

For edge-test candidate route:
- find host matcher;
- find descendant static_response handler;
- require status equal recovered current status;
- require body bytes equal current body bytes;
- require body SHA-256 equal current body SHA-256;
- require preserved non-sensitive configured headers where applicable.

For Mini Craft:
- find host matcher minicraft.spikersun.com;
- find descendant reverse_proxy handler;
- require upstream/dial exactly wordpress:80.

Require:

LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

## Phase H — future mutation plan

Freeze only; do not execute:

1. fresh container-loopback active config GET;
2. verify active config SHA or edge-test behavior fingerprint has not drifted;
3. verify durable Caddyfile SHA unchanged;
4. backup current durable Caddyfile;
5. atomic write exact validated candidate by SHA-256;
6. adapt written Caddyfile;
7. zero-downtime caddy reload only;
8. immediately re-probe edge-test local HTTP/HTTPS behavior and require same fingerprint;
9. verify localhost;
10. verify Mini Craft Host-header private route to wordpress:80;
11. read WordPress indexing state;
12. if indexable, apply bounded noindex before DNS;
13. create DNS-only A minicraft.spikersun.com -> 2.24.193.133;
14. validate DNS/TLS/public Sandbox routes;
15. no actual payment;
16. rollback DNS first, then durable Caddyfile to backup if canary fails, proving edge-test fingerprint restored.

Require:
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

## Carry-forward

DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO

## Hard boundaries

No:
- Caddyfile write;
- candidate persistent file;
- Admin /load;
- Caddy reload/restart;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- external edge-test traffic; probes must resolve locally to 127.0.0.1;
- unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT
SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
EDGE_TEST_RECOVERY_METHOD=
EDGE_TEST_CURRENT_HTTPS_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
EDGE_TEST_CURRENT_HTTP_BEHAVIOR=
EDGE_TEST_CONFIGURED_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=PASS
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
STOP_AT_REVIEWER=YES

A PASS_CANDIDATE authorizes no Shared Infra or DNS mutation.
