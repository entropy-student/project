# G4-B Baidu Known Config-Role Owner Read-Only Classification R6R2L-R14

Status: ACTIVE / OWNER_LOCAL_METADATA_ONLY / READ_ONLY

## GATE_ID

`G4B_BAIDU_KNOWN_CONFIG_ROLE_OWNER_READONLY_R6R2L_R14`

## PREVIOUS_RESULT

`RETURN_R6R2L_R13_EXPECTED_HISTORY_ABSENT_ONE_UNKNOWN_FILE`

## R13 FACTS

R13 completed within metadata-only scope:

```text
TOTAL_ITEM_COUNT=3
ROOT_OWNER_ROLE=OWNER
CONFIG_FILE_PRESENT=YES
CONFIG_FILE_OWNER_ROLE=OWNER
HISTORY_FILE_PRESENT=NO
HISTORY_FILE_OWNER_ROLE=NOT_PRESENT
UNEXPECTED_FILE_COUNT=1
UNEXPECTED_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R13_FILE_ROLE_STATE=UNEXPECTED_ENTRY_PRESENT
CONFIG_CONTENT_READ=NO
ACL_MUTATION=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

Combined with accepted R12:
- exactly one file in the subtree is owned by Builtin Administrators;
- `pcs_config.json` is Owner-owned;
- therefore the one unclassified file observed by R13 is the current Owner-mismatch file.

## UPSTREAM V4.0.2 KNOWN CONFIG-DIRECTORY ROLES

Reviewer source reconciliation of BaiduPCS-Go v4.0.2 identifies these known direct-child roles under `pcsconfig.GetConfigDir()`:

```text
pcs_config.json
pcs_command_history.txt
pcs_uploading.json
captcha.png
```

Relevant source facts:
- `internal/pcsconfig/pcsconfig.go`: `ConfigName = "pcs_config.json"`;
- `main.go`: command history lives at `pcs_command_history.txt`;
- `internal/pcsfunctions/pcsupload/pcsupload.go`: `UploadingFileName = "pcs_uploading.json"`;
- `internal/pcsfunctions/pcsupload/upload_database.go`: upload DB is opened with create semantics in the config directory;
- `internal/pcscommand/upload.go`: upload path invokes `pcsupload.NewUploadingDatabase()`;
- `internal/pcsfunctions/pcscaptcha/pcscaptcha.go`: `CaptchaName = "captcha.png"`.

R9 executed a real upload before its readback failure, so `pcs_uploading.json` is a strong candidate for the ADMIN-owned file, but R14 must prove the role from metadata rather than assume it.

## OBJECTIVE

Use local metadata only to classify presence and Owner role for all four upstream-known direct-child roles and count any truly unknown direct child.

No file content may be opened.

## REQUIRED SANITIZED OUTPUT

```text
OWNER_RUNTIME=PASS
TOTAL_ITEM_COUNT=<integer>
ROOT_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER
CONFIG_PRESENT=YES|NO
CONFIG_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
HISTORY_PRESENT=YES|NO
HISTORY_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
UPLOAD_DB_PRESENT=YES|NO
UPLOAD_DB_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
CAPTCHA_PRESENT=YES|NO
CAPTCHA_OWNER_ROLE=OWNER|ADMIN|SYSTEM|OTHER|NOT_PRESENT
UNKNOWN_FILE_COUNT=<integer>
UNKNOWN_DIRECTORY_COUNT=<integer>
REPARSE_POINT_COUNT=<integer>
R14_KNOWN_ROLE_STATE=<classification>
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
EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN
EXPECTED_CONFIG_OWNER_HISTORY_OWNER
EXPECTED_KNOWN_ROLE_COMBINATION_OTHER
UNKNOWN_ENTRY_PRESENT
EXPECTED_CORE_CONFIG_MISSING
REPARSE_OR_UNSAFE_SHAPE
LOCAL_DIAGNOSTIC_EXCEPTION
```

The key desired observation is:

```text
ROOT_OWNER_ROLE=OWNER
CONFIG_PRESENT=YES
CONFIG_OWNER_ROLE=OWNER
HISTORY_PRESENT=NO
UPLOAD_DB_PRESENT=YES
UPLOAD_DB_OWNER_ROLE=ADMIN
CAPTCHA_PRESENT=NO
UNKNOWN_FILE_COUNT=0
UNKNOWN_DIRECTORY_COUNT=0
REPARSE_POINT_COUNT=0
R14_KNOWN_ROLE_STATE=EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN
```

This is observation only.

## ALLOWED

- local PowerShell 7.6.6;
- exact config root and direct-child `Get-Item` / `Get-ChildItem` / `Get-Acl`;
- internal exact basename comparison for the four upstream-known roles;
- filesystem type/reparse metadata;
- Owner SID role classification internally;
- sanitized role/count output only.

## FORBIDDEN

- reading/parsing/hashing/copying/printing file contents;
- printing filenames, paths, usernames, SIDs or ACE detail;
- recursion below direct children;
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

One local metadata-only known-role classification ending in sanitized output + `STOP_AT_REVIEWER=YES`.

## NEXT AFTER R14

Reviewer decides:
- `EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN` -> design a separate narrow normalization/reconciliation Gate for the proven upload DB ownership residue, without touching config content;
- another upstream-known combination -> reconcile against the actual producer path;
- unknown/reparse state -> separate fail-closed investigation.

No provider readback or live retry is authorized by R14.

## STOP

`STOP_AT_REVIEWER=YES`
