# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7 / ACTIVE_PROVISIONAL  
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
G4-B0 Windows interface bypass canary            PASS
G4-B Persistent three-role readiness             IN_PROGRESS
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
- G4-A offline plan/package is PASS. G4-B0 is now formally PASS: on the current Owner Windows host, Mihomo `interface-name` carried HY2 traffic over the dynamically discovered physical interface while WireGuard remained connected and exact active/persistent VPS `/32` routes stayed absent. The OpenAI probe returned HTTP 401 through the proxy, the public-exit probe matched the accepted SFO3 exit, request count was exactly 2, and final cleanup restored baseline. G4-B persistent implementation may now proceed to offline runner/package work without designing a persistent `/32` route solely for HY2. This does not yet prove REALITY client-path behavior or production-role acceptance.
- G4-B Baidu recovery backend R5R1 is formally Reviewer PASS. The verified local ZIP path is now used after archive SHA-256 validation, production pending local/remote basenames are aligned with a pre-CLI fail-closed guard, R1-R4 regressions and R5R1 fixtures passed, and no live/Baidu/VPS/Secret/network action occurred. This accepts the offline backend source only; G4-B itself remains IN_PROGRESS.
- R6 Owner-local Baidu auth-readiness checkpoint passed its non-ACL offline boundaries, but formal Reviewer result is RETURN because the production config ACL predicate does not yet validate the full Governance ACL invariant (inheritance, Deny rules, explicit allowlist, and Owner required read rights). Synthetic ACE injection is accepted as the correct fixture technique; R6R1 is the only required repair.

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
GATE_ID=G4B_PERSISTENT_THREE_ROLE_READINESS
STATE=EXECUTOR_ASSIGNED_BAIDU_AUTH_READINESS_ACL_REPAIR_R6R1
CURRENT_GATE_ESTIMATED_EXECUTION_TIME=10-20 minutes
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
PREVIOUS_RESULT=RETURN_R6_ACL_INVARIANT_INCOMPLETE
OBJECTIVE=Make HY2-SFO3 PRIMARY, WG-BASELINE BACKUP_1, and REALITY-SFO3 BACKUP_2 durably ready without enabling production-wide takeover or entering G4-C.
MAX_ENDPOINT_THIS_ROUND=Offline-only R6R1 repair of the Baidu config ACL predicate and synthetic ACL fixtures; preserve all accepted R6 non-ACL behavior and perform zero live actions.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Current accepted SFO3 VPS + current Owner Windows host; persistent project-owned REALITY service and one persistent SELF-VPN-V1 Clash profile are the later live targets.
APPLICABLE_CRITICAL_CONSTRAINTS=WireGuard remains rollback; HY2 preserved; no auto switching; final system proxy OFF; final TUN OFF; no G4-C workloads; no Secret values in GitHub/chat/logs; no broad firewall/route/service cleanup.
PREFLIGHT=R5R1 PASS; R6 candidate source identities locked; R6 non-ACL boundaries accepted; no vpn-network-optimization source drift after R6 final timing commit; exact R6R1 Gate blob required.
REQUIRED_EVIDENCE=Production ACL predicate proves exact Owner, explicit safe Allow principals, direct/inherited ACE review, Deny rejection, Owner required read rights, broad/arbitrary principal rejection, plus complete R6 regression, AST, Secret scan, and zero live actions.
ACCEPTANCE_CRITERIA=R6R1_FULL_ACL_INVARIANT_PASS + R6_FULL_REGRESSION_PASS + POWERSHELL_AST_PASS + SECRET_SCAN_PASS + REAL_BAIDU_ACTIONS_0 + OWNER_CONFIG_READ_0 + LIVE_G4B_ACTIONS_0.
ROLLBACK_STATUS_OR_PLAN=R6R1 is source/docs only; revert only the two R6 scripts plus R6R1 Evidence/Executor-Handoff changes. No runtime rollback is required.
OWNER_ONLY_ACTIONS=NONE during R6R1. Do not run the Owner checkpoint. Credentials/cookies/tokens remain Owner-local and must never enter chat, GitHub, logs, environment values, or process arguments.
REVIEWER_TO_EXECUTOR_RELAY=docs/G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1.md + the two locked R6 script blobs only. Do not reread broad history or redesign accepted R6 behavior.
EXECUTOR_TO_REVIEWER_RELAY=Standard short completion packet; detailed sanitized proof to EXECUTION_EVIDENCE.md; mandatory stop after G4-B.
```

G4-B0 is formally closed PASS. The G4-B offline live-runner package is Reviewer PASS through R5R1 backend repair. No persistent VPS/Windows mutation has occurred yet. Owner selected Baidu Netdisk as the second-failure-domain provider and live G4-B authorization remains granted. R6 returned only on an ACL-validator completeness gap; live G4-B remains blocked until R6R1 is Reviewer PASS and the later Owner-side authenticated config is proven.

Current G4-B recovery-backend Executor identity:

```text
G4B_BAIDU_BACKEND_R4_GATE_BLOB=b07461b85319aaa215396a5e8d6f9fe7ea358ec8
G4B_BAIDU_BACKEND_R5_GATE_BLOB=c3eb751396d23f36c4c2a99d4435995d4ea56877
G4B_BAIDU_BACKEND_R5R1_GATE_BLOB=1d5ae4c7563c195ba4dab747b3b0ea8b493b5ffb
G4B_BAIDU_AUTH_R6_GATE_BLOB=9b4822bbf293e055831f7cc911f98e404695e0ac
G4B_BAIDU_AUTH_R6_RESULT=RETURN_R6_ACL_INVARIANT_INCOMPLETE
G4B_BAIDU_AUTH_R6_CHECKPOINT_BLOB=18c0cfc397939930b7556b51153f27a63de85ae0
G4B_BAIDU_AUTH_R6_VALIDATOR_BLOB=b7d5c2162db54ad92bd910035d33a03dc2027546
G4B_BAIDU_AUTH_R6_FINAL_TIMING_COMMIT=34f0bd2c3a6b5452aa91578176fb17278a796689
G4B_BAIDU_AUTH_R6R1_GATE_BLOB=3cdfec9d1a82d84da8f0384d0eeb7ff1fdfe62d0
SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK
OWNER_LIVE_G4B_AUTHORIZATION=GRANTED
REAL_BAIDU_LOGIN_OR_UPLOAD_AUTHORIZED_IN_R4=NO
G4B_BAIDU_BACKEND_R5R1_RESULT=PASS
G4B_BAIDU_BACKEND_R5R1_SOURCE_COMMIT=f1c1b1abdd713089edc4fa677322b96aadcc7e3d
G4B_R5R1_RUNNER_BLOB=f9729791b36b042a305207be24f5ced87113820c
G4B_R5R1_FIXTURE_VALIDATOR_BLOB=2bbc5c61c51fd381063fceebcaa5114b23daa36b
G4B_R5R1_IMPLEMENTATION_PACKAGE_BLOB=305b0b2d8fa14917b7057c6dfeb52a28e0a52f08
```

Current G4-B offline Executor identity:

```text
G4B_OFFLINE_IMPLEMENTATION_R1_GATE_BLOB=6ebf299166109b0640f2acd93cd8c669bc036b32
G4B_OFFLINE_REPAIR_R2_GATE_BLOB=b60c1d1bf09cac5467f547b83dc2c13a4af850d8
G4B_OFFLINE_REPAIR_R3_GATE_BLOB=c76c7118d181f7d01897ba39429334d0068b92e4
EXECUTOR_ROLE=CODEX_DESKTOP_OFFLINE_RUNNER_REPAIR_AND_FIXTURE_VALIDATION
LIVE_G4B_EXECUTION_AUTHORIZED=YES
```

Locked G4-B0 final identities:

```text
G4B0_RUNNER_BLOB=71746ed816a89ccc8d3173a8743713cc9877e64a
G4B0_TEMPLATE_BLOB=f8c637d28a35d3795c8ebaf470d50248562dbaf8
G4B0_VALIDATOR_BLOB=e6d7ac364aca14d52737315a020de7be8d8db1b0
G4B0_GATE_BLOB=fcab4cef6a68f9c57c1077134d9b6b237f21ebd9
```

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

- G4-B0 is formally PASS and closed.
- G4-B Baidu recovery backend R5R1 is formally PASS. R6 auth-readiness checkpoint is Reviewer RETURN only for ACL invariant completeness; persistent REALITY/service/Secret/profile writes remain blocked until R6R1 PASS and later Owner-local authenticated Baidu config proof.
- Baidu Netdisk is the approved second failure domain; the remaining recovery prerequisite is proving an Owner-local authenticated BaiduPCS-Go config through the reviewed readiness boundary without exposing credentials.
- Persistent REALITY backup service does not yet exist; the accepted public REALITY canary was temporary and cleaned.
- Persistent three-role Clash profile does not yet exist.
- G4-C must prove how representative Codex/OpenAI/image-generation traffic actually traverses the selected Clash role; system proxy is tested before any TUN design.
- G4-C peak-hour + representative real-workload validation remains pending.
- Final v1 production default/control posture remains pending G4.
- Final WireGuard routing / kill-switch policy remains pending v1 sealing.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

Codex executes `G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1` only. It narrowly repairs the production Baidu config ACL predicate to cover inheritance, explicit safe principals, Deny rules, and Owner required read rights; it uses synthetic ACE fixtures through the exact production predicate, reruns the complete R6 validator, and stops at Reviewer.

## OWNER_ACTION_REQUIRED

NONE during R6R1 offline ACL repair.

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
