# G4-B R22R3 iptables4 Counter-Normalization — Reviewer Decision

Status: PASS / COUNTER_ONLY_TELEMETRY

## RESULT

```text
R22R3_RESULT=PASS_COUNTER_ONLY_TELEMETRY
R22R3_IPTABLES4_COUNTER_INSENSITIVE_MATCH=YES
R22R3_IPTABLES4_BASELINE_COUNT=14
R22R3_IPTABLES4_CURRENT_COUNT=14
R22R3_CLASSIFICATION=COUNTER_ONLY_TELEMETRY
R22R3_RAW_FIREWALL_RULES_EMITTED=NO
R22R3_REMOTE_MUTATION=NO
R22R3_LOCAL_MUTATION=NO
R22R3_SECRET_CONTENT_READ=NO
```

The only R22R2 firewall mismatch was caused by runtime packet/byte counter telemetry in IPv4 iptables chain declarations. After counter-only normalization, retained baseline and fresh current semantic hashes match exactly.

Therefore the R22 remote route/firewall/service baseline is considered restored for rollback reconciliation. Persistent REALITY runtime surface remains absent and WG/HY2 healthy from R22R1.

Next: exact ownership-proven cleanup of the retained R22 transaction residue only. Recovery pending artifacts remain out of scope.

`STOP_AT_REVIEWER=YES`
