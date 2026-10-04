# G4-B0 Windows Mihomo interface-name bypass canary

Status: PROPOSED / OWNER_AUTHORIZATION_REQUIRED

## GATE_ID

`G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1`

## OBJECTIVE

Determine whether the accepted Windows Mihomo engine can send HY2 outer traffic directly through the dynamically discovered physical interface using only `interface-name`, while production WireGuard remains connected and **without** creating an exact VPS `/32` route.

This Gate answers one architecture question only:

```text
CAN_INTERFACE_NAME_REPLACE_EXPLICIT_VPS_32_BYPASS_ROUTE_ON_THIS_OWNER_HOST?
```

It does not deploy persistent REALITY, install a persistent Clash profile, change the production default, benchmark performance, or enter G4-C.

## WHY_THIS_GATE_EXISTS

Accepted evidence currently proves:

- G3-A says HY2/REALITY fallback roles require a physical-egress `<VPS_PUBLIC_IP>/32` route intent.
- G3-C C1 carries `interface-name` only as an unproven Windows bypass design input.
- R3R2 real HY2-in-Clash PASS used a temporary ActiveStore-only `/32` route.
- Therefore persistent three-role readiness cannot safely assume that `interface-name` alone is sufficient.

## MAX_ENDPOINT_THIS_ROUND

```text
fresh source/read-back
-> Owner Windows identity/runtime preflight
-> WireGuard + Clash baseline healthy
-> system proxy OFF + TUN OFF
-> dynamically discover one physical egress/interface
-> prove active and persistent exact VPS /32 route count = 0
-> create one protected temporary HY2 Mihomo config containing interface-name only
-> local config parse
-> start one temporary localhost Mihomo proxy
-> exactly two bounded requests through that proxy
-> confirm proxy use + expected SFO3 public exit
-> stop temporary Mihomo
-> protected Secret/runtime cleanup
-> prove exact VPS /32 route still absent
-> prove WireGuard/proxy/TUN/network baseline unchanged
-> STOP_AT_REVIEWER
```

## TARGET_AND_SCOPE

Owner Windows host only.

No SSH or VPS mutation is needed. Existing HY2 server is treated as an already accepted target.

The canary uses the installed Clash Verge Mihomo engine but does not need to import or persist a new Clash profile.

## APPLICABLE_CRITICAL_CONSTRAINTS

- WireGuard remains connected and available throughout.
- Do not create an ActiveStore or PersistentStore exact VPS `/32` route.
- System proxy remains OFF.
- TUN remains OFF.
- No REALITY activation.
- No persistent Clash profile.
- No benchmark loop.
- Exactly two external requests maximum.
- No Secret value/hash/raw helper output.
- Failure or ambiguity after Secret/runtime preparation requires reconciliation before any retry.

## PREFLIGHT

- PowerShell/runtime identity appropriate for the accepted Owner-local tooling.
- Canonical source identity proven.
- WireGuard manager/tunnel/adapter healthy.
- Clash Verge service healthy.
- system proxy OFF.
- TUN count 0.
- one unambiguous physical egress with interface name/index/gateway/source IPv4.
- exact current VPS public IPv4 known from accepted project state.
- exact ActiveStore VPS `/32` count = 0.
- exact PersistentStore VPS `/32` count = 0.
- local canary proxy port free.
- existing protected HY2 recovery material available to the accepted Owner-local reader without value output.

## REQUIRED_EVIDENCE

```text
PHYSICAL_EGRESS_DISCOVERY=PASS
INTERFACE_NAME_APPLIED=YES
ACTIVE_VPS_32_ROUTE_BEFORE=0
PERSISTENT_VPS_32_ROUTE_BEFORE=0
TEMP_OR_PERSISTENT_VPS_32_ROUTE_CREATED=NO
MIHOMO_CONFIG_PARSE=PASS
MIHOMO_LOCAL_PROXY_READY=YES
REQUEST_COUNT=2
OPENAI_CURL_EXIT=0
OPENAI_HTTP_STATUS=401
OPENAI_PROXY_USED=1
PUBLIC_EXIT=EXPECTED_SFO3
ACTIVE_VPS_32_ROUTE_AFTER=0
PERSISTENT_VPS_32_ROUTE_AFTER=0
WIREGUARD_PRESERVED=YES
SYSTEM_PROXY_FINAL=OFF
TUN_FINAL=OFF
SECRET_RUNTIME_CLEANUP=PASS
```

## ACCEPTANCE_CRITERIA

### PASS_INTERFACE_NAME_BYPASS

All required evidence passes and the two proxied requests succeed while the exact VPS `/32` route remains absent before, during, and after the canary.

Consequence: G4-B may use `interface-name` as the persistent outer-bypass mechanism and must not add a persistent VPS `/32` route merely for HY2/REALITY.

### RETURN_INTERFACE_NAME_INSUFFICIENT

Mihomo/proxy starts correctly but the requests cannot establish the accepted HY2 path without an exact VPS `/32` route.

Consequence: do not retry blindly. Reviewer redesigns G4-B around a controlled exact-route lifecycle rather than claiming the persistent profile is ready.

### RETURN_OTHER

Any target/source/Secret/runtime ambiguity or unrelated failure. No routing conclusion is inferred.

## ROLLBACK_STATUS_OR_PLAN

The Gate is designed with no route mutation and no persistent profile mutation.

Cleanup owns only its unique temporary Mihomo runtime/config/process. Final read-back must restore the exact pre-canary local network state.

## OWNER_ONLY_ACTIONS

Fresh explicit Owner authorization is required for this canary because it uses the real HY2 credential and sends exactly two real external requests.

Authorization for G4-B0 does not authorize persistent REALITY deployment, G4-B live writes, system proxy/TUN activation, or G4-C.

## REVIEWER_TO_EXECUTOR_RELAY

- this Gate;
- current `REVIEWER_HANDOFF.md`;
- accepted R3R2 HY2 Secret/runtime safety pattern;
- accepted G3-A physical-egress discovery semantics;
- only the source needed to build the local canary.

Do not replay historical network diagnostics.

## EXECUTOR_TO_REVIEWER_RELAY

Standard short completion packet; detailed sanitized proof to `EXECUTION_EVIDENCE.md`.

Mandatory Reviewer stop after the canary.
