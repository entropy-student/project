# G3CR7R1 — Executor Reproduction of Three Frontend Surfaces

## Gate

```text
GATE_ID=G3CR7R1_EXECUTOR_REPRODUCTION
OBJECTIVE=Independently reproduce and validate the three Owner-approved frontend surfaces using the accepted pre-implementation source baseline; prior Reviewer-authored prototype is reference-only
MAX_ENDPOINT_THIS_ROUND=Fresh Executor implementation on PR #64 + local-runtime evidence + PASS_CANDIDATE; stop before backend draft persistence, production generation, real payment, production deployment, P1-P12, or PR merge
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin/** plus project-scoped EXECUTION_EVIDENCE / EXECUTOR_HANDOFF only
APPLICABLE_CRITICAL_CONSTRAINTS=FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; WOO_COMMERCE_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Git restore to accepted G3CR7R1 source baseline e71f94377d341a88ba388f2c5da153e7cd6ee8b8 for target implementation paths; preserve prior accepted homepage files and PR history
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.7**.

Triggered specialist section:
- **11E Provider / Payment** because the frontend must preserve WooCommerce payment truth and must not invent paid/generating state.
- 11A / 11B / 11C / 11D / 11F / 11G are not triggered by this local frontend reproduction Gate unless execution discovers a concrete condition that activates one; if uncertain, RETURN to Reviewer rather than expanding scope.

## PREFLIGHT

Executor must prove before source mutation:

1. canonical repo is `entropy-student/project`;
2. project scope is `birthday-magazine-studio/**`;
3. work is isolated from unrelated monorepo changes;
4. PR #64 remains open/unmerged;
5. accepted target-file baseline is `e71f94377d341a88ba388f2c5da153e7cd6ee8b8`;
6. the two modified baseline files match:
   - `birthday-magazine-poc.php` blob `a677f5c321d9ac323c64b7efda73a57a37efe431`;
   - `preview.js` blob `bf60295a2236eb96e0c358158653b05b95b1f390`;
7. `home.css`, `studio.css`, and `magazine-preview.css` match the baseline blobs recorded in the Reviewer decision unless the Gate explicitly needs a bounded edit;
8. Reviewer-authored G3CR7 files/commits after the baseline are classified **REFERENCE_ONLY_NONAUTHORITATIVE**, not accepted source;
9. no real payment, Provider mutation, production deployment, Shared Infra, Secret, or P1-P12 action is required.

If any baseline fact cannot be proven, RETURN `RETURN_PREFLIGHT_DRIFT`.

## Product behavior to reproduce

Canonical flow:

```text
Homepage
-> Free Preview
-> Homepage / Preview CTA
-> Core function page
-> 12–25 photos + six required prompts
-> Review / Submit
-> WooCommerce checkout
-> post-payment generation/status shell
-> eventual complete magazine
```

### Surface A — Homepage entry
- highest visual bar of the three;
- bounded to the reserved core-function entry/offer area;
- must visually coordinate with the already accepted homepage;
- no global homepage redesign;
- CTA enters the core function page.

### Surface B — Core function page
Use a conventional full-page SaaS onboarding / multi-step form. Low-complexity reuse is preferred over bespoke interaction.

Required visible steps:
1. About them
2. Photos
3. Their story
4. The little things
5. Review -> checkout

Required visible behavior:
- recipient name / age / relationship / tone;
- 12–25 JPG/PNG/WebP selections;
- up to 3 must-use choices;
- all six required prompts from the MVP contract;
- validation before proceeding;
- review summary;
- handoff to canonical WooCommerce checkout.

This Gate may use browser-local photo state for the visual/runtime shell. It does **not** implement the canonical server-side temporary pre-payment draft.

### Surface C — payment / generation / success
- WooCommerce remains canonical checkout/payment UI;
- do not build a replacement payment form;
- order-received continuation may show intake received / payment confirmed / designing / QA / ready;
- paid/generating truth must come from authoritative WooCommerce order state when an order is involved;
- arbitrary query parameters must not be sufficient to claim paid or ready state;
- a clearly labeled visual-only ready fixture is allowed for UI QA if it cannot be confused with real production state.

## REQUIRED_EVIDENCE

Executor must write project-scoped Evidence containing:

1. `AUTHORIZED_GATE=G3CR7R1_EXECUTOR_REPRODUCTION`;
2. preflight facts including accepted baseline commit/blob identities;
3. exact changed files and why each changed;
4. source diff against the accepted baseline;
5. PHP lint for every changed PHP file using an actual PHP parser/runtime;
6. JavaScript syntax/static validation for every changed JS file;
7. desktop 1440px and mobile 375px runtime screenshots of:
   - homepage entry;
   - every intake step;
   - photo grid with >=12 local test images and must-use state;
   - review state;
   - generating/status state;
   - ready visual fixture if used;
   - Woo order-received continuation using only local/non-consequential fixtures;
8. browser console/error summary;
9. Free Preview regression proving its selected photo remains browser-local and no model/upload behavior was added there;
10. checkout handoff proof without submitting a checkout;
11. negative proof that forged URL/query state cannot claim authoritative paid status for an unpaid/foreign/nonexistent order;
12. rollback effect;
13. explicit counters:
   - real payments = 0;
   - checkout submissions = 0;
   - Provider mutations = 0;
   - model/generation calls = 0;
   - production deployments = 0;
   - Shared Infra mutations = 0.

Evidence must distinguish DIRECT_READBACK / BEHAVIORALLY_VERIFIED / INFERRED where relevant.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires all of the following:

1. Executor independently implemented/reproduced from the accepted baseline; prior Reviewer prototype is not promoted as baseline.
2. Homepage entry is coordinated with the accepted homepage and only bounded entry-area changes occur.
3. Core function page works as a coherent desktop/mobile five-step SaaS onboarding.
4. 12–25 photo rule, <=3 must-use, six prompts, validation, review, and checkout handoff are visible and behaviorally verified.
5. Free Preview retains its zero-upload / zero-model boundary.
6. WooCommerce remains the payment source of truth.
7. Status UI cannot be promoted to paid/generating by untrusted query parameters alone.
8. Actual PHP lint + JS validation pass.
9. Required runtime screenshots and browser checks are complete and reviewable.
10. No real payment/checkout submission/model/provider/deploy/Shared-Infra/P1-P12 action occurs.
11. Executor writes Evidence and a completion packet, then stops.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate: `docs/G3CR7R1_EXECUTOR_REPRODUCTION.md`;
2. product contract sections **2–4 and 11–13** in `docs/MVP_PRODUCT_CONTRACT.md`;
3. target source at baseline `e71f94377d341a88ba388f2c5da153e7cd6ee8b8`:
   - `poc/g3c/preview-plugin/birthday-magazine-poc.php`
   - `poc/g3c/preview-plugin/preview.js`
   - `poc/g3c/preview-plugin/home.css`
   - `poc/g3c/preview-plugin/studio.css`
   - `poc/g3c/preview-plugin/magazine-preview.css`
4. optional reference-only prototype at source head `0603706ca0441fb1cb65ff716f47f7a919e2e4f3`:
   - `frontend-flow.php`
   - `frontend-flow.css`
   - `frontend-intake.css`
   - `frontend-flow.js`
   - `frontend-intake-ui.js`
   - `frontend-intake.js`
   - prototype edits to `birthday-magazine-poc.php` and `preview.js`

Accepted facts Executor may rely on:
- homepage outside the reserved entry area is frozen/accepted;
- WooCommerce product 1113 is the canonical USD 39.99 product;
- local retained runtime is expected at `http://127.0.0.1:8189/`;
- current task is frontend/runtime reproduction only;
- no real payment or production generation is authorized.

Do **not** reread Governance, broadly scan REVIEWER_HANDOFF, or reconstruct project history. If a named fact is missing/contradictory, perform the smallest targeted read and RETURN to Reviewer if material.

The reference prototype may inform layout/wording, but its PASS labels, validation claims, and source identity are not Evidence for this Gate.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明实际实现/复现了什么。
验证：一句话总结 baseline、lint、desktop/mobile、Preview boundary、Woo truth checks。
问题：NONE，或明确阻塞原因。
回滚：一句话说明如何恢复到 e71f... 的 target-file baseline。
请 Reviewer 检查：源码 diff + EXECUTION_EVIDENCE + runtime screenshots。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter pre-payment draft persistence, production generation, P1-P12, real payment, production deployment, or PR merge.
