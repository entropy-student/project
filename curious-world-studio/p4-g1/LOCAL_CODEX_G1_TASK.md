# G1 Local Codex runtime protocol — source first, no fictional proof

## Scope and authorization
Owner 2026-10-11 approved **G1 pilot execution and retrieving material from existing websites/information sources**, rather than requiring local stock material. Explicitly approved: scoped downloading of the two **original PLOS figure image files** only, creating temporary CWS files, writing isolated compositor subdirectories after strict guards, rendering a **private** 20–30s technical pilot if actual narration + timing + rights checks are ready. **Not approved**: publishing, paid cloud inference, system-wide installation/upgrades, changing unrelated code/config, copying external experimental video from S3 Appendix without a separate license check, contacting VPN/VPS, or forcibly rewriting the pilot script for duration.

## Inputs already in main
Read these, in order:
1. `docs/CURRENT_STATE.md`
2. `docs/P4_G0_CONTRACT_CORRECTIONS_AND_G1_ACCEPTANCE_2026-10-11.md`
3. `docs/P4_G0_LOCAL_CAPABILITY_READBACK_2026-10-10.md`
4. `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`
5. `research/story-fit/prototypes/2026-10-10_P3R4_J_B_FULL_READTHROUGH_V1.md`
6. This `p4-g1` package. This is a **technical excerpt of existing J-B**, not a formally authorized script, not STORY-FIT GO.

## Files in this package
- `source_manifest.json`: 2 explicit paper figure PNG requests with figure DOI and attribution; external S3 video **excluded**.
- `fixture_script.txt`: exact contiguous paragraph copied from P3-R4 J-B, no invented research facts.
- `captions.manual.template.json` and `rights.reviewed.template.json`: intentionally **NOT_REVIEWED**.
- `scripts/fetch_figures.py`: original PLOS figure URLs, allowlist and PNG checks.
- `scripts/create_sapi_audio.ps1`: optional Windows built-in Chinese speech **if an installed Mandarin SAPI voice exists**; no download/fee/voice install.
- `scripts/build_g1.py`: rejects WAV missing, non-reviewed caption timings, stale SHA, rights not verified or total video duration outside 20–30s.
- `scripts/render_windows.ps1`: only stages additive `projects/cws-g1` and `public/cws-g1` inside existing OpenMontage Composer; no upstream source modification; local Remotion binary only. Renders MP4, ffprobe JSON, keyframes.
- `remotion/entry.tsx` / `ResearchEpisode.tsx`: dedicated fixed A/B with no C state, research figures `contain`, one-line captions and PLOS source. **No runtime pass has yet been claimed.**

## Codex steps (do once, report actual results)
1. Create isolated workspace (for example, `$env:TEMP\cws-g1-20261011-<new-run-id>`) **not inside another active project**. Repo read-only clone is permitted if needed; do not put checkout or test files in original OpenMontage install except strictly additive staging at render step. Use code from current GitHub `main` after the G1 PR is merged.
2. Run existing Python `...\p4-g1\scripts\fetch_figures.py --work <workspace>`. It downloads **2 still images, not S3 videos**, and checks PNG signature/dimensions/SHA. If blocked by PLOS redirect/403 or incorrect media, report `G1_ASSET_BLOCKED` and stop. Do not silently substitute random jelly stock photo as an experiment.
3. Inspect both actual image pixels and paper captions, and verify article CC BY 4.0 and any separate figure credits. Create `<workspace>\rights.reviewed.json` from template. Set `content_verified=CONTENT_VERIFIED` and `reuse_rights_verified=REUSE_RIGHTS_VERIFIED` **only with defensible per-figure review and source SHA**; otherwise preserve UNKNOWN and stop before rendering.
4. Determine whether an **already installed** Mandarin speech engine/voice can create a usable 20–30s technical read without network (Windows PowerShell 5.1 and `scripts/create_sapi_audio.ps1` is one option). If unavailable or unreadable, return `G1_AUDIO_BLOCKED`; **do not call Qwen** or install voice models without separate approval. If available, save final PCM WAV to `<workspace>\audio\narration.wav`, listen for intelligible Chinese and record actual duration, SHA, and voice provenance. No false report of professional voice quality.
5. Use `captions.manual.template.json` as the segmentation starting point. Every `start_audio_ms/end_audio_ms` requires **auditory verification against final narration**. If no one can truthfully confirm the audio by listening, do not set `human_reviewed=true` or `status=REVIEWED`; report `G1_ALIGNMENT_BLOCKED`. No equal division by character count, transcript ASR offsets, or fabricated timing accepted as forced alignment. Put the final checked copy at `<workspace>\captions.reviewed.json` with `audio_sha256` and exact `script_sha256` (SHA of stripped UTF-8 `fixture_script.txt`).
6. Run `scripts\render_windows.ps1` with `-PilotRoot <repo/p4-g1> -Work <workspace>` only after 2–5 succeed. It runs the Python build/review gates and then the installed Remotion CLI, staging additive `cws-g1` files in the original Composer. No overwrite, no npm install. If staging names already exist, **stop and request manual reconciliation**.
7. Examine MP4 and generated `frame-A.png` / `frame-B-08.png` / `frame-B-18.png`, plus SRT/ffprobe/rights ledger. Validate strictly **1920x1080, 30fps, 20–30s, audio stream, B full-bleed, no C, subtitle one line/no word highlighting**, correct picture-to-narration semantics, no black frames, frame continuity and true aural sync. Check at least one long speech line split over multiple captions.
8. Return paths + actual evidence + defects + `G1_TECH_PASS` / `G1_CONDITIONAL` / `G1_BLOCKED_*`. Even technical pass does not approve publication, commercial media use, or automatic future source reuse. Report any actual writes and cleanup candidates; **do not delete stage automatically**. Commit only source and text QA docs to GitHub via scoped PR. Do not commit downloaded media, final human voice recordings, secrets or private file paths into public artifacts accidentally.

## Specific non-overstating rules
- Figure images are **论文证据** from the article; the linked **full experimental videos are not downloaded or licensed by this workflow**.
- Because primary papers contain links and images, `LINK_FOUND` does NOT imply image contents already opened and checked or reuse rights passed. The original paper CC BY is strong evidence, not automatic clearance of third-party material, individual videos, audio, trademarks or privacy.
- A WAV file exists != script-aligned. Auto ASR != forced alignment. A working CLI != G1 pass.
- Never claim G1 ended if actual output, sound or QA evidence is missing.
