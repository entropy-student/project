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
G3.5 UI + Growth Design Freeze = PASS
G4 WordPress ↔ Scanner ↔ Top 3 = NEXT / RELEASED TO CODEX
G4.5 Visual + Functional Acceptance = PENDING
```

## G3.5 Final Decision

```text
PASS_G3_5_UI_GROWTH_DESIGN_FREEZE
VISUAL_DIRECTION = Editorial Diagnostic Console / Evidence-first Diagnostic
PRIMARY_LOGO = Gap Mark
TRUTHFUL_DEMO_FIXTURE = FROZEN
OWNER_VISUAL_APPROVAL = PASS
```

Canonical design contracts live in `../design/`.

Highest-priority implementation references:
1. `../design/FINAL_GOLDEN_SCREEN_SPEC.md`
2. `../design/DEMO_FIXTURE_GOLDEN.md`
3. `../design/DESIGN_SYSTEM.md`
4. `../design/PAGE_CONTRACTS.md`
5. `../design/INTERACTION_STATES.md`
6. `../design/ANALYTICS_EVENT_CONTRACT.md`
7. `../design/FUNCTIONAL_ACCEPTANCE.md`
8. `../design/VISUAL_ACCEPTANCE.md`

If generated-image text conflicts with these contracts, GitHub contracts win.

## Current Reviewer Position

Reviewer does not implement G4 code.

Codex is now authorized to execute only:

`G4_EXECUTION_CONTRACT.md`

The next Reviewer action is to read Codex's updated `EXECUTION_EVIDENCE.md` and decide:

- PASS_G4
- RETURN_G4
- STOP / OWNER CHECKPOINT

## G4 hard boundaries

No:
- payment;
- PayPal;
- Unified Pay;
- VPS;
- public production scanner;
- production Secret;
- new Scanner rules;
- LLM full-report generation;
- broad clone-ui rewrite.

G4 is local integration only:

```text
WordPress URL form
→ Scanner job
→ scan_id
→ honest progress
→ deterministic findings
→ evidence-backed Top 3
→ WordPress result page
```

## Frozen baseline

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

G4 must preserve these validated foundations unless a new real counterexample justifies reopening one.

## Payment

Payment stays deferred to G9.

Tentative provider: Direct PayPal.
Unified Pay is not a current dependency.

## GitHub handoff rule

Reviewer writes decisions/contracts to GitHub.
Codex writes execution facts/evidence to GitHub.
Chat can remain short and point to the relevant file.

If this workflow remains stable through several Gates, promote it to shared project-management governance.
