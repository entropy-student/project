# Reviewer Decision — G4 Contract Completion Return

Date: 2026-09-22

Role: Reviewer / Architect / Gatekeeper

## Decision

`RETURN_G4_CONTRACT_COMPLETION_REQUIRED`

The repository reconciliation is accepted:
- dedicated branch exists;
- branch tip `9d4d8531ecdb1774d03e9edec9a7c4da8819a704`;
- implementation commit `0d8671067df400927c9d5329a8666bac942a605d`;
- all branch changes are under `conversion-leak-audit/**`;
- the branch was based on `746a4882d9511ab103713b9ae1d6bd2d5e8ebfaa`;
- later main changes inspected by Reviewer did not touch `conversion-leak-audit/**`.

G4 final PASS is still withheld because the implementation/evidence does not yet satisfy all frozen G4 contracts.

## Required corrections

### R1 — Prove WordPress ↔ real Scanner V0 compatibility

The current browser integration suite uses `g4-wordpress-integration/tests/fake_scanner_server.py`.

This proves UI/proxy behavior against a fixture server, but does not prove the first complete local product loop against the recovered real Scanner V0.

Add one bounded real-Scanner canary through the WordPress integration:
- start the actual recovered Scanner service;
- submit one safe public test URL through the WordPress G4 integration;
- observe real job creation, real `scan_id`, polling, terminal state, report retrieval when available;
- assert report/job schema compatibility and no evidence-less ISSUE;
- no production deployment, payment, login, or unsafe target.

The deterministic Golden Demo may remain fixture-backed; the real canary exists only to prove actual service compatibility.

### R2 — Complete the real progress-state contract

Frozen interaction contract requires:

`CHECKING_ACCESS → READING_PAGES → MATCHING_EVIDENCE → PRIORITIZING → COMPLETE`

The recovered Scanner currently transitions from `MATCHING_EVIDENCE` directly to `COMPLETE` / `INCOMPLETE`; it never emits `PRIORITIZING`.

Add a real backend `PRIORITIZING` phase before terminal completion, without changing frozen rule semantics.

UI copy must follow canonical stages:
1. Checking access
2. Reading pages
3. Analyzing with trusted rules
4. Finalizing results

No timer-driven fake stage.

### R3 — Bring analytics hooks into the frozen event contract

Current G4 events do not fully conform to `design/ANALYTICS_EVENT_CONTRACT.md`.

At minimum:
- normalize `scan_incomplete.reason` to the frozen public enum;
- include the contract-required privacy-safe `site_id_hash` where required;
- do not send full scanned URL as analytics data;
- keep payment events disabled;
- add automated assertions for analytics event names and properties.

### R4 — Add missing functional acceptance coverage

Automated tests must explicitly cover:
- `refresh_result_page`;
- `analytics_event_contract`;
- real `PRIORITIZING` mapping;
- mobile form submit remains covered.

### R5 — Make the Golden Demo fixture truthful

The frozen Golden Demo contains exactly four pages:
- `/`
- `/products/example`
- `/cart`
- `/faq`

and exactly:
- `CORE-007`
- `PHYS-002`
- `PHYS-001`

The current fake report uses a one-page `/products/demo` fixture and therefore does not reproduce the frozen demo evidence model.

Update only the synthetic demo fixture/test data so it reproduces the frozen four-page evidence and the required summary:
- `3 confirmed findings`
- `17 trusted checks`
- `Synthetic Demo`

Do not change the 17 frozen Scanner rule semantics.

### R6 — Complete required G4 screenshot evidence

Current branch contains only:
- desktop landing;
- desktop demo result;
- mobile two-result screen.

G4 contract additionally requires evidence for:
- Home mobile;
- Scan progress desktop;
- Scan progress mobile;
- Free Top 3 mobile for the Golden Demo;
- incomplete/error state.

Add deterministic Playwright screenshots at the frozen 1440×900 and 390×844 reference viewports.

### R7 — Remove obvious frozen visual-direction drift before G4 PASS

Formal pixel/polish review remains G4.5, but G4 implementation still must follow the frozen direction.

Current implementation uses orange as the primary CTA/accent while `FINAL_GOLDEN_SCREEN_SPEC.md` freezes a clean white canvas, deep navy text, and blue primary action.

Bring the primary action/accent tokens back to the frozen blue/navy direction. Do not perform a broad redesign; G4.5 remains responsible for formal visual acceptance.

## What is already accepted

Do not redo:
- source recovery;
- G1;
- G2;
- 55/55 Scanner regression foundation;
- 20/20 WordPress baseline;
- clean sparse workspace;
- repository isolation;
- existing G4 form/proxy/job/polling/result architecture;
- deterministic Top 3 logic;
- fail-closed concept;
- dedicated branch strategy.

## Required return

After corrections:
- rebase/update dedicated branch onto current `origin/main` while preserving Reviewer-owned docs;
- rerun 55/55 and 20/20;
- rerun fixture-backed G4 suite;
- run real-Scanner canary;
- record analytics/state/demo/screenshot evidence;
- push branch;
- return `PASS_CANDIDATE_G4_CONTRACT_COMPLETE`;
- STOP_AT_REVIEWER.

Do not merge to main before Reviewer PASS.
