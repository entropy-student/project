# Reviewer Transition — 2026-10-05 — G4-B R10 Baidu Listing Parser Repair

> Purpose: durable handoff for the next Reviewer. This document is a transition snapshot, not a replacement for `REVIEWER_HANDOFF.md`. Current authority remains `REVIEWER_HANDOFF.md`.

## 1. Current project position

Project: `vpn-network-optimization`

Target v1 role order is frozen by Owner:

```text
HY2-SFO3      PRIMARY
WG-BASELINE   BACKUP_1
REALITY-SFO3  BACKUP_2
AUTO_SWITCHING=OFF
```

Current production/rollback baseline remains WireGuard. No final production-role switch has been accepted yet.

Current stage:

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

## 2. Current canonical Reviewer state

As of this transition snapshot, the active Gate is:

```text
STATE=OWNER_ACTION_REQUIRED_BAIDU_REAL_LS_PARSER_OFFLINE_VALIDATION_R6R2L_R10
GATE_ID=G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10
PREVIOUS_RESULT=RETURN_R6R2L_R9_BAIDU_REAL_LS_FORMAT_PARSER_DRIFT
```

Locked identities:

```text
R10_GATE_BLOB=86fd201aa368ab1fd45b5e2f83e5c64f993ba3e2
R10_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
R10_VALIDATOR_BLOB=aa8a6db471b83de173c02ae2956719d1ebfdef4b
```

Authorization state:

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
FRESH_REAUTH_REQUIRED=NO
```

R10 is offline-only and does not consume or extend live authorization. Existing bounded G4-B live authorization remains recorded, but no live retry is currently authorized. R9 has already executed once and must not be replayed.

## 3. R4 -> R10 chronology

### R4 — offline repair validation — PASS

R4 proved the prior canonical Git/CRLF/validator repair chain. It became the prerequisite for the first G4-B live attempt.

Accepted R4 identities:

```text
RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
```

### R5 — first live G4-B attempt — RETURN

Owner ran the bounded one-shot live Gate. It reached:

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=UNCLASSIFIED
CONSEQUENTIAL_MUTATION_STARTED=NO
STOP_AT_REVIEWER=YES
```

No persistent VPS REALITY/service mutation began.

### R6 — local P5 diagnostic — PASS

Owner-local diagnostic proved the local non-Baidu P5 chain:

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

This excluded local DPAPI/HY2/Mihomo as the R5 cause.

### R7 — Baidu read-only diagnostic — root cause identified

R7 reproduced:

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

Source inspection found the same defect in the live runner and diagnostic:

```powershell
$psi.Environment.Remove([string]$key)
```

`Remove()` returns a Boolean. Because the return value was not suppressed, PowerShell emitted Boolean values into the function success stream before the final process result object. Under StrictMode, downstream member access such as `$result.StdOut` / `$who.ExitCode` could hit the Boolean value and raise `PropertyNotFoundException`.

This exactly explains the R5 outer `UNCLASSIFIED`.

Root cause is an implementation defect, not a Baidu login/UID/network/output-format failure.

### Superseded diagnostic parser branch

A later read-only diagnostic repair branch contained a parser error around its Baidu `ls` regex. It failed at parse time before any diagnostic body ran.

That branch is explicitly superseded and must not be repaired or rerun. The stronger root-cause path above is canonical.

### R8 — Baidu pipeline-output repair — PASS

Accepted live-runner repair:

```powershell
[void]$psi.Environment.Remove([string]$key)
```

Reviewer independently compared the previously authorized R5 runner with the repaired runner. The live runner differs by exactly one line: the `[void]` suppression above. No other live behavior changed.

R8 offline validation passed:

```text
G4B_FIXTURE_R6R2L_R8_BAIDU_ENV_REMOVE_OUTPUT_SUPPRESSED=PASS
G4B_FIXTURE_NEGATIVE_BAIDU_ENV_REMOVE_STREAM_POLLUTION=PASS
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

Formal Reviewer result:

```text
PASS_R6R2L_R8_BAIDU_PIPELINE_OUTPUT_REPAIR
```

### R9 — one-shot live retry — RETURN

R9 executed exactly once. It passed source/gate/authorization preflight and reached the real Baidu pending-upload readback boundary.

```text
RUNNER_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
BAIDU_CLI_VERSION=v4.0.2
FAILURE_CODE=BAIDU_PENDING_UPLOAD_NOT_PRESENT
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
STOP_AT_REVIEWER=YES
```

Reviewer did not authorize a replay.

Source reconciliation against upstream BaiduPCS-Go v4.0.2 then proved the pre-R10 production parser/fixture was wrong:
- `pcstable.NewTable()` sets `Border=false`, `HeaderLine=false`, and an empty column separator;
- detailed `ls -l` renders the filename as the final column and directories as `filename/`;
- the pre-R10 runner matched only lines beginning with ASCII `|`;
- the fake CLI fixture also synthesized pipe-delimited rows, so it masked the provider-format drift;
- upstream upload code still confirms the remote path is target directory plus local basename.

Therefore R9 is reconciled as a **real listing parser / fixture-drift defect**, not as proof that Baidu upload or account authentication failed.

### R10 — current offline parser/fixture repair — READY FOR VALIDATION

Current Gate:

`docs/G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10.md`

R10 changes only source/fixtures:
- remote-object parser matches an exact basename in the final `ls -l` field without requiring border pipes;
- directory trailing slash remains semantically distinct;
- fake Baidu `ls` output models the real borderless provider format;
- positive FILE/DIRECTORY/exact-basename fixtures are added;
- a negative regression fixture rejects reintroduction of the pipe-only parser.

R10 is offline-only. No Baidu API/file operation, SSH/VPS action, DPAPI/real Secret access, recovery/profile/service/network mutation or G4-C is authorized.

## 4. Owner environment and Secret rules

Owner environment remains:

```text
PowerShell=7.6.6
Administrator=YES
HighIntegrity=YES
RepoRoot=C:\Users\34707\Documents\ChatGPT\VPS搭建
SSH key path=C:\Users\34707\.ssh\digitalocean_ed25519
```

Secret values must never be persisted to GitHub/chat:
- numeric Baidu UID;
- portable recovery passphrase;
- SSH key contents;
- Baidu credentials/cookies;
- HY2 auth;
- REALITY private material.

No Owner Secret input is required for R10 offline validation.

## 5. R10 required validation

Required R10 markers include:

```text
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
STOP_AT_REVIEWER=YES
```

## 6. Rollback/current network truth

- WireGuard remains the active production/rollback baseline.
- Existing HY2 must remain preserved.
- No automatic switching is accepted.
- G4-B must end with system proxy OFF and TUN OFF.
- R5 failed before consequential mutation.
- R6 confirmed post-failure local runtime cleanup.
- R8 was offline only and repaired the success-stream defect.
- R9 executed once, failed in P5 with `CONSEQUENTIAL_MUTATION_STARTED=NO`, and reported bounded rollback PASS.
- R10 is source-only/offline; no live retry is authorized.
- Persistent REALITY and persistent `SELF-VPN-V1` remain unaccepted.

## 7. What the next Reviewer must read

Read in this order:

1. `REVIEWER_HANDOFF.md` — current canonical dashboard and active Gate.
2. `docs/REVIEWER_TRANSITION_2026-10-05.md` — this transition snapshot and R4-R10 chronology.
3. `docs/G4B_BAIDU_REAL_LISTING_PARSER_REPAIR_R6R2L_R10.md` — exact current offline repair Gate.
4. `EXECUTION_EVIDENCE.md` — relevant R5-R9 accepted/returned evidence; append-only.
5. `DECISION_LOG.md` — durable architecture/Owner decisions.
6. Only then read older transition/package docs as needed.

Historical `EXECUTOR_HANDOFF.md` is not allowed to override current Reviewer state.

## 8. What the next Reviewer must not redo

Do not repeat without new evidence:
- R4 canonical Git/CRLF repair validation;
- R5 live attempt;
- R6 local P5 diagnostic;
- R7 Baidu root-cause diagnostic;
- superseded parser-error diagnostic branch;
- R8 pipeline-output offline validation;
- R9 live retry (already consumed once; do not replay);
- HY2 credential recovery/rotation;
- G4-B0 bypass validation;
- earlier HY2/REALITY compatibility/canary work.

The next unresolved action is R10 offline parser/fixture validation. Only after formal R10 acceptance may a new live retry Gate be designed. G4-C remains separate and pending after G4-B formal acceptance.

## 9. Repository durability

This transition, the current R10 Gate, repaired runner/validator, Evidence, and Handoff are all on `main`.

No branch-only document is required to reconstruct or continue the current accepted project state.
