# MokerSaaS Local Lab — DECISION_LOG
> Reviewer-maintained; project decisions only. Canonical Governance is external: entropy-student/spike.skill vps-project-governance/VNEXT.md.

## 2026-10-16 — Owner removes project-specific RAM gate; G1 authorized
- DECISION_ID: MOKER-D-20261016-NO-RAM-NUMERIC-GATE
- OWNER_INSTRUCTION: "请排除内存占用的限制，然后进入下一环节。"
- SCOPE: MokerSaaS owner-local Windows 11 lab only, transition from accepted G0 to new G1; no effect on other projects/VPS and no modification to canonical Governance.
- OVERRIDE: drop prior reviewer planning threshold `HOST_AVAILABLE_RAM_GiB >= ~4`; do not require the standalone G0R resource Gate. G0R remains a historical proposed Gate, marked `SUPERSEDED_NOT_EXECUTED`, NOT `PASS`.
- NOT_OVERRIDDEN: physical target and safe path proof, resource observations and native exit checks, fail-closed on actual OOM/crash/material runtime error, backups/rollback/Secret-safety, access-control/localhost-only requirements, no real provider/account/payment/email, project-scoped Docker operations, Reviewer evidence and stop.
- COST/RISK ACCEPTED: bounded resource pressure from optional project-scoped dependency download, image build and isolated localhost smoke; no real payment/third-party API spend/host-global configuration change authorized.
- RATIONALE: numeric threshold was an internal conservative planning criterion rather than upstream specification; Owner prioritizes advancing development with actual read-back and exact failure stops.
- IMPLEMENTATION: supersede `G0R_RESOURCE_READONLY_GATE.md`, create new `G1_LOCAL_HARDEN_COMPOSE_GATE.md`, update Handoff and append Evidence decision entry.
- NEXT REVIEW POINT: Executor returns G1 smoke evidence or precise RETURN. Reviewer decides whether to authorize deeper payment/referral testing.
