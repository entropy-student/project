# G4-B R22R2 Firewall Component Reconciliation — Reviewer Decision

Status: RETURN / SINGLE_COMPONENT_DRIFT / IPTABLES4_ONLY

## RESULT

```text
R22R2_RESULT=RETURN_SINGLE_COMPONENT_DRIFT_IPTABLES4
R22R2_UFW_MATCH=YES
R22R2_NFT_MATCH=YES
R22R2_IPTABLES4_MATCH=NO
R22R2_IPTABLES6_MATCH=YES
R22R2_IPTABLES4_BASELINE_COUNT=14
R22R2_IPTABLES4_CURRENT_COUNT=14
R22R2_MISMATCH_COUNT=1
R22R2_MISMATCH_COMPONENTS=iptables4
R22R2_CLASSIFICATION=SINGLE_COMPONENT_DRIFT
R22R2_REMOTE_MUTATION=NO
R22R2_LOCAL_MUTATION=NO
R22R2_SECRET_CONTENT_READ=NO
```

## REVIEWER FINDING

The firewall ambiguity is isolated to the normalized `iptables-save` IPv4 representation. UFW, nft and IPv6 iptables all match the retained pre-R22 baseline exactly, and the IPv4 normalized line count remains unchanged at 14.

The current R22R2 normalization removes counters only when a line begins with `[packets:bytes]`. Standard `iptables-save` chain declarations can contain counters at the end of the line, e.g. `:CHAIN POLICY [packets:bytes]`. Those counters are runtime telemetry and may change without rule mutation.

Therefore this result is insufficient to claim real firewall drift.

## NEXT

Open R22R3 as read-only iptables4 counter-insensitive reconciliation. Compare the retained baseline and a fresh current `iptables-save` snapshot after stripping only packet/byte counter tokens from chain declarations, while leaving all rule semantics/order intact.

`STOP_AT_REVIEWER=YES`
