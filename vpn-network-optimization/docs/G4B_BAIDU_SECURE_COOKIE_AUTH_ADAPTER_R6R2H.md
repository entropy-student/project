# G4-B Baidu Secure Cookie Auth Adapter R6R2H

Status: ACTIVE / EXECUTOR_BUILD_AND_OFFLINE_VALIDATE

## GATE_ID

`G4B_BAIDU_SECURE_COOKIE_AUTH_ADAPTER_R6R2H`

## PREVIOUS_RESULT

`RETURN_R6R2G_DEPRECATED_INTERACTIVE_LOGIN_50052_EXIT_ZERO`

## OWNER RESULT

The single authorized R6R2G attempt returned:

```text
PROVIDER_VISIBLE_ERROR=50052
PROVIDER_VISIBLE_MESSAGE_CLASS=SYSTEM_BUSY
BAIDU_INTERACTIVE_AUTH=FAIL_CLOSED
BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=BAIDU_AUTH_WHO_OUTPUT_AMBIGUOUS
BAIDU_INTERACTIVE_AUTH_CONFIG_STATE=NEW_INITIALIZED
BAIDU_INTERACTIVE_AUTH_CONFIG_DISPOSITION=REMOVED_NEW_FILE_AND_DIRECTORY
BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=PASS
BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO
BAIDU_WHO_RAW_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
```

The repaired helper fully rolled back this failed attempt. No Baidu config residue remains from R6R2G.

## REVIEWER SOURCE FINDINGS

Pinned upstream:

```text
UPSTREAM_REPO=qjfoidnh/BaiduPCS-Go
UPSTREAM_TAG=v4.0.2
UPSTREAM_TAG_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
UPSTREAM_README_BLOB=0d07b9b27b989319a65c3c8979d896e02cabc340
UPSTREAM_MAIN_GO_BLOB=ac5ace05fc860bc3f47fdaf9ddec126d06890630
UPSTREAM_LOGIN_GO_BLOB=8865962ac126053632beee750310b099e6b89e1d
UPSTREAM_PCSCONFIG_GO_BLOB=2ab8f56647d70a903786db351c57308ee8bee69d
UPSTREAM_MANIPER_GO_BLOB=edefc8e422dc15938668935de06c4da34c377cbe
```

Reviewer verified:

1. Upstream documentation marks username/password interactive `login` as long-unmaintained and recommends alternate auth.
2. Upstream maintainer explicitly stated on 2026-06-18 for issue #526: username/password login is no longer maintained.
3. Upstream recommends Cookies and also supports BDUSS/STOKEN auth.
4. Standard `login -cookies=...` and `login -bduss=...` put Secret material in process arguments and remain forbidden by this project's Secret boundary.
5. `main.go`'s login action returns the `RunLogin` error, but top-level `main` calls `app.Run(os.Args)` without propagating the returned error to the OS exit code. Therefore a visible 50052 can coexist with process exit 0; native exit alone is not a valid semantic-success signal for the stock username/password path.
6. `SetupUserByBDUSS` accepts a full Cookie string and performs the supported user setup path, but expects a BDUSS field and must not receive malformed Cookie input.

The username/password interactive path is retired for this project. Do not repair or retry it.

## OBJECTIVE

Build and offline-validate a minimal credential-safe Owner-local Cookie authentication adapter derived from the exact pinned v4.0.2 source, without ever placing Cookie/BDUSS/STOKEN values in:

- command-line arguments;
- environment variables;
- clipboard automation;
- command history;
- GitHub;
- logs/transcripts;
- ordinary stdout/stderr.

No real Cookie value, Owner config, or Baidu authentication action is allowed in this Executor round.

## DESIGN REQUIREMENT

Preferred architecture:

- checkout/copy the exact pinned upstream source at the locked commit into a bounded temporary build workspace;
- add a minimal dedicated command/program under that source tree so it can legally reuse upstream `internal/pcsconfig`;
- read one full Cookie string from the Owner's live console with **no echo** and without command-history persistence;
- reject empty input and CR/LF-containing input;
- validate only structure needed before calling upstream setup (at minimum an exact `BDUSS=...;` field shape); do not print or hash the Secret;
- call upstream `pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie)` directly;
- persist through the upstream config save path only on successful setup;
- never print account name, UID, Cookie, BDUSS/STOKEN, provider raw response, or Secret-derived hash;
- return explicit bounded success/failure markers and a reliable nonzero native exit on failure;
- clear mutable byte buffers where practical and let process exit destroy remaining ephemeral memory;
- use the existing reviewed Owner-only config ACL/location boundary before and after authentication;
- after successful adapter exit, later Owner orchestration may run exactly one captured read-only `who` for identity proof. That real run is **not** part of R6R2H.

A different architecture is allowed only if it preserves the same Secret and provenance invariants and is demonstrably smaller/safer. Standard stock CLI Cookie/BDUSS arguments are not allowed.

## BUILD / PROVENANCE

The adapter source must be auditable and minimal.

The build/package must pin:

- upstream repo/tag/commit;
- exact adapter source/patch blob;
- Go module source integrity through upstream `go.mod` / `go.sum`;
- build command and target Windows amd64;
- resulting artifact SHA-256 when a build is performed.

If a public build dependency/toolchain download is required, it may be used only for public source/toolchain/module material; record URLs/versions/digests where available. No Baidu account/provider auth requests are allowed.

Do not commit upstream source trees, module caches, binaries with uncertain provenance, or temporary build workspaces to Git.

## REQUIRED VALIDATION

At minimum prove:

```text
R6R2H_USERNAME_PASSWORD_ROUTE_RETIRED=PASS
R6R2H_STOCK_COOKIE_CLI_ARGS_FORBIDDEN=PASS
R6R2H_SECRET_NOT_IN_ARGS=PASS
R6R2H_SECRET_NOT_IN_ENV=PASS
R6R2H_SECRET_NOT_IN_COMMAND_HISTORY=PASS
R6R2H_SECRET_INPUT_NO_ECHO=PASS
R6R2H_SECRET_NOT_LOGGED_OR_PRINTED=PASS
R6R2H_SECRET_NOT_HASHED_FOR_EVIDENCE=PASS
R6R2H_COOKIE_EMPTY_REJECTED=PASS
R6R2H_COOKIE_CRLF_REJECTED=PASS
R6R2H_COOKIE_BDUSS_SHAPE_VALIDATED=PASS
R6R2H_SETUPUSERBYBDUSS_DIRECT_PATH=PASS
R6R2H_ACCOUNT_NAME_UID_NOT_EMITTED=PASS
R6R2H_FAILURE_NATIVE_EXIT_NONZERO=PASS
R6R2H_CONFIG_SAVE_ONLY_AFTER_SETUP_SUCCESS=PASS
R6R2H_PINNED_UPSTREAM_SOURCE=PASS
R6R2H_TEMP_BUILD_CLEANUP=PASS
R6R2H_EXISTING_R6R1_ACL_BOUNDARY_REUSED=PASS
POWERSHELL_AST_PARSE=PASS
GO_SOURCE_STATIC_VALIDATION=PASS
SECRET_SCAN=PASS
REAL_COOKIE_VALUES_USED=0
REAL_BAIDU_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
STOP_AT_REVIEWER=YES
```

If a synthetic Cookie fixture is necessary, it must be unmistakably fake/non-secret and must never be accepted as real provider Evidence.

## EXECUTOR BOUNDARY

Allowed:

- public upstream source/toolchain/module retrieval needed to build/validate the adapter;
- local synthetic build/test fixtures;
- source/build/validator changes inside this Gate;
- public GitHub issue/readme/source inspection.

Forbidden:

- Owner browser Cookie access;
- clipboard access;
- real Cookie/BDUSS/STOKEN input;
- real Baidu login/setup/who;
- Owner config read/write;
- provider file operations;
- Secret/DPAPI access;
- VPS/SSH/Clash/service/route/proxy/TUN/live G4-B/G4-C.

## ALLOWED PROJECT FILES

- secure Cookie adapter source/patch/build helper under `vpn-network-optimization/scripts/` or a narrowly named build subdirectory;
- adapter validator;
- this Gate;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:

- accepted R6R1/R6R2A sources;
- R6R2E reconciliation helper/validator;
- repaired R6R2E-R1 auth helper unless a compatibility shim is strictly required and separately justified;
- `REVIEWER_HANDOFF.md`;
- unrelated project files.

## STOP

`STOP_AT_REVIEWER=YES`
