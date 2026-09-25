# Reviewer Decision — K6 C1R5 RETURN; C1R5R1 Post-write Evidence Reconciliation

Date: 2026-09-25  
Role: Reviewer / Architect / Gatekeeper  
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed candidate

```text
GATE=K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
EXECUTOR_RESULT=PASS_CANDIDATE_K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING
EXECUTOR_FINAL_COMMIT=15b4d5311f6138a7b276a7c91440863da02807e3
```

Reviewer independently read:

- the current C1R5 Revision 2 execution pack;
- the C1R5 pre-execution governance reconciliation;
- C1R5 `EXECUTION_EVIDENCE.md`;
- C1R5 `EXECUTOR_HANDOFF.md`;
- execution/evidence/handoff cleanup commits through the reported final commit.

## Accepted factual evidence

The following candidate facts are currently supported and are retained as evidence, not yet as formal C1R5 PASS:

- Phase A reports 15/15 synthetic schema/parser cases PASS.
- DPAPI CurrentUser synthetic rehearsal reports PASS.
- strict pinned SSH target identity reports `ops@srv1970241`.
- a new encrypted C1R5 pending artifact was reportedly persisted/read back/round-tripped before the target Secret-file write.
- exact target inventory reports 10 authorized Secret files.
- target metadata reports nine `root:33 0440`, one `root:root 0400`, parent Secret directory `root:root 0700`.
- post-write read-only target check reports zero Mini Craft containers/project networks and no service start.
- new recovery artifact reports final promotion, 1,686 bytes and Owner-only ACL.
- old historical C1 pending reports no access/modification.
- no Secret value/hash, payment, Live action or Shared Infra write is reported.

No evidence presently requires rollback, deletion, rotation, service start or another Secret write.

## Reviewer RETURN findings

### R1 — executed helper source was not retained

Revision 2 required a **retained non-secret helper source** implementing the canonical serializer/parser and real transaction path, with path + SHA available for Reviewer inspection.

Candidate Evidence records only:

```text
HELPER_SHA256=808760C349D83492AF54E6EFC2E76E32231C30D74DD88F2705656C6C0724F083
```

and later explicitly records that the one-time local source was removed after evidence publication.

A hash without the corresponding source bytes does not allow Reviewer to independently verify the exact executed implementation. This is a direct mismatch with the Gate's retained/reviewable-source requirement.

### R2 — runtime access / unrelated-service exclusion evidence is incomplete

Candidate Evidence states runtime access/exclusion was inferred from the sealed Compose mapping plus target ownership/modes and that no service was started.

That supports part of the invariant, but the Revision 2 Gate required explicit proof that:

- WordPress' intended effective reader can read its nine files;
- DB-root is excluded from WordPress;
- MariaDB's intended reader can read its required files;
- unrelated services are not given/mounted the Mini Craft Secret paths.

This must be completed with bounded **no-value, read-only metadata/access checks**. No service start is required or authorized.

### R3 — new final recovery artifact identity/read-back is not complete enough

Evidence records the protected recovery directory, final size and ACL, but does not record the exact metadata-only final artifact path/basename required for durable recovery continuity.

The remediation may record only the exact path/basename, existence, size, ACL/inheritance and timestamps as needed. No ciphertext hash, decrypt or plaintext access is needed.

### R4 — Shared VPS Handoff source-read marker is missing

Revision 2 required reading the unique current Shared VPS Handoff before SSH use. The connection metadata used is consistent with that contract, but the C1R5 evidence does not explicitly record the source-read marker.

This is an evidence gap, not current proof of SSH/trust drift.

## Formal decision

```text
K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING=RETURN_REVIEWER_EVIDENCE_CHAIN_INCOMPLETE
CURRENT_GATE=K6_PHASE_C1R5R1_POSTWRITE_EVIDENCE_RECONCILIATION
CURRENT_GATE_CLASS=READ_ONLY_PLUS_NONSECRET_ARTIFACT_RECOVERY
OWNER_ACTION=NONE
SECRET_WRITE_AUTHORITY=NONE
DEPLOYMENT_AUTHORITY=NONE
```

C1R5 is **not** formally PASS yet. Existing target Secret files and both protected recovery artifacts must remain untouched.

## C1R5R1 objective

Repair the reviewability/evidence chain without changing Secret values or deployment state.

### Allowed

1. Read canonical Governance, unique current Shared VPS Handoff, current project Reviewer decision/Handoff, Revision 2 pack and current evidence.
2. Attempt to recover the **exact executed non-secret helper source bytes** from safe local non-secret sources/caches/backups/history, without accessing any Secret value or protected recovery plaintext.
3. If recovered, require SHA-256 exactly:
   `808760C349D83492AF54E6EFC2E76E32231C30D74DD88F2705656C6C0724F083`.
4. Retain that exact helper as a durable non-secret Gate artifact for Reviewer inspection.
5. Static-review the helper against Revision 2:
   - canonical schema/parser;
   - target-side CSPRNG;
   - no Secret argv/env/stdout/stderr/log/temp persistence;
   - new pending recovery before target Secret write;
   - exact ten-file allowlist;
   - exclusive/fail-on-existing creation;
   - exact modes;
   - final recovery promotion only after remote checks;
   - old pending not accessed.
6. Run strict SSH **read-only** metadata checks:
   - target identity/trust;
   - exact ten target basenames;
   - owner/group/mode;
   - no Mini Craft containers/services/project networks;
   - no Shared Infra mutation;
   - bounded no-value runtime-reader permission checks;
   - read-only Docker mount metadata sufficient to prove unrelated running services do not mount the Mini Craft Secret directory/files.
7. Run Owner-Windows **metadata-only** checks:
   - exact new final recovery path/basename;
   - existence, size, ACL/inheritance;
   - historical old pending existence/size/ACL metadata only;
   - no decrypt/hash/content access.
8. Append redacted evidence and Executor Handoff.

### Forbidden

- Secret regeneration;
- Secret file content read, decrypt, print, hash or transfer;
- any overwrite/chmod/chown/delete/rename of the ten target Secret files;
- decrypt/read/promote/delete/modify either recovery artifact;
- service/container start;
- DB/wp-content restore;
- Shared Infra mutation;
- DNS/public route;
- payment/PayPal Live/refund;
- deployment;
- broad cleanup/prune.

## Result contract

If the exact executed helper is recovered and all evidence gaps close:

```text
PASS_CANDIDATE_K6_PHASE_C1R5R1_POSTWRITE_EVIDENCE_RECONCILIATION
EXECUTED_HELPER_SOURCE_RECOVERED=PASS
EXECUTED_HELPER_SHA_MATCH=PASS
STATIC_HELPER_REVIEW=PASS
TARGET_SECRET_METADATA_READBACK=PASS
RUNTIME_ACCESS_AND_UNRELATED_MOUNT_EXCLUSION=PASS
NEW_FINAL_RECOVERY_METADATA_READBACK=PASS
OLD_PENDING_METADATA_UNCHANGED=PASS
SHARED_VPS_HANDOFF_SOURCE_READ=YES
SECRET_VALUE_OR_HASH_ACCESS=0
STOP_AT_REVIEWER=YES
```

If the exact helper bytes cannot be recovered:

```text
RETURN_C1R5R1_EXECUTED_HELPER_SOURCE_UNRECOVERABLE
STOP_AT_REVIEWER=YES
```

Do not substitute a reconstructed/lookalike helper and call it the executed source. A separately reconstructed reference helper may be supplied as supplementary evidence only.

No Owner action is requested in C1R5R1.
