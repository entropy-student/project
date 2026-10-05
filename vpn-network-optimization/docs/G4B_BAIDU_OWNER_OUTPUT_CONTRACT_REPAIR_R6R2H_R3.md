# G4-B Baidu Owner Output Contract Repair R6R2H-R3

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_OUTPUT_CONTRACT_REPAIR_R6R2H_R3`

## PREVIOUS_RESULT

`RETURN_R6R2H_R2_OUTPUT_CONTRACT_CONFIG_STATE_MISSING`

## ACCEPTED / FROZEN FROM R6R2H-R2

The R6R2H-R2 implementation is accepted except for the bounded Owner output contract defect below.

Freeze these repaired behaviors:

- exact semicolon-delimited field value is parsed once and passed explicitly to upstream setup;
- ambiguous earlier substring fixture passes;
- pinned build helper remains frozen;
- PowerShell 7.6.6 / Administrator / High-integrity and adapter path/ACL/hash preflight occur before config mutation;
- initial config must be absent or accepted pre-existing empty;
- native success requires metadata-only exact single-file shape;
- file/root Owner/ACL normalization occurs before strict R6R1 validation;
- failure reconciliation preserves pre-existing empty root, removes only run-created exact state, and preserves unproven state;
- no config content read;
- no broad recursive deletion;
- no who/provider/Owner real action in the Executor round.

Current candidate source commit:

`d441ed0bc31285311345ed3b3e847258d7de05a2`

## BLOCKING DEFECT

The active R6R2H-R2 Gate requires the Owner checkpoint to emit at minimum:

```text
BAIDU_COOKIE_AUTH_CHECKPOINT=...
BAIDU_COOKIE_AUTH_FAILURE_CODE=...
BAIDU_COOKIE_AUTH_NATIVE_EXIT=...
BAIDU_COOKIE_AUTH_CONFIG_STATE=...
BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=...
BAIDU_COOKIE_AUTH_CONTENT_READ=NO
BAIDU_COOKIE_AUTH_WHO=NOT_RUN
BAIDU_COOKIE_AUTH_UID_EMITTED=NO
```

The candidate checkpoint emits every required field except:

`BAIDU_COOKIE_AUTH_CONFIG_STATE=...`

This is a material reviewability defect. The later Reviewer must be able to distinguish the accepted pre-run config provenance from the final disposition using only bounded, non-secret Owner markers.

## OBJECTIVE

Add the missing bounded config-state classification/output and validator coverage only.

Do not redesign the accepted authentication, build, ACL normalization, or rollback logic.

## CONFIG STATE CONTRACT

Use a single bounded pre-run provenance state with only these values:

- `NOT_REACHED` — execution failed before an accepted canonical config state was classified;
- `ABSENT_PREAUTH` — canonical config root was absent before this attempt;
- `PREEXISTING_EMPTY` — canonical config root existed before this attempt and was proven safely empty.

The state describes the accepted state **before authentication mutation**. It must not be overwritten with a post-auth result. Final outcome remains in `BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION`.

Required behavior:

- initialize state to `NOT_REACHED`;
- assign `ABSENT_PREAUTH` only after the canonical root is proven absent and the exact config file precondition is accepted;
- assign `PREEXISTING_EMPTY` only after the existing root is proven real/non-reparse, empty, and passes the accepted strict config safety check;
- emit exactly one final line:
  `BAIDU_COOKIE_AUTH_CONFIG_STATE=<bounded value>`;
- no path, SID, filename, account identity, or other private data may be embedded in this marker.

## REQUIRED VALIDATION

At minimum:

```text
R6R2H_R3_R2_CORE_FROZEN=PASS
R6R2H_R3_CONFIG_STATE_OUTPUT_PRESENT=PASS
R6R2H_R3_CONFIG_STATE_ENUM_BOUNDED=PASS
R6R2H_R3_ABSENT_STATE_ASSIGNED_AFTER_PRECONDITION=PASS
R6R2H_R3_PREEXISTING_EMPTY_ASSIGNED_AFTER_STRICT_CHECK=PASS
R6R2H_R3_STATE_NOT_OVERWRITTEN_POSTAUTH=PASS
R6R2H_R3_OUTPUT_CONTRACT_COMPLETE=PASS
R6R2H_R3_FULL_R6R2H_R2_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_COOKIE_VALUES_USED=0
REAL_BAIDU_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
NETWORK_REQUESTS_TO_PROVIDER=0
STOP_AT_REVIEWER=YES
```

Validation must confirm the final checkpoint contains all eight required bounded output markers and exactly one config-state output line.

## EXECUTOR BOUNDARY

Offline only.

Forbidden:
- real authentication material;
- browser/clipboard acquisition;
- Owner real config read/write/delete;
- real provider authentication or who;
- retained Owner runtime binary creation;
- Secret/DPAPI;
- VPS/SSH/Clash/network runtime/live G4-B/G4-C.

## ALLOWED FILES

- `scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1`
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`
- this Gate if needed for implementation note only;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:
- adapter `main.go`;
- adapter tests;
- build helper;
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 sources;
- `REVIEWER_HANDOFF.md`;
- unrelated files.

## STOP

`STOP_AT_REVIEWER=YES`
