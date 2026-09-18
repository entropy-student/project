# G4 — WordPress ↔ Scanner ↔ Top 3 Local Integration Contract

Status: `READY_FOR_EXECUTOR`
Precondition: `PASS_G3_5_UI_GROWTH_DESIGN_FREEZE`
Executor: Codex / local development agent
Reviewer: ChatGPT Reviewer

## Goal

Build the first complete local product loop without payment, VPS, production Secrets or public production exposure.

```text
WordPress URL form
→ Scanner job create
→ scan_id
→ honest progress / polling
→ Scanner result
→ deterministic Top 3
→ evidence detail
→ WordPress free result page
```

## Read before coding

Project truth:
1. `../PROJECT_RECORD.md`
2. `../CURRENT_STATUS.json`
3. `G3_5_UI_GROWTH_FREEZE.md`
4. `../design/FINAL_GOLDEN_SCREEN_SPEC.md`
5. `../design/DEMO_FIXTURE_GOLDEN.md`
6. `../design/DESIGN_SYSTEM.md`
7. `../design/PAGE_CONTRACTS.md`
8. `../design/INTERACTION_STATES.md`
9. `../design/ANALYTICS_EVENT_CONTRACT.md`
10. `../design/FUNCTIONAL_ACCEPTANCE.md`
11. `../design/VISUAL_ACCEPTANCE.md`

## Source boundaries

Use the reviewed local source trees:
- `scanner/` — Python Scanner V0
- `wordpress-g1-baseline/` — WordPress/SaasLauncher child-theme baseline

Do not re-create G1/G2 from scratch.

## Regression-first rule

Before product changes:
1. record baseline test commands and results;
2. confirm Scanner regression suite still passes;
3. confirm WordPress baseline asset checks still pass;
4. make the smallest integration changes necessary.

Do not let a UI rewrite replace already validated Scanner or WordPress architecture.

## UI implementation rule

The final visual direction is frozen.

Canonical text/behavior source:
- `FINAL_GOLDEN_SCREEN_SPEC.md`
- `DEMO_FIXTURE_GOLDEN.md`
- design contracts above

The final high-fidelity board approved in Reviewer chat is a visual reference. If generated-image text conflicts with GitHub contracts, GitHub contracts win.

`clone-ui` is reference extraction only. Do not paste broad clone output over the product codebase.

## Functional scope

### A. Home
- render final URL-first hero;
- platform compatibility strip;
- public-pages/no-admin/no-change trust copy;
- valid URL submit;
- invalid/unsafe URL state.

### B. Job creation
- call the Scanner job-create API;
- preserve `scan_id`;
- show retry-safe submission behavior;
- no duplicate scan caused by double click where avoidable.

### C. Progress
Render only real Scanner states.

Use:
1. Checking access
2. Reading pages
3. Analyzing with trusted rules
4. Finalizing results

No fake percentage progress.

### D. Result mapping
Map Scanner report → UI view model without changing rule meaning.

Possible rule statuses remain:
- PASS
- ISSUE
- NOT_APPLICABLE
- CONTEXT_INSUFFICIENT
- AUDIT_INCOMPLETE
- MANUAL_REVIEW_REQUIRED

Do not convert incomplete evidence into ISSUE.

### E. Top 3
Use deterministic prioritization already defined by product contracts.

If fewer than 3 trusted findings exist, render fewer than 3. Never fabricate findings to fill the UI.

Each finding must expose:
- rule id;
- observed fact;
- evidence/source;
- why it may matter;
- first move;
- evidence detail action.

### F. Demo fixture
The sample/demo path must reproduce only:
- CORE-007
- PHYS-002
- PHYS-001

Summary:
- 3 confirmed findings
- 17 trusted checks
- Synthetic Demo

No invented severity totals.

### G. Analytics hooks
Implement provider-independent event hooks according to `ANALYTICS_EVENT_CONTRACT.md`.

G4 may use a local/no-op adapter. Do not require PostHog account/API configuration to make G4 pass.

### H. Accessibility / responsive
Implement desktop and mobile layouts from frozen contracts.
No horizontal-scroll dependency for core result reading.

## Explicitly out of scope

Do NOT implement:
- PayPal;
- Unified Pay;
- checkout;
- entitlement;
- LLM report generation;
- VPS deployment;
- domain/HTTPS;
- production Secrets;
- public production scanner;
- new Scanner rules;
- broad WordPress plugin stack.

## Required G4 tests

At minimum prove:

### Regression
- Scanner existing suite remains green;
- WordPress baseline checks remain green.

### Integration
- valid synthetic demo creates/reads a job and renders the expected three findings;
- unsafe URL fails closed;
- blocked/rate-limited/incomplete scan renders an incomplete state, not an issue;
- zero findings renders a truthful zero-result state;
- one/two findings render one/two findings, not padded Top 3;
- job polling terminates correctly;
- report remains tied to the correct `scan_id`;
- no payment/VPS/production Secret path is introduced.

### UI evidence
Produce local screenshots for:
- Home desktop/mobile;
- Scan progress desktop/mobile;
- Free Top 3 desktop/mobile;
- incomplete/error state.

Formal pixel/visual acceptance belongs to G4.5, but G4 screenshots are required evidence.

## Completion evidence

Codex must update `EXECUTION_EVIDENCE.md` with:

```text
Gate: G4
Commit / local revision:
Files changed:
Architecture changes:
Commands run:
Regression results:
Integration results:
Screenshots:
Known limitations:
Risks:
Owner intervention required: YES/NO
Recommended Reviewer decision:
```

Codex does not declare PASS. Reviewer decides PASS / RETURN.

## Exit condition

Candidate:
`PASS_CANDIDATE_G4_LOCAL_FREE_LOOP`

Then Reviewer checks evidence. If accepted:

`PASS_G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`

Next:
`G4.5_VISUAL_FUNCTIONAL_ACCEPTANCE`
