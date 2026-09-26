# K6 Phase F-R1 — Shared Ingress Config Source Reconciliation

Gate: K6_PHASE_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_RETURN_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Goal

Reconcile the running Caddy Admin API config, autosaved config, and startup Caddyfile without any write, then freeze one exact ingress candidate and rollback plan.

## Accepted facts

- private Mini Craft runtime and serialized migration PASS
- Caddy owns 80/443
- startup source /srv/infra/edge/Caddyfile currently contains localhost only
- active Caddy contains localhost + edge-test.spikersun.com
- Mini Craft WordPress is already reachable from shared edge at wordpress:80
- no Docker network or Compose change needed
- minicraft.spikersun.com currently NXDOMAIN
- cloudflared local change not needed
- PayPal Sandbox YES / Live NO

## A — minimal continuity

Read-only verify SSH identity, Caddy/WordPress/MariaDB continuity, no public Mini Craft route, edge->wordpress:80 HTTP reachability, and DNS still absent.

## B — Caddy persistence model

Read Entrypoint/Cmd, startup mode, relevant non-secret HOME/XDG_CONFIG_HOME, persist_config state, autosave path, autosave metadata/hash, and active Admin config normalized hash.

## C — semantic recovery

Read active config and autosave in memory. Filter to HTTP routing semantics only.
Prove whether autosave matches active HTTP routes.
Recover localhost and edge-test semantics sufficiently to reproduce them exactly.
For edge-test retain in Evidence only: host, handler type, status, header metadata if relevant, body bytes, body SHA-256. Do not publish unnecessary exact body text.

If existing active behavior is not safely recoverable: RETURN_REVIEWER_F_R1_CADDY_ACTIVE_CONFIG_NOT_RECOVERABLE.

## D — candidate Caddyfile, no write

Build in memory only:
- current localhost semantics unchanged
- current edge-test.spikersun.com semantics unchanged
- add minicraft.spikersun.com reverse_proxy wordpress:80

Run caddy adapt or Admin API /adapt only. Do not load/reload.
Compare adapted candidate semantics to active routes and require exact parity for existing routes.
Record candidate SHA-256.

## E — future changeset

Freeze exact later mutation sequence:
1. fresh active-config fingerprint check
2. backup durable Caddyfile
3. atomic candidate write
4. adapt/validate
5. zero-downtime reload only
6. verify localhost + edge-test unchanged
7. verify Mini Craft Host-header route
8. create DNS-only A minicraft -> 2.24.193.133
9. verify DNS/TLS/public Sandbox routes
10. rollback DNS + Mini Craft route only if validation fails

No execution in F-R1.

## F — canary/indexing safety

Read blog_public/search-engine visibility and current noindex behavior.
Classify:
- LAUNCH_SAFE_NOINDEX
or
- INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE

Product 223 remains allowed only as bounded Sandbox canary test data and continues to block Soft Launch / real sales.

## DNS policy

Initial Sandbox canary: A record minicraft -> 2.24.193.133, DNS-only.
No DNS write in this Gate.

## Forbidden

No Caddy write/reload/restart, autosave mutation, DNS/cloudflared/UFW/network/Compose write, public ingress, product/indexing mutation, provider action, Live/payment/refund, Secret value/hash output, or unrelated changes.

## Evidence markers

CADDY_START_MODE=
CADDY_PERSIST_CONFIG=
CADDY_AUTOSAVE_PATH=
CADDY_AUTOSAVE_EXISTS=
CADDY_AUTOSAVE_BYTES=
CADDY_AUTOSAVE_SHA256=
CADDY_ACTIVE_CONFIG_SHA256=
AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=
LOCALHOST_ROUTE_PRESERVED=
EDGE_TEST_ROUTE_RECOVERABLE=
EDGE_TEST_ROUTE_FINGERPRINT=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=PASS
CANDIDATE_CADDYFILE_ADAPT=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
CURRENT_MINICRAFT_DNS=NXDOMAIN
CANARY_INDEXING_STATE=
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PUBLIC_INGRESS_CHANGESET=
ROLLBACK_PLAN=
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
STOP_AT_REVIEWER=YES

Success: PASS_CANDIDATE_K6_PHASE_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION
Otherwise return precise RETURN_* and stop.