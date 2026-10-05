# G4-B Baidu Owner Interactive Auth Helper R6R2C

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_INTERACTIVE_AUTH_HELPER_R6R2C`

## PREVIOUS_RESULT

`RETURN_OWNER_ACTION_REQUIRED_R6R2B_CONFIG_ABSENT`

## REVIEWER RECONCILIATION

R6R2B returned:

```text
BAIDU_UID_DISCOVERY=OWNER_ACTION_REQUIRED
BAIDU_UID_FAILURE_CODE=RETURN_OWNER_ACTION_REQUIRED
BAIDU_UID_RUNTIME_CLEANUP=NOT_REQUIRED
```

Under the accepted helper source, `RUNTIME_CLEANUP=NOT_REQUIRED` means execution stopped before temporary runtime creation. Combined with `OWNER_ACTION_REQUIRED`, this identifies the missing/unavailable BaiduPCS-Go config presence boundary, not an account mismatch and not a failed `who` attempt.

No UID was displayed and no login/provider mutation occurred.

## UPSTREAM AUTH FACTS — PINNED v4.0.2

```text
UPSTREAM_TAG=v4.0.2
UPSTREAM_TAG_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
UPSTREAM_README_BLOB=0d07b9b27b989319a65c3c8979d896e02cabc340
UPSTREAM_MAIN_GO_BLOB=ac5ace05fc860bc3f47fdaf9ddec126d06890630
UPSTREAM_LOGIN_GO_BLOB=8865962ac126053632beee750310b099e6b89e1d
```

Reviewer source inspection establishes:

- cookie login and BDUSS/STOKEN login place credential material in command-line flags and are forbidden for this project;
- username/password flags are likewise forbidden;
- direct no-argument `login` calls `RunLogin("", "")`;
- `RunLogin` prompts for username locally and uses `PasswordPrompt` for password without echo;
- upstream README explicitly says normal interactive login is long-unmaintained / not recommended, so it may fail and must be treated as a bounded Owner-only attempt, not a guaranteed path;
- account-side authentication remains Owner-only.

## OBJECTIVE

Build and offline-validate one atomic Owner-local interactive-auth checkpoint that can initialize the protected BaiduPCS-Go config without placing credentials/cookies/tokens in chat, GitHub, logs, command-line arguments, environment values, or captured stdout/stderr.

Do not execute real login in this Executor round.

## REQUIRED FUTURE OWNER BEHAVIOR

The helper must:

1. reuse the pinned BaiduPCS-Go v4.0.2 archive URL/SHA and extraction boundary already accepted in R6/R6R1;
2. target the canonical Owner config directory `%APPDATA%\BaiduPCS-Go`;
3. before login, classify existing config state:
   - absent/empty known state may be initialized;
   - unknown/non-empty state must fail closed and must not be deleted/overwritten;
4. create/tighten only the exact config directory/subtree owned by this Gate, using the accepted Owner-only ACL constructor; do not rewrite unrelated parent ACLs;
5. create a bounded Owner-only temporary binary runtime;
6. launch exactly:
   `BaiduPCS-Go.exe login`
   with no username/password/cookies/BDUSS/STOKEN/PTOKEN flags and no credential-bearing environment values;
7. inherit the Owner console stdin/stdout/stderr for the interactive prompts; do not capture, tee, log, transcript, or persist the entered username/password/verification code/provider output;
8. never enable verbose/debug output;
9. after the login process returns, verify native exit status;
10. then verify the resulting config subtree with the accepted R6R1 metadata/ACL/reparse/location predicate before any read-only identity check;
11. run exactly one accepted read-only `who` using captured internal stdout/stderr only after login, parse the numeric UID in memory, and return only bounded status markers — **do not emit the UID in this helper**;
12. success requires a valid unique UID from `who`, safe config ACL, and successful temp cleanup;
13. on any ambiguous login/config/who/cleanup result, fail closed;
14. leave the authenticated config in place only on proven success; if login did not produce a valid authenticated config, do not publish a fake PASS. Cleanup/rollback of a partially created config must be carefully bounded and must never delete unknown/non-empty pre-existing state.

## SECRET BOUNDARY

Forbidden in helper source, arguments, environment, logs, Evidence, or Handoff:

- username/password values;
- Cookies;
- BDUSS/STOKEN/PTOKEN;
- SMS/email verification codes;
- raw provider stdout/stderr after the login step;
- UID value.

Owner may type requested authentication factors only into the live local console prompts of the pinned executable.

## EXECUTOR ROUND

Offline only:

```text
fresh source read
-> implement helper + offline validator
-> synthetic empty/unknown config-state fixtures
-> static proof: login has zero credential flags
-> static proof: no redirect/capture/transcript around interactive login
-> synthetic post-login who outcome fixtures
-> ACL/config invariant regression
-> AST + Secret scan
-> Evidence/Handoff
-> GitHub fresh read-back
-> STOP_AT_REVIEWER
```

No network, no Owner config access, no real login/who, no provider mutation, no VPS/SSH/Secret/DPAPI/Clash/G4-C.

## REQUIRED MARKERS

```text
R6R2C_PINNED_ARCHIVE_TRUST_REUSED=PASS
R6R2C_LOGIN_NO_CREDENTIAL_FLAGS=PASS
R6R2C_LOGIN_NO_CREDENTIAL_ENV=PASS
R6R2C_LOGIN_INTERACTIVE_CONSOLE_INHERITED=PASS
R6R2C_LOGIN_OUTPUT_NOT_CAPTURED_OR_LOGGED=PASS
R6R2C_VERBOSE_DEBUG_DISABLED=PASS
R6R2C_EXISTING_UNKNOWN_CONFIG_FAIL_CLOSED=PASS
R6R2C_EMPTY_CONFIG_INITIALIZATION_BOUNDED=PASS
R6R2C_R6R1_ACL_POLICY_REUSED=PASS
R6R2C_NATIVE_LOGIN_EXIT_CHECKED=PASS
R6R2C_POST_LOGIN_WHO_ONLY=PASS
R6R2C_UID_NOT_EMITTED=PASS
R6R2C_PARTIAL_FAILURE_NO_FALSE_PASS=PASS
R6R2C_TEMP_CLEANUP=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_LOGIN_ACTIONS=0
REAL_BAIDU_ACTIONS=0
OWNER_CONFIG_READ=NO
NETWORK_REQUESTS=0
STOP_AT_REVIEWER=YES
```

## ALLOWED FILES

- `scripts/g4b-baidu-owner-interactive-auth-checkpoint.ps1`
- `scripts/g4b-baidu-owner-interactive-auth-validator.ps1`
- this Gate
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`;
- accepted R6/R6R1/R6R2A scripts;
- live G4-B runner/package;
- unrelated files.

## STOP

`STOP_AT_REVIEWER=YES`

Do not execute the Owner login helper.
