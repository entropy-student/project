# Reviewer Decision — K6 F-R1R1 RETURN Accepted / F-R1R2 Caddy-only Reconciliation

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R1_NATIVE_READONLY_CADDY_SOURCE_RECONCILIATION
RESULT=RETURN_REVIEWER_F_R1R1_READONLY_PROBE_FAILED
EVIDENCE_COMMIT=c85643be6e61698aa7dc7205abac12f4be045a47
HANDOFF_COMMIT=698b0781a2582d4e87554465bbede5c928dff925

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

This is a read-only probe implementation failure at WP_PORTS:
- exactly one strict SSH session established;
- ops@srv1970241 identity PASS;
- Caddy/WordPress/MariaDB running with restart count 0;
- MariaDB healthy;
- fresh public DNS NXDOMAIN;
- no Shared Infra/app/DNS/product/payment write;
- no persistent temporary artifact.

This is not evidence of port drift, Caddy drift, or application drift.

## Reviewer design correction

F-R1R2 removes non-essential port probing from the Gate.

Reason:
- no application/Compose/network/public-ingress writes occurred after the repeatedly accepted no-host-port baseline;
- host-port state is not necessary to reconcile Caddy startup source, active config, autosave, or candidate adaptation;
- a formatting failure in a peripheral read-only probe must not repeatedly block the material reconciliation objective.

F-R1R2 also allows bounded read-only fallback **inside the same SSH session**:
- if docker inspect --format fails for metadata formatting only, the Executor may use one raw docker inspect JSON read and filter it in memory;
- if jq is unavailable, Python stdlib JSON parsing may be used;
- such fallback is not an SSH retry and does not weaken trust or mutate state.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R2_CADDY_ONLY_READONLY_SOURCE_RECONCILIATION
OWNER_ACTION=NONE

Read-only only.

## SSH boundary

Exactly one canonical strict SSH invocation/session.

Pre-sudo:
- whoami=ops
- id -un=ops
- uid nonzero
- hostname=srv1970241

No reconnect.

A failed read-only formatting/parser method may use the explicitly allowed in-session fallback below, provided:
- the original subcommand made no write;
- the failure is clearly local formatting/parser related;
- no trust/transport ambiguity exists.

## Phase A — minimal continuity only

Verify only:
- Caddy running/restart stable;
- WordPress running/restart stable;
- MariaDB healthy/restart stable;
- fresh public minicraft.spikersun.com DNS remains NXDOMAIN;
- no active Mini Craft host route in Caddy.

Do not probe WordPress/DB host ports in this Gate.
Do not repeat DB/table/URL migration validation.

## Phase B — Caddy startup source

Read:
- Caddy Entrypoint;
- Caddy Cmd;
- Caddyfile mount source/destination;
- HOME and XDG_CONFIG_HOME only;
- whether startup uses --resume;
- whether persist_config is disabled.

Preferred method:
docker inspect --format

Allowed in-session fallback if formatting itself fails:
- docker inspect <caddy-container> once as raw JSON;
- parse only needed allowlisted fields in memory;
- do not emit raw JSON to Evidence.

Record:
CADDY_START_MODE=
CADDY_PERSIST_CONFIG=
CADDY_CONFIG_DIR=

## Phase C — active config and autosave

Locate autosave.json using observed config directory and Caddy conventions.

Record only metadata:
- path;
- exists;
- bytes;
- mtime;
- SHA-256.

Read current Admin API config and autosave JSON in memory.

Do not emit raw full config.

Allowed parsing:
1. existing jq;
2. Python stdlib json using dict/list access and explicit type checks.

No package installation.

If one parser method fails for a clearly local parse/shape reason, the other allowed parser may be used within the same SSH session.

Return only filtered HTTP semantics and hashes.

## Phase D — semantic reconciliation

Determine:
AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=YES|NO

Recover current semantics of:
- localhost;
- edge-test.spikersun.com.

For edge-test Evidence may include:
- host matcher;
- handler type;
- status;
- non-sensitive header names if needed;
- body byte count;
- body SHA-256.

Exact body may be retained only in process memory for candidate construction.

If active edge-test behavior cannot be reconstructed:
RETURN_REVIEWER_F_R1R2_CADDY_ACTIVE_ROUTE_UNRECOVERABLE

## Phase E — candidate Caddyfile, memory/stdin only

Start from the existing durable /srv/infra/edge/Caddyfile contents.

Preserve its localhost block unchanged.

Append:
1. recovered edge-test.spikersun.com exact semantics;
2. Mini Craft route:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Do not write candidate to disk.

Pipe candidate to:
caddy adapt --adapter caddyfile --config -

Do not load/reload/restart.

Require:
- adapt native exit 0;
- no material warning/error;
- localhost parity PASS;
- edge-test parity PASS;
- Mini Craft route exact upstream wordpress:80.

Record candidate bytes + SHA-256.

## Phase F — fresh private upstream confirmation

Only after candidate adapts successfully, perform one bounded read-only request from current shared-edge context to:
wordpress:80

Require HTTP 200.

No route/network mutation.

## Phase G — indexing safety

Fresh read-only classify:
- WordPress blog_public/search visibility;
- current noindex behavior.

Return:
CANARY_INDEXING_STATE=LAUNCH_SAFE_NOINDEX

or:
CANARY_INDEXING_STATE=INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE

No indexing mutation.

## Phase H — exact future mutation plan

Freeze only; do not execute:

1. fresh active route and edge-test fingerprint check;
2. backup current durable /srv/infra/edge/Caddyfile;
3. atomic install of validated candidate;
4. caddy adapt/validate;
5. zero-downtime caddy reload only;
6. verify localhost + edge-test unchanged;
7. verify Mini Craft host route;
8. if required, bounded noindex write before DNS;
9. DNS-only A minicraft.spikersun.com -> 2.24.193.133;
10. verify DNS/TLS/public Sandbox routes;
11. rollback DNS first then Mini Craft Caddy addition only.

Require:
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

## Carry-forward canary policy

DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PAYPAL_LIVE=NO

## Hard boundaries

No:
- Caddyfile write;
- Admin API load;
- Caddy reload/restart;
- autosave modification;
- DNS/cloudflared/UFW/network/Compose mutation;
- host-port mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R2_CADDY_ONLY_READONLY_SOURCE_RECONCILIATION
SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=PASS
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
CURRENT_MINICRAFT_DNS=NXDOMAIN
CURRENT_MINICRAFT_CADDY_ROUTE=ABSENT
CADDY_START_MODE=
CADDY_PERSIST_CONFIG=
CADDY_CONFIG_DIR=
CADDY_AUTOSAVE_PATH=
CADDY_AUTOSAVE_EXISTS=
CADDY_AUTOSAVE_BYTES=
CADDY_AUTOSAVE_SHA256=
CADDY_ACTIVE_CONFIG_SHA256=
AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=
LOCALHOST_ROUTE_PRESERVED=PASS
EDGE_TEST_ROUTE_RECOVERABLE=PASS
EDGE_TEST_ROUTE_FINGERPRINT=
CANDIDATE_CADDYFILE_ADAPT=PASS
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=PASS
CANARY_INDEXING_STATE=
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
