# G4-B Baidu Netdisk Recovery Backend Repair R5

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_NETDISK_RECOVERY_BACKEND_REPAIR_R5`

## PREVIOUS_RESULT

`RETURN_G4B_BAIDU_RECOVERY_BACKEND_R4_REVIEW_DEFECTS`

## OBJECTIVE

Repair three Reviewer-confirmed defects in the R4 Baidu Netdisk backend while preserving every
accepted R1-R3 G4-B contract and all valid R4 credential-safety/recovery-ordering work.

No real Baidu login/upload/download and no live G4-B execution are authorized in this round.

## ACCEPTED R4 FACTS

```text
R4_FINAL_MAIN=79c10bf54902ce337796ba6329e7911a838b4d1c
R4_RUNNER_BLOB=8bbdfc77b44cec61e92fcbdf67fd1b2ba1f1bb9d
R4_FIXTURE_VALIDATOR_BLOB=8bbfed541b7f9e9f3ce216c7e25692cd61269394
R4_PACKAGE_BLOB=52dad7f05e13c3a8efa2960d74e0ffb9b81fe1e2
R4_CREDENTIAL_ARGUMENT_EXPOSURE=ABSENT
R4_ACCOUNT_READINESS_SYNTHETIC=PASS
R4_PENDING_READBACK_CRYPTO_VALIDATION=PASS_SYNTHETIC
R4_PROMOTION_ORDERING=PASS_SYNTHETIC
R4_ROLLBACK_PENDING_ONLY=PASS_SYNTHETIC
R1_R2_R3_REGRESSIONS=PASS
R4_LIVE_ACTIONS=0
```

## REVIEWER FINDING R5-1 — Downloaded release archive is opened via URL instead of local file

In `Install-PinnedBaiduCli`:

- `$archiveSource` starts as the HTTPS release URL;
- the no-`BaiduCliArchivePath` branch downloads the ZIP to the protected local `$archive` path;
- but `$archiveSource` is not changed to that local path before
  `[IO.Compression.ZipFile]::OpenRead($archiveSource)`.

A real live run using the default download path would therefore try to open an HTTPS URL as a local
ZIP path and fail before Baidu readiness.

### Required repair

- after verified download, set/use the protected local archive path for ZIP extraction;
- local-archive override path must continue to work;
- add fixture coverage for both default-downloaded-local-path selection and explicit local archive path;
- no real Baidu API call is needed.

## REVIEWER FINDING R5-2 — Production pending local filename does not match expected remote object name

Production initialization currently sets:

```text
LOCAL_PENDING_BASENAME=reality-g4b.dpapi.<run>.vpr1.pending
EXPECTED_REMOTE_BASENAME=vpn-network-optimization-g4b-<run>.vpr1.pending
```

The upload command uploads the local file into a remote directory. The R4 fake CLI correctly models
directory upload using the local basename, but the R4 fixture overrides
`recoveryPendingCloudLocal` so its basename already equals the expected remote basename. This masks
the production mismatch.

### Required repair

- make the production local encrypted portable pending file basename exactly equal to the expected
  remote pending object basename; or use an explicitly reviewed CLI operation that names the exact
  destination object if upstream semantics prove it;
- prefer basename alignment because it is simple and fail-closed;
- `Invoke-BaiduCli upload` must positively assert the local basename equals the expected pending
  remote basename before invoking the CLI;
- fixtures must use the production naming derivation rather than silently overriding it;
- add a negative fixture where local/remote basenames differ and prove upload is rejected before the
  fake CLI is invoked.

## REVIEWER FINDING R5-3 — Exact executable SHA-256 is not pinned before live use

The active R4 Gate requires exact upstream repo/ref/release **and binary SHA-256** before live use.

R4 pins the release ZIP SHA-256, but the extracted executable SHA-256 is only calculated at runtime
and printed as metadata. There is no fixed expected executable digest and no equality assertion.

### Required repair

- obtain the exact `BaiduPCS-Go.exe` SHA-256 from the already pinned v4.0.2 Windows x64 archive;
- persist it as a fixed reviewed constant;
- after extraction, require exact equality to that fixed executable digest before any CLI invocation;
- keep the release archive SHA-256 check as a second supply-chain check;
- fixture validator must fail if either expected archive hash or expected executable hash is removed
  or changed from the reviewed source contract.

A public upstream GitHub release-asset download/read may be used in this offline engineering round
solely to derive/verify the fixed executable digest. Do not contact Baidu APIs or use Owner auth.

## GOVERNANCE METADATA CORRECTION

Current canonical Governance is `v0.2.7 / ACTIVE_PROVISIONAL`.

R4 Evidence recorded `v0.2.6`. Treat this as stale execution metadata, not authority. R5 must append
a correction in new Evidence; do not rewrite historical R4 Evidence.

## ALLOWED FILES

Executor may modify only:

- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md`
- accepted G4-B templates
- accepted R1-R3 records
- `scripts/g4b-three-role-package-validator.ps1`

## REQUIRED OFFLINE VALIDATION

In addition to all R1-R4 regressions:

```text
R5_DEFAULT_ARCHIVE_LOCAL_PATH=PASS
R5_EXPLICIT_ARCHIVE_LOCAL_PATH=PASS
R5_ARCHIVE_SHA256_PIN=PASS
R5_EXECUTABLE_SHA256_PIN=PASS
R5_EXECUTABLE_SHA256_MISMATCH_NEGATIVE=PASS
R5_PENDING_LOCAL_REMOTE_BASENAME_MATCH=PASS
R5_PENDING_BASENAME_MISMATCH_NEGATIVE=PASS
R5_FAKE_UPLOAD_USES_REAL_BASENAME_SEMANTICS=PASS
R1_R2_R3_R4_REGRESSIONS=PASS
```

The negative basename fixture must prove the fake CLI was not invoked after the local/remote-name
guard failed.

## ABSOLUTE PROHIBITIONS THIS ROUND

```text
REAL_BAIDU_LOGIN=NO
REAL_BAIDU_API_OR_FILE_OPERATION=NO
OWNER_BAIDU_AUTH_READ=NO
LIVE_RUNNER_EXECUTION=NO
SSH_OR_VPS_ACTION=NO
REAL_SECRET_ACCESS=NO
NETWORK_RUNTIME_MUTATION=NO
CLASH_PROFILE_MUTATION=NO
SYSTEM_PROXY_CHANGE=NO
TUN_CHANGE=NO
SERVICE_MUTATION=NO
ROUTE_MUTATION=NO
G4C_EXECUTION=NO
```

Public read-only GitHub release-asset retrieval for supply-chain hash derivation is the only newly
allowed external read.

## TIMING

```text
ESTIMATED_EXECUTION_TIME=20-35 minutes
TIMING_RECORD_REQUIRED=YES
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
```

Reviewer estimate basis: this is a narrow three-defect repair on an already-implemented backend,
but it still requires supply-chain digest derivation, source edits, new negative fixtures, full
R1-R4 regression, Git persistence, and fresh read-back.

Capture `ROUND_STARTED_AT` before preflight/sync and `ROUND_FINISHED_AT` after fresh GitHub
read-back. Record `ACTUAL_ELAPSED` and `TIME_OVERRUN`.

If actual elapsed exceeds 35 minutes, record a precise `TIME_OVERRUN_CAUSE` from Evidence and append
the round to `docs/ROUND_TIMING_RETROSPECTIVE.md`. If timing boundaries are missed, record
`UNKNOWN`; do not reconstruct them.

## ACCEPTANCE

```text
R5_ARCHIVE_SOURCE_PATH_REPAIR=PASS
R5_PENDING_OBJECT_NAMING=PASS
R5_EXECUTABLE_DIGEST_PIN=PASS
R1_R2_R3_R4_REGRESSIONS=PASS
REAL_BAIDU_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```
