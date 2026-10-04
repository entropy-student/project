# VPN Network Optimization — Reviewer Transition Snapshot

> Prepared for Reviewer handoff on 2026-10-04.
>
> Canonical branch: `main`.
>
> This file is a compact transition snapshot. The canonical current dashboard remains `../REVIEWER_HANDOFF.md`; detailed proof remains append-only in `../EXECUTION_EVIDENCE.md`. Always fresh-read `main` before consequential work.

## 1. Read order for the next Reviewer

1. `REVIEWER_HANDOFF.md` — canonical current state, current Gate, authority boundary, next Owner action.
2. This transition snapshot — accepted chronology and why the current Gate exists.
3. `DECISION_LOG.md` — durable rationale for accepted architecture and scope decisions.
4. `docs/G3C_C2C_REAL_HY2_CANARY_PACKAGE.md` — current real HY2-in-Clash canary contract.
5. `EXECUTION_EVIDENCE.md` — only the exact accepted sections needed to verify a claim; do not replay the full history by default.
6. `EXECUTOR_HANDOFF.md` — historical Executor facts only; it is not canonical current state.
7. Governance authority: `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.6 / ACTIVE_PROVISIONAL.

## 2. Current objective and accepted architecture

Project goal: build a portable, verifiable, rollbackable self-hosted VPN optimization stack for Codex / OpenAI / AI image-generation workloads, optimizing stability and tail latency rather than headline speed.

Accepted roles:

- **WireGuard** — current production and rollback baseline.
- **Hysteria2** — validated performance candidate; current G3-C work is proving real use through Clash Verge/Mihomo.
- **VLESS + REALITY + Vision** — validated TCP/443 compatibility candidate, not the current active G3-C target.
- **Clash Verge / Mihomo** — manual control plane; persistent automatic switching is not authorized.

Current infrastructure:

- DigitalOcean public host: `24.199.118.137`, actual region `sfo3`.
- Hysteria2 server: official v2.12.3, UDP/8443.
- WireGuard active MTU: 1420.
- Windows Owner host; Clash Verge 2.5.6.
- Current C2C Owner-side Mihomo validation baseline: v1.19.32.
- Historical G2-C REALITY interoperability baseline used Mihomo v1.19.31.
- WireGuard IPv4 coverage uses `0.0.0.0/1` + `128.0.0.0/1`.
- Production WireGuard must remain available as rollback during the next canary.

## 3. Secret and recovery boundaries

No Secret value, private key, auth token, plaintext credential, or credential hash is allowed in GitHub, chat, ordinary logs, or handoff documents.

Accepted Owner recovery metadata:

- DPAPI scope: CurrentUser.
- Recovery artifact path: `%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi`.
- Format: accepted `VPNHY2R1` bundle.
- R2R3V2 proved real Owner-host DPAPI unprotect, bundle parse, auth-format validation, certificate fingerprint match, temporary Owner-only profile generation, Mihomo parse, immediate cleanup, and zero residue.
- Do not re-fetch or rotate the credential merely to continue C2C.

## 4. G3-C chronology that matters

### C1 / C2A / C2B

- Manual-control contract: PASS.
- Synthetic package and repair chain: PASS.
- Synthetic Clash UI canary C2B: PASS.
- C2B proved profile lifecycle, UI visibility/manual selection semantics, cleanup, and no production-state drift; it did not prove real HY2 authentication/connectivity.

### C2C package

The real canary was split deliberately:

- `scripts/c2c-secret-profile-helper.ps1` — local Secret handling only; no network requests.
- `scripts/c2c-bounded-proxy-probe.ps1` — exactly two bounded external requests; no Secret access.
- `scripts/c2c-owner-clash-real-canary.ps1` — orchestration, temporary route, UI acknowledgements, rollback/readback; no DPAPI handling.
- `scripts/g3c-c2c-package-validator.ps1` — offline package/fixture validation.
- `templates/clash/c2c-real-hy2-canary.yaml.template` — WG baseline + real HY2 + manual selector.
- `docs/G3C_C2C_REAL_HY2_CANARY_PACKAGE.md` — accepted package boundary.

### Listener/proxy repair

- R1 wrapper failed before real execution because a clean Git status became `$null` under StrictMode and `.Count` faulted; wrapper was repaired.
- R1R1 reached preflight and returned `CLASH_LOCAL_PROXY_LISTENER_MISSING`.
- D4 proved Windows system proxy was OFF and registry port 10810 was stale; live Clash/Mihomo listeners differed.
- D5 loopback protocol probes proved exactly one SOCKS5 no-auth listener, then at port 7900. The implementation must **discover it dynamically**; port 7900 is evidence, not a hardcoded contract.
- The bounded proxy probe was changed to `socks5h://127.0.0.1:<discovered-port>`.

### Runner/helper evidence repair

- R2R1 fixed a resolver success-stream contamination bug.
- R2R2 fixed sanitized Secret-helper evidence forwarding.
- R3R1 then passed network preflight but returned at `SECRET_PROFILE_PREPARE`; because the caller hid the child failure code, no auth/DPAPI conclusion was inferred.

### Secret Prepare diagnostics

- D6 pre-secret prerequisites: PASS; recovery path/ACL/runtime/template/Mihomo/.NET prerequisites were present, with no DPAPI/content read.
- D7 sanitized replay surfaced the exact helper failure: `SECRET_SCAN_READ_FAILED`; zero residue and zero network mutation.
- D8 localized it to one Clash-app root-level `.lock` read failure; project runtime was empty/readable.
- D8R1 proved exactly one root-level `.lock`, non-reparse, zero-byte, but it had become readable. Therefore the defect was transient lock contention, not a permanently unreadable file.

### R2R3 scanner repair

Accepted policy:

- Do **not** generically skip `.lock` files.
- Do **not** generically skip unreadable files.
- Only after a real read exception in the Clash-app scan may one item be bypassed when fresh metadata proves all of:
  - direct child of the Clash app root;
  - extension exactly `.lock` case-insensitively;
  - length exactly 0;
  - normal file;
  - not a reparse point.
- Project-runtime scanning receives no exception and remains fail-closed.
- All other unreadable-file cases remain `SECRET_SCAN_READ_FAILED`.

Owner validation eventually passed all Fixtures A-L, PowerShell AST parse, and Mihomo fixture parse. The intermediate R2R3V1 / V1R1 / V1R2 RETURNs were validator/evidence-tool defects only:
- two PowerShell literal-interpolation defects in Fixture L;
- one documentation-regex phrase-order defect.

These were repaired without changing the accepted scanner safety boundary.

### R2R3V2 real-host verification

Formal PASS.

Accepted Owner evidence:

- `DPAPI_UNPROTECT=PASS`
- `REAL_HY2_AUTH_FORMAT=PASS`
- `CERTIFICATE_FINGERPRINT_MATCH=PASS`
- `CLASH_REAL_AUTH_PREEXISTING=NO`
- `OWNER_ONLY_REAL_PROFILE=PASS`
- `MIHOMO_REAL_PROFILE_PARSE=PASS`
- `C2C_SECRET_PREPARE=PASS`
- immediate cleanup PASS
- Clash real-auth residue ABSENT
- project-runtime real-auth residue ABSENT
- post-cleanup C2C directory count 0
- post-cleanup C2C profile count 0
- Clash import NO
- temp outer route NO
- external network requests 0
- system proxy / TUN / WireGuard mutation NO
- Secret values emitted 0

This closes the historical Secret Prepare blocker.

## 5. Locked C2C candidate identities

These are the accepted source identities at the current R3R2 authorization boundary:

```text
ORCHESTRATOR_BLOB=4424eab2f281af6398f6d7bfbe6e326bce5f7904
SECRET_HELPER_BLOB=81c5a43d4a947d57e44752fd7a09c59e735748e2
PROXY_PROBE_BLOB=d3403cba9196b55083ff9f443e9011582ef9cc01
VALIDATOR_BLOB=e520fa7b6c08b2e46365b55ec731a20bdb810c04
TEMPLATE_BLOB=ea18bdccf8f00f2d6d705e4ba34ba57db243722a
PACKAGE_BLOB=d9e815171d8d7b00722b213b6df6d52c46f6265e
```

Do not silently substitute older C2C blobs from historical Evidence or Executor handoff sections.

## 6. Current Gate at conversation handoff

```text
GATE_ID=G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R3R2
STATE=OWNER_AUTHORIZATION_REQUIRED
PREVIOUS_RESULT=PASS_G3C_C2C_SECRET_PREPARE_REPAIR_VERIFICATION_R2R3V2
OWNER_C2C_AUTHORIZATION=REQUIRED_FRESH
```

Fresh authorization is required because the earlier real canary attempt did not complete and consequential authorization is not reused after a failed/ambiguous attempt.

The Owner has **not yet granted the fresh R3R2 authorization** at the time of this transition snapshot.

The next Reviewer must not run or ask the Owner to run R3R2 until the Owner explicitly authorizes one bounded real canary.

## 7. R3R2 authorized scope if the Owner approves

Exactly one bounded real canary:

1. Safe ff-only sync and exact source lock.
2. Preflight: WireGuard connected; system proxy OFF; TUN OFF; no temp route; live SOCKS5 listener dynamically discovered; profile-store baseline captured.
3. One Secret Prepare using the accepted helper.
4. Owner imports/activates only the generated unique C2C profile while `WG-BASELINE` remains selected.
5. Create one temporary **ActiveStore-only** IPv4 `/32` route to the HY2 server through dynamically resolved physical egress.
6. Owner selects `HY2-SFO3-REAL`.
7. Send exactly two requests through the proven local SOCKS5 listener:
   - OpenAI `/v1/models`: curl exit 0, HTTP 401, proxy used.
   - public-exit check: accepted SFO3 exit.
8. Owner switches back to `WG-BASELINE` and removes only the C2C profile.
9. Verify Secret cleanup, profile-store restoration, route absence, WireGuard restoration/unchanged state, system proxy OFF, TUN OFF, Secret output 0.
10. STOP_AT_REVIEWER.

Not authorized by R3R2:

- performance benchmark or loops;
- persistent default change;
- persistent route;
- system proxy/TUN enablement;
- WireGuard default-role removal;
- REALITY activation;
- VPS/SSH changes;
- G4;
- automatic switching.

## 8. Rollback and failure handling

- WireGuard remains the production/rollback path throughout.
- The runner removes the temporary route in `finally`.
- The runner invokes fallback Secret cleanup when a temporary profile was created but normal cleanup did not finish.
- If a profile was imported and a later step fails, Owner UI cleanup may still be required; classify before retry.
- Any consequential failure/ambiguity must be reconciled before another real canary. Do not blindly replay the two-request action.

## 9. Confirmed documents on main

Canonical/current:

- `REVIEWER_HANDOFF.md` — current Reviewer dashboard.
- `EXECUTION_EVIDENCE.md` — append-only detailed evidence.
- `DECISION_LOG.md` — durable decisions.
- `README.md` — project overview and reading entry point.
- `EXECUTOR_HANDOFF.md` — Executor history only, explicitly non-canonical.

Accepted package/control documents:

- `docs/G3C_C2C_REAL_HY2_CANARY_PACKAGE.md`
- `docs/G3C_C2B_OWNER_CANARY_PACKAGE.md`
- `docs/G3C_MANUAL_CONTROL_CONTRACT.md`
- `docs/G3B_MIGRATION_PACKAGE.md`
- `docs/G3B_STAGED_INSTALL_MANIFEST.md`
- `docs/ROUND_TIMING_RETROSPECTIVE.md` — timing/process evidence only, not project truth.

The repository and these files are already on `main`; no branch-only accepted document is required for the next Reviewer to reconstruct the current state.

## 10. Practical Owner-local facts

Accepted Owner runtime for current consequential Windows checkpoints:

- PowerShell 7.6.6
- Administrator
- High integrity

Known local project entry used successfully in prior checkpoints:

`C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\c2c-owner-clash-real-canary.ps1`

This path is an Owner-host convenience pointer, not canonical source authority. The next Reviewer must still safe-sync to GitHub `main` and lock blobs before consequential execution.

## 11. What the next Reviewer should not redo

Do not repeat without new evidence:

- D4/D5 listener diagnostics;
- D6/D7/D8/D8R1 Secret Prepare diagnostics;
- R2R3 scanner design;
- R2R3 offline Fixtures A-L validation;
- R2R3V2 real-host sanitized Prepare verification;
- HY2 credential recovery or rotation;
- REALITY compatibility experiments;
- G2-B WG vs HY2 60+60 comparison.

The unresolved work is the fresh authorization and execution of R3R2, followed later by G4 representative peak-hour/real-workload validation and MVP v1 sealing.
