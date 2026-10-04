# G4-B Baidu Owner Auth Readiness Checkpoint R6

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_AUTH_READINESS_CHECKPOINT_R6`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_BACKEND_R5R1_OFFLINE_REPAIR`

## OBJECTIVE

Build and offline-validate one atomic Owner-local checkpoint for later proving that the selected Baidu Netdisk account is already authenticated and usable by the accepted G4-B runner, without exposing or accepting credential values and without performing any real provider action in R6.

R6 does **not** authenticate the Owner. Account authentication remains an Owner-only action outside this offline execution round.

## MAX_ENDPOINT_THIS_ROUND

Source/docs only:

```text
design Owner-local readiness checkpoint
-> static/fixture validation
-> PowerShell AST parse
-> Secret scan
-> canonical persistence + fresh read-back
-> STOP_AT_REVIEWER
```

Forbidden in R6: real Baidu login, `who`, upload/download/mkdir/mv/rm, browser auth, cookies/tokens/passwords, VPS/SSH, DPAPI/real Secret access, Clash/service/route/proxy/TUN mutation, or G4-C.

## CHECKPOINT CONTRACT

The future Owner-local checkpoint must:

- be one atomic PowerShell checkpoint, not a sequence of manual debug commands;
- reuse the accepted BaiduPCS-Go v4.0.2 release-archive trust anchor:
  `ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30`;
- either use a locally supplied archive or download the exact pinned archive, verify it before extraction, and extract only the bounded traversal-safe `BaiduPCS-Go.exe` entry;
- never accept BDUSS, STOKEN, cookies, password, token, or other credential value as a script parameter, command-line argument, environment variable, stdout/stderr payload, log, Evidence, or Git content;
- never invoke the CLI `login` command;
- inspect the selected Baidu config directory only for existence, ownership/ACL, reparse-point and location safety; do not print or copy config contents;
- when later executed by Owner, permit only the read-only CLI `who` readiness operation, with stdout/stderr captured inside the protected process boundary;
- parse only the account UID in memory, compare it to an Owner-supplied expected numeric UID, and emit only bounded markers such as `BAIDU_LOGIN_READY=YES` and `BAIDU_ACCOUNT_MATCH=YES`; never emit the UID or raw provider output;
- return a precise `RETURN_OWNER_ACTION_REQUIRED`/equivalent when config is absent or no authenticated account is available;
- fail closed on account mismatch, unsafe ACL/config location, archive mismatch, CLI error, ambiguous output, or raw-output sanitization failure;
- perform no provider mutation.

The Owner may later authenticate BaiduPCS-Go locally using an Owner-controlled method, but credentials are never relayed to Reviewer/Executor. R6 only prepares the readiness verifier.

## ALLOWED FILES

Executor may create/modify only:

- `scripts/g4b-baidu-auth-readiness-checkpoint.ps1`
- `scripts/g4b-baidu-auth-readiness-validator.ps1`
- `docs/G4B_BAIDU_OWNER_AUTH_READINESS_CHECKPOINT_R6.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`
- accepted R5R1 live runner and fixture validator;
- accepted templates and prior Evidence.

## REQUIRED VALIDATION

At minimum:

```text
R6_NO_CREDENTIAL_PARAMETERS=PASS
R6_NO_LOGIN_COMMAND=PASS
R6_PINNED_ARCHIVE_TRUST_REUSED=PASS
R6_CONFIG_METADATA_ONLY=PASS
R6_CONFIG_ACL_FAIL_CLOSED=PASS
R6_WHO_ONLY_RUNTIME_ACTION=PASS
R6_RAW_PROVIDER_OUTPUT_SUPPRESSED=PASS
R6_UID_NOT_EMITTED=PASS
R6_EXPECTED_ACCOUNT_MATCH_FAIL_CLOSED=PASS
R6_UNAUTHENTICATED_RETURNS_OWNER_ACTION_REQUIRED=PASS
R6_NO_PROVIDER_MUTATION_COMMANDS=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
LIVE_ACTIONS=0
```

Use synthetic fixtures only. R6 must not run the checkpoint against the real Owner config or network.

## TIMING

```text
ESTIMATED_EXECUTION_TIME=15-25 minutes
TIMING_RECORD_REQUIRED=YES
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
```

Capture `ROUND_STARTED_AT` before the first preflight/sync and finish after GitHub fresh read-back. If actual elapsed exceeds 25 minutes, record the evidence-backed cause.

## ACCEPTANCE

```text
OWNER_AUTH_READINESS_CHECKPOINT_OFFLINE_READY=YES
CREDENTIAL_VALUES_ACCEPTED_OR_EMITTED=0
REAL_BAIDU_ACTIONS=0
LIVE_G4B_ACTIONS=0
STOP_AT_REVIEWER=YES
```
