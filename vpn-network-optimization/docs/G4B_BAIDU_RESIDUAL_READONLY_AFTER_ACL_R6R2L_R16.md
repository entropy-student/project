# G4-B Baidu Residual-State Read-Only Reconciliation After ACL Repair R6R2L-R16

Status: ACTIVE / OWNER_LOCAL_READ_ONLY_PROVIDER_OBSERVATION

## GATE_ID

`G4B_BAIDU_RESIDUAL_READONLY_AFTER_ACL_R6R2L_R16`

## PREVIOUS_RESULT

`PASS_R6R2L_R15_UPLOAD_DB_OWNER_NORMALIZATION`

## ACCEPTED PRECONDITION

R15 formally reconciled the only local Baidu config Owner drift:

```text
pcs_config.json      owner=OWNER
pcs_uploading.json   owner=OWNER
strict R6R1 ACL      PASS
exact local shape    PASS
rollback journal     retained
```

No provider action occurred in R15.

Remote Baidu recovery state remains UNKNOWN because R11 stopped locally before UID/provider access.

## REUSED READ-ONLY HELPER

R16 intentionally reuses the already-reviewed R11 read-only provider helper without code changes:

```text
SCRIPT=scripts/g4b-baidu-residual-readonly-r11.ps1
SCRIPT_BLOB=b3dfb42f4deaf28650d3aab35d92b5a2965ed662
```

The helper is read-only with respect to Baidu provider state.

## OBJECTIVE

Now that local ACL state is reconciled, observe the Baidu recovery directory using corrected listing semantics and classify whether any R9 residual project object remains.

Expected project object roles:

```text
final:
vpn-network-optimization-g4b.vpr1

pending:
vpn-network-optimization-g4b-<32 lowercase hex run id>.vpr1.pending
```

## ALLOWED

- validate local Baidu config ACL metadata;
- create/remove temporary local diagnostic runtime;
- download the already pinned BaiduPCS-Go v4.0.2 release from GitHub and verify accepted hashes;
- run only:
  - `BaiduPCS-Go who`
  - `BaiduPCS-Go ls -l /vpn-network-optimization-g4b-recovery`
- hidden local input of expected numeric Baidu UID;
- parse provider output using corrected borderless-listing semantics;
- emit sanitized counts/classification only.

## FORBIDDEN

- mkdir/upload/download-from-Baidu/mv/rm;
- login/logout/config mutation/credential refresh;
- remote cleanup of any residual object;
- printing raw provider stdout/stderr, UID, filenames, paths, cookies, tokens or credentials;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C;
- deleting the retained R15 rollback journal.

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

Any other state stops at Reviewer. No cleanup is authorized by R16.

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

R16 is observation only.

- `CLEAN`: may permit Reviewer to design a new bounded live G4-B retry Gate.
- residual object present: requires a separate reconciliation/cleanup Gate.
- auth/provider/local diagnostic failure: fail closed and reconcile before any retry.

R16 does not close G4-B.

## ROLLBACK

No provider rollback is needed because R16 is read-only.

R15 local rollback journal remains retained and untouched.

## OWNER ACTION

Safe fast-forward to current main, verify R16 Gate + reused helper blob + Handoff state, parser-preflight the helper, run once, enter expected Baidu UID through hidden local prompt only, return sanitized markers, stop.

## STOP

`STOP_AT_REVIEWER=YES`
