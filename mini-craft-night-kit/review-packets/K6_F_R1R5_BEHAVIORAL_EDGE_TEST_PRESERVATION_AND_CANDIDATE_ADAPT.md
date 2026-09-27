# K6 Phase F-R1R5 — Behavioral edge-test preservation + candidate adapt

Gate:
K6_PHASE_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R4_RETURN_F_R1R5_BEHAVIORAL_ROUTE_PRESERVATION.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Objective

Preserve edge-test.spikersun.com by observable behavior rather than by reproducing its internal active-JSON route schema. Build one in-memory candidate that keeps the durable localhost baseline, reproduces edge-test, adds Mini Craft, and passes adapt-only semantic checks.

## Frozen accepted state

- durable Caddyfile SHA-256:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
- active config SHA-256:
  206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
- active localhost FOUND
- active edge-test FOUND
- active Mini Craft ABSENT
- historical edge-test response:
  - status 200
  - body bytes 30
  - body SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- Mini Craft DNS NXDOMAIN
- PayPal Sandbox YES / Live NO

## SSH

Exactly one canonical strict SSH session.

Pre-sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

## A — frozen-state checks

Read-only:
- Caddy running
- WordPress running
- MariaDB healthy
- Mini Craft DNS fresh NXDOMAIN
- durable Caddyfile SHA exact frozen value
- container-loopback GET /config/ succeeds
- active config SHA exact frozen value

Active SHA mismatch:
RETURN_REVIEWER_F_R1R5_ACTIVE_CONFIG_DRIFT

No restart-count requirement.

## B — primary route extraction

Parse active JSON in memory.

Find a route-like subtree containing exact host matcher:
edge-test.spikersun.com

Within it recursively find dictionaries where:
handler == static_response

If exactly one safely extractable handler:
- recover status
- recover exact textual body in memory
- recover non-sensitive configured headers if present
- compute body bytes/hash
- EDGE_TEST_RECOVERY_METHOD=PRIMARY_JSON_STATIC_RESPONSE

If ambiguous, proceed to behavioral fallback rather than RETURN.

## C — behavioral fallback

Only when primary extraction is ambiguous.

All probes must stay local by resolving edge-test.spikersun.com to 127.0.0.1 inside spikersun-edge-caddy-1.

### HTTPS

Probe:
https://edge-test.spikersun.com/

with local --resolve and diagnostic TLS verification bypass.

Capture in process memory:
- status
- body
- byte count
- SHA-256
- non-sensitive response headers

Require:
- status 200
- body bytes 30
- SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824

Mismatch:
RETURN_REVIEWER_F_R1R5_EDGE_TEST_BEHAVIOR_DRIFT

### HTTP

Probe:
http://edge-test.spikersun.com/

resolved locally to 127.0.0.1.

Allowed:
- same-origin redirect to HTTPS followed by accepted HTTPS body, or
- direct serving of same accepted static body.

Other behavior:
RETURN_REVIEWER_F_R1R5_EDGE_TEST_PROTOCOL_BEHAVIOR_UNRESOLVED

### Headers

Ignore volatile transport-generated headers:
- Date
- Server
- Content-Length
- Connection
- Alt-Svc

If additional configured-looking headers exist, preserve only if clearly non-sensitive and safely representable. Otherwise RETURN.

Set:
EDGE_TEST_RECOVERY_METHOD=BEHAVIORAL_LOCAL_HTTP_HTTPS

Do not emit exact body.

## D — construct equivalent edge-test block

Generate Caddyfile behavior equivalent to the current route:
- normal hostname site if HTTPS is current behavior
- explicit http:// site only if current route is truly HTTP-only
- respond with exact recovered body and status
- preserve required non-sensitive configured headers

Use a Caddyfile heredoc marker not present in body.

Candidate encoding may be adapted up to two times in memory solely to correct heredoc/trailing-newline representation.

No runtime state changes.

## E — candidate

Candidate:
1. exact current durable Caddyfile bytes unchanged
2. edge-test equivalent block
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Memory/stdin only.

No candidate file.

Record bytes + SHA-256.

## F — adapt only

Run:

docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -

Candidate via stdin.

No /load.
No reload/restart.

Require adapt success and no material warning.

## G — adapted semantic checks

Parse adapted JSON generically.

For candidate edge-test:
- host matcher exists
- descendant static_response exists
- status equals current status
- body bytes/hash equal current body
- required configured headers equal current behavior

For Mini Craft:
- host matcher exists
- descendant reverse_proxy exists
- upstream/dial exactly wordpress:80

Require:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

## H — freeze later mutation

Plan only:
1. fresh active config/behavior fingerprint check
2. durable Caddyfile SHA check
3. Shared Infra backup of durable Caddyfile
4. atomic exact candidate write
5. adapt written file
6. caddy reload only
7. re-probe edge-test and require identical behavior
8. verify localhost
9. verify Mini Craft Host-header private route
10. check indexing; bounded noindex if required before DNS
11. create DNS-only A minicraft -> 2.24.193.133
12. validate DNS/TLS/public Sandbox routes
13. no payment
14. rollback DNS first, then durable Caddyfile backup, re-proving edge-test fingerprint

No execution here.

## Forbidden

No Caddyfile write, candidate temp file, /load, reload/restart, public DNS mutation, cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret value/hash output, external edge-test traffic, unrelated changes.

## Evidence

SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=
CONTAINER_ADMIN_CONFIG_GET=
CURRENT_ACTIVE_CONFIG_SHA256=
EDGE_TEST_RECOVERY_METHOD=
EDGE_TEST_CURRENT_HTTPS_STATUS=
EDGE_TEST_CURRENT_BODY_BYTES=
EDGE_TEST_CURRENT_BODY_SHA256=
EDGE_TEST_CURRENT_HTTP_BEHAVIOR=
EDGE_TEST_CONFIGURED_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=
LOCALHOST_DURABLE_BASELINE_PRESERVED=
EDGE_TEST_BEHAVIORAL_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PUBLIC_INGRESS_CHANGESET=
ROLLBACK_PLAN=
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
STOP_AT_REVIEWER=YES

Success:
PASS_CANDIDATE_K6_PHASE_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT

Otherwise precise RETURN_*.
