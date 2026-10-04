# G4-B Offline Live-Runner Repair Gate R2

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_OFFLINE_LIVE_RUNNER_REPAIR_R2`

## PREVIOUS_RESULT

`RETURN_G4B_OFFLINE_RUNNER_IMPLEMENTATION_R1_REVIEW_DEFECTS`

## OBJECTIVE

Repair the reviewed live-runner defects found after
`PASS_CANDIDATE_G4B_OFFLINE_RUNNER_IMPLEMENTATION_R1`.

This round is source/fixture work only. No live G4-B action is authorized.

## REVIEWER-ACCEPTED R1 FACTS

The following R1 facts are accepted and must not be replayed unnecessarily:

```text
R1_COMMIT=b97266e7cc9e3c3224032f7e49e9bf6d3b61c7d0
RUNNER_BLOB=bd791c02310031c6e80b2c1986c73dc9475b553d
FIXTURE_VALIDATOR_BLOB=b830cd1635c6752095dc21718dbbd28165448f6c
PACKAGE_VALIDATOR_BLOB=a4c5b3bd7875b16eb56cafc1f45ac3035f9a3b69
R1_AST=PASS
R1_PACKAGE_VALIDATOR=PASS
R1_POSITIVE_ASSERTIONS=21
R1_NEGATIVE_FIXTURES=10_OF_10_PASS
R1_SECRET_SCAN=PASS
R1_LIVE_ACTIONS=0
```

The R1 timing record remains partial: the 00:52:48 implementation window is accepted as
a partial measurement only; total R1 duration remains UNKNOWN.

## REVIEWER RETURN FINDINGS

### R2-1 — Recovery is not yet valid disaster recovery

Current source writes the second copy using the same
`ProtectedDataScope.CurrentUser` DPAPI ciphertext as the local first copy.

This violates the active Governance rule that a profile-bound DPAPI/CurrentUser copy may be
the first low-operation recovery copy but **must never be the sole disaster-recovery mechanism**.

Current source also mutates the remote target and generates the live REALITY credentials before
the pending recovery set has been created/round-trip verified.

Required repair:

1. Keep the local Owner-bound DPAPI copy only as the first recovery copy.
2. Implement a second portable, machine-independent authenticated encrypted artifact.
3. The portable artifact must use:
   - Owner-entered passphrase inside the protected live boundary;
   - no passphrase in command arguments, environment variables, stdout/stderr, files, repo, logs, or Handoff/Evidence;
   - PBKDF2-HMAC-SHA256 with random salt >=16 bytes and >=600000 iterations;
   - AES-256-GCM with random 12-byte nonce and 16-byte tag;
   - versioned format marker and exact parser.
4. Live source must perform immediate in-memory encrypt/decrypt/parser round-trip without printing
   plaintext or plaintext/value hashes.
5. REALITY credentials must be prepared before persistent remote mutation. Prefer the accepted
   Owner-local Mihomo binary for REALITY keypair generation plus local CSPRNG UUID/short-id generation;
   do not create persistent VPS objects merely to obtain credentials.
6. Create both recovery artifacts as `pending` before persistent remote mutation.
7. Promote pending recovery artifacts to final only after the remote service/profile/restart/final
   read-backs have succeeded.
8. On failure, remove pending artifacts only after bounded remote rollback is verified; otherwise
   retain them and emit a non-secret reconciliation marker.
9. Add synthetic portable-recovery restore/parser fixtures. Do not use a real passphrase or real Secret.

### R2-2 — REALITY runtime filesystem permissions/layout are incomplete

Current remote `configure()` creates `RUNTIME` as root-owned mode 0750 and never changes its
owner/group. The service later runs as the dedicated non-root REALITY account, so the accepted
runtime identity is not proven able to traverse/write the `-d` runtime directory.

The source also writes
`/srv/apps/vpn-network-optimization/secrets/reality-server.yaml`
without creating or positively validating the parent `secrets` directory.

Required repair:

- create/validate every project-owned parent needed by binary/runtime/Secret paths;
- the runtime directory must be owned by the dedicated runtime user/group with restrictive mode
  compatible with Mihomo runtime writes;
- the Secret directory/config must be root-owned or equivalent least-privilege, with the runtime
  group granted only the read/traverse rights required;
- positively prove the runtime account can read its config and traverse/write its runtime dir;
- prove a generic unrelated principal (for example `nobody`) cannot read the Secret config;
- track which parent directories were created by this Gate and remove only those created by the Gate
  and only when safe/empty during rollback;
- do not weaken the accepted `CAP_NET_BIND_SERVICE`-only service capability contract.

### R2-3 — Owner-side restart persistence is not actually read back

R1 restarts `clash_verge_service` and checks only the local network baseline afterwards.
It does not prove that `SELF-VPN-V1` still exists after restart, remains visible, and still has
HY2 -> WG -> REALITY order, HY2 default, manual select, and no auto selector.

Required repair:

- after the reviewed Clash restart/reload boundary, re-read the imported persistent profile;
- inside the protected boundary, validate its three-role semantics again without printing Secret values;
- verify no pre-existing profile-store entry changed;
- require the imported profile to remain present after restart;
- add a negative fixture that removes/bypasses this post-restart profile read-back and must fail.

### R2-4 — Rollback ownership is discarded before Reviewer accepts PASS_CANDIDATE

R1 calls remote `complete` during the success path, which removes the transaction state before
the mandatory Reviewer stop. Local created-profile path ownership also exists only in process memory.

If the live runner later returns PASS_CANDIDATE but Reviewer returns the Gate, the exact bounded
rollback capability has already been weakened.

Required repair:

- PASS_CANDIDATE must retain a non-secret ownership/rollback journal until Reviewer formal decision;
- do not delete remote ownership transaction state in the PASS_CANDIDATE path;
- persist the minimum Owner-local non-secret rollback metadata needed to identify created profile and
  recovery paths without storing Secret values/hashes;
- expose a non-secret run identifier;
- add a bounded rollback/closeout entry path that can consume the retained ownership journal after
  Reviewer decision;
- closeout may delete the journal only after formal Reviewer PASS; rollback may remove only objects
  whose ownership markers/state match the exact run;
- add a negative fixture proving the PASS_CANDIDATE path cannot silently destroy rollback state.

### R2-5 — Live Evidence markers are too thin

R1 outputs phases and final PASS_CANDIDATE but does not emit enough sanitized positive markers to make
all G4-B acceptance facts directly reviewable from the live execution.

Add non-secret success markers for at least:

```text
G4B_RECOVERY_PENDING_VERIFIED=YES
G4B_RECOVERY_FINAL_PROMOTED=YES
G4B_REALITY_RUNTIME_ACCESS=PASS
G4B_REALITY_SERVICE_READY=YES
G4B_PUBLIC_TCP443_READY=YES
G4B_THREE_ROLE_PROFILE_IMPORTED=YES
G4B_THREE_ROLE_PROFILE_RESTART_PERSISTENCE=PASS
G4B_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2
G4B_AUTO_SWITCHING=OFF
G4B_WIREGUARD_PRESERVED=YES
G4B_HY2_PRESERVED=YES
G4B_SYSTEM_PROXY_FINAL=OFF
G4B_TUN_FINAL=OFF
G4B_ROLLBACK_JOURNAL_RETAINED=YES
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Do not emit Secret values, Secret-derived hashes, credential identifiers, or raw profile/config content.

## ALLOWED EXECUTOR FILES

Executor may modify only:

- `scripts/g4b-persistent-three-role-live-runner.ps1`
- `scripts/g4b-live-runner-fixture-validator.ps1`
- `docs/G4B_PERSISTENT_IMPLEMENTATION_PACKAGE.md`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

The following remain frozen:

- `REVIEWER_HANDOFF.md`
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md`
- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md`
- all three accepted G4-B templates
- accepted G4-B0 source/evidence
- `scripts/g4b-three-role-package-validator.ps1` unless this repair proves that the package validator
  itself must change; if so RETURN to Reviewer rather than changing it.

## REQUIRED OFFLINE VALIDATION

In addition to all accepted R1 regressions, R2 must add deterministic offline checks for:

1. portable recovery is not DPAPI/CurrentUser;
2. portable recovery format parser + synthetic round-trip;
3. pending-before-persistent-mutation ordering;
4. final recovery promotion occurs only after final success read-back;
5. runtime dir owner/group/mode contract;
6. Secret parent creation/ownership/access contract;
7. intended runtime account positive access and unrelated-principal negative access source contract;
8. post-Clash-restart profile persistence + role semantics;
9. PASS_CANDIDATE retains rollback journal;
10. rollback/closeout paths require exact run ownership;
11. PASS_CANDIDATE cannot invoke transaction cleanup/closeout;
12. all R1 phase/order/no-route/no-firewall/no-G4C/Secret-output protections remain PASS.

Negative fixtures must cover the new invariants.

## ABSOLUTE PROHIBITIONS THIS ROUND

```text
LIVE_RUNNER_EXECUTION=NO
SSH_OR_VPS_ACTION=NO
REAL_SECRET_ACCESS=NO
DPAPI_REAL_SECRET_ACCESS=NO
EXTERNAL_TEST_REQUESTS=0
NETWORK_MUTATION=NO
CLASH_PROFILE_MUTATION=NO
SYSTEM_PROXY_CHANGE=NO
TUN_CHANGE=NO
SERVICE_MUTATION=NO
ROUTE_MUTATION=NO
REALITY_LIVE_DEPLOYMENT=NO
G4C_EXECUTION=NO
```

## TIMING

Capture `ROUND_STARTED_AT` before the first preflight/sync command and `ROUND_FINISHED_AT` after
fresh GitHub read-back. If either is missed, report UNKNOWN; do not fabricate.

## ACCEPTANCE CRITERIA

Executor may return PASS_CANDIDATE only when every R2 finding above is repaired and all old/new
fixtures pass.

```text
R2_RECOVERY_PORTABILITY=PASS
R2_RECOVERY_ORDERING=PASS
R2_RUNTIME_FILESYSTEM_CONTRACT=PASS
R2_PROFILE_RESTART_PERSISTENCE=PASS
R2_ROLLBACK_JOURNAL_RETENTION=PASS
R2_SANITIZED_LIVE_EVIDENCE_MARKERS=PASS
R1_REGRESSIONS=PASS
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```

Any need to change a frozen Gate/template or any uncertainty is RETURN to Reviewer.
