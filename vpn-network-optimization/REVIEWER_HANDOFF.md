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
G3-C Real HY2-in-Clash canary R3R2          AUTH_REQUIRED
G4 Peak-hour + real workload final validate PENDING
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
GATE_ID=G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R3R2
STATE=OWNER_AUTHORIZATION_REQUIRED
PREVIOUS_RESULT=PASS_G3C_C2C_SECRET_PREPARE_REPAIR_VERIFICATION_R2R3V2
OBJECTIVE=Run one bounded real HY2-in-Clash canary on the real Owner Windows host using the repaired Secret helper, keep WireGuard as rollback, and restore all temporary state afterward.
MANDATORY_REVIEW_STOP=YES
OWNER_C2C_AUTHORIZATION=REQUIRED_FRESH
```

Fresh Owner authorization has **not** yet been granted for R3R2 at this handoff.

### R3R2 maximum endpoint after fresh approval

```text
safe ff-only sync
-> exact six source identities
-> preflight
-> one Secret Prepare
-> Owner UI import with WG-BASELINE selected
-> one temporary ActiveStore-only /32 route
-> Owner selects HY2-SFO3-REAL
-> exactly two bounded proxy requests
-> Owner returns to WG-BASELINE and removes C2C profile
-> Secret cleanup / route / profile / network readback
-> STOP_AT_REVIEWER
```

Required real requests:

- OpenAI `/v1/models`: curl exit 0, HTTP 401, proxy used.
- public-exit check: accepted SFO3 exit.

## CRITICAL_CONSTRAINTS

- No R3R2 execution before fresh explicit Owner authorization.
- Exactly two external requests in R3R2; no benchmark loop.
- Production WireGuard stays connected/available as rollback.
- System proxy stays OFF.
- Clash TUN stays OFF.
- Temporary route is ActiveStore-only `/32`; no persistent route/default-route change.
- No VPS/SSH mutation in R3R2.
- No REALITY activation in R3R2.
- No automatic switching or persistent default change.
- No G4 in R3R2.
- No Secret/hash/raw helper output.
- Any consequential failure/ambiguity is reconciled before retry; no blind replay.

## DEFAULT_EXECUTION_CHANNEL

- Reviewer may directly perform normal repository/document/source repair when inside the current accepted project boundary.
- Owner executes consequential Windows checkpoints in PowerShell 7.6.6 + Administrator + High integrity.
- Executor is used when independent implementation/testing materially improves safety or speed; current R3R2 has `EXECUTOR_ROLE=NO_ACTION`.
- Owner-local convenience path previously used:
  `C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\c2c-owner-clash-real-canary.ps1`
- Local path is not source authority; every consequential run still safe-syncs to GitHub `main` and locks blobs.

## CURRENT_ROLLBACK_STATUS

- WireGuard is the active rollback path.
- R2R3V2 left zero C2C runtime directory/profile residue.
- No temporary route from R2R3V2 exists.
- No Clash C2C profile was imported during R2R3V2.
- R3R2 runner is designed to remove its temporary route in `finally` and invoke fallback Secret cleanup when needed.
- If a C2C profile has been imported and a later step fails, Owner UI cleanup may still be required before retry.

## UNRESOLVED

- Fresh Owner authorization for exactly one R3R2 real HY2-in-Clash canary.
- Real HY2 authentication/connectivity through the actual Clash profile lifecycle is not yet formally PASS.
- G4 peak-hour + representative Codex/OpenAI/image-generation workload validation remains pending.
- Final v1 default-role selection among WireGuard/HY2/REALITY remains pending G4/final evidence.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

Ask the Owner for fresh authorization for one bounded `G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R3R2`.

If authorized, provide one atomic Owner PowerShell checkpoint and the three exact UI acknowledgements. Do not enter G4 in the same round.

## OWNER_ACTION_REQUIRED

Authorize or decline one bounded R3R2 real HY2-in-Clash canary.

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
