# Reviewer Reconciliation — P3 Reveals Old-WireGuard Underlay Dependency

Status: RETURN_UNDERLAY_DEPENDENCY

Date: 2026-10-07

## Trigger

Owner-guided P3 smoke produced the following controlled observations:

- with the standalone legacy WireGuard path connected:
  - new 3x-ui `SELF-WG-SFO3` carried HTTPS successfully and exited as `143.198.159.233`;
  - new 3x-ui `SELF-REALITY-SFO3` carried HTTPS successfully and exited as `143.198.159.233`;
  - new 3x-ui `SELF-HY2-SFO3` timed out;
- new-profile `DIRECT` carried HTTPS successfully through the legacy WireGuard path and exited as `24.199.118.137`;
- after Owner manually disconnected the legacy WireGuard path, Clash delay checks for all three new nodes timed out.

The Reviewer-supplied automatic legacy-WG stop/restore script used an unverified service name and therefore failed with a service-not-found error. That script is revoked; no inference depends on its service-control portion.

## Interpretation

The strongest current hypothesis is that the fresh target `143.198.159.233` is reachable from this Windows environment only through the legacy WireGuard underlay, or that the direct WLAN path is otherwise unusable for the new-node bootstrap.

This means the successful WG/REALITY tests with legacy WG connected prove nested functional transport, not independent cutover readiness.

HY2 remains unresolved and must not be debugged further until independent underlay reachability is characterized.

## Current classification

```text
P3_RESULT=RETURN_UNDERLAY_DEPENDENCY
NEW_WG_NESTED_FUNCTIONAL=PASS
NEW_REALITY_NESTED_FUNCTIONAL=PASS
NEW_HY2_NESTED_FUNCTIONAL=FAIL_TIMEOUT
INDEPENDENT_NEW_VPS_REACHABILITY=UNKNOWN
FINAL_CUTOVER_READY=NO
P4_RELEASED=NO
SERVER_MUTATION_ALLOWED=NO
```

## Next diagnostic

Owner manually toggles the legacy WireGuard only.

With legacy WireGuard OFF, run a bounded read-only direct-WLAN reachability diagnostic against the fresh target:

- route selected for `143.198.159.233`;
- TCP/443;
- TCP/2096;
- optional ICMP/traceroute evidence;
- no Clash system proxy;
- no TUN;
- no server mutation.

After capture, Owner manually restores legacy WireGuard before returning results.

Do not continue protocol-specific HY2 repair until this underlay question is resolved.
