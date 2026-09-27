# K6 Phase F-R1R5R2 — Direct-native SSH transport recovery + behavioral resume

Gate: K6_PHASE_F_R1R5R2_DIRECT_NATIVE_SSH_TRANSPORT_RECOVERY_AND_BEHAVIORAL_RESUME

Authority:
- canonical GitHub entropy-student/spike.skill/vps-project-governance latest
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R5R1_RETURN_F_R1R5R2_DIRECT_NATIVE_SSH_RECOVERY.md
- prior F-R1R5 decision/pack
- latest Evidence/Handoff
- unique Shared VPS Handoff

## Objective

Stop using custom PowerShell/.NET SSH wrappers. Use direct native ssh.exe invocation, classify any transport failure from locally retained stderr, then resume the already-reviewed F-R1R5 read-only Caddy behavioral reconciliation.

## Phase 0 — local seal

Use direct PowerShell call operator only:
& $sshExe @args

Requirements:
- exact ssh.exe path
- ssh.exe -V exit captured through $LASTEXITCODE
- stdout/stderr temp capture proven
- no stdin redirection
- temp cleanup proven

Failure -> RETURN_REVIEWER_F_R1R5R2_LOCAL_DIRECT_NATIVE_SEAL_FAILED

## Phase 1 — SSH #1

Exactly one remote command token: whoami

Strict options:
- -n -T
- port 22
- exact identity
- BatchMode=yes
- IdentitiesOnly=yes
- StrictHostKeyChecking=yes
- explicit UserKnownHostsFile
- bounded timeout/keepalive
- ops@2.24.193.133

PASS:
- native exit 0
- stdout exactly ops

If nonzero, classify stderr locally, record only safe classification/signature, delete temp captures, return RETURN_REVIEWER_F_R1R5R2_DIRECT_NATIVE_CANARY_FAILED, and stop.

Do not run SSH #2 on failure.

## Phase 2 — encoded payload seal

Only after SSH #1 PASS.

Build compact non-secret F-R1R5 read-only shell script as UTF-8 LF bytes.
Base64 encode with no CR/LF.
Local decode must match source bytes.

Remote launcher must be exactly one string argument:
echo <BASE64>|base64 -d|bash

Record REMOTE_LAUNCHER_ARG_COUNT=1.
Reject total command line above 24000 UTF-16 chars.

## Phase 3 — SSH #2

Direct native invocation only. Same strict options, -n -T, one final launcher argument.
No stdin.

Remote script starts by proving:
- whoami=ops
- id -un=ops
- id -u nonzero
- hostname=srv1970241

Then perform only accepted F-R1R5 scope:
- fresh DNS NXDOMAIN
- durable Caddyfile frozen SHA
- Caddy container-loopback /config/ GET
- frozen active-config SHA
- edge-test primary extraction or local behavioral fallback
- behavioral fingerprint 200 / 30 bytes / SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- exact body process-memory only
- in-memory candidate
- adapt only
- localhost preserved
- edge-test parity
- Mini Craft reverse_proxy wordpress:80
- future ingress change/rollback plan READY

Remote-local pipe to docker exec -i caddy adapt is allowed because it is not SSH stdin.

## Failure handling

No third SSH.
Classify locally retained stderr before deletion.
All remote actions remain read-only/adapt-only.

## Forbidden

No custom .NET Process wrapper, SSH stdin, SCP/SFTP, remote temp script, Caddyfile write/load/reload/restart, DNS/cloudflared/UFW/network/Compose write, product/indexing mutation, public ingress, Provider action, Live/payment/refund, Secret output, or unrelated mutation.

## Required Evidence

LOCAL_DIRECT_NATIVE_SSH_SEAL=PASS
SSH_NETWORK_INVOCATIONS=
SSH1_NATIVE_EXIT=
SSH1_FAILURE_CLASS=
SSH1_SAFE_ERROR_SIGNATURE=
SSH1_HOST_KEY_MATCH=
SSH1_REMOTE_COMMAND=WHOAMI_ONLY
SSH1_REMOTE_IDENTITY=
REMOTE_LAUNCHER_ARG_COUNT=
REMOTE_LAUNCHER_TOTAL_CMDLINE_CHARS=
SSH2_NATIVE_EXIT=
SSH2_FAILURE_CLASS=
SSH2_HOST_KEY_MATCH=
SSH2_REMOTE_IDENTITY=
CURRENT_MINICRAFT_DNS=
DURABLE_CADDYFILE_SHA256=
CONTAINER_ADMIN_CONFIG_GET=
CURRENT_ACTIVE_CONFIG_SHA256=
EDGE_TEST_RECOVERY_METHOD=
EDGE_TEST_CURRENT_HTTPS_STATUS=
EDGE_TEST_CURRENT_BODY_BYTES=
EDGE_TEST_CURRENT_BODY_SHA256=
EDGE_TEST_CURRENT_HTTP_BEHAVIOR=
EDGE_TEST_CONFIGURED_HEADER_NAMES=
CANDIDATE_CADDYFILE_BYTES=
CANDIDATE_CADDYFILE_SHA256=
CANDIDATE_CADDYFILE_ADAPT=
LOCALHOST_DURABLE_BASELINE_PRESERVED=
EDGE_TEST_BEHAVIORAL_PARITY=
CANDIDATE_MINICRAFT_ROUTE=
MINICRAFT_EDGE_UPSTREAM=wordpress:80
PUBLIC_INGRESS_CHANGESET=
ROLLBACK_PLAN=
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
LOCAL_TEMP_CLEANUP=
STOP_AT_REVIEWER=YES

Success:
PASS_CANDIDATE_K6_PHASE_F_R1R5R2_DIRECT_NATIVE_SSH_TRANSPORT_AND_BEHAVIORAL_RESUME