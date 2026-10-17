# MokerSaaS — Owner-local Windows Lab (project document entry)

> LAST_REVIEWED: 2026-10-17
> PROJECT_REPOSITORY: entropy-student/project, main:mokersaas-local-lab/
> CANONICAL_PROJECT_STATUS: [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)
> CURRENT_EXECUTOR_GATE: NONE — last G1TRF RETURN; Reviewer must isolate existing-container Secret mount failure before a new scoped Gate.
> STOP_AT_REVIEWER=YES

## New Reviewer — start here

1. Read [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md) for accepted status, current Gate, decision boundaries, old/new resource identities, rollback, unresolved items and next steps. This is the **single handoff**; this README is only a navigation pointer.
2. Read the [G1TRF returned Gate](G1TRF_RETAINED_PROBE_AND_LOCALHOST_GATE.md) and the last Evidence entry for its four independent flags; it is **historical**, not executable. No active mutating Gate.
3. Read [DECISION_LOG.md](DECISION_LOG.md) for the two Owner approvals: (a) a NEW side-by-side synthetic DB and guarded localhost smoke; (b) temporary **disposable synthetic only** exemption to independent off-host encrypted credential recovery. No live data or payment credentials.
4. Read the latest relevant sections of [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md), especially G1TRF retained-container Secret visibility failure and the earlier evidence-tool lessons; inspect older entries only if a conflict requires.

## Concise status

- **Done:** fixed-source security preparations; PostgreSQL and NextAuth file-backed Secret adapters; G1P2 TypeScript/Next build PASS from Owner-local Codex evidence. Existing G1P2 app image ID is indexed in Handoff.
- **Last failure:** G1TRF retained the exact audit container and captured 4 independent results: DB_FILE_PRESENT=FAIL; DB_FILE_NONEMPTY_READABLE=FAIL; NEXTAUTH_PATH_ABSENT=PASS; NEW_DB_VOLUME_SAFE_EMPTY=PASS. Expected DB Secret is not visible as a regular file in Linux container. Windows→Docker Desktop file-sharing/target/reader mechanism still UNKNOWN; this is not proof of Windows ACL defect or NextAuth Secret exposure.
- **Current Gate:** NONE authorized for writes. Reviewer should first use already-retained exited audit container ID `116898e95836d221a07725ad80791d0ac3a9108c49b61a7331b603abdff636ae` and existing host ACL metadata for bounded **read-only** mounted-file type/target/reader diagnosis. Only then issue a single compatible project-only repair+site continuation Gate; do not recreate Secret or touch old DB.
- **Not yet done:** database has NOT been started or initialized, no app/HTTP/auth tests. Two synthetic secrets DO exist on Owner PC; new internal network and named volume exist; `http://127.0.0.1:3077` was NOT_RUNNING on last Owner-local readback.
- **Preserve:** original `mokersaas-local-lab-db-1` + `mokersaas-local-lab-db-data` and their project network; existing images; 22 locally patched paths. No password reset, volume deletion or mutation of the original DB. No numeric RAM gate; real failures still stop.
- **Important provenance:** GitHub `main:mokersaas-local-lab/` stores the **project-control documents**, not the working application's 22 uncommitted modifications or Docker/Secret bytes. Those changes are on the Owner Windows workstation only. The next Reviewer cannot independently inspect their exact bytes via GitHub; request scoped, sanitized local readback if material. Never infer actual machine success from this README or a PASS_CANDIDATE label.

## Historic records, NOT active

`G1TRF_RETAINED_PROBE_AND_LOCALHOST_GATE.md`, `G1TRR_EXISTING_SECRET_READER_AND_LOCALHOST_CONTINUATION_GATE.md`, `G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md` and `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md` are historical RETURN. Earlier proposals are superseded. Retain audit history, but do not replay.

## Governance

Single cross-project operating standard: [entropy-student/spike.skill — vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7 ACTIVE_PROVISIONAL. Current project Gate and Reviewer interpret applicable rules; this navigation README does not create or override policy.
