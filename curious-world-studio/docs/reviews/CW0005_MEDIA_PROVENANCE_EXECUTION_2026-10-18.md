# Execution summary
## Result
PARTIAL_SEARCH. Executor started the existing Docker Desktop after the initial daemon check failed. One bounded semantic reached both search services; the second remained blocked by the 1,664 MiB safety gate. No media was downloaded.

## Docker and source
- Docker Desktop product 4.88.1.237512; Engine 29.7.2; Compose 5.4.0.
- Before launch there was no Desktop/backend process. The CWS doctor reported DOCKER_DAEMON_UNAVAILABLE.
- All pinned CWS images were already local; compose pull policy was never; no image was pulled.
- CWS project cws-media-ops-6b7eb0f402 started by the CLI; SearXNG and 4get health checks returned HTTP 200. CLI cleanup was STOPPED_AND_VERIFIED; final project containers are exited and ports 18080/15050 are free. Docker Desktop remains running. Other projects were not changed.
- Local cws_media.py and Compose match fetched main blobs. Local imported media_pipeline.py differed; a local-only harness injected the fetched main helper and media_filter without changing tracked sources.
- Test-time main snapshot: 340c548101f7a008c175e02be35b5d94ad55657e. Current-main helper Git blobs used by the local harness: media_pipeline.py 0204d11569ca64de7ca31c55975859f95c9eaa32; media_filter.py 2407ebe0500acdb8e2e1845d4366e074dc7d7610. The evidence PR branch was separately created from the then-latest main b7dadb901e1ad2466e7fda7aac7322e4a3124b0a.

## Search
- S01-A: SearXNG 84 results, UPSTREAM_PARTIAL (brave.videos and google videos errored); 4get 11 results, OK. Latencies 2,750 ms and 1,625 ms. Union: 87 unique source-page URLs, 8 cross-engine URL duplicates, 14 registered domains.
- CWS index query event said SearXNG OK while the actual CLI envelope said UPSTREAM_PARTIAL; the outer envelope is authoritative.
- S01-B sent zero upstream requests. The CWS memory guard returned LOW_MEMORY twice: 685 MiB and 794 MiB, below 1,664 MiB.
- All 87 results had unknown geometry. Four sampled format probes stopped before yt-dlp at NON_PUBLIC_MEDIA_ADDRESS.
- Browser: YouTube page navigation timed out/blank; Dailymotion page displayed “无法播放媒体”; PeerTube page loaded but was not played. Its public API listed Unknown license and an advertised 1080p/30fps rendition. Actual content preview count: 0.

## History and rights
PR #155 request/response and candidate history was not retained: UNKNOWN. A separate 2026-10-15 cache had 85 items (15 video) and 4 exact URL overlaps with current results; remaining pages are not proof of distinct original works. Existing used stock clips were excluded. No new Pexels/Pixabay candidate appeared, and OpenMontage was unavailable in the checked scope. New asset rights remain UNKNOWN.

## Acquisition
No candidate met both S01 visual relevance and verified free asset-level terms. Download attempts: 0; bytes added: 0; FFprobe/FFmpeg on new media: NOT_RUN.

## Local worktree
Preflight branch was an older clean checkout; no tracked source changed. Python import generated two untracked .pyc files in the package cache. A cleanup command was rejected by command safety policy; cache was left untouched and excluded from the PR/ZIP.
