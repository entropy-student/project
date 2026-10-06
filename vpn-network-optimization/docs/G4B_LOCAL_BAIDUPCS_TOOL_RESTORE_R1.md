# G4-B Local BaiduPCS-Go v4.0.2 Tool Restore R1

Status: OWNER_LOCAL_PREREQUISITE

## GATE_ID

`G4B_LOCAL_BAIDUPCS_TOOL_RESTORE_R1`

## WHY THIS GATE EXISTS

The released read-only reality checkpoint was interrupted before execution because the previously verified local `BaiduPCS-Go.exe` and v4.0.2 archive are no longer present.

Do not force the read-only checkpoint to run without them. That would intentionally produce Provider UNKNOWN and an avoidable `AMBIGUOUS_BASELINE`.

## OBJECTIVE

Reacquire exactly the pinned official Windows x64 BaiduPCS-Go v4.0.2 archive, verify the archive digest, extract it to a dedicated local tools directory outside the repository/runtime/recovery trees, and verify the extracted executable is the exact member contained in the pinned archive.

## PINNED OFFICIAL ASSET

```text
REPOSITORY=qjfoidnh/BaiduPCS-Go
TAG=v4.0.2
ASSET=BaiduPCS-Go-v4.0.2-windows-x64.zip
EXPECTED_ARCHIVE_SHA256=ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30
```

The asset identity was independently read back from the official GitHub release API before this Gate was written.

## AUTHORIZED OWNER ACTIONS

Local Administrator PowerShell may:

- create one dedicated local tools directory outside the project repository;
- download the exact pinned public GitHub release asset;
- compute SHA-256;
- abort and delete the new download if the archive digest mismatches;
- extract only that archive into the dedicated tools directory;
- locate the single `BaiduPCS-Go.exe` member;
- compute and compare the extracted EXE hash against the same archive member;
- print only local paths, sizes, and hashes.

## NOT AUTHORIZED

- do not run BaiduPCS-Go;
- do not read or mutate Baidu account/config/provider state;
- do not SSH/VPS;
- do not touch Clash/WireGuard/routes/services;
- do not run any G4-B live runner;
- do not run cleanup/rollback;
- do not store the binary inside the Git repository or G4-B runtime/recovery directory.

## MAX ENDPOINT

Restore + verify the local public tool only, then STOP_AT_REVIEWER/OWNER checkpoint resume.

## SUCCESS MARKERS

```text
BAIDUPCS_ARCHIVE_SHA256_MATCH=YES
BAIDUPCS_EXE_FOUND=YES
BAIDUPCS_EXE_MATCHES_ARCHIVE_MEMBER=YES
PROVIDER_ACTIONS=0
SSH_VPS_ACTIONS=0
NETWORK_OR_CLASH_MUTATION=NO
```

After these markers are returned, Reviewer may resume the already-approved parent read-only checkpoint using the exact restored paths.
