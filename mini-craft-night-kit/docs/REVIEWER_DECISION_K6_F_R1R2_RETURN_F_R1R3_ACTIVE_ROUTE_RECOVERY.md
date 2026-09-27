# Reviewer Decision — K6 F-R1R2 RETURN Accepted / F-R1R3 Active Route Recovery

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R2_CADDY_ONLY_READONLY_SOURCE_RECONCILIATION
RESULT=RETURN_REVIEWER_F_R1R2_READONLY_PROBE_FAILED
EVIDENCE_COMMIT=16e2c86039a26175f99204239c19c1bdf35f4a10
HANDOFF_COMMIT=0a99e9314e9ee9323502846f9122f52bdbe414aa

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

This is an Executor read-only metadata-parser failure.

Accepted facts:
- exactly one canonical strict SSH succeeded;
- host-key trust and ops@srv1970241 identity passed;
- Caddy/WordPress/MariaDB continuity passed;
- fresh public DNS remained NXDOMAIN;
- no Caddy/DNS/network/Compose/app/product/indexing/payment/Secret/Shared Infra write occurred;
- no persistent temp artifact was created.

This is not evidence of new Caddy, DNS, application, or infrastructure drift.

## Reviewer simplification

The prior Gates over-constrained the read-only reconciliation.

To safely preserve the unrelated active edge-test.spikersun.com behavior before a future Caddy reload, the Reviewer only needs:

1. the exact current durable Caddyfile content;
2. the exact current active HTTP routing semantics from Caddy Admin API;
3. a recoverable representation of the active edge-test route;
4. a candidate Caddyfile which keeps the durable localhost block unchanged, reproduces edge-test, and adds Mini Craft;
5. successful no-load adaptation and semantic comparison.

Entrypoint/Cmd, autosave path, persist_config state, WordPress/DB host ports, repeated private-upstream probes, and current indexing state are not prerequisites for this reconciliation and are removed from this Gate.

Indexing safety will be checked in the later authorized ingress mutation Gate immediately before public DNS, with a bounded noindex write if needed.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R3_ACTIVE_CADDY_ROUTE_RECOVERY_AND_CANDIDATE_ADAPT
OWNER_ACTION=NONE

Read-only only.

## SSH boundary

Exactly one canonical strict SSH invocation/session.

Pre-sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

No reconnect.

No custom metadata helper may terminate the session before the core Caddy reads.

## Phase A — minimal continuity

Verify only:
- Caddy running/restart stable;
- WordPress running/restart stable;
- MariaDB healthy/restart stable;
- fresh public minicraft.spikersun.com DNS remains NXDOMAIN;
- active Caddy config contains no minicraft.spikersun.com host route.

Do not read Entrypoint/Cmd.
Do not read autosave.
Do not probe host ports.
Do not repeat database/URL migration checks.
Do not probe indexing in this Gate.

## Phase B — durable Caddyfile read

Read the already-established durable source:

/srv/infra/edge/Caddyfile

Record:
- bytes;
- SHA-256;
- non-secret host labels present.

Do not mutate it.

The current localhost block from this exact file is the durable baseline and must be preserved byte-for-byte in candidate construction.

Do not emit unrelated response bodies or sensitive material if any.

## Phase C — active Admin API config read

Use the local Caddy Admin API:

GET http://127.0.0.1:2019/config/

Read the response only inside the remote process.

Record:
- response success;
- raw byte count;
- SHA-256.

Do not emit the full JSON into Evidence/GitHub.

Parse using either:
- existing jq; or
- Python standard-library json with recursive dict/list traversal.

The parser must make no assumptions about fixed array/string/null shapes outside fields explicitly type-checked.

## Phase D — generic active-route discovery

Use generic recursive traversal of the active JSON.

Search for host matcher values equal to:
- localhost
- edge-test.spikersun.com
- minicraft.spikersun.com

Do not assume server names, route indices, or nesting positions.

Require:
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT

If Mini Craft route is already present:
RETURN_REVIEWER_F_R1R3_UNEXPECTED_PUBLIC_ROUTE_DRIFT

## Phase E — recover edge-test semantics

From the active edge-test route, recover only the semantics necessary to reproduce it in a Caddyfile.

Expected prior accepted class:
STATIC_RESPONSE

Allowlisted recovery:
- host matcher;
- handler chain relevant to that host;
- response status;
- response body;
- required non-sensitive response headers, if any.

Evidence must not contain the exact body unless absolutely necessary.
Evidence should contain:
- handler classification;
- status;
- body byte count;
- body SHA-256;
- header-name list if applicable.

The exact body may exist only in process memory for candidate construction.

If the active edge-test route is no longer a simple safely-reconstructable static-response route:
RETURN_REVIEWER_F_R1R3_EDGE_TEST_ROUTE_NOT_SAFELY_RECONSTRUCTABLE

## Phase F — candidate Caddyfile in memory

Construct candidate from:

1. exact current durable Caddyfile content, unchanged;
2. recovered edge-test.spikersun.com Caddyfile-equivalent block;
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Candidate must exist only in process memory/stdin.

Do not write candidate to disk.
Do not write /srv/infra/edge/Caddyfile.

Record candidate bytes and SHA-256.

## Phase G — no-load adaptation

Preferred:
POST http://127.0.0.1:2019/adapt
Content-Type: text/caddyfile
with candidate bytes as request body.

Allowed fallback:
caddy adapt --adapter caddyfile --config -

Both are adaptation-only paths. Neither may load/reload the running config.

Require:
- adapt success;
- no material warning/error affecting route semantics.

Record:
CANDIDATE_CADDYFILE_ADAPT=PASS

Do not call:
- /load
- caddy reload
- caddy restart/stop

## Phase H — semantic parity

Parse adapted candidate JSON in memory.

Using generic host matcher discovery, require:

1. candidate contains localhost;
2. candidate contains edge-test.spikersun.com;
3. candidate contains minicraft.spikersun.com;
4. candidate edge-test static-response semantics equal the active edge-test semantics:
   - same status;
   - same body bytes/hash;
   - same required non-sensitive headers;
5. candidate Mini Craft route reverse-proxies exactly to wordpress:80.

Record:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

No need to prove complete active-config equality. Only the unrelated edge-test behavior and durable localhost baseline must be preserved.

## Phase I — exact future mutation plan

If all above PASS, freeze the next mutation sequence:

1. fresh read active config and edge-test fingerprint;
2. confirm durable Caddyfile SHA still matches F-R1R3;
3. create Shared Infra backup of /srv/infra/edge/Caddyfile;
4. atomically install the exact candidate identified by its SHA-256;
5. re-adapt the written file;
6. caddy reload only, never restart;
7. verify localhost and edge-test behavior unchanged;
8. verify Mini Craft Host-header route reaches wordpress:80;
9. read WordPress indexing state;
10. if indexable, apply bounded launch-safe noindex before DNS;
11. create DNS-only A record:
    minicraft.spikersun.com -> 2.24.193.133
12. verify DNS, TLS and public Sandbox routes;
13. never execute payment;
14. on public-canary failure, remove Mini Craft DNS first and revert only the Mini Craft Caddy addition while preserving edge-test.

F-R1R3 does not execute any mutation.

## Carry-forward canary policy

DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO

## Hard boundaries

No:
- Caddyfile write;
- Admin API /load;
- Caddy reload/restart/stop;
- autosave read/write requirement;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R3_ACTIVE_CADDY_ROUTE_RECOVERY_AND_CANDIDATE_ADAPT
SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=PASS
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_BYTES=
DURABLE_CADDYFILE_SHA256=
CURRENT_ACTIVE_CONFIG_BYTES=
CURRENT_ACTIVE_CONFIG_SHA256=
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_ROUTE_CLASS=STATIC_RESPONSE
EDGE_TEST_STATUS=
EDGE_TEST_BODY_BYTES=
EDGE_TEST_BODY_SHA256=
EDGE_TEST_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=PASS
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=PASS
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
