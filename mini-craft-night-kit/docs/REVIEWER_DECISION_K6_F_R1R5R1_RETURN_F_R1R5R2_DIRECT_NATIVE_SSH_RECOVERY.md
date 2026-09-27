# Reviewer Decision — K6 F-R1R5R1 RETURN Accepted / F-R1R5R2 Direct Native SSH Recovery + Behavioral Resume

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper
Governance: canonical entropy-student/spike.skill/vps-project-governance latest

## Reviewed result

GATE=K6_PHASE_F_R1R5R1_NO_STDIN_TRANSPORT_AND_BEHAVIORAL_RESUME
RESULT=RETURN_REVIEWER_F_R1R5R1_REMOTE_COMMAND_TRANSPORT_CANARY_FAILED
EVIDENCE_COMMIT=a807eb754a92917ed7efc2196fa1d3e423983215
HANDOFF_COMMIT=85fce567b876136799147c1e3c85b7d940670c32

Reviewer accepts the RETURN as correct and fail-closed.

## Classification

The local no-stdin seal passed, but the first network canary exited 255 with nonempty stderr and no remote stdout marker/identity.
The stderr was captured locally but only persisted as a redacted NONEMPTY classification, so the precise transport cause is not recoverable from Evidence.

SSH_FAILURE_CLASS=UNRESOLVED_TRANSPORT_OR_ARGV_FAILURE
TARGET_HOST_DRIFT=NOT_PROVEN
CADDY_DRIFT=NOT_PROVEN
REMOTE_WRITE_AMBIGUITY=NO

SSH #2 did not run and no write-capable command was sent.

## Governance alignment

Canonical SSH_AND_DELEGATED_SECRET_OPERATIONS rev2 states that Windows PowerShell/OpenSSH argument and quoting semantics are a known transport boundary, native exit must be checked, and bounded encoded remote payloads are preferred over fragile multiline transport.

## Current Gate

CURRENT_GATE=K6_PHASE_F_R1R5R2_DIRECT_NATIVE_SSH_TRANSPORT_RECOVERY_AND_BEHAVIORAL_RESUME
OWNER_ACTION=NONE

Read-only only.

## Design correction

Do not use System.Diagnostics.Process, ProcessStartInfo, RedirectStandardInput, custom stdin/stdout pumps, or PowerShell-native multiline transport.
Use PowerShell direct native invocation only:

& $sshExe @sshArgs

Capture stdout/stderr to bounded local temp files and native exit from $LASTEXITCODE.
No stdin redirection.

## SSH budget

Maximum network SSH invocations: 2.
SSH #1: simplest direct-native transport canary.
SSH #2: full read-only F-R1R5 behavioral resume only after SSH #1 PASS.
No third invocation.

## Phase 0 — local direct-native seal

Before network:
1. resolve exact ssh.exe path;
2. execute ssh.exe -V through direct call operator &;
3. capture $LASTEXITCODE;
4. prove stdout/stderr local temp capture works;
5. prove no stdin redirection;
6. prove local temp cleanup.

Require LOCAL_DIRECT_NATIVE_SSH_SEAL=PASS.
Failure: RETURN_REVIEWER_F_R1R5R2_LOCAL_DIRECT_NATIVE_SEAL_FAILED and no network SSH.

## Phase 1 — SSH #1 simplest canary

Canonical strict option array:
- -n
- -T
- -p 22
- -i exact identity path
- -o BatchMode=yes
- -o IdentitiesOnly=yes
- -o StrictHostKeyChecking=yes
- -o UserKnownHostsFile=<exact known_hosts>
- -o ConnectTimeout=10
- -o ServerAliveInterval=5
- -o ServerAliveCountMax=1
- ops@2.24.193.133
- whoami

The final remote command is exactly the single token whoami.
No semicolon, no quotes, no shell script, no printf, no environment assignment.

Invoke directly with & $sshExe @sshArgs and capture stdout/stderr plus $LASTEXITCODE.

PASS requires exit 0 and normalized stdout exactly ops.
On strict pinned success record SSH1_HOST_KEY_MATCH=YES_BY_STRICT_PINNED_SUCCESS.

If exit is nonzero, classify locally retained stderr before deletion into one of:
- HOST_KEY_MISMATCH
- AUTH_PUBLICKEY_DENIED
- CONNECTION_TIMEOUT
- CONNECTION_REFUSED
- NO_ROUTE_OR_NETWORK
- KNOWN_HOSTS_OR_IDENTITY_FILE_ERROR
- REMOTE_COMMAND_REJECTED
- OTHER_NONEMPTY_STDERR

Evidence may retain only classification, native exit, and at most one bounded non-sensitive error signature.
Delete capture files, return RETURN_REVIEWER_F_R1R5R2_DIRECT_NATIVE_CANARY_FAILED, and do not run SSH #2.

## Phase 2 — prepare one encoded payload

Only after SSH #1 PASS.
Construct the already-reviewed F-R1R5 read-only shell logic as compact UTF-8 LF text with no Secret.
Base64 encode locally.

Validate:
- encoded payload contains only Base64 characters and no CR/LF;
- local decode is byte-identical to the original script;
- the launcher is one PowerShell string argument;
- total native command line stays below a conservative 24000 UTF-16 character ceiling.

Remote launcher string:

echo <BASE64>|base64 -d|bash

No inner quotes are required around the Base64 token.
Set REMOTE_LAUNCHER_ARG_COUNT=1.

If too large: RETURN_REVIEWER_F_R1R5R2_REMOTE_COMMAND_ARGUMENT_TOO_LARGE and do not run SSH #2.

## Phase 3 — SSH #2 behavioral resume

Invoke direct-native & $sshExe @sshArgs2 with the same strict options, -n, -T, exact target, and exactly one final launcher argument.
No stdin and no custom wrapper.

Remote script begins with whoami, id -un, id -u and hostname and must prove ops / ops / nonzero UID / srv1970241.

Then resume only the accepted F-R1R5 read-only scope:
1. fresh Mini Craft DNS NXDOMAIN;
2. durable Caddyfile SHA exact 12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb;
3. container-loopback Caddy Admin GET PASS;
4. active config SHA exact 206997c24f7e52efec7f7a8d241afe6c8d16b5b23e54fd799da0f3a94a9dd9cd;
5. primary edge-test static_response extraction if safe;
6. otherwise local behavioral fallback;
7. fallback fingerprint: HTTPS 200, body bytes 30, SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824;
8. exact body remains process-memory only;
9. construct candidate in memory: durable localhost baseline + equivalent edge-test + minicraft.spikersun.com reverse_proxy wordpress:80;
10. adapt only using a remote-local pipeline into docker exec -i spikersun-edge-caddy-1 caddy adapt --adapter caddyfile --config -;
11. prove localhost preserved;
12. prove edge-test behavioral parity;
13. prove Mini Craft upstream exactly wordpress:80;
14. freeze the already-defined future ingress mutation/rollback plan.

No runtime or durable writes.

## SSH #2 failure handling

If SSH #2 returns nonzero, classify local stderr before deletion. No third SSH. All remote actions are read-only/adapt-only, so no remote write reconciliation is required.
If the remote script emits an explicit bounded RETURN marker, preserve that classification.

## Local temp capture policy

One stdout and one stderr temp file per native SSH call are permitted. They must contain only bounded non-secret output, be deleted before Gate end, and have absence verified.

## Hard boundaries

No custom .NET Process SSH wrapper, SSH stdin, more than two network SSH calls, SCP/SFTP, remote temp script, Caddyfile write, candidate persistent file, Admin /load, Caddy reload/restart/stop, DNS/cloudflared/UFW/network/Compose mutation, product/indexing mutation, public ingress, Provider action, PayPal Live/payment/refund, Secret value/hash output, or unrelated mutation.

## Success contract

PASS_CANDIDATE_K6_PHASE_F_R1R5R2_DIRECT_NATIVE_SSH_TRANSPORT_AND_BEHAVIORAL_RESUME
LOCAL_DIRECT_NATIVE_SSH_SEAL=PASS
SSH_NETWORK_INVOCATIONS=2
SSH1_NATIVE_EXIT=0
SSH1_HOST_KEY_MATCH=YES_BY_STRICT_PINNED_SUCCESS
SSH1_REMOTE_COMMAND=WHOAMI_ONLY
SSH1_REMOTE_IDENTITY=ops
REMOTE_LAUNCHER_ARG_COUNT=1
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