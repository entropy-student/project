# Reviewer Decision — K6 F-R1 RETURN Accepted / F-R1R1 Native Read-only Reconciliation

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1_SHARED_INGRESS_CONFIG_SOURCE_RECONCILIATION
RESULT=RETURN_REVIEWER_F_R1_READONLY_EXECUTION_HELPER_ERROR
EVIDENCE_COMMIT=1dab507c4051ed77cdc3c9aeae32feb1abae4d5d
HANDOFF_COMMIT=afd4d31d8aec6a3231da2b939d606441b248bfe3

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

The failure is:

LOCAL_OR_REMOTE_READONLY_HELPER_IMPLEMENTATION_ERROR

It is not evidence of:
- new Caddy config drift;
- WordPress/MariaDB drift;
- DNS drift;
- public-ingress mutation.

Accepted safety facts:

SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
SECRET_VALUE_OR_HASH_ACCESS=0
UNRELATED_SERVICES_CHANGED=NO
LOCAL_TEMP_CLEANUP=PASS_NO_PERSISTENT_TEMP_CREATED

The prior accepted Phase F facts remain the current baseline unless fresh F-R1R1 read-back proves material drift.

## Design correction

F-R1R1 must not reuse the failed object/attribute-style Caddy metadata helper.

Use direct native commands and standard data shapes:

- docker inspect --format for Entrypoint/Cmd/mount/network metadata;
- allowlisted environment extraction only for HOME and XDG_CONFIG_HOME;
- Caddy Admin API GET for active config;
- jq if already present;
- otherwise Python standard-library JSON parsing using dictionary/list access only.

No package installation is authorized.

No parser may assume JSON objects expose Python attributes.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R1_NATIVE_READONLY_CADDY_SOURCE_RECONCILIATION
OWNER_ACTION=NONE

This Gate remains read-only only.

## SSH boundary

Exactly one fresh canonical strict SSH invocation/session is authorized for the remote Gate payload.

At payload start, before sudo:
- whoami=ops
- id -un=ops
- UID nonzero
- hostname=srv1970241

Do not reconnect because one individual read-only subcommand fails. Return instead.

## Phase A — minimal continuity

Read-only confirm:
- Caddy running/restart stable;
- WordPress running/restart stable;
- MariaDB healthy/restart stable;
- no WordPress/DB host ports;
- edge -> wordpress:80 HTTP 200;
- no Mini Craft public Caddy route;
- public Mini Craft DNS freshly remains absent/NXDOMAIN.

Do not rerun restore/migration work.

## Phase B — native Caddy startup/persistence metadata

Without a custom object helper, obtain:

1. exact container Entrypoint via docker inspect --format;
2. exact container Cmd via docker inspect --format;
3. exact read-only Caddyfile mount source/destination;
4. only HOME and XDG_CONFIG_HOME from container environment;
5. determine whether startup uses --resume;
6. determine whether persist_config off is present in current active/global config;
7. derive the configuration directory from the observed environment according to Caddy conventions;
8. locate autosave.json;
9. record autosave metadata:
   - exists;
   - bytes;
   - mtime;
   - SHA-256;
10. hash current active Admin API config bytes without outputting the raw config.

If a required parser/tool is unavailable and cannot be satisfied by existing jq or Python standard library:
RETURN_REVIEWER_F_R1R1_READONLY_PARSER_UNAVAILABLE

No package install.

## Phase C — safe semantic extraction

Read active Admin API config and autosave JSON only inside the remote process.

Before emitting anything, filter to the allowlist needed for:
- HTTP host matchers;
- route/handler types;
- reverse-proxy upstreams;
- static-response status/header/body fingerprint;
- relevant global persistence setting.

Do not emit:
- full raw config;
- TLS private material;
- credentials/tokens;
- unrelated header secrets;
- certificate material.

If jq exists, prefer jq.

If Python is required:
- use json.load/json.loads;
- use dict.get(), indexing and type checks only;
- no getattr/object.attribute assumptions;
- explicitly tolerate missing optional fields.

Prove:

AUTOSAVE_MATCHES_ACTIVE_HTTP_ROUTES=YES|NO

Recover:
- localhost behavior;
- edge-test.spikersun.com behavior.

For edge-test, Evidence may contain only:
- host;
- handler type;
- status;
- non-sensitive header names if relevant;
- body bytes;
- body SHA-256.

Exact body may exist only in process memory for candidate construction.

If current active edge-test behavior cannot be reconstructed:
RETURN_REVIEWER_F_R1R1_CADDY_ACTIVE_CONFIG_NOT_RECOVERABLE

## Phase D — candidate Caddyfile in process memory only

Use the current durable Caddyfile's localhost block as the baseline instead of trying to reverse-convert all active JSON.

Construct in memory:

1. current durable localhost Caddyfile semantics unchanged;
2. reconstructed edge-test.spikersun.com static-response semantics;
3. add:
   minicraft.spikersun.com {
       reverse_proxy wordpress:80
   }

Do not write /srv/infra/edge/Caddyfile.
Do not write a persistent candidate file.
Do not call /load.
Do not reload.

Pipe candidate through:
caddy adapt --adapter caddyfile --config -

Caddy documentation supports config input from stdin.

Require:
- native exit 0;
- no adaptation error;
- no material adaptation warning affecting route semantics.

Compare adapted candidate route semantics in memory against active config:
- localhost parity PASS;
- edge-test parity PASS;
- Mini Craft route exactly wordpress:80.

Record candidate byte count + SHA-256 only.

## Phase E — autosave/startup-source conclusion

Classify one of:

A.
CADDY_SOURCE_RECONCILIATION=ACTIVE_AUTOSAVE_RECOVERABLE_CADDYFILE_CANDIDATE_VALIDATED

or

B.
RETURN_REVIEWER_F_R1R1_CADDY_PERSISTENCE_MODEL_UNRESOLVED

The success classification must prove enough to persist the current unrelated edge-test behavior in the later durable Caddyfile mutation Gate.

## Phase F — indexing / canary safety

Fresh read-only determine:
- WordPress blog_public/search-engine visibility;
- current noindex behavior.

Return:
CANARY_INDEXING_STATE=LAUNCH_SAFE_NOINDEX

or:
CANARY_INDEXING_STATE=INDEXABLE_REQUIRES_PRE_INGRESS_NOINDEX_WRITE

Product 223 remains:
PRODUCT_223_CLASSIFICATION=SANDBOX_CANARY_ONLY_BLOCKS_SOFT_LAUNCH

No product/indexing write.

## Frozen canary DNS policy

DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133

No DNS write in this Gate.

## Future exact mutation plan

Only if reconciliation succeeds, freeze the later mutation plan:

1. fresh active-route fingerprint;
2. backup current durable /srv/infra/edge/Caddyfile;
3. atomic durable candidate write;
4. adapt/validate;
5. zero-downtime caddy reload, not restart;
6. verify localhost + edge-test unchanged;
7. verify Mini Craft Host-header route;
8. if indexing is not launch-safe, apply bounded noindex before public DNS;
9. create DNS-only A minicraft.spikersun.com -> 2.24.193.133;
10. verify DNS/TLS/public Sandbox routes;
11. rollback DNS first, then only Mini Craft Caddy addition, preserving edge-test.

F-R1R1 does not execute any step above.

## Hard boundaries

No:
- Caddyfile write;
- Caddy load/reload/restart;
- autosave modification;
- DNS/cloudflared/UFW/network/Compose mutation;
- package installation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated project mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R1_NATIVE_READONLY_CADDY_SOURCE_RECONCILIATION
SSH_ATTEMPTS=1
REMOTE_IDENTITY=ops@srv1970241
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
MINICRAFT_EDGE_UPSTREAM=wordpress:80
EDGE_TO_MINICRAFT_PRIVATE_REACHABILITY=PASS
CANDIDATE_CADDYFILE_ADAPT=PASS
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_EXISTING_ROUTE_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
CADDY_SOURCE_RECONCILIATION=ACTIVE_AUTOSAVE_RECOVERABLE_CADDYFILE_CANDIDATE_VALIDATED
CURRENT_MINICRAFT_DNS=NXDOMAIN
DNS_CANARY_POLICY=A_DNS_ONLY_TO_2.24.193.133
CANARY_INDEXING_STATE=
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
