# K6 Phase F-R1R2 — Caddy-only Read-only Source Reconciliation

Gate:
K6_PHASE_F_R1R2_CADDY_ONLY_READONLY_SOURCE_RECONCILIATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R1_RETURN_F_R1R2_CADDY_ONLY_RECONCILIATION.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Objective

Stop spending Gate budget on peripheral port probes. Complete only the Caddy startup-source / active-config / autosave reconciliation, candidate adapt, upstream reachability and indexing classification.

## Accepted baseline

Carry forward absent fresh material drift:
- private Mini Craft runtime PASS
- serialized migration PASS
- no public Mini Craft ingress
- Caddy owns 80/443
- active Caddy has localhost + edge-test.spikersun.com
- durable Caddyfile has localhost only
- Mini Craft WordPress already on spikersun-edge
- edge -> wordpress:80 previously PASS
- no Docker network/Compose change required
- PayPal Sandbox YES / Live NO
- Product 223 is Sandbox-canary-only and blocks Soft Launch

## SSH

Exactly one canonical strict SSH session.

Pre-sudo require:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

Read-only fallback methods are allowed within the same session when a formatting/parser command fails without side effects.

## A — minimal continuity

Read-only only:
- Caddy running/restart stable
- WordPress running/restart stable
- MariaDB healthy/restart stable
- fresh public Mini Craft DNS remains NXDOMAIN
- active Caddy has no Mini Craft host route

Do not inspect WordPress or DB host ports in this Gate.

## B — startup source

Read:
- Caddy Entrypoint
- Caddy Cmd
- Caddyfile mount source/destination
- HOME / XDG_CONFIG_HOME only
- --resume YES/NO
- persist_config state

Preferred:
docker inspect --format

Fallback if the format expression itself fails:
- one raw docker inspect JSON read
- in-memory filtering only
- no raw JSON in Evidence

Record:
CADDY_START_MODE
CADDY_PERSIST_CONFIG
CADDY_CONFIG_DIR

## C — active config + autosave

Locate autosave.json.

Record only:
- path
- exists
- bytes
- mtime
- SHA-256

Read Admin API active config + autosave in memory only.

Parsing:
- existing jq preferred
- otherwise Python stdlib JSON with dict/list access

A parse/shape error may fall back to the other parser in the same SSH session.

No package installation.

No raw full config in Evidence.

## D — route semantics

Prove whether autosave and active HTTP routes correspond.

Recover:
- localhost route semantics
- edge-test.spikersun.com route semantics

Evidence for edge-test:
- handler type
- status
- non-sensitive headers if required
- body byte count
- body SHA-256

Exact body may only remain in process memory for candidate construction.

If unrecoverable:
RETURN_REVIEWER_F_R1R2_CADDY_ACTIVE_ROUTE_UNRECOVERABLE

## E — candidate via stdin

Start from existing durable Caddyfile content and preserve localhost unchanged.

Append reconstructed edge-test block and:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Candidate must stay in memory/stdin.

Run:
caddy adapt --adapter caddyfile --config -

No file write.
No /load.
No reload/restart.

Require:
- adapt PASS
- localhost parity PASS
- edge-test parity PASS
- Mini Craft upstream exactly wordpress:80

Record candidate bytes + SHA-256.

## F — upstream reachability

After candidate adapt PASS, bounded read-only probe from current shared-edge context to wordpress:80.

Require HTTP 200.

No route/network change.

## G — indexing

Read-only classify current WordPress search-engine visibility/noindex state:

LAUNCH_SAFE_NOINDEX

or

INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE

No indexing write.

## H — freeze future mutation plan

Only if all above PASS, freeze:
1. fresh active/edge-test fingerprint check
2. backup current durable Caddyfile
3. atomic validated candidate install
4. adapt/validate
5. caddy reload only
6. verify localhost + edge-test unchanged
7. verify Mini Craft Host-header route
8. bounded noindex before DNS if required
9. DNS-only A minicraft -> 2.24.193.133
10. public DNS/TLS/Sandbox route validation
11. rollback DNS first, then Mini Craft Caddy addition only

Do not execute.

## Forbidden

No Caddy write/load/reload/restart, autosave write, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret value/hash output, or unrelated mutation.

## Evidence markers

SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=
WORDPRESS_RUNTIME_CONTINUITY=
MARIADB_HEALTH=
CURRENT_MINICRAFT_DNS=
CURRENT_MINICRAFT_CADDY_ROUTE=
CADDY_START_MODE=
CADDY_PERSIST_CONFIG=
CADDY_CONFIG_DIR=
CADDY_AUTOSAVE_PATH=
CADDY_AUTOSAVE_EXISTS=
CADDY_AUTOSAVE_BYTES=
CADDY_AUTOSAVE_SHA256=
CADDY_ACTIVE_CONFIG_SHA256=
AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=
LOCALHOST_ROUTE_PRESERVED=
EDGE_TEST_ROUTE_RECOVERABLE=
EDGE_TEST_ROUTE_FINGERPRINT=
CANDIDATE_CADDYFILE_ADAPT=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=
CANARY_INDEXING_STATE=
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
PASS_CANDIDATE_K6_PHASE_F_R1R2_CADDY_ONLY_READONLY_SOURCE_RECONCILIATION

Otherwise precise RETURN_*.
