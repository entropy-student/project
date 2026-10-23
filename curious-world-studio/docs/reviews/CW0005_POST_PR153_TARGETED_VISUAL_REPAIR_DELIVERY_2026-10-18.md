# CW0005 targeted visual repair — delivery evidence

Gate: `CWS-CW0005-POST-PR153-TARGETED-VISUAL-STORYFIT-REPAIR-20261018`  
Delivery state: `PASS_CANDIDATE / INDEPENDENT_REVIEW_REQUIRED`

This PR contains a sanitized execution report only. It does not contain video, audio, generated images, original stock footage, paper figures, private paths, or production code. No formal CWS status is changed.

## Frozen project and output

- The CWS delivery-state correction is commit `c01ea4751bd168d44b602d265f75916d24cff159` (`IN_FLIGHT_VISUAL_DELIVERY_ONLY`). This delivery PR is based on current main `c5a49e0c1c6f0bdea117af1475a9695ea01bf45b`.
- Frozen shell: `visual/frozen/storyboard-v5-6-2-20261018.html`, Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`, SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`. The local copy stayed byte-identical.
- Two full 59.933-second renders exist. Render 1 was retained as superseded after its S06 wording overstated the visible motion. Render 2 is the final review candidate.
- Final MP4 SHA-256: `ACD29F628D5FB83AC3BF817CC522B7E0AD1B5183C38EA21634EF6C887011CA24`; H.264, 1920×1080, 30 fps, 59.933333 s; AAC mono audio.
- Full FFmpeg decode exited 0. Isolated headless Edge played at 1× to the end, with increasing currentTime and no page errors. This was automated playback; human-by-ear listening is `VOICE_BY_EAR_UNVERIFIED`.
- Owner-local review package SHA-256: `9D81FF112BD634F7418B5EC568A731847246A84995DFD918A62960E67E6027DD`. The package includes the MP4, both render outputs, captions/audio, concept illustrations, keyframes, sanitized metadata and logs.

## Media acquisition record and its limits

The only newly used stock asset is Pexels #7677397, [Flatlay Popcorn on Table](https://www.pexels.com/video/flatlay-popcorn-on-table-7677397/), by Mikhail Nilov. It is one contiguous auxiliary shot in S01 and is labeled as stock footage, not research footage. The local source file SHA-256 is `c2600c7ad5fab73e80d96d38469432fa6bec7cb10d270275f7c2622302a74ef6`; it is 1920×1080, 25 fps, 9.84 s, H.264, with no audio, and completed FFmpeg decoding.

Execution notes record that an initial hidden download-locator attempt timed out and the normal Free download control on the Pexels asset page was then used. The exact request, referrer, timestamp, search query, and elapsed time were not retained as raw logs. No SearXNG/4get search response, candidate inventory, or yt-dlp invocation is evidenced for this asset. We therefore do not claim multi-source discovery or an automated search-to-download pass. The page showed the Pexels Free License, while project-specific asset/credit/third-party reuse review remains `PARTIAL`; public use is not cleared.

## Image generation

The existing-image inventory was checked first. No compatible reviewed still safely showed all three distinct mechanism states; the earlier orange-jet image was rejected. Three concept illustrations were generated with the authorized Codex ImageGen Fast Path:

| State | output_hint | Calls | Retries | Peak concurrency | Dimensions | SHA-256 |
|---|---|---:|---:|---:|---|---|
| Formed | `exec-5d16d27d-a05e-4cf4-a50f-1a8229e5d770.png` | 1 | 0 | 2 | 1672×941 | `01feb9028de95d89ebbebd80e562bdda35d901462a76c5b6e150ef893fab0e63` |
| Compressed | `exec-2aac3b88-5041-4599-93ef-2549bd96b8e1.png` | 1 | 0 | 2 | 1672×941 | `337a9a623806b1257edf3456ca5cfbc5fe6d9ed3cad800933495e026d395c828` |
| Rebound | `exec-707d279f-9d27-4510-9ec5-fca8a0242ab4.png` | 1 | 0 | 2 | 1672×941 | `954ca9bbf2eeda70ea11add8822080738d4e354912c4c3f6e50a3d24bc4b0843` |

All three have source/output SHA matches and were visually checked; no retries were made for their native dimensions. Each is labeled “AI concept illustration, not research footage.” Token use, fee, and generation time were not measured: `TOKEN_SAVING_NOT_MEASURED`.

## Story and rights boundaries

The R2 narration wording was retained; seven threshold-confirmed silent ranges totaling 0.894958 s were removed from the reused voice, with no speech edits, speed changes, or new TTS. The final storyboard shows:

- S02–S03: 170°C 17/50 vs 180°C 48/50, then the sample-size caveat.
- S04–S06: formed → compressed → rebound concept states.
- S07–S08: separate acoustic experiment, second rupture near 100 ms and sound near 106 ms.
- S09–S10: observed jump result distinguished from the authors’ sound-source hypothesis.

No paper figures, research video, or study audio were copied. Historical Pexels #854959, Pixabay #2793, and Pexels #1796141/#35876717 were excluded from this sample. Rights remain `PARTIAL`.

## Requested independent review

Please inspect the final MP4 and package keyframes, confirm the S06 wording, verify the AI concept labels and auxiliary-stock distinction, and assess the disclosed provenance gaps. Keep the formal states unchanged:

`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH / RIGHTS_PARTIAL`.

The separate `RETURN_PROCESS_COMPLIANCE` audit remains for the next review and is not represented as passed by this delivery.
