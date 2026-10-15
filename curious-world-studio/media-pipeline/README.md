# CWS MEDIA pipeline

This is an optional, local-only media discovery and technical QA utility. It connects SearXNG/4get search results to a deduplicated candidate index, bounded orientation/format checks, explicit-ID media acquisition, FFprobe/FFmpeg QA, and a local HTML gallery.

It does not change the production video pipeline, CW-0005 state, Research Aqua, Remotion, or the 3+1 source and rights contract. Search or technical download does not establish content suitability or reuse rights. The default `reuse_rights` value stays `UNKNOWN` until an asset is reviewed separately.

## Requirements

- Python 3.10 or newer; runtime and tests use the standard library.
- Existing `yt-dlp`, `ffprobe`, and `ffmpeg` executables for video operations; image acquisition requires `ffprobe` and `ffmpeg`.
- Existing local SearXNG and 4get endpoints for discovery.
- Optional explicit unauthenticated HTTP(S) proxy for external endpoints. Loopback search requests bypass it. Ambient proxy variables are removed from child processes.

The CLI accepts a work directory only inside `curious-world-studio/.local/`. That tree is ignored by Git and stores the index, downloads, previews, and gallery.

**Main status (2026-10-15):** this optional Python CLI was merged via reviewed PR #129. The Owner subsequently accepted the Windows **Docker-backed, on-demand** SearXNG/4get technical chain (G2–G4); see [current state](../docs/CURRENT_STATE.md). The Docker Compose, lifecycle scripts, and browser automation were exercised separately but are **not yet merged as first-class reusable tools**. A non-Docker search backend is no longer the current deployment goal. No formal shot matching, rights or video-production approval is implied.

## Windows PowerShell

Run from the repository root. Use the actual local service ports and verified HTTP/Mixed proxy endpoint for the machine; do not copy a stale port from this example.

```powershell
$tool = '.\curious-world-studio\media-pipeline\media_pipeline.py'
$work = '.\curious-world-studio\.local\media-pipeline'
$proxy = 'http://127.0.0.1:PORT'

python $tool --workdir $work search --engine searxng --kind video --query 'popcorn popping' --endpoint 'http://127.0.0.1:SEARXNG_PORT'
python $tool --workdir $work search --engine fourget --kind image --query 'popcorn close up' --endpoint 'http://127.0.0.1:FOURGET_PORT'
python $tool --workdir $work summary
python $tool --workdir $work --proxy $proxy --ytdlp 'C:\path\to\yt-dlp.exe' probe --ids video-REPLACE_WITH_CANDIDATE_ID
python $tool --workdir $work --proxy $proxy --ytdlp 'C:\path\to\yt-dlp.exe' download --ids video-REPLACE_WITH_CANDIDATE_ID --max-bytes 60000000
python $tool --workdir $work download-image --ids image-REPLACE_WITH_CANDIDATE_ID --max-bytes 15000000
python $tool --workdir $work gallery
```

Global executable and proxy options must appear before the subcommand. Search never starts downloads. Video acquisition requires an explicitly supplied candidate ID that passed a format probe; a caller may select a validated format ID. The CLI caps an invocation at 30 unique IDs, a video at 80 MB hard maximum, an invocation's video total at 2 GB hard maximum, and an image at 15 MB. 4get page 1 only is implemented; its continuation token is not inferred.

## Behavior and status boundaries

- Mainland video platform domains are excluded before video probing.
- Portrait and square video are excluded using display geometry after SAR and rotation. Unknown dimensions remain eligible for a bounded format probe.
- Video formats are selected only after dimensions pass the landscape rule. The downloaded file is checked again for display geometry and fully decoded.
- Images are indexed separately, can be acquired by explicit ID, and are decoded as images before being indexed as a successful local asset.
- The gallery distinguishes local media from search thumbnails. A search thumbnail is labelled as unverified and is not represented as actual video preview.
- `FULL_DECODE_PASS` and `IMAGE_DECODE_PASS` describe technical checks only. Rights, attribution, research provenance, and editorial action matching remain independent review fields.

## External URL safety scope

The local pipeline rejects private/non-global candidate addresses, checks redirect targets used by its bounded HTTP fetches, and probes unknown remote formats from bounded local temporary files rather than passing remote URLs directly to FFprobe. These checks are guardrails, not a complete SSRF sandbox: DNS is checked before the connection but is not pinned to the connected socket, and yt-dlp may follow provider-controlled redirects or nested manifests outside the Python redirect handler. Do not treat this utility as safe for arbitrary untrusted URLs on a network that exposes private services; use an independently restricted egress environment for that threat model.

## Tests

From `curious-world-studio/`:

```powershell
python -X utf8 -m unittest discover -s media-pipeline/tests -v
```

Windows integration acceptance has additionally exercised live SearXNG/4get video and image APIs, explicit candidate probes/downloads from two sites, full decoding, SHA-256, and a real image acquisition. Those results are in the separate Owner/Reviewer acceptance ZIP, not in Git.

## Known limits

- 4get continuation pagination is not implemented until its live token shape and continuation contract are validated.
- The built-in browser in this execution rejected `file:` URLs by security policy; the generated HTML and local asset paths were statically checked, while in-browser playback was not claimed as verified.
- The public-suffix fallback is intentionally approximate when no locally pinned PSL is supplied; platform exclusion uses explicit hostname suffix matching.
- This package does not select shots by semantic action, perform near-duplicate visual matching, establish commercial reuse rights, or connect to OpenMontage or Remotion. It is not a production-ready unattended downloader.
