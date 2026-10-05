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
STATE=OWNER_ACTION_REQUIRED_BAIDU_READONLY_DIAGNOSTIC_REPAIR_R6R2L_R8
CURRENT_GATE_ESTIMATED_EXECUTION_TIME=OWNER_LOCAL_READ_ONLY_NETWORK_DIAGNOSTIC
TIME_OVERRUN_REASON_REQUIRED_IF_YES=YES
PREVIOUS_RESULT=RETURN_R6R2L_R7_BAIDU_WHO_PROPERTY_NOT_FOUND
OBJECTIVE=Repair only the R7 diagnostic result-object handling and re-run the same Baidu who/ls read-only boundary with bounded substage and line classification.
MAX_ENDPOINT_THIS_ROUND=Owner-local read-only Baidu diagnostic only. who + ls -l only; no mutation command, no live runner, no SSH/VPS, no recovery/profile/service/network mutation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner Windows host + Baidu read-only API path only.
APPLICABLE_CRITICAL_CONSTRAINTS=No Secret/UID/raw stdout/stderr in chat/GitHub; no live runner; no Baidu mutation; no SSH/VPS; no profile/service/route/proxy/TUN mutation; no G4-C.
PREFLIGHT=R6 formal PASS; R7 returned PropertyNotFoundException at BAIDU_WHO while temp cleanup PASS and all mutation counters NO.
REQUIRED_EVIDENCE=BAIDU_CONFIG_ACL; pinned CLI identity; who process/result/UID parse/match classifiers; ls process/result/header classifier if reachable; bounded exception line/substage; temp cleanup PASS; no mutation/no Secret output.
ACCEPTANCE_CRITERIA=Bounded classification obtained without dynamic property failure; TEMP_RUNTIME_CLEANUP=PASS; BAIDU_MUTATION_ACTION=NO; SSH_OR_VPS_ACTION=NO; SECRET_VALUES_EMITTED=0; STOP_AT_REVIEWER=YES.
ROLLBACK_STATUS_OR_PLAN=Diagnostic creates only a temporary local runtime directory and deletes it before exit. No remote rollback should be required.
OWNER_ONLY_ACTIONS=Safe fast-forward to current main, verify R8 Gate/script blobs, run only g4b-baidu-readonly-diagnostic.ps1, enter expected Baidu UID through hidden local prompt, return sanitized markers, stop.
REVIEWER_TO_EXECUTOR_RELAY=NONE.
EXECUTOR_TO_REVIEWER_RELAY=Return diagnostic markers only; no live retry.
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
G4B_BAIDU_AUTH_R6R1_RESULT=PASS
G4B_BAIDU_AUTH_R6R1_FINAL_COMMIT=a13c0c76e9a3a5051848db78615fadbf12506d9b
G4B_BAIDU_AUTH_R6R1_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
G4B_BAIDU_AUTH_R6R1_VALIDATOR_BLOB=891d2eaf981962d2241ec008877b8188dc150dee
G4B_BAIDU_AUTH_R6R2_GATE_BLOB=75272436cab8bf88297aa0486d68808fd064b6d0
G4B_BAIDU_UID_DISCOVERY_R6R2A_GATE_BLOB=c5e3fee84339e5511c0ea67b798751409998bb7a
G4B_BAIDU_UID_DISCOVERY_R6R2A_RESULT=PASS
G4B_BAIDU_UID_DISCOVERY_R6R2A_SOURCE_COMMIT=2383211efed12988ebf2742e5ab1150d76ea14c3
G4B_BAIDU_UID_DISCOVERY_HELPER_BLOB=ba8502287989ecc8c9b003e67c729b6d82df378a
G4B_BAIDU_UID_DISCOVERY_VALIDATOR_BLOB=d750c0e665cdfe896e9728a499aad88c77454274
G4B_BAIDU_UID_DISCOVERY_R6R2B_GATE_BLOB=7842ab6c3ce77a5c7011777079ed71510d66a161
G4B_BAIDU_UID_DISCOVERY_R6R2B_RESULT=RETURN_OWNER_ACTION_REQUIRED
G4B_BAIDU_INTERACTIVE_AUTH_R6R2C_GATE_BLOB=5da63ed15d116ad85517b1e757a20f7bdd834341
G4B_BAIDU_INTERACTIVE_AUTH_R6R2C_RESULT=PASS
G4B_BAIDU_INTERACTIVE_AUTH_R6R2C_SOURCE_COMMIT=c7516042c9c2f4a6e373b9a35986c760d1583e89
G4B_BAIDU_INTERACTIVE_AUTH_HELPER_BLOB=cbf8c971567faea3b1735786827611861dafe52a
G4B_BAIDU_INTERACTIVE_AUTH_VALIDATOR_BLOB=4bf30c0629f8136f8a3eb6c4d8710d1c801472e7
G4B_BAIDU_INTERACTIVE_AUTH_R6R2D_GATE_BLOB=3d31312f26ebe10d43fcf4221cf7365fbe374365
G4B_BAIDU_INTERACTIVE_AUTH_R6R2D_RESULT=RETURN_PROVIDER_BUSY_OWNER_MISMATCH
G4B_BAIDU_PARTIAL_CONFIG_REPAIR_R6R2E_GATE_BLOB=d1b3790ae7f670bc660a52dfd13d91d562213eca
G4B_BAIDU_PARTIAL_CONFIG_REPAIR_R6R2E_RESULT=RETURN_PREEXISTING_EMPTY_ROOT_DELETION_RISK
G4B_BAIDU_ROLLBACK_PROVENANCE_REPAIR_R6R2E_R1_GATE_BLOB=a0262bdb70a8a72edcd6df32a5011964c236cd83
G4B_BAIDU_ROLLBACK_PROVENANCE_REPAIR_R6R2E_R1_RESULT=PASS
G4B_BAIDU_RECONCILIATION_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
G4B_BAIDU_AUTH_HELPER_BLOB=e67197ee15ad4ce758ed2c624c80d69dfd4bb08a
G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_R6R2F_GATE_BLOB=446da501a77ca58b11cf41a4be2b73f44082ca72
G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_R6R2F_RESULT=PASS
G4B_BAIDU_INTERACTIVE_AUTH_RETRY_R6R2G_GATE_BLOB=2da9a6271c48ad437067d4a5bfa46833d452d5d6
G4B_BAIDU_INTERACTIVE_AUTH_RETRY_R6R2G_RESULT=RETURN_DEPRECATED_INTERACTIVE_LOGIN_50052_EXIT_ZERO
G4B_BAIDU_SECURE_COOKIE_AUTH_ADAPTER_R6R2H_GATE_BLOB=b687d5c3ccd71cfcf869cfe01f3147a59a459f26
G4B_BAIDU_SECURE_COOKIE_AUTH_ADAPTER_R6R2H_RESULT=RETURN_OWNER_CHECKPOINT_POSTAUTH_ACL_AND_FAILURE_RECONCILIATION_GAP
G4B_BAIDU_COOKIE_ADAPTER_SOURCE_BLOB=9298b477ccbaae6439ae33ddf098e343dfac4dc0
G4B_BAIDU_COOKIE_BUILD_HELPER_BLOB=7f369604de3cf0cce46bf0cf7328313c03ed61d5
G4B_BAIDU_SECURE_COOKIE_OWNER_REPAIR_R6R2H_R1_GATE_BLOB=6f448f7c16a322c240f756121ddbbc0ca97dc516
G4B_BAIDU_SECURE_COOKIE_OWNER_REPAIR_R6R2H_R1_STATUS=SUPERSEDED_UNEXECUTED
G4B_BAIDU_SECURE_AUTH_COMBINED_REPAIR_R6R2H_R2_GATE_BLOB=d648f5f44824349aff1824dd4fb5d405a01a5c4d
G4B_BAIDU_OWNER_OUTPUT_CONTRACT_REPAIR_R6R2H_R3_RESULT=PASS
G4B_BAIDU_OWNER_OUTPUT_CONTRACT_REPAIR_R6R2H_R3_SOURCE_COMMIT=0474fe6b68211ce602beaa55cb9dc9786084e694
G4B_BAIDU_OWNER_SECURE_AUTH_R6R2I_GATE_BLOB=00004a88b1edf3a8ca1ba7d3b7135552819a1743
G4B_BAIDU_OWNER_BUILD_DIAGNOSTIC_R6R2I_D1_RESULT=PASS
G4B_BAIDU_RETAINED_BINARY_REPAIR_R6R2I_D2_GATE_BLOB=af0c0ae529c370d1f1a5e7b48256f440bc67ab23
G4B_BAIDU_RETAINED_BINARY_REPAIR_R6R2I_D2_RESULT=PASS
G4B_BAIDU_RETAINED_BINARY_REPAIR_R6R2I_D2_SOURCE_COMMIT=02ab19b52ff993a4a66827ad283614f38295f292
G4B_BAIDU_OWNER_RETAINED_BUILD_R6R2I_D3_GATE_BLOB=8ad825a4cbb75b21bc78bcf92f5cbbb6f9b406c7
G4B_BAIDU_OWNER_RETAINED_BUILD_R6R2I_D3_RESULT=PASS
G4B_BAIDU_OWNER_SECURE_AUTH_R6R2I_D4_GATE_BLOB=8c94ec957f160ee0c09ad9b4d47c177145817251
G4B_BAIDU_OWNER_SECURE_AUTH_R6R2I_D4_AUTH_STATE=PASS
G4B_BAIDU_OWNER_SECURE_AUTH_R6R2I_D4_GATE_RESULT=RETURN_OUTPUT_CONTRACT_EXTRA_ADAPTER_MARKERS
G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5_GATE_BLOB=5ab5a28d3772b8efbb7a7ac37483f3c8b8585c91
G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5_RESULT=RETURN_GO_SOURCE_TESTS_UNAVAILABLE
G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5_SOURCE_COMMIT=3cf6fdb7f972314b2bf37250b95a8ca7926b46a7
G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1_GATE_BLOB=f761a6b4eb60966951f0986f62935c8176d36e8a
G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1_RESULT=PASS
G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5_FINAL_RESULT=PASS
G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_R6R2J_GATE_BLOB=fed3c0060b56f758fad48b612421e9f7b0ae4cf6
G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_R6R2J_RESULT=RETURN_BAIDU_UID_OUTPUT_AMBIGUOUS
G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1_GATE_BLOB=33609b9eb0b51b6387e428acbf625a3f21d1441f
G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1_RESULT=PASS
G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1_SOURCE_COMMIT=e70eb9168771df38eb2e5989e7f0a1551e895b05
G4B_BAIDU_UID_DISCOVERY_HELPER_CURRENT_BLOB=ebba88863d55d74956d3b745eab8f0f18a7d1dee
G4B_BAIDU_UID_DISCOVERY_VALIDATOR_CURRENT_BLOB=59a6bd86cf021986b7e8066fa08108e9435852c5
G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_RETRY_R6R2J_R2_GATE_BLOB=ba7df8f44132fb8ff8f55c3f95f5b790a2f0a417
G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_RETRY_R6R2J_R2_RESULT=RETURN_BAIDU_UID_OUTPUT_AMBIGUOUS
G4B_BAIDU_UID_UTF8_HELPER_BLOB=db75bb7fb2cefffb243b8003186ac6b5dcc96372
G4B_BAIDU_UID_UTF8_VALIDATOR_BLOB=bde25e6987a16d9f06a368c73b432cb57d958761
G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3_GATE_BLOB=8edcaf366a27b4e90784f546b7edf35fb2a29942
G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3_RESULT=PASS
G4B_BAIDU_POSTAUTH_IDENTITY_DISCOVERY=PASS
G4B_BAIDU_STANDALONE_R6R2_READINESS=SUPERSEDED_REDUNDANT_POSTAUTH
G4B_LIVE_RUNNER_BAIDU_UTF8_BLOB=cf7bc19b1accc142065416bc6c6525aa7b58fc23
G4B_LIVE_RUNNER_VALIDATOR_UTF8_BLOB=5d560481b0367bc0ab783ddd51b4c27285dd5831
G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K_GATE_BLOB=eee401fde4e9cdb1713166737731ace3e9c7e836
G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K_RESULT=PASS
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_GATE_BLOB=e787311742f5bae97b3bfb8745dcb7c3920ca8af
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_RESULT=RETURN_P0_CANONICAL_GIT_QUERY_FAILED
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_CONSEQUENTIAL_MUTATION_STARTED=NO
G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1_GATE_BLOB=afbe9f2d89e3dc35447e73425a4e072478837e29
G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1_RESULT=RETURN_GIT_RUNNER_ROOT_PATH_QUERY_FAILED
G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1_RUNNER_BLOB=ad990886a6e0853c5b30828c5afbcc37d2290c71
G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1_VALIDATOR_BLOB=baf2fb35e9a3ea8644f9fdbf151a2a560bbef98d
G4B_CANONICAL_GIT_AND_CRLF_REPAIR_R6R2L_R2_GATE_BLOB=37a0d1931f3d6fbe1b3fe1a92e664f98f6060bfe
G4B_CANONICAL_GIT_AND_CRLF_REPAIR_R6R2L_R2_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
G4B_CANONICAL_GIT_AND_CRLF_REPAIR_R6R2L_R2_VALIDATOR_BLOB=770f70119040993a66e9b3b3cb25f5d5075b0ec0
G4B_CANONICAL_GIT_AND_CRLF_REPAIR_R6R2L_R2_RESULT=RETURN_VALIDATOR_PARSER_ERROR
G4B_VALIDATOR_SYNTAX_REPAIR_R6R2L_R3_GATE_BLOB=74ac032f3ad7df08eea4e69f132def769cf132b8
G4B_VALIDATOR_SYNTAX_REPAIR_R6R2L_R3_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
G4B_VALIDATOR_SYNTAX_REPAIR_R6R2L_R3_VALIDATOR_BLOB=753570734f82e75ab0a0ec56c4a8c6f0d3c469cb
G4B_VALIDATOR_SYNTAX_REPAIR_R6R2L_R3_RESULT=RETURN_CRLF_ASSERTION_FALSE_NEGATIVE
G4B_CRLF_VALIDATOR_ASSERTION_REPAIR_R6R2L_R4_GATE_BLOB=d53822ed92eebaf196ce7e5270301bf9bba30cca
G4B_CRLF_VALIDATOR_ASSERTION_REPAIR_R6R2L_R4_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
G4B_CRLF_VALIDATOR_ASSERTION_REPAIR_R6R2L_R4_VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
G4B_CRLF_VALIDATOR_ASSERTION_REPAIR_R6R2L_R4_RESULT=PASS
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_R5_GATE_BLOB=bc02a9f76fb76ffdde24302db71d52c03f1c7577
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_R5_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_R5_VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_R5_RESULT=RETURN_P5_UNCLASSIFIED
G4B_P5_LOCAL_DIAGNOSTIC_R6R2L_R6_GATE_BLOB=958e62f57189e39ce33d57b524abc6280aa481c4
G4B_P5_LOCAL_DIAGNOSTIC_R6R2L_R6_SCRIPT_BLOB=1382a7a23885b62be35442d907e4bb9cd0523f70
G4B_P5_LOCAL_DIAGNOSTIC_R6R2L_R6_RESULT=PASS
G4B_BAIDU_READONLY_DIAGNOSTIC_R6R2L_R7_GATE_BLOB=823d21de310c73fcb5f464b8c90694a0a8116b1d
G4B_BAIDU_READONLY_DIAGNOSTIC_R6R2L_R7_SCRIPT_BLOB=84e8706449147d8667414e59de22f0ae33b27c4b
G4B_BAIDU_READONLY_DIAGNOSTIC_R6R2L_R7_RESULT=RETURN_BAIDU_WHO_PROPERTY_NOT_FOUND
G4B_BAIDU_READONLY_DIAGNOSTIC_REPAIR_R6R2L_R8_GATE_BLOB=20ed0bbe8fe7a298bd46ec9ebccbd8ac0421f4f5
G4B_BAIDU_READONLY_DIAGNOSTIC_REPAIR_R6R2L_R8_SCRIPT_BLOB=59c2ab662562d6130fc9215dae810edbfed59ac2
G4B_BAIDU_READONLY_DIAGNOSTIC_R6R2L_R7_RESULT=RETURN_ROOT_CAUSE_IDENTIFIED
G4B_BAIDU_PIPELINE_OUTPUT_REPAIR_R6R2L_R8_GATE_BLOB=7e78a3ff585133c52fdc309947ce79e4a0283a17
G4B_BAIDU_PIPELINE_OUTPUT_REPAIR_R6R2L_R8_RUNNER_BLOB=388714218a7a6f1671777488b0c581812f6cc9eb
G4B_BAIDU_PIPELINE_OUTPUT_REPAIR_R6R2L_R8_VALIDATOR_BLOB=eac0f9684b8f98b71c856e4d297da03f867b2d51
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_RUNNER_BLOB=cf7bc19b1accc142065416bc6c6525aa7b58fc23
G4B_PERSISTENT_THREE_ROLE_LIVE_RUN_R6R2L_VALIDATOR_BLOB=5d560481b0367bc0ab783ddd51b4c27285dd5831
G4B_BAIDU_SECURE_AUTH_COMBINED_REPAIR_R6R2H_R2_RESULT=RETURN_OUTPUT_CONTRACT_CONFIG_STATE_MISSING
G4B_BAIDU_OWNER_OUTPUT_REPAIR_R6R2H_R3_GATE_BLOB=721466d2b4becbfb67c921de5b4ce936fa91aafe
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

Owner runs only `G4B_BAIDU_PIPELINE_OUTPUT_REPAIR_R6R2L_R8` offline validation and stops at Reviewer. No live retry is authorized.

## OWNER_ACTION_REQUIRED

Fast-forward to current main, verify the R8 Gate/runner/validator blobs, run only the offline live-runner fixture validator, and return its markers. Do not run the live G4-B runner.

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
