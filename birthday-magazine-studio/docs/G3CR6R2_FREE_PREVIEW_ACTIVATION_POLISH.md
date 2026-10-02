# G3CR6R2 — Free Preview Activation Polish

## Gate

```text
GATE_ID=G3CR6R2_FREE_PREVIEW_ACTIVATION_POLISH
OBJECTIVE=Improve the pre-payment Aha without changing the frozen product contract or protected backend
MAX_ENDPOINT_THIS_ROUND=Reviewer evidence package for the bounded Preview/frontend correction
MANDATORY_REVIEW_STOP=YES
```

## Context

G3CR6R1 is PASS. The Owner broadly accepts the overall visual composition.

The remaining bounded concern is the Free Preview experience: the current interaction risks making the product feel like “upload a photo → get a cover,” while the product thesis is a **story-led personalized 12-page birthday magazine**.

## Target and scope

Only the customer-facing Activation / Free Preview presentation may change.

Allowed:

- Free Preview section composition;
- default/empty state;
- wording and hierarchy;
- upload control presentation;
- optional-photo framing;
- cover + sample-spread presentation;
- transition from free preview to the US$39.99 full magazine;
- Hero CTA wording/link target only if necessary to make this corrected Activation coherent;
- narrowly related mobile presentation.

Do not reopen:

- overall site composition;
- theme/builder;
- Product/Cart/Checkout/Account architecture;
- WooCommerce backend;
- payment;
- private workspace;
- account model;
- production AI/provider.

## Product behavior to preserve

The frozen MVP product contract remains unchanged.

Free preview inputs remain compatible with:

- recipient name;
- age/birthday;
- style preset;
- optional one local cover photo.

Free preview remains capable of:

- immediate personalized cover preview;
- one sample interior spread.

No full-resolution export.

## Required UX direction

### Default value presentation

The Preview section should first communicate:

> This becomes a real magazine about one person — not just a cover effect.

Use a polished default sample state so the visitor can understand the value **without uploading anything**.

### Photo upload

Photo upload remains optional.

Reframe it as:

> “Try it with your photo”

rather than making upload itself feel like the product.

### Personalized result

After a photo is selected:

- show the cover;
- also visibly preserve the sample editorial spread / magazine context;
- avoid presenting the cover as the sole payoff;
- make the paid 12-page expansion immediately understandable.

### Paid transition

Keep the boundary clear:

```text
FREE
one browser-local personalized sample
→ proves the magazine idea

PAID US$39.99
complete personalized 12-page digital magazine
+ private order workspace
+ bounded revision
```

Do not invent new claims.

## Privacy / technical contract

Must remain:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
```

Selected image stays browser-local.

Select / replace / remove / invalid-image handling remains usable.

## Protected backend

Fresh read-back must prove no mutation to:

- WooCommerce canonical cart/order/checkout business logic;
- payment gateway;
- order state;
- account authorization;
- private-workspace guard;
- entitlement / generation-job semantics;
- DB schema;
- production provider.

## Owner editability

Surrounding Preview copy and normal page content should remain Owner-editable where practical.

The interaction-heavy Preview component may remain project-local code.

## Preflight

Before source mutation:

- fresh PR #64 head;
- fresh current runtime;
- exact project Git root/branch;
- current G3CR6R1 rollback status;
- protected backend hashes;
- current Preview behavior/network baseline;
- unrelated worktree state.

Create a distinct G3CR6R2 rollback point.

## Required evidence

- desktop Preview default/empty state;
- desktop Preview with photo;
- 375px default/empty state;
- 375px with photo;
- enough surrounding page context to judge the Free → Paid transition;
- select / replace / remove / invalid-file behavior;
- browser-local blob proof;
- 0 photo upload;
- 0 external image POST;
- 0 model request;
- product remains virtual USD 39.99;
- native Woo path unaffected;
- order count unchanged;
- 375px no blocking overflow;
- Owner editability read-back;
- protected backend hashes unchanged.

## Acceptance criteria

PASS requires:

1. the Preview no longer reads primarily as a “cover generator”;
2. value is understandable before photo upload;
3. optional personalization strengthens rather than replaces the magazine proposition;
4. cover + editorial spread context remains visible after personalization;
5. Free → full 12-page US$39.99 value boundary is clear;
6. privacy/network contract remains intact;
7. no protected backend regression;
8. desktop + 375px remain usable;
9. no unrelated visual redesign is introduced.

## Rollback

Rollback to the accepted G3CR6R1 state.

Do not overwrite prior G3CR6/G3CR6R1 rollback evidence.

## Owner-only actions

NONE for this local frontend Gate.

No payment, Provider activation, account authorization, production deployment, Secret mutation, or G4 action is allowed.

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

## Executor → Reviewer relay

Return the canonical short completion packet required by Governance v0.2.4:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：...
验证：...
问题：...
回滚：...
请 Reviewer 检查：...
Owner 转交：NONE
```

Detailed evidence belongs in `EXECUTION_EVIDENCE.md`.

Stop at Reviewer.
