# CW-0005 combined source-to-sample execution evidence

**Gate:** CWS-CW0005-COMBINED-STORYFIT-SOURCE-TO-SAMPLE-20261018  
**Execution result:** PASS_CANDIDATE for the internal sample’s technical checks; PAPER_MEDIA_RIGHTS_PARTIAL and VIDEO_VISUAL_REVIEW_NOT_VERIFIED remain open.  
**Git baseline:** main at db7abe20434f82da0acae683e2de5439078d6a9a. The Gate and R2 accepted script hashes matched the earlier local baseline; no business code or frozen HTML changed.

## Research source and evidence boundary

Primary paper: Virot & Ponomarenko (2015), *Popcorn: critical temperature, jump and sound*, DOI 10.1098/rsif.2014.1247 ([official PMC article](https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/); [publisher DOI page](https://royalsocietypublishing.org/doi/10.1098/rsif.2014.1247)).

- **Figure 1:** the paper reports 17/50 kernels popped at 170°C and 48/50 at 180°C. This is a sample result, not a guaranteed single-kernel switch.
- **Figure 3a:** the separate jump experiment describes shell fracture/starch expansion around 6.9 ms, foot formation/compression around 13.8 ms, and rebound/jump around 20.7 ms; the authors report no steam-jet “rocket effect.”
- **Figure 6:** a separate acoustic experiment synchronized high-speed imaging and microphone recording. The second fracture begins around 100 ms and sound around 106 ms. The vapor-release/cavity-vibration account is the authors’ hypothesis.
- Statuses are separate: article and supplement references **LINK_FOUND**; paper text/captions **CONTENT_VERIFIED**; original figure pixels and the S1/S2 video bytes were not visually verified. The article says “all rights reserved”; reuse rights for the figures and supplemental videos remain **UNKNOWN / NOT_PERMITTED for redistribution**. Figure 3b/c were not used.
- The PMC/publisher visual media path was blocked during this run. No CAPTCHA, access restriction, or rights boundary was bypassed. No paper figures or research video/audio were copied into the sample.

## New stock footage and usage

| Asset | Source and observed content | Download actually measured | Rights / use |
|---|---|---|---|
| Pexels #1796141 | [Source page](https://www.pexels.com/video/how-to-make-a-popcorn-1796141/); actual browser playback showed kernels heated in a pot and popped popcorn | 1280×720, 29.97 fps, H.264, 64.998 s, 17,270,525 bytes; SHA-256 3A490DDBA4B1674ED7D56313C005C5D1FBC1C7B417CDF8AFCE1465AB3C5C1227 | Pexels license terms reviewed ([license](https://www.pexels.com/license/)); asset-level reuse status stays PARTIAL. Used once as ordinary stock footage, never as research footage. The downloaded file is 720p despite the selected/download label suggesting Full HD. |
| Pexels #35876717 | [Source page](https://www.pexels.com/video/freshly-popped-popcorn-at-amusement-park-35876717/); actual browser playback showed popcorn in ordinary equipment | 1920×1080, 59.94 fps, H.264, 10.794 s, 6,495,697 bytes; SHA-256 A335FB037CC2F6AC9EEBF5C8436442013216E7915A449244A3D17A46A8EDDD48 | Same license review; asset-level reuse status PARTIAL. Used once as ordinary stock footage, never as the acoustic experiment. |
| Pexels #3752542 | [Source page](https://www.pexels.com/video/pooping-the-popcorn-on-its-microwavable-bag-container-3752542/); viewed; dark/off-topic for this sample | 1920×1080, 23.98 fps, H.264/AAC, 35.135 s, 16,264,254 bytes; SHA-256 1FAE61E258228DB9C3147EC011E96E26484019B43ACC01C7701450FFB5AB88BF | PARTIAL; excluded from the sample. |

Pexels #854959 and Pixabay #2793 remained blocked as already-used project assets and were not reused. One bounded Pexels search-results page and three direct asset pages were checked; this was not a broad search round. A local timeline export had called the second input slot “Pixabay”; the input file hash, Pexels source page, and rendered on-screen label identify it as Pexels #35876717. The sanitized review timeline corrects that metadata label; the video itself already shows the correct Pexels ID.

## Sample

The complete approved R2 narration S01–S10 was used without wording changes. The exact existing R3 narration WAV and existing subtitle timing were reused; no new TTS generation or payment occurred. The voice model identity was not re-established during this run.

- Sample: 55.266667 s including a 1.5 s Aqua opening; 1920×1080, 30 fps, H.264 video and AAC mono 24 kHz narration, 30,225,318 bytes.
- Sample SHA-256: **BE48565792F94FCCDEBB95229D8744D044B1EDF47A1CDBFA9015DC37E0EBDA6C**.
- Voice WAV SHA-256: **594bc25b871fc6d66ff3e251a71556a311b854c65d24694c81e74ec0c4a786ce**; duration 53.760 s.
- S01–S08 use one contiguous 42.966 s interval from Pexels #1796141; S09–S10 use one contiguous 10.794 s interval from Pexels #35876717. No source interval loops or repeats. First-source footage is upscaled from its actual 720p file into the 1080p master.
- S05 includes one static AI concept illustration (1672×941, SHA-256 1F27E8044536D73F11CD96F7E805D7DE5115F4F6A232C751ED82C1AF08721637) from 21.411–27.260 s, labeled “AI概念示意｜非研究录像.” It is not a recreated paper frame. Paper facts appear as cited text overlays, not copied charts.
- No experiment audio or stock audio is used. The sample contains narration only.

## Technical and browser QA

- FFprobe: exit 0; H.264 1920×1080 at 30/1; AAC mono 24 kHz; duration 55.266667 s.
- FFmpeg complete decode: exit 0. Nine representative frames were extracted successfully; S05 and acoustic-hypothesis frames were visually inspected.
- Local gallery was served only on 127.0.0.1:18783. In Codex’s isolated in-app Chromium, the native player was clicked at 1.00× without seeking. Browser status reported readyState 4, videoWidth 1920, videoHeight 1080; time progressed 0.01 s → 34.50 s → 55.27 s and ended=true.
- A page reload interrupted one earlier HTTP response (WinError 10054); the next media response was HTTP 200 and playback completed. This transient client-reset is recorded in the ignored local log.
- After Ctrl+C, port 18783 had zero listeners and no matching review-server process. This is executor-side playback verification, not independent Reviewer playback or Owner Edge review.

## Reviewer handoff and scope

Sample bytes and original media remain only in the ignored local run directory under .local/cw0005-combined-storyfit-20261018/run-20261018-181354/; they are not included in this PR.

On the same Owner Windows machine, run scripts/Start-ReviewGallery.ps1 from that run directory, then open http://127.0.0.1:18783/gallery/index.html and manually play the sample to completion at 1×. The helper refuses an occupied port and binds loopback only; stop it with Ctrl+C in its launch terminal. No external sharing is enabled.

Please review the scientific wording and source-to-shot mapping, the Pexels license boundary and PARTIAL status, the actual sample through the controlled local procedure, and whether the sample’s visual pacing satisfies the Gate. No media bytes, private absolute paths, tokens, or cookies are committed.

Formal project state remains **CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH**. This PR requests independent review only; it does not authorize merge, publication, or the next Gate.
