# G4 Final Three-Role Validation Plan

Status: REVIEWED_OFFLINE_PLAN

## 1. Owner target role order

The v1 target role order is now fixed for validation:

1. **HY2-SFO3 — PRIMARY**
2. **WG-BASELINE — BACKUP_1**
3. **REALITY-SFO3 — BACKUP_2**

This is an explicit Owner target decision, not yet a technical production-role PASS. G4 validates whether the near-final system safely supports this ordering. No additional protocol candidate is added unless later evidence proves a capability gap.

## 2. Accepted facts carried into G4

- WireGuard remains the current production and rollback baseline.
- The accepted WireGuard Windows route shape is the two IPv4 /1 defaults; the strict WFP kill-switch is not currently active.
- HY2 server readiness and real authentication are already proven.
- The accepted same-window comparison completed 60/60 samples for both WireGuard and HY2; HY2 was better on median and tail metrics in that window, but peak-hour superiority remains unproven.
- R3R2 formally proved real HY2 use through the normal Clash profile lifecycle and explicit local SOCKS5 path, followed by complete cleanup/read-back.
- VLESS + REALITY + Vision interoperability is proven on the accepted Mihomo v1.19.31 server/client path over public TCP/443.
- The accepted REALITY public canary was temporary: its server/client runtime, public listener, temporary route, and ephemeral credential material were removed after validation. A persistent REALITY backup node does not currently exist.
- Persistent automatic switching is not accepted. The intended v1 control model remains manual role selection unless a later separately reviewed Gate changes it.

## 3. Why G4 is not one giant live Gate

The target ordering changes product/runtime intent, but the three roles are not equally persistent today. Combining persistent REALITY deployment, permanent Clash profile creation, application traffic takeover, peak-hour benchmarking, real workloads, and final default-role change in one execution would cross several rollback and authority boundaries.

G4 is therefore split by material boundary:

### G4-A — role contract and validation package

Repository/document-only. No network, Secret, VPS, Clash, route, proxy, TUN, or workload mutation.

Result: this document plus canonical Handoff/Decision state.

### G4-B — persistent three-role readiness

Separate consequential Gate requiring fresh Owner authorization before execution.

Maximum intended outcome:

- keep WireGuard available as rollback;
- create a persistent, recoverable REALITY server/client identity on the already validated Mihomo v1.19.31 semantics;
- expose only the reviewed TCP/443 REALITY service;
- create one persistent Owner-local Clash profile containing exactly:
  - HY2-SFO3
  - WG-BASELINE
  - REALITY-SFO3
- manual selector order/default:
  - HY2-SFO3 first
  - WG-BASELINE second
  - REALITY-SFO3 third
- keep automatic switching disabled;
- keep system proxy and TUN OFF at the end of the Gate;
- prove restart persistence, Secret storage/recovery metadata, server/client identity, negative exposure boundaries, route requirements, and exact rollback.

G4-B does **not** make HY2 the system-wide active production path yet. It only makes the three-role package durably ready.

### G4-C — peak-hour + representative real-workload validation

Separate consequential Gate after G4-B PASS and fresh Owner authorization.

G4-C validates the desired role order rather than reopening protocol shopping.

## 4. Application traffic takeover strategy

R3R2 used an explicit SOCKS5 request, so it does not prove that Codex Desktop, ChatGPT/browser image generation, or other real applications automatically use the selected Clash node.

G4-C therefore follows the smallest-mutation rule:

1. Test **system proxy** as the first application takeover mechanism.
2. Prove each representative application actually traverses the selected Clash role using bounded, sanitized path evidence.
3. Keep TUN OFF if system proxy covers the required workloads.
4. If any required application ignores system proxy, STOP and design a separate TUN compatibility Gate. Do not silently enable TUN inside G4-C.

This makes TUN a fallback design decision, not an assumed production requirement.

## 5. Peak-hour network validation

Use one representative local peak-hour window. Preserve the historical distinction between same-window network comparison and real-workload validation.

### HY2 primary acceptance

HY2 may be sealed as PRIMARY only if all are true:

- real authentication/connectivity PASS;
- no unexplained failure streak;
- representative peak-hour sample succeeds;
- tail behavior remains acceptable relative to WireGuard in the same window;
- representative Codex/OpenAI/image-generation workloads complete without network-caused stall/regression;
- manual return to WG remains proven.

The historical 60/60 result is supporting evidence, not a substitute for G4.

### WireGuard backup-1 acceptance

WG does not need to beat HY2. It must prove:

- healthy current tunnel and control route;
- representative peak-hour connectivity;
- successful manual fallback from HY2;
- representative workload continuity after fallback;
- no dependency on Clash Secret material to remain usable.

### REALITY backup-2 acceptance

REALITY does not need to beat HY2 or WG on latency. It must prove:

- persistent TCP/443 service/readiness from G4-B;
- valid manual selection;
- representative peak-hour connectivity on networks where the tested TCP/443 path is available;
- at least one bounded representative workload smoke;
- exact return to HY2 or WG;
- no unexpected public listener/exposure outside the reviewed service boundary.

## 6. Suggested quantitative network layer

For comparability with the historical accepted methodology, G4-C should reuse the same endpoint semantics and metric family:

- success/failure count;
- median;
- P90;
- P95;
- P99;
- counts above 1s / 1.5s / 2s;
- native exit status;
- explicit path-use proof;
- public-exit correlation when applicable.

Do not interpret one metric in isolation. A functional backup role may PASS without winning latency.

The final sample count is frozen by the G4-C Gate before execution. The previous 60/60 comparison should be reused as design precedent rather than automatically replayed.

## 7. Representative workload layer

The workload set must be small, repeatable, and tied to actual user goals:

- **Codex:** one bounded representative task long enough to expose connection stability, with start/end and success/failure captured.
- **OpenAI:** one bounded API/web interaction with objective completion evidence.
- **Image generation:** one bounded representative generation flow through the user's normal application path.

The exact prompts/tasks are frozen before the live Gate. Outputs themselves are not performance benchmarks; the network question is whether the task completes, stalls, retries abnormally, or loses connectivity.

For backup roles, use smoke-level workload proof rather than repeating the full primary workload matrix unless the primary fails.

## 8. Failure and retry rules

- Any ambiguous real network action is reconciled before retry.
- No blind repeat after a failed consequential switch or public-service mutation.
- HY2 failure does not automatically promote WG or REALITY to permanent primary; Reviewer classifies the evidence first.
- REALITY failure does not invalidate WG/HY2 accepted evidence.
- A system-proxy coverage failure returns to Reviewer; it does not authorize TUN.
- Persistent default-role changes happen only after G4 acceptance.

## 9. Rollback model

During all G4 live work:

- WireGuard remains the emergency rollback until the exact Gate says otherwise.
- G4-B persistent REALITY deployment must have a defined stop/remove path before creation.
- Clash profile changes are exact and project-owned.
- System proxy changes, if used in G4-C, are bounded and restored/read back.
- TUN remains OFF unless a later explicit Gate owns it.
- Secret values never enter chat, GitHub, ordinary logs, or Evidence.

## 10. G4 completion meaning

G4 PASS means the Owner-selected v1 role order is technically validated:

```text
PRIMARY=HY2-SFO3
BACKUP_1=WG-BASELINE
BACKUP_2=REALITY-SFO3
```

Only after G4 PASS may MVP v1 sealing persist the final production default/control posture.

G4 PASS does not itself close the deferred fresh-target migration rehearsal; that remains separately tracked unless the Owner later changes its scope.
