# CW0005 Existing Visual Asset Audit — Executor Record

- Gate: `CWS-CW0005-EXISTING-VISUAL-ASSET-AUDIT-20261018`
- Executor result: `PASS_CANDIDATE` for completing the bounded inventory only; asset coverage remains `PARTIAL`, rights remain `PARTIAL/UNKNOWN`.
- This is not a Story-Fit PASS. The formal state remains `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL`.
- Audit mode: read-only inspection of existing CWS local catalogs, previously generated preview frames and R2/R3/R6 records. No network media fetch, new download, frame extraction, image generation, render, code change, or local cleanup occurred.

## 1. Baseline and preflight

- GitHub `main` read at commit `785ed27d0a94624b2ae69ae4f51d42fcf43f386f`. The Gate blob was `042227cf59aee94a3894f1b1e1d811ca53e37e6a`; current state blob `dc897c2162d8ddd0356b34f9f00483ca9b481215`; accepted R2 narration/shots blob `1d05020af82eda0a022393dd198d7a54d9e50308`; asset policy blob `24d4fbf0e309d1a211d5d171f6e2ef7adeaed12c`; Style Lock blob `869f87b0a45dd5d1ddaa260d9246fa80e0d01051`.
- Confirmed local host was Windows 11 PowerShell; repository remote was `https://github.com/entropy-student/project.git`. The existing local checkout was branch `codex/cws-media-operations-integration-20261015`, HEAD `db739e38e0b6434ff807e63e9e9107255d3247bd`, which differs from the GitHub `main` snapshot used for this PR.
- The existing local checkout had 2 modified tracked files (`media-pipeline/README.md`, `media-pipeline/media_pipeline.py`) and 5 untracked entries (`media-pipeline/__pycache__/`, `media-pipeline/cws_media.py`, `media-pipeline/docker/`, `media-pipeline/tests/__pycache__/`, `media-pipeline/tests/test_cws_media.py`). They were left untouched. The ignored `.local/` inventory and all historical artifacts were read-only.
- The R2 revision archive at `.local/prod-r2-cw0005-editorial/` matched expected SHA-256 `e547e48cd107b7a05e47aae466fc9efbd84f8a381f9065a0bb8213cd0dc5c6dc`. The R6L/R7L handoff archive matched `81591798ede2c838bbc8cc31c8b5fb22edbd5f497d90e7142cfcae141e78c4f8`; the R3 revision archive matched `84ddaac6b21279a1a77a46a5a85f71e5528b7d5f0a21274918aeb9bf07c919e0`. These hashes identify existing evidence and do not imply reuse permission.

## 2. Local inventory and inspection boundary

The audited ignored CWS inventory included `.local/media-operations/`, `.local/media-r6l-r7l-fast-match-pilot/RUN_20261016_01/package/`, `.local/prod-r2-cw0005-editorial/`, and `.local/prod-r3-cw0005-internal-av-sample/`.

- The media-operations catalog held 15 video records and 70 image records; only 2 catalog records had corresponding local media files. This is catalog metadata volume, not 85 verified assets.
- Two historical R6 stock-video identities are documented with source SHA and three still frames each. Their raw source files were not present as standalone files in the audited media directories; the prior R6 QA and generated frames were present. The frame files were independently SHA-checked against the R6 QA record and visually inspected in this audit. Their recorded full-file FFprobe/FFmpeg result is inherited from that R6 QA, not rerun against the unavailable raw files.
- No local PDF or image asset for article Figure 1, Figure 3a, or Figure 6 was found in the audited CWS media/catalog scope. The accepted R2 document contains the paper citation and textual findings; that is not a locally readable copy of any figure.
- The R3 deliverable contains the previously rejected 55.366667-second composite MP4 and derivative segments/keyframes, not additional source works. The final MP4 SHA-256 is `7b913ef24888257e3e341a690758286af7361b0d1d4db0d719315623bcdac4a5`. Existing S05 frames show a labeled text schematic (“paper-text organization, not research footage”), not Figure 3a or experimental footage.

### Existing content observations

1. **Pexels #854959** — source page recorded in accepted R2: https://www.pexels.com/video/cooking-popcorn-854959/ . Historical source SHA-256: `d5cacbd2a8158a8b26c3b4e18f43168533b0d7dda25ec67de37a39e864385c78`; historical metadata: 1920×1080, H.264/AAC, 20.223333 s, 30000/1001 fps, 12,011,169 bytes, full decode PASS in R6 QA. The existing frames at 0.5 s, 10 s and 19.5 s show close-up pan contents with popped pieces and unpopped kernels. They do not show a clear single-kernel rupture-to-jump trajectory. Frame SHA-256s: `44e10e048e2c2481fd5710e74ba2fd5f115a7f1bbe5e964db6b4b41555c542d2`, `0d39ca3ead09fda3a2ab7098b019e1c2d904922d05161cfc50f4b3f4ff48fd53`, `6ed4823731905254cd0b6c8be03ccb40a1466f891d03d83df808afa9c6752cfa`. Observation level: representative frames only; no full-clip event review in this audit.
2. **Pixabay #2793** — source page recorded in accepted R2: https://pixabay.com/videos/popcorn-popping-corn-food-snack-2793/ . Historical source SHA-256: `8c6ed307ef0ff4fc666ef169be2cc410ad91dec01b1f003c651b9e92d07e43d7`; historical metadata: 1920×1080, H.264/AAC, 25.726667 s, 30000/1001 fps, 15,256,111 bytes, full decode PASS in R6 QA. The existing frames at 0.5 s, 13 s and 25 s show pan contents and popped/unpopped kernels; the 13-second still contains kernels above the pan, but a still cannot establish a trajectory. Frame SHA-256s: `f451fcac9b4b7850cb711f1f1db6e5c3474ec9fd501329b625a76da91e45adbb`, `311227eba05db49211c84a77f000706c56bd6c9ad7525cd00d1467b9f6b276c5`, `7cecca190b0d18124452dc301ce08e2e2a06ad3ccc13cd117e9651bf4f9c33e7`. Observation level: representative frames only; no full-clip event review in this audit.
3. **PeerTube catalog sample** — local item `video-f1e16b104b4b4e6052bd`, source page https://video.asonix.dog/videos/watch/9ec1a2bc-7269-49ed-802e-c727004115e3 , recorded file SHA-256 `997ed3947c94d924ad399b7ba500a4b9c3ae65fa9b56c3a8a4bdc59095ceb688`, 3,164,233 bytes. Current FFprobe readback: VP9, 1920×1080, 30000/1001 fps, 52.78 s, one Opus audio stream; its existing catalog record reports a prior full-decode PASS. The existing preview frame SHA-256 is `9fb438bad11390f4b5adbd3e3cadc3a92ea04f05b437a9c6db1fa9fcd4f99a4a`; it shows a text-only screenshot of a deleted Reddit post, not popcorn being made or jumping. Full-clip visual playback was not performed here. Rights are UNKNOWN; exclude from story use.
4. **Wikimedia Commons image** — local item `image-e5c9b249f62efac4484f`, page https://commons.wikimedia.org/wiki/File:Popcorn,_2020-11-26,_01.jpg , file SHA-256 `05327c37b6eed6540f5fc2bc3ec4bc06a5d739164c6057832508665da9251e3b`, JPEG 1280×768, 278,862 bytes, catalog image-decode PASS. The existing image was opened and visibly shows several colored corn ears/cobs, not popped kernels or an experiment. Rights are UNKNOWN. It is a weak title-only match and was not assigned to a shot.

### Three independent evidence states

| Asset identity | `LINK_FOUND` | `CONTENT_VERIFIED` | `REUSE_RIGHTS_VERIFIED` |
|---|---|---|---|
| Pexels #854959 | YES (existing source page) | PARTIAL: three actual still frames | PARTIAL; third-party/material-specific conditions not fully resolved |
| Pixabay #2793 | YES (existing source page) | PARTIAL: three actual still frames | PARTIAL; material-specific/third-party exceptions not fully resolved |
| PeerTube catalog sample | YES | PARTIAL: one existing preview frame, text screenshot only | UNKNOWN |
| Commons image | YES | YES for the opened still; content is corn cobs, not popcorn popping | UNKNOWN |
| Paper Figures 1 / 3a / 6 | YES only as article citation in accepted R2 | NOT_VERIFIED: no local figure image/PDF opened | UNKNOWN: no figure credit line or asset-level rights record in local evidence |

## 3. Paper figure evidence

Paper: Emmanuel Virot & Alexandre Ponomarenko (2015), *Popcorn: critical temperature, jump and sound*, DOI `10.1098/rsif.2014.1247`; article page cited in R2: https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/ . No remote page or media was fetched in this bounded audit.

| Figure | Planned evidence use | Local original / readability | Rights and credit | Viewport risk |
|---|---|---|---|---|
| Figure 1 | Temperature/pop proportion result for S02–S03; R2 text already carries 170°C 17/50 and 180°C 48/50 sample values. | No local figure file/PDF; figure pixels, labels and legibility not inspected. | UNKNOWN; exact figure credit line and any third-party exception not in local evidence. | T4 label size, axis/legend readability and crop/contain behavior NOT_ASSESSED. |
| Figure 3a | Jump-study high-speed sequence for S04–S06; R2 text maps observations around 6.9/13.8/20.7 ms to shell/starch-foot changes, compression and rebound. | No local figure file/PDF; no sequence frames inspected. R3 S05 cards are explicitly text schematic, not the figure. | UNKNOWN; exact figure credit line and any third-party exception not in local evidence. | T5 sequence legibility, source frame resolution and image layout NOT_ASSESSED. |
| Figure 6 | Separate acoustics evidence for S07–S09, including image/microphone synchronization and timing around the second rupture. | No local figure file/PDF, waveform or research audio; not inspected. | UNKNOWN; exact figure credit line and any third-party exception not in local evidence. | T4/T2 axis, event marker and caption readability NOT_ASSESSED. |

The scientific wording and figures must remain separate from the used stock-video visuals. Figure 3a would be **paper evidence**, not an “original experiment video”; Figure 6 is the acoustics experiment, separate from the jump experiment. The absence of a local file is not evidence that a figure is unavailable from the publisher, nor that it is reusable.

## 4. S01–S10 shot mapping

Narration IDs below refer to the unchanged, Reviewer-accepted R2 S01–S10 wording. Proposed T values follow the Gate’s candidate mapping and are only placement suggestions; no frozen HTML or visual template was edited.

| shot_id / narration_id | visual purpose / proposed T | candidate source identity; local path status; existing SHA/metadata | observed content; prior use; provenance; rights | fit or gap |
|---|---|---|---|---|
| S01 / N01 | Open on a real rupture or jump; T1 | Pexels #854959 and Pixabay #2793; historical frame evidence is present under the local R6 package, raw source files not found as standalone files in audited dirs. See source SHAs above. | Real stills show ordinary pan contents; both source videos were used in R3. Provenance: existing R6 report/QA. Rights PARTIAL. | **GAP**: neither shows an independently verified single-kernel jump; both are `BLOCKED_ALREADY_USED`. |
| S02 / N02 | Make the sample temperature result visible; T4 | Figure 1, DOI #fig1; no local image/PDF, no local SHA/metadata. Stock backdrops above are used and blocked. | R2 contains the sample counts as text; figure visual not read. Paper is the intended provenance; figure rights UNKNOWN. | **GAP**: text can state the accepted result, but no local Figure 1 visualization exists to review. |
| S03 / N03 | Separate a sample proportion from a deterministic single-kernel switch; T2 | Figure 1 absent. Commons image `image-e5c9b249f62efac4484f` exists (1280×768; SHA in ledger). | Opened still shows corn ears/cobs; it is not an experiment or a popping kernel. Rights UNKNOWN; not previously assigned to a CWS shot. | **WEAK / NOT ASSIGNED**: topic-adjacent image does not explain the sampling distinction; no suitable existing visual confirmed. |
| S04 / N04 | Introduce the distinct jump experiment; T4 | Figure 3a, DOI #fig3a; no local image/PDF. Pixabay #2793 was the historical R3 backdrop and is blocked. | R2 textual conditions include the jump-study setup; the stock frame is ordinary cooking, not study footage. Figure rights UNKNOWN. | **GAP**: source figure is not locally reviewable; no fresh independent visual candidate. |
| S05 / N05 | Show starch-foot formation/compression/rebound; T5 | Figure 3a absent. Existing R3 S05 review frame is a text card; frame SHA `84ff5919db25158d3c6be29c1d1be4b2c3361bf76cdab75cef8a34a0f18332ec`; final R3 video SHA recorded above. | The card labels itself as a text-based schematic, not research footage. No real starch-foot action is visible. Stock sources are both previously used. | **CORE GAP**: current local material cannot show this mechanism; do not report the text card or stock frame as observed experiment. |
| S06 / N06 | Bound the “steam rocket” interpretation; T3/T1 | Figure 3a absent; previously used Pexels/Pixabay only as support. | R2 says the authors did not observe the rocket effect and attributes jump to foot rebound; an ordinary pan frame cannot show a negative observation. | **GAP**: the claim can be accurately attributed in narration/source text; no distinct local visual evidence confirms it. |
| S07 / N07 | Switch explicitly to the separate acoustics experiment; T4 | Figure 6, DOI #fig6; no local image/PDF/audio. Pixabay #2793 was used in R3 and is blocked. | Existing stock has no verified research synchronization; its sound was not the research recording. Figure rights UNKNOWN. | **GAP**: no local Figure 6 or experiment recording; do not imply stock sound is synchronous evidence. |
| S08 / N08 | Explain the second rupture and sound timing; T2/T3 | Figure 6 absent; no local waveform or research audio. | R2 carries approximate event timing as text; no waveform/recording was locally inspected. | **GAP**: the numeric claim is textual evidence only; no visible/local acoustic trace to review. |
| S09 / N09 | Keep the pressure/cavity account visibly labeled as author hypothesis; T1/T3 | Figure 6 absent; no matching local independent visual. | R2 explicitly preserves “author hypothesis.” Stock footage does not establish the proposed mechanism. | **GAP**: preserve the hypothesis label; no visual proof or approved image is present. |
| S10 / N10 | Close by contrasting jump finding with sound hypothesis; T2 | Figures 3a and 6 absent; the two stock videos were used throughout the prior R3 and are blocked. | Prior R3 end frames are derivative stock footage plus text; Owner’s formal visual verdict remains RETURN. | **GAP**: no sufficiently distinct, locally verified pair of research visuals for this comparison. |

## 5. Work-level deduplication and rights

- The project policy treats Pexels #854959 and Pixabay #2793 as already used across the project. R3 used all 20.223333 seconds of the former and all 25.726667 seconds of the latter in distributed shot segments. They remain historical evidence and are `BLOCKED_ALREADY_USED` for any new CW0005 cut, even though old still frames remain available.
- R3 MP4, R3 shot segments, captions and keyframes are derivatives/evidence of that prior edit. They are not additional independent source works and do not defeat source-level deduplication.
- The PeerTube sample is a different recorded media ID/source URL and file SHA than the two stock records; exact ID/hash comparison finds no collision with those records. No perceptual or cross-post search was run, and its preview shows no relevant action; exclude it.
- The Commons photo is a separate static image identity but is not one of the paper figures and is not a relevant popping visual. No project-wide static-image reuse prohibition was inferred.
- Rights states remain asset-specific: Pexels/Pixabay `PARTIAL`; PeerTube/Commons `UNKNOWN`; paper figures `UNKNOWN`. No credit line or third-party exception was upgraded by article access or file availability.

## 6. Minimal next-step recommendation (not started)

The lowest-cost next decision is for Reviewer to determine whether the textual inventory is sufficient for this audit and, if Owner wants a visual preview later, issue a separate bounded instruction to inspect the article’s Figure 1/3a/6 at the official source and review each figure’s displayed credit/licence line. That would still require a separate judgment on image quality, permitted reuse and any third-party exception. The previously used stock clips cannot fill future visual slots. No search, retrieval or media operation is initiated by this recommendation.

## 7. Execution and rollback

- No local file was written or changed; no historical archive, source media, R3 evidence, ignored cache, shared service, Git tree, frozen HTML, business code, network configuration or formal status was changed.
- PR contents are limited to this redacted text report and a candidate append to `docs/EXECUTION_EVIDENCE.md`. They contain no local absolute paths, raw media, frames, credentials, API keys, cookies or tokens.
- Rollback: close the unmerged PR and delete its isolated branch. No local cleanup is required.
- Reviewer boundary: PR text reports executor inspection. The underlying local frames/media are not uploaded; Reviewer has not directly seen those images in GitHub and should not be described as having independently inspected them.
