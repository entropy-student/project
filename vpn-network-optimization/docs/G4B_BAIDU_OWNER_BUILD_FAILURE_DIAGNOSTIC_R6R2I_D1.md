# G4-B Baidu Owner Build Failure Diagnostic R6R2I-D1

Status: ACTIVE / OWNER_READ_ONLY_DIAGNOSTIC

## GATE_ID

`G4B_BAIDU_OWNER_BUILD_FAILURE_DIAGNOSTIC_R6R2I_D1`

## PREVIOUS_RESULT

`RETURN_R6R2I_BUILD_VALIDATION_FAILED_BEFORE_AUTH`

## OBJECTIVE

Classify the failed retained-adapter build attempt without replaying build or authentication.

## ACCEPTED FACTS

From the Owner run:

- pinned source checkout started;
- public Go modules downloaded;
- adapter Go tests passed;
- build helper returned `BUILD_VALIDATION=FAIL_CLOSED`;
- failure code was generic `BUILD_VALIDATION_FAILED`;
- temporary build cleanup passed;
- the wrapper stopped before the Owner authentication checkpoint;
- no authentication prompt was reached.

## DIAGNOSTIC BOUNDARY

Read-only on the Owner host.

Inspect only metadata for:

- project runtime root;
- runtime subdirectory;
- retained adapter binary path;
- if the binary exists: regular/reparse shape, Owner/ACL metadata, and equality to the reviewed binary digest.

Do not read file content except the non-secret executable hash comparison.

Do not build, authenticate, modify ACLs, create/delete files or directories, run provider commands, or retry.

## REQUIRED OUTPUT

Return only:

```text
R6R2I_BUILD_DIAG=...
R6R2I_RUNTIME_ROOT_STATE=...
R6R2I_RUNTIME_DIR_STATE=...
R6R2I_ADAPTER_BINARY_STATE=...
R6R2I_ADAPTER_BINARY_IDENTITY=...
R6R2I_AUTH_CHECKPOINT_STARTED=NO
R6R2I_PROVIDER_AUTH_ACTIONS=0
R6R2I_DIAGNOSTIC_MUTATIONS=0
```

Allowed state values:
- root/dir: `ABSENT | PRESENT_SAFE | PRESENT_UNSAFE | QUERY_FAILED`
- binary: `ABSENT | PRESENT_SAFE | PRESENT_UNSAFE | QUERY_FAILED`
- binary identity: `NOT_APPLICABLE | MATCH | MISMATCH | QUERY_FAILED`

No local paths, SID values, ACL detail, provider output, or authentication material.

## STOP

`STOP_AT_REVIEWER=YES`
