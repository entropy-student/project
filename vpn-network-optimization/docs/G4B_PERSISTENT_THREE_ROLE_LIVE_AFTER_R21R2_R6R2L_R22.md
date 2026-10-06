# G4-B Persistent Three-Role Live After R21R2 — R6R2L-R22

Status: CONSUMED / RETURN_P7_REALITY_LISTENER_READBACK_INVALID / ROLLBACK_UNKNOWN / NO_RETRY

## GATE_ID
`G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R21R2_R6R2L_R22`

## PREVIOUS_RESULT
`PASS_R21R2_AUTH_BINDING_REPAIR`

## LOCKED IDENTITIES
```text
R21R2_SOURCE_COMMIT=54b22c5a88530ba4defd9deea4ce3b153cef42ff
R21R2_REVIEW_EVIDENCE=docs/G4B_R21_P0_AUTH_BINDING_REPAIR_R6R2L_R21R2_REVIEW.md
RUNNER_BLOB=3b02e6753fabea74ef53ce4b2f85778954bdf42b
LIVE_FIXTURE_VALIDATOR_BLOB=6294d3b48e2bb269f91517ec277a7bbaffdcd820
PACKAGE_VALIDATOR_BLOB=59e18226dff66adcaac978b4b7eeb540a14514c9
THREE_ROLE_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
```

## ACCEPTED PRECONDITIONS
```text
R20_SECOND_ATTEMPT=FORBIDDEN
R21_RESULT=RETURN_R21_P0_REVIEWER_LIVE_AUTHORIZATION_MISSING_NO_MUTATION
R21_LIVE_INVOCATIONS_CONSUMED=1
SECOND_R21_LIVE_INVOCATION_AUTHORIZED=NO
R21_CONSEQUENTIAL_MUTATION_STARTED=NO
R21_ROLLBACK_REQUIRED=NO
R21R2_AUTH_BINDING_REPAIR=PASS
WG_HEALTHY=YES
HY2_HEALTHY=YES
```

## OBJECTIVE
Execute exactly one fresh bounded live run using a new run id and the R21R2-validated runner to establish persistent three-role readiness:

1. HY2-SFO3 — PRIMARY
2. WG-BASELINE — BACKUP_1
3. REALITY-SFO3 — BACKUP_2
4. AUTO_SWITCHING=OFF

R22 is a new Gate. It is not a replay or retry of R20 or R21.

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

## ONE-SHOT CONTRACT
```text
R22_LIVE_INVOCATIONS_CONSUMED=1
R22_LIVE_INVOCATIONS_AUTHORIZED=0
SECOND_R22_LIVE_INVOCATION_AUTHORIZED=NO
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
```

R22 returned at P7 with `REALITY_LISTENER_READBACK_INVALID`, consequential mutation started, and automatic rollback returned `UNKNOWN_REQUIRES_RECONCILIATION`.
- do not invoke R22 a second time;
- do not manually run rollback;
- continue only through the read-only R22R1 reconciliation Gate.

## P10 OWNER CHECKPOINT
At `P10_OWNER_UI_IMPORT_AND_VISIBILITY`:
- import only the exact `OWNER_UI_IMPORT_PATH`;
- verify the profile is visible;
- do not activate or switch profiles;
- active profile must remain unchanged;
- system proxy OFF;
- TUN OFF;
- keep standalone Windows WireGuard enabled;
- enter only the exact acknowledgement printed/required by the runner.

## REQUIRED LIVE INVOCATION
```text
-Mode Run
-Live
-OwnerAuthorization OWNER_G4B_LIVE_AUTHORIZATION=APPROVED
-ExpectedRunnerBlob 3b02e6753fabea74ef53ce4b2f85778954bdf42b
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
- any second R22 invocation;
- any R20 or R21 replay;
- G4-C execution inside R22;
- G4-D execution inside R22;
- disabling/removing standalone Windows WireGuard;
- automatic switching;
- permanent deletion of historical quarantine/journal evidence;
- scope expansion beyond documented project-owned paths.

## NEXT AFTER PASS_CANDIDATE
Stop at Reviewer. Only after formal R22 PASS:
1. run lightweight G4-C three-role ChatGPT switching smoke;
2. then G4-D WireGuard-in-Clash migration;
3. disable standalone Windows WireGuard only after formal G4-D PASS;
4. final smoke and MVP v1 seal.

## AUTHORIZATION
Standing Owner authorization covered the consumed R22 one-shot. R22 is closed RETURN; subsequent work proceeds only through the documented R22R1 read-only reconciliation and any later Reviewer-released cleanup/recovery Gate.

## STOP
`STOP_AT_REVIEWER=YES`


## R22 FINAL RESULT

```text
R22_RESULT=RETURN_R22_P7_REALITY_LISTENER_READBACK_INVALID_ROLLBACK_UNKNOWN
R22_LIVE_INVOCATIONS_CONSUMED=1
SECOND_R22_LIVE_INVOCATION_AUTHORIZED=NO
CONSEQUENTIAL_MUTATION_STARTED=YES
REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION
RECOVERY_ARTIFACT_CLEANUP=RETAINED_ROLLBACK_UNVERIFIED
ROLLBACK_JOURNAL=RETAINED_REQUIRES_RECONCILIATION
R22_REPLAY_AUTHORIZED=NO
MANUAL_ROLLBACK_AUTHORIZED=NO
NEXT_GATE=G4B_R22_P7_ROLLBACK_UNKNOWN_READONLY_R6R2L_R22R1
```

Reviewer record: `docs/G4B_R22_P7_RETURN_REVIEW_R6R2L_R22.md`
