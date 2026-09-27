# K6 Phase F-R1R5R3 — Adapt Warning Classification + Candidate Seal

Gate:
K6_PHASE_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION_AND_CANDIDATE_SEAL

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R5R2_RETURN_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION.md
- latest accepted Evidence/Handoff
- unique Shared VPS Handoff

## Objective

Do not rerun transport recovery or full runtime discovery.

Using one already-proven direct-native strict SSH session:
- reconstruct the exact 264-byte candidate;
- classify caddy adapt stderr correctly;
- format the candidate in memory;
- adapt the formatted candidate with zero warning;
- prove localhost/edge-test/Mini Craft semantics;
- seal the exact candidate hash and future rollback plan.

## Accepted baseline

- direct-native SSH transport PASS in prior Gate
- ops@srv1970241 PASS
- Caddy/WordPress/MariaDB continuity PASS
- Mini Craft DNS NXDOMAIN
- durable Caddyfile SHA:
  12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
- active Caddy config SHA:
  206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
- active Mini Craft route absent
- edge-test extracted as static_response
- edge-test fingerprint:
  200 / 30 bytes /
  2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- original candidate:
  264 bytes /
  ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93

## SSH

Exactly one network SSH invocation.

Use the accepted direct-native PowerShell/OpenSSH path:
- no custom Process wrapper
- no SSH stdin
- -n -T
- strict pinned host key
- one compact non-secret Base64 remote-command argument

Remote identity must begin by proving ops@srv1970241.

## A — frozen checks

Within the same SSH:
- durable SHA exact
- Admin GET PASS
- active config SHA exact
- active edge-test body hash exact
- Mini Craft active route absent

Fresh public DNS NXDOMAIN may be recorded from local DoH.

No WordPress/MariaDB lifecycle replay unless unexpected material drift appears.

## B — exact candidate reconstruction

Rebuild from:
- exact durable Caddyfile bytes
- active edge-test status/body
- Mini Craft reverse_proxy wordpress:80

Require exact:
ORIGINAL_CANDIDATE_BYTES=264
ORIGINAL_CANDIDATE_SHA256=ab67b8fca129b5f41f18740997794e05bb37037e58455d2e4524b64543f05e93

Mismatch -> RETURN_REVIEWER_F_R1R5R3_CANDIDATE_RECONSTRUCTION_DRIFT

No disk file.

## C — original adapt classification

Run:
caddy adapt --adapter caddyfile --config -

inside spikersun-edge-caddy-1 with candidate on remote-local stdin.

Capture in process memory:
- native adapt exit
- stdout
- stderr

Do not fail merely because stderr is non-empty.

Require:
- native exit 0
- stdout valid JSON

Allowed warning class:
FORMATTING_ONLY_NON_MATERIAL

The only allowed warning text is equivalent to:
Caddyfile input is not formatted; run 'caddy fmt --overwrite' to fix inconsistencies

Empty stderr:
ADAPT_WARNING_CLASS=NONE

Anything else:
RETURN_REVIEWER_F_R1R5R3_ADAPT_WARNING_UNCLASSIFIED_OR_MATERIAL

Do not persist raw stderr.

## D — canonical formatting

Run:
caddy fmt -

without --overwrite.

Input = original candidate.
Output = process-memory canonical candidate.

Accept formatter exit:
- 0 already formatted
- 1 formatting differences emitted

Any higher/fatal exit -> RETURN.

Require non-empty stdout.

Record:
CANONICAL_CANDIDATE_BYTES
CANONICAL_CANDIDATE_SHA256

No file write.

## E — canonical adapt

Run caddy adapt on formatted candidate.

Require:
- native exit 0
- stdout valid JSON
- stderr empty

Record:
CANONICAL_CANDIDATE_ADAPT=PASS
CANONICAL_ADAPT_STDERR=EMPTY

Any warning after formatting -> RETURN.

## F — semantic seal

Adapt the frozen 76-byte durable baseline alone in memory.

Compare its localhost behavior with the canonical candidate localhost behavior.

Require:
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS

Edge-test canonical candidate:
- exact host
- static_response
- same status
- body bytes=30
- exact accepted body SHA
- configured non-sensitive headers preserved if present

Require:
EDGE_TEST_BEHAVIORAL_PARITY=PASS

Mini Craft:
- exact host minicraft.spikersun.com
- reverse_proxy
- upstream wordpress:80

Require:
CANDIDATE_MINICRAFT_ROUTE=PASS

No unrelated hostname added.

## G — plan seal

If all PASS:
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES

Future write Gate remains:
fresh fingerprints -> Shared Infra Caddy backup -> atomic canonical candidate write -> adapt -> reload only -> route parity -> indexing/noindex check -> DNS-only A record -> public Sandbox validation -> rollback DNS first then prior Caddyfile on failure.

Do not execute here.

## Forbidden

No second SSH, custom wrapper, SSH stdin, Caddyfile write, candidate persistent file, /load, reload/restart/stop, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret output, unrelated changes.

## Evidence

SSH_NETWORK_INVOCATIONS=1
REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=
CONTAINER_ADMIN_CONFIG_GET=
CURRENT_ACTIVE_CONFIG_SHA256=
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=
CURRENT_ACTIVE_MINICRAFT_ROUTE=ABSENT
ORIGINAL_CANDIDATE_BYTES=264
ORIGINAL_CANDIDATE_SHA256=
ORIGINAL_ADAPT_NATIVE_EXIT=
ORIGINAL_ADAPT_STDOUT_JSON=
ADAPT_WARNING_CLASS=
CANONICAL_CANDIDATE_BYTES=
CANONICAL_CANDIDATE_SHA256=
CANONICAL_CANDIDATE_ADAPT=
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
PASS_CANDIDATE_K6_PHASE_F_R1R5R3_ADAPT_WARNING_CLASSIFICATION_AND_CANDIDATE_SEAL

Otherwise precise RETURN_*.
