# Reviewer Transition — 2026-10-05 — G4-B R11 Residual-State Reconciliation

> Durable handoff snapshot for the next Reviewer. `REVIEWER_HANDOFF.md` remains the canonical current-state authority; this file explains how the project reached that state and what must happen next.

## 1. Project goal and frozen v1 role order

Project: `vpn-network-optimization`

Goal: establish a portable, verifiable, rollbackable self-built VPN optimization standard for Codex/OpenAI/image-generation workloads, prioritizing stability and tail performance.

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
STATE=OWNER_ACTION_REQUIRED_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11
GATE_ID=G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11
PREVIOUS_RESULT=PASS_R6R2L_R10_BAIDU_REAL_LISTING_PARSER_REPAIR
```

Current R11 identities:

```text
R11_GATE_BLOB=fb03dce9b974e93e1126d6ce457e2c86919e4acb
R11_SCRIPT_BLOB=dff7b60e31e0fb28295a3309d5516ae23aee28cf
```

Existing bounded live authorization remains recorded:

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
```

However, **no live retry is currently authorized**. R11 is read-only state reconciliation only.

## 4. R4 → R11 chronology

### R4 — offline repair validation — PASS

R4 closed the earlier canonical Git-root, Unicode-safe path, CRLF and validator-repair chain.

Accepted source identities at that point:

```text
RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
```

This enabled the first bounded G4-B live attempt.

### R5 — first live G4-B attempt — RETURN

R5 was executed exactly once.

It reached:

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=UNCLASSIFIED
CONSEQUENTIAL_MUTATION_STARTED=NO
STOP_AT_REVIEWER=YES
```

No accepted persistent REALITY/service/profile mutation began.

### R6 — local P5 diagnostic — PASS

R6 proved the local non-provider P5 chain:

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

This excluded local DPAPI/HY2/Mihomo as the R5 root cause.

### R7 — Baidu boundary diagnosis — root cause identified

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

Source inspection found the same defect in the live process helper:

```powershell
$psi.Environment.Remove([string]$key)
```

`Remove()` returns a Boolean. Without suppression, those values polluted the PowerShell success stream ahead of the process-result object. Under StrictMode, later member access could hit a Boolean and throw `PropertyNotFoundException`.

This reconciled the R5 `UNCLASSIFIED` failure.

A separate diagnostic-edit branch later hit parser errors before execution; it was superseded and is not an active path.

### R8 — process-output repair — PASS

Accepted production repair:

```powershell
[void]$psi.Environment.Remove([string]$key)
```

Reviewer verified the live runner differed from the previously authorized R5 runner by exactly this one safety-preserving line.

Offline validation passed both the positive suppression contract and negative reintroduction regression:

```text
G4B_FIXTURE_R6R2L_R8_BAIDU_ENV_REMOVE_OUTPUT_SUPPRESSED=PASS
G4B_FIXTURE_NEGATIVE_BAIDU_ENV_REMOVE_STREAM_POLLUTION=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
EXTERNAL_REQUESTS=0
SSH_OR_VPS_ACTION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
NETWORK_MUTATION=NO
```

Formal result:

```text
PASS_R6R2L_R8_BAIDU_PIPELINE_OUTPUT_REPAIR
```

### R9 — second live attempt — RETURN

R9 was executed exactly once and passed the R8-fixed provider process boundary.

It reached the real pending-upload readback check:

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=BAIDU_PENDING_UPLOAD_NOT_PRESENT
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
STOP_AT_REVIEWER=YES
```

Reviewer did not authorize replay.

Upstream BaiduPCS-Go v4.0.2 source reconciliation then proved a second implementation defect:

- `pcstable.NewTable()` uses no border and no column separator;
- detailed `ls -l` renders filename as the final field, with directories as `filename/`;
- the pre-R10 production parser required pipe-delimited rows beginning with ASCII `|`;
- the fake provider fixture also synthesized pipe-delimited rows, masking the provider-format drift;
- upstream upload code still confirms a local file is saved under the supplied target directory using its basename.

Therefore `BAIDU_PENDING_UPLOAD_NOT_PRESENT` was reconciled as a **real listing parser / fixture-drift defect**, not proof that account auth or upload itself failed.

### R10 — real-listing parser / fixture repair — PASS

Production parser was rebuilt from the last parser-valid R9 runner and changed only at the real-listing matcher.

Accepted parser behavior:
- exact basename in the final `ls -l` field;
- no pipe-border dependency;
- trailing `/` classified as DIRECTORY;
- exact file/directory/basename matching;
- line-end handling via `(?=\r?\n|\z)` to avoid a prior persistence truncation boundary.

Validator was rebuilt from the last parser-valid R9 validator and re-applied only the intended R10 fixtures.

There were several **pre-execution / fixture-only** R10 returns while repairing:
- stale whole-repository HEAD guard;
- malformed persisted runner tail / parser preflight;
- malformed validator source / parser preflight;
- wrong validator function-boundary selection.

All of those stopped before live/provider/Secret/network action.

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

Accepted R10 identities:

```text
R10_GATE_BLOB=ef148ca80a630e0e6faab748a8862b5bee0e6ea4
R10_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
R10_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
```

### R11 — current read-only residual-state reconciliation — READY

R9 reported `BAIDU_PENDING_ROLLBACK=PASS`, but that observation depended on the pre-R10 broken real-listing parser. Therefore it cannot prove the remote recovery directory is clean.

R11 exists only to observe provider state using corrected semantics.

Current Gate:

`docs/G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11.md`

Current script:

`scripts/g4b-baidu-residual-readonly-r11.ps1`

Allowed provider commands are only:

```text
BaiduPCS-Go who
BaiduPCS-Go ls -l /vpn-network-optimization-g4b-recovery
```

R11 does **not** authorize:
- mkdir/upload/download-from-Baidu/mv/rm;
- login/logout/config mutation;
- cleanup of any remote object;
- live G4-B runner;
- SSH/VPS;
- DPAPI/recovery Secret access;
- Clash/profile/service/route/proxy/TUN mutation;
- G4-C.

R11 returns only sanitized object counts and one classification:

```text
CLEAN
STALE_PENDING_PRESENT
FINAL_PRESENT_REQUIRES_RECONCILIATION
MULTIPLE_OR_UNKNOWN_PROJECT_OBJECTS
AUTH_OR_PROVIDER_READ_FAILED
LOCAL_DIAGNOSTIC_EXCEPTION
```

A CLEAN result may permit Reviewer to design a new bounded live retry Gate. Any residual state requires a separate reconciliation Gate.

## 5. Owner environment and Secret rules

Known Owner environment:

```text
PowerShell=7.6.6
Administrator=YES
HighIntegrity=YES
RepoRoot=C:\Users\34707\Documents\ChatGPT\VPS搭建
SSH key path=C:\Users\34707\.ssh\digitalocean_ed25519
```

Never persist or paste into GitHub/chat:
- numeric Baidu UID;
- portable recovery passphrase;
- SSH private-key contents;
- Baidu cookies/tokens/credentials;
- HY2 auth;
- REALITY private key material.

R11 asks only for the expected Baidu UID through a hidden local prompt. It does not read recovery Secret/DPAPI data.

## 6. Current rollback / network truth

- WireGuard remains the active production/rollback baseline.
- Existing HY2 remains accepted and must be preserved.
- No automatic switching is accepted.
- System proxy and TUN must remain OFF outside bounded tests.
- R5 failed before consequential mutation.
- R9 also reported `CONSEQUENTIAL_MUTATION_STARTED=NO`.
- R10 was fully offline.
- Persistent REALITY service and persistent `SELF-VPN-V1` are not yet accepted.
- R9 pending rollback is non-authoritative for remote cleanliness because it used the pre-R10 parser.
- No live retry is authorized until R11 is reviewed.

## 7. What the next Reviewer must read

Read in this order:

1. `REVIEWER_HANDOFF.md` — canonical dashboard/current Gate.
2. `docs/REVIEWER_TRANSITION_2026-10-05.md` — this R4→R11 chronology.
3. `docs/G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11.md` — exact current Gate.
4. `EXECUTION_EVIDENCE.md` — append-only R5→R10 evidence and formal decisions.
5. `docs/G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10.md` — accepted R10 repair boundary/history.
6. `DECISION_LOG.md` — durable architecture/Owner decisions.
7. Older transition/package docs only when earlier context is actually needed.

Historical `EXECUTOR_HANDOFF.md` cannot override current Reviewer state.

## 8. What must not be repeated

Do not repeat without new Reviewer authorization/evidence:
- R4 repair validation;
- R5 live attempt;
- R6 local P5 diagnostic;
- R7 root-cause diagnostic;
- superseded parser-error diagnostic branches;
- R8 pipeline-output repair validation;
- R9 live retry;
- R10 parser/fixture validation;
- HY2 credential recovery/rotation;
- G4-B0 bypass canary;
- earlier HY2/REALITY compatibility/canary work.

Current unresolved action is **R11 read-only residual-state reconciliation**. G4-C remains separate and pending until G4-B is formally PASS.

## 9. Repository durability

This transition snapshot, R11 Gate/script, accepted R10 runner/validator, Evidence, Handoff and README are on `main`.

No branch-only artifact is required to reconstruct or continue the current accepted project state.
