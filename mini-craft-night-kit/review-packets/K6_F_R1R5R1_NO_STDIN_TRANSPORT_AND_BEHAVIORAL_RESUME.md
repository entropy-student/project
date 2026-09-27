# K6 Phase F-R1R5R1 — No-stdin transport seal + behavioral resume

Gate:
K6_PHASE_F_R1R5R1_NO_STDIN_TRANSPORT_AND_BEHAVIORAL_RESUME

Read:
- current REVIEWER_HANDOFF.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_F_R1R5_RETURN_F_R1R5R1_NO_STDIN_TRANSPORT_RESUME.md
- prior F-R1R5 decision/pack
- latest Evidence/Handoff
- Shared VPS Handoff
- canonical governance latest

## Core correction

Do not use SSH stdin at all.

Every network SSH invocation must use:
- -n
- -T
- BatchMode=yes
- IdentitiesOnly=yes
- StrictHostKeyChecking=yes
- explicit UserKnownHostsFile
- exact identity file

Payload goes only in the final remote-command argument.

Max network SSH invocations: 2.

## Phase 0 — local seal

Before network:
- exact ssh.exe path
- ssh.exe -V through the same native capture mechanism
- native exit captured
- stdout/stderr capture proven
- stdin not redirected/opened

Failure -> RETURN_REVIEWER_F_R1R5R1_LOCAL_NO_STDIN_TRANSPORT_UNSEALED

## Phase 1 — SSH #1 transport canary

Remote command argument only:

set -eu
printf 'REMOTE_ARG_TRANSPORT_OK\n'
whoami
id -un
id -u
hostname

Require:
- native exit 0
- marker present
- ops / ops / nonzero UID / srv1970241
- strict pinned host-key success

Failure -> RETURN_REVIEWER_F_R1R5R1_REMOTE_COMMAND_TRANSPORT_CANARY_FAILED

No SSH #2 on failure.

## Phase 2 — SSH #2

Only after Phase 1 PASS.

Resume the exact semantic F-R1R5 logic.

No SSH stdin.

Allowed delivery:
- compact non-secret shell script
- UTF-8 -> Base64 locally
- final remote command argument:
  printf '%s' '<BASE64>' | base64 -d | bash

No remote script file.
No SCP/SFTP.

If command argument too large:
RETURN_REVIEWER_F_R1R5R1_REMOTE_COMMAND_ARGUMENT_TOO_LARGE

### F-R1R5 logic

- pre-sudo identity again
- fresh DNS NXDOMAIN
- durable Caddyfile hash exact
- container-loopback Admin GET
- active config hash exact
- primary static_response extraction; if ambiguous, local behavioral fallback
- edge-test fallback fingerprint:
  status 200
  body bytes 30
  SHA-256 2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
- exact body process-memory only
- in-memory candidate:
  durable localhost baseline
  + equivalent edge-test
  + minicraft.spikersun.com reverse_proxy wordpress:80
- adapt only
- prove localhost preserved
- prove edge-test behavioral parity
- prove Mini Craft route
- freeze future mutation + rollback plan

Remote candidate may be piped to docker exec -i caddy adapt from the remote shell. That is allowed because it is not SSH stdin.

## Capture

For each SSH:
- native exit
- stdout
- stderr separately/classified
- bounded non-secret output

Local temporary stdout/stderr files are allowed if required; delete and verify absent before end.

## Forbidden

No:
- StandardInput write
- SSH stdin payload
- third SSH
- remote temp script
- SCP/SFTP
- Caddyfile write/load/reload/restart
- DNS/cloudflared/UFW/network/Compose write
- product/indexing write
- public ingress
- Provider action
- Live/payment/refund
- Secret value/hash output

## Success

PASS_CANDIDATE_K6_PHASE_F_R1R5R1_NO_STDIN_TRANSPORT_AND_BEHAVIORAL_RESUME

Required evidence includes:
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
PUBLIC_INGRESS_CHANGESET=READY
ROLLBACK_PLAN=PASS
OWNER_CHECKPOINT_REQUIRED=YES
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
LOCAL_TEMP_CLEANUP=PASS
STOP_AT_REVIEWER=YES
