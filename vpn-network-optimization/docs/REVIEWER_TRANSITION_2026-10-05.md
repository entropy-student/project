# Reviewer Transition — 2026-10-05 — G4-B R17 Stale-Pending Quarantine Preparation

> Durable handoff snapshot for the next Reviewer. `REVIEWER_HANDOFF.md` remains the canonical current-state authority. This file preserves the accepted R4→R17 chronology, current safety boundary and exact next unresolved question.

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
STATE=OWNER_ACTION_REQUIRED_R18_READONLY_CLEAN_CHECK
GATE_ID=G4B_BAIDU_RESIDUAL_CLEAN_READONLY_R6R2L_R18
PREVIOUS_RESULT=RETURN_R6R2L_R16_STALE_PENDING_PRESENT
R17_GATE_BLOB=7d850014c1845a21664f26e503f9da63f4446e6d
R17_HELPER_BLOB=9c910628932c22c448c822437fd53e0b71804a9c
R17_VALIDATOR_BLOB=7a555224720ce65b724012c425b58d6aad2c9026
R17_EXECUTION_AUTHORIZED=YES
R17_EXECUTION_RELEASED=YES
R17R1_GATE_BLOB=05efff190c10e4649e10acb9814f5f0d7d705b95
R17R1_RESULT=PASS_R17R1_OFFLINE_CODE_VALIDATION
```

Historical bounded live authorization remains recorded for the earlier G4-B live work, but it does **not** authorize R17 or any new live retry.

Current truth:
- R15 local ACL normalization is formally PASS and its local rollback journal remains retained.
- R16 read-only provider observation is complete: final=0, pending=1, unknown=0.
- Remote production residual state is formally `STALE_PENDING_PRESENT`.
- R17 Gate/helper/validator are locked after a pre-execution fail-closed repair for unique UID parsing, typed quarantine collision detection and exact mv argument shape; Owner explicitly authorized the exact current Gate; provider mutation has not yet executed.

## 4. R4 → R17 chronology

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

### R14 — known config-role Owner classification — PASS

R14 completed exactly within metadata-only scope:

```text
TOTAL_ITEM_COUNT=3
ROOT_OWNER_ROLE=OWNER
CONFIG_PRESENT=YES
CONFIG_OWNER_ROLE=OWNER
HISTORY_PRESENT=NO
HISTORY_OWNER_ROLE=NOT_PRESENT
UPLOAD_DB_PRESENT=YES
UPLOAD_DB_OWNER_ROLE=ADMIN
CAPTCHA_PRESENT=NO
CAPTCHA_OWNER_ROLE=NOT_PRESENT
UNKNOWN_FILE_COUNT=0
UNKNOWN_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R14_KNOWN_ROLE_STATE=EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN
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
PASS_R6R2L_R14_EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN
```

R12-R14 together now prove:
- root Owner=OWNER;
- `pcs_config.json` Owner=OWNER;
- `pcs_uploading.json` Owner=ADMIN;
- history/captcha absent;
- no unknown entries;
- no reparse;
- prior R12 ACL policy checks were otherwise clean.

Upstream v4.0.2 upload path creates `pcs_uploading.json`, and R9 executed a real upload. This closes the local object-identity question.

### R15 — upload DB Owner normalization — PASS

R15 executed exactly once under explicit Owner authorization.

```text
R15_PRECHECK=PASS
R15_TARGET_OWNER_BEFORE=ADMIN
R15_ROLLBACK_JOURNAL=READY
R15_OWNER_MUTATION=PASS
R15_TARGET_OWNER_AFTER=OWNER
R15_R6R1_STRICT_ACL_READBACK=PASS
R15_SHAPE_READBACK=PASS
R15_RESULT=PASS_CANDIDATE
ROLLBACK_JOURNAL_RETAINED=YES
CONFIG_CONTENT_READ=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

Formal result:

```text
PASS_R6R2L_R15_UPLOAD_DB_OWNER_NORMALIZATION
```

Interpretation:
- exact `pcs_uploading.json` Owner normalized ADMIN -> current Owner;
- pre-write rollback journal was created and verified;
- strict R6R1 ACL metadata readback PASSed after mutation;
- exact local shape remained correct;
- no provider/network/Secret/VPS/live-G4B action occurred;
- rollback journal remains retained and must not be deleted yet.

### R16 — remote residual-state read-only reconciliation — RETURN / observation complete

R16 reused the reviewed R11 read-only helper unchanged and completed the provider observation after R15 repaired the local ACL boundary.

Locked identities:

```text
R16_GATE_BLOB=33649d6c5cf5b16120f4578680071beab9da4592
R16_HELPER_BLOB=b3dfb42f4deaf28650d3aab35d92b5a2965ed662
```

Observed result:

```text
BAIDU_CONFIG_ACL=PASS
BAIDU_PINNED_CLI=PASS
BAIDU_WHO_PROCESS=PASS
BAIDU_UID_PARSE=PASS
BAIDU_UID_MATCH=PASS
BAIDU_LS_PROCESS=PASS
BAIDU_DIRECTORY_HEADER=PASS
PROJECT_FINAL_COUNT=0
PROJECT_PENDING_COUNT=1
PROJECT_UNKNOWN_COUNT=0
BAIDU_RESIDUAL_STATE=STALE_PENDING_PRESENT
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
LIVE_G4B_RUNNER_EXECUTED=NO
STOP_AT_REVIEWER=YES
```

Formal Reviewer result:

```text
RETURN_R6R2L_R16_STALE_PENDING_PRESENT
```

Interpretation:
- local ACL readiness is now reconciled;
- provider account/UID/header checks pass;
- production namespace contains no final object and no unknown project object;
- exactly one strict project pending object remains;
- R16 performed no provider mutation;
- remote residual state is no longer UNKNOWN.

The one pending object is consistent with the R9 pending-upload chronology and is the only production-namespace project residual. R16 does not itself authorize mutation.

### R17 / R17R1 — R17R1 PASS / R17 OWNER CHECKPOINT READY

Current Gate:

`docs/G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17.md`

Locked Gate identity:

```text
R17_GATE_BLOB=dccccf92969d37f5f83b7cb4b6f085cc0cdf566c
R17_HELPER_BLOB=9c910628932c22c448c822437fd53e0b71804a9c
R17_VALIDATOR_BLOB=7a555224720ce65b724012c425b58d6aad2c9026
R17_EXECUTION_AUTHORIZED=YES
```

R17 deliberately uses reversible quarantine rather than permanent delete.

Planned future behavior after helper preparation, review and explicit Owner authorization:
- re-prove final=0/pending=1/unknown=0;
- prove the exact single source matches the strict pending basename regex;
- prove quarantine target absent;
- rename source pending to a non-production quarantine basename;
- verify source absent, quarantine present, final=0/pending=0/unknown=0;
- on failed post-readback, rename quarantine back to the exact source and prove final=0/pending=1/unknown=0;
- never permanently `rm` ciphertext in R17.

R17R1 is formally PASS. Final locked identities are helper `9c910628932c22c448c822437fd53e0b71804a9c` and validator `7a555224720ce65b724012c425b58d6aad2c9026`; parent R17 Gate is relocked at `7d850014c1845a21664f26e503f9da63f4446e6d`. The previously recorded exact Owner authorization is released without scope expansion. The current action is one bounded R17 Owner checkpoint, followed by mandatory Reviewer stop.

## 5. Current unresolved truth

Known:
- WireGuard remains production/rollback baseline.
- Existing HY2 remains accepted.
- R8 is formally PASS.
- R10 is formally PASS.
- R15 is formally PASS and its rollback journal remains retained.
- R16 is complete and proves provider production namespace final=0, pending=1, unknown=0.
- Persistent REALITY service is not accepted.
- Persistent `SELF-VPN-V1` profile is not accepted.
- G4-C has not started.
- system proxy/TUN remain outside current work.

Unknown / unresolved:
- R17R1 is formally PASS; final helper/validator are locked and R17 execution is released under the previously recorded exact authorization.
- The stale pending has not yet been quarantined or deleted.
- The provider production namespace is therefore not yet CLEAN.
- No new live G4-B retry Gate may be issued yet.
- Permanent disposition of quarantined ciphertext, if later desired, remains a separate decision.

## 6. Current safety boundary

Outside the exact locked R17 one-shot checkpoint, the current authorization does **not** authorize:
- permanent `rm`;
- upload/download-from-Baidu;
- mkdir;
- login/logout/config mutation;
- raw UID/stdout/stderr/remote filename output;
- deleting or modifying the retained R15 rollback journal;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

R17 helper/validator final identities are locked after R17R1 PASS. The Owner may run only the exact relocked R17 one-shot checkpoint; live G4-B/G4-C remain blocked.

## 7. What the next Reviewer must read

Read in this order:

1. `REVIEWER_HANDOFF.md` — canonical dashboard/current Gate.
2. `docs/REVIEWER_TRANSITION_2026-10-05.md` — this complete R4→R17 chronology.
3. `docs/G4B_BAIDU_STALE_PENDING_QUARANTINE_CODE_VALIDATION_R6R2L_R17R1.md` — current local Codex offline code-validation Gate.
4. `docs/G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17.md` — exact current locked and Owner-authorized Gate; execution not yet performed.
4. `docs/G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17_PREPARATION_EVIDENCE.md` — locked helper/validator review evidence.
4. `EXECUTION_EVIDENCE.md` — append-only execution proof through R16.
5. `docs/G4B_BAIDU_RESIDUAL_READONLY_AFTER_ACL_R6R2L_R16.md` — completed R16 Gate.
6. `docs/G4B_BAIDU_UPLOAD_DB_OWNER_NORMALIZATION_R6R2L_R15.md` — completed R15 Gate.
7. `docs/G4B_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14.md` — completed R14 role proof.
8. `docs/G4B_BAIDU_CONFIG_FILE_ROLE_OWNER_READONLY_R6R2L_R13.md` — completed R13 role narrowing.
9. `docs/G4B_BAIDU_CONFIG_ACL_OWNER_DRIFT_READONLY_R6R2L_R12.md` — completed R12 ACL inventory.
10. `docs/G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11.md` — historical R11 blocked read-only Gate.
11. `docs/G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10.md` — accepted R10 parser repair.
12. `DECISION_LOG.md` — durable architecture/authorization rationale.
13. Older transition/package docs only if earlier context is needed.

Historical `EXECUTOR_HANDOFF.md` never overrides current Reviewer state.

## 8. What must not be repeated

Do not repeat without a new current Gate / new authorization:
- R4 repair validation;
- R5 live attempt;
- R6 local P5 diagnostic;
- R7 provider-boundary diagnosis;
- R8 pipeline-output repair validation;
- R9 live retry;
- R10 parser/fixture validation;
- R11 blocked provider readback;
- R12 ACL inventory;
- R13 file-role classifier;
- R14 known-role classifier;
- R15 Owner normalization;
- R16 read-only provider observation;
- HY2 credential recovery/rotation;
- G4-B0 bypass canary;
- earlier HY2/REALITY compatibility/canary work.

## 9. Repository durability

This transition snapshot, R17 Gate, R16/R15/R14/R13/R12 history, reusable reviewed helpers, accepted runner/validator, Evidence, Handoff and README are all on `main`.

No branch-only artifact is required to reconstruct or continue the current accepted project state.



### R17 formal PASS / R18 current boundary — 2026-10-06

```text
R17_RESULT=PASS_R6R2L_R17_STALE_PENDING_QUARANTINE
R17_FORWARD_MV_COUNT=1
R17_ROLLBACK_REQUIRED=NO
R17_POST_FINAL_COUNT=0
R17_POST_PENDING_COUNT=0
R17_POST_UNKNOWN_COUNT=0
R17_PERMANENT_DELETE=NO
R18_GATE_BLOB=f42237242503405c11f652240b4baedec8e71e22
R18_STATE=OWNER_ACTION_REQUIRED_READONLY_CLEAN_CHECK
```

R17 moved the exact stale pending out of the production namespace into the non-production quarantine namespace with one reversible rename. No rollback or permanent deletion was required. R18 now independently verifies CLEAN using the reviewed read-only helper; no Provider mutation is authorized in R18.


### R19 fresh Owner authorization — 2026-10-06

```text
R19_GATE_BLOB=13ebc71547c975aa7f99434887e07646bb495a00
R19_LIVE_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
R19_LIVE_RUNNER_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
OWNER_R19_LIVE_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
AUTHORIZED_LIVE_INVOCATIONS=1
SECOND_LIVE_INVOCATION_AUTHORIZED=NO
```

R18 is formally PASS and the production recovery namespace is CLEAN. The historical live one-shot is not replayed. R19 is released for exactly one Owner Administrator PowerShell 7.6.6 live checkpoint. Local-only UID/SSH-key/passphrase inputs and the P10 Clash import remain Owner actions; the profile must not be activated.


### R19 RETURN / R19R1 current boundary — 2026-10-06

```text
R19_RESULT=RETURN_R19_P5_MIHOMO_CONFIG_PARSE_FAILED
R19_LIVE_INVOCATION_COUNT=1
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
LIVE_G4B_EXECUTION_AUTHORIZED=NO
R19R1_GATE_BLOB=7e9e7bf4f69645a695d418bd934c04d79625707c
R19R1_STATE=LOCAL_CODEX_OFFLINE_DIAGNOSTIC
```

R19 failed safely at the local generated profile Mihomo parse check before persistent remote mutation. The one-shot live release is consumed and cannot be replayed. R19R1 uses synthetic values and the actual installed Mihomo parser to reproduce and repair the local parse incompatibility; no Administrator PowerShell, provider, SSH/VPS or network mutation is authorized.


### Owner final validation scope update — 2026-10-06

```text
OWNER_FINAL_G4_VALIDATION_SCOPE=CHATGPT_THREE_ROLE_SMOKE_ONLY
G4C_REQUIRED_ROLES=HY2_SFO3,WG_BASELINE,REALITY_SFO3
G4C_HEAVY_PERFORMANCE_MATRIX=REMOVED_FROM_V1_ACCEPTANCE
G4D_ADDED=YES
G4D_OBJECTIVE=WIREGUARD_IN_CLASH_MIHOMO
WINDOWS_WIREGUARD_DISABLE_AFTER_G4D_PASS=YES
FINAL_CONTROL_PLANE=CLASH_VERGE
```

Owner does not require another complex real-workload benchmark. After G4-B, G4-C only needs manual switching among all three Clash roles with successful normal ChatGPT conversation on each. G4-D then migrates WireGuard into Clash/Mihomo; the standalone Windows WireGuard client remains active until G4-D formal PASS and may then be disabled. Current R19R1 diagnostic scope is unchanged.


### R19R1 formal PASS / R20 prepared — 2026-10-06

```text
R19R1_RESULT=PASS_R19R1_LOCAL_MIHOMO_PARSE_REPAIR
R19R1_GATE_BLOB=7e9e7bf4f69645a695d418bd934c04d79625707c
R19R1_SOURCE_COMMIT=dcbc609c329198e49f87191247570ce0e35ff1a6
FINAL_RUNNER_BLOB=3a5e7c93bb96a4b485283f6590df18c5fac2690f
FINAL_LIVE_FIXTURE_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
FINAL_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
FINAL_PACKAGE_VALIDATOR_BLOB=59e18226dff66adcaac978b4b7eeb540a14514c9
R20_GATE_BLOB=a35f1c4c62091338a1ef71c19f1af0ac94a60a46
R20_STATE=FRESH_OWNER_AUTHORIZATION_REQUIRED
LIVE_G4B_EXECUTION_AUTHORIZED=NO
```

Reviewer accepted the executable diagnosis: the HY2 fingerprint sentinel was left unrendered; `encryption: ""` did not repair parsing; using the already pin-verified certificate fingerprint produced a real local Mihomo parse PASS. The historical R19 one-shot authorization is consumed. R20 is a fresh consequential boundary and requires new explicit Owner authorization.


### Standing Owner authorization — 2026-10-06

```text
OWNER_STANDING_AUTHORIZATION=GRANTED_FOR_DOCUMENTED_ROADMAP
OWNER_STANDING_AUTH_SCOPE=R20,G4C_CHATGPT_THREE_ROLE_SMOKE,G4D_WIREGUARD_IN_CLASH,MVP_V1_SEAL
R20_LIVE_G4B_EXECUTION_AUTHORIZED=YES
R20_AUTHORIZED_LIVE_INVOCATIONS=1
NEW_MATERIAL_SCOPE_REQUIRES_REVIEWER_STOP=YES
```

Do not repeatedly ask the Owner for authorization inside the documented closeout roadmap. Preserve one-shot execution limits and mandatory Reviewer stops.


### R20 P7 RETURN / R20R1 read-only reconciliation — 2026-10-06

```text
R20_RESULT=RETURN_R20_P7_UNCLASSIFIED_ROLLBACK_UNKNOWN
R20_CONSEQUENTIAL_MUTATION_STARTED=YES
R20_REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION
R20_SECOND_ATTEMPT=FORBIDDEN
R20R1_GATE_BLOB=7fdbc077a82e6bbd262d7c5060cd78e0e1a4e2f2
R20R1_HELPER_BLOB=50bc1911d9ae5493cc715e0fb7cfdac8d9266d9c
R20R1_SCOPE=READ_ONLY
```


### R20R1 observation / R20R2 classification — 2026-10-06

```text
R20R1_RESULT=PASS_R20R1_OBSERVATION_PROJECT_RESIDUAL_PRESENT
R20R1_CONSEQUENTIAL_REALITY_SURFACE=CLEAN
R20R1_WG_HY2=HEALTHY
R20R1_TRANSACTION_RESIDUAL=YES
R20R2_GATE_BLOB=92150b47085a770556290dadfca4fdd045c951e0
R20R2_HELPER_BLOB=dcabd46abc7d2736369e1f0f0a0072f6dfe78398
R20R2_SCOPE=READ_ONLY
```
