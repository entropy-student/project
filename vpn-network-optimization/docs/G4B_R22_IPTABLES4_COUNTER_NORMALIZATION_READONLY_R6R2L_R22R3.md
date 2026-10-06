# G4-B R22 iptables4 Counter-Normalization Read-only Reconciliation — R6R2L-R22R3

Status: OWNER_READONLY_ACTION_REQUIRED / NO_MUTATION

## GATE_ID
`G4B_R22_IPTABLES4_COUNTER_NORMALIZATION_READONLY_R6R2L_R22R3`

## PREVIOUS_RESULT
`RETURN_R22R2_SINGLE_COMPONENT_DRIFT_IPTABLES4`

## OBJECTIVE

Determine whether the IPv4 iptables mismatch is only packet/byte counter telemetry.

For both retained baseline and fresh current `iptables-save` output:
- ignore comments;
- strip a leading `[packets:bytes]` token if present;
- strip a trailing chain-declaration counter token `[packets:bytes]` only on lines beginning with `:`;
- preserve all chain names, policies, rules, ordering and non-counter text exactly;
- compare SHA-256 and line count only.

## FORBIDDEN

No raw rules in output; no firewall/service/route mutation; no R22 replay; no rollback/cleanup; no provider/recovery/Clash/profile mutation.

## ACCEPTANCE

- semantic hash/count match => classify R22 firewall mismatch as counter-only telemetry and return remote baseline to CLEAN for the purpose of R22 rollback reconciliation;
- mismatch remains => keep AMBIGUOUS and open a narrower structural fingerprint Gate.

`STOP_AT_REVIEWER=YES`
