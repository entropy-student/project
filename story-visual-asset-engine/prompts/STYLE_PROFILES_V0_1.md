# Style Profiles v0.1

Status: `G1 BENCHMARK INPUT`

These are deliberately compact style locks. Scene-specific prompts are appended separately.

## STYLE_A_LIMITED_2D_STORY_COMIC

```text
2D narrative comic frame; clean medium-weight line art; flat color fills; limited recurring palette; at most one simple cel-shadow layer; low-texture background; clear silhouettes; readable adult facial expressions and body language; cinematic story composition; polished but intentionally simplified; no infographic layout; no embedded text; no photorealism; no 3D render.
```

### Expected reuse behavior
Best candidate for:
- crop/reframe;
- character/background separation;
- pose/expression variants;
- derive edits;
- limited-motion/cutout animation.

## STYLE_B_MONOCHROME_STORYBOARD_PLUS

```text
polished editorial storyboard frame; expressive clean ink drawing; monochrome or restrained 2–4 tone palette; sparse controlled shading; simplified background; strong silhouette and acting; cinematic framing; finished storyboard quality, not rough scribbles; no infographic layout; no embedded text; no photorealism; no 3D render.
```

### Expected reuse behavior
Best candidate for:
- defect tolerance;
- fast visual comprehension;
- aggressive crop/reframe;
- inexpensive-looking-but-intentional story boards.

## STYLE_C_SIMPLIFIED_ANIME_CEL

```text
simplified anime-inspired 2D story frame; adult proportions; clean controlled line art; flat cel colors; restrained two-level shading; expressive but natural acting; moderately simplified environment; cinematic camera composition; consistent wardrobe and face design; no hyper-detailed rendering; no infographic layout; no embedded text; no 3D render.
```

### Expected reuse behavior
Potentially strongest perceived finish, but benchmark must verify:
- identity stability;
- wardrobe stability;
- edit continuity;
- retry burden.

---

# Shared character/reference block

When a provider supports image references:

```text
REFERENCE_BINDINGS:
Preserve the recurring character identity, apparent age, face shape, hair, wardrobe silhouette and palette from the supplied accepted character reference. Do not redesign the character.
```

Text-only fallback:

```text
CHARACTER_LOCK:
Recurring adult IP character. Preserve the same apparent age, face shape, hairstyle, wardrobe silhouette and recurring palette across all boards.
```

# Shared story-frame constraints

```text
MUST_KEEP:
single clear story action; readable emotion; cinematic shot intent; stable character identity.

MUST_NOT:
infographic/PPT composition; decorative labels; speech bubbles unless explicitly requested; random extra props; extra people; unnecessary texture; photorealism; 3D rendering.
```

# Model-sheet prompt

```text
Create a character design turnaround/model sheet for the recurring adult IP: front, 3/4, side and back views; same proportions, face, hair and wardrobe in every view; neutral standing pose; plain background; minimal perspective distortion; design reference asset, not a story scene; no labels or decorative text.
```

# Ordinary story-frame prompt skeleton

```text
[STYLE_PROFILE]

[REFERENCE_BINDINGS]

SHOT_INTENT:
[one sentence describing what changes in the story]

CAMERA:
[shot scale + angle + POV]

ACTION:
[one primary physical action]

EMOTION:
[one primary readable emotion]

ENVIRONMENT:
[only details that materially support this beat]

MUST_KEEP:
[continuity locks]

MUST_NOT:
[scene-specific exclusions]
```
