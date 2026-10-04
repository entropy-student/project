# G3CR6R3C Core Aha — Shortlist and Reviewer Recommendation

> Reviewer result: CORE_AHA_RESEARCH=PASS
> Owner selection: PENDING

## Recommendation — PHOTO_TO_ISSUE_MORPH / “照片成刊”

The strongest Core Aha is an **original composite interaction**, not a copied template:

> **one browser-local photo → continuously becomes the magazine cover → paper layers appear → cover opens/reframes into the first interior spread**

The continuity is the point: the user should never feel that the site “loaded another demo.” The same chosen photo visibly changes identity from **photo** to **their issue**.

### Proposed interaction contract

1. **Input state:** existing local Preview has recipient name, age/birthday, style preset, and optional one browser-local photo.
2. **Photo locks into cover (0–0.7s):** the same visual element/crop scales into a portrait magazine frame; paper edge, subtle spine/shadow and issue proportions appear.
3. **Editorial identity arrives (0.5–1.1s):** deterministic masthead/recipient name/birthday issue labels stage around the photo. No invented memories or personal facts.
4. **“There is a whole issue” cue (1.0–1.6s):** 2–3 restrained paper layers fan behind the cover.
5. **First-spread reveal (1.4–2.2s):** the cover shifts/opens just enough to reveal one deterministic sample interior spread.
6. **End state:** CTA enters the already accepted magazine web viewer / sample-spread experience.

The transition should feel like a crafted editorial object coming into existence, not a game-like 3D book.

## Why this wins

The frozen MVP activation target is: **“This already looks like their magazine.”** A direct photo→cover identity change answers that sentence earlier and more literally than a generic page-turn animation.

It also satisfies the current free-preview boundary:
- photo can remain the existing browser-local object URL;
- no server photo upload;
- no LLM, vision, image-generation or production call;
- no fabricated personal story;
- final PDF architecture stays separate.

## Weighted shortlist

| Rank | Pattern | Impact 25 | Interaction 25 | Editorial/gift 15 | Art 15 | System 10 | Mobile/a11y 10 | Total | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | **Reviewer synthesis: Photo→Cover→First Spread** | 25 | 23 | 15 | 14 | 9 | 9 | **95 / S** | RECOMMEND |
| 2 | C01 Preview→Full Content | 22 | 22 | 15 | 14 | 9 | 8 | **90 / S** | primary transition reference |
| 3 | C03 Stack→Content | 23 | 23 | 13 | 13 | 9 | 8 | **89 / S** | paper/fan staging reference |
| 4 | C02 Large Image→Content | 22 | 22 | 14 | 13 | 8 | 8 | **87 / S** | image continuity reference |
| 5 | C05 Fullscreen Clip | 23 | 22 | 12 | 13 | 8 | 8 | **86 / S** | clip/mask reference |
| 6 | C04 Cover Page Transition | 22 | 21 | 15 | 12 | 8 | 7 | **85 / S** | cover-open semantic reference |
| 7 | C73 StPageFlip | 20 | 20 | 15 | 11 | 8 | 7 | **81 / A** | later reader only |
| 8 | C76 Motion Shared Layout | 20 | 22 | 10 | 12 | 9 | 9 | **82 / A** | implementation reference only |

## Why “real page flip” is demoted

A realistic page-turn is useful **after** the user already believes the artifact is a magazine. As the first Aha it starts with the conclusion (“here is a book”) and skips the transformation (“your photo became the issue”). It is therefore reserved for the reader, not the activation moment.

## Desktop / mobile / reduced motion

**Desktop**
- pointer/hover may add subtle tilt or light response after the core sequence;
- the core sequence itself must not require pointer discovery.

**Mobile**
- tap/automatic sequence only;
- 2D/2.5D translate/scale/clip, no mandatory WebGL or heavy 3D;
- no drag gesture required to understand the result.

**Reduced motion / no controller**
- immediately show the completed personalized cover plus visible sample spread;
- motion is enhancement, never a content/access dependency.

## Frozen-homepage integration boundary

The accepted homepage is not redesigned. The later implementation may only replace/augment the existing **core experience entry surface** so that the current local Preview transitions into this sequence. Header, page rhythm, other homepage sections and Woo path remain frozen.
