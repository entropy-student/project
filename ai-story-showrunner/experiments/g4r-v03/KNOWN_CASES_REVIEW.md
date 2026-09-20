# G4R v0.3 — Known-case Experimental Summary

> Experimental only. Not canonical.

| Case | Visual engine | Semantic Shots | Visual Beats | Duration | Avg beat | Coverage | Result |
|---|---|---:|---:|---:|---:|---|---|
| Agent | ACTION_REACTION | 36 | 67 | ~2:57 | ~2.65s | full | PASS_CANDIDATE |
| Context / Memory | EVOLVING_METAPHOR | 44 | 82 | ~3:33 | ~2.59s | 100% | PASS_CANDIDATE |
| MCP | REPEATED_FRICTION | 35 | 60 | ~2:49 | ~2.82s | 100% | PASS_CANDIDATE |

## Architecture stability

All three known cases used the same six layers:
1. Dramatic Hierarchy
2. Episode / Sequence Visual Strategy
3. Visual Intention
4. Semantic Shot
5. Visual Beat
6. Timing & Edit

What changed was episode configuration, not architecture.

## Rules discovered during validation

Agent:
- exact shot size belongs at Visual Beat level;
- Visual Beat may override local visual intention;
- punchline object reveal may require setup + reveal images.

Context / Memory:
- locked-script coverage must be 100%;
- spoken enumeration must not automatically inflate montage/image count.

MCP:
- no new structural rule;
- parallel/repeated friction can remain visually coherent without architecture diagrams.

## Next required evidence

Run one unseen fourth script that did not influence v0.1/v0.3 rule discovery.

Pass criterion:
the fourth script should require only episode-specific configuration, not a seventh layer or major rewrite of the six-layer architecture.