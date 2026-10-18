# CWS V5.6.2 | N-01/N-02 repair and independent Reviewer relay

**Date:** 2026-10-18  
**Current authoritative status:** `EXECUTOR_SELF_TEST_PASS / INDEPENDENT_REVIEW_PENDING / FORMAL_PRODUCTION_HOLD`.

The Owner authorized only two edge defect repairs found during independent V5.6.1 review. The executing assistant created a **new V5.6.2 HTML**, validated it, and committed it to the existing isolated [Draft PR #144](https://github.com/entropy-student/project/pull/144), keeping V5.6.1 unchanged. **This execution and self-testing must not be counted as a fresh independent acceptance review.**

## Source of truth and revision identity

- [New V5.6.2 HTML](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/visual/content-template-lab/storyboard-v5-6-2-percent-scale-edge-fixes.html)
- Source commit `4fe687cae85cb36b794725cd6815686064831462`, blob `33aabc3ff2e48877493277eb1a86274818e3c769`, SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`.
- [PR branch execution detail](https://github.com/entropy-student/project/blob/cws/content-template-lab-v1-20261017/curious-world-studio/docs/CWS_V562_N01_N02_TARGETED_REPAIR_AND_TESTS_2026-10-18.md), commit `33d5357c0c09931ba5e7d9070ca92cf1b2adb35f`.
- Prior V5.6.1 blob `3cd8b040a9f106ca7d0876b55b34ab71088af175`, preserved. Only frozen version on `main` remains V5.2 blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`, unchanged.

## Exact limited fixes

1. **N-01:** Equivalent percentage-unit glyphs (`%`, `％`, `﹪`) normalize to the same `%` across validation, delta display and exported V2 JSON. A 5→40 absolute difference is +35 percentage points, whereas a relative change is +700%.
2. **N-02:** Reject explicitly configured bar scales strictly smaller than the largest absolute metric, including scales in the 1e-9 and subnormal ranges. Retain proper automatic scale, explicit legal scales, all-zero fallback and negative zero axis.
3. Update display/diagnostic identifier to V5.6.2; no architectural or interface expansion.

## New executor self-checks (same final SHA)

- Chromium core regression **36/36 PASS** (including V1/V2 JSON, R-01–R-05, MIME match/confirm/cancel, Cue/WAV, T5 MP4 in-point).
- N-01/N-02 targeted positive/negative edge cases **28/28 PASS** (percentage glyph variants, micro/subnormal data and illegal/valid explicit scales, import atomicity, V2 export).
- Media preservation and 60-shot / 307.06-second timeline seek **3/3 PASS**.
- Original Mac Canvas exact pixel compare **12/12 identical**.
- Separate screenshot-free real-time playback **0→31.06 seconds PASS**: finishes at original desktop, `playing=false`, content layer hidden, no page JavaScript errors. A preliminary screenshot-equipped fullplay run stalled during terminal screenshot and **must not** be counted as an additional pass.
- Offline Linux Chromium `page.set_content` used; Owner Windows Edge `file://` remains unverified. Tests used synthetic WAV/MP4; not a 4–6-minute encoded movie.

## Current gate and stop

**STOP / WAIT_INDEPENDENT_REVIEW_AND_OWNER_DECISION**. Do not auto-merge, freeze V5.6.2, rework the Mac shell, add templates, or start real film production. The next Reviewer should inspect the exact blob and rerun N-01/N-02 positive and negative evidence plus the inherited regression suite independently.

Formal `CW0005 R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`, rights `PARTIAL` remain. Authentic 4–6-minute voice-over, automatic acoustic timing/SRT, real MP4 export, third-party licensing and Story-Fit remain unaccepted.

Prior authoritative [V5.6.1 handoff](CWS_V561_MAIN_REVIEW_AND_SUCCESSOR_RELAY_2026-10-18.md) and original [V5.4–V5.6 review](CWS_V54_V56_MAIN_REVIEW_VERDICT_2026-10-18.md) are retained for historical provenance; this document supersedes their *next step*, not their past verdicts.
