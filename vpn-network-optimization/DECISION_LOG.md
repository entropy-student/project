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

