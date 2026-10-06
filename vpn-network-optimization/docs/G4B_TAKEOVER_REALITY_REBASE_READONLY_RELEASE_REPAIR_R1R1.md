# G4-B Takeover Reality Rebase — Read-only Release Contract Repair R1R1

Status: REVIEWER_RETURN / OFFLINE_REPAIR_ONLY

## GATE_ID

`G4B_TAKEOVER_REALITY_REBASE_READONLY_RELEASE_REPAIR_R1R1`

## PREVIOUS_RESULT

`RETURN_R1_RELEASE_MARKER_CONFLICT`

## REVIEWER_FINDING

The R1 helper/validator candidate at commit `812f18980f9f10d22e2c8399e7022bcfe347c387` is **not released** for Owner execution.

The read-only implementation is otherwise directionally acceptable, but `Get-SourceIdentity` treats:

`FRESH_LIVE_GATE_RELEASED=YES`

as the Reviewer release condition for this read-only checkpoint.

That marker belongs to a future consequential G4-B live Gate. Setting it to YES merely to run a read-only reality checkpoint would make the canonical Handoff falsely state that a live Gate had been released.

The offline validator did not detect this semantic conflict.

## OBJECTIVE

Repair only the release contract so the R1 helper can be released independently from any live G4-B authorization.

## REQUIRED REPAIR

Use one dedicated current-Gate marker:

`R1_OWNER_READONLY_CHECKPOINT_RELEASED=YES|NO`

The helper must require all of:

```text
GATE_ID=G4B_TAKEOVER_REALITY_REBASE_READONLY_R1
R1_OWNER_READONLY_CHECKPOINT_RELEASED=YES
FRESH_LIVE_GATE_RELEASED=NO
```

before any SSH or Provider read is allowed.

Do not reinterpret or reuse `FRESH_LIVE_GATE_RELEASED` as the read-only checkpoint release switch.

## VALIDATOR REQUIREMENTS

The existing R1 offline validator must be extended with behavior/static fixtures proving:

- dedicated read-only release = YES + fresh live release = NO -> source release contract can pass;
- dedicated read-only release = NO -> fail closed before external read;
- missing dedicated marker -> fail closed before external read;
- `FRESH_LIVE_GATE_RELEASED=YES` -> fail closed for this Gate;
- Gate ID mismatch -> fail closed;
- no SSH/VPS/Provider action occurs during validation;
- existing AST/read-only allowlist/mutation-negative/Secret-output/strict-SSH/provider-read-only fixtures remain PASS.

Prefer exercising an AST-extracted production release-contract helper or another direct production-function fixture. Do not satisfy this Gate with documentation/string presence checks alone.

## FROZEN SCOPE

Do not redesign the R1 helper.

Do not modify:

- live runner;
- G4-B templates;
- protocol/runtime behavior;
- Baidu recovery semantics;
- SSH target;
- Windows network behavior;
- R20+ historical files other than any bounded Executor handoff/evidence append needed for this repair.

R20+ remains reference-only.

## MAX_ENDPOINT_THIS_ROUND

```text
repair R1 release contract
-> run offline validator
-> persist bounded Evidence/Executor Handoff
-> STOP_AT_REVIEWER
```

No Owner checkpoint, SSH, VPS, Provider, Secret, DPAPI, Clash or network target action.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE only when:

```text
POWERSHELL_AST=PASS
READONLY_RELEASE_POSITIVE=PASS
READONLY_RELEASE_NOT_RELEASED_NEGATIVE=PASS
READONLY_RELEASE_MISSING_NEGATIVE=PASS
LIVE_GATE_RELEASE_CONFLICT_NEGATIVE=PASS
GATE_ID_MISMATCH_NEGATIVE=PASS
EXISTING_R1_FIXTURES=PASS
OWNER_CHECKPOINT_EXECUTED=NO
SSH_VPS_PROVIDER_ACTIONS=0
SECRET_OR_DPAPI_ACCESSED=NO
NETWORK_OR_CLASH_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## OWNER_ONLY_ACTIONS

NONE.

## REVIEWER_TO_EXECUTOR_RELAY

Read only this Gate plus the current R1 helper/validator and current `REVIEWER_HANDOFF.md`. Make the smallest possible two-file source repair plus bounded execution-record updates. Do not reread or modify the live runner or historical R20-R22 chain.

## EXECUTOR_TO_REVIEWER_RELAY

Use the standard short completion packet and include final helper/validator blobs. Mandatory Reviewer stop.
