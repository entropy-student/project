# G4-B Baidu Owner Auth Readiness ACL Repair R6R1

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1`

## PREVIOUS_RESULT

`RETURN_R6_ACL_INVARIANT_INCOMPLETE`

## REVIEWER_RECONCILIATION

R6 is **not** rejected as a whole. Reviewer independently accepted these R6 boundaries:

- no credential parameters or login command;
- pinned BaiduPCS-Go v4.0.2 archive SHA-256 is verified before ZIP open;
- checkpoint dot-source does not invoke the real checkpoint;
- future provider action is limited to one read-only `who`;
- raw provider output and UID are not emitted;
- account mismatch and unauthenticated states fail closed / return Owner action required as designed;
- runtime cleanup is bounded;
- R6 execution itself performed zero real Baidu, config, Secret, VPS, network, Clash, route, proxy, TUN, service, or G4-C actions;
- synthetic ACL injection into the production predicate is an acceptable fixture technique.

Formal PASS is blocked only because the production Baidu-config ACL predicate does not yet cover the full Governance v0.2.7 ACL invariant. It currently proves Owner identity and rejects three broad Allow SIDs, but does not explicitly validate inheritance, Deny rules, a complete allowed-principal set, or the Owner's required read rights.

## OBJECTIVE

Repair only the Baidu-config ACL safety predicate and its synthetic fixtures so the future Owner-local readiness checkpoint validates the actual Governance ACL invariant before invoking `who`.

Do not redesign the checkpoint or replay already-accepted R6 behavior.

## MAX_ENDPOINT_THIS_ROUND

```text
fresh canonical source read-back
-> narrow ACL predicate repair
-> synthetic ACL fixtures using the exact production predicate
-> full R6 regression validator
-> PowerShell AST + Secret scan
-> Evidence + Executor Handoff persistence
-> GitHub fresh read-back
-> STOP_AT_REVIEWER
```

No real Owner checkpoint, Baidu CLI/provider action, config read, credential/Secret/DPAPI access, network request, VPS/SSH, Clash, service, route, proxy, TUN, or G4-C action.

## REQUIRED REPAIR

The production Baidu config ACL check must, for every inspected config directory/file item:

1. preserve exact Owner SID verification;
2. explicitly inspect both direct and inherited ACEs rather than treating inheritance as irrelevant;
3. use an explicit safe Allow principal set limited to:
   - current Owner SID;
   - LocalSystem `S-1-5-18`;
   - Builtin Administrators `S-1-5-32-544`;
4. reject any other Allow principal, including Everyone, Authenticated Users, Builtin Users, or arbitrary unrelated SIDs;
5. reject Deny ACEs fail-closed for this protected credential-config boundary;
6. prove the current Owner SID has at least the rights required for read-only config use on every inspected item (minimum `ReadAndExecute`/equivalent required read/list/traverse rights);
7. continue to reject reparse points and unsafe config locations;
8. inspect metadata/ACL only; do not read/copy/print config contents.

Do not require a fixed ACE count. Direct vs inherited representation may vary; the invariant above is what matters.

### Fixture rule

The Executor does **not** need to mutate a real Windows DACL to create negative cases. Synthetic ACE/rule objects may be passed into the exact same production ACL predicate. This is preferred over requiring privileges merely to manufacture an unsafe filesystem ACL.

Required synthetic cases:

```text
R6R1_ACL_SAFE_OWNER_ONLY=PASS
R6R1_ACL_SAFE_OWNER_SYSTEM_ADMINS=PASS
R6R1_ACL_INHERITED_SAFE_RULES_REVIEWED=PASS
R6R1_ACL_BROAD_ALLOW_REJECTED=PASS
R6R1_ACL_ARBITRARY_ALLOW_REJECTED=PASS
R6R1_ACL_DENY_REJECTED=PASS
R6R1_ACL_OWNER_RIGHTS_MISSING_REJECTED=PASS
R6R1_ACL_OWNER_MISMATCH_REJECTED=PASS
```

Then rerun the complete accepted R6 validator and require all prior R6 markers to remain PASS.

## ALLOWED FILES

Executor may modify only:

- `scripts/g4b-baidu-auth-readiness-checkpoint.ps1`
- `scripts/g4b-baidu-auth-readiness-validator.ps1`
- `docs/G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`;
- accepted R5R1 runner/fixture/package;
- R6 Gate;
- templates and unrelated project files.

## LOCKED INPUT IDENTITIES

```text
R6_GATE_BLOB=9b4822bbf293e055831f7cc911f98e404695e0ac
R6_CHECKPOINT_BLOB=18c0cfc397939930b7556b51153f27a63de85ae0
R6_VALIDATOR_BLOB=b7d5c2162db54ad92bd910035d33a03dc2027546
R6_FINAL_TIMING_COMMIT=34f0bd2c3a6b5452aa91578176fb17278a796689
```

If these project files have materially drifted, RETURN `RETURN_PREFLIGHT_DRIFT`. Unrelated repository commits do not count as project drift.

## REQUIRED VALIDATION

Require:

```text
R6R1_ACL_SAFE_OWNER_ONLY=PASS
R6R1_ACL_SAFE_OWNER_SYSTEM_ADMINS=PASS
R6R1_ACL_INHERITED_SAFE_RULES_REVIEWED=PASS
R6R1_ACL_BROAD_ALLOW_REJECTED=PASS
R6R1_ACL_ARBITRARY_ALLOW_REJECTED=PASS
R6R1_ACL_DENY_REJECTED=PASS
R6R1_ACL_OWNER_RIGHTS_MISSING_REJECTED=PASS
R6R1_ACL_OWNER_MISMATCH_REJECTED=PASS
R6_FULL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_BAIDU_ACTIONS=0
NETWORK_REQUESTS=0
OWNER_CONFIG_READ=NO
LIVE_G4B_ACTIONS=0
STOP_AT_REVIEWER=YES
```

## TIMING

```text
ESTIMATED_EXECUTION_TIME=10-20 minutes
TIMING_RECORD_REQUIRED=YES
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
```

Capture `ROUND_STARTED_AT` before the first preflight/sync. If the round exceeds 20 minutes, record the evidence-backed cause.

## ACCEPTANCE

R6R1 PASS_CANDIDATE requires the complete ACL invariant above plus all previously accepted R6 non-ACL behavior with zero live actions.

STOP_AT_REVIEWER. Do not run the Owner checkpoint.
