# CWS V5.6.2 | N-01 / N-02 minimal targeted repair and executor tests

**Date:** 2026-10-18  
**Current stage:** `EXECUTOR_SELF_TEST_PASS / INDEPENDENT_REVIEW_PENDING / FORMAL_PRODUCTION_HOLD`. Owner authorized only the two edge repairs from the V5.6.1 independent review. This is **not** an independent third-party review or a formal baseline freeze.

## Exact identity

- Draft [PR #144](https://github.com/entropy-student/project/pull/144), branch `cws/content-template-lab-v1-20261017`.
- [V5.6.2 candidate](../visual/content-template-lab/storyboard-v5-6-2-percent-scale-edge-fixes.html), Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`, SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`, 75,461 UTF-8 bytes.
- Parent V5.6.1 blob `3cd8b040a9f106ca7d0876b55b34ab71088af175`, SHA-256 `44319df40d2b6e14400f720b97d4a34161ae0cef89c9d9e3a7b5c54e5b8fa213`.
- Main frozen V5.2 Git blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b` (unchanged). V5.6.1 remains intact; PR stays Draft/unmerged.

## Scope of actual changes

1. **N-01 / R-01 (percentage semantic correctness):** Introduce a single `normalizeUnit` path, mapping `％` and `﹪` to canonical `%`, retaining trim behavior. Use it for imported metric units, T6 displayed value units, and delta-result suffix. The canonical JSON export remains `CWS_STORYBOARD_V2`; percentage-point difference is never confused with `change` percentage rate.
2. **N-02 / R-04 (scale correctness for microscopic values):** Replace the fixed absolute `1e-8` tolerance in `dataScaleMax` validation with strict `scale >= max(abs(metrics))` comparison. This rejects a scale lower than the actual data even near 1e-320, and keeps the existing automatic scale, zero fallback, explicit valid scale and negative-value zero axis.
3. Update displayed candidate version and diagnostic `__CWS_SOURCE` to V5.6.2 only. No schema bump; no changes to the original Research Aqua Canvas, template count, the Master Clock, media/Cue implementation, production authorization or release policy.

## Executor regression results (same exact candidate byte stream)

| Test group | New observed result |
| --- | --- |
| Core browser regression incl. V1/V2 JSON migration, MIME manual/batch replace, multiple Cue, WAV sync, T5 real MP4 stage seek, R-01~R-05 | **36 / 36 PASS**, JS errors 0 |
| N-01/N-02 targeted positive and negative tests incl. ` % `, `％`, `﹪`, different units, both delta/change, explicit scale smaller/equal/larger, subnormal inputs, negative and all-zero bars, invalid-import atomicity, JSON export | **28 / 28 PASS**, JS errors 0 |
| Asset preservation on cancel/mismatch; 60-shot 307.06s timeline jump stress | **3 / 3 PASS** |
| Original Mac Canvas exact pixel hashes against Git-authenticated V5.6 | **12 / 12 identical**, JS errors 0 |
| 0→31.06s real-wall-clock default-placeholder play | **PASS**: S01/S03/S05/S07 sampled, final `time=31.06`, `playing=false`, content visibility `hidden`, one original Canvas, no `#qt`, JS errors 0 |
| Source identity comparison | GitHub V5.6.2 blob matches Git blob computed for the locally tested HTML byte-for-byte |

Initial fullplay script reached S07 but its last screenshot stalled; **do not count that script as a full PASS**. A separate screenshot-free continuous play runner produced the terminal-state PASS above. Testing used isolated Linux Chromium with `page.set_content`, not an Owner Windows/Edge double-click. WAV/MP4 are short synthetic local assets; the long stress checks only the timeline seek logic, not a produced five-minute movie.

## Reviewer checklist and evidence

- Reproduce the two originally failing cases: `[5%, 40%]` unit `％` must display `+35 个百分点`; `[1e-9,2e-9]` explicit `dataScaleMax:1e-10` must reject, **not** draw both columns full width.
- Verify `delta` versus `change`, mixed `%`/`％` import and canonical JSON export; exact-scale, all-zero, negatives and subnormal magnitudes.
- Regression: R-02 MIME checks and confirm/cancel, R-03 meaningful nonzero numbers, R-05 V2 naming/V1 compatibility, V5.4 asset registry, V5.5 Cue/WAV, V5.6 4 modes, six templates/Canvas, T5 MP4 and 31.06s 1× complete run.
- Raw reproducible test scripts, short synthetic media and results are included in the Owner-facing companion ZIP; not committed publicly. Do not treat the numerical test counts as independent Reviewer acceptance.

## Formal governance: unchanged

`CW0005 R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`; media rights `PARTIAL`. Production 4–6 minute narrated MP4, acoustic alignment/TTS/SRT, third-party rights, realistic Story-Fit and Owner Edge `file://` launch remain unverified. No PR merge or main frozen HTML alteration is authorized. Next: independently review V5.6.2; Owner decides whether to accept/freeze or schedule further Gates.
