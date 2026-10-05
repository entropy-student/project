# G4-B Baidu Owner Retained Build Retry R6R2I-D3

Status: ACTIVE / OWNER_LOCAL_BUILD_ONLY / ONE_SHOT

## GATE_ID

`G4B_BAIDU_OWNER_RETAINED_BUILD_RETRY_R6R2I_D3`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_RETAINED_BINARY_CREATION_REPAIR_R6R2I_D2`

## OBJECTIVE

Run exactly one Owner-local retained adapter build using the reviewed D2 build helper. This Gate ends after build/readback and does not run authentication.

## LOCKED SOURCE

```text
D2_SOURCE_COMMIT=02ab19b52ff993a4a66827ad283614f38295f292
BUILD_HELPER_BLOB=62aa2451287cfe7bb5d6e20654a9d371d27d0401
OWNER_CHECKPOINT_BLOB=8d0aded1b49aff58e06f5e7c450b8799737b3b68
ADAPTER_SOURCE_BLOB=6b12287e0744bd9b95e487656b8b048c394965c9
ADAPTER_TEST_BLOB=a1d65216f061ee2d5ee32aefc046f01379d40ca2
EXPECTED_ADAPTER_BINARY_SHA256=9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367
```

## OWNER SHELL

PowerShell 7.6.6, Administrator, High integrity, accepted Windows Owner host.

## PRECONDITION

The accepted D1 diagnostic proved:
- runtime root present safe;
- runtime directory present safe;
- retained adapter absent;
- authentication checkpoint did not start;
- provider auth actions = 0.

If the retained adapter exists before this run, stop; do not overwrite or delete it.

## ACTION

Run the D2-reviewed build helper once with `-RetainBinary`.

Do not invoke the Owner authentication checkpoint in this Gate.

## SUCCESS CONTRACT

Success requires these bounded markers:

```text
UPSTREAM_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
GO_VERSION=go1.27.1
GO_TOOLCHAIN_SHA256=a3911b5e0e1b1053f25ed0675f4c1c6aad1e2bfcf253df2b9be4caabd2edd95d
BUILD_TARGET=windows/amd64
ADAPTER_BINARY_SHA256=9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367
OWNER_RUNTIME_BINARY=CREATED
GO_SOURCE_TESTS=PASS
NATIVE_FAILURE_EXIT_FIXTURE=PASS
TEMP_BUILD_CLEANUP=PASS
```

No authentication prompt is expected.

## FAILURE CONTRACT

If the build returns `BUILD_VALIDATION=FAIL_CLOSED`:

- stop;
- do not rerun;
- return the bounded `FAILURE_CODE`, temp cleanup marker, and retained-binary cleanup marker if emitted;
- do not run authentication.

## FORBIDDEN

- authentication checkpoint;
- authentication material;
- provider auth/who/file actions;
- manual runtime ACL/file repair;
- overwrite/delete of pre-existing retained binary;
- VPS/SSH/Clash/live G4-B/G4-C.

## OWNER RETURN

Return only the bounded build result markers. Do not include local paths or unrelated console output.

`STOP_AT_REVIEWER=YES`
