# Skill Migration Review Summary v1

Date: 2026-09-22

Result:
`SKILL_EXTRACTION_R1_PASS / READY_FOR_CANDIDATE_MIGRATION`

## Reviewer conclusion

The system is ready to create a candidate `story-showrunner` Skill.

Do not copy the validation project wholesale.

Extraction model:

```text
stable generic contracts
→ Skill core

domain-specific research/topic/knowledge rules
→ domain adapters

Bilibili/Jingsui/first-person/current visual/character/voice choices
→ profiles

Antigravity/CosyVoice/Nano Banana
→ provider/executor adapters

Calendar/Registry/Episode state
→ runtime state outside Skill source

Pilot/validation/calibration history
→ remains in validation project
```

## R1 result

Resolved all 9 P0 conflicts:
- audio mode;
- speech-timing ownership;
- obsolete Writer SRT estimation;
- timing acceptance metric;
- stale Voice Profile spec;
- recurring G5 Pilot wording;
- stale G5 status;
- AI-specific core mechanism fields;
- candidate-vs-canonical migration lifecycle.

Also completed current-truth cleanup:
- REVIEWER_HANDOFF rewritten;
- CURRENT_STATUS normalized;
- README updated;
- Director observability output no longer implies Owner approval.

Timing vocabulary mapping was also pre-resolved.

## Remaining migration work

P1 work is now **structural extraction**, not unresolved product architecture:

1. split generic Writer contract from Bilibili/Jingsui/first-person editorial profile;
2. split generic Character Identity contract from CHAR_IP_001 profile;
3. move Simplified Flat Narrative Comic into visual profile;
4. split core Production Package contract from Antigravity/CosyVoice/Nano Banana adapters;
5. externalize local machine paths from frozen voice profile;
6. define RuntimeStateLocator for Calendar/Registry;
7. rename schema identity from AI Story Showrunner to Story Showrunner;
8. make Visual Beat timing source explicitly Production SRT.

## Next Gate

`SKILL_EXTRACTION_R2 — CANDIDATE MIGRATION`

R2 may now write to:
`entropy-student/spike.skill/story-showrunner/`

R2 must:
- create the candidate Skill structure;
- migrate only cleaned/reusable rules;
- preserve the current project as validation fixture;
- mark the Skill `CANDIDATE / E2E_NOT_YET_PROVEN`.

Canonical promotion remains blocked until the current episode produces a reviewable final video through the new production package/executor path.

No Owner intervention is required unless R2 uncovers a genuine product-policy ambiguity.
