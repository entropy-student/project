# Reviewer Correction — BaiduPCS-Go Execution Model for R1

Status: ACTIVE_CORRECTION

## CORRECTION

For G4-B, BaiduPCS-Go has two distinct lifecycles:

- **Executable/archive:** ephemeral execution dependency. It is not required to remain installed after a checkpoint.
- **Login/config state:** persistent state under `%APPDATA%\BaiduPCS-Go`.

R22R5 formally passed with `R22R5_TEMP_RUNTIME_CLEANUP=PASS`, confirming the previous temporary tool runtime was removed after use. The current R1 helper also explicitly resolves the persistent config from:

`Join-Path $env:APPDATA 'BaiduPCS-Go'`

Therefore the previously introduced idea of restoring BaiduPCS-Go to a long-lived `C:\Users\34707\Tools\...` location is **superseded**.

## R1 OWNER MODEL

The Owner may perform one atomic bounded procedure:

1. create a fresh temporary directory outside the repository and outside the G4-B runtime/recovery roots;
2. download the exact pinned official v4.0.2 Windows x64 ZIP;
3. verify archive SHA-256:
   `ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30`;
4. extract the temporary `BaiduPCS-Go.exe`;
5. pass the exact temporary ZIP and EXE paths to the already-reviewed R1 helper;
6. allow the helper to use the persistent `%APPDATA%\BaiduPCS-Go` config read-only;
7. after the helper exits, remove the temporary tool directory in `finally`.

The temporary public-tool download/extract/delete is local prerequisite housekeeping only. It does not authorize any G4-B runtime/recovery/profile/network mutation.

## STILL FORBIDDEN

- persistent installation of BaiduPCS-Go as a project requirement;
- login/config mutation;
- provider upload/download/mv/rm;
- SSH/VPS mutation;
- Clash/WireGuard/route/service mutation;
- live runner, rollback or cleanup.

## SUPERSEDED

`docs/G4B_LOCAL_BAIDUPCS_TOOL_RESTORE_R1.md` is superseded only in its long-lived local-tools-directory model. It remains historical evidence of the temporary detour and must not be treated as current execution guidance.

## CURRENT ENDPOINT

Resume parent:

`G4B_TAKEOVER_REALITY_REBASE_READONLY_R1`

with one Owner atomic ephemeral-tool + read-only checkpoint execution, then mandatory Reviewer stop.
