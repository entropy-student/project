# K6 Phase F-R1R1 — Native Read-only Caddy Source Reconciliation

Gate:
K6_PHASE_F_R1R1_NATIVE_READONLY_CADDY_SOURCE_RECONCILIATION

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1_RETURN_F_R1R1_NATIVE_READONLY_RECONCILIATION.md
- latest accepted Evidence/Handoff
- unique current Shared VPS Handoff

## Objective

Replace the failed object/attribute-style helper with direct native read-only commands, then complete the previously authorized Caddy startup/active/autosave reconciliation and candidate adaptation.

## Accepted baseline

Carry forward unless fresh read-back proves drift:
- Mini Craft private runtime PASS
- serialized migration PASS
- Caddy owns 80/443
- durable Caddyfile currently contains localhost only
- active Caddy contains localhost + edge-test.spikersun.com
- Mini Craft WordPress already on spikersun-edge
- edge -> wordpress:80 PASS
- no Docker network/Compose change required
- Mini Craft DNS previously NXDOMAIN
- PayPal Sandbox YES / Live NO

## SSH

Exactly one canonical strict SSH invocation/session.

At remote payload start, pre-sudo:
- whoami
- id -un
- id -u
- hostname

Require ops / ops / nonzero UID / srv1970241.

No reconnect inside this Gate.

## A — minimal continuity

Read-only:
- Caddy running/stable
- WordPress running/stable
- MariaDB healthy/stable
- no WordPress/DB host ports
- no Mini Craft public Caddy route
- edge -> wordpress:80 HTTP 200
- fresh public DNS NXDOMAIN

## B — direct native Caddy metadata

Do not reuse the failed helper.

Use docker inspect --format for:
- Entrypoint
- Cmd
- mount source/destination
- network metadata

Filter environment output to HOME/XDG_CONFIG_HOME only.

Determine:
- startup mode
- --resume YES/NO
- persist_config on/off
- config directory
- autosave path

Record autosave exists/bytes/mtime/SHA-256.

Hash active Admin API config without printing it raw.

No package installation.

## C — JSON parsing boundary

Use jq only if already installed.

If jq is unavailable, Python standard library is allowed only for JSON parsing:
- json.load/json.loads
- dict.get/indexing/type checks
- no attribute-style object access
- no third-party module

Active and autosave JSON must remain inside the remote process until filtered.

Evidence allowlist:
- host matchers
- handler types
- proxy upstream identities
- static-response status
- non-sensitive header names if relevant
- body bytes/hash only
- persistence classification

Do not emit raw full config or sensitive values.

## D — route recovery

Recover:
- localhost semantics
- edge-test.spikersun.com semantics

For edge-test, retain:
- handler type
- status
- body length
- body SHA-256
- any required non-sensitive header semantics

Exact body may be held only in process memory for candidate construction.

If unrecoverable:
RETURN_REVIEWER_F_R1R1_CADDY_ACTIVE_CONFIG_NOT_RECOVERABLE

## E — candidate via stdin only

Use current durable Caddyfile localhost semantics unchanged.

In memory add:
- recovered edge-test route
- minicraft.spikersun.com reverse_proxy wordpress:80

Pipe candidate to:
caddy adapt --adapter caddyfile --config -

Do not write candidate to disk.
Do not call /load.
Do not reload.

Require:
- adapt exit 0
- no material warning
- existing localhost parity PASS
- existing edge-test parity PASS
- Mini Craft upstream exactly wordpress:80

Record candidate bytes and SHA-256 only.

## F — persistence conclusion

Require:
CADDY_SOURCE_RECONCILIATION=ACTIVE_AUTOSAVE_RECOVERABLE_CADDYFILE_CANDIDATE_VALIDATED

Otherwise precise RETURN.

## G — indexing / canary

Fresh read-only determine:
- blog_public/search-engine visibility
- current noindex behavior

Return:
LAUNCH_SAFE_NOINDEX

or:
INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE

Product 223 remains Sandbox-canary-only and blocks Soft Launch/real sales.

DNS policy remains:
A minicraft.spikersun.com -> 2.24.193.133
DNS-only for initial Sandbox canary.

## H — exact future mutation plan

Freeze only:
1. fresh active/edge-test fingerprint check
2. backup current durable Caddyfile
3. atomic validated candidate write
4. caddy adapt/validate
5. caddy reload only, never restart
6. verify localhost + edge-test unchanged
7. verify Mini Craft Host-header route
8. if necessary set launch-safe noindex before DNS
9. create DNS-only A record
10. validate DNS/TLS/public Sandbox routes
11. rollback DNS then Mini Craft Caddy addition only

Do not execute.

## Forbidden

No Caddyfile/autosave/Admin API load/reload/restart write, DNS/cloudflared/UFW/network/Compose mutation, package install, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret value/hash output, or unrelated changes.

## Evidence

SSH_ATTEMPTS=
REMOTE_IDENTITY=
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
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=
CANDIDATE_CADDYFILE_ADAPT=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
CADDY_SOURCE_RECONCILIATION=
CURRENT_MINICRAFT_DNS=
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
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

Success:
PASS_CANDIDATE_K6_PHASE_F_R1R1_NATIVE_READONLY_CADDY_SOURCE_RECONCILIATION

Otherwise precise RETURN_*.
