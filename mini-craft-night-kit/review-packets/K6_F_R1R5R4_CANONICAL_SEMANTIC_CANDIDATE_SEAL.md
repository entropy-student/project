# K6 Phase F-R1R5R4 — Canonical Semantic Candidate Seal

Gate:
K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R5R3_RETURN_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL.md
- latest accepted Evidence/Handoff
- unique Shared VPS Handoff

## Objective

Stop freezing pre-format candidate text hashes.

Build from fresh frozen semantics, canonicalize with caddy fmt, freeze the canonical candidate hash, adapt it warning-free, and prove localhost/edge-test/Mini Craft semantic parity.

## Accepted baseline

- strict direct-native SSH PASS
- ops@srv1970241
- durable Caddyfile SHA:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
- active config SHA:
  206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
- localhost present
- edge-test present
- Mini Craft absent
- edge-test status 200
- edge-test body 30 bytes
- edge-test body SHA:
  2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- previous 264-byte source hashes are diagnostic only, not acceptance criteria

## SSH

Exactly one strict direct-native SSH invocation.
No transport canary.
No SSH stdin.
One compact non-secret Base64 remote-command argument.

## A — frozen checks

Within the single SSH:
- identity ops@srv1970241
- durable SHA exact
- Admin GET PASS
- active config SHA exact
- localhost present
- edge-test present
- Mini Craft absent
- edge-test status/body hash exact

Mismatch -> RETURN_REVIEWER_F_R1R5R4_MATERIAL_DRIFT

Fresh DNS NXDOMAIN may be recorded locally.

## B — explicit configured edge-test headers

From the active edge-test static_response JSON itself, determine whether explicit headers are configured.

Record:
EDGE_TEST_ACTIVE_EXPLICIT_HEADERS_PRESENT
EDGE_TEST_ACTIVE_EXPLICIT_HEADER_NAMES

Do not infer configuration from observed HTTP response headers.

If active handler has no explicit headers, add none to the candidate.

If explicit non-sensitive headers exist, preserve exactly those configured semantics.

## C — source candidate

Construct in memory:
1. exact durable Caddyfile
2. edge-test static response from active status/body + only explicit configured headers
3. minicraft.spikersun.com reverse_proxy wordpress:80

Do not require 264 bytes.
Do not require either historical pre-format hash.

Record source bytes/hash for diagnostics only.

## D — caddy fmt first

Pipe source candidate to:

caddy fmt -

inside the Caddy container.

Accept native exit:
- 0
- 1

Caddy documents exit 1 when formatting differences exist and formatted output is printed.

Require non-empty formatted stdout and no fatal formatter error.

Formatted stdout becomes canonical candidate.

Record:
CADDY_FMT_NATIVE_EXIT
CANONICAL_CANDIDATE_BYTES
CANONICAL_CANDIDATE_SHA256

No --overwrite and no file write.

## E — canonical adapt

Pipe canonical candidate to:

caddy adapt --adapter caddyfile --config -

Require:
- native exit 0
- non-empty valid JSON stdout
- empty stderr

Any warning after canonical formatting:
RETURN_REVIEWER_F_R1R5R4_CANONICAL_ADAPT_WARNING

## F — localhost semantics

Adapt the exact frozen durable Caddyfile alone in memory.

Compare localhost user-route semantics with canonical candidate's localhost user-route semantics.

Require:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS

Ignore adapter-generated ordering/metadata that does not alter localhost behavior.

## G — edge-test semantics

Compare fresh active edge-test static_response with canonical adapted candidate.

Require:
- exact host
- static_response
- same status
- same body bytes/hash
- explicit configured active headers preserved exactly
- no observed-only header injected

Require:
EDGE_TEST_BEHAVIORAL_PARITY=PASS

## H — Mini Craft semantics

Canonical candidate must contain:
- exact host minicraft.spikersun.com
- reverse_proxy
- upstream exactly wordpress:80

Require:
CANDIDATE_MINICRAFT_ROUTE=PASS
MINICRAFT_EDGE_UPSTREAM=wordpress:80

No unrelated user hostname.

## I — final seal

If all PASS:
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

Freeze the fresh canonical candidate SHA as the only candidate authorized for the later write Gate.

Do not perform any write now.

## Forbidden

No second SSH, custom Process wrapper, SSH stdin, Caddyfile write, candidate persistent file, caddy fmt --overwrite, /load, reload/restart/stop, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret output, unrelated changes.

## Evidence markers

SSH_NETWORK_INVOCATIONS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=
CONTAINER_ADMIN_CONFIG_GET=
CURRENT_ACTIVE_CONFIG_SHA256=
CURRENT_ACTIVE_LOCALHOST_ROUTE=
CURRENT_ACTIVE_EDGE_TEST_ROUTE=
CURRENT_ACTIVE_MINICRAFT_ROUTE=
EDGE_TEST_CURRENT_STATUS=
EDGE_TEST_CURRENT_BODY_BYTES=
EDGE_TEST_CURRENT_BODY_SHA256=
EDGE_TEST_ACTIVE_EXPLICIT_HEADERS_PRESENT=
EDGE_TEST_ACTIVE_EXPLICIT_HEADER_NAMES=
SOURCE_CANDIDATE_BYTES=
SOURCE_CANDIDATE_SHA256=
CADDY_FMT_NATIVE_EXIT=
CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=
CANONICAL_ADAPT_NATIVE_EXIT=
CANONICAL_ADAPT_STDOUT_JSON=
CANONICAL_ADAPT_STDERR=
LOCALHOST_DURABLE_BASELINE_PRESERVED=
EDGE_TEST_BEHAVIORAL_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
PUBLIC_INGRESS_CHANGESET=
ROLLBACK_PLAN=
OWNER_CHECKPOINT_REQUIRED=YES
REMOTE_WRITES=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
LOCAL_TEMP_CLEANUP=
STOP_AT_REVIEWER=YES

Success:
PASS_CANDIDATE_K6_PHASE_F_R1R5R4_CANONICAL_SEMANTIC_CANDIDATE_SEAL

Otherwise precise RETURN_*.
