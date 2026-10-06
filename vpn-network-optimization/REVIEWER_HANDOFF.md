# VPN Network Optimization — REVIEWER HANDOFF

> Canonical branch: `main`
> Active implementation: 3x-ui fast path
> Legacy archive: `docs/archive/LEGACY_PROJECT_INDEX_2026-10-06.md`

## PROJECT_GOAL

Deploy three 3x-ui-managed nodes on fresh DigitalOcean VPS `143.198.159.233`, consume them through Mihomo/Clash Verge, validate all three, then cut over and seal.

## PROJECT_STAGE

```text
P0 Fresh VPS trust bootstrap + 3x-ui install      PASS
P1 Three inbounds + shared client                 PASS
P2 Secure Mihomo delivery                         PASS
P2R1 Direct Executor AppData repair               SUPERSEDED_NOT_EXECUTED
P2R2 Server stage + Owner-host materialization    PASS
P2R2C Remote transfer cleanup                     DEFERRED_TO_P4
P3 ChatGPT three-node functional smoke             IN_PROGRESS
P4 Final cutover + backup + seal                  PENDING
```

## ACCEPTED SERVER STATE

The remote/server half of P2 remains accepted:

- target `143.198.159.233`;
- valid bare-IP HTTPS certificate;
- normal TLS validation;
- certificate auto-renewal;
- TLS Mihomo subscription on 2096;
- three-node endpoint previously returned 200 and parsed;
- three P1 inbounds/client remain healthy;
- admin panel loopback-only;
- old VPS `24.199.118.137` untouched.

## OWNER READ-BACK CONTRADICTION

P2 claimed Owner-local files under `%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath`.

Owner independently searched the real Windows session and found neither `subscription.url` nor `self-vpn-3xui.yaml`.

Therefore direct Executor writes into Owner `AppData` are not accepted for this project.

## GOVERNANCE APPLICATION

Per current canonical Governance `vps-project-governance/VNEXT.md` section 11B:

- same absolute path in sandbox/container/redirected runtime does not prove real-host state;
- Windows path virtualization/redirected app storage must be ruled out;
- host-local write requires machine/user/effective privilege + target identity and same-target host-local read-back;
- Owner-local checkpoint is one-shot/minimal and designed by Reviewer/Executor, not interactively debugged by Owner.

Project-specific enforcement from this point:

```text
OWNER_PROFILE_PATH_DIRECT_EXECUTOR_WRITE_TRUSTED=NO
OWNER_PROFILE_MATERIALIZATION_CHANNEL=OWNER_ATOMIC_CHECKPOINT
APPDATA_PATH_DISCOVERY_BY_EXECUTOR=FORBIDDEN_FOR_THIS_REPAIR
```

## CURRENT_GATE

```text
GATE_ID=3XUI_FASTPATH_P3R1_CHATGPT_THREE_NODE_SMOKE
STATE=REVIEWER_RELEASED_OWNER_INTERACTIVE
P2_FORMAL_PASS=YES
NEW_3XUI_SUBSCRIPTION_IMPORTED=YES
HY2_SMOKE=UNVERIFIED
WG_SMOKE=NOT_TESTED
REALITY_SMOKE=NOT_TESTED
API_OPENAI_401_PROBE=EXCLUDED_BASELINE_RESET
OWNER_INTERACTION_REQUIRED=YES
SERVER_MUTATION_ALLOWED=NO
P4_RELEASED=NO
MANDATORY_REVIEW_STOP=YES
```

Canonical Gate:
`docs/3X_UI_P2R2_SERVER_STAGE_OWNER_MATERIALIZE.md`

Supersede decision:
`docs/REVIEWER_DECISION_P2R1_SUPERSEDED_OWNER_HOST_MATERIALIZATION.md`

## CRITICAL_CONSTRAINTS

- Executor must not discover, inspect or write `C:\Users\34707\AppData` in P2R2 Phase A;
- Executor only creates two root-only transfer files on new VPS;
- after Phase A PASS_CANDIDATE, Reviewer supplies one atomic Owner PowerShell materialization checkpoint;
- Owner is not asked to debug paths;
- formal P2 PASS requires same Owner-session exact-path read-back;
- no Secret output;
- no Clash import/activation yet;
- no system proxy/TUN/WireGuard/route mutation;
- no old VPS mutation.

## NEXT_STEP

Phase A and Owner-host materialization are accepted. Remote transfer cleanup is explicitly deferred to P4 and does not block P3. P3 is now re-released for Clash import and three-node functional smoke.

## OWNER_ACTION_REQUIRED

Reviewer directly guides Owner through HY2 -> WG -> REALITY: verify new-VPS egress via explicit Clash SOCKS, then briefly enable system proxy and refresh/send one normal ChatGPT message per node. No Codex required.

## EVIDENCE_POINTERS

- P2 Evidence: `results/3XUI_FASTPATH_P2_SECURE_MIHOMO_DELIVERY_2026-10-06_EXECUTOR_R1.md`
- Initial reconciliation: `docs/REVIEWER_RECONCILIATION_P2_LOCAL_ARTIFACT_MISSING_2026-10-06.md`
- P2R1 supersede: `docs/REVIEWER_DECISION_P2R1_SUPERSEDED_OWNER_HOST_MATERIALIZATION.md`
- Active Gate: `docs/3X_UI_P2R2_SERVER_STAGE_OWNER_MATERIALIZE.md`
- Phase A PASS: `docs/REVIEWER_DECISION_P2R2_PHASE_A_SERVER_STAGE_PASS.md`
- Phase B RETURN reconciliation: `docs/REVIEWER_RECONCILIATION_P2R2_PHASE_B_FINALIZE_LOCAL_RETURN.md`
- Local materialization accepted: `docs/REVIEWER_RECONCILIATION_P2R2_LOCAL_MATERIALIZATION_ACCEPTED.md`
- Deferred cleanup Gate: `docs/3X_UI_P2R2C_REMOTE_STAGE_CLEANUP.md`
- P2 PASS with deferred cleanup: `docs/REVIEWER_DECISION_P2_PASS_REMOTE_CLEANUP_DEFERRED.md`
- Active P3 Gate: `docs/3X_UI_P3_CLASH_IMPORT_THREE_NODE_SMOKE.md`
- P2R2 Phase A Evidence: `results/3XUI_FASTPATH_P2R2_SERVER_STAGE_OWNER_MATERIALIZE_2026-10-07_EXECUTOR_R1.md`

- P3 baseline reconciliation: `docs/REVIEWER_RECONCILIATION_P3_BASELINE_HTTPS_RESET.md`

- P3 probe-contract reconciliation: `docs/REVIEWER_RECONCILIATION_P3_API401_PROBE_REPLACED.md`
- Active P3R1 Gate: `docs/3X_UI_P3R1_CHATGPT_THREE_NODE_SMOKE.md`
