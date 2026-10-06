# G4-B Takeover Reality Rebase — Read-only R1

Status: REVIEWER_PREPARED / EXECUTOR_IMPLEMENTATION_REQUIRED

## GATE_ID

`G4B_TAKEOVER_REALITY_REBASE_READONLY_R1`

## WHY_THIS_GATE_EXISTS

The new Reviewer performed a fresh takeover review after the Owner explicitly downgraded R20 and later material to reference-only status.

The trusted engineering anchor is the formal R19R1 PASS at commit:

`85a33288c23e794d200ddf5e48d5bb7ae0d839c0`

Fresh review found the current `REVIEWER_HANDOFF.md` internally inconsistent: its current-gate block points to R22R6 while later execution/rollback/next-step sections still instruct R22R1. Therefore the post-R20 dashboard cannot be used as current project truth without fresh reconciliation.

R20+ records, source repairs and evidence are **not deleted**. They are supporting material only until a current Reviewer independently re-proves the specific fact being reused.

## OBJECTIVE

Re-establish one authoritative current reality snapshot before any further G4-B live attempt, using one bounded Owner-local read-only checkpoint.

The checkpoint must answer, without mutation:

1. Is the Windows production/rollback baseline still healthy?
2. Does any persistent G4-B REALITY/profile/recovery runtime exist locally?
3. Does any persistent G4-B REALITY/service/runtime/transaction residue exist on the SFO3 VPS?
4. Is the Baidu production recovery namespace clean, occupied, or ambiguous?
5. Can the project safely enter a newly designed G4-B live Gate, or is a bounded reconciliation/cleanup Gate required first?

## TRUST BOUNDARY

### Accepted without replay

The following R19R1-and-earlier facts remain accepted unless fresh evidence directly contradicts them:

- WireGuard is the current production/rollback baseline.
- HY2 is already validated and remains the intended PRIMARY target.
- REALITY Mihomo v1.19.31 protocol interoperability over public TCP/443 was previously proven by a temporary canary.
- G4-B0 proved Mihomo `interface-name` bypass for HY2 on the current Owner host without a persistent VPS /32 route.
- G3-C real HY2-in-Clash canary passed.
- R19 returned before persistent remote mutation.
- R19R1 repaired the HY2 certificate-fingerprint rendering defect and executable local Mihomo parse.
- Owner final v1 sequence remains:
  `G4-B -> G4-C three-role ChatGPT smoke -> G4-D WireGuard-in-Clash -> disable standalone WG after G4-D PASS -> MVP v1 seal`.

### Reference-only until independently re-proven

All R20/R21/R22 execution-state claims, cleanup claims, authorization counters, later live-runner acceptance claims, and post-R20 Handoff state.

Post-R20 source changes may be reused only after the exact behavior is independently reviewed/tested. In particular, a post-R20 PASS marker alone is not sufficient.

## MAX_ENDPOINT_THIS_ROUND

```text
fresh main/read-back
-> implement one bounded read-only takeover helper
-> offline AST/static/negative validation
-> Reviewer source inspection
-> Owner runs exactly one read-only checkpoint
-> classify CURRENT_REALITY
-> persist sanitized Evidence/Handoff
-> STOP_AT_REVIEWER
```

No live G4-B mutation, rollback, cleanup or retry is part of R1.

## TARGET_AND_SCOPE

### Owner Windows host — read-only

Prove:

- PowerShell/runtime identity needed by the helper.
- canonical repository/main/source identity;
- WireGuard manager/tunnel/adapter health;
- Clash Verge service health;
- system proxy OFF;
- Clash/Mihomo TUN count = 0;
- no persistent route is created or removed;
- count/metadata-only state for:
  - G4-B local runtime directories;
  - G4-B rollback journals;
  - `reality-g4b.dpapi`;
  - local pending recovery artifacts;
  - persistent `SELF-VPN-V1` profile candidates.
- Do not emit profile contents, Secret values, hashes of Secrets, recovery plaintext, provider raw output, or private identifiers.

A profile candidate may be identified from project-owned filename/metadata. If identity would require reading Secret-bearing profile content, return `UNKNOWN`; do not print or broadly scan the content.

### SFO3 VPS — read-only strict SSH

Use the accepted strict SSH trust model and query only metadata/runtime state.

Prove:

- exact target hostname / Ubuntu 24.04 identity;
- WireGuard service + UDP/51820 health;
- HY2 service + UDP/8443 health;
- TCP/443 listener count and safe ownership class;
- REALITY systemd load/active/enabled state;
- existence only for the project REALITY binary/runtime/Secret-config/unit paths;
- runtime user/group existence;
- project G4-B transaction/temp directory counts;
- no mutation command, daemon reload, service action, user/group action, file write/remove, firewall action, route action or package action.

Do not read or emit REALITY Secret config contents.

### Baidu recovery namespace — read-only

Use the already authenticated Owner-local configuration only after the helper proves its metadata/ACL boundary.

Allowed Provider calls are limited to the minimum read-only identity/listing operations needed to classify the fixed production namespace.

Output only bounded classifications/counts:

- authenticated identity check = PASS / FAIL / UNKNOWN; never output UID/username/raw `who`;
- fixed recovery directory readable = YES / NO;
- final object count;
- strict pending-object count;
- unknown project-object count;
- retained historical quarantine objects are classified separately and do not count as production pending/final.

No upload/download/mv/rm/mkdir/login/logout/config mutation is allowed.

If exact intended account identity cannot be proven without exposing a private identifier, stop with `PROVIDER_IDENTITY_CONFIRMATION_REQUIRED` rather than assuming a clean namespace.

## APPLICABLE_CRITICAL_CONSTRAINTS

- WireGuard stays available throughout.
- HY2 is not modified.
- system proxy stays OFF.
- TUN stays OFF.
- no route/firewall/service/profile/provider/recovery mutation.
- no Secret/DPAPI plaintext read merely to establish state.
- no broad profile/config scans.
- R20/R21/R22 are never replayed.
- current post-R20 runner is not released for live execution by this Gate.
- no G4-C/G4-D action.
- one Owner-local atomic checkpoint only after Reviewer accepts its source.

## REQUIRED_EVIDENCE

Executor implementation stage:

```text
POWERSHELL_AST=PASS
READONLY_COMMAND_ALLOWLIST=PASS
WRITE_COMMAND_NEGATIVE_SCAN=PASS
SSH_STRICT_TRUST_CONTRACT=PASS
LOCAL_SECRET_OUTPUT_NEGATIVE=PASS
PROVIDER_MUTATION_NEGATIVE=PASS
REMOTE_MUTATION_NEGATIVE=PASS
FIXTURE_CLEAN=PASS
```

Owner checkpoint stage must emit only sanitized bounded markers sufficient to determine:

```text
WINDOWS_WG_HEALTHY
WINDOWS_CLASH_HEALTHY
SYSTEM_PROXY_OFF
TUN_OFF
LOCAL_G4B_RUNTIME_COUNT
LOCAL_G4B_JOURNAL_COUNT
LOCAL_REALITY_RECOVERY_FINAL_PRESENT
LOCAL_REALITY_RECOVERY_PENDING_COUNT
SELF_VPN_V1_PROFILE_CANDIDATE_COUNT

VPS_IDENTITY
VPS_WG_HEALTHY
VPS_HY2_HEALTHY
VPS_TCP443_COUNT
VPS_TCP443_OWNER_CLASS
VPS_REALITY_SERVICE_LOAD
VPS_REALITY_SERVICE_ACTIVE
VPS_REALITY_SERVICE_ENABLE
VPS_REALITY_BINARY_PRESENT
VPS_REALITY_RUNTIME_PRESENT
VPS_REALITY_SECRET_CONFIG_PRESENT
VPS_REALITY_UNIT_PRESENT
VPS_REALITY_RUNTIME_USER_PRESENT
VPS_REALITY_RUNTIME_GROUP_PRESENT
VPS_G4B_TXN_COUNT
VPS_G4B_TMP_COUNT

BAIDU_IDENTITY_CHECK
BAIDU_RECOVERY_DIRECTORY_READABLE
BAIDU_FINAL_COUNT
BAIDU_PENDING_COUNT
BAIDU_UNKNOWN_PROJECT_COUNT
BAIDU_QUARANTINE_COUNT

CURRENT_REALITY
LOCAL_MUTATION=NO
REMOTE_MUTATION=NO
PROVIDER_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## CLASSIFICATION

### CLEAN_BASELINE

Only when all of the following are independently proven:

- Windows WG and Clash healthy; proxy OFF; TUN OFF;
- no active/local G4-B runtime or pending recovery artifact;
- no persistent REALITY local recovery final;
- no persistent SELF-VPN-V1 profile candidate;
- VPS WG/HY2 healthy;
- TCP/443 has no persistent G4-B REALITY listener;
- REALITY service/paths/user/group/transaction/temp artifacts are absent;
- Baidu identity is proven for the intended account;
- production recovery namespace final=0, pending=0, unknown=0.

Consequence: Reviewer may design one new clean G4-B live Gate from the trusted R19R1 baseline plus separately re-reviewed source improvements.

### PROJECT_RESIDUAL_PRESENT

Known project-owned residue exists and can be bounded without ambiguity.

Consequence: STOP. Reviewer creates one exact reconciliation/cleanup Gate. No live deployment retry.

### AMBIGUOUS_BASELINE

Any target identity ambiguity, foreign TCP/443 listener, unknown provider object, uncertain account identity, profile ambiguity, unhealthy WG/HY2 baseline, unknown project object ownership, or helper/readback failure.

Consequence: STOP. Reviewer narrows only the ambiguous fault domain.

## ACCEPTANCE_CRITERIA

R1 PASS means **current reality is authoritatively classified**. It does not mean G4-B itself passes.

Formal R1 PASS requires:

- helper source and offline fixtures are Reviewer-inspected;
- exactly one read-only Owner checkpoint completes;
- required evidence is reviewable and sanitized;
- one of the three classifications above is justified;
- canonical Handoff is updated to that fresh state;
- no mutation occurred.

## ROLLBACK_STATUS_OR_PLAN

Not applicable to target state because the checkpoint is read-only.

If helper preparation changes repository source/docs, source rollback is the exact Git revert of only R1-owned files.

## OWNER_ONLY_ACTIONS

NONE until Executor returns the prepared helper and Reviewer formally releases the read-only checkpoint.

After release, Owner performs exactly one atomic PowerShell checkpoint and returns only its sanitized output.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

- this Gate;
- current `REVIEWER_HANDOFF.md`;
- trusted R19R1 anchor where exact constants/contracts are needed;
- the minimum existing helper/source sections needed to implement the checkpoint.

Do **not** reconstruct R20-R22 chronology or copy their acceptance conclusions. Existing R22 read-only helper may be consulted only as reference for strict SSH/read-only query patterns; do not inherit its run-ID/time-window/journal assumptions.

Implementation must be a new small helper, not another patch to the live runner.

## EXECUTOR_TO_REVIEWER_RELAY

Use the standard completion packet.

Required summary:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：new takeover read-only helper + bounded fixtures only.
验证：AST/read-only allowlist/negative mutation/Secret-output checks.
问题：NONE or exact blocker.
回滚：source-only; target state untouched.
请 Reviewer 检查：helper scope, output contract, zero-mutation proof.
Owner 转交：NONE.
```

Mandatory stop before Owner execution.
