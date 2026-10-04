# G4-B Offline Live-Runner Implementation Gate

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_OFFLINE_LIVE_RUNNER_IMPLEMENTATION_R1`

## PREVIOUS_RESULT

`PASS_G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS`

## OBJECTIVE

Implement and offline-validate the bounded live runner package required for the later
`G4B_PERSISTENT_THREE_ROLE_READINESS` Gate.

This round is engineering-only. It must not touch the Owner network, the SFO3 VPS,
live Clash state, live Secret material, or any external endpoint.

## FROZEN PRODUCT CONTRACT

The runner must preserve the already accepted target:

```text
PRIMARY=HY2-SFO3
BACKUP_1=WG-BASELINE
BACKUP_2=REALITY-SFO3
CONTROL=MANUAL_SELECT
AUTO_SWITCHING=OFF
FINAL_SYSTEM_PROXY=OFF
FINAL_TUN=OFF
WIREGUARD_ROLLBACK_AVAILABLE=YES
```

Accepted G4-B0 fact:

```text
HY2_WINDOWS_INTERFACE_NAME_BYPASS=PASS
PERSISTENT_VPS_32_ROUTE_REQUIRED_FOR_HY2=NO
REALITY_CLIENT_PATH_PROOF=NOT_CLAIMED_BY_G4B0
```

Do not silently generalize the HY2 result into a REALITY live-path PASS.

## ALLOWED EXECUTOR FILES

Executor may create or modify only:

- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-three-role-package-validator.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md` only when needed to keep the
  offline source contract synchronized
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

The following are frozen in this round and must not be changed without RETURN:

- `REVIEWER_HANDOFF.md`
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md`
- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md`
- `templates/clash/self-vpn-v1-three-role.yaml.template`
- `templates/reality/mihomo-reality-server.yaml.template`
- `templates/systemd/mihomo-reality-vpn-network-optimization.service.template`
- accepted G4-B0 source/evidence

If a frozen file is found defective, STOP and RETURN with the exact defect. Do not repair it in this round.

## LIVE RUNNER SOURCE CONTRACT

The new runner source must implement explicit non-secret phases:

```text
P0_CANONICAL_SOURCE
P1_OWNER_HOST_AND_NETWORK_PREFLIGHT
P2_STRICT_TARGET_IDENTITY
P3_WG_HY2_TCP443_BASELINE
P4_REALITY_RUNTIME_IDENTITY_AND_PATH_PREFLIGHT
P5_SECRET_AND_RECOVERY_PREPARE
P6_SERVER_CONFIG_PARSE
P7_SERVICE_ENABLE_AND_LISTENER_READBACK
P8_PUBLIC_REALITY_READINESS
P9_OWNER_THREE_ROLE_PROFILE_PREPARE
P10_OWNER_UI_IMPORT_AND_VISIBILITY
P11_RESTART_PERSISTENCE
P12_FINAL_BASELINE_READBACK
STOP_AT_REVIEWER
```

The source must fail closed on ambiguity and preserve the exact mutation budget from the
accepted G4-B Gate.

Required source-level properties:

- canonical source and clean-project guard before any consequential action;
- explicit Owner authorization guard for later live execution;
- explicit second-failure-domain recovery-destination prerequisite;
- strict SFO3 target identity/trust guard before remote mutation;
- project-owned persistent path collision checks that fail closed;
- dedicated non-root REALITY runtime identity contract;
- `CAP_NET_BIND_SERVICE` only for low-port bind;
- no broad firewall rewrite;
- no persistent route creation;
- no WireGuard/HY2 replacement;
- protected Secret lifecycle with values/hashes never printed;
- rollback ownership limited to objects created by this Gate;
- system proxy and TUN final-state assertions;
- exact three-role order and manual selector assertions;
- restart-persistence checks;
- mandatory Reviewer stop;
- no automatic transition into G4-C.

The runner may contain future SSH/VPS/Secret operations as implementation source,
but **must not execute them in this round**.

## OFFLINE FIXTURE VALIDATION

The fixture validator must prove, without real Secret/network access:

1. PowerShell AST parse of runner and validators.
2. Existing three-role package validator PASS.
3. Required P0-P12 phase markers exist exactly once and in order.
4. Consequential operations cannot precede authorization + prerequisites.
5. Missing second-failure-domain destination fails closed.
6. Unknown pre-existing REALITY target paths/service/profile fail closed.
7. Wrong target identity fails closed.
8. Route creation commands are absent from the live runner.
9. Broad firewall rewrite commands are absent.
10. WireGuard/HY2 destructive replacement commands are absent.
11. Secret material is not emitted/logged and committed fixtures contain placeholders only.
12. Rollback code is project-object scoped.
13. System proxy/TUN final guards exist.
14. Three-role order remains HY2 / WG / REALITY and auto selection is absent.
15. Restart persistence is explicitly checked.
16. G4-C workload/benchmark execution paths are absent.
17. Fixture mode cannot invoke SSH, DPAPI/unprotect, external HTTP, Mihomo live start,
    service mutation, profile mutation, or network mutation.

Negative fixtures are required for at least:

- no Owner authorization;
- no second recovery destination;
- wrong target identity;
- pre-existing unknown persistent target;
- Secret-output attempt;
- route-write attempt;
- auto-selector drift;
- role-order drift;
- missing rollback guard;
- missing final proxy/TUN guard.

## ABSOLUTE PROHIBITIONS THIS ROUND

```text
SSH_OR_VPS_ACTION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
NETWORK_MUTATION=NO
CLASH_PROFILE_MUTATION=NO
SYSTEM_PROXY_CHANGE=NO
TUN_CHANGE=NO
SERVICE_MUTATION=NO
ROUTE_MUTATION=NO
REALITY_LIVE_DEPLOYMENT=NO
G4C_EXECUTION=NO
```

Do not run any historical live canary.

## ACCEPTANCE CRITERIA

Executor may return PASS_CANDIDATE only if:

```text
G4B_LIVE_RUNNER_SOURCE=IMPLEMENTED
POWERSHELL_AST_PARSE=PASS
G4B_EXISTING_PACKAGE_VALIDATOR=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
NETWORK_MUTATION=NO
SSH_OR_VPS_ACTION=NO
REVIEWER_HANDOFF_MODIFIED=NO
STOP_AT_REVIEWER=YES
```

Any uncertainty is RETURN, not partial PASS.

## EXECUTOR REPORT

Return a short completion packet containing:

- PASS_CANDIDATE or RETURN;
- exact changed files;
- resulting blob/commit identities;
- fixture/AST/package-validator result;
- confirmation of zero live actions;
- timing;
- any remaining blocker;
- `STOP_AT_REVIEWER=YES`.

Detailed sanitized evidence goes to `EXECUTION_EVIDENCE.md`.
