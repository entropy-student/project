# G4-B Baidu Netdisk Recovery Backend Integration R4

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_NETDISK_RECOVERY_BACKEND_R4`

## OBJECTIVE

Adapt the already Reviewer-accepted G4-B live runner so that the second-failure-domain portable encrypted recovery artifact can be stored in Baidu Netdisk through a reviewed CLI backend, without weakening the existing recovery, Secret-safety, rollback, or evidence contracts.

## OWNER DECISION

```text
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
LIVE_G4B_AUTHORIZATION=GRANTED
BAIDU_CREDENTIALS_IN_CHAT=FORBIDDEN
ORDINARY_GITHUB_REPOSITORY_RECOVERY_STORAGE=NOT_APPROVED
```

## CURRENT BOUNDARY

This round is offline source/package work only.

Do not:
- log in to Baidu Netdisk;
- read any real Baidu cookie/BDUSS/STOKEN/password;
- upload/download any real file;
- access VPS;
- run the live G4-B runner;
- mutate network/Clash/services/routes.

## REQUIRED DESIGN

Use a reviewed Baidu Netdisk CLI backend that supports Windows and file upload/download.

The runner must:

1. keep the local DPAPI CurrentUser artifact as recovery copy #1;
2. produce the already-accepted portable AES-256-GCM artifact as recovery copy #2;
3. upload only the encrypted portable artifact to Baidu Netdisk;
4. never upload plaintext Secret payloads;
5. never accept Baidu cookie/BDUSS/STOKEN/password as command-line arguments from the runner;
6. require that the Owner has already authenticated the CLI locally before the live Gate;
7. prove authenticated-account readiness through a non-secret account/status command;
8. use a fixed project-owned remote directory, for example `/应用数据/vpn-network-optimization/recovery`;
9. fail closed on an existing conflicting final object unless exact reviewed ownership/version semantics permit replacement;
10. upload a pending encrypted object first;
11. read back/download the pending ciphertext into a protected temporary local path and compare bytes in-process;
12. only after the full G4-B deployment passes, promote/rename/copy to the final cloud object;
13. remove only project-owned pending objects on verified rollback;
14. retain final recovery object on Reviewer-approved PASS/closeout;
15. never print Baidu authentication data, recovery plaintext, ciphertext contents, or Secret-derived hashes;
16. preserve all accepted R1/R2/R3 behavior and negative fixtures.

## CLI SUPPLY-CHAIN REQUIREMENTS

- Pin exact upstream repository/ref/release and binary SHA-256 before live use.
- Prefer a portable executable; no machine-wide install is required.
- Record only version, source URL/ref, binary hash, and non-secret config path.
- CLI config/auth cache is treated as Secret-bearing local state and must stay outside Git/review artifacts.
- If CLI authentication state is missing/expired, live execution stops for Owner local login; the runner must not request the credential in chat or write it into command arguments.

## ALLOWED FILES

Executor may modify only:
- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Executor may add one project-owned helper under `scripts/` only if strictly necessary for the Baidu CLI backend.

Frozen:
- `REVIEWER_HANDOFF.md`
- G4-B readiness Gate
- accepted templates
- G4-B0 artifacts
- existing package validator unless Reviewer explicitly reopens it.

## REQUIRED OFFLINE VALIDATION

- PowerShell AST PASS.
- Existing R1/R2/R3 regressions PASS.
- CLI backend source contract proves no credential command-line flags.
- Synthetic upload/list/download/promote/rollback fixtures use a fake local CLI shim only.
- Pending-before-final ordering PASS.
- Ciphertext round-trip equality PASS.
- Existing-object collision negative fixture PASS.
- Missing-login/readiness negative fixture PASS.
- Wrong-account/readiness shape negative fixture PASS.
- Download/readback mismatch negative fixture PASS.
- Rollback removes pending-only object and preserves final PASS object.
- Secret scan PASS.
- No real network, Baidu login, upload/download, VPS, Secret, Clash, route, proxy or TUN action.

## ACCEPTANCE

```text
R4_BAIDU_BACKEND_SOURCE=PASS
R4_CREDENTIAL_ARGUMENT_EXPOSURE=ABSENT
R4_PENDING_UPLOAD_READBACK=PASS
R4_FINAL_PROMOTION_ORDERING=PASS
R4_ROLLBACK_SCOPE=PASS
R1_R2_R3_REGRESSIONS=PASS
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```
