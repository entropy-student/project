# G3C C2B Owner-local Clash Verge canary package

Status: prepared offline in C2A; not run, imported, or applied.

## Profile contract

The temporary selector contains only `WG-BASELINE` (`direct`, first/default)
and `HY2-SFO3` (the existing SFO3 Hysteria2 endpoint). The physical
`interface-name` is discovered at runtime. The template contains auth and
fingerprint sentinels only. REALITY is excluded from the live profile and stays
`COLD / DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE`.

## Owner checkpoint boundary

The one-shot `scripts/c2b-owner-clash-ui-canary.ps1` is for a later Reviewer-
authorized C2B only. It is designed to read the existing CurrentUser DPAPI
recovery artifact locally, validate its `VPNHY2R1` allowlist in memory, render
one owner-only runtime profile under a unique marked directory, and run the
pinned Mihomo v1.19.32 config test before presenting the file to the Owner.
It does not encode profile auto-apply, system-proxy/TUN enablement, WG stop,
route mutation, VPS access, or external requests.

The later UI step is explicit and bounded: import the temporary profile in
Clash Verge, keep system WireGuard connected and system proxy/TUN off, perform
only the Reviewer-authorized UI check, remove the temporary profile in the UI,
then acknowledge cleanup so the runner can remove its exact runtime directory.
If the Owner does not acknowledge, the script still runs local `finally`
cleanup and returns a non-success result. Do not use this package before C2B
authorization.

## Cleanup and rollback

The runner owns only its uniquely named runtime child, marker, and generated
YAML. It uses fail-on-existing creation and deletes only those exact objects;
it does not recursively remove a shared runtime parent or any Clash profile
directory. The future UI checkpoint must remove the imported canary profile
before acknowledging completion. The script compares WG, proxy, TUN, and route
snapshots before/after and returns non-success on drift.

REALITY readiness remains cold. No persistent or temporary `/32` route is part
of this package. C2A performs no DPAPI unprotect, Secret read, Mihomo start,
profile apply, network request, or network mutation.
