# G4-B Persistent Three-Role Live Retry R6R2L-R9

Status: ACTIVE / OWNER_LOCAL_LIVE_CONSEQUENTIAL / ONE_SHOT

## GATE_ID

`G4B_PERSISTENT_THREE_ROLE_LIVE_RETRY_R6R2L_R9`

## PREVIOUS_RESULT

`PASS_R6R2L_R8_BAIDU_PIPELINE_OUTPUT_REPAIR`

## AUTHORIZATION

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
PRIOR_R5_CONSEQUENTIAL_MUTATION_STARTED=NO
FRESH_REAUTH_REQUIRED=NO
```

Existing bounded G4-B live authorization remains valid because the prior R5 live attempt failed before consequential mutation and the repaired live runner differs by exactly one safety-preserving output-suppression line.

## LOCKED SOURCES

```text
LIVE_RUNNER_BLOB=388714218a7a6f1671777488b0c581812f6cc9eb
LIVE_RUNNER_VALIDATOR_BLOB=eac0f9684b8f98b71c856e4d297da03f867b2d51
R8_REPAIR_RESULT=PASS
```

## ROOT CAUSE CLOSED

R5/R7 failure root cause:

```powershell
$psi.Environment.Remove([string]$key)
```

emitted Boolean values to the PowerShell success stream. Under StrictMode, downstream member access hit the polluted stream and raised `PropertyNotFoundException`, which the outer live runner normalized to `UNCLASSIFIED`.

Repair:

```powershell
[void]$psi.Environment.Remove([string]$key)
```

R8 positive and negative regression fixtures both passed.

## OBJECTIVE

Retry the bounded G4-B persistent three-role readiness run:

```text
HY2-SFO3      PRIMARY
WG-BASELINE   BACKUP_1
REALITY-SFO3  BACKUP_2
AUTO_SWITCHING=OFF
```

The retry may:
- verify the approved Baidu second failure domain;
- create and validate encrypted recovery artifacts;
- create the project-owned persistent REALITY service;
- create/import exactly one SELF-VPN-V1 Clash profile without activating it;
- verify restart persistence and final baselines.

## MAX_ENDPOINT

Exactly one live retry ending at either:
- `PASS_CANDIDATE` + `STOP_AT_REVIEWER=YES`; or
- a bounded failure + stop.

No production-role activation, no automatic switching, no G4-C.

## REQUIRED OWNER ENVIRONMENT

- PowerShell 7.6.6;
- Administrator / High Integrity;
- repository root `C:\Users\34707\Documents\ChatGPT\VPS搭建`;
- safe fast-forward to current `origin/main`;
- exact runner blob `388714218a7a6f1671777488b0c581812f6cc9eb`;
- exact validator blob `eac0f9684b8f98b71c856e4d297da03f867b2d51`;
- current Handoff still records Owner live authorization, live execution YES, and Baidu Netdisk as the approved second failure domain.

## OWNER-LOCAL INPUTS

Collect locally only:
- numeric Baidu UID through hidden input;
- SSH private-key path;
- portable recovery passphrase through the runner's hidden SecureString prompt.

Never paste UID, passphrase, SSH key contents, Baidu credentials, HY2 auth or REALITY key material into chat/GitHub/Evidence.

## REQUIRED FIXED ARGUMENTS

```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 388714218a7a6f1671777488b0c581812f6cc9eb
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

## P10 OWNER STEP

When the runner prints `OWNER_UI_IMPORT_PATH=...`:
1. import only that generated SELF-VPN-V1 profile into Clash Verge;
2. confirm it is visible;
3. do not activate or switch to it;
4. leave the previously active profile unchanged;
5. system proxy remains OFF;
6. TUN remains OFF;
7. enter exactly the acknowledgement string printed by the runner.

If any condition cannot be confirmed, do not acknowledge.

## SUCCESS CONTRACT

Expected terminal markers include:

```text
G4B_RECOVERY_PENDING_VERIFIED=YES
G4B_REALITY_RUNTIME_ACCESS=PASS
G4B_THREE_ROLE_PROFILE_RESTART_PERSISTENCE=PASS
G4B_UNRELATED_REMOTE_DRIFT=NONE
BAIDU_RUNTIME_CLEANUP=PASS
G4B_RECOVERY_FINAL_PROMOTED=YES
G4B_RECOVERY_PORTABLE_FORMAT=VPNG4BP1
G4B_REALITY_SERVICE_READY=YES
G4B_PUBLIC_TCP443_READY=YES
G4B_THREE_ROLE_PROFILE_IMPORTED=YES
G4B_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2
G4B_AUTO_SWITCHING=OFF
G4B_WIREGUARD_PRESERVED=YES
G4B_HY2_PRESERVED=YES
G4B_SYSTEM_PROXY_FINAL=OFF
G4B_TUN_FINAL=OFF
G4B_ROLLBACK_JOURNAL_RETAINED=YES
SECRET_VALUES_EMITTED=0
G4B_PERSISTENT_THREE_ROLE_RUNNER=PASS_CANDIDATE
STOP_AT_REVIEWER=YES
```

Retain locally the non-secret rollback run ID and rollback journal path printed by the runner.

## FAILURE CONTRACT

Any non-zero or ambiguous result stops immediately. Do not replay.

Return only sanitized output:
- failed phase;
- failure code;
- whether consequential mutation started;
- rollback result;
- Baidu pending rollback result;
- runtime cleanup result;
- final proxy/TUN state;
- STOP_AT_REVIEWER marker if emitted.

## ROLLBACK

Use only the runner-owned bounded rollback journal and ownership proofs. No broad service/firewall/route/profile cleanup.

WireGuard remains the production/rollback baseline.

## STOP

`STOP_AT_REVIEWER=YES`
