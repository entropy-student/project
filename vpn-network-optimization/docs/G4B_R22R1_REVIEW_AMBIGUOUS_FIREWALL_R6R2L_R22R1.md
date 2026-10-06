# G4-B R22R1 Read-only Reconciliation — Reviewer Decision

Status: RETURN / AMBIGUOUS_BASELINE / FIREWALL_ONLY_BLOCKER

## RESULT

```text
R22R1_RESULT=RETURN_AMBIGUOUS_BASELINE
R22R1_REALITY_SERVICE_LOAD=not-found
R22R1_REALITY_SERVICE_ACTIVE=inactive
R22R1_TCP443_COUNT=0
R22R1_MIHOMO_PROCESS_COUNT=0
R22R1_WG_HEALTHY=YES
R22R1_HY2_HEALTHY=YES
R22R1_BINARY_PRESENT=NO
R22R1_RUNTIME_PRESENT=NO
R22R1_SECRET_CONFIG_PRESENT=NO
R22R1_UNIT_PRESENT=NO
R22R1_RUNTIME_USER_PRESENT=NO
R22R1_RUNTIME_GROUP_PRESENT=NO
R22R1_TRANSACTION_PRESENT=YES
R22R1_TRANSACTION_STATE_PRESENT=YES
R22R1_TRANSACTION_RUN_ID_MATCH=YES
R22R1_TRANSACTION_ENTRIES_SAFE=YES
R22R1_ROUTE_BASELINE_MATCH=YES
R22R1_FIREWALL_BASELINE_MATCH=NO
R22R1_SERVICE_BASELINE_CLASS=EXACT
R22R1_LOCAL_RUNTIME_PRESENT=NO
R22R1_BAIDU_RUNTIME_PRESENT=NO
R22R1_RECOVERY_PENDING_LOCAL_PRESENT=YES
R22R1_RECOVERY_PENDING_CLOUD_LOCAL_PRESENT=YES
R22R1_RECOVERY_FINAL_LOCAL_PRESENT=NO
R22R1_PROFILE_CREATED_COUNT=0
R22R1_REMOTE_MUTATION=NO
R22R1_SECRET_CONTENT_READ=NO
R22R1_LOCAL_MUTATION=NO
```

## REVIEWER FINDING

R22 automatic rollback appears to have removed the persistent REALITY runtime surface successfully:
service/unit/binary/runtime/secret/user/group/process/listener are absent, WG/HY2 remain healthy, route baseline matches, and active-service baseline is exact.

The remaining project-owned evidence is the matched R22 transaction directory plus the retained recovery pending pair. These must remain untouched while the firewall baseline mismatch is unresolved.

The only blocker to classifying the remote baseline as clean is:
`R22R1_FIREWALL_BASELINE_MATCH=NO`.

## NEXT

Open R22R2 as read-only firewall component reconciliation. Compare only normalized component keys/hashes/count metadata; do not output raw firewall rules and do not mutate firewall or project state.

`STOP_AT_REVIEWER=YES`
