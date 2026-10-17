# MokerSaaS — Owner-local Windows Lab (project document entry)

> LAST_REVIEWED: 2026-10-17
> PROJECT_REPOSITORY: entropy-student/project, main:mokersaas-local-lab/
> CANONICAL_PROJECT_STATUS: [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)
> SOLE_CURRENT_EXECUTOR_GATE: [G1TRR_EXISTING_SECRET_READER_AND_LOCALHOST_CONTINUATION_GATE.md](G1TRR_EXISTING_SECRET_READER_AND_LOCALHOST_CONTINUATION_GATE.md)
> STOP_AT_REVIEWER=YES

## New Reviewer — start here

1. Read [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md) for accepted status, current Gate, decision boundaries, old/new resource identities, rollback, unresolved items and next steps. This is the **single handoff**; this README is only a navigation pointer.
2. Read the single current [G1TRR Gate](G1TRR_EXISTING_SECRET_READER_AND_LOCALHOST_CONTINUATION_GATE.md) and its `REVIEWER_TO_EXECUTOR_RELAY`. This is the only authorized Executor action. No previous Gate is executable merely because its historical text contains an instruction.
3. Read [DECISION_LOG.md](DECISION_LOG.md) for the two Owner approvals: (a) a NEW side-by-side synthetic DB and guarded localhost smoke; (b) temporary **disposable synthetic only** exemption to independent off-host encrypted credential recovery. No live data or payment credentials.
4. Read only the latest relevant parts of append-only [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md): G1P2 build PASS, G1T .NET method mismatch, and G1TR partial Secret creation with ambiguous three-in-one reader result; the G1TRR continuation is current. Retrieve older history only if a conflict requires it.

## Concise status

- **Done:** fixed-source security preparations; PostgreSQL and NextAuth file-backed Secret adapters; G1P2 TypeScript/Next build PASS from Owner-local Codex evidence. Existing G1P2 app image ID is indexed in Handoff.
- **Last failure:** G1TR FIXED the earlier .NET ACL method problem and created two protected local synthetic credential files, plus a new project-owned Docker network and named volume. The one disposable g1s-db read-check container exited 1 from a **combined** DB-file-readable AND NextAuth-not-mounted check; the failed subcondition is UNKNOWN. No policy rejection or proven secret exposure. Test container removed; no DB service/app is running.
- **Current Gate:** G1TR first verifies documented modern Windows/.NET ACL-at-creation APIs, then conditionally continues within one bounded run to protected new synthetic credentials, distinct Postgres/schema, localhost app, login/admin/provider negative tests. If an actual security/native/policy error occurs, preserve resources and return precise evidence; do not bypass a denied command.
- **Not yet done:** database has NOT been started or initialized, no app/HTTP/auth tests. Two synthetic secrets DO exist on Owner PC; new internal network and named volume exist; `http://127.0.0.1:3077` was NOT_RUNNING on last Owner-local readback.
- **Preserve:** original `mokersaas-local-lab-db-1` + `mokersaas-local-lab-db-data` and their project network; existing images; 22 locally patched paths. No password reset, volume deletion or mutation of the original DB. No numeric RAM gate; real failures still stop.
- **Important provenance:** GitHub `main:mokersaas-local-lab/` stores the **project-control documents**, not the working application's 22 uncommitted modifications or Docker/Secret bytes. Those changes are on the Owner Windows workstation only. The next Reviewer cannot independently inspect their exact bytes via GitHub; request scoped, sanitized local readback if material. Never infer actual machine success from this README or a PASS_CANDIDATE label.

## Historic records, NOT active

`G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md` and `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md` now record RETURN. `G1S_NEW_TEST_DB_RECOVERY_PROPOSAL.md` and `G1T_DISPOSABLE_LOCAL_LAB_PROPOSAL.md` are superseded planning records. Older G0/G1/G1R/G1S/G1P/G1P2 Gates are historical. Retain rather than delete them to preserve audit trail. Do not replay them.

## Governance

Single cross-project operating standard: [entropy-student/spike.skill — vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7 ACTIVE_PROVISIONAL. Current project Gate and Reviewer interpret applicable rules; this navigation README does not create or override policy.
