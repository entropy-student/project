# CW0005 media provenance canary — execution record

**Gate:** `CWS-CW0005-MEDIA-PROVENANCE-BOUNDED-MULTISOURCE-VALIDATION-20261018`  
**Run:** `CWS-CW0005-MEDIA-PROVENANCE-20261018-01`  
**Result:** `PARTIAL_SEARCH`  
**Formal production state:** unchanged: `RETURN_PROCESS_COMPLIANCE / RIGHTS_PARTIAL / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`.

## Scope and method

This report follows the current [Gate](../CWS_CW0005_MEDIA_PROVENANCE_AND_BOUNDED_MULTISOURCE_VALIDATION_GATE_2026-10-18.md) and its `REVIEWER_TO_EXECUTOR_RELAY`. It records a read-only reconciliation of PR #155, a bounded attempt to use the current CWS discovery CLI, and a reusable record contract. It does not rewrite PR #155 history or infer search events that were not retained.

The local repository checkout was a clean, shallow, older repair branch at `0a7becd74a7f627d79286760b1f2938121b1bfdd`. Latest main observed through GitHub was `38d6bc58e32e04b937bf6c78cd74c936fa6191b1`. No pull, reset, cleanup, or old-worktree modification was performed. The local `cws_media.py` and Compose file matched current-main blob SHAs; the imported local `media_pipeline.py` did not (`f14ec17c96efc111726fc84c2e8733abb9a82441` vs current-main blob `0204d11569ca64de7ca31c55975859f95c9eaa32`). This source drift was recorded and not patched in place.

## PR #155 history reconciliation

- The PR #155 evidence ZIP SHA-256 was independently read as `9d81ff112bd634f7418b5ec568a731847246a84995dfd918a62960e67e6027dd`. Its retained lineage report says that Pexels #7677397 was the only new stock clip used, obtained from the normal Free control after a hidden locator attempt timed out.
- The retained report SHA-256 is `04cc7da1898ce468c579150508c6ea22381c4fb44c15261833946577905adce4`. It explicitly records no SearXNG/4get request/response, query list, candidate inventory, result counts, deduplication, or comparison. The exact historical search path is therefore `UNKNOWN`; this is not evidence that no search ever happened.
- The local source file matched the recorded SHA-256 `c2600c7ad5fab73e80d96d38469432fa6bec7cb10d270275f7c2622302a74ef6`, size 6,020,199 bytes. The retained technical record reports H.264, 1920×1080, 25fps, 9.84s, no audio, and full FFmpeg decode pass. It is already used in historical S01 and is excluded from this canary under the one-use rule. Provider-level Pexels license information is recorded in the prior review, while project-specific reuse/credit review remains `PARTIAL`.
- A separate 2026-10-15 local media catalog (not PR #155 lineage) had 3 Fourget query events: video `popcorn popping` (11), image `popcorn popping` (81), video `popcorn popping` (13). It holds 85 catalog rows / 85 unique stored source-page keys (15 video, 70 image; 14 popcorn-titled video rows). The event counts sum to 105; the 20-row difference from the final catalog cannot be reconstructed without raw responses. This cache is historical context only and is not counted as this run's search.
- One prior PeerTube regression fixture in that catalog was already locally decoded. Its saved representative frame was inspected read-only and shows a captured Reddit text post, not a popcorn popping action; rights are `UNKNOWN`, action relevance is 0, and it is not an S01 candidate.

Historical status: `PR155_HISTORY=PARTIAL`. Missing records remain `UNKNOWN`.

## Current host and bounded search attempt

The new isolated run directory is under the ignored CWS `.local/media-process-validation-20261018/`; the old checkout remains clean. The current CWS CLI doctor reported Python 3.10.11, yt-dlp 2026.08.19, FFmpeg/FFprobe 9.0, Docker CLI present, Compose 5.4.0, free memory 2,804 MiB (gate minimum 1,664 MiB), and free disk 176,395 MiB (minimum 2,048 MiB). Both loopback search ports (18080 and 15050) were closed. Docker CLI could not reach the Docker Desktop Linux engine; `docker info` reported the engine pipe unavailable.

One bounded CLI discovery invocation used the first Gate semantic, `popcorn kernel popping in pan close-up`, with `--kind video`. It exited 2 with JSON code `DOCKER_DAEMON_UNAVAILABLE` before any upstream request was sent. Direct loopback health requests to SearXNG and 4get raised `HttpRequestException` without an HTTP status because no listener was present. No containers were started, no image was pulled, and no service or shared network setting was changed. The second semantic was not attempted because the same prerequisite had already failed.

The installed CWS source does not expose an OpenMontage adapter: current-main README states that this pipeline does not connect to OpenMontage; no OpenMontage MCP tool, command, or standard install directory was found in this session. This is `NOT_AVAILABLE_IN_CHECKED_SCOPE`, not a claim about every possible custom installation.

Two cached YouTube pages from the historical Fourget index were considered for preview: `FSZd33awqQk` (“Popping Popcorn at 30,000 FPS in Ultra Slow Motion”) and `9YmLOalA_s8` (“Popcorn Popping (100,000 Frames Per Second) | Beyond Slow Motion”). The web page fetch tool returned “Failed to fetch” for both. This does not establish that the source pages are unavailable; no actual video frame, format list, or reuse permission was verified. Both remain `CONTENT_PREVIEW_NOT_VERIFIED / FORMAT_UNKNOWN / RIGHTS_UNKNOWN`.

## Seven-layer evidence

| Layer | This run | Historical context |
|---|---|---|
| `SEARCH_URL_FOUND` | `NOT_RUN`: 0 upstream requests; the CLI stopped before SearXNG/4get query calls. | 85 stored URLs in an unrelated historical Fourget catalog; not fresh search evidence. |
| `URL_DEDUPED` | `NOT_RUN`: no fresh result set. | 85 unique source-page keys in the stored catalog; raw result reconciliation remains incomplete. |
| `ORIGINAL_IDENTITY_DEDUPED` | `NOT_RUN` for new candidates. | 14 historical YouTube video IDs were distinct; no visual near-duplicate test was retained. |
| `PROBE_ELIGIBLE` | `NOT_RUN`: no fresh candidate could be probed. | Cached YouTube dimensions are unknown. Previously used Pexels #7677397 is 1920×1080 but cannot be reused. |
| `CONTENT_PREVIEW_VERIFIED` | `0` new S01 candidates. | PR #155 Pexels clip has historical preview/decode evidence but is already used; the unrelated PeerTube fixture is visually irrelevant. Two YouTube page fetches failed before playback. |
| `DOWNLOADED+FULL_DECODE_PASS` | `0` new downloads; `0` bytes. | Historical Pexels technical QA is recorded; no new candidate was acquired. |
| `REUSE_RIGHTS_VERIFIED` | `0` new candidates. | Pexels project rights remain `PARTIAL`; cached YouTube and PeerTube fixture rights are `UNKNOWN`. |

No new candidate met the Gate's selection precondition (clearly closer to popping/jumping, unused, and with explicit free acquisition/reuse terms). Accordingly, download was correctly not run; no media was added to the local run.

## Conclusion and reviewer stop

`PARTIAL_SEARCH` is the accurate canary result. The search and candidate validation chain could not be exercised because the existing Docker engine was unavailable, local imported source was stale, OpenMontage was unavailable in the checked scope, and cached candidate pages could not be previewed through the attempted fetch route. No alternate search architecture was substituted.

This report does **not** convert PR #155's `RETURN_PROCESS_COMPLIANCE` to PASS and does not change any production, rights, story-fit, or publishing Gate. Review the PR and the attached local evidence ZIP independently.
