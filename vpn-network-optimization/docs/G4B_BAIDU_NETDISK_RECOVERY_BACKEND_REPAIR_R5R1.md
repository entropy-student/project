# G4-B Baidu Netdisk Recovery Backend Repair R5R1

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_NETDISK_RECOVERY_BACKEND_REPAIR_R5R1`

## PREVIOUS_RESULT

`RETURN_G4B_R5_EXECUTABLE_DIGEST_RETRIEVAL_BLOCKED_BY_CODEX_POLICY`

## REVIEWER RECONCILIATION

The prior R5 return is accepted as a correct fail-closed result. No runner/validator/runtime mutation
occurred.

Reviewer independently read the upstream GitHub Release API for the exact pinned release:

```text
UPSTREAM_REPO=qjfoidnh/BaiduPCS-Go
UPSTREAM_TAG=v4.0.2
UPSTREAM_TAG_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
UPSTREAM_ASSET_ID=523819947
UPSTREAM_ASSET_NAME=BaiduPCS-Go-v4.0.2-windows-x64.zip
UPSTREAM_ASSET_SIZE=5711812
UPSTREAM_ASSET_SHA256=ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30
```

The official GitHub Release API digest exactly matches the archive digest already pinned by the
runner.

### Supply-chain decision

A separate pre-pinned executable digest is no longer required.

Reason:
- the exact upstream release asset is pinned by authoritative GitHub release identity + SHA-256;
- the runner verifies the full archive SHA-256 before extraction;
- extraction is constrained to exactly one `BaiduPCS-Go.exe` entry with bounded size and
  traversal rejection;
- therefore every byte of the extracted executable is already transitively authenticated by the
  verified archive digest.

An extracted executable SHA-256 may still be computed/emitted as non-secret audit metadata, but it
is not a separate trust anchor and must not block execution merely because an independently sourced
inner digest is unavailable.

Do **not** substitute the GitHub Actions `windows_amd64` artifact digest/executable digest for the
release asset's internal executable identity. Reviewer inspected the upstream CI/build paths and they
are not an authoritative proof that the release ZIP contains byte-identical output.

## OBJECTIVE

Repair only the two remaining confirmed R4/R5 source defects and adjust fixtures/docs to the
transitive archive-pin decision.

## REQUIRED REPAIRS

### R5R1-1 — Use the verified downloaded local archive path

In the default download branch:
- download to the protected local archive path;
- verify exact size bound and SHA-256;
- set/use that local file path for `ZipFile::OpenRead`;
- never pass the HTTPS URL string to `OpenRead`.

The explicit local `BaiduCliArchivePath` override remains supported and must pass the same archive
SHA-256 validation.

### R5R1-2 — Production pending basename must equal remote pending object basename

The production local encrypted portable pending file must use exactly:

```text
vpn-network-optimization-g4b-<runId>.vpr1.pending
```

before directory upload.

Before invoking Baidu upload:
- assert local basename exactly equals the expected remote pending basename;
- mismatch fails before fake/real CLI invocation.

Fixtures must use production naming derivation, not override the local pending path to hide a
mismatch.

## SUPPLY-CHAIN FIXTURE CONTRACT

Required fixed source constants/evidence:

```text
BAIDU_RELEASE_TAG=v4.0.2
BAIDU_RELEASE_TAG_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
BAIDU_RELEASE_ASSET_ID=523819947
BAIDU_RELEASE_ASSET_NAME=BaiduPCS-Go-v4.0.2-windows-x64.zip
BAIDU_RELEASE_ASSET_SIZE=5711812
BAIDU_RELEASE_ARCHIVE_SHA256=ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30
```

Runtime trust remains the exact archive SHA-256 check before extraction. The runner does not need to
query GitHub API live for these metadata fields.

Keep:
- exactly one extracted `BaiduPCS-Go.exe` by basename;
- non-empty bounded entry size;
- traversal rejection;
- Owner-only runtime file ACL;
- optional computed executable SHA-256 as audit metadata only.

## REQUIRED VALIDATION

Run all accepted R1-R4 regressions plus:

```text
R5R1_DEFAULT_DOWNLOAD_USES_LOCAL_ARCHIVE=PASS
R5R1_LOCAL_ARCHIVE_OVERRIDE=PASS
R5R1_OFFICIAL_ARCHIVE_DIGEST_PIN=PASS
R5R1_UNIQUE_SAFE_EXE_ENTRY=PASS
R5R1_PENDING_PRODUCTION_BASENAME=PASS
R5R1_PENDING_BASENAME_MISMATCH_FAILS_PRE_CLI=PASS
R5R1_FAKE_FIXTURE_USES_PRODUCTION_NAMING=PASS
R1_R2_R3_R4_REGRESSIONS=PASS
```

No real Baidu login/API/file operation, Owner auth read, VPS/SSH, Secret, live runner, network,
Clash, service, route, proxy, TUN, or G4-C action.

## ALLOWED FILES

Executor may modify only:
- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:
- `REVIEWER_HANDOFF.md`
- G4-B readiness Gate
- accepted templates
- package validator
- prior historical Evidence.

## TIMING

```text
ESTIMATED_EXECUTION_TIME=15-30 minutes
TIMING_RECORD_REQUIRED=YES
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
```

Capture `ROUND_STARTED_AT` before the first preflight/sync and finish after GitHub fresh read-back.
If actual elapsed exceeds 30 minutes, record a precise cause and append the round to
`docs/ROUND_TIMING_RETROSPECTIVE.md`. If a timing boundary is missed, report `UNKNOWN`.

## ACCEPTANCE

```text
R5R1_ARCHIVE_LOCAL_PATH=PASS
R5R1_PENDING_OBJECT_NAMING=PASS
R5R1_TRANSITIVE_ARCHIVE_PIN=PASS
R1_R2_R3_R4_REGRESSIONS=PASS
REAL_BAIDU_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```
