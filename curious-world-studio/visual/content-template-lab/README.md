# Curious World Studio — Content Template Lab V1

> STATUS: **DEMO_ONLY / DRAFT_PR / NOT_PRODUCTION_AUTHORIZED**  
> GATE_ID: `CWS_TEMPLATE_LAB_V1_OFFLINE_DEMO_20261017`  
> Boundary: New additive `visual/content-template-lab/` files only. No R3/R4 production, AI image generation, asset downloads, public publishing, video rendering or modifications to accepted source. No changes to old `preview/index.html` or 13 MW motion demos.

## Purpose

Validate the Owner-selected **pick template → fill media and data → review** workflow. The lab is a **single standalone HTML file** using Mac Tiger Aqua / QuickTime visual tokens; it does not claim to be an Apple application or a production video renderer.

The six content uses share three underlying layouts:

| ID | Visual use | Layout | User-fillable media slots |
|---|---|---|---:|
| T1 | Single asset playback | Full | 1 |
| T2 | Two-source comparison | Split | 2 |
| T3 | Real action + explanation image | Split | 2 |
| T4 | Research/archive document | Full | 1 |
| T5 | Three-stage progression | Sequence | 3 |
| T6 | Data/classification conclusion | Sequence | 0 (editable values) |

All media placeholders are neutral non-evidence demo objects, not synthesized real entities or research actions. Numeric and archive content is demonstrative and **must not be used as scientific evidence**. Uploaded local images/videos are previews only; they remain in the browser session and are not embedded in the exported JSON configuration.

## Usage

Open `index.html` in a local Chromium-family browser, select T1–T6 in the left sidebar, choose local photos or MP4/WebM in the right sidebar, edit subtitles, labels and explanatory text, navigate T5/T6 steps and export a JSON configuration. No server, Docker, plugin, API key, audio model, remote services or network access is required.

The lab deliberately **does not auto loop video**. Existing `A→B` desktop animation and the separate MW-01…MW-13 interaction experiments are not recreated or silently approved for formal content use. The B-player visual tokens refer to `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`; demo interface does not constitute exact pixel equivalence with the locked V2 implementation.

## Bounded test evidence (2026-10-17)

- Browser execution: Chromium, Playwright, offline HTML loaded through `set_content` because this isolated runner blocks `file://` direct navigation with `ERR_BLOCKED_BY_ADMINISTRATOR`. **Owner Windows file-open route remains unverified**.
- Six template selectors: **6/6 success**, one active viewport per template; T1/T2/T3/T4/T5/T6 media slot counts **1/2/2/1/3/0**.
- Local image upload: first slot of T2 updated, new image rendered.
- Editable subtitle: immediate stage update.
- Step navigation: T5 advanced to stage 2 of 3.
- Editable demo data: T6 `23,48,76` reflected stage 2 as `48%`.
- JSON export: T6 demo manifest filename and values verified; media bytes not present.
- Page JavaScript runtime errors: **0** in the test.
- No Windows deployment, actual image generation, research-material permissions, real spoken-audio sync or Remotion MP4 export verified here.

## Acceptance and next boundary

**This Gate's maximum endpoint** is a draft offline visual prototype + independent browser checks and a PR for review. The existing Owner visual judgement on the failed 55.367-second R3, `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH` and rights `PARTIAL` remain in force.

Before production integration: (1) Owner reviews whether six visual uses are attractive and useful using real candidate materials; (2) Reviewer checks exact scope/2-4-6 visual license compatibility for sequencing/data behavior; (3) a separately authorized bounded integration Gate addresses shared manifest, A→B shell, Remotion, audio/SRT, source identity, no repeat use and full video QA.

**Rollback**: close the unmerged PR/delete its isolated branch; the accepted main files and local project environment are unchanged.
