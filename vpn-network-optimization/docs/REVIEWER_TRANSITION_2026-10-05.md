# Reviewer Transition — 2026-10-05 — G4-B R9 Live Retry Ready

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
STATE=OWNER_ACTION_REQUIRED_LIVE_RETRY_R6R2L_R9
GATE_ID=G4B_PERSISTENT_THREE_ROLE_LIVE_RETRY_R6R2L_R9
PREVIOUS_RESULT=PASS_R6R2L_R8_BAIDU_PIPELINE_OUTPUT_REPAIR
```

Locked identities:

```text
R9_GATE_BLOB=b81b39da7468d39b6901a4bc9017d136d7527c24
R9_RUNNER_BLOB=388714218a7a6f1671777488b0c581812f6cc9eb
R9_VALIDATOR_BLOB=eac0f9684b8f98b71c856e4d297da03f867b2d51
```

Authorization state:

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
FRESH_REAUTH_REQUIRED=NO
```

Reason fresh authorization is not required: the prior R5 live attempt failed with `CONSEQUENTIAL_MUTATION_STARTED=NO`, and the only accepted live-runner code change since R5 is a one-line safety repair suppressing unintended PowerShell success-stream output.

## 3. R4 -> R9 chronology

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

### R9 — current one-shot live retry — READY, NOT YET EXECUTED

Current Gate:

`docs/G4B_PERSISTENT_THREE_ROLE_LIVE_RETRY_R6R2L_R9.md`

R9 may:
- verify the approved Baidu second failure domain;
- create and validate encrypted recovery artifacts;
- create the project-owned persistent REALITY service;
- create/import exactly one `SELF-VPN-V1` Clash profile without activating it;
- verify restart persistence and final baselines.

R9 does not authorize:
- production-role activation;
- automatic switching;
- G4-C workloads/benchmarks;
- leaving system proxy or TUN enabled;
- broad rollback/cleanup.

## 4. R9 Owner interaction

Owner environment:

```text
PowerShell=7.6.6
Administrator=YES
HighIntegrity=YES
RepoRoot=C:\Users\34707\Documents\ChatGPT\VPS搭建
SSH key path=C:\Users\34707\.ssh\digitalocean_ed25519
```

Owner-local inputs must never be persisted to GitHub/chat:
- numeric Baidu UID;
- portable recovery passphrase;
- SSH key contents;
- Baidu credentials/cookies;
- HY2 auth;
- REALITY private material.

The R9 runner may require two interactions:

1. Hidden portable recovery passphrase, minimum 16 characters.
2. P10 `OWNER_UI_IMPORT_PATH=...`: import only the generated `SELF-VPN-V1` profile into Clash Verge, confirm visible, do not activate/switch it, leave active profile unchanged, system proxy OFF, TUN OFF, then enter exactly the acknowledgement requested by the runner.

Any failure or ambiguity: stop. Do not replay R9 until Reviewer reconciliation.

## 5. R9 success contract

The expected terminal success markers include:

```text
G4B_RECOVERY_PENDING_VERIFIED=YES
G4B_REALITY_RUNTIME_ACCESS=PASS
G4B_THREE_ROLE_PROFILE_RESTART_PERSISTENCE=PASS
G4B_UNRELATED_REMOTE_DRIFT=NONE
BAIDU_RUNTIME_CLEANUP=PASS
G4B_RECOVERY_FINAL_PROMOTED=YES
G4B_RECOVERY_PORTABLE_FORMAT=VPNG4BP1
G4B_REALITY_SERVICE_READY=YES
G4B_PUBLIC_TCP443_READY=YES
G4B_THREE_ROLE_PROFILE_IMPORTED=YES
G4B_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2
G4B_AUTO_SWITCHING=OFF
G4B_WIREGUARD_PRESERVED=YES
G4B_HY2_PRESERVED=YES
G4B_SYSTEM_PROXY_FINAL=OFF
G4B_TUN_FINAL=OFF
G4B_ROLLBACK_JOURNAL_RETAINED=YES
SECRET_VALUES_EMITTED=0
G4B_PERSISTENT_THREE_ROLE_RUNNER=PASS_CANDIDATE
STOP_AT_REVIEWER=YES
```

`PASS_CANDIDATE` is not formal PASS. Reviewer must inspect the full sanitized evidence before accepting G4-B.

## 6. Rollback/current network truth

- WireGuard remains the active production/rollback baseline.
- Existing HY2 must remain preserved.
- No automatic switching is accepted.
- G4-B must end with system proxy OFF and TUN OFF.
- Prior R5 failed before consequential mutation.
- R6 confirmed post-failure local runtime cleanup.
- R8 was offline only; it performed no external/network/runtime mutation.
- Persistent REALITY and persistent `SELF-VPN-V1` are not accepted until R9 succeeds and Reviewer formally accepts the evidence.

## 7. What the next Reviewer must read

Read in this order:

1. `REVIEWER_HANDOFF.md` — current canonical dashboard and active Gate.
2. `docs/REVIEWER_TRANSITION_2026-10-05.md` — this transition snapshot and R4-R9 chronology.
3. `docs/G4B_PERSISTENT_THREE_ROLE_LIVE_RETRY_R6R2L_R9.md` — exact current live Gate.
4. `EXECUTION_EVIDENCE.md` — relevant R5/R6/R7/R8 accepted evidence; append-only.
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
- HY2 credential recovery/rotation;
- G4-B0 bypass validation;
- earlier HY2/REALITY compatibility/canary work.

The next unresolved action is R9 one-shot live retry, followed by Reviewer reconciliation. G4-C remains separate and pending after G4-B formal acceptance.

## 9. Repository durability

This transition, the current R9 Gate, the repaired runner/validator, Evidence, and Handoff are all intended to be on `main`.

No branch-only document is required to reconstruct or continue the current accepted project state.
