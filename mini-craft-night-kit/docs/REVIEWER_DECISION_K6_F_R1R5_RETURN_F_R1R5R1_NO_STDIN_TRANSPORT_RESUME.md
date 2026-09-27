# Reviewer Decision — K6 F-R1R5 RETURN Accepted / F-R1R5R1 No-stdin Transport Seal + Behavioral Resume

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT
RESULT=RETURN_REVIEWER_F_R1R5_SSH_WRAPPER_INPUT_PIPE_CLOSED
EVIDENCE_COMMIT=6a8863672d5b75ca4dafb96f8b0fa917cc4dc77e
HANDOFF_COMMIT=1f8e2a498e422be6fb6e100cc62e2807bb71f724

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

LOCAL_SSH_WRAPPER_STDIN_TRANSPORT_FAILURE

Fresh remote execution is unverified. This is not evidence of target-host, Caddy, WordPress, MariaDB, DNS or route drift.

The submitted remote payload contained no write command. Therefore no consequential-write ambiguity exists and no remote rollback/reconciliation is required before a new bounded read-only Gate.

Accepted local safety facts:
- identity-file path exists and public fingerprint matches the Shared VPS Handoff;
- all three recorded host-key pins are present in known_hosts;
- local public DNS remains NXDOMAIN;
- no retry occurred;
- temporary local wrapper was deleted and absence verified;
- no Shared Infra/public-ingress/payment/Secret write is evidenced.

## Reviewer transport correction

F-R1R5R1 must not redirect, open, write, or depend on ssh.exe StandardInput.

Every network SSH invocation must use:
- -n
- -T
- BatchMode=yes
- IdentitiesOnly=yes
- StrictHostKeyChecking=yes
- explicit UserKnownHostsFile
- exact identity file
- bounded connect timeout/keepalive

Remote logic is supplied as the final SSH remote-command argument, not through stdin.

For the full read-only payload, a compact non-secret shell script may be UTF-8 encoded and Base64 encoded locally, then sent as a safe command argument and decoded remotely with coreutils base64 into bash through a remote-local pipeline. The encoded payload must contain no Secret and should remain compact enough for the local Windows command-line boundary.

## SSH budget

Maximum network SSH invocations in this Gate: 2.

SSH #1 is a tiny read-only transport canary.
SSH #2 is authorized only if SSH #1 fully passes.

No third invocation.

This is not blind retry. The two invocations serve different explicit purposes.

## Phase 0 — local execution seal

Before network access:

1. confirm exact ssh.exe path;
2. run ssh.exe -V using the same native invocation/capture mechanism;
3. prove native success exit is captured;
4. prove stdout/stderr capture mechanism is usable;
5. prove RedirectStandardInput is false / stdin is not opened;
6. no network target supplied.

Failure:
RETURN_REVIEWER_F_R1R5R1_LOCAL_NO_STDIN_TRANSPORT_UNSEALED

No SSH network invocation.

## Phase 1 — SSH #1 transport canary

Use strict SSH with -n -T and the canonical target.

Remote command argument only, equivalent to:

set -eu
printf 'REMOTE_ARG_TRANSPORT_OK\n'
whoami
id -un
id -u
hostname

No sudo. No Docker. No app/Caddy read.

Require:
- native exit 0;
- stdout retained;
- bounded stderr retained/classified;
- REMOTE_ARG_TRANSPORT_OK present;
- whoami=ops;
- id -un=ops;
- UID nonzero;
- hostname=srv1970241.

Strict success with the pinned known_hosts file establishes host-key acceptance for this invocation.

If any requirement fails:
RETURN_REVIEWER_F_R1R5R1_REMOTE_COMMAND_TRANSPORT_CANARY_FAILED

Do not execute SSH #2.

## Phase 2 — SSH #2 resume F-R1R5

Only after Phase 1 PASS.

Reuse the semantic scope from:
- docs/REVIEWER_DECISION_K6_F_R1R4_RETURN_F_R1R5_BEHAVIORAL_ROUTE_PRESERVATION.md
- review-packets/K6_F_R1R5_BEHAVIORAL_EDGE_TEST_PRESERVATION_AND_CANDIDATE_ADAPT.md

Transport override:
- no SSH stdin;
- use -n -T;
- full remote script is sent only as the final remote-command argument;
- no custom StandardInput pipe;
- compact Base64 launcher is allowed;
- no Secret in command line/payload.

The remote script must begin with the same pre-sudo identity checks.

Then perform only the already-authorized F-R1R5 read-only logic:
1. frozen durable Caddyfile hash check;
2. container-loopback Caddy Admin GET and active-config hash check;
3. edge-test primary static-response extraction, with behavioral local HTTP/HTTPS fallback;
4. require accepted edge-test behavior fingerprint where fallback is used:
   - HTTPS status 200
   - body bytes 30
   - SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
5. exact body remains only in remote process memory;
6. construct candidate in remote memory;
7. adapt candidate only;
8. prove localhost durable baseline preserved;
9. prove edge-test behavioral parity;
10. prove Mini Craft reverse_proxy upstream wordpress:80;
11. freeze the already-defined future mutation/rollback plan.

The remote script itself may pipe candidate bytes to:
docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -

That stdin is a remote-shell-local pipeline and is permitted. It is not SSH stdin.

## Remote command delivery

Preferred:
- compact UTF-8 shell script;
- local Base64 encoding;
- final remote command argument:
  printf '%s' '<BASE64>' | base64 -d | bash

The Base64 string contains only non-secret read-only logic.

Do not create a remote script file.
Do not SCP/SFTP.
Do not use a second connection for payload transfer.

If the encoded launcher cannot be safely formed within the local command-line limit:
RETURN_REVIEWER_F_R1R5R1_REMOTE_COMMAND_ARGUMENT_TOO_LARGE

Do not fall back to stdin.

## Capture rules

For both SSH invocations:
- stdin disabled;
- native exit captured;
- stdout captured;
- stderr captured separately or safely classified;
- bounded output only;
- no raw active Caddy JSON;
- no exact edge-test body;
- no Secret.

A local temporary stdout/stderr capture file is permitted if needed for reliable native capture, provided:
- it contains only bounded non-secret output;
- it is project-local or OS-temp;
- it is deleted before Gate end;
- absence is verified.

## Hard boundaries

No:
- SSH stdin payload;
- StandardInput write;
- more than two network SSH invocations;
- remote temp script;
- SCP/SFTP;
- Caddyfile write;
- candidate persistent file;
- Admin /load;
- Caddy reload/restart/stop;
- DNS/cloudflared/UFW/network/Compose mutation;
- product/indexing mutation;
- public ingress;
- Provider action;
- PayPal Live/payment/refund;
- Secret value/hash output;
- unrelated mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R5R1_NO_STDIN_TRANSPORT_AND_BEHAVIORAL_RESUME
LOCAL_NO_STDIN_TRANSPORT_SEAL=PASS
SSH_NETWORK_INVOCATIONS=2
SSH1_NATIVE_EXIT=0
SSH1_HOST_KEY_MATCH=YES_BY_STRICT_PINNED_SUCCESS
SSH1_REMOTE_ARG_TRANSPORT=PASS
SSH1_REMOTE_IDENTITY=ops@srv1970241
SSH2_NATIVE_EXIT=0
SSH2_HOST_KEY_MATCH=YES_BY_STRICT_PINNED_SUCCESS
SSH2_REMOTE_IDENTITY=ops@srv1970241
CURRENT_MINICRAFT_DNS=NXDOMAIN
DURABLE_CADDYFILE_SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb
CONTAINER_ADMIN_CONFIG_GET=PASS
CURRENT_ACTIVE_CONFIG_SHA256=206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd
EDGE_TEST_RECOVERY_METHOD=
EDGE_TEST_CURRENT_HTTPS_STATUS=200
EDGE_TEST_CURRENT_BODY_BYTES=30
EDGE_TEST_CURRENT_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
EDGE_TEST_CURRENT_HTTP_BEHAVIOR=
EDGE_TEST_CONFIGURED_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=PASS
LOCALHOST_DURABLE_BASELINE_PRESERVED=PASS
EDGE_TEST_BEHAVIORAL_PARITY=PASS
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
LOCAL_TEMP_CLEANUP=PASS
STOP_AT_REVIEWER=YES

A PASS_CANDIDATE authorizes no Shared Infra or DNS mutation.
