# G4-B Persistent Three-Role Readiness Gate

Status: OFFLINE_PACKAGE_REVIEWED / OWNER_PREREQUISITES_REQUIRED

## GATE_ID

`G4B_PERSISTENT_THREE_ROLE_READINESS`

## PREREQUISITE_GATE

`G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` is formally PASS.

Accepted G4-B0 evidence proves HY2 outer traffic can use Mihomo `interface-name` over the physical interface while WireGuard remains connected and exact VPS `/32` routes stay absent. No persistent VPS `/32` route is authorized by this Gate. REALITY client-path behavior remains to be validated in its own later execution path; G4-B0 does not overclaim that transport.

## OBJECTIVE

Make the already-selected v1 three-role layout durably ready without yet changing the system-wide production traffic takeover mode:

1. HY2-SFO3 = PRIMARY target
2. WG-BASELINE = BACKUP_1
3. REALITY-SFO3 = BACKUP_2

The Gate establishes persistent service/profile readiness and rollback only. It does not run the final peak-hour/real-workload validation and does not seal the production default.

## MAX_ENDPOINT_THIS_ROUND

```text
fresh main/read-back
-> exact current source/runtime preflight
-> prove WireGuard + HY2 current health
-> prove TCP/443 ownership/exposure baseline
-> create persistent REALITY identity/config/service using accepted Mihomo v1.19.31 semantics
-> verify public TCP/443 REALITY readiness
-> create one persistent Owner-local Clash three-role profile
-> manual selector order HY2 / WG / REALITY
-> config parse + visibility/read-back
-> restart-persistence proof
-> Secret/recovery metadata proof without values
-> final system proxy OFF
-> final TUN OFF
-> final WireGuard still available
-> STOP_AT_REVIEWER
```

No G4-C real-workload run is part of this Gate.

## TARGET_AND_SCOPE

### VPS target

Current accepted SFO3 VPN VPS only.

Owned persistent additions must be project-specific and reviewable. Exact filesystem/service names are frozen in the implementation package before execution. Do not reuse temporary G2-C canary paths as persistent locations.

The persistent REALITY service must use the already accepted semantics:

- server core: Mihomo v1.19.31;
- protocol: VLESS + REALITY + XTLS Vision;
- public transport: TCP/443;
- no change to WireGuard or HY2 service identity;
- no unrelated firewall/SSH/shared-host mutation.

### Owner Windows target

Current Owner Windows host only.

One persistent Clash profile may be created containing exactly:

```text
SELF-VPN-V1
├─ HY2-SFO3       # first / target primary
├─ WG-BASELINE    # second / fallback 1
└─ REALITY-SFO3   # third / fallback 2
```

`WG-BASELINE` remains `direct`, meaning it follows the existing Windows/WireGuard routing baseline.

The Gate does not enable persistent automatic selection.

## APPLICABLE_CRITICAL_CONSTRAINTS

- WireGuard remains available as rollback throughout.
- Existing HY2 service must remain healthy.
- No automatic switching.
- System proxy remains OFF at final read-back.
- TUN remains OFF at final read-back.
- No G4-C peak-hour or real-workload traffic.
- Secret values/hashes/raw credential material never enter GitHub/chat/ordinary logs/Evidence.
- Existing temporary REALITY canary credentials are not reused as if they were persistent recovery material.
- Persistent REALITY credentials require a reviewed lifecycle and recovery design before deployment.
- Any failed/ambiguous consequential mutation is reconciled before retry.
- No broad firewall, route, service, or filesystem cleanup.

## PREFLIGHT

Before any write:

- canonical Git root/main/source provenance proven;
- project-owned worktree scope clean;
- real Owner Windows host/runtime identity proven;
- accepted strict SSH target identity/trust proven;
- WireGuard manager/tunnel/adapter healthy;
- HY2 service/listener healthy;
- current system proxy/TUN state read back;
- current public TCP/443 listener ownership read back;
- current persistent route/firewall state read back;
- accepted Mihomo v1.19.31 artifact identity/hash available;
- persistent REALITY filesystem/service paths frozen;
- persistent REALITY Secret format, target readers, permissions, recovery destination, and rotation/rollback rules frozen;
- Clash profile store uniquely resolved;
- baseline Clash profile-store snapshot captured;
- no conflicting `SELF-VPN-V1` profile exists unless an explicit replace/upgrade path is separately accepted.

## REQUIRED_EVIDENCE

### VPS

- host identity and OS;
- WireGuard health before/after;
- HY2 health before/after;
- TCP/443 listener before/after;
- persistent REALITY service identity and active state;
- exact running binary/version;
- config parse PASS;
- restart/reboot-equivalent service persistence proof where safe;
- public TCP/443 reachability;
- negative boundary check for unintended extra listeners/exposure;
- resource delta sufficient to show no obvious VPS pressure regression;
- no unrelated firewall/route/service drift.

### Secret/recovery

- credential generation/installation occurred inside protected boundary;
- target Secret locations metadata only;
- intended server/client readers and permissions proven;
- unrelated access denied/not-mounted where applicable;
- recovery artifact exists in an approved different failure domain;
- recovery/parser compatibility proven without plaintext/value hash output;
- Secret values emitted 0.

### Owner Windows / Clash

- exact persistent three-role profile identity;
- Mihomo config parse PASS;
- nodes/groups visible with order HY2 -> WG -> REALITY;
- initial/default selector = HY2-SFO3;
- automatic selector absent;
- system proxy OFF;
- TUN OFF;
- WireGuard still connected;
- Clash profile-store post-write/read-back;
- Clash/relevant runtime restart persistence proof;
- no unrelated profile mutation.

## ACCEPTANCE_CRITERIA

PASS requires all of:

```text
PERSISTENT_REALITY_SERVICE_READY=YES
PUBLIC_TCP443_REALITY_READY=YES
WIREGUARD_PRESERVED=YES
HY2_PRESERVED=YES
THREE_ROLE_CLASH_PROFILE_READY=YES
ROLE_ORDER=HY2_PRIMARY/WG_BACKUP1/REALITY_BACKUP2
AUTO_SWITCHING=OFF
SYSTEM_PROXY_FINAL=OFF
TUN_FINAL=OFF
SECRET_RECOVERY=VERIFIED
RESTART_PERSISTENCE=PASS
UNRELATED_DRIFT=NONE
```

G4-B PASS means all three roles are durably available for later validation. It does not prove real applications use the selected Clash node and does not seal HY2 as the production default.

## ROLLBACK_STATUS_OR_PLAN

Before mutation, freeze:

- exact service removal/disable path for the new persistent REALITY service;
- exact persistent config/credential rollback boundary;
- exact Clash profile removal/restore path;
- WireGuard baseline as immediate connectivity fallback;
- post-rollback TCP/443, profile-store, route, proxy, TUN, WG, and HY2 read-back.

Rollback must not delete the existing HY2/WireGuard recovery material.

## OWNER_ONLY_ACTIONS

After G4-B0 PASS, fresh Owner authorization is required before:

- persistent public REALITY service enablement;
- persistent REALITY Secret generation/installation;
- persistent Owner Clash profile installation if it contains live credentials;
- any later production/system-wide traffic takeover.

The current Owner statement establishes the desired role order but does **not** by itself authorize these consequential writes.

## REVIEWER_TO_EXECUTOR_RELAY

Executor startup surface when authorized:

- this Gate;
- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md`;
- current `REVIEWER_HANDOFF.md`;
- accepted G2-C public REALITY canary source/identity needed to preserve protocol semantics;
- accepted R3R2 HY2/Clash source/identity needed to preserve Secret/profile boundaries;
- only the exact target source/templates/scripts needed for G4-B implementation.

Do not replay historical protocol diagnostics.

## EXECUTOR_TO_REVIEWER_RELAY

Use the standard short completion packet and write detailed proof to `EXECUTION_EVIDENCE.md`.

Mandatory stop after G4-B. Do not enter G4-C without Reviewer acceptance and a separately reviewed authorization boundary.
