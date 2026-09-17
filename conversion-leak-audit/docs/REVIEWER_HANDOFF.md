# Conversion Leak Audit — REVIEWER HANDOFF

> Role: Reviewer / Architect / Gatekeeper
> Source of truth: `../PROJECT_RECORD.md`

## Current Decision

```text
P0 / P0A / P0B = PASS
PF = PASS
G1 WordPress Local Baseline = PASS
G2 Safe Scanner V0 = PASS
G3 Rule Engine V0 = MERGED / CLOSED
G3.5 UI + Growth Design Freeze = IN PROGRESS
G4 WordPress ↔ Scanner ↔ Top 3 = PENDING
```

Codex product implementation remains paused until G3.5 PASS.

## G3.5 Completed in current Reviewer round

Text/product contracts now exist:

```text
design/UI_GROWTH_BRIEF.md             READY
design/DESIGN_SYSTEM.md               READY
design/PAGE_CONTRACTS.md              READY
design/INTERACTION_STATES.md          READY
design/ANALYTICS_EVENT_CONTRACT.md    READY
design/FUNCTIONAL_ACCEPTANCE.md       READY
design/VISUAL_ACCEPTANCE.md           READY
```

Current recommended design direction:

> **Editorial Diagnostic Console / Evidence-first Diagnostic**

Key decisions:
- observed fact/evidence before opaque scoring;
- free result = evidence-backed Top 3 complete-but-bounded win;
- no fake percentage progress;
- no AI-neon / fake terminal / generic chatbot feel;
- paid expansion adds scope/depth/prioritization/personalization/continuity;
- clone-ui is reference extraction only;
- analytics semantics are provider-independent;
- payment stays deferred to G9, tentative Direct PayPal.

## Current G3.5 blocker / next task

Only the high-fidelity owner review remains before G3.5 can PASS.

Required golden references:
- Home desktop;
- Home mobile;
- Scan progress;
- Scan incomplete/error;
- Free Top 3 desktop/mobile;
- Evidence detail;
- Full report shell.

Next sequence:

```text
CREATE_HIGH_FIDELITY_GOLDEN_SCREENS
→ OWNER_VISUAL_REVIEW
→ revisions if needed
→ PASS_G3_5
→ update EXECUTOR_HANDOFF
→ release G4 to Codex
```

## Growth Principle

Primary Activation hypothesis:

```text
scan_started
→ scan_completed
→ top3_viewed
→ user experiences a concrete evidence-backed finding about their store
```

The free product must deliver a bounded but complete win. Paid value should expand depth/scope/personalization/continuity rather than intentionally cripple the free result.

## clone-ui Boundary

Allowed: extract layout, spacing, typography, component language and motion references.

Forbidden: broad direct rewriting of the existing product source, architecture or unrelated components. Clone output is reference material, not canonical product code.

## Product Claim Boundary

Allowed:
> 发现可观察到的站内因素，这些因素可能增加购买犹豫、不信任或操作阻力。

Forbidden:
- root-cause claim from L0/L1 evidence;
- exact revenue-loss claim;
- guaranteed conversion uplift;
- free-form LLM diagnosis from raw HTML.

## Accepted Technical Architecture

- Frontend/CMS: WordPress + SaasLauncher + child theme
- Scanner: Python
- Static extraction: Scrapy first
- Dynamic fallback: bounded browser only when technically needed
- Persistence: SQLite for V0 local phase
- Rule set: frozen 17-rule MTRS
- LLM: explanation layer only after deterministic findings

## Evidence Baseline

```text
Rule fixtures             51 / 51 PASS
Scanner project tests     55 / 55 PASS
Real-network facts        26 / 26 PASS
Real rule assertions      28 / 28 PASS
Unexpected ISSUE          0
Geo-context misuse        0
WordPress asset checks    20 / 20 PASS
```

G1 CI run `35237395508`: success.
G2 network CI run `35235157740`: success.

## Payment Decision

Payment remains HOLD until G9.

- tentative provider: Direct PayPal;
- Unified Pay is not a current project dependency and needs separate fixes/production validation;
- do not let payment block G3.5–G8;
- payment must later unlock the correct scan/report entitlement.

## Skill Dogfood

Use `SKILL_DOGFOOD_LOG.md` to log Skill-derived hypotheses before implementation/measurement. Only real behavioral evidence may move them to SUPPORTED/REJECTED/INCONCLUSIVE.

## Reviewer Rules

1. Do not reopen theory without a real counterexample.
2. Do not alter frozen rules merely to make implementation pass.
3. Keep `PROJECT_RECORD.md` and `CURRENT_STATUS.json` synchronized after Gate changes.
4. Every Executor completion must cite files/tests/commands/evidence.
5. Reviewer results go to GitHub; Codex execution results go to GitHub; chat responses can stay short and point to the relevant document.
6. If a task needs payment Secret, Shared Infra change, irreversible action or production opening: RETURN to Owner.
7. After this GitHub handoff workflow successfully completes several Gates, promote it into the shared project-management governance standard.
