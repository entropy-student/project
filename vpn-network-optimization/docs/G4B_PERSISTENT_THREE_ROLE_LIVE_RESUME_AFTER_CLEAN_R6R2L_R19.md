# G4-B Persistent Three-Role Live Resume After CLEAN R6R2L-R19

Status: RETURN / P5_LOCAL_MIHOMO_CONFIG_PARSE_FAILED / NO_REMOTE_CONSEQUENTIAL_MUTATION / RETRY_BLOCKED_PENDING_R19R1

## GATE_ID
`G4B_PERSISTENT_THREE_ROLE_LIVE_RESUME_AFTER_CLEAN_R6R2L_R19`

Parent runner-visible Gate ID remains:
`G4B_PERSISTENT_THREE_ROLE_READINESS`

## PREVIOUS_RESULT
`PASS_R6R2L_R18_RESIDUAL_CLEAN`

## WHY A NEW GATE
The historical live Gate `G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L` was one-shot and locked older runner identities. It must not be replayed.

Canonical main now contains the later R10 parser/fixture-repaired live sources:

```text
LIVE_RUNNER_PATH=scripts/g4b-persistent-three-role-live-runner.ps1
LIVE_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
LIVE_RUNNER_VALIDATOR_PATH=scripts/g4b-live-runner-fixture-validator.ps1
LIVE_RUNNER_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
R18_RESULT=PASS_R6R2L_R18_RESIDUAL_CLEAN
PRODUCTION_RECOVERY_NAMESPACE=FINAL_0_PENDING_0_UNKNOWN_0
R17_QUARANTINE_OBJECT=RETAINED_OUTSIDE_PRODUCTION_PREFIX
```

## OBJECTIVE
Execute one newly authorized bounded live run to establish durable three-role readiness:

1. HY2-SFO3 = PRIMARY
2. WG-BASELINE = BACKUP_1
3. REALITY-SFO3 = BACKUP_2
4. AUTO_SWITCHING = OFF

The run may create the encrypted recovery artifact, use a run-scoped Baidu pending object and promote it to final only on overall success, create/update the local DPAPI artifact, create the persistent project-owned REALITY service, and prepare/import exactly one `SELF-VPN-V1` Clash profile without activating it.

## CONSEQUENCE / OWNER AUTHORIZATION BOUNDARY
This Gate crosses fresh consequential boundaries:
- persistent REALITY credentials/service on the accepted SFO3 VPS;
- public TCP/443 project listener;
- new persistent Clash profile import;
- encrypted recovery upload/promote on Baidu.

Historical live authorization is not reused automatically. The Owner explicitly granted fresh R19 authorization in chat on 2026-10-06 after this Gate was prepared.

Authorization state:
```text
OWNER_R19_LIVE_AUTHORIZATION=GRANTED
LIVE_G4B_EXECUTION_AUTHORIZED=YES
AUTHORIZED_SCOPE=CURRENT_R19_GATE_ONLY
SECOND_R19_LIVE_INVOCATION_AUTHORIZED=NO
G4C_AUTHORIZED_BY_THIS_GRANT=NO
```

Exactly one R19 live run is released. Any failure or ambiguity stops for Reviewer.

## REQUIRED PRE-FLIGHT AFTER AUTHORIZATION
- Owner PowerShell 7.6.6 Administrator / High integrity;
- safe-sync canonical `main`;
- tracked project scope clean except accepted results artifacts;
- Handoff exact line `GATE_ID=G4B_PERSISTENT_THREE_ROLE_READINESS`;
- Handoff exact line `LIVE_G4B_EXECUTION_AUTHORIZED=YES`;
- Handoff exact line `SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK`;
- runner blob exactly `2faf59ec5a1653a275b11504fe567d0fc871f94e`;
- fixture validator blob exactly `26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3`;
- fixture validator PASS immediately before live execution;
- R18 formal CLEAN remains canonical accepted state;
- local expected Baidu UID entered only locally;
- SSH private-key path entered only locally and must exist;
- portable recovery passphrase entered as hidden SecureString, minimum 16 characters.

Required fixed runner arguments after release:
```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 2faf59ec5a1653a275b11504fe567d0fc871f94e
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

## MANUAL P10 OWNER STEP
If the runner reaches `P10_OWNER_UI_IMPORT_AND_VISIBILITY`, Owner may import only the generated profile path printed by the runner, confirm it is visible, and must NOT activate it. Existing active profile, system proxy OFF and TUN OFF must remain unchanged before acknowledgement.

## MAX ENDPOINT
Exactly one live Run invocation. Maximum accepted endpoint is PASS_CANDIDATE with:
- recovery pending verified and final promoted only on overall success;
- persistent REALITY service ready;
- public TCP/443 ready;
- one SELF-VPN-V1 profile imported but not activated;
- role order HY2 / WG / REALITY;
- auto switching OFF;
- WG and HY2 preserved;
- final system proxy OFF;
- final TUN OFF;
- rollback journal retained;
- Secret values emitted = 0;
- mandatory Reviewer stop.

## FAILURE / ROLLBACK
Use only the runner's bounded rollback behavior and returned rollback journal. Any failure/ambiguity stops for Reviewer. No automatic or manual second live attempt under R19.

## FORBIDDEN
- replaying historical live Gate as execution authority;
- second R19 live invocation;
- automatic node switching;
- changing target role order;
- disabling/removing WG or HY2;
- broad firewall/route/service cleanup;
- plaintext recovery upload;
- Secret disclosure;
- re-authenticating Baidu;
- touching/deleting the retained R17 quarantine object;
- permanent deletion of the R17 quarantine object;
- G4-C workloads/benchmarks.

## OWNER ACTION
Fresh explicit authorization is recorded and released for exactly one R19 live invocation under this Gate. No second live invocation is authorized.

## STOP
`STOP_AT_REVIEWER=YES`


## AUTHORIZATION RECORD — 2026-10-06

```text
OWNER_R19_LIVE_AUTHORIZATION=GRANTED
R19_GATE_BLOB_AT_AUTHORIZATION=11cb06d6b1be7ac372181517bb65cd847a10e81c
LIVE_RUNNER_BLOB=2faf59ec5a1653a275b11504fe567d0fc871f94e
LIVE_RUNNER_VALIDATOR_BLOB=26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3
LIVE_G4B_EXECUTION_AUTHORIZED=YES
AUTHORIZED_SCOPE=R19_ONE_SHOT_ONLY
G4C_AUTHORIZED_BY_THIS_GRANT=NO
```

The Owner approved proceeding with the R19 plan after being told the remaining interactive boundary: one Administrator PowerShell 7.6.6 live checkpoint, local-only UID/SSH-key/passphrase inputs, and one Clash profile import without activation.


## OWNER RUN RESULT — 2026-10-06

```text
OWNER_R19_CHECKPOINT=RETURN_FOR_REVIEW
RUNNER_FAILED_PHASE=P5_SECRET_AND_RECOVERY_PREPARE
FAILURE_CODE=MIHOMO_CONFIG_PARSE_FAILED
CONSEQUENTIAL_MUTATION_STARTED=NO
REMOTE_ROLLBACK=PASS
BAIDU_PENDING_ROLLBACK=PASS
R19_LIVE_INVOCATION_COUNT=1
NO_SECOND_R19_ATTEMPT=YES
G4C_EXECUTED=NO
```

Reviewer classification:
- preflight, source identity, authorization readback, AST and offline fixture validator all passed;
- the run reached P5 and successfully verified the encrypted Baidu pending recovery artifact;
- local generated `SELF-VPN-V1.yaml` then failed the real local `verge-mihomo.exe -t` parse check;
- no persistent remote mutation had started;
- remote rollback reported PASS and the owned Baidu pending object rollback reported PASS;
- no second live invocation is authorized.

R19 is RETURN, not PASS. The next Gate is local-only R19R1 diagnosis/repair. Live authorization is revoked until Reviewer accepts the repair and issues a new live Gate.
