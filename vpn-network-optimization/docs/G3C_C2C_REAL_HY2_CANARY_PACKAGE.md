# G3C C2C real HY2-in-Clash canary package

Status: Owner-authorized real-connectivity canary package. Execution remains bounded by the current Reviewer Gate.

## Purpose

C2C proves that the already-validated real SFO3 Hysteria2 credential can be consumed by Clash Verge's normal profile lifecycle and can carry a minimal real HTTPS request while production WireGuard remains available as the rollback path.

C2C is not a performance benchmark, not a default-route change, and not authorization to make HY2 the persistent default.

## Real credential boundary

The source of truth is the already-accepted Owner-local CurrentUser DPAPI artifact:

`%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi`

The implementation is intentionally split into three reviewed components so no single component both handles the plaintext HY2 credential and constructs external network requests:

- `scripts/c2c-secret-profile-helper.ps1`: local-only Secret helper. It verifies Owner-only ACLs, decrypts the DPAPI CurrentUser artifact in process memory, validates the VPNHY2R1 frame/auth/certificate, renders one Owner-only temporary YAML, performs the exact auth-byte residue checks, and zeroes plaintext buffers. It contains no network-request code.
- `scripts/c2c-bounded-proxy-probe.ps1`: two-request network probe. It receives only a localhost proxy port and has no DPAPI/recovery/auth access.
- `scripts/c2c-owner-clash-real-canary.ps1`: orchestration layer. It handles read-back, the temporary /32 route, UI acknowledgements, helper/probe invocation, and final rollback verification; it does not decrypt or hold the HY2 credential.

A real auth value is injected only into one unique Owner-only runtime YAML. Importing that YAML into Clash Verge may cause Clash's own application storage/cache to temporarily contain the real auth value. This temporary persistence is inside the authorized C2C boundary. The Secret helper scans the Clash application root for the exact auth byte sequence before import and requires zero matches after the canary profile is removed. It does not print matching paths.

The Clash application scan remains fail-closed for unreadable files, with one narrowly bounded runtime-lock exception. Only after an actual read failure may the scanner bypass that item, and only when a fresh metadata read proves it is a direct root-level `.lock` file in the Clash application root, exactly zero-byte, a normal file, and not a reparse point. Readable zero-byte files are still scanned normally. Metadata lookup failure, descendant lock files, nonzero files, reparse points, other extensions, and every unreadable file under the project runtime remain strict failures; the project runtime scan has no exception.

## Network boundary

Production WireGuard remains connected throughout. System proxy and Clash TUN must remain OFF.

The orchestrator creates one temporary ActiveStore IPv4 /32 route for the HY2 server public IP through the dynamically resolved non-WireGuard physical default gateway. This is required so HY2 UDP/8443 does not recurse through the WireGuard full tunnel. The route is removed in cleanup and no persistent route is allowed.

Exactly two real requests are authorized in C2C. The orchestrator does not trust disabled Windows `ProxyServer` metadata; instead it discovers live Clash/Mihomo loopback listeners and requires exactly one listener to answer a SOCKS5 no-auth greeting. The bounded probe then uses that proven listener explicitly with `socks5h://127.0.0.1:<port>`.

The only intentional real canary traffic is:
1. one HTTPS request to `https://api.openai.com/v1/models` through the proven local SOCKS5 listener, expecting curl exit 0 and HTTP 401;
2. one request to `https://api.ipify.org` through the same SOCKS5 listener, expecting the accepted SFO3 public exit.

No benchmark loop is authorized.

## UI sequence

The generated profile contains:
- `WG-BASELINE` as a direct node;
- `HY2-SFO3-REAL` as the real Hysteria2 node;
- `SELF-VPN-C2C` as a manual select group with WG first/default.

Owner interaction is split into three explicit acknowledgements:
1. import and activate only the unique C2C profile while WG remains current/default;
2. select `HY2-SFO3-REAL` only after the runner has verified the import and installed the temporary /32 route;
3. after the two bounded real requests pass, select `WG-BASELINE` again and remove only the C2C profile.

Do not enable system proxy or TUN during C2C.

## Acceptance and cleanup

PASS requires:
- exact reviewed source identities;
- preflight WireGuard/Clash/recovery/profile-store state;
- zero pre-existing real-auth matches in Clash application storage;
- Owner-only runtime YAML and local Mihomo parse PASS;
- temporary /32 route exact readback;
- explicit UI acknowledgements;
- live local proxy discovery => exactly one Clash/Mihomo SOCKS5 no-auth listener;
- OpenAI request via `socks5h` => curl 0 / HTTP 401;
- public exit through the same `socks5h` proxy => accepted SFO3 exit;
- profile-store snapshot restored;
- zero auth-byte matches in Clash application storage after profile removal;
- temporary route absent;
- temporary real-auth YAML absent;
- production WireGuard restored/unchanged;
- system proxy OFF and TUN OFF;
- Secret values emitted 0.

Any ambiguity fails closed. The runner never deletes files from Clash's application storage itself.
