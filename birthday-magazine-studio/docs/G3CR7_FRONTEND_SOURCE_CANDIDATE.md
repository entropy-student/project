# G3CR7 — Three Frontend Surfaces Source Candidate

> Date: 2026-10-04
> Governance: vps-project-governance v0.2.7
> PR: #64
> Candidate head: `0603706ca0441fb1cb65ff716f47f7a919e2e4f3`

## Result

```text
EXECUTOR_RESULT=PASS_CANDIDATE_SOURCE_ONLY
HOMEPAGE_ENTRY_SOURCE=READY
CORE_FUNCTION_ONBOARDING_SOURCE=READY
POSTPAY_STATUS_SOURCE=READY
RUNTIME_VISUAL=UNVERIFIED
OWNER_VISUAL_ACCEPTANCE=PENDING
REAL_PAYMENT_ACTIONS=0
MODEL_OR_GENERATION_CALLS=0
PRODUCTION_DEPLOYMENT=0
P1_P12_BUILD=0
PR64_MERGE=0
```

## Implemented surfaces

1. **Homepage entry**
   - reuses the accepted `.bms-offer` area only;
   - CTA routes into the dedicated creator;
   - adds a restrained three-step route cue and magazine-object treatment;
   - no global homepage redesign.

2. **Core function page**
   - full-page SaaS-style five-step onboarding;
   - About them -> Photos -> Their story -> Little things -> Review;
   - visible 12–25 photo rule;
   - up to 3 local must-use selections;
   - six required story prompts;
   - review state and WooCommerce checkout handoff;
   - photos remain browser-local in this Gate: no draft persistence yet.

3. **Post-payment / status**
   - WooCommerce order-received may render the generation-status continuation;
   - dedicated generating/ready presentation shell also exists for visual review;
   - no production worker or model call is implemented.

## Changed source

Relative to the accepted G3CR7 opening head `e71f94377d341a88ba388f2c5da153e7cd6ee8b8`, changes are project-scoped to:

- `poc/g3c/preview-plugin/birthday-magazine-poc.php`
- `poc/g3c/preview-plugin/preview.js`
- `poc/g3c/preview-plugin/frontend-flow.php`
- `poc/g3c/preview-plugin/frontend-flow.css`
- `poc/g3c/preview-plugin/frontend-intake.css`
- `poc/g3c/preview-plugin/frontend-flow.js`
- `poc/g3c/preview-plugin/frontend-intake-ui.js`
- `poc/g3c/preview-plugin/frontend-intake.js`

## Verification

- all changed G3CR7 source files fresh-read successfully from PR #64;
- no truncation markers or merge-conflict markers found;
- all four changed JavaScript files parse successfully in V8;
- `frontend-flow.php` PHP lint: PASS;
- changed `birthday-magazine-poc.php` PHP lint: PASS;
- compare against G3CR7 opening head shows no non-project files;
- static reference previews at 1440px and 375px showed no horizontal overflow, but they are **reference-only**, not authoritative WordPress runtime evidence;
- Reviewer correction at `0603706c...`: free-Preview style is carried into intake, and payment/generation status is derived from WooCommerce paid truth rather than query-string claims.

## Reviewer source corrections

- The free Preview style choice now preselects the matching magazine style on the intake page.
- The dedicated status surface checks the signed-in order owner and WooCommerce `is_paid()` before displaying paid/generating truth.
- The Woo order-received continuation also derives paid state from the actual order.
- A forged `order_id` or `state=ready` query cannot promote an unpaid/foreign order into a paid/ready presentation.

## Remaining checkpoint

Formal G3CR7 PASS is blocked only on runtime visual readback:

- current PR head loaded in the retained local WordPress runtime;
- 1440px + 375px screenshots for homepage entry;
- all intake steps and photo state;
- generating + ready status;
- Woo order-received continuation;
- no checkout submission / real payment needed.

Stop after Owner visual review. Backend pre-payment draft persistence and P1-P12 remain separate later Gates.
