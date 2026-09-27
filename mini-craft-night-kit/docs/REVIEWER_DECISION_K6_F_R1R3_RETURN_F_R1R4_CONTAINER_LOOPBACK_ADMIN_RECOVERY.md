# Reviewer Decision — K6 F-R1R3 RETURN Accepted / F-R1R4 Container-Loopback Admin Recovery

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R3_ACTIVE_CADDY_ROUTE_RECOVERY_AND_CANDIDATE_ADAPT
RESULT=RETURN_REVIEWER_F_R1R3_ACTIVE_CONFIG_READ_FAILED
EVIDENCE_COMMIT=4fd89c171b6e415bd86039057a1c20666ae040de
HANDOFF_COMMIT=3800c3186cf6316b6d9a29ae89f153ed1bb4fcea

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

The active-config read used host loopback:

http://127.0.0.1:2019/config/

The shared Caddy runs inside Docker. Caddy's default Admin API bind is localhost:2019, so host loopback and container loopback are different network namespaces.

This failure is therefore classified as:

ADMIN_API_NETWORK_NAMESPACE_MISMATCH_UNTIL_PROVEN_OTHERWISE

It is not evidence that the Caddy Admin API is disabled or that active config is unavailable inside the Caddy container.

Accepted safety facts:
- strict SSH and ops@srv1970241 identity PASS;
- Caddy/WordPress/MariaDB continuity PASS;
- durable Caddyfile read PASS;
- durable Caddyfile bytes=76;
- durable Caddyfile SHA-256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb;
- fresh DNS NXDOMAIN;
- no Shared Infra/app/DNS/product/indexing/payment/Secret write;
- no persistent temporary artifacts.

## Current official tool facts

Current official Caddy documentation:
- Admin API default address is localhost:2019.
- GET /config/ reads the current active configuration.
- POST /adapt adapts config without loading it.

Current official caddy:2.11.4-alpine Dockerfile:
- installs curl;
- exposes 2019;
- contains Caddy v2.11.4.

Therefore F-R1R4 uses container-loopback HTTP from inside spikersun-edge-caddy-1. No package install or host Admin port exposure is needed.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R4_CONTAINER_LOOPBACK_CADDY_ADMIN_RECOVERY_AND_CANDIDATE_ADAPT
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

## Phase A — minimal continuity

Read-only confirm only:
- Caddy running/restart stable;
- WordPress running/restart stable;
- MariaDB healthy/restart stable;
- fresh public Mini Craft DNS remains NXDOMAIN;
- durable Caddyfile SHA still equals:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb.

Do not inspect Entrypoint/Cmd, autosave, host ports, indexing, DB/table/URL migration, or unrelated metadata.

## Phase B — prove container-loopback Admin API

Execute inside the existing Caddy container:

curl -fsS http://127.0.0.1:2019/config/

through docker exec.

Do not expose or publish raw config.

The response must be captured only inside the remote process for parsing.

Record:
- CONTAINER_ADMIN_CONFIG_GET=PASS
- active config bytes
- SHA-256

If container-loopback GET fails:
- retain bounded non-sensitive curl classification / native exit;
- do not retry alternate ports/addresses;
- return RETURN_REVIEWER_F_R1R4_CONTAINER_ADMIN_API_UNAVAILABLE.

Do not expose/admin-publish port 2019 on the host.

## Phase C — parse active routes generically

Parse active JSON with:
- existing jq, or
- Python stdlib json with recursive dict/list traversal and type checks.

No fixed server name, route index, or optional-field shape assumptions.

Generic exact host matcher discovery:
- localhost
- edge-test.spikersun.com
- minicraft.spikersun.com

Require:
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT

If Mini Craft is unexpectedly present:
RETURN_REVIEWER_F_R1R4_UNEXPECTED_MINICRAFT_ACTIVE_ROUTE

## Phase D — recover edge-test semantics

Recover current edge-test.spikersun.com behavior.

Prior accepted class is static_response, but fresh active config controls.

Allowlisted recovered semantics:
- host matcher;
- relevant handler chain;
- response status;
- response body retained only in process memory;
- body byte count;
- body SHA-256;
- required non-sensitive response header names/values only if necessary for exact parity.

Evidence must not contain exact response body.

If the route cannot be safely represented in Caddyfile:
RETURN_REVIEWER_F_R1R4_EDGE_TEST_NOT_RECONSTRUCTABLE

## Phase E — build candidate in memory

Read current durable /srv/infra/edge/Caddyfile content.

Candidate =
1. exact durable Caddyfile bytes unchanged;
2. reconstructed edge-test.spikersun.com block;
3. Mini Craft block:

minicraft.spikersun.com {
    reverse_proxy wordpress:80
}

Candidate must remain only in process memory/stdin.

No candidate temp file.
No durable Caddyfile write.

Record candidate bytes + SHA-256.

## Phase F — adapt through container loopback

Preferred path:

pipe candidate into the existing Caddy container and POST:

http://127.0.0.1:2019/adapt

with:
Content-Type: text/caddyfile

using the official-image curl already present inside the Caddy container.

This endpoint adapts only; do not call /load.

Allowed fallback:
pipe candidate to:

docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -

No persistent file.

Require:
CANDIDATE_CADDYFILE_ADAPT=PASS

Record adapted JSON bytes/hash in process memory only.

## Phase G — semantic parity

Parse adapted candidate JSON generically.

Require:
- localhost route present;
- edge-test route present;
- Mini Craft route present;
- edge-test candidate semantics match fresh active semantics:
  - status;
  - body bytes/hash;
  - required headers;
- Mini Craft route reverse_proxy upstream exactly wordpress:80.

Record:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_ACTIVE_TO_CANDIDATE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS

Do not require full active-config equality.

## Phase H — freeze exact future mutation plan

If all above PASS, freeze but do not execute:

1. fresh container-loopback active-config GET;
2. confirm edge-test fingerprint unchanged;
3. confirm durable Caddyfile SHA unchanged;
4. create Shared Infra backup of /srv/infra/edge/Caddyfile;
5. atomically write exact validated candidate;
6. adapt the written Caddyfile;
7. caddy reload only, never restart;
8. verify localhost and edge-test unchanged;
9. verify Mini Craft Host-header route to wordpress:80;
10. read current indexing state;
11. if indexable, apply bounded launch-safe noindex before DNS;
12. create DNS-only A:
    minicraft.spikersun.com -> 2.24.193.133;
13. validate DNS/TLS/public Sandbox routes;
14. no real order/payment;
15. on canary failure, remove Mini Craft DNS first, then revert only the Mini Craft Caddy addition while preserving edge-test.

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
- host exposure of port 2019;
- Caddyfile write;
- Admin API /load;
- Caddy reload/restart/stop;
- autosave work;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R4_CONTAINER_LOOPBACK_CADDY_ADMIN_RECOVERY_AND_CANDIDATE_ADAPT
SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=PASS
WORDPRESS_RUNTIME_CONTINUITY=PASS
MARIADB_HEALTH=PASS
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_BYTES=
CURRENT_ACTIVE_CONFIG_SHA256=
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_ROUTE_CLASS=
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
