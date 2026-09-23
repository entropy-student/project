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
