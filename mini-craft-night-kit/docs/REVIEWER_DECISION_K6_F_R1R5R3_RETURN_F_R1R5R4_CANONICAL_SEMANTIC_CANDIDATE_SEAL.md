# Reviewer Decision — K6 F-R1R5R3 RETURN Accepted / F-R1R5R4 Canonical Semantic Candidate Seal

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION_AND_CANDIDATE_SEAL
RESULT=RETURN_REVIEWER_F_R1R5R3_CANDIDATE_RECONSTRUCTION_DRIFT
EVIDENCE_COMMIT=1d99cb663f6202e3567d2fbc777703bcc3c42668
HANDOFF_COMMIT=0da0ff21823d6cade2b34d9ab623fc2be92e85a8

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted facts

SSH strict pinned transport=PASS
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_BYTES=610
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_CURRENT_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
REMOTE_WRITES=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0

Two pre-format candidate reconstructions were observed:
- 264 bytes / SHA-256 ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93
- 264 bytes / SHA-256 b3531c1d7efb1b7e6e8e5cc83b39c5e58b61c66bcf386343dfa028d80dab2047

Because all frozen semantic inputs remained unchanged, these pre-format hashes are diagnostic only and are no longer authoritative acceptance criteria.

## Reviewer interpretation

The previous Gate incorrectly froze an intermediate text serialization instead of the canonicalized configuration.

The future Shared Infra write must be pinned to:
1. fresh active route semantics;
2. the exact durable localhost baseline semantics;
3. an in-memory candidate normalized by caddy fmt;
4. a canonical candidate SHA-256;
5. warning-free successful caddy adapt output;
6. semantic parity for localhost, edge-test and Mini Craft.

Observed HTTP response headers are not proof of explicit Caddy configuration. Candidate reconstruction may preserve only headers explicitly present in the active static_response handler. Transport-generated or inferred headers must not be added.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL
OWNER_ACTION=NONE

Read-only/adapt-only.

## SSH budget

Exactly one strict direct-native SSH invocation.
No transport canary.
Use the already-proven direct-native PowerShell/OpenSSH path:
- -n -T
- strict pinned known_hosts
- exact identity
- one compact non-secret Base64 remote-command argument
- native exit/stdout/stderr capture
- no custom Process wrapper
- no SSH stdin

## Phase A — frozen state

Within the one SSH session prove:
- ops@srv1970241;
- durable Caddyfile SHA exact frozen value;
- container-loopback Admin GET PASS;
- active config SHA exact frozen value;
- localhost route present;
- edge-test route present;
- Mini Craft route absent;
- edge-test status/body fingerprint unchanged.

Any mismatch -> RETURN_REVIEWER_F_R1R5R4_MATERIAL_DRIFT.

Fresh DNS NXDOMAIN may be recorded locally.

## Phase B — explicit active edge-test semantics

From the fresh active JSON locate the unique edge-test static_response handler.

Extract only:
- status;
- exact body in process memory;
- body bytes/hash;
- headers explicitly present in that handler's JSON, if any.

Record:
EDGE_TEST_ACTIVE_EXPLICIT_HEADERS_PRESENT=YES|NO
EDGE_TEST_ACTIVE_EXPLICIT_HEADER_NAMES=

Do not use observed HTTP response headers as configuration source.
Do not add content-type merely because it appeared in the HTTP response.

If active JSON contains explicit headers:
- preserve only those exact non-sensitive configured headers.
If none:
- candidate must not add a header directive for edge-test.

Any sensitive/unrepresentable explicit header -> RETURN.

## Phase C — semantic source candidate

Construct an in-memory source candidate from:
1. exact durable Caddyfile bytes;
2. edge-test.spikersun.com with the active static-response status/body and only explicitly configured active headers;
3. minicraft.spikersun.com reverse_proxy wordpress:80.

Do not require any prior pre-format candidate byte count or SHA.
Record source candidate bytes/hash for diagnostics only:

SOURCE_CANDIDATE_BYTES=
SOURCE_CANDIDATE_SHA256=

No disk file.

## Phase D — canonicalize first

Pipe the source candidate into:

caddy fmt -

inside the existing Caddy container.

Per Caddy CLI contract:
- exit 0 = already formatted;
- exit 1 = formatting differences exist and formatted output is printed;
- either 0 or 1 is acceptable here.

Require:
- formatter exit is 0 or 1;
- formatted stdout is non-empty;
- no fatal formatter error.

The formatted stdout becomes the only authoritative candidate:

CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=

This hash is the candidate hash to freeze for the future mutation Gate.

No --overwrite.
No file write.

## Phase E — canonical adapt

Pipe the canonical candidate into:

caddy adapt --adapter caddyfile --config -

Capture native exit/stdout/stderr separately.

Require:
- adapt native exit 0;
- stdout non-empty valid JSON;
- stderr empty.

If stderr contains any warning after caddy fmt canonicalization:
RETURN_REVIEWER_F_R1R5R4_CANONICAL_ADAPT_WARNING

Do not ignore warnings.
Do not persist raw stderr.

Record:
CANONICAL_ADAPT_NATIVE_EXIT=0
CANONICAL_ADAPT_STDOUT_JSON=PASS
CANONICAL_ADAPT_STDERR=EMPTY

## Phase F — localhost semantic parity

Adapt the exact frozen durable 76-byte Caddyfile alone in memory.

Parse both:
- durable baseline adapted JSON;
- canonical candidate adapted JSON.

Compare only the localhost user-route semantics, ignoring unrelated automatically synthesized adapter metadata/order where it does not change the localhost route.

Require:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS

## Phase G — edge-test semantic parity

Compare fresh active edge-test static_response semantics with the canonical candidate adapted edge-test route.

Require:
- exact host matcher;
- static_response handler;
- status equal;
- body bytes=30;
- body SHA-256 equal accepted active hash;
- explicitly configured active headers preserved exactly;
- no inferred/observed-only header added.

Record:
EDGE_TEST_BEHAVIORAL_PARITY=PASS

## Phase H — Mini Craft route

Canonical adapted JSON must contain:
- exact host matcher minicraft.spikersun.com;
- reverse_proxy handler;
- upstream/dial exactly wordpress:80.

Require:
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80

No unrelated user hostname may be introduced.

## Phase I — final candidate/change-plan seal

If all phases PASS:

PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

Freeze:
CANONICAL_CANDIDATE_SHA256=<fresh exact value>

Future mutation Gate must use exactly this canonical candidate.

Future sequence remains:
1. fresh active edge-test/durable fingerprints;
2. backup Shared Infra Caddyfile;
3. atomic write exact canonical candidate;
4. adapt written file;
5. zero-downtime caddy reload only;
6. verify localhost + edge-test unchanged;
7. verify Mini Craft private Host-header route;
8. check indexing and set bounded noindex if needed before DNS;
9. DNS-only A minicraft.spikersun.com -> 2.24.193.133;
10. verify DNS/TLS/public Sandbox routes;
11. no real payment;
12. rollback DNS first, then prior Caddyfile on failure.

This Gate performs none of those writes.

## Hard boundaries

No:
- second SSH;
- custom Process wrapper;
- SSH stdin;
- Caddyfile write;
- candidate persistent file;
- caddy fmt --overwrite;
- Admin /load;
- caddy reload/restart/stop;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret output;
- unrelated mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL
SSH_NETWORK_INVOCATIONS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_CURRENT_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
EDGE_TEST_ACTIVE_EXPLICIT_HEADERS_PRESENT=
EDGE_TEST_ACTIVE_EXPLICIT_HEADER_NAMES=
SOURCE_CANDIDATE_BYTES=
SOURCE_CANDIDATE_SHA256=
CADDY_FMT_NATIVE_EXIT=0_OR_1
CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=
CANONICAL_ADAPT_NATIVE_EXIT=0
CANONICAL_ADAPT_STDOUT_JSON=PASS
CANONICAL_ADAPT_STDERR=EMPTY
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES
REMOTE_WRITES=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
LOCAL_TEMP_CLEANUP=PASS
STOP_AT_REVIEWER=YES

A PASS_CANDIDATE authorizes no Shared Infra or DNS mutation.
