# G3CR6R3C — Template Discovery Research Contract

> Status: **MANDATORY CURRENT RESEARCH CONTRACT**  
> Owner authority: `OWNER_DECISION_G3CR6R3C_TEMPLATE_RESEARCH_QUALITY_BAR.md`  
> Parent Gate: `G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md`

## 1. Purpose

Prevent shallow template research and force a high-signal search for **exceptional** source/template/interaction candidates for:

- 12 magazine pages;
- 1 homepage;
- 1 core homepage interaction/motion experience.

The magazine pages may be static, lightly animated, or interaction-driven in web presentation. That choice remains unresolved during discovery.

The current delivery contract remains a 12-page PDF unless later reopened by the Owner.

## 2. Non-negotiable research floor

A final shortlist must not be proposed before all of the following are met:

```text
DISTINCT_CANDIDATES_INSPECTED >= 60
DISTINCT_SOURCE_ECOSYSTEMS >= 8
LIVE_DEMO_OR_EQUIVALENT_VISUAL_EVIDENCE = REQUIRED
SOURCE_OR_LICENSE_STATUS = REQUIRED_FOR_SHORTLIST
REJECT_LOG = REQUIRED
SATURATION_STOP = REQUIRED
```

A candidate counts only when it is directly inspected.

Do not count:
- a template repeated across multiple marketplaces;
- color/style variants of the same template;
- cloned/forked copies with no material difference;
- SEO roundup entries not directly opened;
- marketing thumbnails with no meaningful inspection;
- irrelevant templates included only to inflate the count.

## 3. Source-ecosystem breadth

Research must span at least 8 materially distinct ecosystems/categories, such as:

- Framer marketplace/community;
- Webflow marketplace/showcase;
- GitHub open-source projects;
- Codrops experiments;
- GSAP/community demos;
- premium commercial template marketplaces;
- editorial/magazine-specific template ecosystems;
- award/showcase sites such as Awwwards-like sources;
- independent design studios / interactive portfolios;
- code-demo communities such as CodePen-like sources;
- web-to-print/editorial layout systems.

This list is not exhaustive and must not become a search ceiling.

## 4. Candidate evidence packet

For every serious candidate, record:

```text
NAME
SOURCE_URL
SOURCE_ECOSYSTEM
ROLE=HOMEPAGE | CORE_INTERACTION | MAGAZINE | MULTI_ROLE
VISUAL_EVIDENCE
INTERACTION_EVIDENCE
MOBILE_OR_RESPONSIVE_EVIDENCE
SOURCE_CODE_STATUS
LICENSE_OR_REUSE_STATUS
DEPENDENCIES
IMPLEMENTATION_COMPLEXITY
STATIC_LIGHT_MOTION_INTERACTIVE_CLASS
FIT_WITH_12_PLUS_1_PLUS_1
REJECT_OR_SHORTLIST_REASON
```

If a field cannot be verified, mark it `UNKNOWN`; do not guess.

## 5. Two-axis evaluation

Do not mix design quality with reuse rights.

### A. Experience quality

Score 0–100:

| Dimension | Weight |
|---|---:|
| Immediate visual impact / memorability | 25 |
| Interaction sophistication / motion quality | 25 |
| Editorial / magazine / gift fit | 15 |
| Composition / typography / image art direction | 15 |
| System coherence / extensibility to 12+1+1 | 10 |
| Mobile / accessibility / reduced-motion viability | 10 |

### B. Reuse status

Classify separately:

```text
DIRECT_REUSE_OK
LICENSED_REUSE_POSSIBLE
REFERENCE_ONLY_REIMPLEMENT
UNKNOWN_DO_NOT_COPY
REJECT
```

A visually exceptional candidate may remain S-grade as a **reference** even when direct code reuse is not allowed.

Do not downgrade artistic quality merely because the license is restrictive; instead classify the reuse path correctly.

## 6. Grade thresholds

### S-grade

Normally requires:
- Experience quality >= 85/100;
- no major mismatch with the intended premium editorial experience;
- enough real evidence to understand the interaction, not just a thumbnail;
- at least one clearly transferable principle for the 12+1+1 system.

### A-grade

Normally requires:
- Experience quality >= 75/100;
- strong enough to serve as backup, component source, or secondary inspiration.

Below A:
- reject from Owner shortlist;
- retain only in research ledger with concise reason.

A score is a comparison aid, not a substitute for visual judgment. Reviewer may reject a high numeric score when the underlying evidence does not support it.

## 7. Hard rejection rules

Reject from shortlist when the candidate is mainly:

- generic SaaS/ecommerce styling;
- ordinary WordPress starter-template quality;
- superficial scroll-fade effects only;
- animation-heavy but visually cheap;
- visually striking but structurally incompatible with the product;
- repetitive page composition with weak photography/editorial rhythm;
- dependent on an unreasonably heavy stack for a minor visual gain;
- inaccessible/unusable on mobile with no credible adaptation path;
- clearly derivative of a protected brand in a way we should not reproduce.

## 8. Interaction bar

For core-interaction candidates, prioritize patterns that can create a strong “Aha” after a user selects/uploads one local photo.

Strong candidates may include:
- object/cover morphing;
- masked/clip reveals;
- page or card stacking/fan-out;
- layered editorial staging;
- image-to-layout transformation;
- controlled 3D/depth;
- tactile drag/hover/touch transitions;
- scroll-driven but non-scroll-jacking sequences.

The interaction must be:
- purposeful;
- premium;
- comprehensible;
- mobile-adaptable;
- reducible under `prefers-reduced-motion`.

## 9. Magazine-page bar

The 12-page system should not be assembled from twelve unrelated styles.

Prefer:
- one strong editorial family;
- a small number of compatible source families;
- shared typography, spacing, image treatment and grid logic;
- multiple page archetypes with real visual rhythm.

Discovery should cover enough patterns for:
- cover;
- opening/profile;
- feature story;
- dynamic module;
- quote/why-they-matter;
- photo story/current era;
- birthday letter;
- back cover.

## 10. Challenger rule

Once an S/A shortlist exists, a new candidate enters only if it:

- materially beats an existing candidate on at least one high-priority dimension; or
- adds a genuinely new first-order visual/interaction pattern; or
- provides a materially better reuse/license/implementation path without major visual regression.

“Also nice” is not enough.

## 11. Saturation stop rule

After the 60-candidate / 8-ecosystem floor:

- continue in batches of at least 10 meaningful candidates;
- broad search stops only after **two consecutive batches** produce:
  - no new first-order pattern; and
  - no material improvement to the current shortlist.

If saturation is not reached, return:

```text
RETURN_RESEARCH_NOT_SATURATED
```

and continue research rather than forcing a shortlist.

## 12. Required research artifacts

The Gate must produce:

1. **Research Ledger** — all inspected candidates, including rejects.
2. **Source Coverage Map** — source ecosystems and counts.
3. **S/A Shortlist** — only candidates that clear the bar.
4. **Reject Summary** — recurring reasons good-looking candidates failed.
5. **12+1+1 Coverage Map** — which sources can support which visual surfaces.
6. **Reuse Map** — direct reuse vs licensed reuse vs reference-only.
7. **Saturation Evidence** — the final two no-improvement batches.
8. **Owner Gallery** — concise visual/reference set for actual selection.

## 13. Final output rule

Do not end with “here are some good templates.”

The final result must answer:

- What are the genuinely exceptional candidates?
- Which one(s) are best for the homepage?
- Which one(s) are best for the core interaction?
- Which family can cover the 12 magazine pages coherently?
- Which source can be copied/adapted legally?
- Which must be independently reimplemented?
- What combination would create the strongest unified 12+1+1 system?
- What did the search reject, and why?
- Has saturation actually been reached?

If the answer is “none are good enough,” say so and continue discovery.
