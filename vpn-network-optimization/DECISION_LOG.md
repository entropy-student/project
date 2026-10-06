# VPN Network Optimization — DECISION LOG

> Purpose: durable decision rationale only. Canonical current state remains `REVIEWER_HANDOFF.md`; execution proof remains `EXECUTION_EVIDENCE.md`.

## 2026-10-02 — Keep WireGuard as current production/rollback path

**Decision:** After the successful same-window comparison, do not switch the persistent default client to HY2 yet.

**Why:** HY2 is now technically validated and performed better in the accepted 60+60 same-window network test, but peak-hour repeatability and representative Codex/OpenAI/image-generation workload behavior are still unproven.

**Consequence:** WireGuard remains the current production/rollback path; HY2 is a validated candidate pending G2-C and the final v1 decision.

**Evidence:** `EXECUTION_EVIDENCE.md`, accepted same-window comparison; evidence commit `b85224370a295cc5128e29da9186573b81345d27`.

## 2026-10-02 — Replace WireGuard IPv4 /0 with two /1 defaults

**Decision:** Replace the Windows WireGuard IPv4 `0.0.0.0/0` route with `0.0.0.0/1, 128.0.0.0/1`.

**Why:** Direct packet and WFP evidence proved WireGuard for Windows' strict `Block all outbound (IPv4)` kill-switch was dropping the HY2 outer UDP path before the WLAN NIC. The split defaults preserve normal IPv4 route coverage while no longer triggering that strict kill-switch.

**Consequence:** HY2 can use the explicit VPS `/32` WLAN route while WireGuard remains the default path for other IPv4 traffic. The strict WireGuard Windows WFP kill-switch is no longer active; this security/runtime tradeoff must be revisited at v1 sealing.

**Rollback:** Restore the prior WireGuard AllowedIPs/default-route semantics if a later Gate explicitly decides to reinstate the strict kill-switch or adopts another routing design.

**Evidence:** kill-switch confirmation, post-change route/WFP read-back, post-repair UDP/8443 arrival, and successful HY2 handshake in `EXECUTION_EVIDENCE.md`.

## 2026-10-02 — Limit the performance conclusion to the tested window

**Decision:** Accept `HY2_BETTER_THIS_WINDOW` only for the completed same-window network test.

**Why:** Both protocols completed 60/60 samples without failures, and HY2 improved all measured latency/tail metrics, but the test does not establish universal, long-duration, or peak-hour superiority.

**Consequence:** `PEAK_HOUR_SUPERIORITY_PROVEN=NO` remains explicit. G2-C is proposed for the next suitable peak-hour window and representative real workloads before MVP v1 sealing.


## 2026-10-02 — Freeze the protocol candidate set

**Decision:** Freeze the v1 protocol set to three roles: WireGuard, Hysteria2, and VLESS + REALITY + XTLS Vision. Do not continue protocol-shopping unless later evidence proves an uncovered capability gap.

**Why:** WireGuard is the already-proven management/full-VPN rollback path; HY2 is the already-proven UDP/QUIC performance candidate; VLESS+REALITY adds the materially different TCP/443 fallback domain for networks where UDP is blocked or degraded. Further candidates such as TUIC largely overlap HY2's QUIC/UDP fault domain and would add maintenance/testing cost without a currently demonstrated gap.

**Implementation direction:** Prefer a sing-box VLESS+REALITY server with the existing Clash Verge/Mihomo client, subject to fresh G2-C preflight. Current Mihomo documentation warns about compatibility with newer xray-core REALITY behavior, while both sing-box and Mihomo document VLESS/REALITY support; this is a compatibility-risk reduction choice, not a claim that sing-box is universally faster.

**Consequence:** G2-C becomes VLESS+REALITY side-by-side integration. Peak-hour and real-workload validation moves to G2-D. No persistent default-client switch occurs until those Gates are accepted.


## 2026-10-02 — Insert a private REALITY compatibility canary before public TCP/443 deployment

**Decision:** Do not jump directly from the successful G2-C port/SSH preflight to a public VLESS+REALITY listener. First run one temporary private canary reachable only through the existing WireGuard address on a non-public test port.

**Why:** Fresh upstream documentation and issue evidence show two active risks in the 2026 REALITY ecosystem: cross-core compatibility is changing, and failed/unauthenticated REALITY handshakes can be forwarded to the configured handshake target. Public deployment before proving our exact Mihomo + server-core pair and fallback behavior would mix compatibility, exposure, and provider-abuse risk in one step.

**Canary boundary:** temporary server candidate bound only to `10.66.21.1:14443`; existing Windows Mihomo client; ephemeral UUID/REALITY key material generated and consumed inside protected execution boundaries; no public TCP/443 listener; no WireGuard/HY2 changes; exact cleanup and mandatory Reviewer stop.

**Consequence:** A successful private canary proves protocol interoperability only. Public TCP/443 still requires a separate reviewed fallback-safety design and explicit Owner authorization.


## 2026-10-03 — Add lightweight per-round timing observability

**Decision:** Starting with the next Executor round, Reviewer will estimate a practical end-to-end execution-time range and Executor will record actual elapsed time.

**Overrun handling:** Exceeding the estimate is not a Gate failure. Normal work continues. Executor records a brief evidence-based cause at the next natural checkpoint; if the cause is not already clear, perform only one bounded diagnostic on the slow phase. Immediate investigation is reserved for an actual no-progress stall rather than ordinary slow-but-progressing work.

**Purpose:** Improve future planning and make abnormal slowdowns visible without turning timing measurement into another source of project delay.

**First estimate:** G2-C private REALITY compatibility canary retry = **25–45 minutes**, excluding any deliberate Owner wait.


## 2026-10-03 — Stop unchanged-parameter REALITY diagnostics after R2 and isolate server implementation

**Decision:** Accept R2 as `PASS_DIAGNOSTIC_ONLY / UNKNOWN_AFTER_R2` and stop further unchanged-parameter sing-box trace probing. The next G2-C experiment is a controlled B-side using a temporary Mihomo v1.19.31 native VLESS+REALITY server while preserving the existing Windows Mihomo client, SNI/target, Vision flow, private port, and one-request limit.

**Why:** Two bounded diagnostic rounds reproduced the same curl 35 / Mihomo timeout while private TCP and target TLS 1.3 reachability remained healthy, yet sing-box trace did not expose the requested REALITY internal state. Governance §6 says repeated materially similar failure without new evidence should not trigger another speculative patch. Swapping only the temporary server implementation produces higher information than another log parser or an unproven parameter toggle.

**Pinned B-side candidate:** official MetaCubeX Mihomo `v1.19.31`, asset `mihomo-linux-amd64-compatible-v1.19.31.gz`, SHA256 `04cf9f09671704f839ddbee2e93069dc831a4123a75281e725d1d96ab9ac1afc`.

**Consequence:** A successful Mihomo-server B-side materially implicates the sing-box server implementation path but does not itself authorize production use. A similar failure weakens the sing-box-specific hypothesis and moves the next Reviewer choice to a different single variable such as the REALITY handshake target/SNI. Public TCP/443 remains separately gated.


## 2026-10-03 — Defer peak-hour/real-workload validation until after deterministic MVP engineering

**Decision:** Re-sequence the remaining roadmap so the former `G2-D Peak-hour + real workload validation` becomes **G4 final validation**, after two deterministic engineering stages:
1. `G3-A Network auto-adaptation + health`;
2. `G3-B VPS migration + rollback package`;
3. `G4 Peak-hour + real workload final validation`;
4. `MVP v1 seal`.

**Why:** Peak-hour validation depends on a suitable time window, while G3-A/G3-B can be advanced during the day. More importantly, running the real-workload A/B after automation/migration is implemented means the final test exercises a near-final system instead of an intermediate configuration that will immediately change afterward.

**G3-A scope:** discover the active physical egress/interface/IP/gateway rather than hardcoding the historical WLAN values; generate/validate required bypass routes and client configuration; add bounded health/read-back and safe role-switch logic.

**G3-B scope:** package template-driven VPS migration inputs, per-VPS Secret/certificate lifecycle, staged new->old cutover/rollback, health checks, and a bounded migration rehearsal without requiring a provider purchase unless separately authorized.

**G4 remains mandatory:** the schedule change does not weaken acceptance. Before MVP v1 seal, the near-final WireGuard/HY2/validated REALITY roles must still be tested in a representative peak-hour window and with real Codex/OpenAI/image-generation workloads.

**Current Gate unaffected:** the already-authorized `G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3` remains the active Gate and is not expanded by this roadmap change.


## 2026-10-03 — Freeze real-request retry after masked R3 runner failure

**Decision:** Treat the R3 retry's real-request status as `UNKNOWN` because the top-level exception classifier failed and masked the original phase. Do not reuse the prior one-request authorization. Before any new REALITY/OpenAI request, first complete a local-only runner-hardening Gate; after that Gate passes, require fresh Owner authorization for the next real request.

**Why:** Governance requires ambiguous consequential results to be reconciled before retry and forbids assuming an action did not occur when Evidence cannot prove it. The same round also showed that SFO2-A and its control route are currently ifIndex 9 while the runner hardcodes 13, so the runner must validate runtime consistency instead of a historical interface number.

**Local hardening scope:** make failure classification independently testable and non-throwing; replace fixed ifIndex 13 assertions with dynamic adapter/control-route consistency; prove both through no-network fixtures before any SSH or remote/server work.

**Consequence:** G2-C compatibility remains unresolved, but no protocol conclusion is lost or invented. The next round has zero network actions and no Owner consequential authorization requirement; the subsequent real A/B retry does.


## 2026-10-03 — Accept H1 local runner hardening and require fresh authorization for R4

**Decision:** Accept `G2C_R3_LOCAL_RUNNER_HARDENING_H1` as PASS. The next REALITY interoperability experiment is `G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4`, but it remains proposed until the Owner provides a fresh one-request authorization.

**Why:** H1 proves the two known local runner defects are closed: the failure classifier no longer depends on an unresolvable exception type literal, and WireGuard preflight validates the live adapter/control-route relationship instead of a fixed ifIndex. However, the earlier R3 retry left request state UNKNOWN, so its prior one-request authorization is not reused.

**R4 boundary:** one temporary private Mihomo v1.19.31 server, one unchanged proxied OpenAI request, exact cleanup/read-back; no public TCP/443, persistence, benchmark, protocol/SNI/target change, or production switch.


## 2026-10-03 — Select Mihomo v1.19.31 as the G2-C REALITY server candidate

**Decision:** Accept the R4 private implementation A/B and continue G2-C with **Mihomo v1.19.31 native VLESS+REALITY** as the server candidate. Stop spending v1 implementation effort on the sing-box server path unless later evidence reopens that question.

**Why:** Under the same Windows Mihomo client and unchanged VLESS+REALITY+Vision, SNI and handshake-target semantics, the temporary Mihomo server returned the expected OpenAI HTTP 401 in one bounded request. The accepted sing-box path had repeatedly produced curl 35 / timeout. The server-core implementation difference is therefore materially implicated in this tested configuration.

**Limit:** This does not prove a universal sing-box bug or incompatibility. It also does not prove public TCP/443 interoperability, persistence, production role, or peak-hour superiority.

**Next:** Run one Owner-authorized temporary public TCP/443 canary with a dynamically discovered physical-egress /32 route, then clean up completely. Persistence remains a later step.
## 2026-10-03 — Allow bounded direct Owner-local execution when faster

**Decision:** For this project only, when Reviewer determines that a bounded Owner-local diagnostic/static check or exact already-authorized local checkpoint is materially faster than routing the step through Codex, the Owner may execute the Reviewer-designed atomic command directly.

**Boundary:** This is an execution-channel exception only. It does not authorize new consequential scope, additional real requests, Secret disclosure, permanent network/firewall/routing changes, persistence, production-default changes, or bypass of Gate/Evidence/rollback requirements.

**Current use:** The Unicode Git-path provenance defect may be validated by Owner directly with a read-only canonical-source-only runner mode before any further P1 canary attempt.

## 2026-10-03 — Accept public REALITY path and enter G3-A plan-only automation

**Decision:** Accept `G2C_REALITY_PUBLIC_TCP443_CANARY_P1` as PASS and close G2-C. Begin `G3A_NETWORK_ADAPTATION_LOCAL_ENGINEERING_H1` as a source/offline Gate before any live automatic network switching.

**Why:** The public canary proved the accepted Mihomo v1.19.31 VLESS+REALITY+Vision path over public TCP/443 with a dynamically discovered physical-egress /32 route, one curl 0 / HTTP 401 request, and complete cleanup/read-back. This closes the remaining interoperability/path question but does not yet justify persistent role changes. Governance 11C/11D requires automation to be fail-closed and safe before real automated actions.

**G3-A H1 boundary:** implement a plan-only Windows planner that dynamically resolves the physical egress, consumes explicit WG/HY2/REALITY health states, emits advisory role/route intent, and fails closed on ambiguity. H1 forbids live route/service/proxy/TUN/VPS mutation and does not change the production default.

**Current policy during H1:** WireGuard remains the production/rollback baseline. HY2 and REALITY remain validated candidates. Final priority/default-role selection is deferred to later near-final validation and G4 evidence.

**Consequence:** P1 is not replayed; its one-request budget is exhausted. The next live network activation or automatic switch requires a separate reviewed Gate after H1 passes.

## 2026-10-03 — Close G3-A advisory automation and stage G3-B with source-VPS rollback

**Decision:** Accept G3-A as complete for v1 sensing/classification/advisory scope. Begin G3-B as a staged migration-package effort in which a new target is qualified before cutover and the old/source VPS remains intact through the rollback window.

**Why:** H1–H4 proved dynamic physical-egress discovery, real read-only WG/HY2/REALITY readiness collection, readiness-to-plan semantics, and live H2→H3 advisory integration. The current real state maps to `WIREGUARD_BASELINE`; no actuator or automatic switching is needed to call the advisory layer complete. For migration, rebuilding the old/source VPS after a failed cutover would be a weaker rollback than simply keeping the known-good source available.

**Migration boundary:** Portable templates must not carry SFO3-specific public IP/SNI/WLAN/label constants. Secret movement, provider purchase/new-VPS provisioning, Owner client cutover, and source decommission are separate consequential checkpoints. REALITY remains a cold candidate and is not turned into a persistent service merely to satisfy migration packaging.

**Consequence:** G3-B D1 is repository-only. A later live rehearsal must prove exact source/target identity, protected Secret handling, target WG/HY2 health, REALITY cold readiness, bounded Owner-side qualification, and rollback to the still-valid source before any source decommission.

## 2026-10-03 — Prioritize unified manual control before fresh-target rehearsal

**Decision:** Defer the fresh-target G3-B rehearsal and open G3-C to make the existing WireGuard/HY2/REALITY capability visible and manually selectable through Clash Verge/Mihomo first.

**Reason:** The project already has validated transport candidates and advisory health logic, but the Owner cannot currently see latency or manually select the self-hosted paths in one UI. A usable manual control surface is the next meaningful product-facing milestone and also reduces risk before automatic switching.

**Connectivity boundary:** The Owner's ChatGPT web and Codex Desktop require at least one working VPN at all times. WireGuard is the current production VPN, but the Owner has other temporary VPN options. WireGuard may be disconnected only at an explicit Owner checkpoint after another VPN path is confirmed working. Executor must never strand the Owner with no VPN.

**C1 boundary:** repository-only profile/validator work. No Clash apply, no system proxy/TUN change, no route mutation, no VPS access, no Secret read, and no WireGuard disconnect.

**Later live control:** Prefer a named Mihomo direct node for the WG baseline and dynamic per-node physical-interface binding for HY2/REALITY as the first bypass design. Windows real bypass behavior remains unproven until a bounded live canary.



## 2026-10-04 — Authorize bounded C2C real HY2-in-Clash canary after package validation

Decision:
- Owner explicitly authorized proceeding from synthetic C2B into one bounded real HY2-in-Clash canary.
- Authorization is conditional on Reviewer acceptance of the C2C package before real execution.

Bounds:
- WireGuard remains the continuity/rollback baseline.
- No persistent default change is authorized.
- No C2C performance benchmark, G4 entry, REALITY activation, or broader network mutation is authorized by this decision.
- The real canary is limited to the reviewed temporary-profile/temporary-route lifecycle and the explicitly bounded connectivity requests defined by the accepted C2C Gate.

Rationale:
- C2B already proved Clash UI/profile lifecycle semantics without real credentials or traffic.
- C2C is the next required proof for real HY2 authentication/connectivity inside Clash while preserving immediate rollback.


## 2026-10-04 — Accept bounded Secret scanner repair and real-host Prepare verification

**Decision:** Accept the R2R3 bounded Clash root-lock scanner repair and R2R3V2 real-host Secret Prepare verification as PASS.

**Why:** D7/D8/D8R1 proved the blocker was transient contention on one zero-byte, non-reparse, root-level Clash `.lock`, not DPAPI/recovery corruption or project-runtime residue. The accepted repair bypasses only that exact metadata class after an actual read exception in the Clash-app scan; all other unreadable files remain fail-closed, and the project-runtime scan has no exception. Owner validation then passed Fixtures A-L, PowerShell AST, Mihomo fixture parse, and the real Owner-host Prepare/VerifyCleanup path with zero residue.

**Boundary:** This decision does not authorize generic `.lock` skipping, generic unreadable-file skipping, credential rotation, Clash import, route mutation, external requests, persistent default changes, benchmarks, REALITY activation, or G4.

**Accepted C2C source identities:**
- orchestrator `4424eab2f281af6398f6d7bfbe6e326bce5f7904`
- Secret helper `81c5a43d4a947d57e44752fd7a09c59e735748e2`
- proxy probe `d3403cba9196b55083ff9f443e9011582ef9cc01`
- validator `e520fa7b6c08b2e46365b55ec731a20bdb810c04`
- template `ea18bdccf8f00f2d6d705e4ba34ba57db243722a`
- package doc `d9e815171d8d7b00722b213b6df6d52c46f6265e`

## 2026-10-04 — Require fresh Owner authorization before R3R2 real HY2-in-Clash canary

**Decision:** The next real HY2-in-Clash canary is `G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R3R2` and remains blocked on fresh explicit Owner authorization.

**Why:** The previous consequential real-canary attempt did not complete. Governance does not reuse prior consequential authorization after a failed or ambiguous attempt. R2R3V2 proves the historical Secret Prepare blocker is closed, but that technical readiness does not itself authorize a new profile import, temporary route, or external requests.

**Authorized scope after fresh approval:** one temporary C2C profile, WireGuard retained as rollback, one ActiveStore-only `/32` route, exactly two bounded requests through the dynamically discovered local SOCKS5 listener, then return to WireGuard, profile removal, Secret cleanup, route removal, and full readback.

**Not authorized:** benchmark loops, persistent routes, persistent default changes, system proxy/TUN enablement, automatic switching, REALITY activation, VPS/SSH changes, or G4.


## 2026-10-04 — Owner granted fresh authorization for one R3R2 real HY2-in-Clash canary

**Decision:** Owner explicitly authorized exactly one bounded `G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R3R2` consequential canary after the prior handoff had still recorded authorization as pending.

**Scope:** The authorization is limited to the already-reviewed R3R2 boundary: one temporary C2C profile, WireGuard retained as rollback, one ActiveStore-only IPv4 `/32` route, exactly two bounded requests through the dynamically discovered local SOCKS5 listener, then return to WireGuard, remove the C2C profile, clean Secret runtime state, remove the route, perform full read-back, and stop at Reviewer.

**Not authorized:** benchmark loops, persistent route/default changes, system proxy or TUN enablement, automatic switching, REALITY activation, VPS/SSH mutation, G4, or a blind retry after any consequential failure/ambiguity.

**Execution state:** Authorization is granted; no R3R2 execution result has yet been recorded or accepted. A failed or ambiguous consequential attempt requires reconciliation and fresh authorization before another real attempt.

**Reconciliation:** `REVIEWER_HANDOFF.md` is the canonical current dashboard and has been updated to `AUTHORIZED_NOT_EXECUTED`. The earlier transition snapshot remains a historical snapshot of the state at its creation time.


## 2026-10-04 — Freeze v1 target role order and move G4 to validation

**Owner target decision:** The v1 role order is now fixed for validation as:

1. `HY2-SFO3 = PRIMARY`
2. `WG-BASELINE = BACKUP_1`
3. `REALITY-SFO3 = BACKUP_2`

No additional protocol shopping is planned for v1 unless later evidence proves a capability gap.

**Reviewer interpretation:** This is an Owner product/runtime target decision, not yet a technical production-role PASS. Existing evidence supports the direction: HY2 won the accepted 60/60 same-window comparison and passed R3R2 real Clash lifecycle validation; WireGuard remains the proven production/rollback baseline; REALITY is the validated TCP/443 compatibility fallback. G4 now validates this selected ordering rather than reopening the candidate set.

**Current limitation:** The accepted REALITY public TCP/443 canary was temporary and fully cleaned. Therefore a persistent REALITY backup service/profile does not yet exist, and the three-role production layout is not yet durably ready.

**G4 split:** 
- G4-A: role contract + offline validation plan/package.
- G4-B: persistent three-role readiness, separately consequential and Owner-authorized.
- G4-C: peak-hour + representative real-workload validation, separately authorized after G4-B PASS.

**Application takeover policy:** System proxy is tested before TUN because it is the smaller mutation. TUN remains OFF unless a later explicit Gate proves system-proxy coverage is insufficient and separately authorizes TUN compatibility work.

**Persistent role change boundary:** HY2 is not promoted to the system-wide persistent production default merely by this decision. That promotion waits for G4 acceptance and final v1 sealing.


## 2026-10-04 — Insert G4-B0 Windows bypass proof before persistent three-role readiness

**Decision:** Do not enter persistent G4-B yet. Insert one bounded Owner-host prerequisite Gate, `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1`, to prove whether Mihomo `interface-name` alone can carry HY2 outer traffic over the physical interface while WireGuard remains connected and no exact VPS `/32` bypass route exists.

**Why:** The accepted evidence currently disagrees at the architecture boundary if treated as already solved: G3-A explicitly plans an exact VPS public-IP `/32` physical-egress route for HY2/REALITY fallback roles; G3-C C1 labels Windows `interface-name` bypass as unproven; and R3R2 achieved its real HY2 PASS with a temporary ActiveStore-only `/32` route. Therefore the persistent three-role template must not silently assume `interface-name` is sufficient.

**Bound:** G4-B0 is Windows-local only, uses the existing accepted HY2 server, creates no exact VPS `/32` route, performs no SSH/VPS/REALITY/persistent-profile action, sends at most two bounded real requests, cleans its temporary runtime, and stops at Reviewer.

**Consequence:** If G4-B0 passes, the v1 persistent Clash profile may use `interface-name` without adding a persistent VPS route. If it returns because interface binding is insufficient, Reviewer will design an explicit route lifecycle before G4-B rather than guess. This decision does not authorize the canary or any persistent G4-B write.


## 2026-10-04 — Owner authorized one G4-B0 Windows interface bypass canary

**Decision:** Owner explicitly authorized exactly one `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` attempt.

**Authorized scope:** On the current Owner Windows host only, keep WireGuard connected; prove exact active/persistent VPS `/32` route absence; read the existing HY2 credential only inside the protected Owner-local boundary; render/start one temporary Mihomo HY2 runtime using dynamically discovered `interface-name`; send exactly two bounded external requests; then stop Mihomo, remove temporary Secret runtime state, prove the exact VPS `/32` route is still absent, prove WireGuard/system-proxy/TUN/network baseline is restored, and stop at Reviewer.

**Not authorized:** creating any active or persistent VPS `/32` route, SSH/VPS changes, REALITY activation/deployment, persistent Clash profile writes, system proxy/TUN enablement, benchmark loops, automatic switching, G4-B persistent writes, G4-C workloads, or a blind retry after a consequential/ambiguous failure.

**Execution state:** Authorization is granted but not yet consumed. The live runner must first be completed and reviewed. A pre-start tooling/source failure does not consume authorization if Reviewer reconciliation proves the real Secret/runtime/request phase never started.


## 2026-10-04 — G4-B0 first live attempt consumed authorization and returned before requests

**Decision:** The first live `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` attempt is a formal RETURN, not a bypass result.

**Reason:** The runner reached protected HY2 Secret/runtime preparation, so the one-shot Owner authorization is consumed. Mihomo configuration parsing passed, but the readiness check rejected a Mihomo-owned UDP endpoint before the local proxy-ready marker. Because HY2 itself uses UDP, zero Mihomo UDP endpoints is not a valid readiness invariant.

**Evidence boundary:** Request count remained 0. Therefore this attempt proves neither success nor failure of `interface-name` bypass. Final cleanup/read-back restored WireGuard, system proxy OFF, TUN OFF, zero exact VPS `/32` routes, and no accepted temporary Secret/runtime residue.

**Repair rule:** Future readiness checking may reject UDP binding on the reserved local SOCKS port, but must not reject unrelated Mihomo-owned ephemeral UDP sockets. Failure telemetry must preserve the pre-cleanup failure phase separately from the cleanup phase.

**Authorization:** No retry is authorized by the consumed first-attempt approval. Fresh explicit Owner authorization is required only after the repaired runner passes non-consequential AST/static/validator checks.


## 2026-10-04 — Owner authorized one repaired G4-B0 live retry

**Decision:** After the repaired Owner-host checkpoint PASS, Owner explicitly authorized exactly one repaired `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` live retry.

**Scope:** Same bounded Windows-local canary only: WireGuard remains connected; exact VPS `/32` routes remain absent; existing HY2 credential may be read only inside the protected runtime; one temporary Mihomo HY2 instance may be started; at most two external requests may be sent; cleanup/read-back and mandatory Reviewer stop are required.

**Not authorized:** route creation, SSH/VPS mutation, REALITY, persistent Clash profile writes, system proxy/TUN activation, benchmark loops, automatic switching, G4-B persistent writes, G4-C, or blind additional retries.

**Execution state:** Fresh retry authorization is granted and unconsumed until the runner enters its protected Secret/runtime consequential phase.


## 2026-10-04 — G4-B0 repaired retry returned before requests on SOCKS UDP loopback check

**Decision:** The repaired live retry is a formal RETURN and is not evidence for or against Windows Mihomo `interface-name` bypass.

**Reason:** The retry entered the protected consequential phase and consumed its authorization, but request count stayed 0. Mihomo parse passed; startup readiness then rejected a UDP endpoint on the configured local SOCKS port.

**Interpretation:** A SOCKS5 listener may provide UDP-associate capability on the same local port. Therefore “no UDP endpoint on SOCKS port” is not a valid invariant. The valid invariant is loopback confinement: process-owned TCP/UDP listener surfaces on the configured SOCKS port must be loopback-only; unrelated HY2 outbound ephemeral UDP sockets must not be treated as listeners.

**Baseline:** Final WireGuard state was preserved, system proxy/TUN remained OFF, exact VPS `/32` routes remained absent, and protected runtime/Secret cleanup passed.

**Authorization:** The repaired retry authorization is consumed. No live retry is currently authorized.


## 2026-10-04 — Owner granted standing authorization within current G4-B0 Gate

**Decision:** Owner explicitly approved authorizations within the current `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` Gate.

**Interpretation:** Reviewer may proceed without repeatedly asking for approval for actions already inside the fixed current Gate boundary.

**Non-expansion rule:** This does not authorize any action outside the Gate, including persistent G4-B writes, REALITY deployment, route creation, SSH/VPS mutation, system proxy/TUN activation, benchmark loops, auto-switching, or G4-C.

**Governance override prohibited:** If governance requires a fresh post-failure Owner authorization after a consequential failure, or if the Gate boundary changes, Reviewer must stop and obtain that fresh authorization despite this standing preference.


## 2026-10-04 — G4-B0 formally PASSes Windows Mihomo interface-name bypass

**Decision:** `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` is formally PASS.

**Accepted fact:** On the current Owner Windows host, with WireGuard connected and exact active/persistent VPS `/32` routes both absent, the accepted Mihomo path successfully carried HY2 traffic through the dynamically discovered physical interface using `interface-name`. The bounded OpenAI request returned HTTP 401 through the proxy and the public-exit request matched the accepted SFO3 IP.

**Architecture consequence:** G4-B no longer needs an explicit persistent VPS `/32` route merely to make HY2 outer traffic bypass WireGuard on this Owner host. The persistent three-role design may keep HY2 bound to the physical interface via `interface-name`.

**Boundary:** This proof is transport/path evidence for HY2 only. It is not evidence that REALITY application traffic, automatic switching, peak-hour workloads, or the final production role has passed.

**Next Gate:** `G4B_PERSISTENT_THREE_ROLE_READINESS`. G4-B remains a new consequential Gate and requires its own Owner authorization plus the unresolved second-failure-domain recovery destination before live execution can PASS.


## 2026-10-04 — G4-B offline live-runner package formally accepted after R3

**Decision:** The G4-B persistent three-role live-runner source/fixture package is formally accepted
for later live execution.

**Accepted repairs:** R1/R2/R3 source review now covers portable two-copy recovery, non-root REALITY
runtime filesystem/access, profile restart persistence, retained exact-run rollback/closeout state,
sanitized live markers, remote route/firewall/service drift proof, SHA-256 profile-store integrity,
and StrictMode-safe recovery cleanup.

**Boundary:** No live G4-B deployment has occurred. The next Gate remains
`G4B_PERSISTENT_THREE_ROLE_READINESS` and still requires Owner-selected second-failure-domain
encrypted recovery destination plus explicit live consequential authorization.


## 2026-10-04 — Owner authorized live G4-B; recovery destination still pending

**Decision:** Owner explicitly authorized the consequential `G4B_PERSISTENT_THREE_ROLE_READINESS` live deployment.

**Remaining prerequisite:** execution must not start until the encrypted portable recovery artifact has an approved second failure domain distinct from both the SFO3 VPS and the current Windows local disk.

**Repository boundary:** the ordinary project GitHub repository is not used for private recovery material under the current Gate. Using GitHub as an encrypted-storage provider would require a separate explicitly reviewed storage design; it is not inferred from the live authorization.


## 2026-10-04 — Baidu Netdisk selected for portable G4-B recovery

**Decision:** Owner selected Baidu Netdisk as the second failure domain for the portable encrypted
G4-B recovery artifact.

**Implementation consequence:** The reviewed G4-B runner must first gain an offline-reviewed Baidu
CLI backend because its accepted recovery backend was filesystem-based. Only encrypted portable
recovery ciphertext may be uploaded.

**Credential boundary:** Baidu account credentials/cookies/tokens remain Owner-local Secret state.
They are never requested in chat, committed to Git, or passed by the G4-B runner as command-line
credential flags.

**Live boundary:** Owner's live G4-B authorization remains granted, but no real Baidu login/upload
or live G4-B execution begins until the R4 backend package is Reviewer PASS and local CLI
authentication is proven.


## 2026-10-05 — Baidu recovery backend R4 returned for three source defects

**Decision:** R4 remains offline-only and is Reviewer RETURN.

**Accepted:** credential-free CLI argv boundary, local-auth readiness design, encrypted portable
artifact only, synthetic pending readback, delayed final promotion, and pending-only rollback.

**Blocking repairs:** default downloaded ZIP must be opened from its local verified path; production
local pending filename must match the expected remote pending object semantics; and the extracted
BaiduPCS-Go executable must have a fixed reviewed SHA-256 equality check in addition to the archive
digest.

**Next:** `G4B_BAIDU_NETDISK_RECOVERY_BACKEND_REPAIR_R5`. No Owner action or real Baidu login is
required during R5.


## 2026-10-05 — Release archive hash is the Baidu CLI trust anchor

**Decision:** For the pinned BaiduPCS-Go v4.0.2 Windows x64 asset, the authoritative GitHub Release
asset SHA-256 plus constrained extraction is sufficient supply-chain identity. A separately
pre-pinned inner executable digest is not required.

**Reason:** the full archive SHA-256 authenticates every contained byte. The runner verifies that
digest before extraction and accepts exactly one bounded, traversal-safe `BaiduPCS-Go.exe` entry.

**Rejected shortcut:** GitHub Actions artifact executable hashes are not treated as the release
binary hash because the upstream CI and release build paths are not proven byte-identical.

**Remaining repair:** use the verified downloaded local archive path for extraction and align the
production local pending basename with the exact remote pending object basename.


## 2026-10-05 — Baidu recovery backend R5R1 formally accepted

**Decision:** `G4B_BAIDU_NETDISK_RECOVERY_BACKEND_REPAIR_R5R1` is Reviewer PASS.

**Accepted repair:** the pinned release archive is opened from the verified local path, and the production pending local/remote basename is unified with a fail-closed pre-CLI mismatch guard. R1-R4 regressions and R5R1 fixtures passed; the mismatch negative fixture proves zero CLI calls before rejection.

**Boundary:** This is an offline source PASS only. No real Baidu/VPS/Secret/network action occurred and `G4B_PERSISTENT_THREE_ROLE_READINESS` remains IN_PROGRESS.

**Next:** `G4B_BAIDU_OWNER_AUTH_READINESS_CHECKPOINT_R6` prepares one offline-reviewed Owner-local readiness verifier. R6 itself performs no real login or provider action. Owner credentials remain local and are never relayed through chat, GitHub, logs, environment variables, or process arguments.


## 2026-10-05 — R6 returned only for incomplete ACL invariant

**Decision:** `G4B_BAIDU_OWNER_AUTH_READINESS_CHECKPOINT_R6` is Reviewer RETURN with reason `RETURN_R6_ACL_INVARIANT_INCOMPLETE`.

**Accepted:** all non-ACL R6 boundaries, including no credential input, no login action, pinned archive verification, read-only future `who`, raw-output/UID suppression, fail-closed account handling, bounded cleanup, synthetic fixtures, and zero live actions.

**Fixture judgment:** the fallback from a real dangerous DACL mutation to synthetic ACE objects is acceptable because the synthetic rules are passed into the exact production ACL predicate. The local privilege limitation is not the blocker.

**Blocking gap:** the production config ACL predicate checks Owner identity and three broad Allow SIDs but does not yet prove inheritance handling, Deny-rule safety, a complete safe-principal allowlist, or the Owner's required read rights as required by Governance v0.2.7.

**Next:** `G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1` performs only that ACL predicate/fixture repair and reruns the complete R6 regression. No Owner/live action is needed.


## 2026-10-05 — R6R1 ACL repair formally accepted

**Decision:** `PASS_G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1`.

The previous R6 ACL completeness blocker is closed. Production ACL validation now covers exact Owner identity, direct/inherited ACE review, explicit safe Allow principals, Deny rejection, arbitrary/broad principal rejection, and required Owner read/list/traverse rights. Eight synthetic fixtures exercise the exact production predicate and the complete R6 regression remains PASS.

No real Baidu/provider/config/network/VPS/Secret action occurred. Next Gate is `G4B_BAIDU_OWNER_AUTH_READINESS_RUN_R6R2`: a single Owner-local read-only readiness run. No login or live G4-B is authorized.


## 2026-10-05 — R6R2 paused for Owner-local UID discovery

Owner does not know the expected Baidu numeric UID. R6R2 is therefore paused before execution. No identity value is guessed and no credential-bearing config content is read.

Next Gate: `G4B_BAIDU_OWNER_UID_DISCOVERY_HELPER_R6R2A`, an offline-only implementation/validation round for a minimal local UID discovery helper using the already accepted pinned archive, config ACL, and read-only `who` boundaries.


## 2026-10-05 — R6R2A UID discovery helper formally accepted

**Decision:** `PASS_G4B_BAIDU_OWNER_UID_DISCOVERY_HELPER_R6R2A`.

The helper is bounded to the accepted R6R1 trust/config/ACL/read-only who path. It does not accept credentials or login, suppresses provider raw output/username, parses a single numeric UID, and only displays that UID locally after successful cleanup. Offline fixtures, AST, Secret scan, and zero-live-action evidence are accepted.

Next Gate: `G4B_BAIDU_OWNER_UID_DISCOVERY_RUN_R6R2B`. The numeric UID remains Owner-local and must not be pasted into chat/GitHub.


## 2026-10-05 — R6R2B returned: Baidu config absent; prepare bounded interactive auth

**Decision:** `RETURN_OWNER_ACTION_REQUIRED_R6R2B_CONFIG_ABSENT`.

The UID helper stopped before temporary runtime creation, so no `who` was attempted and no UID was displayed. The selected BaiduPCS-Go config is not currently available for read-only identity discovery.

Pinned BaiduPCS-Go v4.0.2 source confirms cookie/BDUSS/username/password flag-based login would expose credential material in process arguments and is forbidden. A no-argument interactive `login` prompts locally with password no-echo, but upstream marks it long-unmaintained. Therefore the next step is the offline-only `G4B_BAIDU_OWNER_INTERACTIVE_AUTH_HELPER_R6R2C` Gate; no manual login is authorized yet.


## 2026-10-05 — R6R2C interactive-auth helper formally accepted

**Decision:** `PASS_G4B_BAIDU_OWNER_INTERACTIVE_AUTH_HELPER_R6R2C`.

The reviewed helper provides a bounded Owner-local authentication path using only no-argument interactive `login`; credential-bearing CLI flags/environment are prohibited. Login console streams remain local and uncaptured; config state is classified before mutation; unknown non-empty config fails closed; post-login ACL is validated before one read-only `who`; UID and raw who output are not emitted; success requires verified cleanup.

The frozen R6R2A validator CRLF guard false negative is a validator text-pattern defect only and does not invalidate the accepted R6R2A helper or R6R2C source.

Next Gate: `G4B_BAIDU_OWNER_INTERACTIVE_AUTH_RUN_R6R2D`.


## 2026-10-05 — R6R2D returned on provider busy + config owner mismatch

**Decision:** `RETURN_G4B_BAIDU_INTERACTIVE_AUTH_R6R2D_PROVIDER_BUSY_OWNER_MISMATCH`.

The one authorized interactive login received upstream code 50052 (system busy). The helper-created config directory became non-empty, then strict metadata validation failed because a config item Owner was not the exact current Owner SID. No `who` was run and no UID was emitted.

Pinned v4.0.2 source shows the config file is `pcs_config.json` and an error returned by `RunLogin` exits before `SetupUserByBDUSS`. The residue is therefore a bounded failed-login partial state, but it will not be deleted or modified until a metadata-only exact-shape reconciliation passes.

Next: offline `G4B_BAIDU_PARTIAL_CONFIG_RECONCILIATION_REPAIR_R6R2E` to build a one-shot residue rollback checkpoint and repair post-login Windows Owner/ACL normalization. Login replay remains unauthorized.


## 2026-10-05 — R6R2E returned for pre-existing empty-root rollback provenance defect

**Decision:** `RETURN_R6R2E_PREEXISTING_EMPTY_ROOT_DELETION_RISK`.

R6R2E's metadata-only residue reconciliation and post-login ACL normalization design are accepted. However, the auth helper's fallback branch can delete a config root that existed empty before the run: when login starts/fails before a config file or post-login shape proof exists, the helper invokes `Remove-NewEmptyBaiduConfigDirectory` without checking `interactiveAuthConfigCreated`.

This violates the explicit requirement that a pre-existing empty root be preserved. The next Gate, `G4B_BAIDU_PREEXISTING_EMPTY_ROLLBACK_REPAIR_R6R2E_R1`, is limited to restoring exact root provenance in rollback and adding production-function regression fixtures. No Owner action or login replay is authorized meanwhile.


## 2026-10-05 — R6R2E-R1 rollback provenance repair formally accepted

**Decision:** `PASS_G4B_BAIDU_PREEXISTING_EMPTY_ROLLBACK_REPAIR_R6R2E_R1`.

The auth helper now preserves any pre-existing empty config root on failure and permits exact empty-root deletion only when root provenance proves it was created by the current run. Exact config-file rollback remains file-only for a pre-existing root and file+root for a run-created root. Six production-function provenance fixtures and full regression passed.

The accepted metadata-only failed-run reconciliation helper remains frozen. Next Gate: `G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_RUN_R6R2F`.


## 2026-10-05 — R6R2F exact failed-run residue reconciliation passed

**Decision:** `PASS_G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_RUN_R6R2F`.

The Owner-host metadata-only checkpoint identified the exact R6R2D failed-run residue and removed only the exact `pcs_config.json` plus the verified-empty exact config root. The pre-login absent baseline is restored, and no config content was read.

One new bounded interactive login retry is now authorized through `G4B_BAIDU_OWNER_INTERACTIVE_AUTH_RETRY_R6R2G`. Repeated retries and Cookie/BDUSS fallbacks remain unauthorized.


## 2026-10-05 — R6R2G retires deprecated username/password Baidu login

**Decision:** `RETURN_R6R2G_DEPRECATED_INTERACTIVE_LOGIN_50052_EXIT_ZERO`.

The single authorized retry again displayed provider error 50052. The helper then returned `BAIDU_AUTH_WHO_OUTPUT_AMBIGUOUS` because stock BaiduPCS-Go v4.0.2 does not reliably propagate login action errors to the native process exit: `app.Run(os.Args)` is called without using its returned error. The repaired rollback removed all config state created by the failed attempt.

Public upstream guidance now makes the larger conclusion decisive: username/password interactive login is long-unmaintained, and the maintainer explicitly says not to use it. No further retry is authorized.

The supported Cookie/BDUSS paths cannot be invoked through stock CLI flags because Secret values would appear in process arguments. Next Gate `G4B_BAIDU_SECURE_COOKIE_AUTH_ADAPTER_R6R2H` builds a credential-safe local no-echo Cookie adapter against the exact pinned v4.0.2 source.


## 2026-10-05 — R6R2H Cookie adapter core accepted; Owner checkpoint returned for ACL/reconciliation gap

**Decision:** `RETURN_R6R2H_OWNER_CHECKPOINT_POSTAUTH_ACL_AND_FAILURE_RECONCILIATION_GAP`.

The pinned no-echo Cookie adapter and build chain are accepted. The remaining defect is in the Owner orchestration: it performs strict R6R1 validation before normalizing a child-created config file Owner/ACL, recreating the Windows Owner-mismatch failure already observed in R6R2D. It also lacks provenance-aware rollback for a run-created empty root or exact partial `pcs_config.json` after adapter/post-auth failure.

R6R2H-R1 is limited to repairing the Owner checkpoint and validator using the accepted R6R2E metadata/normalization/reconciliation pattern. No real Cookie action is authorized yet.


## 2026-10-05 — R6R2H returned for missing post-save ACL normalization

**Decision:** `RETURN_R6R2H_COOKIE_OWNER_CHECKPOINT_MISSING_POSTSAVE_ACL_NORMALIZATION`.

The credential-safe Cookie adapter and pinned build path are accepted. The Owner checkpoint is not yet safe to run because it applies strict R6R1 config ACL validation immediately after the adapter creates `pcs_config.json`, before normalizing the child-created file Owner/ACL. R6R2D already demonstrated this Windows ownership mismatch on the real Owner host.

R6R2H-R1 is limited to restoring the accepted R6R2E ordering: exact metadata shape -> Owner/ACL normalization -> strict R6R1 validation, plus failure provenance for pre-existing/new empty roots. No real Cookie/auth action is authorized meanwhile.


## 2026-10-05 — Canonicalize R6R2H-R1 Gate

A concurrently present, stricter R6R2H-R1 Gate already covered both post-auth ACL normalization and failure/partial-write reconciliation. It is the canonical Gate:
`G4B_BAIDU_SECURE_COOKIE_OWNER_CHECKPOINT_REPAIR_R6R2H_R1`.

The narrower duplicate Gate is superseded and must not be executed. No runtime or Secret state changed.


## 2026-10-05 — Fresh re-review supersedes unexecuted R6R2H-R1

**Decision:** `RETURN_R6R2H_REREVIEW_ADAPTER_PARSE_AND_PREFLIGHT_ORDER_GAP`.

A clean Reviewer re-review confirmed the earlier Owner-checkpoint ACL/reconciliation RETURN and found two additional pre-real-run defects: the adapter validates an exact session field but then leaves the pinned upstream to re-extract from the whole Cookie string with an unanchored search; and the Owner checkpoint can create the canonical config root before proving the adapter binary/runtime candidate identity.

No R6R2H-R1 execution occurred. That Gate is superseded, not failed in execution.

Next canonical Gate: `G4B_BAIDU_SECURE_AUTH_OWNER_COMBINED_REPAIR_R6R2H_R2`. It narrowly repairs exact-field handoff plus preflight-before-write, post-write ACL normalization, and provenance-aware rollback. The pinned build helper and accepted historical helpers remain frozen.


## 2026-10-05 — R6R2H-R2 returned only for missing Owner config-state marker

**Decision:** `RETURN_R6R2H_R2_OUTPUT_CONTRACT_CONFIG_STATE_MISSING`.

The combined parser, preflight ordering, post-write ACL normalization and provenance-aware rollback repairs are accepted. The remaining blocker is the Owner result contract: the active Gate requires a bounded `BAIDU_COOKIE_AUTH_CONFIG_STATE` marker, but the candidate checkpoint does not emit it and the validator does not enforce the complete eight-marker contract.

R6R2H-R3 is a narrow output/validator repair. The accepted adapter/parser, build chain, ACL normalization and reconciliation core are frozen. No real Owner/provider action is authorized meanwhile.


## 2026-10-05 — R6R2H-R3 output contract repair formally accepted

**Decision:** `PASS_G4B_BAIDU_OWNER_OUTPUT_CONTRACT_REPAIR_R6R2H_R3`.

The Owner checkpoint now emits the missing bounded pre-auth config-state marker using only `NOT_REACHED`, `ABSENT_PREAUTH`, or `PREEXISTING_EMPTY`. Assignment occurs only after the accepted pre-run provenance checks and is not overwritten after authentication. The complete eight-marker output contract is validator-enforced, while the accepted R6R2H-R2 core remains frozen.

Next Gate: `G4B_BAIDU_OWNER_SECURE_AUTH_RUN_R6R2I`, an Owner-local one-shot secure authentication checkpoint.


## 2026-10-05 — R6R2I returned before authentication on retained-build failure

**Decision:** `RETURN_R6R2I_BUILD_VALIDATION_FAILED_BEFORE_AUTH`.

The Owner build reached and passed adapter Go tests, then the frozen build helper returned generic `BUILD_VALIDATION_FAILED`; temporary build cleanup passed. The wrapper stopped before the authentication checkpoint, so no authentication material/provider action occurred.

Do not retry. The next step is a metadata-only Owner diagnostic of the project runtime directories and retained binary state. The known `SeSecurityPrivilege` limitation is a candidate explanation for the retained-binary ACL stage but remains unproven until reconciliation.


## 2026-10-05 — R6R2I-D1 proves clean runtime residue state

**Decision:** `PASS_R6R2I_D1_RUNTIME_RESIDUE_DIAGNOSTIC`.

The Owner runtime root and runtime directory are present and safe; the retained adapter binary is absent; authentication did not start; the read-only diagnostic made zero mutations. The failed R6R2I attempt therefore needs no runtime cleanup.

Next Gate: `G4B_BAIDU_RETAINED_BINARY_CREATION_REPAIR_R6R2I_D2`. It repairs only retained-binary creation/ACL/readback and failure-stage diagnostics. No build/auth retry is authorized until Reviewer PASS.


## 2026-10-05 — R6R2I-D2 retained binary creation repair formally accepted

**Decision:** `PASS_G4B_BAIDU_RETAINED_BINARY_CREATION_REPAIR_R6R2I_D2`.

The retained adapter path now uses fail-on-existing creation with the Owner-only descriptor applied at creation, followed by unchanged strict ACL and exact hash readback. Expected persistence-stage failures have bounded codes, and failed-run cleanup removes only the exact run-created leaf while preserving runtime directories. Temporary production-function fixtures and full R6R2H-R3/R6R1 regressions passed.

The earlier generic Owner build failure remains unattributed; it is not retrospectively labeled as an ACL privilege failure.

Next Gate: `G4B_BAIDU_OWNER_RETAINED_BUILD_RETRY_R6R2I_D3`, which retries only the retained build once and stops before authentication.


## 2026-10-05 — R6R2I-D3 real Owner retained build passed

**Decision:** `PASS_G4B_BAIDU_OWNER_RETAINED_BUILD_RETRY_R6R2I_D3`.

The reviewed D2 build helper succeeded on the real Owner host. Pinned upstream/toolchain identities matched, the Windows amd64 adapter digest exactly matched the reviewed value, the retained runtime binary was created, Go tests and native failure fixture passed, and temp cleanup passed. Authentication did not start.

Next Gate: `G4B_BAIDU_OWNER_SECURE_AUTH_RUN_R6R2I_D4`, exactly one Owner-local authentication checkpoint using the existing retained binary, with no rebuild or retry.


## 2026-10-05 — R6R2I-D4 authentication state accepted; output contract returned

**Decision:** `PASS_AUTH_STATE_RETURN_D4_EXTRA_ADAPTER_MARKERS`.

The one authorized Owner authentication attempt succeeded: checkpoint `SETUP_SAVED`, failure `NONE`, native exit 0, pre-auth state `ABSENT_PREAUTH`, authenticated config preserved, content-read NO, who NOT_RUN, UID emitted NO.

The successful authenticated config is accepted and no authentication retry is authorized.

D4 is not fully closed because the child adapter also emitted two bounded status lines directly to the inherited console, so the end-to-end Owner output exceeded the exact eight-marker contract. This is an output/reviewability defect, not an authentication-state defect.

Next Gate: `G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5`, offline only.


## 2026-10-05 — R6R2I-D5 source repair accepted, compiled evidence missing

**Decision:** `RETURN_R6R2I_D5_GO_SOURCE_TESTS_UNAVAILABLE`.

The D5 source delta is narrowly accepted: only the adapter's 16 fixed child status writes were removed, while hidden input, authentication parsing/setup/save logic and native exit behavior remain source-frozen. The Owner checkpoint remains unchanged with its exact eight-marker output contract.

The Gate nevertheless requires actual `GO_SOURCE_TESTS=PASS` and a compiled native failure fixture. These were not executed because the Executor environment lacked Go and D5 prohibited fetching it. Static evidence is not sufficient to waive an explicit Gate requirement.

Next Gate: `G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1`. It permits only pinned public build/toolchain/module retrieval, runs the build helper without `-RetainBinary`, then the full validator. The accepted authenticated config and real Owner runtime remain frozen.


## 2026-10-05 — D5 output repair and D5-R1 compiled verification passed

**Decision:** `PASS_G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1`; parent repair `PASS_G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5`.

The missing compiled evidence is now complete: pinned provenance, Go source tests, Windows/amd64 build, native invalid-argument fixture, absence of child status markers, temp cleanup, full validator and Secret scan all passed. The verification run did not access the real Owner config/runtime binary and made no provider request.

The real authenticated config remains accepted and frozen. No authentication retry is authorized.

Next Gate: `G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_R6R2J`, a single Owner-local read-only identity check using the already reviewed UID helper. It must not perform any provider file operation.


## 2026-10-05 — R6R2J UID discovery returned ambiguous; parser repair required

**Decision:** `RETURN_R6R2J_BAIDU_UID_OUTPUT_AMBIGUOUS`.

The one authorized post-auth read-only UID-discovery attempt failed closed with `BAIDU_UID_OUTPUT_AMBIGUOUS`; temporary runtime cleanup passed and no UID was accepted for downstream use.

Reviewer inspection found an offline parser defect: the discovery helper counts generic `uid` mentions across provider stdout/stderr, while the pinned v4.0.2 `who` identity contract and accepted readiness parser derive identity from the unique canonical `当前帐号 uid: <numeric>, ...` line. Generic extra `uid` text can therefore create a false ambiguity.

The authenticated config remains accepted/frozen. No re-authentication or immediate `who` retry is authorized. Next Gate: `G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1`.


## 2026-10-05 — R6R2J-R1 UID parser repair passed

**Decision:** `PASS_G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1`.

The repaired discovery parser now matches the intended pinned `who` identity contract: one canonical account-identity line is the sole UID source; unrelated generic `uid` text no longer creates a false ambiguity; duplicate canonical identity lines still fail closed. All required offline fixtures, AST parsing, cleanup regression and Secret scan passed.

No real authentication, Owner config access or provider action occurred. The authenticated config remains accepted/frozen.

Next Gate: `G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_RETRY_R6R2J_R2`, exactly one Owner-local read-only retry.


## 2026-10-05 — R6R2J-R2 remained ambiguous; lock `who` decoding to UTF-8

**Decision:** `RETURN_R6R2J_R2_BAIDU_UID_OUTPUT_AMBIGUOUS`.

Because the R6R2J-R1 parser already accepts one canonical identity line plus unrelated generic `uid` text, the repeated ambiguity narrowed the remaining boundary to canonical-line visibility. The inherited redirected child process did not explicitly define stdout/stderr decoding. The pinned Go CLI's Chinese `who` line is UTF-8, so the UID-only read path now sets both redirected decoders to UTF-8 while preserving the frozen one-`who`, no-login StartInfo contract.

The accepted authentication config and authentication/readiness checkpoint remain frozen; no re-authentication is authorized.

Next Gate: `G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3`. Owner first runs the full local validator; only on PASS may exactly one read-only `who` retry occur.


## 2026-10-05 — Post-auth Baidu identity confirmed; carry UTF-8 fix into live runner

**Decision:** `PASS_G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3`.

The accepted authenticated config successfully produced one canonical account UID through a real read-only `who`; the numeric value remained Owner-local and runtime cleanup passed.

The old standalone R6R2 readiness rerun is superseded for this post-auth path because feeding the just-discovered UID back into the same config immediately would provide no independent identity evidence. The live runner's own account-match guard remains required before recovery/provider mutation.

Reviewer applied the same explicit UTF-8 stdout/stderr decoding boundary to the live runner's bounded Baidu CLI process path so both `who` and later Chinese-text listing parsing use the same proven decode contract.

Next Gate: `G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K`, offline validator only.


## 2026-10-05 — R6R2K offline live-runner validation passed; enter one-shot live G4-B

**Decision:** `PASS_G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K`.

The full current G4-B live-runner fixture suite and negative fixtures pass with explicit UTF-8 decoding for the bounded Baidu CLI path. No live action occurred.

The project may now enter exactly one live G4-B execution using the locked runner. The existing recorded Owner authorization is limited to the accepted G4-B scope: encrypted recovery publication, project-owned persistent REALITY service, one persistent three-role Clash profile, bounded restart/read-back and rollback. G4-C and automatic switching remain forbidden.

Next Gate: `G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L`.


## 2026-10-05 — R6R2L stopped at P0; canonical Git path scope repaired

**Decision:** `RETURN_R6R2L_P0_CANONICAL_GIT_QUERY_FAILED`.

The first live G4-B invocation exited during `P0_CANONICAL_SOURCE` with `CONSEQUENTIAL_MUTATION_STARTED=NO`, so no rollback is required and no provider/VPS/Clash/Secret state changed.

Root cause: pathspec-sensitive Git commands used `-C` at the project subdirectory while also supplying repository-root-relative paths containing the project prefix. The repair runs `ls-files` and project-scoped `status` from the discovered repository root.

Next Gate: `G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1`, offline validation only. A new live retry Gate must use the repaired runner blob and may be authorized only after this validation passes.


## 2026-10-06 — R17R1 local code validation required before R17 release

**Decision:** `HOLD_R17_PENDING_R17R1_OFFLINE_CODE_VALIDATION`.

The prepared R17 consequential quarantine Gate remains unexecuted. Owner authorization is recorded, but execution is not released. Reviewer reconciliation determined that source usability must be confirmed locally before any Provider mutation: the complete helper/validator require executable offline evidence, including a regression for stale inherited `$LASTEXITCODE`, negative parser/cardinality/directory fixtures, and forward/rollback usability evidence.

Code modification and executable verification are delegated to local Codex under `G4B_BAIDU_STALE_PENDING_QUARANTINE_CODE_VALIDATION_R6R2L_R17R1`. R17R1 is offline-only: no Baidu access, Owner config read, Secret/DPAPI access, SSH/VPS/Clash/network mutation, live G4-B, G4-C, or R17 Run mode.

Only after Codex returns final blobs and PASS_CANDIDATE evidence may Reviewer re-review/relock the implementation and decide whether the previously recorded R17 authorization can be released for the bounded one-shot checkpoint.


## 2026-10-06 — R17R1 formal PASS and R17 release

Decision: `PASS_R17R1_OFFLINE_CODE_VALIDATION_AND_RELEASE_R17`.

Canonical final source identities:
- helper: `9c910628932c22c448c822437fd53e0b71804a9c`
- validator: `7a555224720ce65b724012c425b58d6aad2c9026`

R17R1 repaired and proved:
- synthetic listing newline fixtures;
- inherited `$LASTEXITCODE` false-failure handling;
- rollback success-stream/Boolean normalization at all three production call sites;
- executable forward-success and rollback-success state-machine behavior;
- multiple-pending and final-present negative rejection fixtures;
- source/target shape, directory collision, unknown-object and default-nonmutating boundaries.

Final Reviewer direct readback confirms the helper still defaults to `Validate`, requires `OwnerAuthorized` for Run, limits Provider actions to `who / ls / mv`, contains no permanent-delete action, and preserves one-forward/one-rollback limits.

The Owner's previously recorded authorization for the exact bounded R17 quarantine Gate is released without scope expansion. Permanent deletion, live G4-B and G4-C remain unauthorized by this decision. Provider mutation has not yet executed.


## 2026-10-06 — R17 formal PASS; R18 independent CLEAN readback required

Decision: `PASS_R6R2L_R17_STALE_PENDING_QUARANTINE`.

R17 executed exactly once under the previously authorized/relocked Gate. Fresh precheck proved one pending source and absent quarantine target. Exactly one source→quarantine rename succeeded. Post-readback proved production namespace final=0/pending=0/unknown=0, source absent and quarantine present. Rollback was not required; permanent delete did not occur.

R17 post-readback is not treated as the final durable CLEAN proof. A separate read-only Gate `G4B_BAIDU_RESIDUAL_CLEAN_READONLY_R6R2L_R18` at blob `f42237242503405c11f652240b4baedec8e71e22` must independently report CLEAN before live G4-B resumes. The quarantine object remains retained and outside the production project prefix.


## 2026-10-06 — Release one R19 live invocation

Decision: `AUTHORIZE_R19_ONE_SHOT_LIVE_RESUME`.

Fresh Owner authorization is recorded for Gate `G4B_PERSISTENT_THREE_ROLE_LIVE_RESUME_AFTER_CLEAN_R6R2L_R19` only. The released execution identity is runner `2faf59ec5a1653a275b11504fe567d0fc871f94e` and validator `26eff5e0ec7c3d12fc436fe1b7b32b27929ab8d3`. Exactly one live invocation is authorized.

Scope includes persistent project-owned REALITY service/credentials, project TCP/443 listener, one SELF-VPN-V1 profile import without activation, and encrypted Baidu recovery pending→final promotion. G4-C, automatic switching, second live invocation, removal of WG/HY2, and permanent deletion of the retained R17 quarantine object remain outside authorization.


## 2026-10-06 — R19 RETURN; revoke live release pending local parse repair

Decision: `RETURN_R19_P5_MIHOMO_CONFIG_PARSE_FAILED`.

R19 stopped at P5 after the encrypted Baidu pending recovery artifact was verified but before any persistent remote mutation. The real installed Mihomo parser rejected the rendered local three-role profile. Remote rollback and owned Baidu pending rollback both reported PASS.

The one-shot R19 authorization is consumed and is not reusable. Canonical live authorization is revoked. R19R1 is a local Codex offline diagnostic/repair Gate; it cannot authorize any live retry.


## 2026-10-06 — Narrow final G4 validation and add WireGuard-in-Clash migration

Owner decision:
- existing performance evidence is sufficient; do not run another heavy peak-hour/percentile/Codex/image-generation workload matrix for v1;
- G4-C acceptance is reduced to a functional smoke: manually select HY2, WG and REALITY in Clash and prove normal ChatGPT conversation works on each;
- add G4-D before v1 seal to migrate WG-BASELINE from the standalone Windows WireGuard client into a native Clash/Mihomo WireGuard node;
- keep the Windows WireGuard client as production/rollback until G4-D formally PASSes;
- after G4-D PASS, the standalone Windows WireGuard client may be disabled and Clash Verge becomes the single control plane.

This decision changes future validation scope only. The current R19R1 local Mihomo parse diagnostic remains unchanged.


## 2026-10-06 — PASS R19R1; prepare fresh R20 live Gate

Decision: `PASS_R19R1_LOCAL_MIHOMO_PARSE_REPAIR`.

Accepted cause: the production renderer left the HY2 certificate fingerprint sentinel unrendered. The alternative `encryption: ""` hypothesis was rejected by executable single-variable testing. The repair reuses the certificate SHA-256 fingerprint already verified against the accepted pin, passes it explicitly to the renderer, validates its exact format, and writes it into the HY2 proxy.

Executable proof is accepted: the legacy sentinel profile is rejected by the installed Mihomo parser while the repaired synthetic production-renderer output parses successfully. Package and full live-runner fixture regressions passed with no consequential actions.

A new live Gate R20 is prepared at `a35f1c4c62091338a1ef71c19f1af0ac94a60a46`. R19 authorization remains consumed. R20 requires fresh Owner authorization before exactly one live invocation can be released.


## 2026-10-06 — Standing authorization for documented closeout roadmap

Owner decision: all remaining authorization checkpoints in the currently documented closeout roadmap are approved without repeated prompts.

Applies to R20, the lightweight G4-C three-role ChatGPT smoke, G4-D WireGuard-in-Clash migration, and MVP v1 seal. One-shot execution limits and Reviewer stops remain unchanged. Any materially expanded scope still stops for review.


## 2026-10-06 — RETURN R20 at P7; no blind rollback retry

Decision: `RETURN_R20_P7_UNCLASSIFIED_ROLLBACK_UNKNOWN`.

Because consequential remote mutation had started and automatic rollback is unverified, neither R20 nor its rollback path may be blindly replayed. First action is R20R1 read-only reconciliation of the exact project-owned service/listener/paths/transaction state. No Secret content, provider action, Clash mutation, or network mutation is authorized.


## 2026-10-06 — R20R1: consequential surface clean, transaction residue remains

R20R1 proves the REALITY service/listener/process/binary/runtime/config/unit and runtime identity were removed, while WireGuard and HY2 remain healthy. Only the R20 transaction directory/state is known to remain. Do not delete it yet; R20R2 must classify its exact allowlisted contents and created-parent metadata first.


## 2026-10-06 — R20R2 PASS; exact R20 transaction cleanup released

Decision: `PASS_R20R2_TRANSACTION_RESIDUAL_CLASSIFIED`.

R20R2 proves the residual transaction directory is project-owned, has the expected metadata, contains exactly two allowlisted files, has no unknown child, and references no still-present created parent directories. R20R3 may therefore remove exactly the staged unit, state JSON, and resulting empty transaction directory after repeating ownership and clean-baseline checks. Recovery artifacts and Baidu remain out of scope.


## 2026-10-06 — PASS R20R3; VPS-side R20 residue closed

Decision: `PASS_R20R3_REMOTE_TRANSACTION_CLEANUP`.

The only classified R20 transaction residue was deleted under exact ownership checks, and post-clean readback preserved the clean REALITY baseline and healthy WG/HY2. No recovery, Baidu, Clash, or local network state was changed.

R20R4 now reconciles the retained recovery pending set read-only before any deletion.
