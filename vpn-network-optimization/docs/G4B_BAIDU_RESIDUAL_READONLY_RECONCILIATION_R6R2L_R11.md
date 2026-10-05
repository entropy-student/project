# G4-B Baidu Residual-State Read-Only Reconciliation R6R2L-R11

Status: ACTIVE / OWNER_LOCAL_READ_ONLY_NETWORK_DIAGNOSTIC

## GATE_ID

`G4B_BAIDU_RESIDUAL_READONLY_RECONCILIATION_R6R2L_R11`

## PREVIOUS_RESULT

`PASS_R6R2L_R10_BAIDU_REAL_LISTING_PARSER_REPAIR`

## WHY THIS GATE EXISTS

R9 attempted the Baidu pending upload and later reported `BAIDU_PENDING_ROLLBACK=PASS`, but that rollback decision used the pre-R10 real-listing parser that was subsequently proven defective.

Therefore R9 rollback output cannot establish that the remote recovery directory is clean.

Before any new live G4-B retry, read-only provider state must be reconciled using the corrected borderless-listing semantics.

## LOCKED SOURCE

```text
R11_SCRIPT_BLOB=b3dfb42f4deaf28650d3aab35d92b5a2965ed662
```

## OBJECTIVE

Read only the approved Baidu recovery directory and classify whether any project-owned residual object is visible.

Expected project object shapes:

```text
final:
vpn-network-optimization-g4b.vpr1

pending:
vpn-network-optimization-g4b-<32 lowercase hex run id>.vpr1.pending
```

## ALLOWED

- validate Owner-local Baidu config ACL metadata;
- create a temporary Owner-only local diagnostic directory;
- download the already pinned BaiduPCS-Go v4.0.2 release from GitHub and verify the accepted archive/binary SHA-256 values;
- run only:
  - `BaiduPCS-Go who`
  - `BaiduPCS-Go ls -l /vpn-network-optimization-g4b-recovery`
- hidden local input of the expected numeric Baidu UID;
- parse provider output without printing raw stdout/stderr or remote filenames;
- report only sanitized counts/classification;
- delete the temporary local diagnostic directory.

## FORBIDDEN

- `mkdir`, `upload`, `download` from Baidu, `mv`, `rm`;
- login/logout/config mutation/credential refresh;
- live G4-B runner;
- SSH/VPS;
- DPAPI or real recovery Secret access;
- Clash/profile/service/route/proxy/TUN mutation;
- G4-C;
- printing UID, raw provider output, cookies, tokens, credentials or remote filenames.

## CLASSIFICATION

```text
CLEAN
STALE_PENDING_PRESENT
FINAL_PRESENT_REQUIRES_RECONCILIATION
MULTIPLE_OR_UNKNOWN_PROJECT_OBJECTS
AUTH_OR_PROVIDER_READ_FAILED
LOCAL_DIAGNOSTIC_EXCEPTION
```

`CLEAN` requires:

```text
BAIDU_UID_MATCH=PASS
BAIDU_DIRECTORY_HEADER=PASS
PROJECT_FINAL_COUNT=0
PROJECT_PENDING_COUNT=0
PROJECT_UNKNOWN_COUNT=0
```

Any other provider state stops at Reviewer. This Gate does not authorize cleanup.

## REQUIRED OUTPUT

```text
BAIDU_CONFIG_ACL=PASS
BAIDU_PINNED_CLI=PASS
EXPECTED_UID_INPUT=READY
BAIDU_WHO_PROCESS=PASS
BAIDU_UID_PARSE=PASS
BAIDU_UID_MATCH=PASS
BAIDU_LS_PROCESS=PASS
BAIDU_DIRECTORY_HEADER=PASS
PROJECT_FINAL_COUNT=<integer>
PROJECT_PENDING_COUNT=<integer>
PROJECT_UNKNOWN_COUNT=<integer>
BAIDU_RESIDUAL_STATE=<classification>
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE

R11 is accepted only as a state observation. It never closes G4-B.

A `CLEAN` result may permit Reviewer to issue a new bounded live retry Gate. Any residual object requires a separate reconciliation Gate.

## STOP

`STOP_AT_REVIEWER=YES`
