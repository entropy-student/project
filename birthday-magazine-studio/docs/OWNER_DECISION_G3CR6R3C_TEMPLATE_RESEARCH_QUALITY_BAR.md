# Owner Decision — G3CR6R3C Template Research Quality Bar

> Date: 2026-10-04  
> Status: **CURRENT OWNER DECISION**  
> Parent: G3CR6R3C Template + Motion Source Discovery  
> PR: #64  
> G4 authority: NONE

## Decision

The Owner explicitly rejects shallow template research.

The research must prioritize **exceptional, advanced, premium, surprising, interactive** candidates over speed or candidate-count completion.

The research must not:
- stop after a few convenient search results;
- recommend generic ecommerce templates merely because they are easy to reuse;
- fill a quota with mediocre candidates;
- treat a thumbnail or marketing description as sufficient review;
- confuse “good enough” with “worth building the product around”.

## Quality principle

> **Quality threshold outranks shortlist size.**

If no candidate reaches the required bar, the correct result is:

```text
NO_QUALIFYING_CANDIDATE_YET
CONTINUE_RESEARCH
```

Do not lower the bar to force a recommendation.

## Target experience

The desired result should feel:
- visually memorable;
- premium;
- editorial;
- interaction-rich;
- technically sophisticated where useful;
- coherent rather than effect-heavy;
- clearly above an ordinary WordPress/ecommerce template.

## Research breadth

The research must be broad enough to avoid local optima.

Minimum floor before a final shortlist can be proposed:
- inspect at least **60 distinct real candidates**;
- cover at least **8 distinct source ecosystems / template communities**;
- inspect actual demos, interaction states or sufficiently representative visual evidence;
- inspect source/license information separately from visual quality.

Duplicate variants, recolors, SEO listicles, affiliate roundups, and near-identical forks do not count as distinct candidates.

## Saturation rule

After the minimum floor is reached, research continues until both are true:

1. two consecutive additional batches of at least 10 meaningful candidates each produce no new first-order visual/interaction pattern;
2. those batches produce no candidate that materially improves the current top shortlist.

Only then may broad discovery stop.

## Final shortlist rule

There is **no minimum shortlist size**.

Acceptable final result:
- 0–5 S-grade candidates;
- up to 10 A-grade backup candidates;
- everything else rejected with reason.

If there are zero S-grade candidates, the research does not pretend otherwise.

## Evidence requirement

Every S/A candidate must include enough evidence to judge:
- homepage/hero;
- core interaction/motion;
- at least one deeper/internal state or page;
- mobile/responsive behavior where available;
- source-code availability;
- license/reuse status;
- implementation dependencies;
- fit with the 12 + 1 + 1 architecture.

## State

```text
TEMPLATE_RESEARCH_QUALITY_BAR=OWNER_APPROVED
SHALLOW_SEARCH=FORBIDDEN
QUOTA_FILLING=FORBIDDEN
QUALITY_OVER_QUANTITY=YES
MIN_CANDIDATES_INSPECTED=60
MIN_SOURCE_ECOSYSTEMS=8
SATURATION_STOP_REQUIRED=YES
G3CR6R3C=CURRENT
```
