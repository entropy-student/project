# G1 Style + Reuse Benchmark Spec v0.1

Date: 2026-09-23  
Status: `READY_NOT_EXECUTED`

## 1. Goal

Select a production style family using repeatable evidence, not the prettiest cherry-picked image.

The winner must satisfy:
- audience-facing quality floor;
- recurring character stability;
- story readability;
- direct reuse and reference-driven edit/derive potential;
- acceptable retry burden;
- acceptable generation cost.

## 2. Controlled variables

For a given provider/model run:
- same model;
- same size/aspect ratio;
- same quality setting;
- same character reference set;
- same shot semantics;
- same generation-count policy;
- same acceptance rules.

The only intended primary variable is `STYLE_PROFILE`.

If provider changes, that is a separate benchmark stratum and must not be mixed into one style conclusion.

## 3. Candidate styles

- `STYLE_A_LIMITED_2D_STORY_COMIC`
- `STYLE_B_MONOCHROME_STORYBOARD_PLUS`
- `STYLE_C_SIMPLIFIED_ANIME_CEL`

Definitions live in:
`prompts/STYLE_PROFILES_V0_1.md`.

## 4. Fixed 10-shot benchmark set

```text
B01 CHARACTER_MASTER
    recurring IP turnaround/model sheet

B02 NEUTRAL_MEDIUM
    recurring IP, neutral medium shot, simple interior

B03 CONFUSION_CLOSEUP
    same IP, close-up confused reaction

B04 THINKING_SIDE
    same IP, side/3-4 view at a computer, thinking

B05 EXPLAIN_POINT
    same IP, explaining/pointing gesture

B06 ROOM_WIDE
    wide establishing shot of recurring room

B07 ROOM_NEW_ANGLE
    same room, materially different camera angle

B08 TWO_CHARACTER
    recurring IP interacting with a secondary adult character

B09 DOCUMENT_INSERT
    close insert of a generic document/screen/prop, no brand

B10 DERIVE_EDIT
    take one accepted B02/B04 image and alter action/emotion while preserving identity/environment
```

## 5. Cost-saving staged execution

Do not immediately burn 30+ generation calls. Local crop/reframe and local compositing are explicitly out of scope by Owner decision.

### G1A — early-discrimination set

Run B01, B02, B03, B04, B10 for all three styles.

Base target:
`5 tasks × 3 styles = 15 low-quality screening outputs`.

Use the lowest provider quality tier that still produces reviewable images. Only styles that survive G1A proceed to higher-quality confirmation; do not spend final-quality generation on styles already eliminated.

If a style fails hard quality/consistency gates in >=3 of 5 tasks, it may be returned early and does not proceed to G1B.

### G1B — finalist stress set

Only surviving styles run B05–B09.

For finalists:
- repeat representative accepted shots at the intended production quality;
- keep provider/model/size controlled;
- record actual billed usage/cost;
- use reference-driven generation/edit where the test calls for continuity;
- use prompt caching when the provider supports it and the repeated prefix is identical.

This reduces benchmark cost while preserving comparable evidence.

## 6. Prompt structure

Each request compiles:

```text
STYLE_PROFILE
REFERENCE_BINDINGS
SHOT_INTENT
CAMERA
ACTION
EMOTION
ENVIRONMENT
MUST_KEEP
MUST_NOT
```

Do not restate irrelevant character details.

Do not ask the model to create captions, labels or explanatory text inside story frames.

## 7. Hard RETURN conditions

A candidate output returns if any material issue exists:
- wrong/missing recurring character identity;
- wrong apparent age class;
- wrong wardrobe lock when wardrobe should remain fixed;
- extra character when forbidden;
- severe hand/limb/body defect;
- camera intent materially wrong;
- story action unreadable;
- PPT/infographic layout when a story frame was requested;
- baked-in text when forbidden;
- derive/edit request destroys identity or environment continuity.

## 8. Measurements

Per output record:

### Mechanical
- provider/model;
- quality;
- size;
- generation latency;
- billed/usage tokens or cost if exposed;
- generation attempt number;
- generation vs edit;
- reference-image count;
- quality tier (screening/final);
- prompt-cache status if exposed.

### QA
Score 0–5:
- `identity_consistency`
- `wardrobe_consistency`
- `style_consistency`
- `story_readability`
- `composition_readability`
- `body_hand_integrity`
- `reuse_editability`
- `visual_appeal`

Also record:
- first-pass PASS: true/false;
- retry count;
- hard-return reason;
- accepted asset ID if retained.

## 9. Aggregate metrics

Primary:
- first-pass acceptance rate;
- median retries per accepted frame;
- hard-return rate;
- median identity consistency;
- median story readability;
- median direct-reuse/reference-editability.

Cost:
- generation calls per accepted asset;
- edit calls per accepted asset;
- billed cost/tokens if provider exposes them.

Do not infer lower token cost from style name alone.

## 10. Decision rule

A style cannot win if:
- first-pass acceptance < 60%; or
- median identity consistency < 4/5; or
- median story readability < 4/5.

Among remaining candidates, select based on production behavior:
1. lowest retry/call burden;
2. strongest identity + style consistency;
3. strongest direct reuse/reference-editability;
4. adequate audience-facing visual appeal.

Do not select from one exceptional best frame.

## 11. STOP condition

At the end of G1:
- preserve all accepted/rejected benchmark records;
- Reviewer evaluates evidence;
- return `PASS_CANDIDATE_STYLE_<ID>` or `RETURN_G1_<CAUSE>`;
- do not integrate with Story Showrunner yet.


## 12. Explicitly excluded cost path

Owner decision:
- no local crop/reframe workflow;
- no local compositing workflow.

G1 therefore evaluates these cost levers only:
1. asset-library direct reuse;
2. low-quality-first screening, higher quality only for finalists/accepted production;
3. reference-driven generation/edit to reduce drift and retries;
4. prompt caching where supported;
5. fewer total generations/retries.

Do not reintroduce crop/composite as an optimization without a new Owner decision.
