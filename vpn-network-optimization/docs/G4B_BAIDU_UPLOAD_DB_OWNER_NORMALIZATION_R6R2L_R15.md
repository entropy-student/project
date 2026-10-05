# G4-B Baidu Upload-DB Owner Normalization R6R2L-R15

Status: PREPARED / OWNER_AUTHORIZATION_REQUIRED / LOCAL_SECURITY_METADATA_WRITE

## GATE_ID

`G4B_BAIDU_UPLOAD_DB_OWNER_NORMALIZATION_R6R2L_R15`

## PREVIOUS_RESULT

`PASS_R6R2L_R14_EXPECTED_CONFIG_OWNER_UPLOAD_DB_ADMIN`

## PROVEN PRECONDITION

Accepted R12-R14 evidence proves the current local Baidu config subtree is exactly:

```text
root                         owner=OWNER
pcs_config.json              owner=OWNER
pcs_uploading.json           owner=ADMIN
pcs_command_history.txt      absent
captcha.png                  absent
unknown file/dir             0
reparse                      0
Deny ACE item                0
unauthorized Allow item      0
Owner read-rights missing    0
SYSTEM/OTHER owner           0
```

Upstream BaiduPCS-Go v4.0.2 proves the upload path creates `pcs_uploading.json` under the config directory. R9 executed a real upload before its readback failure.

The only currently proven ACL defect is therefore the Owner principal of the exact `pcs_uploading.json` object.

## OBJECTIVE

Normalize **only the Owner field** of the exact `pcs_uploading.json` file from Builtin Administrators to the current Owner SID while preserving its existing DACL/SACL representation as far as `Set-Acl` permits.

Do not rewrite the config root ACL.  
Do not rewrite `pcs_config.json`.  
Do not delete `pcs_uploading.json`.  
Do not read its contents.

## WHY OWNER-ONLY CHANGE

R12 already proved:
- no Deny ACE;
- no unauthorized Allow ACE;
- current Owner has required read rights;
- no reparse point;
- no SYSTEM/OTHER owner.

Therefore replacing the entire DACL would be broader than necessary. The minimal repair is the Owner field only, followed by strict R6R1 validation.

## OWNER AUTHORIZATION

This Gate changes local security metadata and is consequential.

```text
OWNER_R15_ACL_NORMALIZATION_AUTHORIZATION=REQUIRED
R15_EXECUTION_AUTHORIZED=NO
```

Preparing this Gate/helper does not authorize execution.

A later Owner message must explicitly authorize R15 before the mutation path may run.

## REQUIRED PRE-MUTATION RECHECK

Immediately before mutation, re-prove metadata only:

- PowerShell 7.6.6;
- exact local config root;
- root is regular directory and non-reparse;
- direct children are exactly `pcs_config.json` and `pcs_uploading.json`;
- history/captcha absent;
- no extra file or directory;
- config file Owner=OWNER;
- upload DB Owner=ADMIN;
- no reparse;
- R6R1 ACL policy checks remain clean for root/config/upload DB.

Any drift -> stop before mutation.

## ROLLBACK BEFORE WRITE

Before any Owner mutation:

1. create a unique rollback directory below:
   `%LOCALAPPDATA%\vpn-network-optimization\rollback`;
2. protect it with current-Owner-only ACL;
3. capture the exact current ACL security descriptor of `pcs_uploading.json` as SDDL;
4. write only that ACL metadata plus a version marker to the Owner-only rollback journal;
5. verify the rollback journal exists and is Owner-only.

Do not store config contents, UID, cookies, tokens, passwords or provider data.

## ALLOWED MUTATION

Exactly one intended target:

```text
%APPDATA%\BaiduPCS-Go\pcs_uploading.json
```

Allowed change:
- set Owner to current Owner SID using the existing ACL object;
- preserve the current access rules;
- write that ACL object back with `Set-Acl`.

No other filesystem object may be modified.

## POST-MUTATION VALIDATION

After the Owner change:

- target Owner must equal current Owner;
- root/config/upload DB all pass the accepted strict R6R1 metadata predicate;
- direct-child shape remains exactly config + upload DB;
- no content read;
- no file size/content/hash check;
- no provider action.

Expected candidate markers:

```text
R15_PRECHECK=PASS
R15_ROLLBACK_JOURNAL=READY
R15_TARGET_OWNER_BEFORE=ADMIN
R15_OWNER_MUTATION=PASS
R15_TARGET_OWNER_AFTER=OWNER
R15_R6R1_STRICT_ACL_READBACK=PASS
R15_SHAPE_READBACK=PASS
R15_RESULT=PASS_CANDIDATE
ROLLBACK_JOURNAL_RETAINED=YES
CONFIG_CONTENT_READ=NO
BAIDU_PROVIDER_ACTION=NO
UID_INPUT=NO
SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## FAILURE / ROLLBACK

If any post-mutation check fails:

1. restore the exact pre-mutation ACL from the local rollback journal;
2. verify target Owner returns to ADMIN;
3. keep rollback journal for Reviewer evidence;
4. emit sanitized failure/rollback markers;
5. stop.

If rollback fails:

```text
R15_RESULT=ROLLBACK_FAILED
STOP_AT_REVIEWER=YES
```

No retry is authorized.

## FORBIDDEN

- config file content read/parse/hash/copy/print;
- delete/rename/move `pcs_uploading.json`;
- change root or `pcs_config.json` Owner/ACL;
- broad `takeown` / recursive `icacls`;
- BaiduPCS-Go/provider access;
- UID prompt;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

## MAX ENDPOINT

After explicit Owner authorization: one bounded local Owner normalization attempt with durable rollback journal, strict post-readback and mandatory Reviewer stop.

## NEXT AFTER FORMAL PASS

Only after Reviewer formally accepts R15 may a new read-only remote residual-state Gate be issued to re-run the blocked R11 provider observation with corrected local ACL state.

## STOP

`STOP_AT_REVIEWER=YES`
