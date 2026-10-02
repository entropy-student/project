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
