## V3 30秒动态预览（2026-10-17，最新；覆盖下方旧V2开发状态）

- **GitHub中可复用的无媒体源码**：[storyboard-v3-source.html](storyboard-v3-source.html)：六种模板＋30秒时间轴＋本地媒体槽位＋字幕编辑＋配置导出。默认空素材，必须自行填合法素材。
- **实际视觉演示**：`CWS_30秒动态知识模板_完整预览.html`（Owner对话私有附件，不在GitHub）；媒体摘自Owner上传的第三方参考视频，只用于内部视觉评审；不具有转发、商用、公开视频权利。
- **本轮Review**：`V3_VISUAL_DEMO_TECH_PARTIAL / REVIEWER_RETURN_EXACT_STYLE_AND_RIGHTS`。十二个抽帧检查点、T1–T6、T5阶段、字幕修改时视频连续播放、六段配置导出均测；完整30秒自动回归退出超时。Mac外壳使用接近原V2的CSS几何，未做到原V2源码逐帧复用。不能据此合并/生产/发布。
- **完整Gate/证据与未完成项**：[CWS_TEMPLATE_LAB_V3_REVIEW_2026-10-17.md](../../docs/CWS_TEMPLATE_LAB_V3_REVIEW_2026-10-17.md)。旧V1静态退回和V2候选文档历史保留，以下V2描述仅作历史。

# Curious World Studio — Content Template Lab V2

> **STATUS: V2_REVIEW_CANDIDATE / DRAFT_PR_NOT_MERGED / NOT_PRODUCTION_AUTHORIZED**  
> Scope: only PR #144, no effect on mainline `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`.

## What is actually built

Open **`index.html`** directly in the browser. This is now a **single-file offline prototype**: the accepted [G1V-A V2 Research Aqua canvas](../../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html) is embedded as an iframe `srcdoc`, using the exact original drawing logic for Mac desktop, cursor, file-double-click, Genie opening, maximization and QuickTime bars. Only test-media illustration, clip filename, demo duration and autoplay loop were changed; the content viewport is occupied by the V2 template stage.

The index implements 28.76s timed preview: **0–4.76s original Mac opening**, followed by six independent content-use scenes. The stage fills the 16:9 output canvas; editor UI is outside that canvas.

| Template | Role | Span (s) | Media slots |
|---|---|---|---|
| T1 | Single footage or image | 4.76–8.00 | 1 |
| T2 | A/B simultaneous comparison | 8.00–11.80 | 2 |
| T3 | Action + explanation image | 11.80–16.40 | 2 |
| T4 | Source evidence / archive | 16.40–19.60 | 1 |
| T5 | 3-stage picture progression | 19.60–24.60 | 3 |
| T6 | 3-stage illustrative data comparison | 24.60–28.76 | 0 |

**Behavior:** Play, Pause, Restart and Seek follow one media clock. T5 and T6 auto-progress across three timed states. The user may switch to any scene, insert local photo/video into slots and edit title, subtitles, labels and notes without destroying an active video node. Videos are muted in this visual-only prototype; no automatic media looping. JSON export includes six shot times, stage events, media filenames, unverified provenance/rights fields, and review requirements; it does **not** embed media or authorize publishing.

## What did not happen

- No exact scientific research animation, AI image generation, internet search or video asset downloading.
- No original reference-video footage was copied into the project.
- No actual dubbing, soundtrack, SRT alignment, Remotion MP4 export or real research rights verification.
- Default empty slots remain visibly marked `DEMO ONLY`. The example data values 24/48/76 are **fictional UI test fixtures**.
- No extra MW-01…13 animation presets were added. The 13 existing Mac interactions are a distinct A-shell concern; this is the separate **B content-template layer**.

## Verification and limitations

**Independent Chromium/Playwright probe in sandbox (2026-10-17):**
- Six content-scene render states and timeline selectors: **6/6**.
- T5 automatically advances to stage 2 after ~2s; T6 advances to example 48%.
- Local six-second machine-generated QA MP4 played, and subtitle editing preserved its source and playback progression (about 1.47s→1.99s), unlike V1.
- JSON exported six timed scenes with the chosen local filename; page JavaScript errors **0**.
- The sandbox browser blocks both `file://` and localhost navigation with `ERR_BLOCKED_BY_ADMINISTRATOR`; tests used HTML `set_content` and a **structurally equivalent local stub shell via srcdoc**. Thus **the exact newly embedded original V2 shell was not independently rendered in that browser session**. No Windows double-click test has been performed; visual acceptance remains open.
- Two attempted whole-suite regressions hit harness timeouts; a bounded single-fault video probe completed and showed working continuity. Treat the shell/render end-to-end as `UNVERIFIED` until reviewer can play the final exact candidate in an appropriate browser environment.

## Current Reviewer boundary

The V1 PR review recorded `RETURN_VISUAL_MOTION_AND_STYLE`; this V2 addresses those design causes **as a candidate**, not a self-declared PASS. The next bounded reviewer should validate the final exact HTML, original Mac motion fidelity, scene timing and real varied content, then confirm whether additional tweaks are needed before considering a merge. Main project R3 remains `RETURN_OWNER_VISUAL_STORYFIT` and R4 and publishing remain unauthorized.

**Rollback:** the PR remains open as draft and can be closed/reverted without touching main. This HTML contains no credentials, data store or production network calls.

See [V2 Gate + Evidence](../../docs/CWS_TEMPLATE_LAB_V2_GATE_2026-10-17.md), [Governance](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md).
