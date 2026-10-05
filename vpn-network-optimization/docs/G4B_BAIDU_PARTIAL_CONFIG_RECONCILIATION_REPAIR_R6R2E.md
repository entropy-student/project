# G4-B Baidu Partial Config Reconciliation + Auth ACL Repair R6R2E

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_PARTIAL_CONFIG_RECONCILIATION_REPAIR_R6R2E`

## PREVIOUS_RESULT

`RETURN_G4B_BAIDU_INTERACTIVE_AUTH_R6R2D_PROVIDER_BUSY_OWNER_MISMATCH`

## OWNER EVIDENCE

The one authorized R6R2D Owner run returned:

```text
UPSTREAM_LOGIN_ERROR_CODE=50052
UPSTREAM_LOGIN_ERROR_CLASS=SYSTEM_BUSY
BAIDU_INTERACTIVE_AUTH=FAIL_CLOSED
BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=BAIDU_AUTH_CONFIG_OWNER_MISMATCH
BAIDU_INTERACTIVE_AUTH_CONFIG_STATE=NEW_INITIALIZED
BAIDU_INTERACTIVE_AUTH_CONFIG_DISPOSITION=PRESERVED_NONEMPTY
BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=PASS
BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO
BAIDU_WHO_RAW_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
```

Do not replay login yet.

## PINNED UPSTREAM FACTS

```text
UPSTREAM_TAG=v4.0.2
UPSTREAM_TAG_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
UPSTREAM_MAIN_GO_BLOB=ac5ace05fc860bc3f47fdaf9ddec126d06890630
UPSTREAM_LOGIN_GO_BLOB=8865962ac126053632beee750310b099e6b89e1d
UPSTREAM_PCSCONFIG_GO_BLOB=2ab8f56647d70a903786db351c57308ee8bee69d
UPSTREAM_CONFIG_FILENAME=pcs_config.json
```

Reviewer source reconciliation:

- the pinned config implementation creates/opens only `pcs_config.json` inside `BAIDUPCS_GO_CONFIG_DIR`;
- config initialization may create/save default config before the login action;
- the no-argument login action calls `RunLogin("", "")`;
- when `RunLogin` returns an error such as provider code 50052, the action returns before `SetupUserByBDUSS`;
- therefore this R6R2D failed attempt did not reach the authenticated-user setup call;
- the R6R2D root config directory was created by the reviewed helper from an absent state, then became non-empty during the pinned login process;
- strict post-login ACL validation failed because an item owner was not the exact Owner SID. On elevated Windows this can arise when the child process creates a file owned by the Administrators token/group despite the protected parent ACL.

The current partial config is a bounded failed-run residue, but it must still be reconciled without content reads before destructive rollback.

## OBJECTIVE

Offline-build and validate two tightly related artifacts:

1. a one-shot Owner-local **partial-config reconciliation/rollback checkpoint** for the exact R6R2D failed-run residue;
2. a repaired interactive-auth checkpoint that prevents the same Windows owner mismatch on the next authorized login attempt.

No real Owner config or provider action is allowed in this Executor round.

## A. PARTIAL-CONFIG RECONCILIATION / ROLLBACK HELPER

Future Owner run must operate only on:

`%APPDATA%\BaiduPCS-Go`

It must be metadata-only before deletion and must not read, print, hash, parse, copy, move, or serialize config content.

It may authorize rollback only if all are true:

- root exists and is a real directory, not a reparse point;
- root canonical location passes the accepted R6R1 safe-path rule;
- root contains **exactly one** entry;
- that entry is a regular, non-reparse file named exactly `pcs_config.json`;
- no subdirectories or additional entries exist;
- file size is non-zero and bounded to a conservative config limit (<= 1 MiB);
- root/item owners are limited to current Owner SID and/or Builtin Administrators SID `S-1-5-32-544` as expected from this elevated failed-run shape; any System/arbitrary/broad/unresolved owner fails closed unless Reviewer evidence specifically justifies it;
- ACL metadata has no Deny and no Allow principal outside current Owner / LocalSystem / Builtin Administrators;
- the helper never prints owner SID values, filenames beyond the fixed literal, ACL details, timestamps, sizes, or config content.

If and only if the exact failed-run residue shape is proven, the future Owner checkpoint may delete exactly `pcs_config.json` and then the now-empty `BaiduPCS-Go` directory, restoring the pre-R6R2D absent baseline.

Any mismatch => fail closed, no deletion.

Output bounded markers only, e.g.:

```text
BAIDU_PARTIAL_CONFIG_RECONCILIATION=...
BAIDU_PARTIAL_CONFIG_SHAPE=...
BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO
BAIDU_PARTIAL_CONFIG_ROLLBACK=...
BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=...
```

## B. INTERACTIVE AUTH HELPER REPAIR

Repair the R6R2C helper without broadening auth behavior.

Required changes:

- keep exactly one no-argument `login` process and the same cleared/allowlisted environment;
- keep inherited local console and no capture/transcript;
- keep the exact pinned archive trust chain;
- before login, only ABSENT or safely EMPTY config state is accepted;
- record whether the config started absent or empty;
- after the pinned login process returns, before strict R6R1 ACL validation:
  - inspect the exact config subtree metadata only;
  - for this pinned v4.0.2 auth flow, accept only the root plus exact regular file `pcs_config.json`; any extra entry/reparse/subdirectory fails closed before ACL normalization;
  - normalize Owner/ACL metadata for the root and exact `pcs_config.json` to the current Owner-only ACL using the already accepted ACL constructor;
  - never read config content during normalization;
- then run the strict accepted R6R1 config ACL predicate;
- check native login exit before any `who`;
- if login native exit is non-zero:
  - no `who`;
  - no false PASS;
  - rollback may remove the exact newly-created/this-attempt config only when provenance and exact single-file shape are proven; otherwise preserve fail-closed;
- if login exit is zero:
  - run exactly one captured read-only `who`;
  - UID remains in memory and is not emitted;
  - success still requires unique numeric UID + strict config safety + runtime cleanup;
- existing unknown non-empty config at start remains rejected. The current R6R2D residue must be reconciled by the separate rollback checkpoint first.

## EXECUTOR ROUND BOUNDARY

Offline only:

```text
fresh read
-> implement reconciliation helper + validator
-> repair auth helper + validator
-> synthetic exact-residue / extra-entry / reparse / wrong-owner / forbidden-ACE fixtures
-> synthetic post-login ACL normalization fixtures
-> R6R1 ACL regression
-> AST + Secret scan
-> Evidence/Handoff
-> GitHub fresh read-back
-> STOP_AT_REVIEWER
```

Forbidden:

- real Owner config access;
- real deletion;
- real login / `who`;
- network/provider action;
- credential/Secret/DPAPI access;
- VPS/SSH;
- Clash/service/route/proxy/TUN;
- live G4-B/G4-C.

## REQUIRED MARKERS

At minimum:

```text
R6R2E_UPSTREAM_SINGLE_CONFIG_FILE_PROVEN=PASS
R6R2E_RECONCILE_METADATA_ONLY=PASS
R6R2E_RECONCILE_EXACT_PCS_CONFIG_ONLY=PASS
R6R2E_RECONCILE_EXTRA_ENTRY_REJECTED=PASS
R6R2E_RECONCILE_REPARSE_REJECTED=PASS
R6R2E_RECONCILE_UNEXPECTED_OWNER_REJECTED=PASS
R6R2E_RECONCILE_FORBIDDEN_ACE_REJECTED=PASS
R6R2E_RECONCILE_DELETE_EXACT_ONLY=PASS
R6R2E_AUTH_SINGLE_LOGIN_PRESERVED=PASS
R6R2E_AUTH_NO_CREDENTIAL_FLAGS_OR_ENV=PASS
R6R2E_AUTH_CONSOLE_UNCAPTURED=PASS
R6R2E_AUTH_POST_LOGIN_EXACT_SHAPE_CHECKED=PASS
R6R2E_AUTH_POST_LOGIN_OWNER_ACL_NORMALIZED=PASS
R6R2E_AUTH_R6R1_STRICT_ACL_AFTER_NORMALIZE=PASS
R6R2E_AUTH_NONZERO_LOGIN_NO_WHO=PASS
R6R2E_AUTH_UID_NOT_EMITTED=PASS
R6R2E_AUTH_PARTIAL_FAILURE_NO_FALSE_PASS=PASS
R6R2E_R6R1_ACL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_CONFIG_ACTIONS=0
REAL_LOGIN_ACTIONS=0
REAL_BAIDU_ACTIONS=0
NETWORK_REQUESTS=0
STOP_AT_REVIEWER=YES
```

## ALLOWED FILES

- `scripts/g4b-baidu-partial-config-reconcile-checkpoint.ps1`
- `scripts/g4b-baidu-partial-config-reconcile-validator.ps1`
- `scripts/g4b-baidu-owner-interactive-auth-checkpoint.ps1`
- `scripts/g4b-baidu-owner-interactive-auth-validator.ps1`
- this Gate
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`;
- accepted R6R1/R6R2A sources;
- live G4-B runner/package;
- unrelated files.

## STOP

`STOP_AT_REVIEWER=YES`
