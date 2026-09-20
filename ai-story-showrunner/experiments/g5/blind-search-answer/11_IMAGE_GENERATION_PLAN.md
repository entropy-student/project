# Blind Search Answer — G5C Image Generation Plan

> Status: PASS_CANDIDATE / 44 rows compiled
> No batch generation has started.

## Summary

- Visual Beats: 44
- Image rows: 44
- Mapping: 1 Visual Beat → 1 image row
- Aspect ratio: 16:9
- Resolution: 1920×1080
- Style: Simplified Flat Narrative Comic
- Validation: PASS

## Production rule

Critical Chinese text uses `POST_OVERLAY` instead of trusting image-generation text fidelity.
Character/scene/UI identity is supplied through stable asset IDs plus continuity refs where appropriate.

## Human-readable rows

| Image | Beat | Time | Shot | POV | Main image state | Refs | Continuity | Text |
|---|---|---:|---|---|---|---|---|---|
| IMG_001 | SRCH_VB001 | 0.00–5.25 | MEDIUM_CLOSE | OBSERVER | official-source cue appears under answer; IP no longer relaxes automatically | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_002 | SRCH_VB002 | 5.25–6.74 | MEDIUM_CLOSE | OBSERVER | hand/cursor moves to open the source instead | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_001 | NONE |
| IMG_003 | SRCH_VB003 | 6.74–11.97 | MEDIUM | OBSERVER | IP frames this as a tiny easy rule-check he wants to outsource | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_002 | NONE |
| IMG_004 | SRCH_VB004 | 11.97–16.02 | MEDIUM_INSERT | OBSERVER | exact question facet lands: 平台服务费会不会退 | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_003 | NONE |
| IMG_005 | SRCH_VB005 | 16.02–18.71 | MEDIUM | IP_POV | AI performs search and answer state arrives | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_004 | POST_OVERLAY |
| IMG_006 | SRCH_VB006 | 18.71–21.39 | INSERT | IP_POV | answer conclusion becomes focal: 会 | SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_005 | POST_OVERLAY |
| IMG_007 | SRCH_VB007 | 21.39–24.59 | MEDIUM_INSERT | IP_POV | official help-center source appears directly under the answer | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_006 | POST_OVERLAY |
| IMG_008 | SRCH_VB008 | 24.59–30.49 | MEDIUM_CLOSE | OBSERVER | IP visibly relaxes because the answer looks source-backed; no literal classroom cutaway | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_007 | POST_OVERLAY |
| IMG_009 | SRCH_VB009 | 30.49–34.35 | MEDIUM_INSERT | OBSERVER | IP writes 服务费：可退 into the cost sheet | CHAR_IP_001, SCENE_WORKDESK_001, PROP_COST_SHEET_001, STYLE_CHANNEL_001 | IMG_008 | POST_OVERLAY |
| IMG_010 | SRCH_VB010 | 34.35–38.73 | MEDIUM | OBSERVER | task appears finished; IP is already about to move on, then hesitates | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_009 | NONE |
| IMG_011 | SRCH_VB011 | 38.73–40.58 | MEDIUM_CLOSE | OBSERVER | IP clicks the official source almost casually | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_010 | POST_OVERLAY |
| IMG_012 | SRCH_VB012 | 40.58–42.94 | WIDE_POV | IP_POV | same official refund page opens; title confirms source is correct | SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_011 | POST_OVERLAY |
| IMG_013 | SRCH_VB013 | 42.94–46.00 | MEDIUM_INSERT | IP_POV | AI-cited sentence is visibly present on that same page | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_012 | POST_OVERLAY |
| IMG_014 | SRCH_VB014 | 46.00–49.71 | INSERT | IP_POV | first policy sentence is highlighted: 订单款项退回原支付方式 | SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_013 | POST_OVERLAY |
| IMG_015 | SRCH_VB015 | 49.71–51.34 | MATCHED_INSERT | IP_POV | eye/cursor moves one line downward; final answer is not revealed yet | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_014 | POST_OVERLAY |
| IMG_016 | SRCH_VB016 | 51.34–53.48 | INSERT | IP_POV | reveal: 平台服务费不予退还 becomes dominant | SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_015 | POST_OVERLAY |
| IMG_017 | SRCH_VB017 | 53.48–54.88 | CLOSE | OBSERVER | silent hold on the contradiction | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_016 | NONE |
| IMG_018 | SRCH_VB018 | 54.88–57.24 | MATCHED_INSERT | IP_POV | IP looks back to AI answer: 会 | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_017 | POST_OVERLAY |
| IMG_019 | SRCH_VB019 | 57.24–59.21 | MATCHED_INSERT | IP_POV | IP looks back to official page: 不予退还 | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_018 | POST_OVERLAY |
| IMG_020 | SRCH_VB020 | 59.21–64.61 | MEDIUM_WIDE | OBSERVER | investigation rules out easy causes: not offline, not forum, not dubious source | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_019 | NONE |
| IMG_021 | SRCH_VB021 | 64.61–67.62 | MEDIUM | OBSERVER | correct official page remains physically present as the evidence object | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_020 | POST_OVERLAY |
| IMG_022 | SRCH_VB022 | 67.62–72.85 | MATCHED_INSERT | IP_POV | matched comparison isolates question facet 服务费 against cited facet 订单款项 | SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_021 | POST_OVERLAY |
| IMG_023 | SRCH_VB023 | 72.85–75.37 | MEDIUM | OBSERVER | analogy question: 老板今天来不来 | CHAR_IP_001, SCENE_PHONEBOOK_ANALOGY_001, PROP_CONTACT_BOOK_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_024 | SRCH_VB024 | 75.37–79.92 | MEDIUM_INSERT | OBSERVER | person accurately opens the boss's correct contact record | CHAR_IP_001, SCENE_PHONEBOOK_ANALOGY_001, PROP_CONTACT_BOOK_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_025 | SRCH_VB025 | 79.92–83.91 | MEDIUM_TWO_SHOT | OBSERVER | wrong-facet answer lands: 老板电话是138…; correct record still does not answer attendance question | CHAR_IP_001, SCENE_PHONEBOOK_ANALOGY_001, UI_AI_ANSWER_001, PROP_CONTACT_BOOK_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_026 | SRCH_VB026 | 83.91–87.62 | MEDIUM | OBSERVER | back at desk, IP changes strategy: no longer asks for conclusion first | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | - | NONE |
| IMG_027 | SRCH_VB027 | 87.62–91.16 | MEDIUM_INSERT | OBSERVER | new evidence challenge is focal: 哪一句明确说明服务费会退 | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_026 | POST_OVERLAY |
| IMG_028 | SRCH_VB028 | 91.16–92.50 | MEDIUM | IP_POV | AI returns attention to the same official page | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_027 | POST_OVERLAY |
| IMG_029 | SRCH_VB029 | 92.50–93.99 | MATCHED_INSERT | IP_POV | same answer pane changes conclusion after evidence check | SCENE_WORKDESK_001, UI_AI_ANSWER_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_028 | POST_OVERLAY |
| IMG_030 | SRCH_VB030 | 93.99–97.70 | MEDIUM_WIDE | OBSERVER | whole correct page is shown as one evidence object | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_029 | POST_OVERLAY |
| IMG_031 | SRCH_VB031 | 97.70–100.88 | MEDIUM_INSERT | OBSERVER | attention narrows from whole page to the exact supporting sentence | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_030 | POST_OVERLAY |
| IMG_032 | SRCH_VB032 | 100.88–106.78 | MEDIUM_WIDE | OBSERVER_WITH_POV | same question-page workspace compares true correspondence vs merely similar wording | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_033 | SRCH_VB033 | 106.78–107.98 | INSERT | IP_POV | exception line becomes explicit check point | SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | - | POST_OVERLAY |
| IMG_034 | SRCH_VB034 | 107.98–110.84 | MEDIUM_WIDE | OBSERVER | multiple relevant lines are considered together before final conclusion | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | - | NONE |
| IMG_035 | SRCH_VB035 | 110.84–116.57 | MEDIUM_WIDE | OBSERVER | one answer package remains on screen while source and link are confirmed real | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_034 | POST_OVERLAY |
| IMG_036 | SRCH_VB036 | 116.57–118.59 | MEDIUM_INSERT | OBSERVER | quoted sentence is also confirmed real | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_035 | POST_OVERLAY |
| IMG_037 | SRCH_VB037 | 118.59–120.93 | MEDIUM_CLOSE | OBSERVER | final conclusion alone remains mismatched/wrong | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_036 | NONE |
| IMG_038 | SRCH_VB038 | 120.93–123.95 | MEDIUM_CLOSE | OBSERVER | IP sees a cited AI answer but does not treat the citation badge as proof by itself | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_037 | POST_OVERLAY |
| IMG_039 | SRCH_VB039 | 123.95–126.47 | MEDIUM | OBSERVER | a low-stakes answer passes without a verification ritual; IP keeps working normally | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_038 | POST_OVERLAY |
| IMG_040 | SRCH_VB040 | 126.47–130.85 | MEDIUM_WIDE | OBSERVER | money / plan / hard-to-reverse consequences enter the working decision space and cause a visible stop | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_039 | NONE |
| IMG_041 | SRCH_VB041 | 130.85–132.20 | MEDIUM_CLOSE | OBSERVER | IP pauses before action and turns back to the source/answer with one deliberate follow-up | CHAR_IP_001, SCENE_WORKDESK_001, UI_AI_ANSWER_001, STYLE_CHANNEL_001 | IMG_040 | POST_OVERLAY |
| IMG_042 | SRCH_VB042 | 132.20–135.55 | MEDIUM_INSERT | OBSERVER | verification question becomes the action: 哪句话真的支持这个结论 | CHAR_IP_001, SCENE_WORKDESK_001, STYLE_CHANNEL_001 | IMG_041 | NONE |
| IMG_043 | SRCH_VB043 | 135.55–139.62 | MEDIUM_CLOSE | OBSERVER | final setup returns to the seductive feeling of a correct webpage | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_042 | POST_OVERLAY |
| IMG_044 | SRCH_VB044 | 139.62–142.21 | MEDIUM_CLOSE | OBSERVER | opening callback resolves: official page is correct, and IP clicks/checks it before accepting the conclusion | CHAR_IP_001, SCENE_WORKDESK_001, UI_POLICY_PAGE_001, STYLE_CHANNEL_001 | IMG_043 | POST_OVERLAY |

## Pilot recommendation

Before generating all 44 images, validate these high-risk rows:

- `SRCH_VB001` — character + workdesk identity baseline
- `SRCH_VB009` — character + causal cost-sheet prop
- `SRCH_VB012` — stable official-page master
- `SRCH_VB015` — setup must withhold reveal
- `SRCH_VB016` — matched reveal on same page
- `SRCH_VB022` — question/evidence semantic comparison
- `SRCH_VB025` — temporary analogy world + contact prop
- `SRCH_VB044` — opening-composition callback / final behavior change

Pilot PASS should precede full 44-image batch execution.