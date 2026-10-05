# G4-B Baidu Config ACL Owner Drift Read-Only Inventory R6R2L-R12

Status: ACTIVE / OWNER_LOCAL_METADATA_ONLY / READ_ONLY

## GATE_ID

`G4B_BAIDU_CONFIG_ACL_OWNER_DRIFT_READONLY_R6R2L_R12`

## PREVIOUS_RESULT

`RETURN_R6R2L_R11_BAIDU_AUTH_CONFIG_OWNER_MISMATCH`

## R11 FACTS

R11 passed source/gate/parser preflight and began the local read-only diagnostic.

It stopped before any Baidu provider command:

```text
DIAGNOSTIC_STAGE=OWNER_RUNTIME
OWNER_RUNTIME=PASS
DIAGNOSTIC_STAGE=BAIDU_CONFIG_ACL
DIAGNOSTIC_FAILED_STAGE=BAIDU_CONFIG_ACL
DIAGNOSTIC_EXCEPTION_TYPE=System.Management.Automation.RuntimeException
BAIDU_RESIDUAL_STATE=BAIDU_AUTH_CONFIG_OWNER_MISMATCH
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

No `who`, no remote `ls`, no UID prompt, no provider action, no Secret/DPAPI access and no network mutation occurred.

Therefore R11 did **not** establish whether the remote Baidu recovery directory is clean.

## RELEVANT ACCEPTED HISTORY

The accepted R6R1 ACL invariant requires, for every inspected Baidu config item:

- exact current Owner SID ownership;
- no reparse point;
- explicit review of direct and inherited ACEs;
- safe Allow principals only: current Owner SID, LocalSystem `S-1-5-18`, Builtin Administrators `S-1-5-32-544`;
- no Deny ACE;
- current Owner has required read/list/traverse rights;
- metadata/ACL inspection only; no config content read/copy/print.

Historical project evidence also records that on this exact Windows host, an elevated child process creating `pcs_config.json` can leave that file owned by Builtin Administrators rather than the exact Owner SID.

That history is relevant but does not identify the current mismatching item. R12 must observe the current metadata without guessing.

## LOCKED SOURCE

```text
R12_SCRIPT= scripts/g4b-baidu-config-acl-owner-drift-r12.ps1
R12_SCRIPT_BLOB=3ca2dcb3784d5d37d0fb3710eeac2b48cca1d3a9
```

## OBJECTIVE

Read only the local Baidu config subtree metadata and classify the exact scope of owner/ACL drift before any repair is considered.

The diagnostic must answer, without exposing paths, usernames, SIDs or config contents:

- total item count;
- root owner matches current Owner: YES/NO;
- file count and directory count;
- exact-Owner item count;
- Builtin-Administrators-owned item count;
- LocalSystem-owned item count;
- other-owner item count;
- owner-mismatch file count and directory count;
- reparse-point count;
- Deny-ACE item count;
- unauthorized-Allow item count;
- Owner-required-read-rights-missing item count;
- whether the current state is compatible with the previously observed narrow child-created-admin-owner shape.

## SANITIZED CLASSIFICATION

Use one:

```text
ACL_CLEAN
ADMIN_OWNER_SINGLE_EXPECTED_FILE_SHAPE
ADMIN_OWNER_MULTI_ITEM_DRIFT
SYSTEM_OWNER_DRIFT
OTHER_OWNER_DRIFT
ACL_POLICY_DRIFT
REPARSE_OR_UNSAFE_SHAPE
LOCAL_DIAGNOSTIC_EXCEPTION
```

`ADMIN_OWNER_SINGLE_EXPECTED_FILE_SHAPE` may be emitted only if metadata proves all of the following without reading file content:

- config root itself is owned by current Owner;
- subtree contains exactly the expected root plus one regular non-reparse config file;
- exactly that one file is owned by Builtin Administrators;
- no item is owned by LocalSystem or another principal;
- no Deny ACE, unauthorized Allow, reparse point or Owner read-rights failure is present.

This classification is observation only. It does not authorize ACL normalization.

## ALLOWED

- local PowerShell 7.6.6 metadata inspection;
- `Get-Item`, bounded `Get-ChildItem`, `Get-Acl`;
- object type / ACL / owner classification;
- current-user SID comparison internally;
- sanitized aggregate counts and classification only.

## FORBIDDEN

- reading, hashing, copying or printing config file contents;
- printing usernames, paths, SIDs or ACE detail;
- `Set-Acl`, `takeown`, `icacls` or any ACL/owner mutation;
- creating/deleting/renaming config files;
- BaiduPCS-Go or provider network action;
- UID prompt;
- login/logout/auth refresh;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

## REQUIRED SANITIZED OUTPUT

```text
OWNER_RUNTIME=PASS
ITEM_COUNT=<integer>
FILE_COUNT=<integer>
DIRECTORY_COUNT=<integer>
ROOT_OWNER_MATCH=YES|NO
EXACT_OWNER_ITEM_COUNT=<integer>
ADMIN_OWNER_ITEM_COUNT=<integer>
SYSTEM_OWNER_ITEM_COUNT=<integer>
OTHER_OWNER_ITEM_COUNT=<integer>
OWNER_MISMATCH_FILE_COUNT=<integer>
OWNER_MISMATCH_DIRECTORY_COUNT=<integer>
REPARSE_POINT_COUNT=<integer>
DENY_ACE_ITEM_COUNT=<integer>
UNAUTHORIZED_ALLOW_ITEM_COUNT=<integer>
OWNER_READ_RIGHTS_MISSING_ITEM_COUNT=<integer>
R12_ACL_STATE=<classification>
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## MAX ENDPOINT

One local metadata-only inventory ending in sanitized classification + `STOP_AT_REVIEWER=YES`.

R12 does not authorize normalization or provider readback.

## NEXT AFTER R12

Reviewer decides from observed metadata:

- narrow known admin-owner shape -> design a separate bounded ACL-normalization Gate;
- broader/unknown drift -> separate fail-closed reconciliation;
- ACL clean -> investigate why R11 observed mismatch before any provider action.

Only after local ACL state is reconciled may R11 remote residual-state readback be reconsidered.

## STOP

`STOP_AT_REVIEWER=YES`
