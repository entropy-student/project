# CWS｜Content Template Lab V2 返修 Gate 与 Reviewer 检查点

> **GATE_ID:** `CWS-TEMPLATE-LAB-V2-OFFLINE-REWORK-20261017`  
> **STATUS:** `V2_REVIEW_CANDIDATE / PARTIAL_VERIFICATION / DRAFT_PR_144`. This Gate is **not** R4 or formal CW0005 production.

## Gate contract

| Field | Decision |
|---|---|
| OBJECTIVE | Repair V1's static template, fake playback controls and mismatched Mac style; implement six time-based content uses as **pick template → insert media → timed preview** |
| MAX_ENDPOINT_THIS_ROUND | Add/rework PR#144 offline `visual/content-template-lab/index.html`, README and this scoped evidence/Gate documentation; independent browser QA; stop before main merge |
| MANDATORY_REVIEW_STOP | After checking candidate PR and verifying files/evidence. No full-video production, no public release |
| TARGET_AND_SCOPE | `entropy-student/project`, draft PR#144 branch `cws/content-template-lab-v1-20261017`; **no mainline or Owner Windows runtime writes** |
| APPLICABLE_CRITICAL_CONSTRAINTS | `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`, R3 overall Owner visual RETURN, source rights PARTIAL, original V2 Aqua visual identity, 2/4/6 formal-effects policy |
| PREFLIGHT | GitHub `main` current project state/Handoff/visual style and PR#144 scope read; isolated branch path only; no secrets/providers/ports/assets touched |
| REQUIRED_EVIDENCE | Read-back exact PR path/diff and HTML, template count, deterministic timing/seek, active video continuity under subtitle edit, demo fixture and time-step QA, source V2 delta, external-item provenance/status |
| ACCEPTANCE_CRITERIA | Desktop→player original motion retained; all six layouts work; one clock advances T5/T6 and playback controls; local media replaceable; edit does not reset video; 20–30 second sequential preview; explicit placeholder vs real media labels; candidate matches reviewed bytes |
| ROLLBACK_STATUS_OR_PLAN | PR remains unmerged and changes are limited to its two implementation/docs scopes; close/revert PR without affecting main, R3 or local backups |
| OWNER_ONLY_ACTIONS | NONE for isolated static prototype. Later real images/costs/production R4/public release/merge require separate review/authorization |
| REVIEWER_TO_EXECUTOR_RELAY | Reuse `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html` as original style baseline (don't mutate it), PR#144 V1 HTML as replaceable candidate, `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`, `docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md` and reviewer comment `#issuecomment-6232004762`; implement only offline video-template lab in PR |
| EXECUTOR_TO_REVIEWER_RELAY | Result; exact changed PR paths; browser and media evidence with provenance; known unverified steps; rollback; next reviewer checks; Owner relay NONE |

## V1 findings retained

V1 HTML could upload files/change text, but represented layouts only; the old player icon/progress were decorative, all sample media slots started empty, T5/T6 required manual next-click, and subtitle editing recreated a video node, resetting live playback. It did not implement the already accepted V2 mouse-to-file-to-player opener. **V1 was returned, not visually accepted.**

## V2 candidate change

1. Kept the original `g1va_v2_research_aqua_prototype.html` as the authoritative starting source; embedded a copy in a `srcdoc` iframe, removed only historical custom jelly animation **inside the demo shell** and adapted demonstration filename/time/loop control; original source file in main is unchanged.
2. Added timed preview across `0.00–28.76s`: A shell 4.76 seconds, then six T1–T6 scenes. All content templates use existing B full-player area.
3. T1 one asset; T2 two-source comparison; T3 footage + existing/approved illustrative image; T4 research/archival media; T5 three timed visual states; T6 three timed *illustrative* numeric states. Avoid claims of AI animation/scientific truth.
4. Media files only selected locally at runtime; no media package generated or uploaded to GitHub; no research rights assumed.
5. Subtitle and label fields update without DOM video replacement. Exported JSON is a *candidate plan*, not verified Remotion instructions.

## QA & actual limits

- **Direct technical browser readback of local V2 logic:** 6/6 scene panels render; T5 and T6 time-driven step changes; local QA video playback persists under subtitle edit; JSON six-scene export; no observed page JS exceptions in bounded successful tests.
- **Important limitation:** the local browser disallowed both `file://` and localhost navigation, so the automated suite used `set_content` and a local **stand-in for the Mac shell**. The GitHub commit embeds the true upstream V2 source by deterministic edits, but final exact integrated animation **is not yet independently browser-visually verified**. Only code-level source verification is available. Do not call Mac V2 visual identity `PASS` until this missing test is performed.
- **Repeated harness timeouts:** two full-suite tests timed out after code changes; bounded one-file video continuity probe succeeded. Further speculative full-suite retries are out of scope; next reviewer should identify the constrained runtime failure independently if relevant.
- **Not tested:** Windows local offline double-click, true MP4 rendering, real human narration, SRT/music, usage-rights verification, cost/Token analysis, or unfamiliar-viewer response.
- **Future work:** compare real 20–30-second visual preview **with real distinct, reviewable legal materials** and requested reference; accept T1–T6 only when information is genuinely communicated visually; then plan separate Remotion integration work.

## Reviewer/Owner status

- Old R3 = `RETURN_OWNER_VISUAL_STORYFIT`.
- PR#144 = `V2_REVIEW_CANDIDATE`, not accepted/merged.
- Main = unchanged, `NO_PUBLISH` remains.
- **Owner action now:** `NONE` unless an actual final browser visual acceptance becomes necessary.
