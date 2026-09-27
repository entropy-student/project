# K6 Phase F-R1R4 — Container-loopback Caddy Admin Recovery + Candidate Adapt

Gate:
K6_PHASE_F_R1R4_CONTAINER_LOOPBACK_CADDY_ADMIN_RECOVERY_AND_CANDIDATE_ADAPT

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R3_RETURN_F_R1R4_CONTAINER_LOOPBACK_ADMIN_RECOVERY.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Objective

Read Caddy active config from inside the Caddy container's own loopback namespace, recover edge-test, construct an in-memory candidate, adapt it without loading, and prove route parity.

## Accepted baseline

Carry forward absent fresh material drift:
- private Mini Craft runtime PASS
- serialized migration PASS
- shared Caddy owns 80/443
- durable Caddyfile /srv/infra/edge/Caddyfile
- durable SHA-256 12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
- durable hostname label localhost
- active Caddy previously contained localhost + edge-test.spikersun.com
- Mini Craft active route absent previously
- Mini Craft upstream wordpress:80
- DNS NXDOMAIN
- PayPal Sandbox YES / Live NO

## SSH

Exactly one canonical strict SSH session.

Pre-sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

## A — minimal continuity

Read-only:
- Caddy running/restart stable
- WordPress running/restart stable
- MariaDB healthy/restart stable
- fresh DNS NXDOMAIN
- durable Caddyfile SHA remains exact frozen value

No other preflight.

## B — container-loopback Admin GET

Do not query host 127.0.0.1:2019.

Execute inside:
spikersun-edge-caddy-1

Use the curl already present in the official Caddy image:

curl -fsS http://127.0.0.1:2019/config/

Capture response only inside the remote process.

Record:
- success/failure
- bytes
- SHA-256

Do not output raw JSON.

On failure:
RETURN_REVIEWER_F_R1R4_CONTAINER_ADMIN_API_UNAVAILABLE
with bounded curl/native error classification only.

Do not try alternate ports, host exposure, network mutation, or a second SSH.

## C — generic active host discovery

Parse active config with:
- existing jq, or
- Python stdlib JSON recursive dict/list traversal

No fixed server/index assumptions.

Find exact host matchers:
- localhost
- edge-test.spikersun.com
- minicraft.spikersun.com

Require:
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT

Unexpected Mini Craft route:
RETURN_REVIEWER_F_R1R4_UNEXPECTED_MINICRAFT_ACTIVE_ROUTE

## D — edge-test recovery

Recover current edge-test semantics:
- handler class/chain
- status
- exact body only in process memory
- body bytes
- body SHA-256
- required non-sensitive headers if applicable

Do not emit exact body.

If not safely reconstructable in Caddyfile:
RETURN_REVIEWER_F_R1R4_EDGE_TEST_NOT_RECONSTRUCTABLE

## E — candidate

Read current durable Caddyfile bytes.

Candidate =
1. exact durable bytes unchanged
2. reconstructed edge-test block
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Memory/stdin only.
No candidate file.

Record candidate bytes + SHA-256.

## F — adapt only, inside Caddy container

Preferred:

POST http://127.0.0.1:2019/adapt
Content-Type: text/caddyfile

from inside spikersun-edge-caddy-1, using candidate bytes from stdin.

Allowed fallback:

docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -

No /load.
No reload/restart.

Require adapt success.

## G — semantic parity

Parse adapted JSON in memory.

Require:
- localhost present
- edge-test present
- Mini Craft present
- edge-test candidate equals active status/body hash/required headers
- Mini Craft reverse_proxy upstream exactly wordpress:80

Record:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

## H — freeze later mutation

Plan only:
1. fresh container-loopback active config read
2. edge-test fingerprint unchanged
3. durable SHA unchanged
4. backup current durable Caddyfile
5. atomic write exact validated candidate
6. adapt written file
7. caddy reload only
8. verify localhost + edge-test unchanged
9. verify Mini Craft Host-header route
10. read indexing state; bounded noindex if needed
11. DNS-only A minicraft -> 2.24.193.133
12. verify DNS/TLS/public Sandbox routes
13. no payment
14. rollback DNS first, then Mini Craft Caddy addition only

No execution here.

## Forbidden

No host port 2019 exposure, Caddyfile write/load/reload/restart, autosave work, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret value/hash output, unrelated changes.

## Evidence markers

SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=
WORDPRESS_RUNTIME_CONTINUITY=
MARIADB_HEALTH=
CURRENT_MINICRAFT_DNS=
DURABLE_CADDYFILE_SHA256=
CONTAINER_ADMIN_CONFIG_GET=
CURRENT_ACTIVE_CONFIG_BYTES=
CURRENT_ACTIVE_CONFIG_SHA256=
CURRENT_ACTIVE_LOCALHOST_ROUTE=
CURRENT_ACTIVE_EDGE_TEST_ROUTE=
CURRENT_ACTIVE_MINICRAFT_ROUTE=
EDGE_TEST_ROUTE_CLASS=
EDGE_TEST_STATUS=
EDGE_TEST_BODY_BYTES=
EDGE_TEST_BODY_SHA256=
EDGE_TEST_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=
LOCALHOST_DURABLE_BASELINE_PRESERVED=
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=
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
PASS_CANDIDATE_K6_PHASE_F_R1R4_CONTAINER_LOOPBACK_CADDY_ADMIN_RECOVERY_AND_CANDIDATE_ADAPT

Otherwise precise RETURN_*.
