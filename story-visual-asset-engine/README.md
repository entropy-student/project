# Story Visual Asset Engine

Status: `P0_RESEARCH_IN_PROGRESS`

## Goal

Build a reusable visual-asset system for story-first image-sequence video:

```text
story beat / shot need
→ search existing asset library
→ reuse / crop / derive / composite when possible
→ generate only when reuse cannot satisfy the shot
→ record asset identity, prompt, lineage, quality and usage
→ feed accepted boards/assets to Story Showrunner
```

The project optimizes four things together:

1. visual quality above an acceptable floor;
2. character/style consistency;
3. total generation cost and retry cost;
4. cross-episode reuse rate.

This is a standalone R&D/production-system project. It must not mutate `ai-story-showrunner` contracts until its own pilot passes.

## Governance

Canonical governance:
`entropy-student/spike.skill/vps-project-governance`

Project truth:
`REVIEWER_HANDOFF.md`

Research and current evidence:
`docs/RESEARCH_BASELINE_V0_1.md`
`EXECUTION_EVIDENCE.md`
