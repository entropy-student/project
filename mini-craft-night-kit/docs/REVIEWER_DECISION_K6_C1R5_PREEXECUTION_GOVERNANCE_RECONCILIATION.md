# Reviewer Decision — K6 C1R5 Pre-execution Governance Reconciliation

Date: 2026-09-25  
Role: Reviewer / Architect / Gatekeeper  
Governance source: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reason

Before any C1R5 execution, the Reviewer re-read the complete canonical Governance package, including:

- core v0.1.6;
- Governance Handoff;
- Governance Source Policy rev1;
- Storage Layout Contract rev1;
- SSH / Delegated Secret Operations rev2;
- Target Host Reality Contract rev2;
- Production Provider Canary and Recovery Contract rev2;
- Usage Scenarios;
- all handoff/evidence/storage templates.

No C1R5 host execution has occurred yet.

The prior C1R5 decision and execution pack contained one sequencing defect: they described target Secret installation before creation/verification of the new DPAPI pending recovery artifact. Canonical Governance requires delegated Secret provisioning to establish and verify encrypted off-host recovery before the consequential remote write, then promote the pending artifact only after remote verification succeeds.

This decision corrects sequencing only. It does not expand the Owner-authorized Secret scope.

## Owner authorization remains valid

The Owner already explicitly authorized the fresh-regeneration path for:

- project `mini-craft-night-kit`;
- the verified Hostinger target;
- exactly the ten allowlisted Secret files;
- fail-on-existing/no-overwrite behavior;
- fresh Secret generation;
- DPAPI CurrentUser encrypted recovery;
- no deployment/service start/Provider Live/real payment.

The sequencing correction below is a stricter technical safety implementation of that same bounded authorization. No new Owner decision is required.

## Current authority

```text
GATE=K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
PREEXECUTION_GOVERNANCE_RECONCILIATION=PASS
OWNER_AUTHORIZATION=VALID_UNCHANGED_SCOPE
C1R5_HOST_EXECUTION_STARTED=NO
```

This decision supersedes only conflicting **sequencing** text in the earlier C1R5 decision/package. All exact target, allowlist, formats, modes, forbidden scope and STOP conditions remain unchanged.

## Mandatory Shared VPS source

Before SSH use, Codex/Executor must read the unique current Shared VPS Handoff (`SHARED_VPS_HANDOFF_CURRENT.md` in the established Owner/shared-infrastructure source) and validate its non-secret connection/trust metadata:

- target `ops@2.24.193.133:22`;
- target hostname `srv1970241`;
- recorded identity-file reference/public fingerprint;
- normal `known_hosts` reference and pinned host-key fingerprint(s);
- passwordless sudo / Docker privilege model;
- shared Caddy/network/80/443 boundaries.

The project repository does not contain a competing Shared VPS Handoff. If the Executor cannot access/read the unique current Shared VPS Handoff or cannot validate the recorded connection metadata, it must fail closed before any write with the appropriate `RETURN_SSH_CONNECTION_REQUIRED` / `RETURN_SSH_TRUST_DRIFT`.

## Corrected two-phase C1R5 sequence

### Phase A — synthetic serializer/parser/DPAPI seal — no real Secret

1. Prove the real Owner Windows host/profile execution boundary.
2. Read the canonical Shared VPS Handoff and prove the strict SSH identity/trust boundary read-only.
3. Define one retained canonical payload serializer/parser:
   - UTF-8 encoding;
   - explicit BOM policy;
   - explicit LF/CRLF policy;
   - project/host bindings;
   - exact ten field names/order;
   - framing/EOF contract;
   - exact cardinality;
   - reject missing/duplicate/extra/malformed/trailing content.
4. Use only synthetic fixture values.
5. Exercise serializer → DPAPI CurrentUser pending → in-memory unprotect → exact parser validation on the real Owner Windows profile.
6. Run accepted/rejected test matrix.
7. Record helper source/hash and redacted results only.
8. Any ambiguity/failure stops and automatically cancels Phase B.

### Phase B — fresh real Secret transaction

Only after Phase A PASS:

1. Run fresh strict read-only prewrite target check and production Compose render using non-secret placeholders.
2. Confirm all exact target paths are absent and there is no project/container/network collision.
3. Generate the exact ten fresh values inside the protected target-side transaction/process with the approved target OS CSPRNG and formats.
4. Before any target Secret file is installed, stream the canonical payload through the reviewed in-memory/stdin path to the proven Owner Windows process and create a **new C1R5 `*.pending.dpapi`** artifact.
5. Immediately unprotect that new pending artifact in memory on the same Owner profile and require exact normalized-byte + parser/binding/cardinality/format validation. No plaintext persistence, output or hash.
6. Only if the new pending recovery round-trip/parser validation is PASS may the remote transaction atomically/exclusively create the exact ten allowlisted Secret files and their exact owner/group/mode.
7. Read back metadata only and prove intended runtime access plus DB-root exclusion and unrelated-service non-access.
8. If all remote/access checks pass, atomically promote the **new C1R5 pending** artifact to the new final recovery artifact and perform Owner-host `Test-Path/Get-Item/ACL` read-back.
9. The historical old C1 pending artifact remains encrypted, unmodified, unpromoted and undeleted throughout.

## Failure / rollback rules

- If failure occurs before new C1R5 pending creation: no target Secret write is allowed.
- If the new C1R5 pending exists/round-trips but remote write fails or is ambiguous: do **not** promote it; retain it encrypted and classify remote state with strict read-only read-back before any retry.
- If remote write commits but application/access verification fails: do not rerun blindly; retain pending, read back exact target state, RETURN Reviewer.
- Unexpected existing Secret/path/content means fail closed; no overwrite, delete, hash or value read.
- No automatic deletion of either old or new protected pending artifacts on an uncertain result.
- Any retry after RETURN/ambiguity requires Reviewer reconciliation and, where the prior conditional write authority has expired, fresh Owner authorization per Governance.

## Forbidden scope unchanged

No:
- old pending reuse/decrypt/modify/delete/promotion;
- extra Secret;
- overwrite/rotation;
- Mini Craft service/container start;
- DB/wp-content restore;
- `/srv/apps` or `/srv/backups` creation in this Gate;
- Shared Infra mutation;
- DNS/public route;
- PayPal Live, real payment, refund or launch.

## Executor result

Success candidate remains:

```text
PASS_CANDIDATE_K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
PHASE_A_CANONICAL_SERIALIZATION_SEAL=PASS
NEW_C1R5_PENDING_PREWRITE_ROUNDTRIP=PASS
PHASE_B_EXACT_TEN_FILE_PROVISIONING=PASS
RUNTIME_ACCESS_AND_EXCLUSION=PASS
NEW_RECOVERY_FINAL_VERIFIED=PASS
OLD_PENDING_UNCHANGED=PASS
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```

No C1R5 candidate authorizes deployment/start. Reviewer independently reviews Evidence before opening any subsequent K6 Gate.
