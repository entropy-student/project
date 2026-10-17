# MokerSaaS — Owner-local Windows Lab (project document entry)

> LAST_REVIEWED: 2026-10-17
> PROJECT_REPOSITORY: entropy-student/project, main:mokersaas-local-lab/
> CANONICAL_PROJECT_STATUS: [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)
> SOLE_CURRENT_EXECUTOR_GATE: [G1UV_STDIN_PIPE_FIX_AND_LOCALHOST_GATE.md](G1UV_STDIN_PIPE_FIX_AND_LOCALHOST_GATE.md) — READY
> STOP_AT_REVIEWER=YES

## New Reviewer — start here

1. Read [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md) for accepted status, current Gate, decision boundaries, old/new resource identities, rollback, unresolved items and next steps. This is the **single handoff**; this README is only a navigation pointer.
2. Read the one current [G1UV Gate](G1UV_STDIN_PIPE_FIX_AND_LOCALHOST_GATE.md), authorized to correct **the same** .NET ProcessStartInfo stdin method, prove it with a non-secret Docker fixture, then conditionally continue through synthetic Secret volumes/new DB/site. Do not replay old Gate relays.
3. Read [DECISION_LOG.md](DECISION_LOG.md) for the two Owner approvals: (a) a NEW side-by-side synthetic DB and guarded localhost smoke; (b) temporary **disposable synthetic only** exemption to independent off-host encrypted credential recovery. No live data or payment credentials.
4. Read the latest G1U partial-result section of [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md), plus G1TRF evidence only when investigating earlier Windows→Linux bind failure.

## Concise status

- **Done:** fixed-source security preparations; PostgreSQL and NextAuth file-backed Secret adapters; G1P2 TypeScript/Next build PASS from Owner-local Codex evidence. Existing G1P2 app image ID is indexed in Handoff.
- **Last failure:** G1U fallback B created TWO project-only Docker Secret volumes, confirmed EMPTY **before** credential transfer. The first protected .NET anonymous stdin stream invocation raised `MethodInvocationException` with no retained base exception; receiver container was absent and no successful transfer proven. Volume emptiness **after** the attempt still needs read-only check; Windows original credentials unchanged. No policy denial demonstrated.
- **Current Gate:** G1UV first read-only inventories the **existing two** isolated Secret-only volumes after failed transfer; then tests SAME redirected .NET ProcessStartInfo/stdin binary pipeline using a completely NON-SECRET Docker fixture. On fixture PASS, securely copy original existing synthetic credentials to distinct volumes with no Secret bytes in env/args/logs and restrictive service-only mounts. Continue in SAME round to NEW Postgres, current migrator build/schema, G1P2 loopback site and negative security checks. Real native/policy/security failure still stops.
- **Not yet done:** Neither Secret volume is proven filled/usable; new G1S DB, schema, HTTP and login/security tests NOT_STARTED. Existing two protected host synthetic Secret files, private new DB network/volume and app build retained; `http://127.0.0.1:3077` NOT_RUNNING.
- **Preserve:** original `mokersaas-local-lab-db-1` + `mokersaas-local-lab-db-data` and their project network; existing images; 22 locally patched paths. No password reset, volume deletion or mutation of the original DB. No numeric RAM gate; real failures still stop.
- **Important provenance:** GitHub `main:mokersaas-local-lab/` stores the **project-control documents**, not the working application's 22 uncommitted modifications or Docker/Secret bytes. Those changes are on the Owner Windows workstation only. The next Reviewer cannot independently inspect their exact bytes via GitHub; request scoped, sanitized local readback if material. Never infer actual machine success from this README or a PASS_CANDIDATE label.

## Historic records, NOT active

`G1U_SECRET_MOUNT_REPAIR_AND_LOCALHOST_GATE.md`, `G1TRF_RETAINED_PROBE_AND_LOCALHOST_GATE.md`, `G1TRR_EXISTING_SECRET_READER_AND_LOCALHOST_CONTINUATION_GATE.md`, `G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md`, and `G1T_NEW_DB_LOCALHOST_SMOKE_GATE.md` are historical RETURN; G1UV only READY. No historical relay executable.

## Governance

Single cross-project operating standard: [entropy-student/spike.skill — vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7 ACTIVE_PROVISIONAL. Current project Gate and Reviewer interpret applicable rules; this navigation README does not create or override policy.
