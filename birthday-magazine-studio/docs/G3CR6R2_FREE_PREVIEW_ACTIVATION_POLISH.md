# G3CR6R2 — Free Preview Activation Polish

> **STATUS: SUPERSEDED BEFORE EXECUTION by `G3CR6R3_PRODUCT_PROOF_MOTION_ACTIVATION`.**  
> Owner feedback on 2026-10-03 broadened the required correction from Preview framing alone to Final Product Proof + Motion + Preview Activation. Do not execute this Gate independently.

## Gate

```text
GATE_ID=G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH
OBJECTIVE=Improve the pre-payment Aha so the product reads as a complete personalized magazine gift, not a cover-generator trick
MAX_ENDPOINT_THIS_ROUND=Reviewer evidence package for this bounded Preview/frontend correction
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Local G3C frontend Preview framing only on existing PR #64
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.6**, canonical `VNEXT.md`.

## Accepted facts Executor may rely on

- G3CR6R1 is Reviewer PASS.
- Existing PR: **#64**.
- Accepted execution head entering this Gate: `15ff73f6232e0ef94f04f313f74372e52389d1e2`.
- Overall Warm Birthday Gift composition is accepted and is **not** being redesigned again.
- Product 1113 is virtual USD 39.99.
- Native Woo Product → Cart → Checkout → My Account is accepted and protected.
- Free Preview privacy contract is accepted and must remain zero-upload / zero-model.
- Owner editability must remain.
- Current commercial state is **LOW_COST_VALIDATION_NOT_SCALE**.

## Applicable critical constraints

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
REAL_MONEY_ACTIONS=0
PAYPAL_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PR_MERGE=0
G4_ACTIONS=0
```

## Target and allowed changes

Only the customer-facing Free Preview / Activation presentation may change:

- Preview section composition;
- default sample state;
- wording/hierarchy;
- optional upload control presentation;
- “Try it with your photo” framing;
- cover + interior-spread presentation;
- Free → complete 12-page US$39.99 transition;
- narrowly related Hero CTA/link target if needed;
- narrowly related 375px presentation.

Do **not** reopen:

- overall site composition;
- theme/builder;
- Product/Cart/Checkout/Account architecture;
- Woo backend;
- payment;
- account/private workspace;
- entitlement/job semantics;
- frozen MVP contract;
- production AI/provider.

## Required UX direction

### 1. Value before upload

A polished magazine sample must communicate the value **without requiring a photo upload**.

The visitor should understand:

> this is a personalized magazine about one person.

### 2. Upload is optional proof

Photo upload remains supported but becomes secondary framing:

> **Try it with your photo**

It must not appear to be the product itself.

### 3. Personalized result stays magazine-shaped

After selection:
- keep the cover visible;
- keep a visible interior editorial spread / magazine context;
- do not make the cover the sole payoff;
- keep the complete 12-page paid expansion nearby and obvious.

### 4. Free → Paid boundary

```text
FREE
browser-local personalized sample
cover + sample editorial context
proves the magazine idea

PAID US$39.99
complete personalized 12-page digital magazine
private order workspace
one bounded revision batch
```

No unsupported claim may be added.

## Product behavior to preserve

Compatible Preview inputs:
- recipient name;
- age/birthday;
- style preset;
- optional one local photo.

Keep usable:
- select;
- replace;
- remove;
- invalid MIME rejection;
- corrupt-image rejection.

No full-resolution export.

## Protected backend

Fresh read-back must show no mutation to:
- WooCommerce cart/order/checkout business logic;
- payment gateway;
- order state;
- account authorization;
- private-workspace guard;
- entitlement/generation-job semantics;
- DB schema;
- production provider.

## Owner editability

- surrounding Preview headings/copy remain Owner-editable where practical;
- normal Home content remains Gutenberg;
- interaction-heavy Preview code may remain project-local;
- do not reduce the already-proven Owner editing capabilities.

## PREFLIGHT

Before mutation prove:
- canonical Git root;
- branch and fresh PR #64 head;
- no material drift from the accepted G3CR6R1 baseline;
- current local runtime identity;
- unrelated worktree state;
- G3CR6R1 rollback still exists;
- current Preview network/behavior baseline;
- protected backend hashes.

Create a **distinct G3CR6R2 rollback point**. Do not overwrite older rollback evidence.

## REQUIRED_EVIDENCE

Visual:
- desktop Preview before photo;
- desktop Preview after photo;
- 375px before photo;
- 375px after photo;
- surrounding section context sufficient to judge the Free → Paid transition.

Behavior:
- select / replace / remove;
- invalid MIME;
- corrupt image;
- browser-local blob behavior;
- 0 server photo upload;
- 0 external image POST;
- 0 model request.

Regression:
- product remains virtual USD 39.99;
- native Woo path loads and is unaffected;
- no Checkout submission;
- order count unchanged;
- 375px no blocking horizontal overflow;
- Owner editability read-back;
- protected backend hashes unchanged;
- no unrelated visual redesign.

## ACCEPTANCE_CRITERIA

PASS requires all:

1. Preview no longer reads primarily as a cover generator.
2. Product value is understandable before upload.
3. Upload is clearly optional personalization proof.
4. Personalized state visibly preserves cover + editorial-spread context.
5. Free → complete 12-page US$39.99 boundary is clear.
6. Privacy/network contract remains intact.
7. Protected backend remains unchanged.
8. Desktop + 375px remain usable.
9. Overall accepted site composition is not reopened.

## ROLLBACK_STATUS_OR_PLAN

- rollback target: accepted G3CR6R1 state;
- create new scoped G3CR6R2 recovery artifact before write;
- prior G3CR6/G3CR6R1 recovery evidence remains untouched.

## REVIEWER_TO_EXECUTOR_RELAY

Executor startup surface is intentionally narrow.

Read only:

1. `docs/G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH.md` — this Gate.
2. `docs/REVIEWER_DECISION_G3CR6R1_PASS.md` — accepted frontend baseline.
3. `docs/GROWTH_VALIDATION_STATE_2026-10-03.md` — why the Preview framing is being changed.
4. Target implementation files for the current Preview/Home section.
5. Fresh runtime/PR/source read-back required by Preflight.

Accepted facts are listed above. Do **not** reread Governance, broad historical Handoff/Evidence, or prior Gates by default. If execution reveals a specific contradiction, perform the smallest targeted read and RETURN to Reviewer on material drift.

Continue on existing PR #64. Do not create or merge another PR.

## EXECUTOR_TO_REVIEWER_RELAY

Use Governance v0.2.6 short completion packet:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明实际改了什么。
验证：一句话总结关键检查结果；详细证据写入 EXECUTION_EVIDENCE。
问题：NONE，或具体阻塞点。
回滚：一句话说明是否可恢复、恢复到哪里。
请 Reviewer 检查：一句话说明需要核对什么。
Owner 转交：NONE
```

Executor must update current execution facts/evidence durably, perform fresh read-back, and stop at Reviewer.

## Forbidden

```text
PR_MERGE=0
THEME_CHANGE=0
BUILDER_CHANGE=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
G4_ACTIONS=0
```
