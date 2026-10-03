# G3CR3 — G3C Current Visual Evidence Closure

> Governance: VPS Project Governance v0.1.6 + active addenda  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE EVIDENCE CLOSURE AUTHORIZED**  
> Parent implementation: G3C Blocksy Wedding productization  
> PR: #64  
> G4 authority: **NONE**

## 1. Goal

Close only the current evidence gap for the already-implemented G3C page.

Do not redesign the site.

The closure must prove the **final corrected current branch/runtime**, especially 375px mobile behavior, and update stale PR metadata in branch evidence.

## 2. Required read order

1. `../REVIEWER_HANDOFF.md`
2. `REVIEWER_DECISION_G3C_PR64_INTERIM_RETURN.md`
3. `G3C_UI_UX_PRODUCTIZATION.md`
4. `G3C_BLOCKSY_WEDDING_EXECUTION_PACKET.md`
5. current PR #64 branch evidence
6. this closure

## 3. Existing runtime

Use the retained project-scoped G3C runtime.

Expected local site:

`http://127.0.0.1:8189/`

Do not reconstruct or reimport unless the runtime is no longer healthy.

Do not change theme/builder.

## 4. Required current screenshots

Capture the final corrected state, not historical screenshots:

```text
desktop-full-page.png
desktop-hero.png
desktop-preview.png
desktop-offer-faq.png
mobile-375-hero.png
mobile-375-preview.png
woo-product-or-cart.png
wp-admin-gutenberg-home.png
```

All content must remain synthetic/sample-safe.

## 5. 375px verification

At exactly 375px viewport width, verify:

- document width does not materially exceed viewport width;
- hero text remains readable;
- primary `Create a Free Preview` CTA is visible and usable;
- Free Preview form controls are visible/usable;
- preview output remains visible;
- no blocking overlap;
- no fixed/sticky element blocks core interaction;
- no fatal browser/page error.

Minor aesthetic differences are not failures.

If there is a blocking mobile regression, return:

`RETURN_G3CR3_MOBILE_375_REGRESSION`

## 6. Desktop current-state verification

Confirm the screenshots correspond to the same current code/state after final Hero/header/logo corrections.

No old screenshots may be relabeled.

## 7. PR/evidence reconciliation

Update branch evidence to replace stale submission state.

Must record:

```text
GITHUB_PR=64
GITHUB_PR_STATE=OPEN_UNMERGED
GITHUB_PR_CREATION_BLOCKER=RESOLVED_BY_REVIEWER
CURRENT_375_VIEWPORT_INDEPENDENTLY_VERIFIED=YES
CURRENT_SCREENSHOT_SET=PASS
```

Update:

- `poc/g3c/artifacts/reports/verification-g3c.json`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- screenshot manifest/readme as needed

Push to the **same branch / PR #64**.

## 8. Preserve Owner editing checkpoint

Do not tear down the runtime.

At success:

```text
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
OWNER_GUTENBERG_EDIT_ACCESS=PASS
OWNER_VISUAL_FREEZE=PENDING
```

## 9. Forbidden scope

```text
REDESIGN=0
THEME_CHANGE=0
BUILDER_CHANGE=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
G4_ACTIONS=0
```

## 10. Success return

```text
PASS_CANDIDATE_G3CR3_G3C_VISUAL_EVIDENCE_CLOSURE

PR_64=OPEN_UNMERGED
PR_CREATION_BLOCKER=RESOLVED

CURRENT_SCREENSHOT_SET=PASS
DESKTOP_CURRENT_STATE=PASS
MOBILE_375_UI=PASS
MOBILE_375_NO_BLOCKING_OVERFLOW=PASS
MOBILE_375_PREVIEW_USABLE=PASS

OWNER_GUTENBERG_EDIT_ACCESS=PASS
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
SHARED_INFRA_MUTATIONS=0

OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```
