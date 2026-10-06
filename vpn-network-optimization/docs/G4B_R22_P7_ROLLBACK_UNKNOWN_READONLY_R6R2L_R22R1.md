# G4-B R22 P7 Rollback-Unknown Read-only Reconciliation — R6R2L-R22R1

Status: OWNER_READONLY_ACTION_REQUIRED / NO_MUTATION

## GATE_ID
`G4B_R22_P7_ROLLBACK_UNKNOWN_READONLY_R6R2L_R22R1`

## PREVIOUS_RESULT
`RETURN_R22_P7_REALITY_LISTENER_READBACK_INVALID_ROLLBACK_UNKNOWN`

## OBSERVED R22 RESULT
```text
R22_LIVE_INVOCATIONS_CONSUMED=1
RUNNER_FAILED_PHASE=P7_SERVICE_ENABLE_AND_LISTENER_READBACK
FAILURE_CODE=REALITY_LISTENER_READBACK_INVALID
CONSEQUENTIAL_MUTATION_STARTED=YES
REMOTE_ROLLBACK_FAILURE_CODE=REMOTE_NATIVE_COMMAND_FAILED
REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION
RECOVERY_ARTIFACT_CLEANUP=RETAINED_ROLLBACK_UNVERIFIED
ROLLBACK_JOURNAL=RETAINED_REQUIRES_RECONCILIATION
R22_NATIVE_EXIT=1
R22_SOURCE_WORKTREE_CLEANUP=PASS
```

R22 is consumed and must never be invoked again.

## OBJECTIVE
Perform one bounded read-only reconciliation of the failed R22 run before any cleanup or retry decision.

Determine:
1. the unique R22 local rollback journal identity from the R22 execution window;
2. whether R22 local runtime/Baidu runtime cleanup completed;
3. whether R22 recovery pending/final paths are present locally, without reading recovery contents;
4. whether any `SELF-VPN-V1` profile was created;
5. exact remote REALITY service/load/enable state;
6. TCP/443 listener count and whether all listeners are owned by Mihomo;
7. exact project-owned binary/runtime/secret/unit/transaction/temp/user/group presence;
8. whether the remote transaction state belongs to the selected R22 run and which creation flags are recorded;
9. whether WireGuard and HY2 remain healthy;
10. whether current remote route/firewall/active-service state matches the rollback journal baseline, with REALITY service treated only as an observed extra service and never as accepted state.

## LOCKED INPUT IDENTITIES
```text
R22_GATE_BLOB=449c6b0565cf3c18b5d1cbe8a8869795c380e52d
R22_RUNNER_BLOB=3b02e6753fabea74ef53ce4b2f85778954bdf42b
R22_LIVE_FIXTURE_VALIDATOR_BLOB=6294d3b48e2bb269f91517ec277a7bbaffdcd820
R22R1_HELPER_PATH=scripts/g4b-r22-readonly-reconciliation.ps1
```

## ALLOWED
- local metadata reads of the project rollback journal and referenced paths;
- local profile-store presence check;
- exactly one strict SSH read-only diagnostic invocation to the accepted SFO3 control target;
- read-only `systemctl show/is-active`, `ss`, `getent`, filesystem metadata/ownership-marker checks, process inventory, route/rule/firewall snapshots;
- compare current remote route/firewall/service state to the journal's stored pre-R22 baseline;
- no Secret content output.

## FORBIDDEN
- no R22 replay;
- no `-Mode Rollback`;
- no `systemctl start/stop/restart/enable/disable`;
- no file create/write/remove/rename/chmod/chown;
- no user/group mutation;
- no provider mutation;
- no recovery artifact deletion/promotion;
- no Clash/profile/network mutation;
- no raw service logs or Secret/config body output.

## REQUIRED EVIDENCE
```text
R22R1_LOCAL_JOURNAL_IDENTITY=PASS
R22R1_REMOTE_READONLY_QUERY=PASS
R22R1_WG_HEALTHY=YES|NO
R22R1_HY2_HEALTHY=YES|NO
R22R1_REALITY_SERVICE_LOAD=<bounded>
R22R1_REALITY_SERVICE_ACTIVE=<bounded>
R22R1_REALITY_SERVICE_SUB=<bounded>
R22R1_REALITY_SERVICE_ENABLE=<bounded>
R22R1_TCP443_COUNT=<integer>
R22R1_TCP443_OWNED_BY_MIHOMO=YES|NO|NA
R22R1_MIHOMO_PROCESS_COUNT=<integer>
R22R1_BINARY_PRESENT=YES|NO
R22R1_RUNTIME_PRESENT=YES|NO
R22R1_SECRET_CONFIG_PRESENT=YES|NO
R22R1_UNIT_PRESENT=YES|NO
R22R1_TRANSACTION_PRESENT=YES|NO
R22R1_TEMP_PRESENT=YES|NO
R22R1_TRANSACTION_STATE_PRESENT=YES|NO
R22R1_TRANSACTION_RUN_ID_MATCH=YES|NO|NA
R22R1_RUNTIME_USER_PRESENT=YES|NO
R22R1_RUNTIME_GROUP_PRESENT=YES|NO
R22R1_ROUTE_BASELINE_MATCH=YES|NO
R22R1_FIREWALL_BASELINE_MATCH=YES|NO
R22R1_SERVICE_BASELINE_CLASS=<EXACT|REALITY_ONLY_EXTRA|DRIFT>
R22R1_LOCAL_RUNTIME_PRESENT=YES|NO
R22R1_BAIDU_RUNTIME_PRESENT=YES|NO
R22R1_RECOVERY_PENDING_LOCAL_PRESENT=YES|NO
R22R1_RECOVERY_PENDING_CLOUD_LOCAL_PRESENT=YES|NO
R22R1_RECOVERY_FINAL_LOCAL_PRESENT=YES|NO
R22R1_PROFILE_CREATED_COUNT=0
R22R1_RECONCILIATION_STATE=CLEAN|PROJECT_RESIDUAL_PRESENT|AMBIGUOUS_BASELINE
R22R1_REMOTE_MUTATION=NO
R22R1_SECRET_CONTENT_READ=NO
R22R1_LOCAL_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
This Gate never declares G4-B PASS.

- `CLEAN`: remote target/identities/transaction/temp absent, no TCP/443 or Mihomo residue, WG/HY2 healthy, route/firewall/service baseline exact, and no unexpected local profile/runtime/final state. Recovery pending artifacts may remain and are reconciled in a separate read-only recovery Gate.
- `PROJECT_RESIDUAL_PRESENT`: WG/HY2 remain healthy but at least one R22-owned project residue or REALITY-only service delta remains. Reviewer must create an ownership-proven cleanup Gate.
- `AMBIGUOUS_BASELINE`: WG/HY2 unhealthy, route/firewall drift, unrelated service drift, journal/run ownership mismatch, or diagnostic ambiguity. No cleanup may begin until further read-only reconciliation.

## ROLLBACK
Not applicable to this Gate because it is read-only. The retained R22 rollback journal and recovery pending artifacts must remain untouched.

## AUTHORIZATION
Covered by Owner standing authorization for the documented roadmap. No new Owner prompt is required.

## STOP
`STOP_AT_REVIEWER=YES`
