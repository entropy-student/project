# G4.5 — Visual + Functional Acceptance Contract

Status: `READY_FOR_EXECUTOR`
Precondition: `PASS_G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`
Executor: Codex / local development agent
Reviewer: ChatGPT Reviewer

## Goal

Accept the implemented G4 product against the frozen G3.5 design and functional contracts without expanding scope.

Canonical references:
- `../design/FINAL_GOLDEN_SCREEN_SPEC.md`
- `../design/DEMO_FIXTURE_GOLDEN.md`
- `../design/DESIGN_SYSTEM.md`
- `../design/PAGE_CONTRACTS.md`
- `../design/INTERACTION_STATES.md`
- `../design/ANALYTICS_EVENT_CONTRACT.md`
- `../design/FUNCTIONAL_ACCEPTANCE.md`
- `../design/VISUAL_ACCEPTANCE.md`
- `EXECUTION_EVIDENCE.md`

## Scope

G4.5 may:
- rerun functional tests;
- run Playwright screenshots at frozen viewports;
- compare implementation against Golden Screen contracts;
- fix bounded implementation drift discovered by acceptance;
- fix responsive/accessibility/state presentation defects;
- improve deterministic screenshot stability.

G4.5 must not:
- add new product features;
- add new Scanner rules;
- change frozen rule meaning;
- build G5 full Fix Queue or LLM report;
- add payment/PayPal/Unified Pay;
- touch VPS/domain/HTTPS/shared infrastructure;
- use production Secrets;
- expose a public production Scanner.

## Functional acceptance

Reconfirm:
- valid URL local loop;
- invalid/unsafe URL;
- Scanner unavailable;
- incomplete/fail-closed;
- zero/one/two/three findings;
- evidence expand;
- refresh result;
- mobile form submit;
- analytics contract;
- no payment call;
- Scanner 55/55;
- WordPress 20/20.

Any functional regression returns G4.5.

## Visual acceptance

Required reference viewports:
- Desktop `1440×900`;
- Mobile `390×844`.

Also smoke:
- `1280×800`;
- `360×800`.

Required screens/states:
- Home;
- Scan progress;
- incomplete/error;
- Free Top 3;
- issue evidence detail;
- paid-expansion/full-report shell boundary.

Check:
1. hierarchy;
2. comprehension;
3. trust/proof visibility;
4. free Aha visibility;
5. responsive behavior;
6. state fidelity;
7. frozen blue/navy visual direction;
8. motion/reduced-motion behavior where present;
9. polish.

No horizontal overflow, clipped CTA, unreadable body text, or sub-44px critical tap targets.

## Screenshot rule

Use deterministic Golden Demo data and stable fonts/viewport/animations.

Do not loosen visual-diff thresholds merely to obtain PASS. If anti-aliasing noise requires tolerance, record the smallest practical threshold and evidence.

## Acceptance evidence

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` with:
- Gate;
- commit/revision;
- commands;
- functional results;
- viewport matrix;
- screenshot paths;
- visual comparison result;
- responsive result;
- accessibility/state observations;
- bounded fixes, if any;
- known limitations;
- Owner intervention;
- recommended Reviewer decision.

Candidate result:

`PASS_CANDIDATE_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

Then `STOP_AT_REVIEWER`.

Reviewer alone declares final G4.5 PASS.
