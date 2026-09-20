# Blind Search Answer — Character Bible v0.1

## CHAR_IP_001 — Recurring Channel IP

Status:
`BLOCKED_BY_REAL_REFERENCE / SPEC_READY`

Canonical identity source:
the user's existing IP three-view reference.

Current repository state:
`MISSING_REAL_ASSET`

## Locked rule

Do NOT invent or redesign:
- face shape;
- hairstyle / hair color;
- age impression;
- body proportion;
- clothing;
- accessories;
- canonical colors.

Those identity fields must be extracted from the actual approved three-view image when available.

## Allowed per-beat variation

- expression;
- eye direction;
- head direction;
- arm/hand pose;
- seated/standing pose;
- interaction with mouse / monitor / cost sheet;
- camera-relative orientation.

## Required canonical views

- front;
- 3/4;
- side.

If the provided three-view already contains these, reuse it rather than regenerating a new identity sheet.

## Continuity rule

Every beat containing IP:
1. attach the same canonical IP reference;
2. preserve fixed identity/clothing;
3. use previous accepted frame only as an additional continuity reference where pose/desk geometry must continue;
4. never let a previous generated frame replace the canonical identity reference.

Failure:
`RETURN_CHARACTER_DRIFT`
