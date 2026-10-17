# MokerSaaS — Owner-local Windows Lab (project document entry)

> LAST_REVIEWED: 2026-10-17
> PROJECT_REPOSITORY: entropy-student/project, main:mokersaas-local-lab/
> CANONICAL_PROJECT_STATUS: [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)
> SOLE_CURRENT_EXECUTOR_GATE: [G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md](G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md) — READY
> STOP_AT_REVIEWER=YES

## New Reviewer — start here

1. Read [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md) for accepted status, current Gate, decision boundaries, old/new resource identities, rollback, unresolved items and next steps. This is the **single handoff**; this README is only a navigation pointer.
2. Read the only current [G1X Docker-native first-boot Gate](G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md): generate new disposable credentials inside isolated Docker volumes, then DB/schema/loopback site. No Windows host Secret transfer or prior Gate rerun.
3. Read [DECISION_LOG.md](DECISION_LOG.md): Owner new disposable synthetic DB approval, synthetic-only no-offhost-recovery exception, and one-round Docker-native first-boot simplification. Never touch old DB/credentials or real Providers.
4. Read only latest relevant [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md) sections for G1U stdin failure, G1UV supersession and G1X action scope. Management docs are separate from actual Windows-local source and runtime state.

## Concise status

- **Done:** fixed-source security preparations; PostgreSQL and NextAuth file-backed Secret adapters; G1P2 TypeScript/Next build PASS from Owner-local Codex evidence. Existing G1P2 app image ID is indexed in Handoff.
- **Last failure:** G1U created two project-only Secret named volumes and encountered PowerShell/.NET stdin `MethodInvocationException`; their post-error contents are unverified, and no receive container was found. The original host Windows file Secret mount had also failed earlier. These transmission failures are no longer the chosen architecture; G1UV was not executed.
- **Current Gate:** G1X uses CSPRNG generated **new, synthetic Docker-native credentials inside two separate, protected Docker-only named volumes** (reuse prior ones only if proven empty, else leave untouched). It bypasses neither an execution policy denial nor old DB credentials. Verify Linux reader and service isolation, start separate NEW Postgres and existing migrator/schema, reuse G1P2 app at `http://127.0.0.1:3077` and test critical admin/provider blocks **in one round**.
- **Not yet done:** No G1X local execution yet. No confirmed new DB/schema/app or HTTP. Original Owner/SYSTEM-protected Windows credentials, two G1U Docker Secret-only volumes, G1S DB volume/network and original DB all retained. Site NOT_RUNNING on latest readback.
- **Preserve:** original `mokersaas-local-lab-db-1` + `mokersaas-local-lab-db-data` and their project network; existing images; 22 locally patched paths. No password reset, volume deletion or mutation of the original DB. No numeric RAM gate; real failures still stop.
- **Important provenance:** GitHub `main:mokersaas-local-lab/` stores the **project-control documents**, not the working application's 22 uncommitted modifications or Docker/Secret bytes. Those changes are on the Owner Windows workstation only. The next Reviewer cannot independently inspect their exact bytes via GitHub; request scoped, sanitized local readback if material. Never infer actual machine success from this README or a PASS_CANDIDATE label.

## Historic records, NOT active

`G1UV_STDIN_PIPE_FIX_AND_LOCALHOST_GATE.md` is superseded **unexecuted**. G1U, G1TRF, G1TRR, G1TR and earlier Gates were returned/historical; do not replay. G1X is sole READY.

## Governance

Single cross-project operating standard: [entropy-student/spike.skill — vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7 ACTIVE_PROVISIONAL. Current project Gate and Reviewer interpret applicable rules; this navigation README does not create or override policy.
