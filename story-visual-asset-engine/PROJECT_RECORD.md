# Story Visual Asset Engine — PROJECT RECORD

## 2026-09-23 — Project bootstrap

Owner requested a standalone project to investigate the visual-production problem separately from Story Showrunner.

Problem statement:
- story videos will continue to use image-sequence storytelling;
- current image quality is unstable;
- generation usage/cost is material;
- a reusable asset library may shift cost from repeated generation to one-time asset creation;
- prompts must support different artifact types such as character model sheets and ordinary story boards without becoming ad hoc.

Governance:
- use canonical `vps-project-governance` semantics adapted to R&D/content tooling;
- Reviewer owns formal decisions;
- P0 starts as research/problem-definition;
- Story Showrunner integration remains out of scope until this project validates the approach.

Initial Reviewer hypothesis:
a limited-detail, cutout-friendly 2D story-comic family is likely to outperform highly detailed styles on reuse and consistency, but this is not yet accepted and must be benchmarked.


## 2026-09-23 — P0 deep research PASS

Reviewer completed the first research/problem-definition gate.

Accepted conclusions:
- no verified pricing rule supports choosing an art style solely because it is presumed to consume fewer image output tokens at fixed model/quality/size;
- the primary economic strategy is to reduce new generations and retries through reuse, derive/edit and compositing;
- reference-driven consistency is preferable to prompt-only repetition for the long-term system;
- structured metadata is sufficient for the initial asset library; vector retrieval is deferred;
- three style families are fixed for controlled testing, but no final style is locked.

P0 result:
`PASS_P0_RESEARCH_AND_PROBLEM_DEFINITION`

G1 package prepared:
- staged 10-shot benchmark;
- compact style profiles;
- minimal visual-asset schema;
- hard-return and measurement rules.

Next:
`G1_STYLE_AND_REUSE_BENCHMARK = READY_NOT_EXECUTED`


## 2026-09-23 — Owner removes crop/composite optimization

Owner rejected the local crop/reframe and local compositing branches as cost-saving mechanisms.

Current accepted cost strategy:
- direct reuse from the asset library;
- low-quality-first screening and higher quality only for survivors/final assets;
- reference-driven generation/edit to reduce drift and retries;
- prompt caching where supported;
- new generation only when reuse/reference-driven paths cannot satisfy the shot.

Current operational reuse order:
`EXACT_REUSE → DERIVE_EDIT_OR_REFERENCE_DRIVEN → NEW_GENERATE`.

Historical P0 notes mentioning crop/composite are retained as research history but are superseded for current execution.
