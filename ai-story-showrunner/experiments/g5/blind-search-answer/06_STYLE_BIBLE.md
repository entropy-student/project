# Blind Search Answer — Style Bible v0.2

## STYLE_CHANNEL_001

Status:
`DIRECTION_APPROVED / PRODUCTION_REFERENCE_CALIBRATION_IN_PROGRESS`

Owner approved direction:
**扁平简化漫画风 / simplified flat narrative comic style**

## Why this direction

Chosen over:
- higher-detail light narrative illustration;
- ultra-minimal line-art character;
- chibi / Q-symbolic style.

Reason:
best balance of:
- character identity;
- story performance;
- repeatability;
- lower drift risk;
- compatibility with workdesk / UI / prop scenes;
- limited-animation still-image production.

## Core visual language

- story-first still illustration;
- simplified anime/comic proportions, not chibi;
- clean stable outline;
- reduced hair strand complexity;
- 1–2 flat shadow levels;
- restrained clothing folds;
- clear face and hand readability;
- readable action silhouettes;
- simplified recurring background geometry;
- no decorative detail without story function;
- no PPT / slide-deck composition;
- no infographic-first framing;
- no generic neon-AI visual language.

## Character simplification lock

Preserve:
- youthful male narrator identity;
- dark tousled short hair silhouette;
- warm, rational, gentle expression baseline;
- wine-red top;
- cream/off-white collar;
- black trousers;
- simple white shoes.

Simplify:
- hair into a small number of stable major clumps;
- skin shading to broad flat shapes;
- clothing folds to only major structural folds;
- background props to stable story-relevant objects.

Do NOT simplify into:
- stick figure;
- faceless mascot;
- chibi head/body ratio;
- generic office avatar.

## Surface goal

Each frame should look like:
> one clear story moment featuring the same recurring character in the same visual world.

It should NOT look like:
- a polished standalone anime poster;
- a UI tutorial screenshot;
- a presentation slide;
- a stock illustration with floating icons.

## UI integration

UI/screens live inside the story space.

For exact critical text:
`POST_OVERLAY` remains preferred.

## Color direction

Primary character accent:
- wine red.

Supporting environment:
- warm off-white / beige;
- charcoal / dark gray;
- muted neutral wood;
- restrained green plant accents.

Avoid:
- highly saturated cyber-blue/purple gradients;
- random accent colors between beats.

## Production-reference strategy

Human-facing Character Guide is NOT the only machine reference.

Machine generation should use only the references needed for the beat:
1. character identity master;
2. relevant angle / pose reference;
3. scene master;
4. style calibration reference;
5. UI / prop master if causal.

## Calibration Gate

Before full episode generation, approve:
1. Production Character Master v2 — simplified four-view;
2. Workdesk Scene Master — stable geometry;
3. three real G4 calibration frames:
   - character + desk;
   - character + UI/evidence;
   - pure evidence insert.

Only after these pass:
`STYLE_CHANNEL_001 = VISUAL_LOCKED`

Failure:
`RETURN_STYLE_DRIFT`
