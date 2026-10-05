# G4-B Persistent Three-Role Live Run R6R2L-R5

Status: ACTIVE / OWNER_LOCAL_LIVE_CONSEQUENTIAL / ONE_SHOT

## GATE_ID

`G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_R5`

## PREVIOUS_RESULT

`PASS_R6R2L_R4`

## AUTHORIZATION

```text
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
PRIOR_AUTHORIZED_ATTEMPT_CONSEQUENTIAL_MUTATION_STARTED=NO
FRESH_REAUTH_REQUIRED=NO
```

The existing bounded G4-B live authorization remains valid because the prior live attempt failed in P0 before any consequential mutation. No broader authorization is inferred.

## LOCKED SOURCES

```text
LIVE_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
LIVE_RUNNER_VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
R6R2L_R4_VALIDATION_RESULT=PASS
```

The original R6R2L live Gate is stale and must not be reused because it locks pre-repair source blobs.

## OBJECTIVE

Make the accepted v1 three-role target durably ready without production-wide takeover:

```text
HY2-SFO3      PRIMARY
WG-BASELINE   BACKUP_1
REALITY-SFO3  BACKUP_2
AUTO_SWITCHING=OFF
```

This Gate may create the persistent project-owned REALITY service, create and verify encrypted portable recovery in the approved second failure domain, and create/import exactly one persistent SELF-VPN-V1 Clash profile without activating it.

## MAX_ENDPOINT

One Owner-local live run only, ending at `PASS_CANDIDATE` + `STOP_AT_REVIEWER=YES`.

This Gate does not authorize:
- switching production traffic to SELF-VPN-V1;
- enabling automatic switching;
- G4-C workloads or benchmarks;
- changing the final WireGuard production/rollback role;
- leaving system proxy or TUN enabled.

## REQUIRED OWNER ENVIRONMENT

- PowerShell 7.6.6;
- Administrator / High Integrity;
- repository root `C:\Users\34707\Documents\ChatGPT\VPS搭建`;
- safe fast-forward to current `origin/main`;
- exact runner blob `8b099e4229642bf439eb03c0d1e9cce0f8e698bd`;
- exact validator blob `5c8763350098f181f41b0b1e0799885da9e5d07d`;
- current Handoff still records this parent G4-B Gate, live authorization YES, and Baidu as the approved second failure domain.

## OWNER-LOCAL SECRET / ID INPUTS

Collect locally only:
- numeric Baidu UID through `Read-Host`;
- SSH private-key path through `Read-Host`;
- portable recovery passphrase through the runner's hidden SecureString prompt.

Do not paste the numeric UID, recovery passphrase, SSH private-key contents, Baidu credentials, HY2 secret, REALITY private key, or any raw Secret into chat/GitHub/Evidence.

The recovery passphrase must satisfy the runner's minimum length requirement.

## REQUIRED FIXED ARGUMENTS

```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 8b099e4229642bf439eb03c0d1e9cce0f8e698bd
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

Pass the locally collected UID through a variable, not as a literal command-history value.

## INTERACTIVE P10 OWNER STEP

At `P10_OWNER_UI_IMPORT_AND_VISIBILITY`, the runner prints:

`OWNER_UI_IMPORT_PATH=<local generated profile path>`

Owner must:
1. import only that generated SELF-VPN-V1 profile into Clash Verge;
2. confirm it is visible;
3. do not activate or switch to it;
4. leave the previously active profile unchanged;
5. leave system proxy OFF;
6. leave TUN OFF;
7. enter only the acknowledgement string requested by the runner.

If any condition cannot be confirmed, do not acknowledge; allow the run to fail closed.

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

Retain locally the non-secret rollback identifiers printed by the runner:
- `G4B_ROLLBACK_RUN_ID`;
- `G4B_ROLLBACK_JOURNAL`.

## FAILURE CONTRACT

Any non-zero or ambiguous result stops immediately.

Return only sanitized non-secret output, including:
- failed phase;
- failure code;
- whether consequential mutation started;
- rollback result;
- Baidu pending rollback result;
- runtime cleanup result;
- final proxy/TUN state;
- `STOP_AT_REVIEWER=YES` if emitted.

Do not blindly replay the live runner.

## ROLLBACK

The runner's bounded rollback journal is authoritative for this run. Rollback is scoped to objects proven to be created by the current run. Do not perform broad service/firewall/route/profile cleanup.

WireGuard remains the production/rollback baseline throughout this Gate.

## STOP

`STOP_AT_REVIEWER=YES`
