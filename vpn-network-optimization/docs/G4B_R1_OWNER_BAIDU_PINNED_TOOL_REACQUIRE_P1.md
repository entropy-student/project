# G4-B R1 Owner Prerequisite — Reacquire Pinned BaiduPCS-Go v4.0.2

Status: REVIEWER_RELEASED / OWNER_LOCAL_PREP_ONLY

## GATE_ID

`G4B_R1_OWNER_BAIDU_PINNED_TOOL_REACQUIRE_P1`

## REASON

The released R1 read-only checkpoint requires the already pinned BaiduPCS-Go v4.0.2 Windows x64 archive and executable as local inputs. Owner confirmed the prior local copies were likely cleaned.

Do not run the R1 checkpoint with empty or guessed Baidu paths.

## EXACT AUTHORIZED ASSET

```text
VERSION=v4.0.2
PLATFORM=windows-x64
ASSET=BaiduPCS-Go-v4.0.2-windows-x64.zip
EXPECTED_SHA256=ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30
SOURCE=https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip
```

## AUTHORIZED OWNER ACTIONS

Exactly one bounded local preparation:

1. Download the exact pinned archive above.
2. Verify SHA-256 equals the expected value.
3. If and only if the hash matches, extract the archive to a dedicated local tools directory outside:
   - repository root;
   - vpn-network-optimization runtime directory;
   - vpn-network-optimization recovery directory.
4. Locate the extracted `BaiduPCS-Go.exe`.
5. Return the ZIP and EXE paths plus the verified archive SHA-256.

## FORBIDDEN

- Do not execute BaiduPCS-Go.
- Do not access or mutate Baidu provider state.
- Do not run login/who/ls/upload/download/mv/rm.
- Do not run the R1 checkpoint in the same preparation step.
- Do not touch VPN, Clash, routes, services, VPS, Secrets, DPAPI, live runner, rollback or cleanup.
- Do not accept any archive whose SHA-256 differs from the pinned value.

## MAX_ENDPOINT_THIS_ROUND

```text
download pinned archive
-> verify SHA-256
-> extract locally if PASS
-> report paths/hash
-> STOP_AT_REVIEWER
```

## OWNER_ONLY_ACTIONS

Run the exact bounded PowerShell preparation supplied by Reviewer.
