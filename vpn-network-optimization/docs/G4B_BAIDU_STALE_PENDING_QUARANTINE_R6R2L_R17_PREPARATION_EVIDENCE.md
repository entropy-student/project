# G4-B R17 Reviewer Preparation Evidence

Date: 2026-10-06  
Gate: `G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17`  
Provenance: DIRECT_GITHUB_READBACK + OWNER_CHAT_AUTHORIZATION

## Authorization

Owner explicitly authorized the current R17 Gate in chat:

```text
OWNER_R17_STALE_PENDING_QUARANTINE_AUTHORIZATION=GRANTED
AUTHORIZED_SCOPE=CURRENT_R17_GATE_ONLY
PERMANENT_DELETE_AUTHORIZED=NO
LIVE_G4B_AUTHORIZED_BY_THIS_GRANT=NO
G4C_AUTHORIZED_BY_THIS_GRANT=NO
```

The authorization covers the already-declared R17 maximum endpoint: one bounded reversible source→quarantine rename after locked-source and preflight validation, with at most one exact quarantine→source rollback when required.

## Locked implementation

```text
R17_BASE_GATE_BLOB=1b02f0e258b7b2b3e71513f7760f200660bfbf6a
R17_HELPER_PATH=scripts/g4b-baidu-stale-pending-quarantine-r17.ps1
R17_HELPER_BLOB=3d7797a21c31fb805993530b28d674db4cdf288c
R17_VALIDATOR_PATH=scripts/g4b-baidu-stale-pending-quarantine-r17-validator.ps1
R17_VALIDATOR_BLOB=359cddf73075c090396a49d106022efd3f078029
```

## Reviewer source review

Fresh GitHub read-back confirms:

- helper default mode is non-mutating `Validate`;
- mutation path requires explicit `-OwnerAuthorized`;
- Provider command allowlist is exactly `who | ls | mv`;
- there is no `rm`, upload, download-from-Baidu, mkdir, login/logout or config-mutation provider action;
- pre-mutation state requires final=0, pending=1, unknown=0;
- source basename must match the strict accepted pending regex;
- quarantine basename is derived from the same run id and does not use the production project-object prefix;
- exact quarantine target must be absent before mutation;
- forward success requires source absent, exact quarantine present, final=0, pending=0, unknown=0;
- rollback performs a fresh read-only precheck and only moves quarantine→source when the exact rollback shape is proven;
- successful rollback requires source present, quarantine absent, final=0, pending=1, unknown=0;
- local Baidu config validation uses the accepted R6R1 strict ACL invariants: exact Owner, no Deny ACE, complete Allow-principal allowlist, and effective Owner required-read rights;
- raw UID/provider output/remote filenames are not part of the bounded result markers;
- R15 rollback journal is not read, changed or deleted;
- helper always emits `BAIDU_PERMANENT_DELETE=NO` and mandatory Reviewer stop markers.

The offline validator is limited to AST/source-contract checks, synthetic listing fixtures and the helper's default non-mutating validation mode. A Reviewer fresh-read caught and repaired one pre-execution StrictMode string-interpolation defect in the validator's literal Mode check; no Owner/provider action used the superseded validator blob. The current locked validator does not read Owner config or invoke a Provider action.

## Current execution state

```text
R17_HELPER_LOCKED=YES
R17_VALIDATOR_LOCKED=YES
R17_OWNER_AUTHORIZATION=GRANTED
R17_OWNER_CHECKPOINT_EXECUTED=NO
R17_PROVIDER_MUTATION=NO
R17_PERMANENT_DELETE=NO
R15_ROLLBACK_JOURNAL_ACTION=NONE
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## Next checkpoint

Owner-local one-shot checkpoint:

1. safe fast-forward canonical `main`;
2. lock the R17 Gate/helper/validator blobs;
3. PowerShell AST-parse helper and validator;
4. run the offline validator and require PASS;
5. execute the helper exactly once with `-Mode Run -OwnerAuthorized`;
6. provide only the helper's sanitized markers to Reviewer;
7. do not rerun after any mutation-started/ambiguous result without Reviewer reconciliation.

No additional Owner authorization is required for this exact R17 checkpoint because the Owner already authorized the current Gate. Any action beyond R17 still requires its own Gate/authorization.


## Reviewer pre-execution repair — 2026-10-06

Fresh Reviewer reconciliation before Owner execution found and repaired two fail-closed gaps:

1. canonical Baidu UID parsing now requires **exactly one** canonical UID line rather than accepting the first match;
2. quarantine-target absence now rejects a same-name directory as well as a same-name file.

The same repair also narrows Provider command arguments:
- `who` accepts zero arguments only;
- `ls` accepts only `-l /vpn-network-optimization-g4b-recovery`;
- `mv` accepts only the derived source→quarantine pair or its exact quarantine→source rollback reversal.

Listing classification now counts exact files/directories separately and treats project-prefix directories as unknown project state. The offline validator adds matching static guards plus same-name quarantine-directory and project-prefix-directory negative fixtures.

No Owner-local helper execution, Provider command, config read, Secret/DPAPI access, SSH/VPS action, network mutation, or R17 provider mutation occurred during this repair.

```text
PRE_REPAIR_HELPER_BLOB=dfb90be851eaf2bdc8ed7f84ec2beeb2d591a3b0
PRE_REPAIR_VALIDATOR_BLOB=45b660a1faf6ace3be5bff840c7daa2ff519aea3
R17_HELPER_BLOB=3d7797a21c31fb805993530b28d674db4cdf288c
R17_VALIDATOR_BLOB=359cddf73075c090396a49d106022efd3f078029
R17_OWNER_AUTHORIZATION=GRANTED_UNCHANGED_SCOPE
R17_OWNER_CHECKPOINT_EXECUTED=NO
R17_PROVIDER_MUTATION=NO
STOP_AT_REVIEWER=YES
```


## Subsequent Reviewer hold — R17R1

A later Reviewer reconciliation intentionally suspended release of the prepared R17 Owner checkpoint pending local executable code-usability validation.

```text
R17_OWNER_AUTHORIZATION=GRANTED_RECORDED
R17_EXECUTION_RELEASED=NO
R17_PROVIDER_MUTATION=NO
R17R1_GATE=docs/G4B_BAIDU_STALE_PENDING_QUARANTINE_CODE_VALIDATION_R6R2L_R17R1.md
R17R1_GATE_BLOB=05efff190c10e4649e10acb9814f5f0d7d705b95
SUSPENDED_PARENT_R17_GATE_BLOB=09fd5086dc6f6121fdbd3006553560b19019b211
STARTING_R17_HELPER_BLOB=3d7797a21c31fb805993530b28d674db4cdf288c
STARTING_R17_VALIDATOR_BLOB=359cddf73075c090396a49d106022efd3f078029
OWNER_ACTION_REQUIRED=NONE
EXECUTOR_ACTION_REQUIRED=LOCAL_OFFLINE_CODE_VALIDATION
```

Reason: the project now requires executable local evidence that the complete helper/validator are reliably usable before any consequential provider action. The known stale-`$LASTEXITCODE` validator risk must be regression-tested, and forward/rollback behavior must receive offline executable evidence or return PARTIAL/RETURN. Earlier preparation evidence remains historical evidence of what was reviewed at that time; it is not a current release-to-run decision.

No Provider action, Owner config read, Secret/DPAPI access, SSH/VPS action, network mutation, or R17 Run-mode execution occurred as part of this hold.


## Final Reviewer release after R17R1 — 2026-10-06

```text
R17R1_RESULT=PASS_R17R1_OFFLINE_CODE_VALIDATION
R17_FINAL_GATE_BLOB=7d850014c1845a21664f26e503f9da63f4446e6d
R17_FINAL_HELPER_BLOB=9c910628932c22c448c822437fd53e0b71804a9c
R17_FINAL_VALIDATOR_BLOB=7a555224720ce65b724012c425b58d6aad2c9026
R17_OWNER_AUTHORIZATION=GRANTED_UNCHANGED_SCOPE
R17_EXECUTION_RELEASED=YES
R17_PROVIDER_MUTATION_EXECUTED=NO
```

R17R1 produced executable offline evidence for default non-mutating behavior, listing positive/negative fixtures, stale-LASTEXITCODE handling, source/target shape guards, forward success, rollback success, rollback marker propagation/type safety and cleanup. Final Reviewer direct source readback confirms the production Provider allowlist remains exactly who/ls/mv and permanent delete remains absent.

This release does not authorize any action outside the original R17 quarantine Gate.
