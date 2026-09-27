# K6 Phase F-R1R3 — Active Caddy Route Recovery + Candidate Adapt

Gate:
K6_PHASE_F_R1R3_ACTIVE_CADDY_ROUTE_RECOVERY_AND_CANDIDATE_ADAPT

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R2_RETURN_F_R1R3_ACTIVE_ROUTE_RECOVERY.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Objective

Complete only the material Caddy reconciliation needed before public ingress:
durable Caddyfile + current active Admin config -> recover edge-test -> construct candidate -> adapt-only -> semantic parity -> exact future mutation/rollback plan.

## Accepted baseline

Carry forward absent fresh material drift:
- Mini Craft private runtime PASS
- serialized URL migration PASS
- Caddy owns 80/443
- durable Caddyfile source is /srv/infra/edge/Caddyfile
- durable file has localhost baseline
- active Caddy previously has localhost + edge-test.spikersun.com
- no active Mini Craft route previously
- Mini Craft upstream is wordpress:80 on existing spikersun-edge
- no Docker network/Compose change required
- DNS previously/freshly NXDOMAIN
- PayPal Sandbox YES / Live NO
- Product 223 is Sandbox-canary-only and blocks Soft Launch

## SSH

Exactly one canonical strict SSH session.

Pre-sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

## A — minimal continuity

Read-only only:
- Caddy running/restart stable
- WordPress running/restart stable
- MariaDB healthy/restart stable
- fresh public DNS remains NXDOMAIN
- current active Caddy has no minicraft.spikersun.com route

Do not inspect:
- Entrypoint/Cmd
- autosave
- host ports
- indexing
- DB/table/serialized-migration state

## B — durable Caddyfile

Read /srv/infra/edge/Caddyfile.

Record only:
- bytes
- SHA-256
- host labels

Use the exact current durable file bytes as candidate baseline.

Do not mutate it.

## C — active Admin config

GET:
http://127.0.0.1:2019/config/

Keep raw JSON inside the remote process.

Record:
- HTTP/read success
- raw bytes
- SHA-256

Do not output raw full JSON.

Parse using:
- existing jq; or
- Python stdlib JSON with generic recursive dict/list traversal.

No fixed route index/server-name/schema assumption.

## D — active host discovery

Generic recursive search for exact host matcher values:
- localhost
- edge-test.spikersun.com
- minicraft.spikersun.com

Require:
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT

Unexpected Mini Craft route:
RETURN_REVIEWER_F_R1R3_UNEXPECTED_PUBLIC_ROUTE_DRIFT

## E — edge-test recovery

Recover the active edge-test route only.

Expected prior accepted class:
STATIC_RESPONSE

Allowlisted recovery:
- host matcher
- handler type/chain for this route
- response status
- exact response body in process memory only
- body byte count
- body SHA-256
- required non-sensitive response headers if present

Evidence must not contain exact body unless absolutely unavoidable.

If route is no longer safely reconstructable as a Caddyfile-equivalent static response:
RETURN_REVIEWER_F_R1R3_EDGE_TEST_ROUTE_NOT_SAFELY_RECONSTRUCTABLE

## F — candidate in memory

Candidate =
1. exact durable Caddyfile bytes unchanged
2. reconstructed edge-test block
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Keep candidate only in memory/stdin.

Record:
CANDIDATE_CADDYFILE_BYTES
CANDIDATE_CADDYFILE_SHA256

No persistent candidate file.

## G — adapt only

Preferred:
POST http://127.0.0.1:2019/adapt
Content-Type: text/caddyfile

Allowed fallback:
caddy adapt --adapter caddyfile --config -

Do not call /load.
Do not reload/restart.

Require adaptation success and no material semantic warning/error.

## H — semantic comparison

Parse adapted candidate in memory.

Require:
- localhost host route exists
- edge-test host route exists
- Mini Craft host route exists
- candidate edge-test status/body/hash/required headers equal active edge-test
- Mini Craft reverse_proxy upstream exactly wordpress:80

Record:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

Do not require complete active-config equality.

## I — future mutation plan

Freeze only; do not execute:

1. fresh active edge-test fingerprint check
2. durable Caddyfile SHA match
3. backup current durable Caddyfile
4. atomic install exact validated candidate
5. adapt written file
6. caddy reload only
7. verify localhost + edge-test unchanged
8. verify Mini Craft Host-header route
9. read indexing state; if indexable, bounded noindex before DNS
10. create DNS-only A minicraft.spikersun.com -> 2.24.193.133
11. verify DNS/TLS/public Sandbox routes
12. no payment action
13. rollback DNS first then only Mini Craft Caddy addition on canary failure

Require:
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

## Forbidden

No Caddyfile write/load/reload/restart, autosave work, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret value/hash output, unrelated changes.

## Evidence markers

SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=
WORDPRESS_RUNTIME_CONTINUITY=
MARIADB_HEALTH=
CURRENT_MINICRAFT_DNS=
DURABLE_CADDYFILE_BYTES=
DURABLE_CADDYFILE_SHA256=
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
PASS_CANDIDATE_K6_PHASE_F_R1R3_ACTIVE_CADDY_ROUTE_RECOVERY_AND_CANDIDATE_ADAPT

Otherwise precise RETURN_*.
