# Reviewer Reconciliation — Independent WLAN Reachability to Fresh VPS Fails

Status: RETURN_DIRECT_UNDERLAY_UNREACHABLE

Date: 2026-10-07

## Owner direct-underlay evidence

With the legacy standalone WireGuard manually disconnected, system proxy OFF and TUN OFF, Owner ran a direct reachability diagnostic to the fresh VPS.

Observed:

```text
ROUTE_INTERFACE=WLAN
ROUTE_INTERFACE_INDEX=18
ROUTE_NEXT_HOP=192.168.1.1
ROUTE_METRIC=0

TCP_443_INTERFACE=WLAN
TCP_443_SOURCE=192.168.1.4
TCP_443_SUCCESS=False

TCP_2096_INTERFACE=WLAN
TCP_2096_SOURCE=192.168.1.4
TCP_2096_SUCCESS=False

PING_143.198.159.233=TimedOut
```

## Interpretation

The fresh target `143.198.159.233` is not independently reachable from the Owner's current WLAN path.

This explains why, with the legacy WireGuard connected:

- SELF-WG-SFO3 can carry HTTPS and exit through `143.198.159.233`;
- SELF-REALITY-SFO3 can carry HTTPS and exit through `143.198.159.233`;

but, when the legacy WireGuard is disconnected, all new nodes time out.

Those successful node tests prove nested functional transport only; they do not prove independent cutover readiness.

## Current state

```text
P3_RESULT=RETURN_DIRECT_UNDERLAY_UNREACHABLE
DIRECT_WLAN_TO_FRESH_VPS=FAIL
NEW_WG_NESTED_FUNCTIONAL=PASS
NEW_REALITY_NESTED_FUNCTIONAL=PASS
NEW_HY2_STATUS=UNRESOLVED_TIMEOUT
FINAL_CUTOVER_READY=NO
P4_RELEASED=NO
SERVER_MUTATION_ALLOWED=NO
```

## Next fault domain

Do not continue HY2-specific debugging.

Next diagnosis is the direct reachability boundary:

1. prove general WLAN Internet remains healthy without legacy WireGuard;
2. inspect fresh-VPS host firewall / nftables / ufw read-only;
3. inspect DigitalOcean Cloud Firewall / source restrictions if present;
4. distinguish source-sensitive firewall from upstream ISP/routing reachability.

No protocol mutation is authorized until the direct-underlay reachability issue is explained.
