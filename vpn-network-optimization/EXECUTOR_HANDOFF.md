# VPN Network Optimization — EXECUTOR HANDOFF

> Executor-owned execution facts only. Reviewer truth remains `REVIEWER_HANDOFF.md`.







## Current execution status — G3C C2A Clash UI canary package

```text
GATE_ID=G3C_C2_CLASH_UI_CANARY_PACKAGE_C2A
EXECUTOR_ROLE=CODEX_DESKTOP
CANONICAL_SOURCE=origin/main
PREVIOUS_RESULT=PASS_G3C_C1_MANUAL_CONTROL_CONTRACT
OWNER_INTERVENTION_REQUIRED=NO_IN_C2A
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
DPAPI_UNPROTECT_AUTHORIZED=NO_IN_C2A
EXTERNAL_REQUEST_AUTHORIZED=NO
REALITY_LIVE_NODE_AUTHORIZED=NO
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

### Executor task

1. **First action:** record `ROUND_STARTED_AT=<UTC ISO8601>` before fetch/preflight.
2. Fresh fetch/sync canonical `origin/main`; do not discard unrelated local work.
3. Read the current C2A Gate in `REVIEWER_HANDOFF.md`, current C1 profile/validator, and only the accepted recovery-helper source/metadata necessary to design local HY2 secret injection. Do not unprotect/read the real Secret.
4. Build the minimum repository-owned package for the later Owner C2B live UI canary.
5. The later live selector must contain only:
   - `WG-BASELINE` — named Mihomo `direct`;
   - `HY2-SFO3` — current deployed HY2 candidate.
6. REALITY must be documented as `COLD / DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE` and must not be emitted into the live selectable group.
7. The atomic Owner checkpoint/package must be designed so that later C2B:
   - dynamically discovers the physical interface;
   - locally obtains HY2 auth only through the existing protected recovery path without printing/committing it;
   - renders into a uniquely marked owner-local runtime directory;
   - native-parses with accepted Mihomo v1.19.32 before any UI apply;
   - keeps system WireGuard connected;
   - keeps system proxy and TUN off initially;
   - does not add a persistent /32 route;
   - exposes bounded pre/post markers;
   - has exact cleanup/rollback;
   - stops before any WG disconnect.
8. Offline/static fixtures must reject:
   - live REALITY selector entry;
   - hardcoded WLAN/ifIndex/gateway/local IP;
   - plaintext HY2 auth in repo/package/log output;
   - automatic system proxy/TUN enablement;
   - WG stop/route removal;
   - persistent /32 route;
   - missing rollback/cleanup markers;
   - missing first-step timing instrumentation.
9. C2A itself must not start/apply Clash, decrypt DPAPI, read Secret values, send traffic, change routes/proxy/TUN/WG, or access VPS/Provider.
10. Persist bounded Evidence and update Executor Handoff only; do not modify Reviewer Handoff.
11. Fresh GitHub read-back and verify tested package/source identity and scope diff.
12. Record `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN=YES|NO`; if over 25 minutes record `TIME_OVERRUN_CAUSE` and update timing retrospective.
13. STOP_AT_REVIEWER.

### Expected completion

Return `PASS_CANDIDATE_G3C_C2A_CLASH_UI_CANARY_PACKAGE` or a precise `RETURN_*`.
Do not advance to live C2B.

## Historical execution status — awaiting Owner R3

```text
GATE_ID=G3C_C1_OWNER_MIHOMO_NATIVE_PARSE_R3
STATE=AWAITING_OWNER_EXECUTION
EXECUTOR_ACTION_AUTHORIZED=NO
CODEX_NATIVE_PARSE_RETRY_AUTHORIZED=NO
POLICY_WORKAROUND_AUTHORIZED=NO
OWNER_ONE_SHOT_LOCAL_CHECKPOINT=REQUIRED
MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
EXPECTED_MIHOMO_VERSION=v1.19.32
ESTIMATED_EXECUTION_TIME=2-5_minutes
STOP_AT_REVIEWER=YES
```

Codex must not retry the native parse, spawn alternate shells to bypass policy, modify the C1 source, or perform any network/VPN action while Owner R3 is pending.


## Historical execution result — G3C C1 Mihomo v1.19.32 native parse R2

```text
GATE_ID=G3C_C1_MIHOMO_V11932_NATIVE_PARSE_R2
EXECUTOR_RESULT=RETURN_MIHOMO_NATIVE_PARSE_BLOCKED_BY_POLICY
PRE_GATE_HEAD=5537d50640c3d1ff12423d75104f30b4e555e682
MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
MIHOMO_VERSION=v1.19.32
C1_TEMPLATE_BLOB=a7ec68ec08c47945b55b567e1717d89d3d06bfaa
C1_VALIDATOR_BLOB=9974bf962c07a51e92aa88f604af6eb2fe77fb0f
NATIVE_CONFIG_TEST=BLOCKED_BEFORE_PROCESS_START
BLOCKED_COMMAND_TYPE=PowerShell inline config-test setup/invocation
BLOCKED_EXECUTABLE=Codex execution-context pwsh.exe
BLOCKED_POLICY_REASON=CreateProcess rejected; blocked by policy
TEMP_FIXTURE_CREATED=NO
MIHOMO_ACTIVE_STARTED=NO
NETWORK_REQUEST_COUNT=0
WIREGUARD_CHANGED=NO
ROUTE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
VPS_ACCESS=NO
SECRET_ACCESS=NO
REVIEWER_HANDOFF_MODIFIED=NO
ROUND_STARTED_AT=UNKNOWN_NOT_CAPTURED_BEFORE_INITIAL_FETCH
ROUND_FINISHED_AT=UNKNOWN
ACTUAL_ELAPSED=UNKNOWN
TIME_OVERRUN=UNKNOWN
LOCAL_R2_PHASE_START=2026-10-03T14:20:12Z
LOCAL_R2_PHASE_CHECK=2026-10-03T14:24:11Z
LOCAL_R2_PHASE_ELAPSED=3m59s
STOP_AT_REVIEWER=YES
```

The exact binary path was present and `-v` returned the Gate-required Mihomo Meta v1.19.32. The one attempted local fixture/config-test invocation was rejected before its PowerShell process started with `CreateProcess ... blocked by policy`; no fixture was created, and no Mihomo process or network action started. No alternate execution channel or split-command retry was attempted. The full Gate start marker was missed before the initial fetch; elapsed/overrun for the complete round remain unknown. The measured 3m59s is only the later local recheck interval, not the total Gate duration.

## Historical R2 execution package — result recorded above

```text
GATE_ID=G3C_C1_MIHOMO_V11932_NATIVE_PARSE_R2
EXECUTOR_ROLE=CODEX_DESKTOP
CANONICAL_SOURCE=origin/main
PREVIOUS_RESULT=RETURN_MIHOMO_VERSION_DRIFT
MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
EXPECTED_MIHOMO_VERSION=v1.19.32
PREVIOUS_ACCEPTED_MIHOMO_VERSION=v1.19.31
OWNER_INTERVENTION_REQUIRED=NO
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
EXTERNAL_REQUEST_AUTHORIZED=NO
SOURCE_REDESIGN_AUTHORIZED=NO_UNLESS_NATIVE_PARSE_PROVES_A_SOURCE_DEFECT
ESTIMATED_EXECUTION_TIME=10-15_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

### Executor task

1. **Before fetch, path check, version check, or any other preflight, record `ROUND_STARTED_AT=<UTC ISO8601>`.**
2. Fresh fetch/sync canonical `origin/main` in the existing project-scoped worktree; do not discard unrelated work.
3. Check exact binary path:
   `C:\Program Files\Clash Verge\verge-mihomo.exe`
4. Run only `-v` and require Mihomo Meta v1.19.32. Any new drift => precise RETURN.
5. Read current canonical C1 source:
   - `templates/clash/self-vpn-manual.yaml.template`
   - `scripts/g3c-manual-control-validator.ps1`
6. Create exactly one temporary non-secret config-test fixture outside the repository using the canonical template unchanged.
7. Replace placeholders only with parser-safe synthetic/test values:
   - reserved documentation IP;
   - example SNI;
   - fixture-only password;
   - all-zero/parser-safe certificate fingerprint;
   - valid synthetic UUID;
   - valid synthetic short-id;
   - non-secret public-key-shaped fixture;
   - current physical interface name only if required for parser validation.
8. Run Mihomo native **config test only**. Do not start the active proxy core and do not send traffic.
9. Delete the temporary fixture and prove it is absent.
10. If native parse succeeds, do not edit C1 source.
11. If parse fails, record sanitized parser failure and STOP_AT_REVIEWER; do not auto-fix template/source.
12. Persist bounded non-secret Evidence and update this Executor Handoff only. Do not modify Reviewer Handoff.
13. Fresh GitHub read-back and prove the tested C1 template/validator blobs remain canonical.
14. Record:
   - `ROUND_FINISHED_AT=<UTC ISO8601>`
   - `ACTUAL_ELAPSED=<duration>`
   - `TIME_OVERRUN=YES|NO`
   - if YES: `TIME_OVERRUN_CAUSE=<evidence-backed cause>`
15. If over 15 minutes, update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its current rules.
16. STOP_AT_REVIEWER.

### Expected PASS_CANDIDATE evidence

- `ROUND_STARTED_AT=...` captured before preflight
- `MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe`
- `MIHOMO_VERSION=v1.19.32`
- `MIHOMO_NATIVE_CONFIG_TEST=PASS`
- `C1_PROFILE_SOURCE_CHANGED=NO`
- `TEMP_FIXTURE_CREATED=YES`
- `TEMP_FIXTURE_SECRET_VALUES=0`
- `TEMP_FIXTURE_CLEANUP=PASS`
- `CLASH_ACTIVE_STARTED=NO`
- `NETWORK_REQUEST_COUNT=0`
- `WIREGUARD_CHANGED=NO`
- `ROUTE_CHANGED=NO`
- `SYSTEM_PROXY_CHANGED=NO`
- `TUN_CHANGED=NO`
- `VPS_ACCESS=NO`
- complete timing fields
- `STOP_AT_REVIEWER=YES`

### Explicit prohibitions

- Do not downgrade or download Mihomo.
- Do not stop/restart/disable WireGuard.
- Do not add/remove/change routes.
- Do not enable system proxy or TUN.
- Do not apply/import the profile into Clash Verge.
- Do not start Mihomo as an active proxy client.
- Do not SSH or access any VPS/Provider.
- Do not read/generate/move/rotate real Secrets.
- Do not send external network requests.
- Do not change C1 source unless Reviewer later authorizes a repair after a parser-proven defect.
- Do not advance to C2.


## Historical execution result — G3C C1 native Mihomo parse reconciliation R1

```text
GATE_ID=G3C_C1_MIHOMO_NATIVE_PARSE_RECONCILIATION_R1
EXECUTOR_RESULT=RETURN_MIHOMO_VERSION_DRIFT
PRE_GATE_HEAD=b8e8e09d17fdec55076afb753d8a461f7e74d15b
HISTORICAL_MIHOMO_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
HISTORICAL_PATH_EXISTS=YES
EXPECTED_MIHOMO_VERSION=v1.19.31
OBSERVED_MIHOMO_VERSION=v1.19.32
NATIVE_CONFIG_TEST=NOT_RUN_VERSION_DRIFT
TEMP_FIXTURE_CREATED=NO
NETWORK_REQUEST_COUNT=0
CLASH_ACTIVE_STARTED=NO
WIREGUARD_CHANGED=NO
ROUTE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
VPS_ACCESS=NO
SECRET_ACCESS=NO
REVIEWER_HANDOFF_MODIFIED=NO
ROUND_STARTED_AT=UNKNOWN_NOT_CAPTURED
ROUND_FINISHED_AT=UNKNOWN_NOT_CAPTURED
ACTUAL_ELAPSED=UNKNOWN
TIME_OVERRUN=UNKNOWN
TIME_OVERRUN_CAUSE=Timing capture began only after initial preflight; the 2026-10-03T14:02:32Z clock read is not a valid round-start or finish measurement.
STOP_AT_REVIEWER=YES
```

The exact historically accepted binary exists, but its read-only `-v` output is v1.19.32 rather than the Gate-pinned v1.19.31. Per the Gate, no bounded substitution search and no native config parse were performed after this version drift. No temporary fixture was created, and no client, network, route, VPS, or Secret action occurred. The canonical C1 template was read unchanged (blob `a7ec68ec08c47945b55b567e1717d89d3d06bfaa`).

## Historical R1 execution package — superseded by the result above

```text
GATE_ID=G3C_C1_MIHOMO_NATIVE_PARSE_RECONCILIATION_R1
EXECUTOR_ROLE=CODEX_DESKTOP
CANONICAL_SOURCE=origin/main
PREVIOUS_RESULT=RETURN_MIHOMO_NATIVE_PARSE_REQUIRED
HISTORICAL_MIHOMO_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
EXPECTED_MIHOMO_VERSION=v1.19.31
OWNER_INTERVENTION_REQUIRED=NO
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
EXTERNAL_REQUEST_AUTHORIZED=NO
SOURCE_REDESIGN_AUTHORIZED=NO_UNLESS_NATIVE_PARSE_PROVES_A_SOURCE_DEFECT
ESTIMATED_EXECUTION_TIME=10-15_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

### Executor task

1. Fresh fetch/sync canonical `origin/main` in the project-scoped worktree. Do not discard unrelated work.
2. Record `ROUND_STARTED_AT` before execution.
3. Check this exact accepted historical path first:
   `C:\Program Files\Clash Verge\verge-mihomo.exe`
4. If absent, perform only a bounded read-only search beneath `C:\Program Files\Clash Verge\` for a Mihomo executable. Do not download/install anything.
5. Run only `-v`. Expected stable identity is Mihomo Meta v1.19.31.
   - If absent after bounded discovery: RETURN exact missing-binary evidence.
   - If version differs: RETURN version drift; do not silently substitute another core.
6. Use the current canonical `templates/clash/self-vpn-manual.yaml.template` unchanged to create one temporary **non-secret** config-test fixture outside the repository.
7. Replace placeholders only with synthetic/test-safe values:
   - reserved documentation IP such as 203.0.113.10;
   - fixture-only password;
   - parser-safe all-zero certificate fingerprint sentinel;
   - valid synthetic UUID;
   - valid synthetic short-id;
   - non-secret public-key-shaped fixture value;
   - example SNI;
   - dynamically discovered current physical interface name only if Mihomo validation requires an existing interface.
8. Run Mihomo config test only (`-t` / accepted equivalent invocation for the verified binary). Do not launch it as an active client and do not send traffic.
9. Delete the temporary fixture and prove cleanup.
10. Do not modify the C1 profile/template/validator unless the native parser itself proves a precise source defect. If it fails, preserve the sanitized parser failure class/output needed for Reviewer and STOP.
11. Persist bounded non-secret facts in `EXECUTION_EVIDENCE.md` and update this Executor Handoff. Do not modify `REVIEWER_HANDOFF.md`.
12. Fresh read-back GitHub main and prove tested C1 source blobs are still the canonical source.
13. Record:
   - `ROUND_FINISHED_AT`
   - `ACTUAL_ELAPSED`
   - `TIME_OVERRUN=YES|NO`
   - if YES: `TIME_OVERRUN_CAUSE=<evidence-backed cause>`
14. If actual elapsed exceeds 15 minutes, update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its current rules.
15. STOP_AT_REVIEWER.

### Expected PASS_CANDIDATE evidence

- `MIHOMO_BINARY_PATH=...`
- `MIHOMO_VERSION=v1.19.31`
- `MIHOMO_NATIVE_CONFIG_TEST=PASS`
- `C1_PROFILE_SOURCE_CHANGED=NO`
- `TEMP_FIXTURE_CREATED=YES`
- `TEMP_FIXTURE_SECRET_VALUES=0`
- `TEMP_FIXTURE_CLEANUP=PASS`
- `CLASH_ACTIVE_STARTED=NO`
- `NETWORK_REQUEST_COUNT=0`
- `WIREGUARD_CHANGED=NO`
- `ROUTE_CHANGED=NO`
- `SYSTEM_PROXY_CHANGED=NO`
- `TUN_CHANGED=NO`
- `VPS_ACCESS=NO`
- timing fields above
- `STOP_AT_REVIEWER=YES`

### Explicit prohibitions

- Do not stop/restart/disable WireGuard.
- Do not add/remove/change routes.
- Do not enable system proxy or TUN.
- Do not apply/import the profile into Clash Verge.
- Do not start Mihomo as an active proxy client.
- Do not SSH or access any VPS/Provider.
- Do not read/generate/move/rotate real Secrets.
- Do not send any external HTTP/UDP/TCP test request.
- Do not redesign C1 merely because the previous Executor failed to discover the known binary path.
- Do not advance to C2.


## Historical execution status — G3C C1 unified manual-control contract

```text
GATE_ID=G3C_UNIFIED_MANUAL_CONTROL_CONTRACT_C1
EXECUTOR_ROLE=CODEX_DESKTOP
CANONICAL_SOURCE=origin/main
SOURCE_HEAD_TESTED=a502068ff752892fac75aab37b7d8aaa5e2ab85d
LATEST_MAIN_RECONFIRMED=a502068ff752892fac75aab37b7d8aaa5e2ab85d
PROFILE_TEMPLATE=templates/clash/self-vpn-manual.yaml.template
CONTRACT_DOC=docs/G3C_MANUAL_CONTROL_CONTRACT.md
OFFLINE_VALIDATOR=scripts/g3c-manual-control-validator.ps1
OWNER_INTERVENTION_REQUIRED=NO
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_IS_CURRENT_PRODUCTION_VPN=YES
WG_DISCONNECT_REQUIRES_OWNER_CHECKPOINT=YES
ALTERNATE_VPN_MUST_BE_CONFIRMED_BEFORE_WG_DISCONNECT=YES
WG_SERVICE_STOP_AUTHORIZED=NO_IN_C1
WG_ROUTE_REMOVAL_AUTHORIZED=NO_IN_C1
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
PERSISTENT_BYPASS_ROUTE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=NEXT_GATE
OFFLINE_FIXTURES=PASS
PROFILE_SYNTAX=JSON_COMPATIBLE_YAML_PARSE_PASS
MIHOMO_NATIVE_PARSE=NOT_RUN_NO_VERIFIED_LOCAL_BINARY
LATEST_MAIN_RECONFIRMED=342fb647dcdd1a22d429dbdfbeea4841ab70412e
LATEST_MAIN_GATE_RECONFIRMED=G3C_UNIFIED_MANUAL_CONTROL_CONTRACT_C1_AUTHORIZED
REQUIRED_PORTABLE_INPUTS_CHANGED=NO
STOP_AT_REVIEWER=YES
```

### Executor task

1. Read the current C1 Gate in `REVIEWER_HANDOFF.md` and only the portable Clash/HY2/REALITY templates or accepted G2-C client-schema source required by that Gate.
2. Sync a clean project-scoped worktree to canonical `origin/main`; do not discard unrelated changes.
3. Create the minimum repository-owned non-secret manual-control profile contract and offline validator.
4. Contract requirements:
   - named `WG-BASELINE` Mihomo proxy with `type: direct`;
   - `SELF-VPN-MANUAL` select group whose first/default selection is `WG-BASELINE`;
   - `HY2-SFO3` and `REALITY-SFO3` skeletons use a dynamic physical-interface placeholder rather than hardcoded `WLAN`/ifIndex/gateway;
   - HY2/REALITY Secret/identity sentinels remain explicit;
   - REALITY is explicitly marked cold/not-ready-for-manual-use until a later live Gate;
   - manual delay-test contract is present;
   - no automatic/fallback/url-test production selection is enabled;
   - no persistent public-IP /32 route instruction exists.
5. Offline fixtures must cover:
   - valid contract;
   - hardcoded physical interface rejection;
   - WG baseline missing/not-default rejection;
   - automatic/fallback/url-test production selection rejection;
   - Secret sentinel loss/population rejection;
   - persistent /32 route instruction rejection;
   - REALITY incorrectly marked production-ready rejection.
6. Use a deterministic local Mihomo parse/test path if available without starting Clash or changing active profiles.
7. **C1 transition exception:** this C1 prompt was already issued before timing observability was restored. Timing fields are optional for C1 and missing timing must not cause retry, RETURN, or replay.
8. Reviewer estimate **15–25 minutes** is reference-only for C1.
9. Starting with the next Gate after C1, timing capture becomes mandatory per `docs/ROUND_TIMING_RETROSPECTIVE.md`.
10. On PASS: append bounded non-secret Evidence and update this Executor Handoff; then STOP_AT_REVIEWER.
11. On failure: record the exact failure class and stop. Do not perform live retries.

### Explicit prohibitions

- Do not stop/disable/restart WireGuard in C1.
- Do not remove/change the two accepted WireGuard /1 routes in C1.
- Do not start Clash/Mihomo as an active client.
- Do not enable system proxy or TUN.
- Do not apply/import a live Clash profile.
- Do not add persistent or temporary bypass routes in C1.
- Do not SSH to any VPS.
- Do not read/generate/move/rotate Secret values.
- Do not make REALITY persistent.
- Do not advance to C2 or resume G3-B fresh-target work.
- Do not replay any G2-C canary.
- In later Gates, never disconnect WG unless Reviewer has established an explicit Owner checkpoint and the Owner has already confirmed another VPN is working.


### Latest Executor result — G3C C1 manual-control contract (2026-10-03)

```text
RESULT=PASS_CANDIDATE_G3C_C1_MANUAL_CONTROL_CONTRACT
SOURCE_HEAD_TESTED=a502068ff752892fac75aab37b7d8aaa5e2ab85d
POWERSHELL_AST_PARSE=PASS
G3C_C1_OFFLINE_FIXTURES=PASS
G3C_C1_PROFILE_SYNTAX=JSON_COMPATIBLE_YAML_PARSE_PASS
MIHOMO_NATIVE_PARSE=NOT_RUN_NO_VERIFIED_LOCAL_BINARY
LATEST_MAIN_GATE_RECONFIRMED=G3C_UNIFIED_MANUAL_CONTROL_CONTRACT_C1_AUTHORIZED
REQUIRED_PORTABLE_INPUTS_CHANGED=NO
PROFILE_APPLIED=NO
CLASH_STARTED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
WIREGUARD_CHANGED=NO
ROUTE_CHANGED=NO
VPS_ACCESS=NO
SECRET_VALUES_ACCESSED=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

The manual profile remains a non-applied template. REALITY is listed only as a cold placeholder and is not ready for use; the per-node physical-interface field is a discovery placeholder, not proof of Windows bypass behavior. Reviewer disposition is pending.


## Historical execution status — G3B D3 staged-install render validation

```text
GATE_ID=G3B_STAGED_INSTALL_RENDER_CONTRACT_D3
EXECUTOR_ROLE=CODEX_DESKTOP
CANONICAL_SOURCE=origin/main
REBUILT_VALIDATOR_COMMIT=2cb25ecccdaf8fdc0c2a20368142b205cb0ca880
SOURCE_HEAD_TESTED=df32d130d65f129f68294e4b26e4df4f06b8f930
OWNER_INTERVENTION_REQUIRED=NO
LIVE_VPS_ACCESS_AUTHORIZED=NO
PROVIDER_ACTION_AUTHORIZED=NO
SECRET_READ_OR_TRANSFER_AUTHORIZED=NO
SERVICE_OR_NETWORK_MUTATION_AUTHORIZED=NO
EXECUTOR_OFFLINE_VALIDATION=PASS_CANDIDATE
STOP_AT_REVIEWER=YES
```

### Executor task

1. Read current `REVIEWER_HANDOFF.md` and only the D3 target files it names.
2. Sync a clean local worktree to canonical `origin/main`; do not discard unknown local changes.
3. Use PowerShell 7.6.x.
4. AST-parse `scripts/g3b-staged-install-render-validator.ps1`.
5. Run exactly:
   `& .\scripts\g3b-staged-install-render-validator.ps1 -Validate`
   from the project root, or the equivalent absolute path.
6. Expected bounded success includes:
   - `G3B_D3_SELFTEST_CASES=6`
   - `G3B_D3_SELFTEST_RESULT=PASS`
   - `G3B_D3_WG_SPLIT_DEFAULT=PASS`
   - `G3B_D3_SECRET_SENTINELS=PASS`
   - `G3B_D3_STAGED_ORDER=PASS`
   - `G3B_D3_ROLLBACK_TO_SOURCE=PASS`
   - `FILES_CREATED=0`
   - `NETWORK_MUTATION=NO`
   - `VPS_ACCESS=NO`
   - `PROVIDER_ACTION=NO`
   - `SECRET_VALUES_READ=0`
   - `SECRET_VALUES_EMITTED=0`
   - `G3B_D3_OFFLINE_VALIDATION=PASS`
7. On PASS: append bounded non-secret execution facts to `EXECUTION_EVIDENCE.md`, update this handoff with the exact source HEAD/result, and stop for Reviewer.
8. On failure: do not enter live/retry loops. Record the exact failure class and relevant non-secret source evidence, then stop for Reviewer.

### Explicit prohibitions

- Do not SSH to current or future VPS.
- Do not create/buy a VPS or call a Provider control plane.
- Do not read, generate, move, rotate, decrypt, print, hash, or commit Secret values.
- Do not create rendered runtime files outside fixture memory.
- Do not start/stop/enable services.
- Do not change routes, firewall, NAT, sysctl, proxy, TUN, WireGuard, HY2, REALITY, or Clash.
- Do not advance to D4/G4 or any later Gate.
- Do not replay G2-C public canaries.

### Latest Executor result — G3B D3 offline render validation (2026-10-03)

```text
RESULT=PASS_CANDIDATE_G3B_D3_OFFLINE_RENDER_VALIDATION
SOURCE_HEAD_TESTED=df32d130d65f129f68294e4b26e4df4f06b8f930
POWERSHELL_VERSION=7.6.5
POWERSHELL_AST_PARSE=PASS
G3B_D3_SELFTEST_CASES=6
G3B_D3_SELFTEST_RESULT=PASS
G3B_D3_WG_SPLIT_DEFAULT=PASS
G3B_D3_SECRET_SENTINELS=PASS
G3B_D3_STAGED_ORDER=PASS
G3B_D3_ROLLBACK_TO_SOURCE=PASS
FILES_CREATED=0
NETWORK_MUTATION=NO
VPS_ACCESS=NO
PROVIDER_ACTION=NO
SECRET_VALUES_READ=0
SECRET_VALUES_EMITTED=0
OWNER_INTERVENTION_REQUIRED=NO
STOP_AT_REVIEWER=YES
```

The validator used only its in-memory non-secret fixture. No live target rendering, Secret access, or runtime action occurred. Reviewer disposition is pending.


## Historical execution status — G2C REALITY handshake diagnostic R1

- Gate: `G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1`; source base was fresh GitHub `main` commit `3b20323933f6751e6cd614e5b41946430c191432`. Executed in the Owner Windows account via PowerShell 7.6.5, Medium integrity RID `8192`, Administrator `False`; elevation was not required.
- Fresh local preflight passed: WireGuard Manager/Tunnel Running, `SFO2-A` Up/ifIndex 13, control route to `10.66.21.1` via ifIndex 13, system proxy disabled, WinHTTP direct, no Mihomo/TUN process or adapter, and accepted Mihomo Meta `v1.19.31` present.
- Strict SSH with the accepted HostKeyAlias reached root on `10.66.21.1`; target was `ubuntu-s-1vcpu-512mb-10gb-sfo3`, Ubuntu 24.04.5 LTS, kernel `6.8.0-142-generic`. WG/HY2 were active with UDP 51820/8443 listeners; TCP 14443 and TCP 443 were initially free.
- VPS→`www.microsoft.com:443` read-only check passed TCP and TLS 1.3. After the temporary server listener was ready, Windows→`10.66.21.1:14443` TCP reachability passed. Pinned sing-box v1.14.2 asset/hash and server/Mihomo config checks passed; listener was private-only, with no public 14443/443 listener.
- Protocol parameters remained unchanged: VLESS+REALITY+Vision, handshake/SNI `www.microsoft.com`, flow `xtls-rprx-vision`, VPS private listener `10.66.21.1:14443`, localhost HTTP proxy `127.0.0.1:17990`. Only diagnostic log capture/classification was added.
- Exactly one proxied request to `https://api.openai.com/v1/models`: curl exit `35`, HTTP `0`, total `5.002744s`, proxy connect `0.000765s`, TLS app-connect `0.000000s`. Sanitized classes: curl `UNKNOWN_TLS_HANDSHAKE_FAILURE`; Mihomo `TIMEOUT`; sing-box `UNKNOWN_TLS_HANDSHAKE_FAILURE`. Aggregate `REALITY_DIAGNOSTIC_CLASSIFICATION=TIMEOUT`. This narrows the observed client-core failure to a timeout class, but does not prove protocol compatibility or identify a more specific underlying defect. No retry, benchmark, or performance conclusion.
- Cleanup/fresh read-back passed: test Mihomo stopped; temporary owner-only client config removed; protected VPS runtime/workspace, sing-box process and TCP 14443 listener absent; TCP 443 still free; WG/HY2, routes, system proxy, WinHTTP, and TUN state preserved. Secret values emitted/committed: `0`.
- No public listener, firewall, route, WireGuard/HY2 service, system proxy, TUN, MTU, or kernel tuning change occurred; no persistent service was installed. Result: `PASS_CANDIDATE_DIAGNOSTIC`; stop for Reviewer. Owner action: `NONE`.
- Timing: `ROUND_STARTED_AT=2026-10-02T17:57:29Z`; `ROUND_FINISHED_AT=2026-10-02T18:21:58Z`; `ACTUAL_ELAPSED=24m29s`; `TIME_OVERRUN=NO` (estimate 15–30 minutes).

## G1 historical executor status (preserved)

`RETURN_PREFLIGHT_DRIFT` — G1 read-only preflight and project-local foundation completed; stopped before any VPS write or live client change.

`STOP_AT_REVIEWER: YES`

## Gate boundary

The following G1-era inspection sections preserve the state observed during G1; later accepted G2-A read-backs below supersede any conflicting current-state wording.

- Gate: `G1 — Foreground-safe Foundation`
- Foreground interruption: `NO`
- VPS write: `NO`
- Windows/VPN write: `NO`
- Current traffic switched: `NO`
- Live fq/BBR/sysctl/MTU/GRO tuning applied: `NO`

## G1 historical target-host facts

- SSH read-only probe reached `24.199.118.137` with strict host-key checking and the existing local identity reference; host-key mismatch was not observed.
- No `SHARED_VPS_HANDOFF.md` was present in the workspace; the probe used the explicit user-provided historical endpoint and existing local key/known-host metadata only. This is not treated as authorization for a remote write.
- Fresh hostname: `ubuntu-s-1vcpu-512mb-10gb-sfo3`.
- Fresh DigitalOcean metadata: region `sfo3`, droplet id recorded in evidence only.
- Fresh OS/kernel: Ubuntu 24.04.5 LTS, kernel 6.8.0-142-generic, x86_64.
- Fresh WAN: `eth0`; public IPv4 `24.199.118.137`; default route via `24.199.112.1`.
- Material drift: Reviewer labels the VPS `SFO2-A`; target-host read-back reports `sfo3`. This is recorded as unresolved identity/location drift and must be reconciled by Reviewer before any remote write.
- Full read-only preflight transport returned exit code 1 only because the optional `hysteria*` systemd-unit listing was empty; identity and all required inspection sections were collected. No remote write occurred.

## G1 historical WireGuard facts

- Server `wg0` is up, listening on UDP 51820, address `10.66.21.1/24`, service enabled/active.
- Server read-back showed a live peer handshake and transfer counters; no private key was read or emitted.
- Server MTU read-back: 1420. Client active adapter read-back: connected `SFO2-A`, active MTU 1420; a separate 1280 metadata entry was present. No MTU was changed.
- Forwarding/NAT read-back: IPv4 forwarding enabled; nftables/iptables FORWARD and eth0 masquerade present; UFW inactive.
- UDP 8443 had no listener at probe time; UDP 51820 was occupied by WireGuard.

## G1 historical Linux candidate facts

- `eth0` qdisc: `fq_codel`; `wg0`: `noqueue`.
- TCP congestion control: `cubic`; available/allowed: `reno cubic`.
- TCP BBR kernel module exists, but it is not active in the read-back.
- `rx-gro-list=off` and `rx-udp-gro-forwarding=off`; generic receive offload is on. No offload/sysctl change was made.
- No Hysteria2 systemd unit was present.

## G1 historical Windows client facts

- Target runtime was proven as the Owner Windows host for this read-only check: Windows 11 build 26200, PowerShell 7.6.5.
- Clash Verge 2.5.6 is installed under `C:\Program Files\Clash Verge`; Mihomo binaries are present. Current active core version was not independently proven.
- No Clash/Mihomo TUN adapter was observed. WinHTTP is direct and `ProxyEnable=0`; a configured proxy endpoint value remains inactive and was not changed.
- WireGuard Manager and `WireGuardTunnel$SFO2-A` are running; adapter `SFO2-A` is Up and default route metric 0 remains present.
- `wg.exe show all` was attempted read-only but returned permission denied; adapter/service/route evidence still proves the tunnel is active. No privilege escalation or client change was attempted.

## G1 historical local project artifacts

- Portable parameter file: `config/variables.env.example`
- WireGuard templates: `templates/wireguard/`
- HY2 server template: `templates/hysteria2/server.yaml.template`
- Mihomo fragment: `templates/clash/mihomo-hy2.yaml.template`
- Optional systemd unit template: `templates/systemd/hysteria2.service.template`
- Read-only preflight: `scripts/preflight-linux.sh`, `scripts/preflight-windows.ps1`
- Non-invasive health check: `scripts/health-check.sh`
- Dry-run rollback/uninstall: `scripts/rollback-uninstall.sh`
- Plan-first migration/reinstall helper: `scripts/migration-reinstall.sh`
- Secrets excluded by `.gitignore`; no Secret value was generated, read, or recorded.

## G1 historical HY2 status

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

Blocked because the current Gate has no authorized HY2 auth Secret or TLS private key, no DNS/SNI certificate checkpoint, and the VPS identity/location drift (`SFO2-A` vs fresh `sfo3`) is unresolved. UDP 8443 is free at the read-only probe, but that alone is not end-to-end readiness.

## G1 historical reviewer handoff

Please reconcile the fresh `sfo3` identity/location against the historical `SFO2-A` label before authorizing any remote write. If accepted, the next bounded Gate may separately authorize Secret/DNS/cloud-firewall checkpoints and a safe-window HY2 installation; G1 did not enter that Gate.

## G1 historical exact return

`RETURN_PREFLIGHT_DRIFT`

## G2-A pre-authorization execution facts (historical)

- Fresh SSH read-back used strict host-key checking against `24.199.118.137`; public IP, hostname, OS, kernel, WAN route, wg0, UDP listeners, forwarding, local firewall/NAT metadata, and resource usage were inspected read-only.
- Identity matches the current Owner-accepted baseline: `24.199.118.137`, hostname `ubuntu-s-1vcpu-512mb-10gb-sfo3`; `sfo3` is accepted and `SFO2-A` is a legacy label. The target's DigitalOcean metadata endpoint and cloud-init region query did not return a region value.
- wg0 remained active/enabled at MTU 1420 and UDP 51820 remained bound. UDP 8443 had no listener. No remote write, package install, systemd unit creation, service start, route/NAT/firewall change, or sysctl/qdisc/GRO/MTU tuning occurred.
- Fresh HY2-specific read-back found no Hysteria executable, no project HY2 binary/config, no HY2 unit, and none of the declared auth/certificate/key paths on the target.
- DigitalOcean Cloud Firewall could not be read through an authorized local interface: `doctl` is unavailable and no DigitalOcean API token is present. No firewall rule was changed.
- Clash Verge 2.5.6 is installed. Installed cores report Mihomo Meta `v1.19.31` and `alpha-f103639`; no Mihomo core process was running at read-back. The Clash Verge service and Windows WireGuard tunnel were running; no Clash/Mihomo TUN adapter was observed, system proxy is disabled, and WinHTTP is direct.
- Both YAML templates passed the installed Mihomo `-t` parser using both installed cores. The client template's fingerprint field was accepted. Its all-zero fingerprint is a deliberately non-matching parse sentinel, not a certificate fingerprint or handshake result. No Hysteria binary was installed, so Hysteria-specific config validation was not run.
- The Mihomo fragment now uses `SFO3-A-HY2`, the local SNI `hy2.sfo3-a.invalid`, `skip-cert-verify: true` plus certificate fingerprint pinning, and no public DNS dependency. It is a template only; the sentinel, server placeholder, and auth placeholder must be replaced before use.
- Rollback now names only the project HY2 unit, config, and binary; its default preserves data/Secrets and does not touch WireGuard, routes, NAT, or firewall. Bash syntax and the dry-run both passed. A systemd-native unit validator was unavailable on this Windows host.
- No HY2 auth Secret, TLS private key, or self-signed certificate was generated. No value was emitted, logged, or committed. Client runtime configuration and HY2 service are not ready until Owner checkpoints are resolved.

## G2-A pre-authorization checkpoint (historical; superseded by completed execution below)

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

- Owner must explicitly authorize the exact Secret paths/modes and generation behavior before auth/certificate material can be created.
- Owner must inspect the DigitalOcean Cloud Firewall for this droplet and, only if absent, allow inbound UDP 8443 for this droplet only. No other rule or port is in scope.
- After those checkpoints, validate the rendered Hysteria config and systemd unit before starting only the independent HY2 service; then verify WG and Windows routes remain unchanged.

## G2-A completed execution — 2026-10-02

- Target fresh read-back: `24.199.118.137`, hostname `ubuntu-s-1vcpu-512mb-10gb-sfo3`, DigitalOcean region `sfo3`, Ubuntu 24.04.5 LTS, kernel `6.8.0-142-generic`, WAN `eth0`.
- The standard `/srv/data` and `/srv/apps` parents were absent and were created as `root:root 0755`; no pre-existing parent directory was changed. Project directories and the no-login `hy2-vpn` service account were created within the accepted paths.
- Official Hysteria `v2.12.3` binary was installed at `/usr/local/lib/vpn-network-optimization/hysteria`; the release SHA-256 was verified as `8c7a68a906998b747a0db87586e364f995fbfddb95693ae6e2fdb68a6e920d3e`.
- The independent `hysteria2-vpn-network-optimization.service` is enabled and active. It runs as `hy2-vpn`, listens on UDP 8443 only, and suppresses stdout/stderr so the Secret-bearing config is not sent to ordinary service logs.
- Runtime server YAML passed remote PyYAML parsing; the systemd unit passed `systemd-analyze verify`; the running service and listener were freshly read back. The auth file is readable only by root; `hy2-vpn` can read its TLS key/certificate and runtime config.
- Secret-file metadata: `hy2-auth` `root:root 0600`; `server.key` `root:hy2-vpn 0640`; `server.crt` `root:root 0644`; runtime config `root:hy2-vpn 0640`. Secret values are not recorded here.
- Self-signed certificate SAN is `DNS:hy2.sfo3-a.invalid`; SHA-256 fingerprint: `8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18`.
- The final recovery artifact is `%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi` (1206 bytes), DPAPI `CurrentUser`. Final existence, decryption/byte-identity round-trip, current-owner-only ACL, and disabled inheritance passed fresh read-back. The pending artifact no longer exists. The bundle contains only HY2 auth, TLS private key, and certificate; it excludes the runtime YAML.
- `config/clash/sfo3-a-hy2.yaml` points to `24.199.118.137:8443`, pins the certificate fingerprint, and retains a local auth-injection placeholder. It passed config tests with Mihomo Meta `v1.19.31` and `alpha-f103639`; Clash Verge is `2.5.6`. It was not imported or enabled.
- Fresh regression read-back: `wg0` remains active/enabled at MTU 1420, UDP 51820 remains bound, default/WG routes and IPv4 forwarding remain unchanged, UFW remains inactive, and the existing single NAT masquerade rule remains present. qdisc remains `fq_codel`, TCP CC `cubic`, BBR inactive, generic GRO on, `rx-gro-list` and UDP GRO forwarding off. No live tuning was applied.
- Windows fresh read-back: WireGuard Manager/tunnel remain Running, adapter `SFO2-A` remains Up, default routes remain on `SFO2-A` and `WLAN`, Clash Verge service remains Running, `ProxyEnable=0`, WinHTTP is direct, no Clash/Mihomo TUN adapter or active Mihomo core was present. No Windows network state was changed.
- G2-A service process RSS was `21,596 KiB`; target `MemAvailable` read-back was `260,452 KiB`. The pre-deployment observation was `292,280 KiB` (net interval change `-31,828 KiB`, not attributed solely to HY2). No performance benchmark or client handshake was run.
- During execution, the initial directory step correctly stopped because `/srv/data` and `/srv/apps` were missing; only the authorized no-login account had been created at that point. A later provisioner health read-back initially mis-indexed `ss -p` columns; no final DPAPI artifact was promoted until an independent read-only verification passed. The provisioner parser was corrected for future clean deployments.
- No WireGuard/network service restart, route/NAT/firewall change, Windows proxy/profile/TUN change, BBR/fq/GRO/sysctl/MTU change, traffic switch, Speedtest, benchmark, or G2-B work occurred. Secret values emitted/logged/committed: `0`.

```text
TARGET_HOST_VERIFIED=YES
WG_PRESERVED=YES
FOREGROUND_TASK_INTERRUPTION=NO
YAML_PARSE_VALIDATED=YES
MIHOMO_HY2_SUPPORT_VERIFIED=YES
HY2_INSTALLED=YES
HY2_SERVICE_ACTIVE=YES
HY2_UDP_8443_LISTENING=YES
CLIENT_CONFIG_READY=YES
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
ROLLBACK_READY=YES
DPAPI_FINAL_RECOVERY=YES
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
G2B_ENTERED=NO
STOP_AT_REVIEWER=YES
```



## Current resume point — supersedes earlier DPAPI path assumptions

- Hysteria2 server-side deployment remains accepted and active on UDP 8443; WireGuard remains active on UDP 51820.
- The original G2-A DPAPI artifact was not missing. It was written under Codex packaged-app virtualization at `...\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi`.
- That virtualized artifact is 1206 bytes, owner-only, DPAPI CurrentUser decryptable, parses as the accepted `VPNHY2R1` bundle, and passes TLS key/cert, SAN, and fingerprint validation.
- Do not re-fetch or rotate VPS Secrets.
- `g2b-owner-runner.ps1` ACL validation has been fixed and statically reviewed; benchmark has not started.
- `scripts/realize-owner-dpapi-path.ps1` is the current Owner action path. Its first run failed only because its integrity precheck falsely rejected a real High-integrity PowerShell 7.6.6 process.
- Owner read-back proved Administrator=True and integrity SID `S-1-16-12288` / High; pending and target canonical artifacts were not created.
- Next executor action: fix only the realization runner integrity precheck to use token integrity level semantics; do not execute benchmark until canonical Owner path fresh read-back passes.


## G2-B readiness update — 2026-10-02

Owner-side canonical recovery path realization completed successfully. Source was retained; target ACL, DPAPI round-trip, bundle validation, and encrypted-byte identity all passed; no pending or plaintext temporary artifact remains. Do not repeat recovery creation. G2-B benchmark is now the next step and has not started yet.


## G2-B runtime ACL owner repair

结果：PASS_CANDIDATE
改动：owner-only directory/file ACL constructors now explicitly set Owner SID before Set-Acl.
验证：The repair is limited to ACL ownership semantics; benchmark, Secret, route, and cleanup logic are unchanged.
问题：下一次正式重试前仍需在真实 Windows 主机上用非 Secret 临时目录验证 SetOwner + Set-Acl + owner readback。
回滚：移除两处 SetOwner($script:ownerSid) 即可回到上一 accepted runner。
请 Reviewer 检查：核对 OWNER_ACL_OWNER_MISMATCH 与源码缺失 SetOwner 的因果一致性、补丁范围及下一次 fixture 要求。
Owner 转交：NONE

## Current executor result — G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2 (2026-10-03)

结果：PASS_CANDIDATE_DIAGNOSTIC；服务端状态归类为 `UNKNOWN_AFTER_R2`。
改动：canary 仅把临时 sing-box 日志提高到 trace，并从受保护日志提取固定 REALITY 状态枚举；VLESS+REALITY+Vision 参数未变。
验证：仅发送 1 次私网代理请求（curl 35 / HTTP 0）；临时私网监听器已创建并清理，sing-box 状态日志采集与 cleanup read-back 通过，但所有 REALITY 阶段字段均为 UNKNOWN。Mihomo 已停止、Secret runtime 已删除、WG/HY2 与本机网络基线保持。
问题：UNKNOWN_AFTER_R2：可读 trace 中未确认任何目标 REALITY 内部状态标记；不得据此推断 auth/fallback 或协议兼容性。
回滚：提交前恢复 `scripts/g2c-private-reality-canary.ps1` 与本轮两份记录即可；本轮临时服务端/客户端运行物已清理，无持久网络或服务变更。
请 Reviewer 检查：fresh-read 本轮 runner、Evidence 与 commit，评估为何 v1.14.2 trace 未暴露目标状态字段，并决定下一步 Gate。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T00:44:07Z
ROUND_FINISHED_AT=2026-10-03T01:09:19Z
ACTUAL_ELAPSED=25m12s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=GITHUB_MAIN_ADVANCED_DURING_ROUND_REQUIRED_FETCH_REBASE_AND_RETRY
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 (2026-10-03)

结果：RETURN_G2C_R3_CLIENT_REQUEST_NOT_STARTED；不得将本轮归类为 Mihomo server success/failure A/B。
改动：新增有界 R3 runner，并修复其本地进程参数绑定问题；未重跑任何服务端、客户端或请求。
验证：固定 Mihomo v1.19.31 资产哈希与服务端配置校验通过，私网 TCP 检查通过；一次服务端尝试后发现 `--noproxy ''` 被 PowerShell mandatory string[] 参数绑定拒绝，curl/REALITY 请求数为 0。临时进程与运行配置清理及生产网络回读通过。
问题：LOCAL_PROCESS_ARGUMENT_BINDING_FAILED：PowerShell 参数校验拒绝显式空参数，发生在启动 curl 前；因此没有握手证据，结果为 UNKNOWN。
回滚：临时 server/client 进程和运行文件已删除；没有持久服务、公开监听或网络配置变更。若需继续，等待 Reviewer 决定是否另开/授权重试 Gate。
请 Reviewer 检查：fresh-read 本轮 runner、Evidence 和 commit，并决定下一步授权；本轮不得自动重放请求。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T01:20:41Z
ROUND_FINISHED_AT=2026-10-03T02:15:51Z
ACTUAL_ELAPSED=55m10s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=LOCAL_PROCESS_ARGUMENT_BINDING_DIAGNOSIS_AND_GITHUB_MAIN_RECONCILIATION
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 retry (2026-10-03)

结果：RETURN_G2C_R3_RUNNER_EXCEPTION_CLASSIFIER_FAILURE；本轮无法给出 A/B 结果。
改动：仅追加本轮脱敏 Evidence 与 Handoff；未修改 runner、协议参数、sing-box A 侧或网络配置。
验证：正式 helper 的本地无网络 empty-argument fixture PASS。唯一一次 retry runner 随后在顶层 catch 中因异常类型不可解析而再次抛错，遮蔽原始阶段；请求数/REALITY 握手状态 UNKNOWN，不再重放。Windows 与 VPS 只读 cleanup read-back 均确认无临时 Mihomo、监听器或 runtime residue，WireGuard/HY2 保持 active。
问题：RUNNER_EXCEPTION_CLASSIFIER_TYPE_UNAVAILABLE：`Management.Automation.ParameterBindingValidationException` 在当前 PowerShell runtime 无法解析；另有 post-run SFO2-A ifIndex=9，而 runner 要求 13，但无法证明该差异触发本次异常。
回滚：所有本轮临时文件/进程均已清理；没有持久服务、路由、代理、TUN 或服务器配置修改。
请 Reviewer 检查：fresh-read 当前 runner、authorized-retry Evidence 与本节，并决定后续诊断 Gate；本轮不再执行请求。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T04:56:08Z
ROUND_FINISHED_AT=2026-10-03T05:07:06Z
ACTUAL_ELAPSED=10m58s
TIME_OVERRUN=NO
STOP_AT_REVIEWER=YES

## Current executor result — G2C_R3_LOCAL_RUNNER_HARDENING_H1 (2026-10-03)

结果：PASS_CANDIDATE；只完成本地 runner hardening，等待 Reviewer。
改动：异常分类改为安全 runtime type/FQID 窄匹配；SFO2-A ifIndex 改为每次动态读取，并要求控制路由 alias/index 与之匹配。
验证：AST、真实本地参数绑定异常、未知异常 generic fallback、动态 ifIndex 匹配/不匹配 fixture、空字符串进程参数 fixture 均通过；当前只读主机基线为 SFO2-A Up ifIndex 9，控制路由同样为 SFO2-A/9。
问题：NONE；Owner reboot 仅作为 ifIndex 可能重编号的上下文，本轮不据此推断先前失败原因。
回滚：仅回退本轮 runner 与两份 execution record 变更即可恢复 PRE_GATE_HEAD；本轮无网络/VPS/Secret/运行服务变更。
请 Reviewer 检查：fresh-read 本轮 commit、R3 runner hardening 与新增 Evidence。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T05:18:10Z
ROUND_FINISHED_AT=2026-10-03T05:32:55Z
ACTUAL_ELAPSED=14m45s
TIME_OVERRUN=NO
TIME_OVERRUN_CAUSE=NONE
MAIN_ADVANCE_DURING_GATE=YES; RECONCILED_TO=889fe48defd4bcd59221bfdf1567dbf93a6db66e
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4 (2026-10-03)

结果：PASS_CANDIDATE_AB；单次 Mihomo v1.19.31 native B-side 请求成功，等待 Reviewer 判定。
改动：仅执行已授权的临时私网 B-side；没有修改源 runner、VLESS/REALITY/Vision 参数、SNI、握手目标或 sing-box A 侧。
验证：本地 hardened-runner preflight PASS；私网 `10.66.21.1:14443` 资产/配置/监听检查 PASS；唯一一次代理请求为 curl 0 / HTTP 401，B-side 分类 `MIHOMO_SERVER_SUCCEEDED`。精确 cleanup 与独立本地/SSH read-back 均 PASS。
问题：NONE；结果仅适用于本次 bounded request，不代表生产默认或高峰表现。
回滚：临时 client/server、Secret-bearing runtime config、服务端 runtime/workspace 与下载 binary 均已清理；WireGuard/HY2 和网络配置保持。
请 Reviewer 检查：fresh-read 本轮 Evidence、Executor Handoff、提交及单次 B-side 结果。
Owner 转交：NONE
耗时：预计 15–25 分钟；实际 9m38s（本地 preflight 至 GitHub fresh read-back）；超时 NO；原因 NONE。
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_PUBLIC_TCP443_CANARY_P1 (2026-10-03)

结果：RETURN_LOCAL_ADMIN_HIGH_TOKEN_REQUIRED；公网 REALITY canary 未启动。
改动：仅追加本轮脱敏 preflight Evidence 与 Executor Handoff；未创建 P1 runner，未触碰 VPS 或网络状态。
验证：GitHub `main` fresh-read 确认 Owner 授权 commit `ee278e6af643088cfe026ef7b61fca31eb431ddb` 已存在；当前 PowerShell 7.6.5 的 Administrator role 为 False，integrity RID=8192 (Medium)，不满足本 Gate 的 Administrator/High 前置条件。
问题：LOCAL_ADMIN_HIGH_TOKEN_REQUIRED：当前 Codex PowerShell token 为 Medium；按 Gate fail-closed 停止，未尝试提权。
回滚：无运行态变更；没有 listener、临时路由、Mihomo runtime 或 Secret artifact 需要清理。
请 Reviewer 检查：本轮 preflight blocker、Evidence 与提交；决定是否提供 Owner elevated execution checkpoint。
Owner 转交：需要后续在真实 Owner Administrator/High-integrity PowerShell 7.x 执行；本轮不提交运行器命令，也不自动重试。
耗时：预计 20–30 分钟；实际耗时未可靠捕获（首个计时读数晚于本地 preflight）；超时 NO，因首项 token gate 失败即停止。
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_PUBLIC_TCP443_CANARY_P1 runner preparation (2026-10-03)

结果：PASS_CANDIDATE_RUNNER_PREPARED；未执行 Owner checkpoint。
改动：新增 `scripts/g2c-reality-public-tcp443-canary-p1.ps1`，以单个 Owner-local PowerShell checkpoint 封装本 Gate 的有界流程。
验证：PowerShell 与嵌入式 Python AST 均 PASS；物理出口/精确路由匹配与 fail-closed fixture PASS；静态检查确认先验 PowerShell 7.6.6 + Administrator + High token、canonical source/Gate 校验、动态物理出口、UFW/iptables-backend/nftables 只读防火墙检查、只监听公网 TCP/443、精确 `/32` 回滚及唯一一次 OpenAI 请求边界；Secret scan PASS。Python AST 初次发现 server config 块缩进错误，已在新 runner 内修复并复验 PASS。
问题：NONE；当前仅源码准备。Owner live preflight、SSH/VPS、路由、listener、Secret 和真实请求均未运行，额度仍为 `0/1`。
回滚：本轮仅有项目源码与脱敏执行记录变更；可通过回退本轮 Git commit 撤销，不涉及运行态回滚。
请 Reviewer 检查：fresh-read P1 runner、静态验证和本轮 Evidence/commit；确认后再让 Owner 执行单条 checkpoint 命令。
Owner 转交：只需在真实 Owner Windows 上以 PowerShell 7.6.6 Administrator/High 运行最终回复给出的唯一命令；runner 自身会先重验 token 与 canonical source，失败即停止。
耗时：P1 consequential execution 预计 20–30 分钟，尚未开始；源码准备初始计时未捕获，不重构实际耗时。
STOP_BEFORE_OWNER_LOCAL_EXECUTION=YES
STOP_AT_REVIEWER=YES

## Current executor result — G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1 (2026-10-03)

结果：PASS_CANDIDATE_HARDENING；仅修复 P1 runner 的 Git root / tracked-relative project path 发现。
改动：Git 从真实 project root 读取 `--show-toplevel`，随后动态推导并校验 project-relative tracked paths；source provenance 的 origin、HEAD、accepted-base ancestry、tracked/clean、Gate 和 request-budget 检查保持 fail-closed。
验证：canonical checkout、既有 managed worktree 和合法嵌套 project-path fixture PASS；LF/CRLF Gate 字段、错配路径、错误 origin、invalid HEAD、未跟踪/dirty target、错误 Gate/budget fixtures 均按预期通过或 fail-closed；PowerShell AST、未改 runner 函数对比和 Secret/network-boundary 静态审查 PASS。
问题：NONE。
回滚：仅本轮源码与执行记录；回滚本轮两个提交即可恢复，未发生运行态变更。
GitHub：源码提交 `e5f1dd24064ccab47b2412fd8a3305a161c17ed6` 已推送到 `main`；fresh-fetch/read-back 确认当时 remote main 与 source commit 一致，runner、Evidence、Handoff 均可读。
请 Reviewer 检查：本轮 commit、canonical source/worktree discovery helper、无网络 fixtures 与 Evidence。
Owner 转交：NONE；本轮没有执行 Owner checkpoint，P1 真实请求额度保持 `0/1`。
OPENAI_REQUEST_COUNT=0
NETWORK_CHANGED=NO
STOP_AT_REVIEWER=YES
