# G4-B R22 Firewall Component Read-only Reconciliation — R6R2L-R22R2

Status: OWNER_READONLY_ACTION_REQUIRED / NO_MUTATION

## GATE_ID
`G4B_R22_FIREWALL_COMPONENT_READONLY_R6R2L_R22R2`

## PREVIOUS_RESULT
`RETURN_R22R1_AMBIGUOUS_BASELINE_FIREWALL_ONLY`

## OBJECTIVE
Determine which normalized firewall component differs from the R22 rollback-journal baseline without revealing raw rules.

Compare baseline vs current for:
- UFW normalized status, when available;
- nft normalized ruleset with packet/byte counters removed;
- iptables-save normalized rules;
- ip6tables-save normalized rules.

Output only:
- component presence;
- SHA-256 hashes;
- equality result;
- bounded normalized item/line counts.

## FORBIDDEN
No R22 replay, rollback, cleanup, firewall mutation, service mutation, route mutation, provider action, recovery mutation, Clash/profile mutation, or raw firewall rule output.

## ACCEPTANCE
- If all component hashes match on a fresh read, classify the prior mismatch as transient and proceed to exact R22-owned residue/recovery reconciliation.
- If exactly one component differs, Reviewer opens a component-specific read-only diff classification Gate.
- If multiple components differ or component availability changes, remain AMBIGUOUS and continue read-only only.

`STOP_AT_REVIEWER=YES`
