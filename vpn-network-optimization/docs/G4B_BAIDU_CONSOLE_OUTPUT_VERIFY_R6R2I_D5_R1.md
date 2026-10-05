# G4-B Baidu Console Output Verification R6R2I-D5-R1

Status: ACTIVE / EXECUTOR_PINNED_PUBLIC_BUILD_VERIFY

## GATE_ID

`G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1`

## PREVIOUS_RESULT

`RETURN_R6R2I_D5_GO_SOURCE_TESTS_UNAVAILABLE`

## ACCEPTED / FROZEN FROM D5

The D5 source repair is accepted pending compiled verification:

- adapter status writes were removed and only those fixed output lines changed;
- hidden local prompt and `terminal.ReadPassword` remain;
- parse/setup/save semantics remain frozen;
- `main()` still exits with `run()` native status;
- Owner checkpoint remains unchanged and retains the exact eight-marker contract;
- build helper changed only its synthetic native-failure expectation so child status text must be absent.

No source redesign is authorized in this Gate unless compiled verification finds a real defect.

## OBJECTIVE

Obtain the missing Go/native evidence for the already-reviewed D5 candidate without touching real Owner runtime, authenticated config, or provider state.

## AUTHORIZED NETWORK

Public build inputs only, exactly as pinned by the existing build helper:

- pinned BaiduPCS-Go v4.0.2 / commit `225bdd3b6cb298601c4d5ef7104c3e08cd1d692d`;
- official Go `go1.27.1.windows-amd64.zip` with the existing pinned SHA-256;
- public modules resolved strictly from the pinned `go.sum` / readonly module mode.

Forbidden network:
- Baidu provider authentication/API;
- any provider file operation;
- VPS/SSH/Clash/live G4-B/G4-C.

## REQUIRED EXECUTION

1. Fresh-sync current `main`.
2. Confirm current candidate identities:
   - adapter source blob `1bf6ec1f1ec98e84bd8db965802de2875104cce6`;
   - adapter test blob `a1d65216f061ee2d5ee32aefc046f01379d40ca2`;
   - build helper blob `61f9b283ee073cd00adac42676cc4e90c83fb1e1`;
   - validator blob `b0949461460afd9ebe6ca491d45e9aa5d579f465`.
3. Run the build helper **without** `-RetainBinary`.
4. The helper must:
   - verify pinned upstream/toolchain identities;
   - run Go source tests;
   - build the Windows/amd64 adapter;
   - run the synthetic invalid-argument native fixture;
   - prove native exit is nonzero;
   - prove child output contains no `BAIDU_COOKIE_AUTH` status marker;
   - clean the temporary build workspace.
5. Run the full current offline validator afterward.
6. Do not create, replace, read, hash, or delete the real retained Owner runtime binary.
7. Do not read/write the accepted authenticated config.

## REQUIRED PASS EVIDENCE

At minimum:

```text
R6R2I_D5_R1_SOURCE_IDENTITIES=PASS
UPSTREAM_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
GO_VERSION=go1.27.1
GO_TOOLCHAIN_SHA256=a3911b5e0e1b1053f25ed0675f4c1c6aad1e2bfcf253df2b9be4caabd2edd95d
BUILD_TARGET=windows/amd64
ADAPTER_BINARY_SHA256=<current D5 build digest>
GO_SOURCE_TESTS=PASS
NATIVE_FAILURE_EXIT_FIXTURE=PASS
R6R2I_D5_R1_CHILD_STATUS_OUTPUT_ABSENT=PASS
TEMP_BUILD_CLEANUP=PASS
R6R2I_D5_R1_FULL_VALIDATOR=PASS
SECRET_SCAN=PASS
REAL_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
OWNER_RUNTIME_BINARY_ACCESSED=NO
PROVIDER_REQUESTS=0
STOP_AT_REVIEWER=YES
```

Do not claim D5 PASS if Go tests or the compiled native fixture are not actually executed.

## ALLOWED FILES

No source change is expected.

Allowed only for result recording unless compiled verification reveals a real defect:
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`;
- this Gate for implementation note only.

If compiled verification reveals a source defect, stop with a precise RETURN instead of silently editing code.

Frozen:
- adapter source/tests;
- Owner checkpoint;
- build helper;
- validator;
- authenticated Owner config;
- retained Owner runtime binary;
- `REVIEWER_HANDOFF.md`;
- unrelated files.

## STOP

`STOP_AT_REVIEWER=YES`
