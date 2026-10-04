# G4-B Persistent Three-Role Implementation Package

Status: OFFLINE_READY / LIVE_NOT_AUTHORIZED

This package turns the accepted G4-B Gate into an implementation contract without touching the live VPS or Owner Windows host.

## 1. Target role contract

```text
PRIMARY=HY2-SFO3
BACKUP_1=WG-BASELINE
BACKUP_2=REALITY-SFO3
CONTROL=MANUAL_SELECT
AUTO_SWITCHING=OFF
```

G4-B prepares persistent availability only. It does not enable system-wide traffic takeover and does not run G4-C workloads.

## 2. Persistent REALITY server contract

### Fixed project-owned paths

```text
BINARY=/usr/local/lib/vpn-network-optimization/mihomo-reality
RUNTIME_DIR=/srv/apps/vpn-network-optimization/reality
SECRET_CONFIG=/srv/apps/vpn-network-optimization/secrets/reality-server.yaml
SYSTEMD_UNIT=/etc/systemd/system/mihomo-reality-vpn-network-optimization.service
PUBLIC_LISTENER=<current accepted VPS public IPv4>:443
```

These paths are project-owned. Existing WireGuard/HY2 paths remain out of scope.

### Runtime identity

The persistent service must not rely on implicit root execution.

```text
RUNTIME_USER=dedicated project service identity
RUNTIME_GROUP=same dedicated project service identity
LOW_PORT_CAPABILITY=CAP_NET_BIND_SERVICE only
NO_NEW_PRIVILEGES=YES
```

The service template carries `User=__REALITY_RUNTIME_USER__` and `Group=__REALITY_RUNTIME_USER__`, plus `AmbientCapabilities=CAP_NET_BIND_SERVICE` and `CapabilityBoundingSet=CAP_NET_BIND_SERVICE`.

The live Gate must create or verify the exact runtime identity before writing any Secret-bearing config.

### Secret-bearing server config

The runtime config is intentionally outside Git. It contains the accepted VLESS + REALITY + Vision server semantics plus live credential material.

Required protection:

- restrictive owner/group and mode;
- intended runtime reader must be positively proven;
- unrelated broad principals must not receive access;
- no value or value hash is printed;
- unknown/non-empty pre-existing target fails closed rather than being overwritten.

## 3. Windows persistent Clash profile contract

Template:

`templates/clash/self-vpn-v1-three-role.yaml.template`

Exact manual order:

```text
SELF-VPN-V1
├─ HY2-SFO3
├─ WG-BASELINE
└─ REALITY-SFO3
```

The first/default selector item is HY2-SFO3.

The profile contains live client credential material only after a protected render step. The populated profile is never committed to Git or pasted into chat/logs.

G4-B final state:

```text
PROFILE_PERSISTENT=YES
SELECTOR_DEFAULT=HY2-SFO3
SYSTEM_PROXY=OFF
TUN=OFF
WIREGUARD_AVAILABLE=YES
```

This means the profile is ready, not that all application traffic has already been moved to HY2.

## 4. Secret classes

Persistent REALITY introduces these protected classes:

- client/server VLESS identity;
- REALITY server private key;
- REALITY client public key;
- REALITY short identifier.

The private key is server-only. The client profile must never contain the server private key.

The live implementation must correlate server and client material without emitting values or value hashes.

## 5. Recovery model

### First recovery copy

A protected Owner-local encrypted recovery bundle may be created under the existing project recovery root, using the same Owner-bound protection model already validated for HY2.

This is **not sufficient as sole disaster recovery**.

### Second failure domain

Before live G4-B can PASS, the Owner must name one approved second-failure-domain destination for an encrypted recovery copy.

Acceptable classes include an Owner-controlled external/cloud storage location that is distinct from both:

- the SFO3 VPS; and
- the current Windows machine's local disk.

The exact destination path/account is Owner-controlled and is not stored in Git. Secret values are never relayed through chat.

Current offline package state:

```text
SECOND_FAILURE_DOMAIN_DESTINATION=UNRESOLVED_OWNER_INPUT
LIVE_G4B_PASS_BLOCKED_UNTIL_RESOLVED=YES
```

This is a design prerequisite, not a request to expose any credential.

## 6. Live execution phase contract

The future authorized live runner must expose non-secret phase markers sufficient to distinguish where a failure happened.

Required phase order:

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

Any native non-zero result, ambiguity, target mismatch, pre-existing unknown object, or permission mismatch fails closed.

## 7. Mutation budget

G4-B owns only:

- one project-specific persistent REALITY binary/config/runtime/service set;
- one persistent project-owned Clash profile;
- the minimum project-specific protected recovery artifacts required by the accepted recovery design.

It does not own:

- WireGuard service/config replacement;
- HY2 service/config replacement;
- unrelated firewall rewrite;
- unrelated persistent routes;
- system proxy enablement;
- TUN enablement;
- automatic switching;
- G4-C workload traffic;
- source-VPS decommission.

## 8. Rollback contract

Rollback is defined before mutation.

### Server rollback

- stop/disable only the project REALITY service;
- remove only the project REALITY unit/runtime/binary/config objects that the Gate created;
- preserve encrypted recovery material unless a later cleanup Gate explicitly removes it;
- verify TCP/443 returns to the exact pre-G4B state;
- verify WireGuard and HY2 remain healthy.

### Owner-side rollback

- return selection to WG-BASELINE if needed;
- remove only the project `SELF-VPN-V1` profile;
- verify the Clash profile store against the accepted before snapshot;
- verify system proxy OFF and TUN OFF;
- verify WireGuard remains available.

No broad filesystem or Clash cleanup is permitted.

## 9. Restart/persistence acceptance

G4-B cannot PASS merely because the service/profile works once.

Required persistence checks:

- service configuration points to the canonical persistent files;
- service survives a bounded service restart and returns to the expected TCP/443 listener;
- Owner-side three-role profile remains available after the reviewed Clash restart/reload boundary;
- selector order remains HY2 / WG / REALITY;
- no automatic selector appears;
- no unrelated profile/service mutation appears.

A full OS reboot is not automatically required; the Gate freezes the smallest sufficient restart boundary before execution.

## 10. Offline implementation assets

Current offline package:

- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md`
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md`
- `templates/clash/self-vpn-v1-three-role.yaml.template`
- `templates/reality/mihomo-reality-server.yaml.template`
- `templates/systemd/mihomo-reality-vpn-network-optimization.service.template`
- `scripts/g4b-three-role-package-validator.ps1`

No file above contains live credential values.

## 11. Windows outer-bypass prerequisite

The persistent Clash template currently carries `interface-name` for HY2 and REALITY, but accepted project evidence does not yet prove that this alone bypasses the live WireGuard route on Windows.

```text
OUTER_BYPASS_MECHANISM=UNPROVEN_LIVE
R3R2_USED_EXPLICIT_TEMP_VPS_32_ROUTE=YES
G3A_ROUTE_INTENT_FOR_HY2_REALITY=VPS_PUBLIC_IP_32_VIA_PHYSICAL_EGRESS
G4B0_REQUIRED=YES
```

Live persistent G4-B must not proceed until `G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1` is formally reviewed.

## 12. Remaining prerequisites before live authorization is executable

```text
OFFLINE_PACKAGE_STATIC_REVIEW=READY
WINDOWS_OUTER_BYPASS_PROOF=PENDING_G4B0
DEDICATED_RUNTIME_IDENTITY_CONTRACT=READY
ROLLBACK_CONTRACT=READY
LIVE_RUNNER=NOT_YET_IMPLEMENTED
SECOND_FAILURE_DOMAIN_DESTINATION=OWNER_INPUT_REQUIRED
LIVE_G4B_OWNER_AUTHORIZATION=REQUIRED
```

The next safe engineering step is local-only live-runner implementation and fixture validation. That work may proceed without touching the VPS or Owner network. Actual G4-B execution remains blocked until the Owner authorizes the Gate and supplies the recovery-destination class/location.
