# G3CR7V2R1R1 — Runtime Candidate Alignment

## Gate

```text
GATE_ID=G3CR7V2R1R1_RUNTIME_CANDIDATE_ALIGNMENT
OBJECTIVE=Make the retained local Owner-review runtime byte-correlate to the already Reviewer-approved Stripe candidate without redesigning or changing project business source
MAX_ENDPOINT_THIS_ROUND=Exact candidate mounted at 127.0.0.1:8189 + minimal smoke/readback + PASS_CANDIDATE; no visual redesign, payment replay, backend, P1-P12, deployment, PR merge
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=retained local G3C runtime bind-mounted plugin files + evidence only; PR visual/source candidate remains frozen
APPLICABLE_CRITICAL_CONSTRAINTS=VISUAL_MUTATIONS_0; GIT_SOURCE_BUSINESS_MUTATIONS_0; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; ORDER_MUTATIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; DOCKER_RECREATE_PULL_BUILD_DOWN_VOLUME_DELETE_0; PR64_MERGE_0
ROLLBACK_STATUS_OR_PLAN=Before runtime alignment, save exact active runtime birthday-magazine-poc.php bytes/hash; restore only that file if alignment smoke fails
OWNER_ONLY_ACTIONS=Live visual review after Reviewer confirms runtime identity
```

Governance: **vps-project-governance v0.2.7**.

## Frozen accepted candidate

PR source candidate:
`18ab6b0e6d18d973bd4cc9376cec97b6fb89b830`

Frozen business blobs:

- `frontend-reproduction.php` = `db3af21e56fe2683b20020ae25cda0fbf6a8f5a1`
- `frontend-reproduction.js` = `cbd67a7dc0897e87e4c7bc4edb017a1e138d2e6a`
- `birthday-magazine-poc.php` = `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf`

Approved visual files are those at `18ab6b0e6d18d973bd4cc9376cec97b6fb89b830`.

Do not edit any candidate source in Git during this Gate.

## PREFLIGHT A — inspect the runtime delta

Before any runtime mutation:

1. confirm PR #64 remains open/unmerged and current source contains candidate `18ab6b0e6d18d973bd4cc9376cec97b6fb89b830` or a descendant with byte-identical target source;
2. read the active runtime `birthday-magazine-poc.php` bytes;
3. save a local rollback copy + SHA256 / Git blob identity;
4. compare active runtime file to candidate `birthday-magazine-poc.php`;
5. produce a sanitized structural diff showing changed functions/hooks/require statements, without secrets/session/order private data;
6. confirm whether the runtime delta is:
   - **STALE_OR_UNNEEDED_RUNTIME_DELTA**, or
   - **MATERIAL_LOCAL_ONLY_DEPENDENCY**.

If the difference contains a material local-only dependency required to keep the current local site functional, **do not overwrite it**. RETURN `RETURN_RUNTIME_LOCAL_DEPENDENCY` with the exact bounded reason.

## Alignment action

If preflight classifies the delta as stale/unneeded:

1. copy the exact candidate `birthday-magazine-poc.php` into the active runtime bind mount;
2. also fresh-read `frontend-reproduction.php` and `frontend-reproduction.js` in the active runtime;
3. if either differs from the frozen candidate blob, align that exact file too, after saving its runtime rollback copy;
4. do not change CSS/SVG—they are already candidate-matching unless readback proves otherwise;
5. do not restart/recreate the container unless PHP opcode/cache behavior demonstrably requires only a bounded WordPress-container restart; ordinary PHP file read should not require it.

No WordPress DB/content mutation is authorized.

## Minimal validation

After alignment prove:

1. active runtime candidate identities:
   - `birthday-magazine-poc.php` = candidate blob;
   - `frontend-reproduction.php` = candidate blob;
   - `frontend-reproduction.js` = candidate blob;
   - two approved CSS files + mesh = candidate SHA256;
2. `http://127.0.0.1:8189/` returns HTTP 200;
3. homepage Preview/core-entry renders;
4. `/make-your-magazine/` renders the intake shell;
5. `/magazine-status-preview/` renders the status fixture;
6. one 1440px screenshot of homepage Preview and one 375px screenshot of intake are sufficient to prove runtime mount identity; do not regenerate the entire visual suite;
7. Preview local name/photo smoke still works;
8. no PHP/JS source or DB/order/payment mutation occurred;
9. exact Stripe candidate remains mounted after validation for Owner review.

Do not create/replay a Woo test order. G3CR7R1R2 payment truth remains accepted.

## Acceptance criteria

PASS_CANDIDATE requires:

- runtime main plugin delta is understood and safely reconciled;
- exact frozen PHP/JS + visual candidate files are all mounted;
- local site remains healthy;
- minimal visual/interaction smoke passes;
- no Git candidate changes;
- no visual redesign;
- no DB/order/payment/provider/model/deploy action;
- candidate remains mounted for Owner.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR7V2R1_RETURN_RUNTIME_IDENTITY_2026-10-05.md`;
3. candidate target files at `18ab6b0e6d18d973bd4cc9376cec97b6fb89b830`;
4. active local runtime copies of the exact target plugin files only;
5. existing G3CR7V2R1 `runtime-final-readback.json`.

Do not reread broad project history.
Do not alter visual CSS/mesh.
Do not replay payment/order evidence.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：只对齐 retained local runtime 与已批准 Stripe candidate；未修改 Git 候选、视觉设计或业务逻辑。
验证：runtime PHP/JS/CSS/SVG identities、HTTP 200、首页/intake/status 最小 smoke、候选持续挂载。
问题：NONE，或明确 local-only runtime dependency。
回滚：已保存对齐前 runtime 文件；若失败仅恢复对应 runtime 文件，不碰 DB/volume。
请 Reviewer 检查：runtime structural diff + final identity readback + 两张最小截图。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, automatic generation, P1-P12, real payment, production deployment, PR merge or Shared Infra.
