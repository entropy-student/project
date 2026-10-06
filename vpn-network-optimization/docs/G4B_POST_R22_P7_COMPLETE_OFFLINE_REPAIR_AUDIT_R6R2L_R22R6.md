# G4-B Post-R22 P7 Complete Offline Repair Audit — R6R2L-R22R6

Status: OFFLINE_REPAIR_AUDIT_REQUIRED / NO_LIVE

## GATE_ID
`G4B_POST_R22_P7_COMPLETE_OFFLINE_REPAIR_AUDIT_R6R2L_R22R6`

## PREVIOUS_RESULT
`PASS_R22R5_FAILED_RUN_RESIDUE_CLEAN`

## OBJECTIVE
Before any fresh live Gate, repair and regression-test every defect class exposed by R21/R22 that can be caught offline.

## REQUIRED REPAIR SURFACE

1. **P7 readiness semantics**
   - replace immediate single listener read-back after `systemctl enable --now` with bounded readiness polling;
   - distinguish service-not-active, listener-not-ready timeout, and listener ownership mismatch;
   - use the same bounded readiness primitive after restart.

2. **Rollback native-command diagnostics and postconditions**
   - do not collapse rollback-critical systemd failures into only `REMOTE_NATIVE_COMMAND_FAILED`;
   - record bounded allowlisted error codes;
   - tolerate a non-zero stop/disable command only when the required stopped/disabled postcondition is independently proven;
   - preserve fail-closed ownership rules.

3. **Firewall semantic normalization**
   - ignore packet/byte telemetry in both rule counter prefixes and chain-declaration suffix counters;
   - preserve chain names, policies, rule semantics and order;
   - add positive and negative fixtures proving telemetry-only change passes while semantic rule change fails.

4. **Fresh one-shot Gate binding**
   - no future live release until runner, fixture, Handoff and fresh Gate all bind the same new live Gate id;
   - explicit consumed=0 / authorized=1 / second=NO fields must be checked together;
   - fixture must fail when any one field is absent/stale.

## EVIDENCE REQUIRED BEFORE LIVE RELEASE
- PowerShell AST runner + validator PASS;
- production helper/fixture identity PASS;
- synthetic readiness sequence: delayed listener becomes ready => PASS;
- readiness timeout => specific fail-closed code;
- service failed/inactive => specific fail-closed code;
- listener non-Mihomo ownership => specific fail-closed code;
- restart uses the same readiness contract;
- rollback systemd command/postcondition positive + negative fixtures;
- iptables counter-only positive fixture;
- iptables semantic-drift negative fixture;
- existing package validator PASS;
- existing R19R1 profile parse regression PASS;
- no SSH/VPS/provider/Secret/DPAPI/Clash/network mutation.

## LIVE RELEASE
FORBIDDEN inside this Gate. A later fresh live Gate may be created only after formal Reviewer PASS of this offline audit.

`STOP_AT_REVIEWER=YES`
