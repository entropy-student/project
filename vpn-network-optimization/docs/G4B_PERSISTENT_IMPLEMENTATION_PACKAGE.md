# G4-B Persistent Three-Role Implementation Package

Status: OFFLINE_R5R1_REPAIR_REVIEWER_ACCEPTED / LIVE_AUTH_READINESS_PENDING

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

### Recovery artifacts and ordering

The Owner-local DPAPI CurrentUser artifact is the first, profile-bound recovery copy only. It is not portable and is **not sufficient as sole disaster recovery**.

The second copy is a machine-independent authenticated encrypted `VPNG4BP1` artifact in the Owner-approved second failure domain. Its binary envelope is versioned and strictly parsed; it uses an Owner-entered hidden passphrase, PBKDF2-HMAC-SHA256 with a random 16-byte salt and 600,000 iterations, and AES-256-GCM with a random 12-byte nonce and 16-byte tag. The passphrase and plaintext are handled in memory only; neither values nor hashes are recorded.

Both recovery copies use the accepted `VPNG4BP1` AES-256-GCM envelope. The local DPAPI artifact is staged locally; the portable ciphertext is uploaded to Baidu Netdisk as a run-scoped `pending` object. Before any persistent VPS mutation, the runner downloads that pending ciphertext into a protected local runtime directory, compares bytes in process, and validates the decrypted payload. The portable object is promoted to its fixed final name only after service, profile, restart, and final read-backs succeed. On failure, only a byte-verified project-owned pending object may be removed, and only after bounded remote rollback is verified; otherwise the encrypted local staging artifact is retained for reconciliation. A final recovery object is never deleted by rollback.

The PASS_CANDIDATE path retains a non-secret Owner-local journal and the remote run-ownership state. Only exact-run rollback may remove owned objects. Journal closeout is available only after formal Reviewer PASS.

### Baidu Netdisk second failure domain

The Owner selected `BAIDU_NETDISK`; the runner uses the fixed project directory `/vpn-network-optimization-g4b-recovery` and fixed final basename `vpn-network-optimization-g4b.vpr1`. A run-specific pending basename is derived from the non-secret run ID. The project directory may be created if needed and is retained; rollback only targets the exact pending object, never the directory or final object.

The reviewed portable CLI is the community-maintained `qjfoidnh/BaiduPCS-Go`, pinned to release `v4.0.2` for Windows x64. The runner downloads the exact release ZIP into its protected local run directory, verifies the release archive size and SHA-256 (`ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30`), then opens that verified local archive path (the explicit local archive override is subject to the same digest check). Extraction is limited to exactly one bounded, traversal-safe `BaiduPCS-Go.exe` entry; the extracted executable SHA-256 is recorded only as non-secret audit metadata. The archive digest is the authoritative trust anchor and transitively authenticates the extracted bytes. See the [v4.0.2 release assets](https://github.com/qjfoidnh/BaiduPCS-Go/releases/expanded_assets/v4.0.2) and [v4.0.2 upstream README](https://github.com/qjfoidnh/BaiduPCS-Go/blob/v4.0.2/README.md). This is a third-party/community CLI, not a claim of Baidu-official software.

The local encrypted portable pending artifact uses the same run-scoped basename as its remote pending object (`vpn-network-optimization-g4b-<runId>.vpr1.pending`). The runner checks exact basename equality before any Baidu CLI query/upload, so a mismatch fails closed before provider interaction.

The runner consumes only the already authenticated local CLI config directory (default `%APPDATA%\BaiduPCS-Go`) through the child-process `BAIDUPCS_GO_CONFIG_DIR` environment setting. It never accepts login credentials, cookies, tokens, or passwords as CLI arguments. Before recovery Secret access, it runs `who`, parses only the expected numeric account UID in memory, and discards the captured account output; missing login or account mismatch fails closed. CLI stdout/stderr is captured and never copied to normal logs or Evidence. The Owner-selected account identity and config path are not committed.

```text
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
BAIDU_REMOTE_DIRECTORY=/vpn-network-optimization-g4b-recovery
LIVE_PROVIDER_OPERATIONS_IN_R4=NONE
```

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
- `scripts/g4b-persistent-three-role-live-runner.ps1` (R5R1 Baidu backend source candidate; no live invocation in R5R1)
- `scripts/g4b-live-runner-fixture-validator.ps1` (offline-only R1–R4 regressions plus R5R1 fixtures)

No file above contains live credential values.

## 11. Windows outer-bypass prerequisite — RESOLVED

Accepted G4-B0 evidence now proves the Windows Mihomo `interface-name` mechanism for HY2 outer traffic on the current Owner host while WireGuard remains connected and exact VPS `/32` routes remain absent.

```text
OUTER_BYPASS_MECHANISM=PASS_FOR_HY2_ON_CURRENT_OWNER_HOST
R3R2_USED_EXPLICIT_TEMP_VPS_32_ROUTE=YES
G4B0_FORMAL_RESULT=PASS
PERSISTENT_VPS_32_ROUTE_REQUIRED_FOR_HY2=NO
REALITY_CLIENT_PATH_PROOF=NOT_CLAIMED_BY_G4B0
```

G4-B may therefore proceed without designing a persistent VPS `/32` route solely for HY2. REALITY client-path behavior must be validated within its later applicable Gate rather than inferred from HY2.

## 12. Remaining prerequisites before live authorization is executable

```text
OFFLINE_PACKAGE_STATIC_REVIEW=PASS_REVIEWER_ACCEPTED
WINDOWS_OUTER_BYPASS_PROOF=PASS_G4B0
DEDICATED_RUNTIME_IDENTITY_CONTRACT=READY
ROLLBACK_CONTRACT=READY
LIVE_RUNNER=R5R1_BAIDU_BACKEND_REVIEWER_ACCEPTED
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
OWNER_LOCAL_BAIDU_AUTHENTICATION=REQUIRED_AT_LIVE_PREFLIGHT
LIVE_G4B_OWNER_AUTHORIZATION=GRANTED_BY_CURRENT_REVIEWER_GATE
```

R5R1 is Reviewer accepted after source-contract checks and a local fake CLI shim. Actual account readiness, upload/download, VPS deployment, and Owner UI actions remain unexecuted. The immediate next boundary is an offline-reviewed Owner-local Baidu authentication-readiness checkpoint; live G4-B remains blocked until that checkpoint and the later Owner-local authenticated-config proof pass.
