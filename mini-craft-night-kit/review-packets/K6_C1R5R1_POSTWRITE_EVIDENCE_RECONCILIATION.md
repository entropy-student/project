# K6 C1R5R1 — Post-write Evidence Reconciliation Execution Pack

Gate:
`K6_PHASE_C1R5R1_POSTWRITE_EVIDENCE_RECONCILIATION`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- `docs/REVIEWER_DECISION_K6_C1R5_RETURN_C1R5R1_EVIDENCE_RECONCILIATION.md`;
- C1R5 Revision 2 execution pack;
- current project Reviewer Handoff;
- latest C1R5 Evidence/Executor Handoff;
- unique current Shared VPS Handoff.

## Objective

Close C1R5 reviewability/evidence gaps **without modifying any Secret value, recovery payload, deployment state, service state or Shared Infrastructure**.

## Required work

1. Read all authority sources completely.
2. Recover the exact executed C1R5 non-secret helper source if safely available from local non-secret sources.
3. Require exact SHA-256:
   `808760C349D83492AF54E6EFC2E76E32231C30D74DD88F2705656C6C0724F083`.
4. Retain the exact helper as a durable non-secret review artifact.
5. Static-review that exact helper against the C1R5 Revision 2 transaction contract.
6. Perform strict read-only VPS metadata/access/mount checks:
   - target identity/trust;
   - exact 10 basenames;
   - owner/group/mode;
   - no service/container/project-network start;
   - intended reader access using no-value checks;
   - DB-root exclusion from WordPress;
   - unrelated running-service mount exclusion;
   - Shared Infra unchanged.
7. Perform Owner-Windows metadata-only recovery checks:
   - exact new final recovery path/basename;
   - existence, size, ACL/inheritance;
   - old historical pending existence/size/ACL only.
8. Record explicit `SHARED_VPS_HANDOFF_SOURCE_READ=YES`.
9. Append redacted `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`.
10. Stop at Reviewer.

## Hard prohibitions

Do not:
- read/decrypt/hash/print/transfer any Secret value or recovery plaintext;
- regenerate or overwrite Secrets;
- chmod/chown/delete/rename target Secret files;
- decrypt/modify/delete/promote recovery artifacts;
- start Mini Craft services/containers;
- restore DB/wp-content;
- modify Shared Infra;
- enable route/PayPal Live/payment/refund;
- deploy;
- broad prune.

## Return

Success:

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

If exact executed helper bytes are unavailable:

```text
RETURN_C1R5R1_EXECUTED_HELPER_SOURCE_UNRECOVERABLE
STOP_AT_REVIEWER=YES
```

A reconstructed helper does not count as the executed helper source.
