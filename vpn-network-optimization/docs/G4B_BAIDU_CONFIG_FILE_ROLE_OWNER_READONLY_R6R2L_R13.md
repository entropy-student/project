# G4-B Baidu Config File-Role Owner Read-Only Classification R6R2L-R13

Status: ACTIVE / OWNER_LOCAL_METADATA_ONLY / READ_ONLY

## GATE_ID

`G4B_BAIDU_CONFIG_FILE_ROLE_OWNER_READONLY_R6R2L_R13`

## PREVIOUS_RESULT

`PASS_R6R2L_R12_METADATA_OBSERVATION_ADMIN_OWNER_ONE_FILE`

## R12 FACTS

R12 completed successfully within metadata-only scope:

```text
ITEM_COUNT=3
FILE_COUNT=2
DIRECTORY_COUNT=1
ROOT_OWNER_MATCH=YES
EXACT_OWNER_ITEM_COUNT=2
ADMIN_OWNER_ITEM_COUNT=1
SYSTEM_OWNER_ITEM_COUNT=0
OTHER_OWNER_ITEM_COUNT=0
OWNER_MISMATCH_FILE_COUNT=1
OWNER_MISMATCH_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
DENY_ACE_ITEM_COUNT=0
UNAUTHORIZED_ALLOW_ITEM_COUNT=0
OWNER_READ_RIGHTS_MISSING_ITEM_COUNT=0
R12_ACL_STATE=ADMIN_OWNER_MULTI_ITEM_DRIFT
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

The only observed deviation is one file Owner principal.

## UPSTREAM V4.0.2 FILE ROLES

Reviewer source reconciliation against BaiduPCS-Go v4.0.2 establishes two legitimate files under the same config directory:

```text
pcs_config.json
pcs_command_history.txt
```

Source:
- `internal/pcsconfig/pcsconfig.go` defines `ConfigName = "pcs_config.json"`;
- `main.go` defines `historyFilePath = filepath.Join(pcsconfig.GetConfigDir(), "pcs_command_history.txt")`.

Therefore the R12 root + two-file shape may be normal. The unresolved question is which expected file has the Administrators Owner.

## OBJECTIVE

Use local metadata only to prove:

- the root exists and is the only directory object;
- exactly one `pcs_config.json` exists as a regular non-reparse direct child;
- exactly one `pcs_command_history.txt` exists as a regular non-reparse direct child;
- no unexpected file or subdirectory exists;
- the Owner role of root/config/history is classified only as OWNER / ADMIN / SYSTEM / OTHER;
- no file contents are opened, hashed, copied or printed.

## REQUIRED SANITIZED OUTPUT

```text
OWNER_RUNTIME=PASS
TOTAL_ITEM_COUNT=<integer>
ROOT_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER
CONFIG_FILE_PRESENT=YES|NO
CONFIG_FILE_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
HISTORY_FILE_PRESENT=YES|NO
HISTORY_FILE_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
UNEXPECTED_FILE_COUNT=<integer>
UNEXPECTED_DIRECTORY_COUNT=<integer>
REPARSE_POINT_COUNT=<integer>
R13_FILE_ROLE_STATE=<classification>
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## CLASSIFICATION

Use one:

```text
EXPECTED_V4_0_2_SHAPE_CONFIG_ADMIN_HISTORY_OWNER
EXPECTED_V4_0_2_SHAPE_ALL_OWNER
EXPECTED_V4_0_2_SHAPE_OTHER_OWNER_COMBINATION
EXPECTED_FILE_MISSING
UNEXPECTED_ENTRY_PRESENT
REPARSE_OR_UNSAFE_SHAPE
LOCAL_DIAGNOSTIC_EXCEPTION
```

The narrow desired observation for later normalization consideration is:

```text
ROOT_OWNER_ROLE=OWNER
CONFIG_FILE_PRESENT=YES
CONFIG_FILE_OWNER_ROLE=ADMIN
HISTORY_FILE_PRESENT=YES
HISTORY_FILE_OWNER_ROLE=OWNER
UNEXPECTED_FILE_COUNT=0
UNEXPECTED_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R13_FILE_ROLE_STATE=EXPECTED_V4_0_2_SHAPE_CONFIG_ADMIN_HISTORY_OWNER
```

This is observation only and does not authorize ownership/ACL mutation.

## ALLOWED

- local PowerShell 7.6.6;
- `Get-Item`, direct-child `Get-ChildItem`, `Get-Acl`;
- exact basename comparison internally;
- filesystem object type and reparse metadata;
- Owner SID role classification internally;
- sanitized role/count output only.

## FORBIDDEN

- reading, parsing, hashing, copying or printing file contents;
- printing filenames, paths, usernames, SIDs or ACL/ACE detail;
- recursive traversal beyond the exact config directory direct children;
- `Set-Acl`, `takeown`, `icacls` or any owner/ACL mutation;
- file create/delete/rename/move;
- BaiduPCS-Go/provider access;
- UID prompt;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

## MAX ENDPOINT

One local metadata-only direct-child role classification ending in sanitized classification + `STOP_AT_REVIEWER=YES`.

## NEXT AFTER R13

Reviewer decides:
- exact expected config=ADMIN/history=OWNER shape -> design a separate narrow ACL normalization Gate targeting only the proven config file/root as needed;
- all Owner -> investigate temporal drift between R11 and R13;
- any other combination/unexpected entry -> separate fail-closed reconciliation.

No provider readback or live retry is authorized by R13.

## STOP

`STOP_AT_REVIEWER=YES`
