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

Reconciliation commit: `e3a7573` (`conversion leak audit: reconcile G4 workspace`).
