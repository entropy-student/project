# G3S1P — Owner execution permission checkpoint (no runtime mutation)

> Date: 2026-10-15
> Parent: REVIEWER_DECISION_G3S1D_RETURN_POLICY_SOURCE_UNKNOWN_2026-10-15.md
> Governance: v0.2.7

## Gate

    GATE_ID=G3S1P_OWNER_EXECUTION_PERMISSION_CHECKPOINT
    OBJECTIVE=Establish whether an officially documented permission/approval path exists for the previously denied start of the existing project-isolated WordPress container.
    MAX_ENDPOINT_THIS_ROUND=Owner reports documented approval capability and scope; no process execution or container mutation.
    MANDATORY_REVIEW_STOP=YES
    TARGET_AND_SCOPE=Official Codex executor permission/approval UI or support documentation, not Windows/Docker itself.
    APPLICABLE_CRITICAL_CONSTRAINTS=NO_POLICY_BYPASS; NO_DOCKER_START_STOP; NO_SHELL_RETRY; NO_ALTERNATE_SHELL_SDK_GUI_AGENT; NO_ELEVATION_OR_PERMISSION_POLICY_CHANGE; NO_REBUILD_RECREATE_RESTORE; NO_SECRET_OUTPUT; NO_PAYMENT_PROVIDER_ACTION; NO_PR_MERGE.
    PREFLIGHT=Current main/Handoff, parent RETURN, last G3S1D Evidence, Owner consent for an explicit minimal permission investigation.
    REQUIRED_EVIDENCE=DOCUMENTED_APPROVAL_MECHANISM_OR_UNAVAILABLE; EXACT_SCOPE; OWNER_PERMISSION_DECISION_IF_APPLICABLE; NO_TARGET_MUTATION.
    ACCEPTANCE_CRITERIA=Official approval mechanism is identified and narrowly applicable to the blocked action, or formally classified unavailable. Neither result authorizes Docker execution.
    ROLLBACK_STATUS_OR_PLAN=No writes; DB and volumes preserved. DB last reported running; data integrity UNKNOWN.
    OWNER_ONLY_ACTIONS=Full Access already enabled by Owner report. Do not repeat that check. If official documented per-action approval is unavailable, escalate the redacted error to Codex product support; any later operation requires separate reviewed authority.

## Owner response: Full access already enabled

On 2026-10-15, Owner reports using **Codex Windows desktop** with **Full Access already enabled for about three days**, in the **same unchanged conversation/session** when the denial occurred. Provenance: OWNER_REPORTED, not independent settings UI readback.

Do **not** ask Owner to enable Full Access again or assume insufficient user permission. Current inconsistency: Full Access reportedly enabled while `CreateProcess` was still denied before Docker invocation. The exact executor policy layer/rule remains UNKNOWN; a client/session/tool bug or a more specific rule is possible but unproven.

The current outstanding checkpoint is now **officially supported diagnosis/permission escalation**, not repeating the standard Full Access setting check. If no native, documented per-action approval is surfaced, the next recommended action is to report the exact redacted `CreateProcess ... blocked by policy` error and Windows-desktop / long-lived session context to official Codex support. Do not try a new session, different executor surface or manual Docker launch merely to evade this denial.

## Reviewer to Owner checkpoint

Verify only whether the Codex product/executor, in the exact session and deployment environment that denied CreateProcess, offers a native documented ask-for-approval or execution permission setting for this exact action. The exact policy and owner-controllable mechanism are currently UNKNOWN. Do not route the same start through PowerShell, CMD, Docker Desktop, Compose, API/SDK, alternate agent or UI automation to evade the refusal. Do not change Windows execution policy or global environment permissions speculatively.

Return one of:
- OFFICIAL_APPROVAL_PATH_AVAILABLE: identify the product setting/workflow by name, its allowed scope and what action it would authorize; do not execute it.
- OFFICIAL_APPROVAL_PATH_UNAVAILABLE: exact available official product/support route, or UNKNOWN.
- UNKNOWN: no documented path was discoverable without prohibited access.

Reviewer will then authorize a separate exact service-start Gate only when the permission model is explicitly resolved; otherwise G3S1 remains on hold.

## Executor-facing rule

No Executor run is needed solely to recheck Docker or retry the denied command. If an Executor is used for documentation-only readback, it must not attempt host lifecycle operations.

## Owner-facing result

WordPress, Mailpit and wpcli remain stopped in the latest Executor evidence; DB reported running/healthy. All four containers, images and two project volumes are reportedly retained. Missing 17 historical screenshot files do not block runtime start. No rebuild is appropriate.
