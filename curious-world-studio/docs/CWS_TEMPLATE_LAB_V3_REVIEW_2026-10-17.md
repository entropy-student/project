# CWS｜六模板30秒动态样片 V3｜执行证据与独立Reviewer结论（2026-10-17）

> **GATE_ID:** `CWS-SIX-CONTENT-TEMPLATES-30S-PRIVATE-VISUAL-QA-20261017`  
> **RESULT:** `V3_VISUAL_DEMO_TECH_PARTIAL / REVIEWER_RETURN_EXACT_STYLE_AND_RIGHTS`  
> **PR:** [#144](https://github.com/entropy-student/project/pull/144) remains **Draft/unmerged**. No formal `CW0005` production, R4, G1/G2 or publishing permission.

## Objective and boundary

Owner authorized a real **~30-second continuous HTML demo**, not another static six-layout gallery. Target: restore the accepted Research Aqua Mac style, demonstrate **T1 single clip, T2 two-source contrast, T3 footage + explanation, T4 source/archive, T5 three-stage visual sequence, T6 data comparison** with interchangeable inputs, then Reviewer checks video engagement/style and records the durable project result.

**Critical distinction:** The private chat artifact embeds short crops/frames from an **Owner-uploaded third-party reference video** for internal visual evaluation only. Those media files, screenshots and the self-contained asset-bearing HTML **are deliberately NOT pushed to public GitHub**; reuse and publication rights are `UNVERIFIED`.

GitHub receives `visual/content-template-lab/storyboard-v3-source.html` **without any media data**, preserving reusable HTML/media-slot wiring. The private single-file embedded-media candidate was supplied in the Owner conversation as `CWS_30秒动态知识模板_完整预览.html` (1,537,733 bytes, SHA256 `21d53390aa8fc75dbb2288437f0ae6be75cdd3335e063ca6eb1c9cfa7c353e93`). It is not a GitHub-accessible or deployable production asset. Source-only 30,288 bytes, SHA256 `3ebe0dc5190267e78890174d9327510de13f031739ed0386f8d20289c349adda`. Source-only default media slots are intentionally unfilled.

## Provenance and active guardrails

- **Visual baseline** (DIRECT_READBACK): `p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html` (Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`), `visual/retro-mac-v1.2/preview/index.html`, `STYLE_LOCK v1.2`, and accepted Owner choice of Research Aqua.
- **Media provenance** (OWNER_PROVIDED_REFERENCE): only time-scoped crops/frames from the uploaded reference MP4. Not research experiment original, not license-verified, not reusable across other productions; on-screen label denotes internal demo/reference.
- **2020 tax wording** (public fact check): original 2020 `Bookfinders Ltd v Revenue Commissioners [2020] IESC 60` and historical two-percent sugar/flour threshold, contrasted with roughly ten-percent sugar/flour in the case. Do **not** generalize the historical 2% rule to current Irish tax law (which has changed). Court source: https://www.bailii.org/ie/cases/IESC/2020/2020IESC60.html ; current tax guidance: https://www.revenue.ie/en/tax-professionals/tdm/value-added-tax/part03-taxable-transactions-goods-ica-services/Goods/goods-bread.pdf.
- **Out of scope:** sourcing/purchasing third-party footage, live production, AI image generation/video, secrets/provider login, deploying servers, Remotion MP4, narration/SRT synchronization, or merging into main.

## What was actually implemented

- Self-contained 1920×1080 output stage inside a separate browser editor, with desktop/File double click animation → QuickTime-style B content filling the stage. The interface below the stage does not enter the video frame.
- One timeline (0–30 seconds), play/pause/restart/seek, six T1–T6 layouts and automatic three-image stage change for T5; T6 time-driven comparative bar reveal; filename-only JSON export.
- Image/video file-picker for all content slots; imported local media does not upload to a server. Single-scene editing of subtitle/title does not reconstruct and restart active video.
- Animated Mac shell here is **CSS/HTML reconstruction** of accepted visual tokens/geometry, **not a pixel-faithful reuse of the exact archived Canvas source**. Consequently it is a **style candidate, not evidence that visual restoration is complete**.

## Actual verification

`BEHAVIORALLY_VERIFIED` by Chromium/Playwright `page.set_content` and private-local generated images/video crops:
- Twelve checkpoints including desktop idle, file click, opening, maximize, each T1–T6 scene and T5 stages 1/2/3 were captured; no page JavaScript exceptions.
- Six distinct scene keys observed and frame dimensions declared 1920×1080; T5 transitions at chosen timestamps.
- Real video continuity under live caption edit: local MP4 playback advanced `1.65s → 2.22s` and remained playing, with no DOM media reset.
- JSON export `duration_sec=30`, six scene records, expected timeline positions; stored alongside local QA report.
- A longer whole-sequence attempt observed the clock reaching T6/30s but automation harness **timed out around teardown**, so no completed independent end-to-end playback QA certificate exists.
- Real Owner Windows Edge `file://` launch, exact V2 pixel/style comparison, outside-watched 30-second uninterrupted qualitative review, video output encoding and actual audio synchronization remain `UNVERIFIED`.

## Reviewer judgement

**PASS (bounded component-level):** six editable layouts, timeline design, T5 automatic progression, T6 bar reveal, Mac-inspired opening, local upload controls, export and basic active-video continuity.

**RETURN / required before formal acceptance:**
1. **Exact visual identity:** compare full-size V3 0–5s and B chrome to the accepted Research Aqua V2, and adopt the **actual locked V2 shell**, not CSS approximations. Do not re-create another dashboard look inside the output stage.
2. **Visual storytelling:** the private demo demonstrates layouts, not automatic matching across multiple independent/legal sources; all source assets originate from one Owner-provided reference MP4. Meaningful multi-source story-fit is unproven, old R3 failure is not resolved by this demo.
3. **Meaningful information T3–T6:** ensure explanation/archival graphics remain grounded in real data or sourced images; no main-mechanism PPT text. Internal paraphrase card is clearly a re-layout, not a literal court screenshot.
4. **Production controls:** all clips used in future episode must satisfy actual licensing/source identity, no reuse of original video files, truthful provenance, narration/SRT alignment and Remotion production test in a separately authorized Gate.

The **six content-template categories are kept as sufficient working primitives**; narrative planning (explain/investigate/reconstruct a decision) is not a seventh static layout. This round does not freeze the quantity.

## Rollback, artifacts, and next reviewer

- **Rollback:** close the unmerged Draft PR; main source remains unchanged except previously accepted project status pointers. This round touches no real user media archive or deployed system.
- **Public version:** code-only `visual/content-template-lab/storyboard-v3-source.html`. No embedded video, image stills or third-party footage in GitHub.
- **Private human-viewable version:** downloadable standalone `CWS_30秒动态知识模板_完整预览.html` in this chat. No permission to copy it to public hosts.
- **Next Reviewer:** independently view exact V3 with Owner, compare locked V2; choose small fixes/RETURN. Do not merge #144 on technical component PASS alone.

**OWNER_ACTION_REQUIRED:** Only watching the attached file and giving style/clarity feedback if desired. No approvals, credentials or environment changes required.
