# Character Identity Lock v0.1 — CANONICAL

## Status

`CANONICAL / G5 CHARACTER IDENTITY HARD LOCK`

Purpose:
prevent recurring-character drift across generated and edited stills.

Core rule:

> **风格可以简化；身份不能被简化。**

Simplification may reduce render complexity.
It may NOT change identity geometry, maturity, costume or body proportion.

---

## 1. Reference precedence

For every recurring character:

```text
Canonical Identity Source
>
Approved Production Character Master
>
Approved angle / pose reference
>
Previous accepted frame
>
Prompt prose
```

A previous generated frame is NEVER the identity truth.

It may help preserve:
- pose;
- scene placement;
- local lighting;
- local continuity.

It may NOT redefine:
- age/maturity;
- face shape;
- eye size;
- jaw;
- nose;
- hair silhouette;
- body proportion;
- costume.

Failure:
`RETURN_REFERENCE_PRECEDENCE_VIOLATION`

---

## 2. CHAR_IP_001 maturity lock

CHAR_IP_001 must read as:

> **young adult male / 成年青年男性**

Not:
- child;
- teen;
- school-age boy;
- chibi;
- baby-faced mascot;
- cute-boy reinterpretation.

Hard identity cues:

- clearly adult head/body proportion;
- natural adult eye size;
- stable jaw/chin geometry;
- visible but restrained nose structure;
- no exaggerated cheek roundness;
- no childlike shortened midface;
- no oversized head;
- no blush used to make the character cute/juvenile.

This is an identity property, not a style preference.

Failure:
`RETURN_CHARACTER_MATURITY_DRIFT`

---

## 3. Face geometry lock

Do not simplify:

- face outline;
- jaw width;
- chin length;
- eye-to-face ratio;
- inter-eye spacing;
- nose placement/structure;
- mouth placement;
- ear position;
- hairline;
- canonical fringe partition.

Allowed:
- fewer internal hair strands;
- fewer skin shading layers;
- less rendering texture.

Rule:

> **Reduce drawing detail, not facial anatomy.**

---

## 4. Body proportion lock

Preserve canonical adult body proportion.

Do not:
- enlarge head relative to body;
- shorten torso/limbs into chibi proportions;
- compress shoulders into childlike proportions;
- replace adult posture with cute mascot posture.

Pose may change.
Proportion may not.

---

## 5. Costume lock

For current channel IP:

- wine-red top;
- cream/off-white collar;
- black trousers;
- simple white shoes.

Unless a story explicitly requires a costume change, the default costume is immutable.

Do NOT silently substitute:
- hoodie;
- school uniform;
- T-shirt;
- jacket;
- alternate collar;
- novelty costume.

Failure:
`RETURN_COSTUME_DRIFT`

---

## 6. Hair lock

Preserve:
- canonical dark short tousled silhouette;
- major fringe partition;
- overall top/side volume;
- hairline.

Simplification allowed:
- fewer stable major clumps;
- fewer flyaway strands;
- less texture.

Do NOT:
- change into bowl cut;
- childlike fluffy cap;
- anime spikes unrelated to source;
- different fringe pattern.

---

## 7. Expression lock

Expression may change without changing identity.

Allowed:
- neutral;
- skeptical;
- thinking;
- surprised;
- speechless;
- serious;
- mild smile;
- discovery.

Do not express emotion by changing:
- eye anatomy;
- face age;
- jaw geometry;
- head proportion.

---

## 8. Style simplification boundary

Style simplification may affect ONLY:

```text
hair micro-strands
shadow layers
clothing micro-folds
surface texture
background detail
decorative props
```

It may NOT affect:

```text
age
maturity
face geometry
eye scale
nose structure
jaw/chin
body proportion
costume identity
hair silhouette
```

---

## 9. Per-frame reference rule

Any frame containing CHAR_IP_001 must bind:

1. `CHAR_IP_001 canonical identity source`;
2. approved production character master / relevant angle when available;
3. style reference;
4. scene reference if applicable;
5. previous accepted frame only as secondary continuity support.

For `DERIVE_EDIT`:

> source_frame_ref is NOT sufficient by itself.

The edit must also bind canonical identity reference.

Failure:
`RETURN_CANONICAL_IDENTITY_REFERENCE_MISSING`

---

## 10. Drift propagation rule

If a generated frame already drifted:

> do NOT use it as the source of the next character frame.

Mark:
`REJECTED_CHARACTER_DRIFT`

Return to the nearest accepted frame + canonical identity source.

This prevents:

```text
small drift
→ next frame inherits drift
→ cumulative identity collapse
```

---

## 11. Production QA

Every character frame must pass:

### Identity
same person?

### Maturity
clearly young adult, not teen/child?

### Face
jaw / eye scale / nose / fringe stable?

### Body
adult proportion stable?

### Costume
canonical outfit unchanged?

### Style
simplified rendering without simplified anatomy?

Any failure:
do not continue derivation chain.

---

## 12. Current project-specific diagnosis

Observed Pilot failure modes:

- larger rounder eyes;
- shorter/rounder jaw;
- weakened nose structure;
- blush/cute rendering;
- smaller/younger body impression;
- wine-red collared top silently changed into hoodie;
- extra cute props reinforced juvenile semantics.

Diagnosis:

`CHARACTER_IDENTITY_DRIFT / MATURITY_DRIFT / COSTUME_DRIFT`

Corrective action:

- restore canonical IP as identity truth;
- prohibit juvenile reinterpretation;
- prohibit costume substitution;
- simplify rendering detail only;
- revalidate one character Pilot frame before continuing the full Pilot.
