# G4-B Persistent Three-Role Live After R19R1 — R6R2L-R20

Status: PREPARED / FRESH_OWNER_AUTHORIZATION_REQUIRED / LIVE_NOT_RELEASED

## GATE_ID
`G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R19R1_R6R2L_R20`

## PARENT_GATE_ID
`G4B_PERSISTENT_THREE_ROLE_READINESS`

## PREVIOUS_RESULTS
```text
R18_RESULT=PASS_R6R2L_R18_RESIDUAL_CLEAN
R19_RESULT=RETURN_R19_P5_MIHOMO_CONFIG_PARSE_FAILED
R19_CONSEQUENTIAL_MUTATION_STARTED=NO
R19_REMOTE_ROLLBACK=PASS
R19_BAIDU_PENDING_ROLLBACK=PASS
R19R1_RESULT=PASS_R19R1_LOCAL_MIHOMO_PARSE_REPAIR
```

## OBJECTIVE
Run exactly one fresh bounded G4-B live attempt using the repaired production renderer and validator chain to establish durable three-role readiness:

1. HY2-SFO3 = PRIMARY
2. WG-BASELINE = BACKUP_1
3. REALITY-SFO3 = BACKUP_2
4. AUTO_SWITCHING = OFF

This Gate does not perform G4-C or G4-D.

## LOCKED SOURCE IDENTITIES
```text
R19R1_GATE_BLOB=7e9e7bf4f69645a695d418bd934c04d79625707c
R19R1_SOURCE_COMMIT=dcbc609c329198e49f87191247570ce0e35ff1a6
LIVE_RUNNER_BLOB=3a5e7c93bb96a4b485283f6590df18c5fac2690f
LIVE_FIXTURE_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
THREE_ROLE_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
PACKAGE_VALIDATOR_BLOB=59e18226dff66adcaac978b4b7eeb540a14514c9
```

The R19R1 repair is specifically included: the HY2 certificate SHA-256 fingerprint already verified against the accepted pin is now retained and explicitly rendered into the three-role profile before the real local Mihomo parse check.

## CONSEQUENTIONAL SCOPE
Maximum allowed outcome:
- preserve existing HY2 and Windows WireGuard;
- create persistent project-owned REALITY credentials/runtime/service on the accepted SFO3 VPS;
- expose the reviewed REALITY TCP/443 listener only;
- create encrypted recovery artifacts, including bounded Baidu pending→final promotion only after overall success;
- prepare one persistent `SELF-VPN-V1` Clash profile with exactly HY2 / WG / REALITY in the frozen manual order;
- Owner imports that exact profile at P10 without activating it;
- prove restart persistence and final baseline;
- end with system proxy OFF and TUN OFF;
- retain bounded rollback journal for Reviewer closeout.

## REQUIRED PRE-LIVE VALIDATION
Immediately before the live invocation:
- PowerShell 7.6.6 Administrator / High integrity;
- safe-sync canonical `main`;
- project tracked worktree clean except accepted untracked results;
- exact Handoff parent Gate line and R20 subgate line;
- exact `LIVE_G4B_EXECUTION_AUTHORIZED=YES` only after fresh Owner authorization;
- exact source blobs above;
- PowerShell AST PASS;
- package validator PASS, including real local `verge-mihomo.exe -t` synthetic rendered-profile parse;
- full live fixture validator PASS;
- R18 CLEAN remains canonical;
- local Baidu UID, SSH key path and recovery passphrase remain local-only.

## FIXED LIVE ARGUMENTS
After fresh Owner authorization only:
```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 3a5e7c93bb96a4b485283f6590df18c5fac2690f
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

## P10 OWNER UI CHECKPOINT
If the runner reaches `P10_OWNER_UI_IMPORT_AND_VISIBILITY`:
- import only the exact path printed as `OWNER_UI_IMPORT_PATH`;
- verify the profile is visible;
- do not activate or switch to it;
- keep the active profile unchanged;
- keep system proxy OFF and TUN OFF;
- enter only the exact acknowledgement printed by the runner.

If any condition cannot be confirmed, do not acknowledge. Stop fail-closed.

## ACCEPTANCE
R20 returns `PASS_CANDIDATE` only if all runner final markers are present, including:
- persistent REALITY ready;
- TCP/443 ready;
- three-role profile imported and restart-persistent;
- role order HY2/WG/REALITY;
- automatic switching OFF;
- WG and HY2 preserved;
- system proxy OFF;
- TUN OFF;
- recovery final promotion verified;
- rollback journal retained;
- `SECRET_VALUES_EMITTED=0`;
- `STOP_AT_REVIEWER=YES`.

PASS_CANDIDATE is not formal PASS until Reviewer durable closeout/readback.

## FAILURE / RETRY
- This Gate authorizes at most one live invocation after fresh Owner authorization.
- Any failure or ambiguity stops for Reviewer.
- No automatic second R20 attempt.
- No replay of R19 authorization.
- No G4-C / G4-D execution.
- No permanent deletion of R17 quarantine.
- No automatic switching.
- No removal/disable of Windows WireGuard or HY2.

## AUTHORIZATION MODEL
The Gate file is intentionally immutable after preparation. Fresh Owner authorization is recorded externally in canonical Handoff / Evidence / Decision so this Gate blob remains stable.

Before fresh authorization:
```text
LIVE_G4B_EXECUTION_AUTHORIZED=NO
```

## OWNER ACTION
Fresh explicit Owner authorization is required before R20 live execution is released.

## STOP
`STOP_AT_REVIEWER=YES`
