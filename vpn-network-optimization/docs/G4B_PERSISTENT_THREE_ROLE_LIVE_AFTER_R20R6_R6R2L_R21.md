# G4-B Persistent Three-Role Live After R20R6 — R6R2L-R21

Status: RELEASED / OWNER_ONE_SHOT_LIVE / REVIEWER_STOP

## GATE_ID
`G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R20R6_R6R2L_R21`

## PREVIOUS_RESULT
`PASS_R21R1_GATE_BINDING_OFFLINE`

## LOCKED IDENTITIES
```text
R20R6_GATE_BLOB=2549ba44475a113c5e66ef101ee3ced7d43984ea
R20R6_SOURCE_REPAIR_COMMIT=6344fc4625383fbf25883ffb546cceee62a5b010
R21R1_GATE_BLOB=0ae43846afeff808dcf7084a8cabb90284f33797
R21R1_REVIEW_EVIDENCE=docs/G4B_R21_P0_GATE_BINDING_OFFLINE_R6R2L_R21R1_REVIEW.md
RUNNER_BLOB=2b9a6e5f361905500b00c71548118e9046cd89de
LIVE_FIXTURE_VALIDATOR_BLOB=b44fe52a560694dcb49ef0dfece0db253b7aa7a7
PACKAGE_VALIDATOR_BLOB=59e18226dff66adcaac978b4b7eeb540a14514c9
THREE_ROLE_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
```

## ACCEPTED PRECONDITIONS
```text
R20_SECOND_ATTEMPT=FORBIDDEN
R20_REMOTE_CONSEQUENTIAL_SURFACE=CLEAN
R20_REMOTE_TRANSACTION_RESIDUE=CLEAN
R20_FAILED_RUN_RECOVERY_PENDING_SET=CLEAN
R20_RECOVERY_FINAL_ARTIFACTS=ABSENT
R20_ROLLBACK_JOURNAL=RETAINED_OUT_OF_SCOPE
WG_HEALTHY=YES
HY2_HEALTHY=YES
R20R6_OFFLINE_REPAIR=PASS
R21R1_GATE_BINDING_REPAIR=PASS
R21_LIVE_INVOCATIONS_CONSUMED=0
```

## OBJECTIVE
Execute exactly one fresh bounded live run using a new run id and the R20R6-repaired, R21R1-binding-validated runner to establish persistent three-role readiness:

1. HY2-SFO3 — PRIMARY
2. WG-BASELINE — BACKUP_1
3. REALITY-SFO3 — BACKUP_2
4. AUTO_SWITCHING=OFF

This is a new Gate. It is not a replay or retry of R20.

## ALLOWED LIVE SCOPE
- preserve current HY2 and standalone Windows WireGuard;
- create new project-owned REALITY runtime/service on the accepted SFO3 VPS;
- expose reviewed REALITY TCP/443 only;
- create new run-scoped encrypted recovery pending artifacts and promote them only after success;
- prepare exactly one project-owned `SELF-VPN-V1` profile;
- Owner imports the exact profile at P10 without activating it;
- prove restart persistence and final baseline;
- keep system proxy OFF and TUN OFF;
- retain new rollback journal through Reviewer decision.

## R20 HISTORICAL JOURNAL
The retained R20 rollback journal is historical evidence only:
- it must not be deleted or reused by R21;
- R21 must create/use only its own new run-scoped journal;
- any collision or ambiguity fails closed.

## P10 OWNER CHECKPOINT
At `P10_OWNER_UI_IMPORT_AND_VISIBILITY`:
- import only the exact `OWNER_UI_IMPORT_PATH`;
- verify the profile is visible;
- do not activate or switch profiles;
- active profile must remain unchanged;
- system proxy OFF;
- TUN OFF;
- enter only the exact acknowledgement printed/required by the runner.

## ONE-SHOT RULE
Exactly one R21 live invocation is authorized.

If R21 returns failure, ambiguity, rollback UNKNOWN, or any unexpected state:
- do not invoke R21 a second time;
- do not manually run rollback;
- return to Reviewer with sanitized output.

## REQUIRED LIVE INVOCATION
```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 2b9a6e5f361905500b00c71548118e9046cd89de
-SecondFailureDomainAcknowledgement SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED
```

## REQUIRED SUCCESS EVIDENCE
Existing runner PASS_CANDIDATE markers plus:
- no failure markers;
- structured error propagation remains available if failure occurs;
- new rollback journal retained;
- WG/HY2 preserved;
- role order exact;
- AUTO_SWITCHING=OFF;
- system proxy OFF;
- TUN OFF;
- `STOP_AT_REVIEWER=YES`.

## FORBIDDEN
- any second R21 invocation;
- G4-C execution inside R21;
- G4-D execution inside R21;
- disabling/removing standalone Windows WireGuard;
- automatic switching;
- permanent deletion of R17 quarantine;
- deletion/reuse of the retained R20 journal;
- scope expansion beyond the documented project-owned paths.

## NEXT AFTER PASS_CANDIDATE
Stop at Reviewer. Only after formal R21 PASS:
1. run lightweight G4-C three-role ChatGPT switching smoke;
2. then G4-D WireGuard-in-Clash migration;
3. disable standalone Windows WireGuard only after formal G4-D PASS;
4. final smoke and MVP v1 seal.

## AUTHORIZATION
Standing Owner authorization covers this documented R21 one-shot live Gate. No additional authorization prompt is required.

## STOP
`STOP_AT_REVIEWER=YES`
