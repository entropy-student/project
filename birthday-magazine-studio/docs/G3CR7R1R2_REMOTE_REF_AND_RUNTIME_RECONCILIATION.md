# G3CR7R1R2 — Remote Ref + Local Runtime Reconciliation

## Gate

```text
GATE_ID=G3CR7R1R2_REMOTE_REF_AND_RUNTIME_RECONCILIATION
OBJECTIVE=Recover the Executor onto the authoritative G3CR7R1 candidate, clean unused Reviewer-reference files, restore/diagnose the retained local web runtime, and capture actual Woo order-received pending-state evidence
MAX_ENDPOINT_THIS_ROUND=Fresh PASS_CANDIDATE for the two remaining G3CR7 blockers only
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=PR64 project source + retained local G3C runtime + g3cr7r1 evidence; no redesign or backend intake implementation
APPLICABLE_CRITICAL_CONSTRAINTS=REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Source may return to independent anchor 88f45f5d...; accepted pre-implementation baseline remains e71f943...; local runtime repair must preserve project DB/volumes and previously accepted data
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.7**.

Triggered specialists for this repair:
- **11A Shared VPS / Storage**: local Docker resource/storage integrity is relevant to runtime diagnosis; no Shared VPS mutation is authorized.
- **11C Deployment / Network / Resources**: container-up does not prove web health; local port/process layers must be diagnosed separately.
- **11D Automation / Authentication**: actual Woo order-received proof uses browser/order access context; no Owner credential is to be consumed.
- **11E Provider / Payment**: Woo payment truth must remain authoritative and Provider/payment actions remain zero.

## Authority and source anchor

Canonical Gate/Handoff authority is current GitHub `main`.

The **implementation source anchor** is:
`88f45f5d712e3c1fe26f4386628703716b8eca3e`.

Fresh Reviewer read-back established:
- PR #64 head at reconciliation: `c01843de4fb8bc139030930ad12caeb9ebbcd2b3`;
- `c01843de...` descends from `88f45f5d...`;
- changes after `88f45...` are Reviewer docs/Handoff only;
- current PR plugin implementation source is byte-identical to `88f45...`.

The old commit `97aceb4a...` is **not** a valid current-source anchor. It was the pre-G3CR7R1 execution head and still references the old Reviewer prototype.

## PREFLIGHT A — recover fresh Git source view

Before any source mutation:

1. fetch current remote refs;
2. read the actual PR #64 remote head from GitHub/remote, not a cached local branch pointer;
3. prove that remote candidate descends from `88f45f5d...` or has an equivalent plugin source tree;
4. prove current `birthday-magazine-poc.php` blob is `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf` and references `frontend-reproduction.php`;
5. prove `frontend-reproduction.php/css/js` match the accepted G3CR7R1 blobs recorded in the Reviewer decision;
6. use a clean project-scoped worktree or equivalent fresh checkout from that remote candidate; do not continue from local `97aceb4a...`;
7. if remote source no longer matches the reconciled implementation, RETURN `RETURN_PREFLIGHT_DRIFT`.

Do not reset/rewrite remote Git history.

## Repair A — clean source boundary

After the fresh-source preflight, prove the following six files are not referenced by active plugin source:

- `frontend-flow.php`
- `frontend-flow.css`
- `frontend-flow.js`
- `frontend-intake.css`
- `frontend-intake-ui.js`
- `frontend-intake.js`

Then remove exactly those six files from the final PR candidate.

Regenerate a complete plugin-target diff from `e71f94377d341a88ba388f2c5da153e7cd6ee8b8` to the new candidate.

Do not delete historical commits or Reviewer decision/evidence records.

## PREFLIGHT B — local runtime diagnosis

The Executor's previous `connection refused` is now an explicit runtime fault to diagnose, not a reason to select another source implementation.

Use bounded read-only diagnostics first:

1. exact `birthday-magazine-g3c` container inventory/state;
2. WordPress container port mapping and binding for host `127.0.0.1:8189`;
3. web server/PHP process state inside the WordPress container;
4. container-local HTTP probe;
5. host-local HTTP probe;
6. DB container health/connectivity only if needed to explain web failure;
7. sanitized recent WordPress/Apache container error class if needed; do not surface Secret/cookie/private-order content.

Classify the fault domain before mutation.

Allowed smallest runtime repair:
- exact project WordPress container **start or restart only**, if diagnosis proves this is sufficient.

Not authorized:
- image pull;
- build;
- container recreate;
- Compose down;
- volume deletion;
- DB reset/migration;
- global Docker cleanup;
- Shared Infra change.

If a restart is insufficient or a recreate/storage/config change would be required, RETURN `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE` or the more precise applicable RETURN.

After repair, prove:
- WordPress container/process health;
- host `http://127.0.0.1:8189/` HTTP reachability;
- existing project DB/data still present;
- product 1113 still USD 39.99 virtual;
- no unrelated Docker delta.

Do not replay the already-passed five-step/browser suite.

## Repair B — actual Woo order-received route

Once the retained runtime is reachable:

Create the smallest local-only synthetic **guest unpaid** Woo order fixture through WooCommerce application APIs/WP-CLI, without checkout submission and without Provider/payment gateway invocation.

Required fixture properties:
- synthetic/local-only;
- no real customer data;
- unpaid/pending or on-hold;
- valid Woo order key/access context;
- may contain product 1113;
- Provider/payment actions = 0;
- generation/model actions = 0.

Use the genuine Woo order-received URL/access context for that fixture and capture:
- 1440px screenshot;
- 375px screenshot.

The actual route must render the BMS `woocommerce_thankyou` continuation with:
- **PAYMENT PENDING**;
- generation not started semantics.

The project continuation must derive truth from Woo `WC_Order::is_paid()`; URL/query values must not promote the fixture to paid.

After evidence:
- delete only the synthetic local fixture and prove order count returns to its pre-fixture value, **or**
- retain it only if cleanup would create greater risk, with exact synthetic/unpaid classification and reason.

Do not inspect/reuse the existing account-owned order's credentials. Do not touch historical Sandbox order #30.

## REQUIRED_EVIDENCE

Append a G3CR7R1R2 section containing:

1. fresh remote PR head and source blob preflight;
2. explicit classification of prior `97aceb4a...` as stale local/pre-execution source;
3. proof the six old reference files are unreferenced and absent from final candidate;
4. complete `e71f943...` -> final plugin source diff;
5. local runtime diagnostic facts by layer: container / web process / container HTTP / host HTTP / DB if relevant;
6. exact bounded runtime repair, or NONE;
7. post-repair runtime read-back;
8. actual Woo order-received 1440/375 screenshots using the synthetic unpaid guest fixture;
9. proof `is_paid()=false` and no query promotion;
10. synthetic fixture cleanup/read-back;
11. explicit counters:
   - real payments 0;
   - checkout submissions 0;
   - Provider mutations 0;
   - model/generation calls 0;
   - production deployments 0;
   - Shared Infra mutations 0;
   - Docker recreate/pull/build/down/volume-delete 0;
12. rollback effect and final PR head;
13. `STOP_AT_REVIEWER=YES`.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

- fresh Git source view is based on the current remote candidate, not local `97aceb4a...`;
- final candidate retains the independent `frontend-reproduction.*` implementation;
- six unused Reviewer prototype files are absent;
- complete accepted-baseline diff is reviewable;
- local G3C web runtime is healthy again without unauthorized recreate/storage changes;
- actual Woo order-received route at 1440/375 visibly contains the BMS pending continuation;
- synthetic fixture is unpaid and cannot be query-promoted;
- no real/provider/model/deploy/shared-infra action occurs;
- already-passed G3CR7R1 frontend tests are not replayed;
- Executor records Evidence and stops.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate from current GitHub `main`: `docs/G3CR7R1R2_REMOTE_REF_AND_RUNTIME_RECONCILIATION.md`;
2. prior G3CR7R1 Evidence: `docs/evidence/g3cr7r1/README.md`;
3. current PR source after a **fresh remote fetch**, limited to:
   - `poc/g3c/preview-plugin/birthday-magazine-poc.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.js`
   - `poc/g3c/preview-plugin/g3cr7r1-local-seed.php`
   - the six exact stale filenames only for reference/deletion checks.

Accepted facts that remain reusable:
- `88f45f5d...` is the independently reproduced source anchor;
- the current GitHub PR source descends from and matches that source anchor;
- five-step intake, Preview privacy, checkout handoff, forged-query negative, and prior PHP/JS validation already passed;
- do not rerun them merely because the local runtime became unavailable.

Do not reread Governance, broad Handoff, or project history.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：同步到远端当前独立候选，清理六个旧参考文件；如有需要仅修复本地 WordPress web 进程，并补真实 Woo order-received 夹具证据。
验证：fresh PR/source blobs、完整 baseline diff、runtime 分层诊断/恢复、1440/375 实际 order-received、未付款/零 Provider/零支付/零模型。
问题：NONE，或明确剩余阻塞点。
回滚：源码可恢复到 88f45f5d...；本地 runtime 保留原 DB/volumes，不执行 recreate/down/delete。
请 Reviewer 检查：fresh source boundary + runtime 诊断 + actual order-received screenshots + Evidence。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend pre-payment draft persistence, real payment, production generation, P1-P12, production deployment, or PR merge.
