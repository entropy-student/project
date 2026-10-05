# G4-B Baidu Retained Binary Creation Repair R6R2I-D2

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_RETAINED_BINARY_CREATION_REPAIR_R6R2I_D2`

## PREVIOUS_RESULT

`PASS_R6R2I_D1_RUNTIME_RESIDUE_DIAGNOSTIC`

## ACCEPTED OWNER DIAGNOSTIC

```text
R6R2I_BUILD_DIAG=PASS
R6R2I_RUNTIME_ROOT_STATE=PRESENT_SAFE
R6R2I_RUNTIME_DIR_STATE=PRESENT_SAFE
R6R2I_ADAPTER_BINARY_STATE=ABSENT
R6R2I_ADAPTER_BINARY_IDENTITY=NOT_APPLICABLE
R6R2I_AUTH_CHECKPOINT_STARTED=NO
R6R2I_PROVIDER_AUTH_ACTIONS=0
R6R2I_DIAGNOSTIC_MUTATIONS=0
```

The failed R6R2I attempt left no retained adapter residue and never entered authentication.

## REVIEWER CLASSIFICATION

The build passed Go tests, then returned generic `BUILD_VALIDATION_FAILED` before Owner authentication. Because symbolic Go/native failures would have returned their own bounded code, the remaining fault domain is the retained-binary creation/copy/ACL/readback section.

The current helper creates the file first and then calls `Set-OwnerOnlyAcl`, whose accepted constructor sets Owner explicitly. Earlier offline execution on this Owner environment already showed `SeSecurityPrivilege` is unavailable. This makes the post-create owner/ACL rewrite a plausible cause, but R6R2I-D2 must not claim exact causality unless a non-secret fixture reproduces it.

## OBJECTIVE

Repair only the retained-binary persistence path and its diagnostic precision so a later single Owner build retry can distinguish exact failure stages and does not depend on an unnecessary post-create Owner rewrite.

Do not modify the already accepted adapter/authentication/checkpoint core.

## REQUIRED DESIGN

### 1. Safe file creation

Prefer creating the retained executable with an already-protected Owner-only DACL at file creation time, or an equivalently safe target-compatible method that:

- uses `CreateNew` / fails on existing;
- gives only the current Owner full control;
- disables inherited access rules;
- allows Windows to retain/assign the correct current Owner without a separate owner rewrite when possible;
- immediately proves with the frozen `Assert-OwnerOnlyAcl` invariant;
- never broadens parent/runtime ACLs.

A .NET `FileSystemAclExtensions.Create(FileInfo,...,FileSecurity)`-style approach is acceptable if target-compatible and fixture-proven.

Do not weaken `Assert-OwnerOnlyAcl`.

### 2. Exact retained-binary integrity

After copy/write:

- flush/close the destination;
- strict Owner-only ACL readback;
- exact SHA-256 equality with the freshly built candidate;
- no executable launch in this persistence substep.

### 3. Bounded failure-stage codes

Replace generic ambiguity in the retained-binary section with non-secret symbolic classes at minimum for:

```text
OWNER_RUNTIME_PREPARE_FAILED
RETAINED_BINARY_CREATE_FAILED
RETAINED_BINARY_COPY_FAILED
RETAINED_BINARY_ACL_VERIFY_FAILED
RETAINED_BINARY_HASH_VERIFY_FAILED
```

Do not emit raw exception text, paths, SID/ACL details or stack traces.

A general unexpected exception may still close fail-closed, but the above expected stages must be distinguishable.

### 4. Failure cleanup

If this run created the retained binary and the overall build/validation later fails:

- remove only that exact run-created binary;
- verify absence;
- preserve the already accepted runtime directories;
- never recursively remove the runtime root/directory.

If retained-binary creation never completed, no delete is attempted.

## REQUIRED VALIDATION

Use only non-secret temporary fixture directories/files outside the real Owner runtime path.

At minimum:

```text
R6R2I_D2_R3_AUTH_CORE_FROZEN=PASS
R6R2I_D2_BUILD_DEFAULT_PATH_REGRESSION=PASS
R6R2I_D2_RETAINED_CREATE_NEW_ONLY=PASS
R6R2I_D2_RETAINED_OWNER_ONLY_ACL_AT_OR_BEFORE_FINALIZATION=PASS
R6R2I_D2_NO_POSTCREATE_OWNER_REWRITE_DEPENDENCY=PASS
R6R2I_D2_FROZEN_ASSERT_OWNER_ONLY_ACL_PASS=PASS
R6R2I_D2_RETAINED_HASH_READBACK_PASS=PASS
R6R2I_D2_EXISTING_BINARY_COLLISION_FAILS_CLOSED=PASS
R6R2I_D2_FAILURE_STAGE_CODES_BOUNDED=PASS
R6R2I_D2_FAILED_RUN_EXACT_BINARY_CLEANUP=PASS
R6R2I_D2_RUNTIME_DIRECTORIES_PRESERVED=PASS
R6R2I_D2_NO_REAL_OWNER_RUNTIME_WRITE=PASS
R6R2I_D2_FULL_R6R2H_R3_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_AUTH_ACTIONS=0
OWNER_REAL_CONFIG_ACTIONS=0
PROVIDER_REQUESTS=0
STOP_AT_REVIEWER=YES
```

If the old post-create ACL method can be reproduced as failing with `PrivilegeNotHeldException` on a synthetic temp fixture, record only the exception class/fault stage, not raw ACL/SID/path details. Reproduction is useful but not mandatory for repair acceptance.

## ALLOWED FILES

- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1`
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`
- this Gate if needed for implementation notes;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:

- adapter `main.go`;
- adapter tests;
- Owner auth checkpoint;
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 helpers;
- `REVIEWER_HANDOFF.md`;
- unrelated project files.

## EXECUTOR BOUNDARY

Offline only.

Forbidden:
- real Owner runtime path mutation;
- real Owner config;
- authentication material;
- real provider authentication/who/file operation;
- browser/clipboard access;
- VPS/SSH/Clash/network runtime/live G4-B/G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
