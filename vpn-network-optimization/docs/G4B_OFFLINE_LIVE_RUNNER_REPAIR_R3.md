# G4-B Offline Live-Runner Repair Gate R3

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_OFFLINE_LIVE_RUNNER_REPAIR_R3`

## PREVIOUS_RESULT

`RETURN_G4B_OFFLINE_LIVE_RUNNER_REPAIR_R2_REVIEW_DEFECTS`

## OBJECTIVE

Keep the accepted R2 repairs and fix only the three remaining Reviewer findings before live G4-B
can be considered for authorization.

No live runner execution is authorized in this round.

## ACCEPTED R2 FACTS — DO NOT REPLAY OR REDESIGN

```text
R2_FINAL_MAIN=6eb7b3733eacdab5a09a01310e7f62baa4860e68
R2_RUNNER_BLOB=cc595546e0bad6cb17dc4cac5fea11d82840bb24
R2_FIXTURE_VALIDATOR_BLOB=af01347b126a90eea90247767664991e4cf18044
R2_PACKAGE_DOC_BLOB=8baaa653b14354cb43951fb22aa50881c91f84a5
R2_RECOVERY_PORTABILITY=PASS
R2_RECOVERY_ORDERING=PASS
R2_RUNTIME_FILESYSTEM_CONTRACT=PASS
R2_PROFILE_RESTART_PERSISTENCE=PASS
R2_ROLLBACK_JOURNAL_RETENTION=PASS
R2_SANITIZED_LIVE_EVIDENCE_MARKERS=PASS
R1_REGRESSIONS=PASS
R2_LIVE_ACTIONS=0
R2_TIMING=UNKNOWN_AS_REQUIRED_BY_GATE
```

Preserve the accepted:
- two-artifact pending -> final recovery model;
- VPNG4BP1 PBKDF2/AES-GCM portable recovery;
- dedicated non-root REALITY runtime identity and permissions;
- post-Clash-restart profile semantic read-back;
- retained exact-run rollback journal / rollback / closeout modes;
- sanitized live Evidence markers;
- no route writes, no broad firewall writes, no automatic selector, no G4-C execution.

## REVIEWER FINDING R3-1 — Remote unrelated drift is not actually proven

The frozen G4-B readiness Gate requires:

- preflight read-back of current persistent route/firewall state; and
- final proof of `UNRELATED_DRIFT=NONE`, including no unrelated firewall/route/service drift.

Current remote `probe()` returns only firewall command return codes and no remote route snapshot.
The live runner therefore cannot prove this acceptance criterion even if the deployment succeeds.

### Required repair

Before the first persistent remote mutation, capture in-memory normalized remote baseline data for:

1. IPv4/IPv6 routing state relevant to the host;
2. firewall ruleset state using the available canonical firewall backend(s);
3. active service set or equivalent service-state inventory sufficient to detect unrelated service
   drift.

After restart/final read-back:

- compare routes exactly to the pre-write baseline;
- compare firewall state exactly to the pre-write baseline;
- compare service state with an explicit allowlist for the one newly created project REALITY service
  only;
- WG and HY2 must still retain their accepted identities/states;
- emit only a sanitized `G4B_UNRELATED_REMOTE_DRIFT=NONE` marker, never the raw snapshots.

Rollback post-readback must also prove the remote route/firewall/service baseline returns to the exact
pre-G4B state.

Do not mutate firewall or routes to make this pass.

## REVIEWER FINDING R3-2 — Profile-store integrity proof is weaker than the accepted baseline

Current `Get-ProfileSnapshot` stores only:

`file length | LastWriteTimeUtc ticks`

This can miss a content mutation that preserves length/timestamp and is weaker than the already
accepted C2C profile-store integrity pattern, which used SHA-256 content comparison.

The G4-B Gate requires no unrelated profile mutation and exact bounded rollback.

### Required repair

- restore content-integrity comparison for files in the Clash profile store;
- use a cryptographic digest (SHA-256 is accepted) for in-process comparison;
- if durable rollback journal persistence requires storing the baseline digest, it may remain only
  inside the Owner-only rollback journal; it must never be printed, committed, or copied into
  Handoff/Evidence;
- directories remain represented structurally;
- post-import, post-restart, rollback, and closeout checks must use the stronger baseline;
- add a negative fixture where pre-existing profile content changes while size/timestamp semantics
  would otherwise appear unchanged.

No Secret-bearing profile contents or digests may be emitted.

## REVIEWER FINDING R3-3 — StrictMode can mask a recovery failure

In `Write-EncryptedRecovery`, the `finally` block references:

```text
$localReadback
$externalReadback
$localPayload
$externalPayload
```

without initializing all of them before entering the `try`.

Under `Set-StrictMode -Version Latest`, an earlier failure can therefore be replaced by an
uninitialized-variable exception, causing the runner to lose the actual bounded failure code and
degrade to an unclassified error.

### Required repair

- initialize every cleanup variable to `$null` before the `try`;
- preserve the original classified failure code;
- add an offline negative fixture that injects a failure before those later variables are assigned
  and proves cleanup does not mask the original error class;
- scan the runner's other `finally` blocks for the same StrictMode pattern and repair only real
  instances found.

## ALLOWED FILES

Executor may modify only:

- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md` only if the accepted contract needs a matching
  non-normative implementation note
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md`
- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md`
- all accepted templates
- `scripts/g4b-three-role-package-validator.ps1`
- accepted G4-B0 artifacts/evidence.

If a frozen contract must change, RETURN instead of changing it.

## REQUIRED VALIDATION

Run all accepted R1 + R2 regressions plus new deterministic R3 checks.

Required new checks:

```text
R3_REMOTE_ROUTE_BASELINE_COMPARE=PASS
R3_REMOTE_FIREWALL_BASELINE_COMPARE=PASS
R3_REMOTE_SERVICE_DRIFT_ALLOWLIST=PASS
R3_REMOTE_ROLLBACK_BASELINE_COMPARE=PASS
R3_PROFILE_CONTENT_INTEGRITY=PASS
R3_PROFILE_SAME_SIZE_CONTENT_DRIFT_NEGATIVE=PASS
R3_STRICTMODE_RECOVERY_CLEANUP=PASS
R3_FAILURE_CODE_NOT_MASKED=PASS
R2_REGRESSIONS=PASS
R1_REGRESSIONS=PASS
```

The fixture validator itself must remain offline-only and must not invoke SSH, network, DPAPI real
Secret access, live Mihomo, service/profile mutations, or external HTTP.

## ABSOLUTE PROHIBITIONS THIS ROUND

```text
LIVE_RUNNER_EXECUTION=NO
SSH_OR_VPS_ACTION=NO
REAL_SECRET_ACCESS=NO
DPAPI_REAL_SECRET_ACCESS=NO
EXTERNAL_TEST_REQUESTS=0
NETWORK_MUTATION=NO
CLASH_PROFILE_MUTATION=NO
SYSTEM_PROXY_CHANGE=NO
TUN_CHANGE=NO
SERVICE_MUTATION=NO
ROUTE_MUTATION=NO
REALITY_LIVE_DEPLOYMENT=NO
G4C_EXECUTION=NO
```

## TIMING

Capture the round start before preflight/sync and finish after fresh GitHub read-back.
If either boundary is missed, report `UNKNOWN`; do not fabricate.

## ACCEPTANCE

PASS_CANDIDATE requires all R3 findings repaired, every R1/R2 regression preserved, zero live
actions, canonical GitHub fresh read-back, and `STOP_AT_REVIEWER=YES`.
