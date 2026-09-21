# Blind Search Answer — Character Bible v0.2

## CHAR_IP_001 — Recurring Channel IP

Status:
`IDENTITY_DIRECTION_LOCKED / PILOT_REVALIDATION_REQUIRED`

Canonical identity policy:
`docs/CHARACTER_IDENTITY_LOCK.md`

Canonical identity source:
Owner-approved original IP image supplied in the current conversation.

Repository binary state:
`NOT_YET_PERSISTED`

## Identity definition

CHAR_IP_001 is a:

> **young adult male / 成年青年男性**

He must NOT drift into:
- teen / school-age boy;
- chibi;
- cute-boy reinterpretation;
- baby-faced mascot.

## Hard locked identity

Do NOT invent, simplify or redesign:

- age / maturity impression;
- face outline;
- jaw / chin geometry;
- eye-to-face ratio;
- nose structure;
- hairstyle silhouette / fringe partition / hair color;
- body proportion;
- default costume;
- canonical colors.

### Default costume

- wine-red top;
- cream/off-white collar;
- black trousers;
- simple white shoes.

Do NOT silently replace with:
- hoodie;
- T-shirt;
- school uniform;
- jacket;
- novelty costume.

## Allowed style simplification

May simplify:
- hair micro-strands;
- shadow layers;
- clothing micro-folds;
- surface texture;
- background detail.

May NOT simplify:
- facial anatomy;
- adult proportion;
- maturity;
- costume identity;
- major hair silhouette.

Rule:

> **画法可以变简单，人不能变小孩。**

## Allowed per-beat variation

- expression;
- eye direction;
- head direction;
- arm/hand pose;
- seated/standing pose;
- interaction with mouse / monitor / cost sheet;
- camera-relative orientation.

Expression must not be created by changing identity geometry.

## Reference precedence

```text
Owner canonical IP image
>
Approved Production Character Master
>
Approved angle / pose reference
>
Previous accepted frame
>
Prompt prose
```

A previous generated frame is continuity support only.
It never becomes the identity truth.

## Per-frame rule

Every Beat containing CHAR_IP_001 must:

1. bind `CHAR_IP_001`;
2. attach canonical identity reference;
3. preserve adult maturity / face / body / costume hard locks;
4. attach scene/style refs as required;
5. optionally attach previous accepted frame for local continuity.

For `DERIVE_EDIT`:
source frame alone is insufficient.
Canonical identity reference must still be bound.

## Drift-chain protection

If a generated character frame fails identity/maturity/costume QA:

`REJECTED_CHARACTER_DRIFT`

Do NOT use it as the next source frame.

Return to:
nearest accepted frame + canonical identity source.

## Required character QA

- same person?
- clearly adult young man?
- natural eye size?
- jaw/chin stable?
- nose structure present?
- hair silhouette/fringe stable?
- adult body proportion stable?
- wine-red collared costume unchanged?
- no cute/chibi semantics introduced?

Failure:
- `RETURN_CHARACTER_DRIFT`
- `RETURN_CHARACTER_MATURITY_DRIFT`
- `RETURN_COSTUME_DRIFT`
