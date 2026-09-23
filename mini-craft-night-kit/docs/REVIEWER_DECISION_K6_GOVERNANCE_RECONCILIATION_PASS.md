# Reviewer Decision — K6 Governance Reconciliation PASS

Date: 2026-09-23
Status: FORMAL PASS
Scope: documentation/authority reconciliation only

## Decision

Mini Craft project documents may contain historical or project-local restatements of VPS Governance.
Those restatements are not a second Governance source.

For any duplicated Governance topic, use this precedence:

```text
Owner latest explicit instruction
→ active Reviewer bounded override / Gate-specific addendum
→ GitHub canonical entropy-student/spike.skill/vps-project-governance latest
→ Mini Craft project restatements / historical Decision wording
→ old local copies / chat history
```

Project factual truth remains separate and follows the current accepted Reviewer decision/Handoff plus fresh accepted Evidence.

## Reconciled duplicate domains

The following domains now defer to canonical Governance wherever overlapping:

- Owner / Reviewer / Executor role boundaries;
- PASS_CANDIDATE vs PASS;
- Source of Truth;
- Gate lifecycle and compressed Gate rules;
- Secret handling;
- SSH connection recovery;
- Target Host Reality;
- Shared Infra classification;
- Storage layout;
- canonical deployment-manifest invariant;
- resource/disk governance;
- rollback/evidence standards;
- Owner-operation minimization;
- no rerun of accepted PASS without material drift.

Project docs may still add stricter or project-specific facts, such as:
- target origin;
- WordPress/MariaDB versions;
- protected Home/Product Gallery decisions;
- PayPal Sandbox state;
- Mini Craft exact paths/names;
- visual-evidence ZIP workflow.

A project document may not weaken canonical Governance.

## Current K6 consequences

1. `K6R1_SSH_TRANSPORT_DIAGNOSIS` is historical/superseded.
2. Current Gate is `K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY`.
3. Exactly one canonical strict SSH read-only probe is used.
4. Repeated pre-host-key close stops at a minimal Hostinger-console checkpoint.
5. Existing Shared VPS Docker/Compose/Caddy/`/srv` foundations are reused rather than rebuilt.
6. `PROJECT_STORAGE_MANIFEST.md` now exists and must be completed with fresh resource read-back before deployment writes.
7. No global Governance change is needed for this incident.

## Result

```text
GATE=K6_GOVERNANCE_RECONCILIATION
RESULT=PASS
CANONICAL_GOVERNANCE_PRIORITY=PASS
PROJECT_DUPLICATE_RULES_DEAUTHORIZED_AS_COMPETING_SOURCE=PASS
K6R1_CURRENT=K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
PROJECT_STORAGE_MANIFEST=CREATED
GLOBAL_GOVERNANCE_CHANGE_REQUIRED=NO
VPS_ACTIONS=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
NEXT=K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY
```
