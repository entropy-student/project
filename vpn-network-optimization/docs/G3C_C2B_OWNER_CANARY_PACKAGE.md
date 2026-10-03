# G3C C2B synthetic Clash UI canary package

Status: offline package only. This package is not authorized to run until a
later Reviewer checkpoint. It validates UI visibility only; it does not prove
HY2 connectivity.

## Synthetic profile contract

The profile has exactly two nodes. `WG-BASELINE` is a named `direct` proxy and
is first in the manual `SELF-VPN-CANARY` `select` group, so the declared initial
choice is the current Windows route (with production WireGuard left running).
`HY2-SFO3` uses the reserved documentation address `203.0.113.77`, an
`.invalid` SNI, a conspicuously synthetic auth fixture, and a zero-valued
fixture fingerprint. These values are not credentials and cannot identify the
production HY2 endpoint. No physical interface name, ifIndex, gateway, or local
address is embedded.

REALITY is absent from the profile and remains
`COLD / DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE`. No persistent REALITY
server is part of C2B.

## Future Owner UI checkpoint boundary

The one-shot `scripts/c2b-owner-clash-ui-canary.ps1` is not executed in this R1.
If a later Gate authorizes its use, it creates one owner-only, CreateNew runtime
copy from the synthetic template and performs only Mihomo's local config parse.
It does not unprotect DPAPI, read recovery material, obtain real HY2 auth or a
production certificate fingerprint, start a Mihomo client, or send traffic.

The Owner checkpoint keeps the existing production profile active, WireGuard
connected, system proxy off, and TUN off. The Owner imports the synthetic
profile only for visual inspection, confirms the WG/HY2 entries and manual
selector with `WG-BASELINE` current/default, does not select HY2 or send traffic,
removes the imported profile in the Clash Verge UI, and provides the exact
bounded structured acknowledgement requested by the runner.

Before import, the runner discovers exactly one Clash Verge `profiles/` store
under the current user's roaming application-data directory and holds a
read-only in-memory snapshot of relative file names and file hashes. After UI
removal, it compares the snapshot. It never prints profile names, hashes, or
contents and never deletes files from the Clash-owned profile store. Ambiguous
store discovery, read failure, mismatch, or residue is fail-closed; cleanup is
manual/reviewer-directed rather than automatic deletion of unrelated files.

## Safety, cleanup, and interpretation

The runner checks that production WireGuard remains connected and that system
proxy/TUN remain off; it compares route and client-state snapshots before and
after. It owns only its unique project runtime directory, marker, and generated
synthetic YAML, created with `CreateNew` and owner-only ACL. Its `finally`
cleanup removes only those exact objects. It does not change routes, proxy,
TUN, WireGuard, VPS state, or any system setting.

C2B can establish only that the synthetic profile is parseable and that the
manual controls are visible in the UI. It cannot establish a HY2 handshake,
authentication, endpoint reachability, or performance. Real HY2 use within
Clash is deferred to a separate C2C Gate with an explicitly approved secret and
profile-storage lifecycle.
