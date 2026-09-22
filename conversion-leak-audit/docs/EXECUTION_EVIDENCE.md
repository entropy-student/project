# Conversion Leak Audit — EXECUTION EVIDENCE

> Evidence log only. Do not use this file for future plans; use `PROJECT_RECORD.md` / `ROADMAP.md` for state and roadmap.

## Pre-development foundation

Completed evidence:

```text
Full knowledge rules        77
Scanner V0 frozen rules     17
Synthetic rule fixtures     51 / 51 PASS
Normal real targets         9 / 9 auditable
Real fact assertions        26 / 26 PASS
Real rule assertions        28 / 28 PASS
Unexpected ISSUE            0
Geo-context misuse          0
```

Theory / rule canonical source:
`entropy-student/spike.skill/independent-store-operations/`

## G2 — Safe Scanner V0

Reviewer decision: `PASS`

Verified capabilities:
- Python Scanner V0;
- SQLite persistence;
- `/healthz`;
- job/report API;
- bounded page count / concurrency / browser fallback;
- public URL / SSRF controls;
- localhost / private / link-local / metadata blocking;
- redirect re-validation;
- same-origin boundary;
- connection-time DNS/IP pinning;
- Scrapy static-first;
- bounded Chromium fallback;
- 403 / 429 / robots do not trigger browser bypass;
- raw HTML not persisted as normal durable job data;
- ISSUE requires evidence reference.

Latest recovery re-run before document migration:

```text
Scanner project tests = 55 / 55 PASS
```

Real-network validation workflow:

```text
Repository: entropy-student/spike.skill
Workflow: Independent Store Ops Real Crawl
Run ID: 35235157740
Conclusion: success
```

The same validation family retained:

```text
Real facts          26 / 26
Real rules          28 / 28
Unexpected ISSUE    0
Geo misuse          0
```

## G1 — WordPress Local Baseline

Reviewer decision: `PASS`

Verified runtime baseline:
- WordPress 7.1
- MariaDB 11.4
- SaasLauncher 2.0.18
- project child theme active
- block theme = YES
- Home / How it works / Demo / Pricing / FAQ / Blog
- 6 / 6 HTTP 200
- project home content rendered
- disabled URL scan placeholder rendered
- Sample Page removed
- Hello world removed
- Scanner integration = NO
- Real payment = NO
- Production Secret = NO
- VPS writes = 0

Workflow evidence:

```text
Repository: entropy-student/spike.skill
Workflow: Conversion Leak Audit G1 WordPress Baseline
Run ID: 35237395508
Commit: eae557fa643e7082aa18ecb99f72f4e9633606bc
Conclusion: success
```

Latest recovery asset check before document migration:

```text
WordPress asset checks = 20 / 20 PASS
```

## Security / package recovery

Final handoff snapshot security scan before GitHub doc migration:

```text
High-confidence Secret hits = 0
Private-key files           = 0
Live .env files             = 0
Absolute sandbox refs       = 0
```

A `.env.example` with local placeholder values is allowed; real Secrets remain forbidden from GitHub.

## G4 Repository Reconciliation Evidence — 2026-09-22

Gate: `G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`

### Repository and provenance

- Clean project-scoped workspace: `C:/Users/34707/Documents/ChatGPT/VPS基建/workspaces/conversion-leak-audit-g4/`
- Source repository: `https://github.com/entropy-student/project.git`
- Base fetched from `origin/main`: `746a4882d9511ab103713b9ae1d6bd2d5e8ebfaa`
- Fetch window: `2026-09-22T11:43:36.1486203Z` → `2026-09-22T11:43:38.8237575Z`.
- Old shared worktree: `main` at `98a7d3d4c8cd9851f4780a70c63c89ee3f57b092`; relation to fetched `origin/main`: `0` commits ahead / `31` commits behind.
- Dedicated branch: `codex/g4-repository-reconciliation`
- Old shared worktree was read-only for this reconciliation after fetch; no sibling project was migrated or modified.
- Sparse materialization contains `conversion-leak-audit/` only; sibling projects are not present in the clean workspace.
- Recovery package path supplied for source recovery: `C:/Users/34707/Downloads/conversion-leak-audit-final-2026-09-17(1).zip`; provenance `canonical final handoff package 2026-09-17`.
- Recovery SHA256 recorded during source recovery: `e5c3aa1da7a8fe5a431eade38f2b45fc48862b21470e413f4a034f150f59df03` (`MATCH`).
- Temporary extraction root: `C:/Users/34707/AppData/Local/Temp/conversion-leak-audit-g4-recovery-250295bb915c4be7a215c9ff297e2b4c/`
- Restored source paths: `conversion-leak-audit/scanner/` and `conversion-leak-audit/wordpress-g1-baseline/`.
- Current GitHub governance and Reviewer-owned documents were preserved from `origin/main`; old package management documents were not copied over them.

### Reconciliation and regression commands

Scanner, from the clean workspace:

```text
C:/Users/34707/AppData/Local/Temp/conversion-leak-audit-g4-scanner-venv-cd9cd9709dd74b2b8515cf04a1010fc2/Scripts/python.exe -m pytest -q
....................................................... [100%]
55 passed
```

WordPress baseline, from the clean project root:

```text
py -3.12 .\\wordpress-g1-baseline\\acceptance\\run_asset_checks.py
TOTAL=20 PASS=20 FAIL=0
```

The regression runs were completed after restoring the canonical source trees and before committing the reconciled workspace. No business-code change was made after those regression runs.

### G4 local integration

The local-only synthetic loop was executed with a clean WordPress runtime on port `8082` and a fixture Scanner on port `8123`:

```text
NODE_PATH=C:/Users/34707/AppData/Local/Temp/cla-g4-playwright/node_modules
CLA_WORDPRESS_BASE=http://127.0.0.1:8082/
node .\\g4-wordpress-integration\\tests\\g4_browser_test.cjs
```

Observed assertions:

- Landing page and form: PASS.
- URL → Scanner job → `scan_id` → bounded status polling → report: PASS.
- Deterministic Top 3 order for three findings: `CORE-007`, `PHYS-002`, `PHYS-001`.
- Zero, one, and two findings: PASS; no fabricated findings.
- Incomplete, blocked, and rate-limited scans: PASS; Top 3 withheld.
- Scanner timeout: PASS; polling terminated within the bound.
- Unsafe URL: PASS; fail closed.
- Scanner unavailable: PASS; user-facing error path observed.
- Evidence traceability and `scan_id` binding: PASS.
- Payment actions: `0`; VPS writes: `0`; production secrets: `0`.

Screenshots:

- `docs/evidence/g4-screenshots/g4-desktop-landing.png`
- `docs/evidence/g4-screenshots/g4-desktop-demo-results.png`
- `docs/evidence/g4-screenshots/g4-mobile-two-results.png`

### Scope and change summary

- Migrated only G4-owned `scanner/`, `wordpress-g1-baseline/`, `g4-wordpress-integration/`, and G4 screenshots into the clean project workspace.
- Applied the existing G4 local wiring for Scanner base URL and WordPress overlay mounts; no architecture redesign and no change to the 17 frozen Scanner-rule semantics.
- Added no Payment, PayPal, Unified Pay, checkout, entitlement, VPS, production-secret, public-scanner, new-rule, or G5 LLM behavior.
- Local `.env`, Docker runtime state, SQLite runtime state, and Python caches are excluded from the commit.

Known limitation: this is a local synthetic integration and is not a public production deployment. Owner intervention required: `NO`.

Recommended Reviewer decision: `REVIEW_G4_PASS_CANDIDATE_REPOSITORY_RECONCILED`.

Candidate result: `PASS_CANDIDATE_G4_REPOSITORY_RECONCILED`.

Initial reconciliation commit: `0d86710` (`conversion leak audit: reconcile G4 workspace`).

## G4 Contract Completion Corrections — 2026-09-22

Reviewer return: `RETURN_G4_CONTRACT_COMPLETION_REQUIRED`

The dedicated branch was rebased onto the latest fetched `origin/main` at `99e5685a3e18e1c92bb3530f1e375c14642ea668`. The current branch preserves the latest Reviewer-owned `PROJECT_RECORD.md`, `CURRENT_STATUS.json`, `REVIEWER_HANDOFF.md`, and `REVIEWER_DECISION_G4_CONTRACT_COMPLETION_RETURN.md` byte-for-byte from `origin/main` before Executor evidence updates.

Dedicated branch: `codex/g4-repository-reconciliation`  
Correction implementation commit: `62d1d70ac6e697745a375fb3c257152091204208`

### R1 — Real Scanner canary

Command:

```text
NODE_PATH=C:/Users/34707/AppData/Local/Temp/cla-g4-playwright/node_modules
CLA_WORDPRESS_BASE=http://127.0.0.1:8082/
CLA_REAL_CANARY_URL=http://1.1.1.1/
node .\\g4-wordpress-integration\\tests\\real_scanner_canary.cjs
```

Result: `PASS`.

- WordPress form created a real Scanner job and preserved real `scan_id`: `fc90bb4e362c4b4db2941f07a46d58f1`.
- Real terminal state: `AUDIT_INCOMPLETE`; report retrieval: `200`; report pages: `1`.
- Report schema compatible: `requested_url`, `pages`, and `decisions` validated.
- Evidence-less `ISSUE`: `0`.
- The initial `https://example.com/` attempt was correctly rejected by the local DNS safety gate because this environment resolved it to `198.18.0.24`; no unsafe target bypass was introduced. The successful canary used the public IP literal `http://1.1.1.1/` and required no login, payment, or production access.

### R2 — Real backend PRIORITIZING

- `scanner/app/services/runner.py` now persists `PRIORITIZING` after rule matching and before `COMPLETE` / `INCOMPLETE`.
- `g4-wordpress-integration/tests/test_real_prioritizing_state.py`: `1 passed`.
- Asserted backend phase sequence: `CHECKING_ACCESS → READING_PAGES → MATCHING_EVIDENCE → PRIORITIZING → COMPLETE`.
- Browser mapping uses the backend phase and canonical copy: `Checking access`, `Reading pages`, `Analyzing with trusted rules`, `Finalizing results`.
- Frozen 17-rule semantics and rule fixtures were not changed.

### R3 — Analytics contract

The browser adapter now emits the frozen event properties from `design/ANALYTICS_EVENT_CONTRACT.md`:

- `landing_view`: `referrer_type`, `campaign_source`, `device_class`, `locale`.
- `scan_started`: privacy-safe SHA-256 `site_id_hash`, host class, device class, source page.
- `scan_completed`: `site_id_hash`, pages checked, finding count, Top 3 availability, duration bucket.
- `top3_viewed`: `site_id_hash`, count, duration bucket.
- `issue_expanded`: `site_id_hash`, rule id, priority rank, finding type.
- `scan_incomplete.reason` is normalized to the frozen public enum: `RATE_LIMITED`, `BLOCKED`, `LOGIN_REQUIRED`, `JS_INCOMPLETE`, `GEO_CONTEXT_MISMATCH`, `SITE_UNAVAILABLE`, `UNKNOWN_FAILURE`.
- Full scanned URLs are absent from analytics properties; `checkout_started` and `payment_completed` are not emitted.
- Automated browser assertions: `analytics_event_contract = PASS`.

### R4 — Functional acceptance

`g4-wordpress-integration/tests/g4_browser_test.cjs` explicitly passes:

- `refresh_result_page`;
- `analytics_event_contract`;
- real-backend phase mapping through the fixture response path;
- `mobile_form_submit`;
- existing valid, unsafe, unavailable, incomplete, timeout, zero, one, two, evidence, and no-payment cases.

### R5 — Golden Demo fidelity

The synthetic fixture now returns exactly:

```text
/
/products/example
/cart
/faq
```

with exactly `CORE-007`, `PHYS-002`, `PHYS-001` in frozen order. The UI asserts and displays:

```text
3 confirmed findings
17 trusted checks
Synthetic Demo
```

Evidence detail resolves all four fixture pages; no `/products/demo` source remains in the G4 fixture.

### R6 — Screenshot evidence

Playwright generated the complete required pack at `1440×900` and `390×844`:

- `docs/evidence/g4-screenshots/g4-desktop-landing.png`
- `docs/evidence/g4-screenshots/g4-desktop-progress.png`
- `docs/evidence/g4-screenshots/g4-desktop-demo-results.png`
- `docs/evidence/g4-screenshots/g4-desktop-incomplete.png`
- `docs/evidence/g4-screenshots/g4-mobile-landing.png`
- `docs/evidence/g4-screenshots/g4-mobile-progress.png`
- `docs/evidence/g4-screenshots/g4-mobile-demo-results.png`
- `docs/evidence/g4-screenshots/g4-mobile-two-results.png`

Evidence detail remains covered in the desktop Golden Demo screenshot/test path.

### R7 — Frozen visual direction

Only the G4 accent tokens were corrected: clean white canvas, deep navy text, blue primary action/accent and blue soft state. No broad UI redesign was performed. The generated desktop result screenshot visually confirms blue primary/action direction.

### Final verification

```text
Scanner canonical regression       = 55/55 PASS
WordPress asset regression          = 20/20 PASS
G4 real PRIORITIZING test          = 1 PASS
fixture-backed G4 suite             = PASS
real Scanner canary                 = PASS
analytics contract                  = PASS
refresh result page                  = PASS
Golden Demo fidelity                 = PASS
required screenshot pack             = COMPLETE
PAYMENT_ACTIONS                     = 0
VPS_WRITES                          = 0
PRODUCTION_SECRETS                  = 0
OUT_OF_SCOPE_CHANGES                = 0
```

Architecture remains the existing local WordPress → Scanner → Top 3 loop. No Payment, PayPal, Unified Pay, checkout, entitlement, VPS, production Secret, public production Scanner, new Scanner rules, or G5 LLM behavior was added. Local `.env`, Docker runtime state, SQLite state, and generated caches remain uncommitted.

Recommended Reviewer decision: `REVIEW_G4_PASS_CANDIDATE_G4_CONTRACT_COMPLETE`.

Candidate result: `PASS_CANDIDATE_G4_CONTRACT_COMPLETE`.

## G4.5 Visual Editability Rework — 2026-09-23

Gate: `G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

Reviewer return followed `docs/G4_5_VISUAL_EDITABILITY_REWORK_CONTRACT.md`. Work was performed in the clean sparse project workspace on branch `codex/g4-5-visual-editability-rework`, based on the fetched latest `origin/main`. The old shared monorepo worktree and all sibling projects were not used for implementation.

### Files changed

Only `conversion-leak-audit/**` was changed:

- `g4-wordpress-integration/conversion-leak-audit-g4.php`
- `g4-wordpress-integration/conversion-leak-audit-g4.js`
- `g4-wordpress-integration/conversion-leak-audit-g4.css`
- `wordpress-g1-baseline/content/pages/home.html`
- `wordpress-g1-baseline/scripts/seed-content.php`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/style.css`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/theme.json`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/templates/front-page.html`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/templates/page.html`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/parts/header.html`
- `wordpress-g1-baseline/wp-content/themes/conversion-leak-audit-child/parts/footer.html`
- this evidence file and `docs/EXECUTOR_HANDOFF.md`

Generated Python caches, local SQLite state, WordPress runtime files, Docker state, and temporary browser scripts remain uncommitted. Reviewer-owned governance documents were not modified.

### Architecture and bounded corrections

- Removed the Home full `the_content` replacement. Gutenberg now owns static Home copy and section order; the Scanner remains mounted through the `[cla_scan_placeholder]` shortcode.
- Kept REST wiring, scan creation, bounded polling, real backend progress mapping, deterministic Top 3, evidence detail, analytics, and safety behavior in the integration layer.
- Reduced default Top 3 density to priority/rule, title, concise observed fact, first move, and expandable details/evidence. Expanded evidence retains source, references, Scanner decision, and limitation.
- Kept the four real public progress stages and canonical English copy; no fake percentage or frontend timer was added.
- Replaced template navigation/footer remnants with the real project navigation and minimal footer. Pretty routes use `/how-it-works/`, `/demo/`, `/pricing/`, `/faq/`, and `/blog/`.
- Preserved the frozen 17-rule semantics, four-page Golden Demo fixture, claim boundaries, and blue/navy/white visual direction.

### Commands and results

```text
Python312 -m pytest -q scanner/                         = 55/55 PASS
Python312 -X utf8 acceptance/run_asset_checks.py        = 20/20 PASS
Python312 -m pytest -q g4-wordpress-integration/tests/test_real_prioritizing_state.py = 1 PASS
g45_functional.py                                      = PASS
editable_proof.py                                      = OWNER_EDITABILITY_PROOF=PASS
real_canary.py                                         = REAL_SCANNER_CANARY=PASS
```

The fixture-backed browser suite passed `G4_INTEGRATION`, `PRETTY_ROUTES`, `ANALYTICS_CONTRACT`, `REAL_PRIORITIZING_STATE`, `GOLDEN_DEMO`, `REFRESH_RESULT`, and `MOBILE_FORM_SUBMIT`; `PAYMENT_ACTIONS=0`. The real local canary used the safe public target `http://1.1.1.1/` and proved WordPress → real Scanner POST → real `scan_id` → bounded polling → terminal `AUDIT_INCOMPLETE` → report retrieval/schema compatibility, with `EVIDENCE_LESS_ISSUE=0`.

The reversible Gutenberg proof changed a harmless Home claim-boundary text block, saved it, observed the changed text on the frontend, restored the original text, and observed the restored frontend text. No temporary proof text is committed.

### Screenshot evidence

Playwright with Chrome, `deviceScaleFactor=1`, reduced motion, and no DevTools generated the temporary package:

`C:\Users\34707\Documents\ChatGPT\VPS基建\conversion-leak-audit-g4-5-owner-editable-visual-review.zip`

The package contains 17 PNG files plus `MANIFEST.md`: Home desktop/mobile viewport and full page, progress desktop/mobile, Top 3 desktop/mobile viewport and full page, evidence desktop/mobile, incomplete desktop/mobile, Pricing full page, Home editor, and Site Editor. It contains no source, runtime, cookies, database, environment file, password, or secret. `WORDPRESS_OWNER_EDITABILITY=FULL_FOR_STATIC_CONTENT_AND_LAYOUT`.

### Final verification and risks

```text
SCANNER_REGRESSION       = 55/55 PASS
WORDPRESS_REGRESSION     = 20/20 PASS
G4_INTEGRATION           = PASS
REAL_SCANNER_CANARY      = PASS
ANALYTICS_CONTRACT       = PASS
GOLDEN_DEMO              = PASS
OWNER_EDITABILITY_PROOF  = PASS
PRETTY_ROUTES            = PASS
SCREENSHOT_PACKAGE       = READY
PAYMENT_ACTIONS          = 0
VPS_WRITES               = 0
PRODUCTION_SECRETS       = 0
OUT_OF_SCOPE_CHANGES     = 0
```

Known limitations: the WordPress/Scanner environment is local-only; no payment, VPS, production secret, or public production Scanner path was exercised. Visual acceptance remains a Reviewer decision. Owner intervention required: `NO`.

Implementation and first evidence commit: `dba52f8` (`conversion leak audit: rework G4.5 visual editability`). Recommended Reviewer decision: `REVIEW_G4_5_OWNER_EDITABLE_VISUAL_REWORK`.

Candidate result: `PASS_CANDIDATE_G4_5_OWNER_EDITABLE_VISUAL_REWORK`.
