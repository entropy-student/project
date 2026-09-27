# Reviewer Decision — K6 F-R1R5R2 RETURN Accepted / F-R1R5R3 Adapt Warning Classification + Candidate Seal

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R5R2_DIRECT_NATIVE_SSH_TRANSPORT_RECOVERY_AND_BEHAVIORAL_RESUME
RESULT=RETURN_REVIEWER_F_R1R5R2_CANDIDATE_ADAPT_WARNING
EVIDENCE_COMMIT=a30d53428d11f8a0fa9c014d581205a7a9cf59db
HANDOFF_COMMIT=e56d1b3abd669e220c8fa4a172034d0e3cb5b8d0

Reviewer accepts the RETURN as correct and fail-closed.

## Accepted progress

LOCAL_DIRECT_NATIVE_SSH_SEAL=PASS
SSH1_NATIVE_EXIT=0
SSH1_REMOTE_IDENTITY=ops
SSH2_REMOTE_IDENTITY=ops@srv1970241
CADDY_RUNTIME_CONTINUITY=PASS_RESTART_0
WORDPRESS_RUNTIME_CONTINUITY=PASS_RESTART_0
MARIADB_HEALTH=PASS_RESTART_0
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
CURRENT_ACTIVE_LOCALHOST_ROUTE=FOUND
CURRENT_ACTIVE_EDGE_TEST_ROUTE=FOUND
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
EDGE_TEST_RECOVERY_METHOD=PRIMARY_JSON_STATIC_RESPONSE
EDGE_TEST_CURRENT_HTTPS_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
EDGE_TEST_CURRENT_HTTP_BEHAVIOR=HTTP_TO_HTTPS_SAME_ORIGIN_REDIRECT
ORIGINAL_CANDIDATE_BYTES=264
ORIGINAL_CANDIDATE_SHA256=ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93
REMOTE_WRITES=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0

## Reviewer interpretation

Caddy's official CLI contract states that `caddy adapt` writes adapted JSON to stdout and warnings to stderr, then exits. Therefore non-empty stderr alone is not proof that adaptation failed.

The prior helper stopped solely because stderr was non-empty. It did not retain:
- the `caddy adapt` process exit code;
- a safe warning classification;
- adapted stdout semantic proof.

The candidate cannot yet PASS, but the entire transport/runtime/Caddy discovery chain does not need to be repeated.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION_AND_CANDIDATE_SEAL
OWNER_ACTION=NONE

This Gate is read-only/adapt-only.

## SSH budget

Exactly one strict SSH invocation is authorized.

The direct-native transport mechanism proven in F-R1R5R2 is the accepted transport baseline.

Do not run a separate transport canary.

Use:
- PowerShell direct native `& ssh.exe @args`;
- `-n -T`;
- canonical strict pinned options;
- one compact non-secret Base64 remote-command argument;
- native exit/stdout/stderr capture.

No custom Process wrapper.

## Phase A — bounded frozen-state recheck

Before candidate work, in the one SSH payload:

- identity = ops@srv1970241;
- durable Caddyfile SHA exact frozen value;
- container-loopback Admin GET succeeds;
- active config SHA exact frozen value;
- active edge-test static-response body fingerprint remains 30 bytes / accepted SHA;
- active Mini Craft route remains absent.

Do not repeat WordPress/MariaDB lifecycle checks unless a material inconsistency appears.

Fresh DNS NXDOMAIN may be checked locally before SSH and recorded.

Any frozen-hash mismatch -> RETURN_MATERIAL_DRIFT.

## Phase B — reconstruct the exact original candidate

Reconstruct from:
1. exact durable Caddyfile bytes;
2. fresh active edge-test static-response body/status;
3. Mini Craft block reverse_proxy wordpress:80.

Require:

ORIGINAL_CANDIDATE_BYTES=264
ORIGINAL_CANDIDATE_SHA256=ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93

Mismatch:
RETURN_REVIEWER_F_R1R5R3_CANDIDATE_RECONSTRUCTION_DRIFT

Candidate remains process-memory/stdin only.

## Phase C — classify original caddy adapt result correctly

Run inside the existing Caddy container:

caddy adapt --adapter caddyfile --config -

with original candidate on stdin.

Capture separately, in process memory:
- native caddy-adapt exit code;
- stdout bytes;
- stdout SHA-256;
- stderr bytes;
- normalized stderr warning lines.

Do not treat non-empty stderr by itself as failure.

Require:
- ADAPT_NATIVE_EXIT=0;
- stdout is valid JSON.

If native exit is nonzero or stdout is not valid JSON:
RETURN_REVIEWER_F_R1R5R3_ADAPT_ERROR

### Warning classification

Allowed non-material warning:
the exact Caddy formatting warning equivalent to:
`Caddyfile input is not formatted; run 'caddy fmt --overwrite' to fix inconsistencies`

If stderr is empty:
ADAPT_WARNING_CLASS=NONE

If stderr contains only the formatting warning:
ADAPT_WARNING_CLASS=FORMATTING_ONLY_NON_MATERIAL

Any other warning/error text:
RETURN_REVIEWER_F_R1R5R3_ADAPT_WARNING_UNCLASSIFIED_OR_MATERIAL

Evidence must store classification, not full raw stderr.

## Phase D — produce a formatted canonical candidate

If Phase C succeeds, run:

caddy fmt -

on the original candidate, without `--overwrite`.

This is read-only and may exit 1 when it reports formatting differences.

Accept fmt exit:
- 0 = already formatted;
- 1 = formatted output differs.

Require non-empty formatted stdout and no fatal formatter error.

Set the formatted stdout bytes as the canonical candidate.

Record:
CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=

Do not write it to disk.

## Phase E — adapt the canonical formatted candidate

Run:

caddy adapt --adapter caddyfile --config -

against the formatted candidate.

Require:
- canonical adapt native exit 0;
- stdout valid JSON;
- stderr empty.

If stderr still contains the exact formatting-only warning despite formatter output, RETURN for implementation inconsistency.
Any other warning also RETURN.

Record:
CANONICAL_CANDIDATE_ADAPT=PASS

## Phase F — semantic seal

Parse canonical adapted JSON in memory.

Also adapt the 76-byte durable baseline alone in memory so localhost semantics can be compared directly.

Require:

LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS

For edge-test:
- exact host matcher present;
- static_response handler present;
- status matches active;
- body bytes=30;
- body SHA-256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824;
- any explicitly configured non-sensitive headers preserved.

EDGE_TEST_BEHAVIORAL_PARITY=PASS

For Mini Craft:
- exact host matcher minicraft.spikersun.com;
- reverse_proxy handler;
- upstream exactly wordpress:80.

CANDIDATE_MINICRAFT_ROUTE=PASS

No unrelated hostname may be introduced.

## Phase G — final plan seal

If semantic seal PASS:

PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

The future mutation plan remains:
1. fresh active/durable fingerprint check;
2. backup current Shared Infra Caddyfile;
3. atomically write exact canonical candidate by SHA;
4. adapt written file;
5. zero-downtime caddy reload, never restart;
6. prove localhost + edge-test unchanged;
7. prove Mini Craft private Host-header route;
8. check indexing and apply bounded noindex if required before DNS;
9. create DNS-only A minicraft.spikersun.com -> 2.24.193.133;
10. verify DNS/TLS/public Sandbox routes;
11. no real payment;
12. rollback DNS first and restore prior Caddyfile on failure.

This Gate does not execute the plan.

## Hard boundaries

No:
- second SSH;
- custom Process wrapper;
- SSH stdin;
- Caddyfile write;
- candidate persistent file;
- Caddy /load;
- reload/restart/stop;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret output;
- unrelated mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION_AND_CANDIDATE_SEAL
SSH_NETWORK_INVOCATIONS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
ORIGINAL_CANDIDATE_BYTES=264
ORIGINAL_CANDIDATE_SHA256=ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93
ORIGINAL_ADAPT_NATIVE_EXIT=0
ORIGINAL_ADAPT_STDOUT_JSON=PASS
ADAPT_WARNING_CLASS=
CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=
CANONICAL_CANDIDATE_ADAPT=PASS
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
