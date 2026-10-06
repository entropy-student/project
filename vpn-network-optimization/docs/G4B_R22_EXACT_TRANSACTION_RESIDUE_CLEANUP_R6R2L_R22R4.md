# G4-B R22 Exact Transaction Residue Cleanup — R6R2L-R22R4

Status: OWNER_BOUNDED_MUTATION_REQUIRED / REVIEWER_STOP

## GATE_ID
`G4B_R22_EXACT_TRANSACTION_RESIDUE_CLEANUP_R6R2L_R22R4`

## PREVIOUS_RESULT
`PASS_R22R3_COUNTER_ONLY_TELEMETRY`

## OBJECTIVE
Remove only the retained R22 transaction directory after exact ownership and clean-surface verification.

## REQUIRED PRE-MUTATION PROOF
- unique local R22 rollback journal in the bounded execution window;
- remote transaction path derived only from that journal run-id;
- transaction directory root:root mode 0700;
- exactly two children: `state.json` and `mihomo-reality-vpn-network-optimization.service`;
- state run-id exact match and `pass_candidate=false`;
- all R22 creation flags expected through P7 are true;
- staged unit first-line run-id marker exact match;
- persistent binary/runtime/secret/unit/temp/user/group absent;
- REALITY service absent/inactive, TCP/443=0, Mihomo process count=0;
- WG and HY2 active with expected UDP listeners.

## ALLOWED MUTATION
Delete exactly:
1. the R22 staged unit inside the R22 transaction directory;
2. the R22 transaction `state.json`;
3. the now-empty R22 transaction directory.

## FORBIDDEN
No R22 replay; no service/firewall/route/user/group mutation; no binary/runtime/config deletion; no recovery pending/final mutation; no Baidu action; no Clash/profile/local-network mutation; do not delete the local rollback journal.

## ACCEPTANCE
Fresh post-clean read-back proves transaction absent, persistent REALITY surface absent, TCP/443 empty, Mihomo absent, WG/HY2 healthy, and local rollback journal still retained.

`STOP_AT_REVIEWER=YES`
