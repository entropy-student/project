# G3C Unified Manual-Control Contract — C1

Status: repository-only template; not imported or applied to Clash Verge.

## Selection semantics

- `WG-BASELINE` is Mihomo `direct`: it follows normal Windows routing. The production WireGuard tunnel must remain connected; this entry does not stop, replace, or configure WireGuard.
- `SELF-VPN-MANUAL` is a manual `select` group. Its first item is `WG-BASELINE`, so a fresh profile starts from the production baseline. No stored-selection override is configured.
- `HY2-SFO3` preserves the portable HY2 authentication and certificate-fingerprint sentinels. Its physical `interface-name` is a runtime-discovery placeholder only; Windows bypass behavior is `UNPROVEN_LIVE`.
- `REALITY-SFO3` preserves the accepted VLESS + REALITY + Vision client shape. It is listed as a cold placeholder for future visibility, not approved for selection or use until a later Reviewer Gate.

REALITY_READINESS=COLD_CANDIDATE / NOT_READY_FOR_MANUAL_USE

## Deferred protected inputs

The client template carries only sentinels for HY2 auth/fingerprint and REALITY identity/public parameters. The server-side REALITY private key is not a client field and remains external:

```text
HY2_AUTH_SENTINEL=__EXTERNAL_SECRET_NOT_IN_REPOSITORY__
HY2_FINGERPRINT_SENTINEL=__TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__
REALITY_UUID_SENTINEL=__EXTERNAL_REALITY_UUID_NOT_IN_REPOSITORY__
REALITY_PUBLIC_KEY_SENTINEL=__TARGET_REALITY_PUBLIC_KEY_AFTER_LATER_GATE__
REALITY_SHORT_ID_SENTINEL=__TARGET_REALITY_SHORT_ID_AFTER_LATER_GATE__
REALITY_SERVER_PRIVATE_KEY_SENTINEL=__EXTERNAL_REALITY_PRIVATE_KEY_NOT_IN_REPOSITORY__
```

## Manual delay check and boundary

MANUAL_DELAY_TEST_URL=https://www.gstatic.com/generate_204
MANUAL_DELAY_TEST_MODE=OWNER_INITIATED_ONLY_NO_AUTOMATIC_SWITCH

The URL is a future Clash Verge per-node manual delay-test target; C1 does not send a request. The profile contains no automatic selector and no route operation. No persistent public-endpoint bypass is part of this contract. The per-node `interface-name` field is only a later bypass-canary design input and has not been validated on Windows.

The REALITY placeholder must not be used until a later Gate authorizes and validates its target-side readiness. C1 does not create a persistent REALITY server, change the active profile, system proxy, TUN, route, or current VPN.
