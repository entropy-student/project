# Reviewer Transition — 2026-10-05 — G4-B R12 Local ACL Owner-Drift Inventory

> Durable handoff snapshot for the next Reviewer. `REVIEWER_HANDOFF.md` remains the canonical current-state authority. This file preserves the accepted R4→R14 chronology, current safety boundary and exact next unresolved question.

## 1. Project goal and frozen v1 role order

Project: `vpn-network-optimization`

Goal: establish a portable, verifiable and rollbackable self-built VPN optimization standard for Codex/OpenAI/image-generation workloads, prioritizing stability and tail performance.

Owner-frozen v1 role order:

```text
HY2-SFO3      PRIMARY
WG-BASELINE   BACKUP_1
REALITY-SFO3  BACKUP_2
AUTO_SWITCHING=OFF
```

WireGuard remains the current production/rollback baseline. No final production-role activation has been accepted.

## 2. Accepted stage map

```text
P0 Research / Scope                         PASS
G1 Foreground-safe Foundation               PASS
G2 Multi-path candidate validation          PASS
G3-A Health/readiness/advisory              PASS
G3-B Migration package D1-D3                PASS_OFFLINE
G3-C Manual-control contract                PASS
G3-C Synthetic UI package                   PASS
G3-C Real HY2-in-Clash canary               PASS
G4-A Three-role target/offline package      PASS
G4-B0 Windows interface bypass canary       PASS
G4-B Persistent three-role readiness        IN_PROGRESS
G4-C Peak-hour + real workload validation   PENDING
MVP v1 seal                                 PENDING
```

## 3. Current canonical Reviewer state

```text
STATE=OWNER_ACTION_REQUIRED_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14
GATE_ID=G4B_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14
PREVIOUS_RESULT=RETURN_R6R2L_R13_EXPECTED_HISTORY_ABSENT_ONE_UNKNOWN_FILE
R12_GATE_BLOB=e8a41d4e6bcfe65f1d552c30134d6eb2c862aab2
```

Existing bounded live authorization is still recorded historically:

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
```

That does **not** authorize a live retry now. Current R12 is local metadata-only.

## 4. R4 → R12 chronology

### R4 — offline repair validation — PASS

R4 closed the earlier canonical Git-root, Unicode-safe path, CRLF and validator-repair chain.

Accepted identities:

```text
RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
```

### R5 — first bounded live G4-B attempt — RETURN

R5 executed exactly once and reached P5:

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=UNCLASSIFIED
CONSEQUENTIAL_MUTATION_STARTED=NO
STOP_AT_REVIEWER=YES
```

No accepted persistent REALITY/service/profile mutation began.

### R6 — local P5 diagnostic — PASS

R6 excluded the local non-provider chain as the R5 cause:

```text
POST_FAILURE_LOCAL_CLEANUP=PASS
HY2_DPAPI_UNPROTECT=PASS
HY2_FRAME_PARSE=PASS
HY2_CERTIFICATE_CONTRACT=PASS
MIHOMO_VERSION=PASS
MIHOMO_REALITY_KEYPAIR=PASS
BAIDU_NETWORK_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
```

### R7 — provider boundary diagnosis — root cause identified

A bounded Baidu read-only diagnostic reproduced:

```text
DIAGNOSTIC_STAGE=BAIDU_WHO
DIAGNOSTIC_EXCEPTION_TYPE=System.Management.Automation.PropertyNotFoundException
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
```

Source reconciliation identified PowerShell success-stream pollution:

```powershell
$psi.Environment.Remove([string]$key)
```

The Boolean return values polluted the helper output before the process-result object. Under StrictMode, later member access could hit a Boolean and raise `PropertyNotFoundException`.

This explains the R5 outer `UNCLASSIFIED`.

### R8 — process-output repair — PASS

Accepted repair:

```powershell
[void]$psi.Environment.Remove([string]$key)
```

Reviewer confirmed the live runner differed from the previously authorized R5 runner by exactly this one safety-preserving line.

Required positive and negative regressions passed, with zero live/provider/network action.

Formal result:

```text
PASS_R6R2L_R8_BAIDU_PIPELINE_OUTPUT_REPAIR
```

### R9 — second bounded live attempt — RETURN

R9 executed exactly once and passed the R8-fixed process boundary.

It reached the real pending-upload readback:

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=BAIDU_PENDING_UPLOAD_NOT_PRESENT
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
STOP_AT_REVIEWER=YES
```

Upstream BaiduPCS-Go v4.0.2 source reconciliation proved a second defect:

- detailed `ls -l` is rendered as a borderless table;
- filename is the final field and directories append `/`;
- the pre-R10 runner expected ASCII pipe-delimited rows;
- the fake provider fixture also synthesized pipe rows, masking the drift;
- upstream upload code still confirms target directory + local basename semantics.

Therefore R9 was reconciled as a **real-listing parser / fixture-drift defect**, not proof that auth or upload itself failed.

R9 must not be replayed.

### R10 — real-listing parser / fixture repair — PASS

Production parser was rebuilt from the last parser-valid R9 runner and changed only at the listing matcher.

Accepted behavior:
- exact basename in final `ls -l` field;
- no pipe dependency;
- trailing `/` means DIRECTORY;
- exact file/directory/basename matching;
- safe line-end lookahead `(?=\r?\n|\z)`.

Validator was rebuilt from the last parser-valid R9 validator and re-applied only the intended R10 fixtures.

Several R10 attempts returned safely before live/provider action while fixing source persistence/parser/static-fixture defects:
- stale whole-repository HEAD guard;
- malformed persisted runner duplicate tail;
- validator parser error;
- wrong validator function-boundary lookup.

Final R10 validation passed:

```text
R10_PARSER_PREFLIGHT=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_FORMAT_PARSER=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_FILE_MATCH=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_DIRECTORY_MATCH=PASS
G4B_FIXTURE_R6R2L_R10_BAIDU_REAL_LS_EXACT_BASENAME=PASS
G4B_FIXTURE_NEGATIVE_BAIDU_PIPE_BORDER_ONLY_PARSER=PASS
G4B_FIXTURE_R4_PENDING_UPLOAD_READBACK_PASS=PASS
G4B_FIXTURE_R4_PENDING_TO_FINAL_PROMOTION_PASS=PASS
G4B_FIXTURE_R4_ROLLBACK_REMOVES_PENDING_ONLY=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
SSH_OR_VPS_ACTION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
NETWORK_MUTATION=NO
CLASH_PROFILE_MUTATION=NO
SYSTEM_PROXY_CHANGE=NO
TUN_CHANGE=NO
SERVICE_MUTATION=NO
ROUTE_MUTATION=NO
REALITY_LIVE_DEPLOYMENT=NO
G4C_EXECUTION=NO
```

Formal result:

```text
PASS_R6R2L_R10_BAIDU_REAL_LISTING_PARSER_REPAIR
```

Accepted identities:

```text
R10_GATE_BLOB=ef148ca80a630e0e6faab748a8862b5bee0e6ea4
R10_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
R10_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
```

### R11 — Baidu residual-state read-only reconciliation — RETURN

R11 existed because R9's `BAIDU_PENDING_ROLLBACK=PASS` depended on the now-superseded pre-R10 listing parser and therefore could not prove remote cleanliness.

An initial R11 attempt stopped at parser preflight because two sanitized error-reporting `Write-Output (...)` statements were missing their outer closing parenthesis. That attempt executed no diagnostic/provider action. The script was repaired and relocked.

Final R11 source identities used by Owner:

```text
R11_GATE_BLOB=b941fb2a97951ce978752937f36baebca7c6c4c5
R11_SCRIPT_BLOB=b3dfb42f4deaf28650d3aab35d92b5a2965ed662
```

The final R11 attempt passed source and parser preflight, then stopped locally:

```text
OWNER_RUNTIME=PASS
DIAGNOSTIC_STAGE=BAIDU_CONFIG_ACL
DIAGNOSTIC_FAILED_STAGE=BAIDU_CONFIG_ACL
DIAGNOSTIC_EXCEPTION_TYPE=System.Management.Automation.RuntimeException
BAIDU_RESIDUAL_STATE=BAIDU_AUTH_CONFIG_OWNER_MISMATCH
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Important interpretation:
- R11 stopped **before hidden UID input**;
- R11 did not execute Baidu `who`;
- R11 did not execute remote `ls`;
- remote pending/final residual state therefore remains **UNKNOWN**;
- the only new observed fact is that at least one local Baidu config subtree object is not owned by the exact current Owner SID required by the strict R6R1 invariant.

Formal result:

```text
RETURN_R6R2L_R11_BAIDU_AUTH_CONFIG_OWNER_MISMATCH
```

### R12 — local ACL owner-drift inventory — PASS as metadata observation

R12 completed within metadata-only scope.

```text
ITEM_COUNT=3
FILE_COUNT=2
DIRECTORY_COUNT=1
ROOT_OWNER_MATCH=YES
EXACT_OWNER_ITEM_COUNT=2
ADMIN_OWNER_ITEM_COUNT=1
SYSTEM_OWNER_ITEM_COUNT=0
OTHER_OWNER_ITEM_COUNT=0
OWNER_MISMATCH_FILE_COUNT=1
OWNER_MISMATCH_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
DENY_ACE_ITEM_COUNT=0
UNAUTHORIZED_ALLOW_ITEM_COUNT=0
OWNER_READ_RIGHTS_MISSING_ITEM_COUNT=0
R12_ACL_STATE=ADMIN_OWNER_MULTI_ITEM_DRIFT
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

Formal Reviewer interpretation:

```text
PASS_R6R2L_R12_METADATA_OBSERVATION_ADMIN_OWNER_ONE_FILE
```

R12 does not mean multiple items have Owner drift. It means:
- config root is Owner-owned;
- exactly one of two files is Administrators-owned;
- the other file is Owner-owned;
- no SYSTEM/OTHER Owner exists;
- ACL policy, reparse and Owner-read-rights checks are clean.

Additional upstream v4.0.2 source reconciliation proved the config directory legitimately uses both:
- `pcs_config.json`;
- `pcs_command_history.txt`.

Therefore root + two-file shape is potentially normal and requires one more metadata-only role classification before any normalization is considered.

### R13 — config file-role Owner classification — RETURN

R13 completed within metadata-only scope:

```text
TOTAL_ITEM_COUNT=3
ROOT_OWNER_ROLE=OWNER
CONFIG_FILE_PRESENT=YES
CONFIG_FILE_OWNER_ROLE=OWNER
HISTORY_FILE_PRESENT=NO
HISTORY_FILE_OWNER_ROLE=NOT_PRESENT
UNEXPECTED_FILE_COUNT=1
UNEXPECTED_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R13_FILE_ROLE_STATE=UNEXPECTED_ENTRY_PRESENT
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

Formal result:

```text
RETURN_R6R2L_R13_EXPECTED_HISTORY_ABSENT_ONE_UNKNOWN_FILE
```

Interpretation:
- `pcs_config.json` is present and Owner-owned;
- `pcs_command_history.txt` is absent;
- exactly one other direct-child file exists;
- R12 already proved exactly one file in the subtree is Administrators-owned, so this unclassified direct-child file is the current Owner-mismatch file.

Upstream v4.0.2 reconciliation then identified two additional known config-directory roles:
- `pcs_uploading.json`, created by the upload path through `NewUploadingDatabase()`;
- `captcha.png`, used by captcha handling.

R9 executed a real upload, so `pcs_uploading.json` is the strongest candidate, but that remains unaccepted until R14 proves it from metadata.

### R14 — current known config-role Owner classification — READY TO EXECUTE

Current Gate:

`docs/G4B_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14.md`

Prepared helper:

`scripts/g4b-baidu-known-config-role-owner-r14.ps1`

Locked identities:

```text
R14_GATE_BLOB=4a12130337fc79366ce2dceea3fb7ae5f5fe759e
R14_SCRIPT_BLOB=e2a5f2e9f64e5878b66575f50f772131b7dacb0f
```

R14 is local direct-child metadata-only. It classifies only the four upstream-known config-directory roles: config, command history, upload database and captcha.

Desired narrow observation:

```text
ROOT_OWNER_ROLE=OWNER
CONFIG_PRESENT=YES
CONFIG_OWNER_ROLE=OWNER
HISTORY_PRESENT=NO
UPLOAD_DB_PRESENT=YES
UPLOAD_DB_OWNER_ROLE=ADMIN
CAPTCHA_PRESENT=NO
UNKNOWN_FILE_COUNT=0
UNKNOWN_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R14_KNOWN_ROLE_STATE=EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN
```

R14 does not authorize ACL normalization, provider access or live retry.

## 5. Current unresolved truth

Known:
- WireGuard remains production/rollback baseline.
- Existing HY2 remains accepted.
- R8 is formally PASS.
- R10 is formally PASS.
- R5 and R9 both stopped before accepted consequential mutation.
- Persistent REALITY service is not accepted.
- Persistent `SELF-VPN-V1` profile is not accepted.
- G4-C has not started.
- system proxy/TUN remain outside current work.

Unknown / unresolved:
- whether the single Administrators-owned file is exactly the expected `pcs_config.json`;
- whether the Owner-owned second file is exactly the expected `pcs_command_history.txt`;
- whether R9 left a remote pending or final recovery object in Baidu;
- whether a later bounded ACL normalization will be safe;
- whether a new live G4-B retry can be issued.

## 6. Current safety boundary

R14 allows only local direct-child known-role/Owner metadata observation.

R14 does **not** authorize:
- config file content read/hash/copy/print;
- username/path/SID/ACE-detail output;
- `Set-Acl`, `takeown`, `icacls` or ownership mutation;
- BaiduPCS-Go/provider access;
- UID input;
- remote cleanup;
- DPAPI/recovery Secret access;
- SSH/VPS;
- live G4-B;
- Clash/profile/service/route/proxy/TUN mutation;
- G4-C.

Only after R14 is reviewed may Reviewer decide whether a separate narrow ACL-normalization/reconciliation Gate is justified. Remote residual-state readback remains blocked until local ACL state is reconciled.

## 7. What the next Reviewer must read

Read in this order:

1. `REVIEWER_HANDOFF.md` — canonical dashboard/current Gate.
2. `docs/REVIEWER_TRANSITION_2026-10-05.md` — this complete R4→R14 chronology.
3. `docs/G4B_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14.md` — exact current Gate.
4. `docs/G4B_BAIDU_CONFIG_FILE_ROLE_OWNER_READONLY_R6R2L_R13.md` — completed R13 Gate.
4. `EXECUTION_EVIDENCE.md` — append-only R5→R12 evidence and formal Reviewer decisions.
5. `docs/G4B_BAIDU_CONFIG_ACL_OWNER_DRIFT_READONLY_R6R2L_R12.md` — completed R12 metadata inventory Gate.
6. `docs/G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11.md` — R11 read-only Gate and failure boundary.
7. `docs/G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10.md` — accepted R10 repair.
8. `docs/G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1.md` — accepted ACL invariant definition.
9. `docs/G4B_BAIDU_SECURE_COOKIE_OWNER_ACL_NORMALIZATION_REPAIR_R6R2H_R1.md` — historical child-created Administrators-owner evidence/boundary; note that this specific duplicate Gate is marked superseded, so use it only as historical rationale, not an executable Gate.
10. `DECISION_LOG.md` — durable architecture/Owner decisions.
11. Older transition/package docs only if earlier context is actually needed.

Historical `EXECUTOR_HANDOFF.md` never overrides current Reviewer state.

## 8. What must not be repeated

Do not repeat without new Reviewer authorization/evidence:
- R4 repair validation;
- R5 live attempt;
- R6 local P5 diagnostic;
- R7 provider-boundary diagnosis;
- R8 pipeline-output repair validation;
- R9 live retry;
- R10 parser/fixture validation;
- R11 provider residual-state run as-is while ACL mismatch remains;
- R12 metadata inventory;
- HY2 credential recovery/rotation;
- G4-B0 bypass canary;
- earlier HY2/REALITY compatibility/canary work.

## 9. Repository durability

This transition snapshot, R14/R13/R12 Gates and helpers, R11/R10 history, accepted runner/validator, Evidence, Handoff and README are all on `main`.

No branch-only artifact is required to reconstruct or continue the current accepted project state.
