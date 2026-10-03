> **Governance status: SUPPORTING VALIDATION PLAN.**  
> Framework: `Acquisition Growth Radar v0.2`.  
> Current project truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md).  
> Updated: 2026-10-03.

# Birthday Magazine Studio — Acquisition & Validation Plan

## Current commercial state

```text
CORE_PRODUCT_THESIS=KEEP_FOR_LOW_COST_VALIDATION
SOLUTION_PROOF=STRONG_AT_BOUNDED_TECHNICAL_SCOPE
REAL_TARGET_USER_ATTENTION=UNVERIFIED
REAL_TARGET_USER_INTEREST=UNVERIFIED
ACTIVATION_FRAMING=ITERATE_ONCE_IN_G3CR6R2
REAL_INTENT=UNVERIFIED
REAL_TRANSACTION=UNVERIFIED
REPEATABILITY=UNKNOWN
ECONOMICS=UNKNOWN
SCALE=NO
```

The product should be treated as a **validation-stage DTC gift product**, not as a scale-ready business.

## Validation Spine

### VALUE REALITY

**Problem Evidence:** Owner reports prior demand validation, but the durable repository does not yet contain enough target-user VOC/sample/channel detail for independent Reviewer verification.

**Solution Proof:** strong at bounded technical scope:
- browser-local Preview;
- real-AI structured content;
- deterministic 12-page PDF;
- Woo commerce/account/private workspace;
- PayPal Sandbox payment/refund lifecycle;
- current customer-facing frontend.

### CUSTOMER BEHAVIOR

For the finalized product/site, Attention / Interest / Intent are not yet durably measured on real target users.

Current pre-transaction Activation is intended to be:

> “This already feels like a real magazine made about them.”

G3CR6R2 exists because the current upload-first framing risks producing the wrong Aha:

> “This is a cover generator.”

### BUSINESS VIABILITY

Real Transaction, Repeatability and Economics remain unproven.

Do not infer them from Sandbox, screenshots, code correctness, likes, views, or one future order.

## Current bottleneck and lever

Before external testing:

- **Bottleneck:** Value Experience / Activation + Trust.
- **Primary lever:** Free Preview framing / first-value experience.
- **Secondary lever:** Proof / Trust.
- **This round does not change:** Audience, price, paid scope or channel.

## G3CR6R2 — bounded Activation correction

Keep the free Preview capability.

Change the framing:

1. show a polished magazine outcome before upload;
2. make “Try it with your photo” optional;
3. when personalized, preserve cover + editorial spread context;
4. keep the complete 12-page US$39.99 expansion immediately understandable.

Then stop general product polishing.

## Next real-user experiment

After G3CR6R2 Reviewer PASS + Owner visual freeze + the required public/payment readiness Gates, the first acquisition loop should vary **Message / Situation**, not price or product scope.

Suggested message hypotheses:

- meaningful birthday gift for someone hard to buy for;
- turn years of photos/memories into a magazine about them;
- personal gift without having to design a photo book yourself.

Keep product, price and Preview fixed while comparing message/situation.

### Event spine

```text
landing_view
→ preview_sample_seen
→ preview_personalization_started (optional)
→ preview_personalization_completed (optional)
→ product_cta_clicked
→ add_to_cart
→ checkout_started
→ payment_completed
```

Activation is not “opened the uploader.” It is evidence that the visitor experiences/understands the magazine value.

### Trust observations

Track objections separately:
- looks like a template / AI gimmick;
- does not look personal enough;
- privacy concern about photos;
- digital-only concern;
- unclear what 12 pages contain;
- price concern;
- delivery/turnaround uncertainty.

Do not automatically classify “did not pay” as a price problem.

## Free vs paid boundary

```text
FREE
complete but bounded win:
see the magazine idea clearly
optionally personalize one browser-local sample

PAID US$39.99
more scope + depth + personalization + continuity:
complete personalized 12-page digital magazine
private order workspace
one bounded revision batch
```

## Metrics to retain

Acquisition:
- source / campaign / message variant;
- landing views;
- Preview sample seen;
- optional personalization started/completed;
- product CTA;
- add to cart;
- checkout start;
- payment complete when Live is authorized.

Delivery/economics:
- generation success/failure;
- QA correction/retry;
- proof viewed;
- revision requested;
- PDF delivered;
- payment fees;
- real model/render/storage cost;
- refund;
- acquisition spend.

Privacy:
- do not log uploaded photos, private prompt answers or raw personal details into analytics.

## Decision logic

- **KEEP:** real users understand the magazine proposition and some progress toward purchase; continue controlled validation.
- **ITERATE:** behavior or objections identify one concrete Message / Activation / Trust / Offer problem.
- **KILL:** repeated qualified tests show weak interest/intent despite a clear value experience, or economics become structurally unattractive.
- **SCALE:** not available until real transaction + repeatability + economics are sufficiently evidenced.

## Current decision

The correct next action is **not more broad feature work**.

Complete the bounded G3CR6R2 Preview correction, freeze the frontend if accepted, then move toward real-behavior validation through the separately governed readiness/payment/deployment sequence.
