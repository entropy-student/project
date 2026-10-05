# G4-B Baidu Stale Pending Quarantine Reconciliation R6R2L-R17

Status: PREPARED / OWNER_AUTHORIZATION_REQUIRED / REMOTE_PROVIDER_MUTATION

## GATE_ID

`G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17`

## PREVIOUS_RESULT

`RETURN_R6R2L_R16_STALE_PENDING_PRESENT`

## R16 ACCEPTED OBSERVATION

After R15 local ACL normalization, R16 completed a read-only provider observation with corrected listing semantics:

```text
BAIDU_CONFIG_ACL=PASS
BAIDU_PINNED_CLI=PASS
BAIDU_WHO_PROCESS=PASS
BAIDU_UID_PARSE=PASS
BAIDU_UID_MATCH=PASS
BAIDU_LS_PROCESS=PASS
BAIDU_DIRECTORY_HEADER=PASS
PROJECT_FINAL_COUNT=0
PROJECT_PENDING_COUNT=1
PROJECT_UNKNOWN_COUNT=0
BAIDU_RESIDUAL_STATE=STALE_PENDING_PRESENT
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Therefore remote residual state is no longer UNKNOWN:
- exactly one project pending object exists;
- no final project object exists;
- no unknown project object exists.

R16 performed no mutation.

## WHY QUARANTINE, NOT DELETE

Permanent remote deletion has no simple rollback.

The next bounded reconciliation should therefore be reversible:
- identify the exact single pending object by the accepted strict pending-name regex;
- rename it to a non-production quarantine basename in the same recovery directory;
- verify source absent and quarantine target present;
- on any failed post-readback, rename the quarantine target back to the original pending basename.

No permanent `rm` is authorized by R17.

## OBJECTIVE

Move exactly one accepted stale pending object out of the production pending namespace without deleting ciphertext.

Accepted source shape:

```text
vpn-network-optimization-g4b-<32 lowercase hex>.vpr1.pending
```

Quarantine target must be derived from the same run-id but must not match the production project-object prefix used by residual-state checks, for example:

```text
r17-quarantine-<32 lowercase hex>.vpr1.pending
```

The exact remote names must never be printed in chat/GitHub/evidence.

## OWNER AUTHORIZATION

R17 changes remote provider state and is consequential.

```text
OWNER_R17_STALE_PENDING_QUARANTINE_AUTHORIZATION=REQUIRED
R17_EXECUTION_AUTHORIZED=NO
```

This Gate preparation does not authorize execution.

## REQUIRED PRE-MUTATION RECHECK

Immediately before any provider mutation:

- pinned BaiduPCS-Go v4.0.2 identity must pass;
- current local Baidu config ACL must pass strict readiness;
- hidden expected UID input must parse and match the current provider account;
- recovery-directory header must match;
- exact provider state must still be:
  - final=0;
  - pending=1;
  - unknown=0;
- the single pending basename must match the strict accepted regex;
- quarantine target must be absent;
- no raw provider output, UID or remote basename may be emitted.

Any drift -> stop before mutation.

## ALLOWED PROVIDER COMMANDS

Before explicit Owner authorization:
- none.

After explicit Owner authorization under a locked helper:
- `who`;
- `ls -l /vpn-network-optimization-g4b-recovery`;
- exactly one `mv` source→quarantine;
- only if rollback is required, exactly one `mv` quarantine→source.

No other provider command is authorized.

## SUCCESS READBACK

After source→quarantine:

- original production pending object count must be 0;
- final count must remain 0;
- unknown project count must remain 0;
- exact quarantine target must be present;
- no second production/project object may appear.

Expected candidate markers:

```text
R17_PRECHECK=PASS
R17_SOURCE_STATE=ONE_PENDING
R17_QUARANTINE_TARGET_PRECHECK=ABSENT
R17_REMOTE_MUTATION=MV_TO_QUARANTINE
R17_SOURCE_AFTER=ABSENT
R17_QUARANTINE_AFTER=PRESENT
PROJECT_FINAL_COUNT_AFTER=0
PROJECT_PENDING_COUNT_AFTER=0
PROJECT_UNKNOWN_COUNT_AFTER=0
R17_RESULT=PASS_CANDIDATE
R17_ROLLBACK_REQUIRED=NO
BAIDU_PERMANENT_DELETE=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## FAILURE / ROLLBACK

If mutation started and any post-readback fails:

1. rename quarantine target back to the exact original pending basename;
2. verify:
   - source pending present again;
   - quarantine target absent;
   - final=0;
   - pending=1;
   - unknown=0;
3. emit sanitized rollback markers;
4. stop.

No second forward attempt is authorized.

If rollback fails, emit:

```text
R17_RESULT=ROLLBACK_FAILED
STOP_AT_REVIEWER=YES
```

and stop hard.

## FORBIDDEN

- permanent `rm`;
- upload;
- download-from-Baidu;
- mkdir;
- login/logout/config mutation/credential refresh;
- changing or deleting the R15 local rollback journal;
- printing raw UID/stdout/stderr/remote filenames;
- DPAPI/recovery Secret read;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

## MAX ENDPOINT

After explicit Owner authorization: one bounded reversible remote quarantine move with immediate readback and mandatory Reviewer stop.

## NEXT AFTER FORMAL PASS

Only after Reviewer formally accepts R17 may a fresh read-only residual-state observation verify the production namespace is CLEAN.

A later permanent-delete decision for the quarantined ciphertext, if ever desired, must be a separate Gate.

Live G4-B retry remains blocked until the production residual state is formally CLEAN.

## STOP

`STOP_AT_REVIEWER=YES`
