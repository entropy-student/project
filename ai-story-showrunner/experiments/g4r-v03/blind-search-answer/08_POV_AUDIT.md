# Search Answer — POV Audit v0.1

Status: `PASS / BOUNDED_PATCH`

Canonical:
`docs/G4_VIEWPOINT_GRAMMAR.md`

## Result

44 Visual Beats reviewed.

- changed: 8
- unchanged: 36
- architecture rewrite: NO

| Beat | Before | After | Reason |
|---|---|---|---|
| VB004 | OBSERVER | IP_POV | exact question should be experienced from narrator side |
| VB009 | OBSERVER | IP_POV_HANDS | protagonist personally writes the causal assumption |
| VB011 | OBSERVER | OVER_SHOULDER_IP | preserve actor ownership while entering page discovery |
| VB027 | OBSERVER | IP_POV | exact evidence-challenge query is the new action |
| VB031 | OBSERVER | OBJECTIVE_INSERT | supporting sentence itself is causal |
| VB036 | OBSERVER | OBJECTIVE_INSERT | verified quote itself is causal |
| VB037 | OBSERVER | OBJECTIVE_INSERT | wrong conclusion is the payoff object |
| VB042 | OBSERVER | IP_POV | viewer should inhabit the new verification question |

## Key finding

The prior system had a mild `OBSERVER_DEFAULT_BIAS`.

It was not a broad G4 failure.

Failure pattern:
first-person owned actions / exact evidence sometimes inherited the surrounding desk scene's OBSERVER strategy even when the local Beat needed subjective or object-isolated framing.

## VB009 correction

Old:
`MEDIUM_INSERT / OBSERVER`

New:
`MEDIUM_INSERT / IP_POV_HANDS / DOWNWARD_DESK_IP_POV`

Meaning:
viewer looks down with the narrator at their own hand, burgundy sleeve/cuff, pen and cost-sheet row.

The frame should not show the full face or become a third-party desk illustration.

## Downstream implication

POV can change Beat Asset Binding.

Examples:
- object/IP-POV inserts often do NOT need full character + full scene refs;
- character refs are kept only when body/hand identity cues are actually visible;
- OVER_SHOULDER retains character + scene + target;
- OBJECTIVE_INSERT binds causal UI/prop only.

This reduces unwanted full-character generation and clutter.
