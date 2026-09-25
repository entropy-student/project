# Reviewer Decision — K6 C1R3 RETURN; consolidated pending recovery checkpoint

Date: 2026-09-25 (Asia/Shanghai)  
Gate reviewed: `K6_PHASE_C1R3_PENDING_REUSE_TRANSPORT_SEAL`  
Result: **RETURN accepted — original pending serialization unknown**  
Next Gate: `K6_PHASE_C1R4_PENDING_RECOVERY_LOCAL_SEAL` — **awaiting fresh Owner Secret-handling authorization**

## Evidence and finding

I read the current GitHub `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` C1R3 sections and verified commit `16a0c576d258290a1e8360c915b5eceeeaae593c`. C1R3 found no retained non-secret source that specifies the exact byte serialization of the existing DPAPI pending payload: encoding/BOM, field order, framing, binding, and parser. The original C1 transaction was inline; C1R1/C1R2 retained helpers exercise the ACK path only. C1R3 correctly stopped under its no-decrypt rule. It created no helper, ran no SSH/transport rehearsal, and made no VPS write. The reported 1,686-byte Owner-profile pending artifact remains encrypted and unpromoted; this review did not open, decrypt, hash, copy, move, or delete it.

C1R2's synthetic ACK PASS remains valid for that component only. **No pending-reuse Windows-to-VPS transfer or real installer has passed review.** The C1R3 return is a protocol provenance gap, not evidence of a corrupted pending artifact. No target Secret file is claimed to exist. The C1R3 evidence reports no remote operation; the last independently confirmed target-path absence is C1R2. Fresh read-only target checks are therefore mandatory before any later write.

## Decision and Owner boundary

The previous C1 write delegation is historical. Canonical VPS Governance v0.1.6 Conditional Preauthorization cancels a write preauthorization on RETURN; a production-write retry requires fresh explicit Owner authorization. Reading/decrypting the protected pending payload also handles real Secret values, so C1R4 will not start under this Reviewer decision alone.

To reduce Owner relays, request **one bounded Owner decision** covering:

1. C1R4 local in-memory DPAPI `CurrentUser` decrypt on the recorded Owner Windows account solely to determine and validate the existing ten-value serialization; no value or value hash may be emitted or persisted as plaintext.
2. **Conditional future C1R5 authorization**, effective only after C1R4 receives a formal Reviewer PASS: reuse those same values for exact ten-file installation on the recorded `ops@srv1970241` host under `/srv/data/mini-craft-night-kit/secrets/`, with exclusive creation, no overwrite, restrictive modes, read-only runtime mounts, and final DPAPI recovery promotion after target checks. This is a proposed authorization, **not yet granted**. If C1R4 returns, any prerequisite fails, target state drifts, or the real transfer is ambiguous, that conditional authorization automatically expires and there is no retry.

The C1R5 write is **not** part of C1R4. C1R4 must stop at Reviewer after local and synthetic checks, even if all pass. Reviewer will inspect the exact helper/schema and authorize execution of the already Owner-approved conditional C1R5 only if its conditions are met. The one Owner decision can therefore span both checkpoints without weakening independent review. No deployment, database restore, Compose start, shared infrastructure, payment, PayPal Live, or public route is included.

## Consolidated C1R4 execution package — only after Owner authorization

The external Executor should receive this entire package in one prompt. Reviewer/Planner does not invoke an Executor or handle Secret content.

1. Re-read latest canonical `vps-project-governance` skill and SSH/Delegated Secret Operations, Storage Layout and Target Host Reality addenda, this decision, current Reviewer Handoff and Storage Manifest, C1 RETURN, C1R1/C1R2 PASS, and C1R3 evidence. Preserve the existing Owner-profile `*.pending.dpapi` in place. Verify exact Windows user/profile, DPAPI availability, ciphertext path, 1,686-byte size and protected ACL; verify recorded strict SSH identity/host pin and read-only target namespace. Stop on mismatch. Do not print ciphertext, decrypted bytes, values, value hashes, or excerpts.
2. On the recorded Owner Windows account only, decrypt the pending artifact **in process memory**. Establish the actual encoding, framing, ten-name mapping and host/project binding without writing plaintext files or exposing data through transcripts, arguments, environment, stdout/stderr, chat, ordinary logs or GitHub. Validate exact ten allowlisted basenames, one occurrence each, format and length (two 32-random-byte lowercase-hex passwords and eight 64-random-byte lowercase-hex WordPress keys/salts), nonempty and pairwise unique. Reject ambiguous, extra, missing, malformed or unbound payloads. If the schema cannot be established unambiguously, RETURN before any remote Secret transfer.
3. Build the smallest reviewable production-intended parser/sender helper under the project-owned local Gate artifact directory. First prove its serialization, framing/EOF, strict SSH sender and remote parser with synthetic fixture values only, through the actual Windows PowerShell → pinned SSH path. Exercise accepted and rejected framing/identity/collision cases; confirm target paths absent before/after, no remote temp resource or write. Real pending bytes must not be sent over SSH in C1R4. The helper must fail closed without a separate real-write Gate switch.
4. In the same Gate perform fresh **read-only** capacity, host identity, namespace/container collision, `sudo -n`, and explicit production Compose render/semantic checks needed for a later write. Reuse accepted K5, Phase B R1 and C0 evidence unless material drift requires focused recheck. Do not pull images, create files/directories, start containers, touch real Secret targets, or alter shared services. Record bounded metadata-only evidence: schema description without values, validation PASS/FAIL, helper SHA-256, synthetic test results, target read-back, capacity numbers/assumptions, pending path/size/ACL, and unchanged pending state.
5. Update only redacted `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` in GitHub; return `PASS_CANDIDATE_K6_PHASE_C1R4_PENDING_RECOVERY_LOCAL_SEAL` or a precise `RETURN_*`, with `REMOTE_WRITES=0`, `PENDING_PROMOTED=NO`, `SECRET_VALUES_OR_HASHES_EXPOSED=0`, `STOP_AT_REVIEWER=YES`. On any uncertainty stop; do not self-advance into C1R5.

C1R5, if eventually approved, is bounded by the original exact ten-file C1 allowlist and metadata in `docs/REVIEWER_DECISION_K6_C1_SECRET_PROVISIONING_AUTHORIZED.md`; its runtime and recovery assertions require fresh target evidence. The Owner-profile DPAPI limitation remains: it does not survive simultaneous loss of the VPS and that Windows profile.
