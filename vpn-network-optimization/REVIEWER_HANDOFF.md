# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.6 / ACTIVE_PROVISIONAL  
> Canonical branch: `main`  
> Detailed chronology: `docs/REVIEWER_TRANSITION_2026-10-04.md`  
> Detailed proof: `EXECUTION_EVIDENCE.md`

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现。WireGuard 当前仍是生产/回退基线；HY2 是当前 G3-C 真实 Clash 控制面验证对象；REALITY 是已验证的 TCP/443 兼容候选。

## PROJECT_STAGE

```text
P0 Research / Scope                         PASS
G1 Foreground-safe Foundation               PASS
G2 Multi-path candidate validation          PASS
G3-A Health/readiness/advisory              PASS
G3-B Migration package D1-D3                PASS_OFFLINE
G3-C Manual-control contract C1             PASS
G3-C Synthetic UI package C2A               PASS
G3-C Synthetic Clash UI canary C2B          PASS
G3-C Real C2C package + scanner repair      PASS
G3-C Secret Prepare real-host verification  PASS
G3-C Real HY2-in-Clash canary R3R2          PASS
G4-A Three-role target/offline package          PASS
G4-B0 Windows interface bypass canary            AUTH_REQUIRED
G4-B Persistent three-role readiness             PENDING
G4-C Peak-hour + real workload final validate    PENDING
MVP v1 seal                                 PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Production / rollback: WireGuard
│  ├─ IPv4 coverage: 0.0.0.0/1 + 128.0.0.0/1
│  ├─ active MTU: 1420
│  └─ current self-hosted VPS: DigitalOcean 24.199.118.137 / sfo3
├─ Clash Verge 2.5.6
│  └─ local SOCKS5 listener must be dynamically discovered
│     └─ D5 observed 127.0.0.1:7900, but port 7900 is NOT a hardcoded contract
├─ HY2 candidate
│  ├─ server: Hysteria2 v2.12.3
│  ├─ UDP/8443
│  └─ current C2C Owner Mihomo validation baseline: v1.19.32
└─ REALITY candidate
   └─ historical G2-C interoperability baseline: Mihomo v1.19.31
```

## CURRENT_ACCEPTED_STATE

### Transport and architecture

- WireGuard is the production and rollback baseline.
- HY2 passed the historical same-window 60/60 comparison against WireGuard and showed better median/tail behavior in that accepted sample.
- VLESS + REALITY + Vision passed private implementation A/B and public TCP/443 canary; it remains a compatibility candidate, not the current active G3-C target.
- G3-A sensing/readiness/advisory automation is complete; no automatic network-switch actuator is authorized.
- G3-B migration package D1-D3 is complete offline; fresh-target live rehearsal remains deferred.
- G3-C synthetic manual-control/UI behavior is accepted.
- G3-C R3R2 real HY2-in-Clash canary is formally PASS: the bounded OpenAI request used the explicit Clash proxy path, the public-exit check matched the accepted SFO3 exit, and final cleanup/read-back restored the WireGuard/network/profile baseline.
- Owner target v1 role order is now HY2-SFO3 PRIMARY, WG-BASELINE BACKUP_1, REALITY-SFO3 BACKUP_2. This order is frozen for G4 validation but is not yet a production-role PASS.
- G4-A offline plan/package is PASS. G4-B persistent implementation contract is prepared offline, including least-privilege REALITY service identity/capability boundaries and exact rollback semantics. A fresh review found one prerequisite gap: Windows Mihomo `interface-name` bypass is still unproven live, while accepted G3-A/R3R2 evidence relied on an exact VPS `/32` physical-egress route. Persistent REALITY readiness and the persistent three-role Clash profile are therefore not yet deployable.

### Secret / recovery

- Secret values never enter GitHub/chat/ordinary logs/handoff.
- Accepted recovery metadata: `%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi`, DPAPI CurrentUser, accepted `VPNHY2R1` bundle.
- Do not re-fetch or rotate the HY2 credential to continue C2C.
- R2R3V2 proved real Owner-host DPAPI unprotect, bundle/auth validation, certificate fingerprint match, temporary Owner-only profile creation, Mihomo parse, immediate VerifyCleanup, and zero residue.

### Accepted C2C repair

Historical blocker `SECRET_SCAN_READ_FAILED` was localized to transient contention on one Clash-app root-level zero-byte `.lock`.

Accepted scanner policy:

- no generic `.lock` bypass;
- no generic unreadable-file bypass;
- exception activates only **after an actual read exception** in the Clash-app scan;
- fresh metadata must prove the failing item is a direct root child, `.lock`, zero-byte, normal file, and non-reparse;
- project-runtime scanning has no exception and remains strict;
- every other unreadable-file case remains fail-closed.

R2R3 Owner validation passed Fixtures A-L, PowerShell AST parse and Mihomo fixture parse. R2R3V2 then behaviorally verified real Secret Prepare + immediate cleanup on the Owner host.

### Locked current C2C identities

```text
ORCHESTRATOR_BLOB=4424eab2f281af6398f6d7bfbe6e326bce5f7904
SECRET_HELPER_BLOB=81c5a43d4a947d57e44752fd7a09c59e735748e2
PROXY_PROBE_BLOB=d3403cba9196b55083ff9f443e9011582ef9cc01
VALIDATOR_BLOB=e520fa7b6c08b2e46365b55ec731a20bdb810c04
TEMPLATE_BLOB=ea18bdccf8f00f2d6d705e4ba34ba57db243722a
PACKAGE_BLOB=d9e815171d8d7b00722b213b6df6d52c46f6265e
```

Do not silently substitute historical C2C blobs from old Evidence or Executor sections.

## CURRENT_GATE

```text
GATE_ID=G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1
STATE=REPAIR_VALIDATION_PENDING
PREVIOUS_RESULT=PASS_G4A_THREE_ROLE_TARGET_AND_OFFLINE_PACKAGE
OBJECTIVE=Prove whether Windows Mihomo interface-name alone can carry HY2 outer traffic over the physical egress while WireGuard remains connected and no exact VPS /32 bypass route exists.
MAX_ENDPOINT_THIS_ROUND=One protected temporary local Mihomo HY2 runtime + exactly two bounded requests + cleanup/read-back + STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Current Owner Windows host only; existing accepted HY2 server; no SSH/VPS mutation; no Clash persistent profile.
APPLICABLE_CRITICAL_CONSTRAINTS=WireGuard stays connected; system proxy OFF; TUN OFF; exact active/persistent VPS /32 route count remains zero; no REALITY; no benchmark; no Secret output.
PREFLIGHT=Fresh source, Owner runtime, WG/Clash health, physical-egress discovery, exact VPS /32 absence, local proxy port availability, accepted protected HY2 recovery reader.
REQUIRED_EVIDENCE=interface-name applied; no /32 route before/during/after; Mihomo parse/proxy ready; exactly two proxied requests; OpenAI 401; expected SFO3 public exit; cleanup and baseline restored.
ACCEPTANCE_CRITERIA=PASS_INTERFACE_NAME_BYPASS or precise RETURN without routing inference.
ROLLBACK_STATUS_OR_PLAN=Own only the unique temporary local Mihomo runtime/process; no route/profile/VPS mutation; final network baseline must equal pre-canary.
OWNER_ONLY_ACTIONS=The repaired live retry authorization is consumed. No further live retry is authorized until the SOCKS listener readiness semantics are repaired and non-consequential validation passes.
REVIEWER_TO_EXECUTOR_RELAY=docs/G4B0_WINDOWS_INTERFACE_BYPASS_CANARY_GATE.md + accepted R3R2 Secret/runtime safety pattern + accepted G3-A physical-egress semantics; no historical diagnostic replay.
EXECUTOR_TO_REVIEWER_RELAY=Standard short completion packet; detailed sanitized proof to EXECUTION_EVIDENCE.md; mandatory stop.
```

G4-B persistent readiness is blocked on this bypass proof. The first G4-B0 live attempt formally RETURNed before any external request; its authorization is consumed. Persistent REALITY/service/profile writes remain unauthorized.

Locked G4-B0 repair identities:

```text
G4B0_REPAIR_CHECKPOINT_BLOB=8249091f6fcf469c303c449a2912ad507dead7a2
```

Locked G4-B0 live identities:

```text
G4B0_RUNNER_BLOB=71746ed816a89ccc8d3173a8743713cc9877e64a
G4B0_TEMPLATE_BLOB=f8c637d28a35d3795c8ebaf470d50248562dbaf8
G4B0_VALIDATOR_BLOB=25e9624092ecef7fc23ae97569d85026e3ebef56
G4B0_GATE_BLOB=ae6018d5a7650c4d694b242e885e8dc3b616e630
```

The second live retry returned before any external request because the readiness check rejected a loopback SOCKS UDP endpoint. That authorization is consumed. The readiness invariant has now been repaired to allow SOCKS TCP/UDP only on loopback, and the new runner/validator/checkpoint package has passed repository-level static review. Owner-host repair checkpoint is still required before any fresh live authorization can be requested.

## CRITICAL_CONSTRAINTS

- Target v1 role order is HY2 PRIMARY, WG BACKUP_1, REALITY BACKUP_2.
- The target order is an Owner decision, not yet a technical production-role PASS.
- WireGuard remains the current production/rollback baseline until G4 acceptance and v1 sealing.
- Existing HY2 service must remain healthy through G4-B.
- Persistent REALITY deployment is a new consequential public-service/Secret boundary and requires fresh Owner authorization.
- No automatic switching.
- G4-B ends with system proxy OFF and TUN OFF.
- G4-C real workloads are not part of G4-B.
- Secret values/hashes/raw credential material never enter GitHub/chat/ordinary logs/Handoff/Evidence.
- Any failed/ambiguous live G4-B attempt is reconciled before retry.
- G3-B fresh-target live migration rehearsal remains deferred.

## DEFAULT_EXECUTION_CHANNEL

- Reviewer may directly perform normal repository/document/source repair when inside the current accepted project boundary.
- Owner executes consequential Windows checkpoints in PowerShell 7.6.6 + Administrator + High integrity.
- Executor is used when independent implementation/testing materially improves safety or speed; current R3R2 has `EXECUTOR_ROLE=NO_ACTION`.
- Owner-local convenience path previously used:
  `C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\c2c-owner-clash-real-canary.ps1`
- Local path is not source authority; every consequential run still safe-syncs to GitHub `main` and locks blobs.

## CURRENT_ROLLBACK_STATUS

- WireGuard is the active production/rollback path.
- R3R2 final read-back restored the pre-canary network state.
- The temporary ActiveStore-only HY2 /32 route is absent.
- The unique temporary C2C profile is removed and the Clash profile store returned to baseline.
- Project runtime cleanup passed and no R3R2 temporary runtime remains accepted as live state.
- System proxy is OFF and Clash TUN is OFF.

## UNRESOLVED

- First and repaired-retry G4-B0 live authorizations are both consumed. No live retry is currently authorized.
- G4-B persistent REALITY/service/Secret/profile writes remain blocked until G4-B0 is formally reviewed.
- An approved encrypted recovery destination in a second failure domain (distinct from both the SFO3 VPS and this Windows local disk) is still Owner input required before G4-B can PASS.
- Persistent REALITY backup service does not yet exist; the accepted public REALITY canary was temporary and cleaned.
- Persistent three-role Clash profile does not yet exist.
- G4-C must prove how representative Codex/OpenAI/image-generation traffic actually traverses the selected Clash role; system proxy is tested before any TUN design.
- G4-C peak-hour + representative real-workload validation remains pending.
- Final v1 production default/control posture remains pending G4.
- Final WireGuard routing / kill-switch policy remains pending v1 sealing.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

Owner-local AST-only checkpoint PASS on PowerShell 7.6.6. The repaired offline validator also PASSed on the Owner host with zero network mutation and zero Secret access. The live runner remains unchanged. The one-shot live authorization remains valid and unconsumed.

## OWNER_ACTION_REQUIRED

Repair is complete and offline static review PASS. Run only non-consequential Owner-local AST + validator checks against the repaired locked blobs. If both PASS, request fresh explicit Owner authorization for one repaired live retry. Do not run the live runner yet.

## EVIDENCE_POINTERS

Read only what is needed:

- `docs/REVIEWER_TRANSITION_2026-10-04.md` — complete transition chronology and accepted boundaries.
- `EXECUTION_EVIDENCE.md` — append-only execution proof; accepted R2R3/R2R3V2 sections are near the tail.
- `DECISION_LOG.md` — architecture and authorization rationale, including accepted scanner repair and fresh R3R2 authorization requirement.
- `docs/G3C_C2C_REAL_HY2_CANARY_PACKAGE.md` — accepted real canary package contract.
- `docs/G3C_C2B_OWNER_CANARY_PACKAGE.md` — accepted synthetic UI canary package.
- `docs/G3C_MANUAL_CONTROL_CONTRACT.md` — accepted manual-control contract.
- `docs/G3B_MIGRATION_PACKAGE.md` and `docs/G3B_STAGED_INSTALL_MANIFEST.md` — accepted G3-B offline migration package.
- `docs/ROUND_TIMING_RETROSPECTIVE.md` — process/timing notes only; not canonical project truth.
- `EXECUTOR_HANDOFF.md` — historical Executor facts only; never use it to override this file.

Historical Reviewer narrative remains in Git history and the transition snapshot; it is intentionally not duplicated here.
