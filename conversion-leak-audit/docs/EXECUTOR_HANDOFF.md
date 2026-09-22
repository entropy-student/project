# Conversion Leak Audit — EXECUTOR HANDOFF

> Intended executor: Codex / local development agent
> Current State: `G4_5_PASS_G4_6_READY_FOR_EXECUTION`

## Reviewer authorization

```text
PASS_G3_5_UI_GROWTH_DESIGN_FREEZE
G4_RELEASED_TO_CODEX=YES
```

You may begin G4.

## Read First

1. `../PROJECT_RECORD.md`
2. `../CURRENT_STATUS.json`
3. `REVIEWER_HANDOFF.md`
4. `G4_EXECUTION_CONTRACT.md`
5. `G3_5_UI_GROWTH_FREEZE.md`
6. `../design/FINAL_GOLDEN_SCREEN_SPEC.md`
7. `../design/DEMO_FIXTURE_GOLDEN.md`
8. `../design/FUNCTIONAL_ACCEPTANCE.md`
9. `../design/VISUAL_ACCEPTANCE.md`
10. `HANDOFF_PROTOCOL.md`

## Mandatory source-baseline precheck

Before changing any product source:

1. Locate the existing reviewed `scanner/` and `wordpress-g1-baseline/` trees.
2. Record their workspace-relative roots.
3. Record source provenance and revision: Git repository/ref/commit when tracked; otherwise the existing snapshot/provenance identifier available locally.
4. Rerun and record the frozen pre-change regression commands/results.
5. Confirm the baseline corresponds to the previously reviewed G1/G2 assets.

If either source tree is missing, recreated, ambiguous, or cannot be tied to the validated baseline:

`RETURN_G4_SOURCE_BASELINE_UNRESOLVED`

Stop at Reviewer. Do not rebuild G1/G2 as a substitute.

## Reviewer-resolved recovery source — 2026-09-22

The previous local precheck returned `RETURN_G4_SOURCE_BASELINE_UNRESOLVED` correctly because the source trees were absent from that workspace.

Reviewer has now recovered and independently verified the canonical package:

`conversion-leak-audit-final-2026-09-17.zip`

Expected SHA256:

`e5c3aa1da7a8fe5a431eade38f2b45fc48862b21470e413f4a034f150f59df03`

It contains the canonical handoff snapshots:
- `conversion-leak-audit/scanner/`
- `conversion-leak-audit/wordpress-g1-baseline/`

After Owner places this package in the local workspace, Executor must:

1. Verify the ZIP SHA256 exactly.
2. Extract/restore only the canonical `scanner/` and `wordpress-g1-baseline/` trees into the project workspace; do not reconstruct them from Skill validation files.
3. Record the restored workspace-relative paths and package provenance.
4. Run Scanner regression from `scanner/`: `python -m pytest -q` (expected 55/55).
5. Run WordPress asset regression: `python wordpress-g1-baseline/acceptance/run_asset_checks.py` (expected 20/20).
6. If both pass, continue G4 under the existing contract. If checksum or either regression differs, stop at Reviewer.

## Execute

Implement only:

```text
WordPress form
→ Scanner job create API
→ scan_id
→ status polling
→ honest progress states
→ Scanner report
→ deterministic Top 3
→ evidence detail
→ WordPress free result page
```

Full requirements and tests are canonical in:

`G4_EXECUTION_CONTRACT.md`

## Source assets

Use the reviewed local trees:
- `scanner/`
- `wordpress-g1-baseline/`

Do not recreate G1/G2.

Before edits, record current regression results. After edits, rerun them.

## Visual rule

Implement the frozen design; do not invent a new UI direction.

`clone-ui` may only provide reference extraction. Do not paste a cloned site over the validated product architecture.

Generated mockup text is not authoritative. GitHub design contracts are authoritative.

## Forbidden in G4

Do not implement:
- PayPal / payment;
- Unified Pay;
- checkout / entitlement;
- LLM full report;
- VPS / domain / HTTPS;
- production Secrets;
- public production scanner;
- new Scanner rules;
- unrelated WordPress plugin stack.

## Completion

Update `EXECUTION_EVIDENCE.md` with:

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

Candidate result:

`PASS_CANDIDATE_G4_LOCAL_FREE_LOOP`

Do not declare final PASS yourself. Reviewer will read GitHub evidence and decide.

## G4 Repository Reconciliation — 2026-09-22

The prior G4 implementation was reconciled into a new clean project-scoped workspace based on the fetched `origin/main` at `746a4882d9511ab103713b9ae1d6bd2d5e8ebfaa`. The dedicated branch is `codex/g4-repository-reconciliation`. The old shared monorepo worktree was not reset, cleaned, checked out, staged, committed, or otherwise modified beyond the required remote fetch.

Initial reconciliation commit: `0d86710` (`conversion leak audit: reconcile G4 workspace`).

Only the `conversion-leak-audit/` sparse project was materialized. The canonical `scanner/` and `wordpress-g1-baseline/` trees were restored from the final handoff recovery package, with provenance and SHA256 recorded in `docs/EXECUTION_EVIDENCE.md`. Reviewer-owned governance documents were preserved from the current GitHub checkout.

Clean-workspace verification:

- Scanner frozen regression: `55 passed`.
- WordPress asset regression: `TOTAL=20 PASS=20 FAIL=0`.
- G4 browser integration: landing, job creation, `scan_id` binding, bounded polling, report rendering, deterministic Top 3, evidence traceability, unsafe URL fail-closed, unavailable/timeout, blocked/rate-limited/incomplete, zero/one/two findings: PASS.
- G4 screenshots: `docs/evidence/g4-screenshots/`.
- Payment actions, VPS writes, and production secrets: `0`.

Files changed are limited to the `conversion-leak-audit/**` project scope and are listed by the reconciliation commit. Local `.env`, Docker runtime state, SQLite state, and generated caches are not committed.

Recommended Reviewer decision: `REVIEW_G4_PASS_CANDIDATE_REPOSITORY_RECONCILED`.

Candidate result: `PASS_CANDIDATE_G4_REPOSITORY_RECONCILED`.

Do not declare final G4 PASS. Stop at Reviewer after the dedicated branch is pushed.

## G4 Contract Completion Corrections — 2026-09-22

The dedicated branch was updated from the latest `origin/main` at `99e5685a3e18e1c92bb3530f1e375c14642ea668` by rebase. Latest Reviewer-owned governance was preserved; only Executor-owned implementation, tests, screenshots, and evidence are changed.

Correction implementation commit: `62d1d70ac6e697745a375fb3c257152091204208`.

Completed bounded corrections:

- Real Scanner canary through WordPress: PASS; terminal `AUDIT_INCOMPLETE`, report schema compatible, evidence-less ISSUE `0`.
- Real Scanner backend `PRIORITIZING`: PASS; standalone phase test and fixture browser mapping cover it.
- Analytics contract: PASS; frozen incomplete enum, privacy-safe site hash, no full URL, no payment events.
- Functional acceptance: refresh result, analytics contract, real prioritizing mapping, and mobile form submit are explicit tests and pass.
- Golden Demo: exact four-page fixture `/`, `/products/example`, `/cart`, `/faq`; exact three findings and required summary.
- Screenshot pack: desktop Home/Progress/Top 3/Incomplete plus mobile Home/Progress/Top 3 complete.
- Visual drift: primary action/accent returned to blue/deep navy direction without broad redesign.

Final clean-workspace verification:

```text
Scanner regression = 55/55 PASS
WordPress regression = 20/20 PASS
fixture-backed G4 suite = PASS
real Scanner canary = PASS
analytics contract = PASS
Golden Demo = PASS
screenshot evidence = COMPLETE
PAYMENT_ACTIONS=0
VPS_WRITES=0
PRODUCTION_SECRETS=0
OUT_OF_SCOPE_CHANGES=0
```

Recommended Reviewer decision: `REVIEW_G4_PASS_CANDIDATE_G4_CONTRACT_COMPLETE`.

Candidate result: `PASS_CANDIDATE_G4_CONTRACT_COMPLETE`.

Executor does not declare final G4 PASS. Push the dedicated branch and stop at Reviewer.


## Reviewer release — G4.5

G4 final decision:

`PASS_G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`

G4 implementation is merged to `main` through PR #2.

Current authorized Gate:

`G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

Read and execute:

`G4_5_ACCEPTANCE_CONTRACT.md`

Do not expand into G5, payment, VPS, domain/HTTPS, production Secret, or public production Scanner.

Candidate:

`PASS_CANDIDATE_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

Then `STOP_AT_REVIEWER`.

## G4.6 Acquisition / SEO Readiness — 2026-09-23

```text
BASE_MAIN=8e0f044541598a1eee6a304df8a7c6b6368bf473
BRANCH=codex/g4-6-acquisition-seo-readiness
IMPLEMENTATION_COMMIT=c26f9ca089b3020beb8f991b0a9a53bc697d5f26
```

The final fetch confirmed `origin/main` is still BASE_MAIN and there are no newer `conversion-leak-audit/**` governance or product changes to synchronize. Work took place in a fresh, clean, project-scoped sparse workspace. No sibling project or main branch was changed.

Candidate verification summary:

```text
MESSAGE_READINESS=PASS
DEMO_PROOF=PASS
NAV_READINESS=PASS
HOME_META=PASS; HOW_IT_WORKS_META=PASS; DEMO_META=PASS; FAQ_META=PASS
CANONICAL=PASS
SCAN_RESULT_NOINDEX=PASS
SCAN_RESULT_CANONICAL_HOME=PASS
SITEMAP=PASS; SITEMAP_UNFINISHED_SURFACES_EXCLUDED=PASS
ROBOTS_READINESS=PASS
H1_SANITY=PASS
PUBLIC_INTERNAL_TERMS=0
BLOG_PRIMARY_NAV=HIDDEN; BLOG_NOINDEX=PASS; BLOG_SITEMAP_EXCLUDED=PASS
PRICING_PRIMARY_NAV=HIDDEN; PRICING_NOINDEX=PASS; PRICING_SITEMAP_EXCLUDED=PASS
ANALYTICS_CONTRACT=PASS
SCANNER_REGRESSION=55/55 PASS
WORDPRESS_REGRESSION=20/20 PASS
SEO_READINESS_ACCEPTANCE=43/43 PASS
G4_BROWSER_REGRESSION=PASS
PAYMENT_ACTIONS=0; VPS_WRITES=0; PRODUCTION_SECRETS=0
OUT_OF_SCOPE_CHANGES=0
```

New repeatable acceptance: `wordpress-g1-baseline/acceptance/run_seo_readiness_checks.py`. Local screenshot set (4 PNGs) and detailed readiness/production-deferred evidence are under `docs/evidence/g4-6-screenshots/` and `docs/evidence/G4_6_SEO_READINESS.md`. The site remained local-only at `http://127.0.0.1:8084/`; no production host, payment, VPS, or secret was used. Scanner rules and semantics are unchanged.

Known limitation: metadata, canonical, sitemap, robots, and page content were validated on local WordPress; production-domain crawl/index behavior and the explicitly deferred production checklist have not been exercised. Owner action: `NONE`. Recommended Reviewer decision: `REVIEW_G4_6_ACQUISITION_SEO_READINESS`.

Candidate result: `PASS_CANDIDATE_G4_6_ACQUISITION_SEO_READINESS`. Executor does not declare Gate PASS. Push only the dedicated branch, do not merge main, and `STOP_AT_REVIEWER`.

## G4.5 Visual Editability Rework — 2026-09-23

Gate: `G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

The bounded rework was executed in a new clean sparse workspace on the dedicated branch `codex/g4-5-visual-editability-rework`, from the latest fetched `origin/main`. The existing shared monorepo was not reused for implementation, and no sibling project was changed.

Completed:

- Home static content and section order now remain in Gutenberg; dynamic Scanner behavior remains in the shortcode/integration layer.
- Home hierarchy brings the scan surface forward on mobile and subdues the decorative report preview.
- Top 3 defaults to priority/rule, title, concise observed fact, first move, then expandable details/evidence. Evidence remains available and traceable.
- Progress remains four-stage, backend-driven, and percentage-free.
- Project navigation and minimal footer use only real routes/pages; template residual SaaS copy is removed.
- Secondary pages use a shared content width, spacing, hierarchy, and navy/blue direction.
- Pretty route verification passed for `/how-it-works/`, `/demo/`, `/pricing/`, `/faq/`, and `/blog/`.
- Reversible Home Gutenberg edit proof passed: save → frontend changed → restore → frontend restored.
- Screenshot package was generated outside Git and contains only screenshots and `MANIFEST.md`.

Verification:

```text
SCANNER_REGRESSION=55/55 PASS
WORDPRESS_REGRESSION=20/20 PASS
G4_INTEGRATION=PASS
REAL_SCANNER_CANARY=PASS
ANALYTICS_CONTRACT=PASS
GOLDEN_DEMO=PASS
REFRESH_RESULT=PASS
MOBILE_FORM_SUBMIT=PASS
OWNER_EDITABILITY_PROOF=PASS
PRETTY_ROUTES=PASS
PAYMENT_ACTIONS=0
VPS_WRITES=0
PRODUCTION_SECRETS=0
OUT_OF_SCOPE_CHANGES=0
```

Real canary evidence: safe public target `http://1.1.1.1/`; terminal state `AUDIT_INCOMPLETE`; report pages `1`; `EVIDENCE_LESS_ISSUE=0`. Fixture evidence: exact Golden Demo pages `/`, `/products/example`, `/cart`, `/faq` and exact findings `CORE-007`, `PHYS-002`, `PHYS-001`.

WordPress editability target achieved: `WORDPRESS_OWNER_EDITABILITY=FULL_FOR_STATIC_CONTENT_AND_LAYOUT`. The runtime local admin and runtime credentials are intentionally not recorded in GitHub evidence.

Screenshot package:

`C:\Users\34707\Documents\ChatGPT\VPS基建\conversion-leak-audit-g4-5-owner-editable-visual-review.zip`

Implementation and first evidence commit: `dba52f8` (`conversion leak audit: rework G4.5 visual editability`).

Recommended Reviewer decision: `REVIEW_G4_5_OWNER_EDITABLE_VISUAL_REWORK`.

Candidate result: `PASS_CANDIDATE_G4_5_OWNER_EDITABLE_VISUAL_REWORK`.

Executor does not declare G4.5 PASS. Dedicated branch should be pushed and execution should stop at Reviewer.

## G4.5 Final Polish — 2026-09-23

Reviewer returned `RETURN_G4_5_FINAL_POLISH_ONLY`. Final pre-push fetch resolved latest `origin/main` to `bb61e42d0644ba07f4681f985136c275c4ad8861`; main's only project-path changes since the branch base were `CURRENT_STATUS.json` and the Reviewer final-polish decision. Later main commits added no `conversion-leak-audit/**` changes. The dedicated branch `codex/g4-5-visual-editability-rework` was safely rebased onto that tip; it was not merged to main.

Final bounded corrections:

- Removed `$29 planned launch price` and customer-facing G1 / checkout / Gate language from Pricing and its static preview. Retained `Free preview`, `$0`, `Full fix queue`, and `Planned paid expansion`. No payment button or action exists.
- Reduced Home H1 size and hero spacing, subdued the decorative preview, and tuned shared secondary-page, header, and mobile navigation spacing. Scanner behavior and Top 3/Evidence structure remain unchanged.
- Captured Site Editor from a real authenticated local Administrator session. WP-CLI verified the `cla_admin` role; the password is not stored in repository evidence or screenshot package.

Verification:

```text
SCANNER_REGRESSION=55/55 PASS
WORDPRESS_REGRESSION=20/20 PASS
G4_INTEGRATION=PASS
PRETTY_ROUTES=PASS (all six routes HTTP 200)
OWNER_EDITABILITY_PROOF=PASS
SITE_EDITOR_ACCESS=PASS_AUTHENTICATED_ADMIN
PRICING_PUBLIC_COPY=PASS
PAYMENT_ACTIONS=0
OUT_OF_SCOPE_CHANGES=0
VPS_WRITES=0
PRODUCTION_SECRETS=0
```

Final screenshot ZIP:

`C:\Users\34707\Documents\ChatGPT\VPS基建\conversion-leak-audit-g4-5-final-visual-review.zip`

It contains the 10 requested PNG screenshots and `MANIFEST.md` only. The progress image captured backend `MATCHING_EVIDENCE`; the Top 3 and mobile Evidence screenshots show the actual result/detail surfaces. The authenticated Site Editor is visible without login fields or password.

Recommended Reviewer decision: `REVIEW_G4_5_FINAL_POLISH_COMPLETE`.

Candidate result: `PASS_CANDIDATE_G4_5_FINAL_VISUAL_COMPLETE`.

Executor does not declare G4.5 PASS. Push the rebased dedicated branch and stop at Reviewer.


## Reviewer release — G4.6

G4.5 final decision:

`PASS_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`

G4.5 implementation is merged to `main` through PR #3.

Current authorized Gate:

`G4_6_ACQUISITION_SEO_READINESS`

Read and execute:

`G4_6_ACQUISITION_SEO_READINESS_CONTRACT.md`

This Gate may modify Message / Proof / Demo / navigation visibility / SEO metadata / canonical / robots / sitemap behavior and related readiness tests.

Do not:
- reopen G4.5 visual structure;
- bulk-generate blog content;
- add payment;
- touch VPS/domain/HTTPS;
- add new Scanner rules;
- build G5 Full Fix Queue / LLM report.

Candidate:

`PASS_CANDIDATE_G4_6_ACQUISITION_SEO_READINESS`

Then `STOP_AT_REVIEWER`.
