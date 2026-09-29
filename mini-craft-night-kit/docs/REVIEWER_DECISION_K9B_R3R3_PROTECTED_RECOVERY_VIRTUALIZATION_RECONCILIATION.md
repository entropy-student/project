# Reviewer Decision — K9B-R3R3 Protected Recovery Virtualization Reconciliation

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Trigger

Owner-side ordinary PowerShell reported the previously expected paths under:

`C:\Users\34707\AppData\Local\MiniCraftNightKit\...`

as absent.

A subsequent read-only filename search located the expected recovery artifacts under the Codex packaged-app LocalCache namespace:

`C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_*\LocalCache\Local\MiniCraftNightKit\...`

## Reviewer interpretation

This is consistent with Windows packaged-application LocalAppData virtualization / package-local cache behavior.

The prior Executor/Codex references to `%LOCALAPPDATA%\MiniCraftNightKit\...` were relative to the Codex application execution context, while Owner's ordinary PowerShell resolves `%LOCALAPPDATA%` to the normal user profile LocalAppData root.

Therefore:

```text
PROTECTED_RECOVERY_DELETION_PROVEN=NO
PROTECTED_RECOVERY_MISSING_PROVEN=NO
PROTECTED_RECOVERY_RELOCATED_OR_VIRTUALIZED=YES_CANDIDATE
K9B_FILESYSTEM_DELETE_ACCIDENT=NOT_PROVEN
```

The seven allowlisted VPS-basis project-directory deletions do not include the Codex packaged-app LocalCache path.

## Current Gate

```text
CURRENT_GATE=K9B_R3R3_R1_PROTECTED_RECOVERY_VIRTUALIZATION_METADATA_SEAL
CURRENT_GATE_STATUS=OWNER_LOCAL_READONLY_METADATA_ONLY

FURTHER_DELETION_AUTHORIZED=NO_UNTIL_METADATA_SEAL
K9C_AUTHORIZED=NO
```

## Expected artifacts

Read-only metadata seal must identify:

1. rollback metadata:
   - filename `rollback-point.json`
   - expected bytes: 54911

2. historical DPAPI pending:
   - filename `k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi`
   - expected bytes: 1686

3. final DPAPI recovery artifact:
   - filename pattern `k6-c1r5-mini-craft-night-kit-srv1970241-*.final.dpapi`
   - expected bytes: 1686

No contents, hashes or decryption are required.

## Allowed

Only:
- full path;
- file length;
- creation time;
- last-write time;
- ACL/owner metadata if needed.

Do not:
- open rollback JSON content;
- decrypt/open DPAPI payload;
- hash recovery files;
- move/copy/restore/delete anything.

## Success

If all three artifacts are located at the packaged-app LocalCache path with expected byte sizes:

```text
PASS_CANDIDATE_K9B_R3R3_R1_PROTECTED_RECOVERY_VIRTUALIZATION_METADATA_SEAL
PROTECTED_ROLLBACK_METADATA=RETAINED_CODEX_LOCALCACHE
DPAPI_PENDING_RECOVERY=RETAINED_CODEX_LOCALCACHE
DPAPI_FINAL_RECOVERY=RETAINED_CODEX_LOCALCACHE
```

Then Reviewer may resume the remaining exact local-directory cleanup verification.

Do not enter K9C automatically.
