# G4-B Persistent Three-Role Live Run R6R2L

Status: ACTIVE / OWNER_LOCAL_LIVE_CONSEQUENTIAL / ONE_SHOT

## GATE_ID

`G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L`

Parent canonical Gate remains:

`G4B_PERSISTENT_THREE_ROLE_READINESS`

The top-level `REVIEWER_HANDOFF.md` `GATE_ID` must remain the parent value because the live runner verifies it before any mutation.

## PREVIOUS_RESULT

`PASS_G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K`

## LOCKED LIVE SOURCES

```text
LIVE_RUNNER_BLOB=cf7bc19b1accc142065416bc6c6525aa7b58fc23
LIVE_RUNNER_VALIDATOR_BLOB=5d560481b0367bc0ab783ddd51b4c27285dd5831
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
LIVE_G4B_EXECUTION_AUTHORIZED=YES
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
POSTAUTH_BAIDU_IDENTITY_DISCOVERY=PASS
```

## OBJECTIVE

Execute the accepted G4-B runner exactly once to establish durable three-role readiness:

1. HY2-SFO3 = PRIMARY
2. WG-BASELINE = BACKUP_1
3. REALITY-SFO3 = BACKUP_2

This run may:

- create and verify the encrypted portable recovery artifact;
- upload a run-scoped pending encrypted recovery object to Baidu Netdisk, read it back, decrypt/validate it, and promote it only after the rest of G4-B succeeds;
- create the local DPAPI recovery artifact;
- generate persistent REALITY credentials in protected runtime only;
- create/configure/enable the project-owned persistent REALITY service on the accepted SFO3 VPS;
- open/use the already planned TCP/443 listener through that project service;
- prepare exactly one `SELF-VPN-V1` three-role Clash profile;
- require Owner to import that exact profile without activating it;
- restart/read back the project REALITY service and Clash service;
- preserve WG and HY2;
- end with system proxy OFF, TUN OFF, automatic switching OFF;
- retain the bounded rollback journal and stop at Reviewer as PASS_CANDIDATE.

## LOCAL-ONLY INPUTS

The following values must stay local:

- numeric Baidu UID discovered in R6R2J-R3;
- SSH private-key path;
- portable recovery passphrase.

Do not paste them into chat/GitHub/Evidence.

The portable recovery passphrase is entered through the runner's hidden SecureString prompt and must be at least 16 characters.

## REQUIRED OWNER INVOCATION CONTRACT

Use PowerShell 7.6.6 Administrator / High Integrity.

Before invocation:

- fast-forward to current `origin/main`;
- verify the locked runner and validator blobs;
- run the live-runner fixture validator once more only as an immediate source-integrity guard;
- collect expected Baidu UID with local `Read-Host`;
- collect SSH private-key path with local `Read-Host`;
- require both local inputs to be non-empty and the SSH file to exist;
- invoke exactly one live run.

Required fixed arguments:

```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob cf7bc19b1accc142065416bc6c6525aa7b58fc23
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

Do not place the numeric UID directly in the command history; pass the local variable.

## INTERACTIVE P10 OWNER STEP

At `P10_OWNER_UI_IMPORT_AND_VISIBILITY` the runner prints:

`OWNER_UI_IMPORT_PATH=<local generated profile path>`

Owner must:

1. import only that named generated profile into Clash Verge;
2. confirm it is visible;
3. **do not activate/switch to it**;
4. leave active profile unchanged;
5. leave system proxy OFF;
6. leave TUN OFF;
7. then enter exactly the acknowledgement string requested by the runner.

If any of those conditions cannot be confirmed, do not type the acknowledgement; let the run stop/fail closed.

## SUCCESS CONTRACT

Expected terminal PASS_CANDIDATE markers include:

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

Also retain locally the non-secret:

- `G4B_ROLLBACK_RUN_ID`;
- `G4B_ROLLBACK_JOURNAL`.

Return them to Reviewer if printed; they are needed to identify the bounded rollback candidate.

## FAILURE CONTRACT

On failure, return all bounded non-secret lines from:

```text
RUNNER_FAILED_PHASE=...
FAILURE_CODE=...
CONSEQUENTIAL_MUTATION_STARTED=...
REMOTE_ROLLBACK=...
PROFILE_ROLLBACK=...
BAIDU_PENDING_ROLLBACK=...
RECOVERY_ARTIFACT_CLEANUP=...
LOCAL_RUNTIME_CLEANUP=...
BAIDU_RUNTIME_CLEANUP=...
ROLLBACK_JOURNAL=...
```

Do not retry automatically.

Any `UNKNOWN_REQUIRES_RECONCILIATION` or retained rollback journal/pending artifact blocks retry until Reviewer reconciliation.

## FORBIDDEN

- G4-C workloads or benchmarks;
- automatic node switching;
- changing the target role order;
- disabling/removing WG or HY2;
- broad firewall/route/service cleanup;
- uploading plaintext recovery material;
- printing/copying Secret values;
- re-authenticating Baidu;
- executing a second live run under this Gate.

## STOP

`STOP_AT_REVIEWER=YES`
