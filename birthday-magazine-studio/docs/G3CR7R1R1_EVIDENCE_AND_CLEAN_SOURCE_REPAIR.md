# G3CR7R1R1 — Evidence and Clean-Source Repair

## Gate

```text
GATE_ID=G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR
OBJECTIVE=Close the two narrow G3CR7R1 Reviewer blockers without redesigning or replaying accepted frontend work
MAX_ENDPOINT_THIS_ROUND=Clean PR candidate source boundary + actual local Woo order-received continuation evidence + refreshed PASS_CANDIDATE
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin/** plus g3cr7r1 evidence and EXECUTION_EVIDENCE/EXECUTOR_HANDOFF only
APPLICABLE_CRITICAL_CONSTRAINTS=REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Restore current Executor candidate `88f45f5d...` if repair regresses; accepted target baseline remains `e71f943...`
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.7**.

Triggered specialist:
- **11E Provider / Payment** only.

## PREFLIGHT

1. Confirm PR #64 is open/unmerged.
2. Confirm current candidate descends from `88f45f5d712e3c1fe26f4386628703716b8eca3e`.
3. Confirm current Executor implementation uses `frontend-reproduction.php/css/js` and does not reference the six prior Reviewer prototype files.
4. Confirm no current-main Birthday Magazine drift invalidates this repair.
5. Confirm all Provider/payment/model/deploy/shared-infra counters are still zero before work.

## Repair A — clean accepted source boundary

Remove from the final plugin working tree the six **unused Reviewer-reference prototype files**:

- `frontend-flow.php`
- `frontend-flow.css`
- `frontend-flow.js`
- `frontend-intake.css`
- `frontend-intake-ui.js`
- `frontend-intake.js`

Do not rewrite Git history. Historical commits remain the audit record.

Then regenerate a **complete** source diff from accepted baseline `e71f943...` to the new candidate for the plugin target paths. The resulting diff must contain only the independent Executor implementation and intentional bounded baseline-file edits.

If any of the six files is unexpectedly referenced or required at runtime, do not delete it; RETURN to Reviewer with the exact dependency.

## Repair B — actual Woo order-received continuation

Create/use the smallest **local-only, non-consequential WooCommerce order fixture** that allows the actual order-received route to render without reading/reusing account credentials.

Preferred shape:
- synthetic local guest order;
- product 1113 or an equivalent local-only fixture correlation;
- unpaid/pending/on-hold state;
- valid local Woo order-received access context/key;
- no payment gateway invocation;
- no Provider request;
- no checkout submission;
- no generation job/model call.

Capture 1440px and 375px actual Woo order-received pages showing the project continuation rendered by the real `woocommerce_thankyou` hook.

For an unpaid fixture, expected project state is **PAYMENT PENDING / generation not started**.

Do not fake `is_paid()` via URL/query parameters.

The existing explicit ready/generation visual fixture may remain as the visual-only proof for later states; no paid-order mutation is required in this repair.

After capture, either remove the local order fixture or document its exact retained synthetic state and why it is harmless. Do not touch historical Sandbox order #30 or any real/provider-backed order.

## REQUIRED_EVIDENCE

Append a scoped G3CR7R1R1 section containing:

1. preflight facts;
2. proof the six stale prototype files are absent from the final candidate;
3. complete baseline-to-candidate plugin source diff;
4. affected PHP/JS lint/static rechecks if source changed;
5. actual Woo order-received desktop/mobile screenshots from the synthetic local order context;
6. Woo order ID may be redacted/treated as local fixture metadata; do not expose credentials or private buyer data;
7. proof fixture remains unpaid and Provider mutations/payment actions are zero;
8. proof generation/model calls remain zero;
9. cleanup/retention state of the fixture;
10. final counters and rollback effect.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

- final plugin directory contains no unaccepted Reviewer prototype implementation files;
- complete source diff against `e71f943...` is reviewable;
- independent Executor implementation remains otherwise unchanged except necessary repair;
- actual Woo order-received route renders the BMS continuation at 1440px and 375px under a local non-consequential fixture;
- unpaid fixture displays pending/not-started semantics;
- forged/untrusted parameters still cannot create paid truth;
- no real payment, checkout submission, Provider mutation, model call, production deploy, Shared Infra mutation, P1-P12 work, or PR merge;
- Executor appends Evidence and returns PASS_CANDIDATE / RETURN, then stops.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate: `docs/G3CR7R1R1_EVIDENCE_AND_CLEAN_SOURCE_REPAIR.md`;
2. prior evidence: `docs/evidence/g3cr7r1/README.md`;
3. current independent implementation:
   - `poc/g3c/preview-plugin/birthday-magazine-poc.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.js`
   - `poc/g3c/preview-plugin/g3cr7r1-local-seed.php`
4. the six stale reference-only filenames listed in Repair A only to confirm absence/reference status.

Accepted facts that may be reused without replay:
- G3CR7R1 baseline identity PASS;
- PHP/JS validation PASS at `88f45f5d...`;
- five-step desktop/mobile runtime PASS;
- 12/25 + <=3 must-use PASS;
- Free Preview local-photo boundary PASS;
- Woo checkout handoff PASS;
- forged-query negative PASS;
- no real/provider/model/deploy actions occurred.

Do not reread Governance or broad project history.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：删除未使用的 Reviewer 参考原型文件，并补齐真实 Woo order-received 本地夹具证据；其他已通过前端不重做。
验证：完整 baseline diff、必要 lint、1440/375 实际 order-received、未付款状态与零 Provider/支付/模型动作。
问题：NONE，或明确阻塞点。
回滚：可恢复到 88f45f5d...；接受基线仍为 e71f943...
请 Reviewer 检查：完整 source diff + 新 order-received 截图 + G3CR7R1R1 Evidence。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, real payment, production generation, P1-P12, production deployment, or PR merge.
