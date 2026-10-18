# CWS media provenance record contract v1.1
Use one record per shot-specific canary. Keep historical search, current search, content evidence, and rights independent.

## Seven states
SEARCH_URL_FOUND → URL_DEDUPED → ORIGINAL_IDENTITY_DEDUPED → PROBE_ELIGIBLE → CONTENT_PREVIEW_VERIFIED → DOWNLOADED+FULL_DECODE_PASS → REUSE_RIGHTS_VERIFIED.

## Query fields
Record run/gate/time/shot, exact semantic and query, engine, page, elapsed time, counts, upstream errors, and the outer CLI exit/status. Retain both the outer envelope and index query event; this implementation may record SearXNG OK while the envelope says UPSTREAM_PARTIAL. Do not collapse these statuses.

## Candidate fields
Record candidate ID, source engine(s), provider/platform family, public page URL, platform media ID, creator only if verified, title, canonical URL, historical-use match, display geometry, format evidence, actual preview method, visible action, relevance score or NOT_SCORED, rights status, credit line, third-party exceptions, decision, and failure reason.

## Independent states
link_found=YES|NO|UNKNOWN; content_verified=YES|NO|UNKNOWN; reuse_rights_verified=YES|PARTIAL|NO|UNKNOWN. Titles, thumbnails, source-page opening, and advertised formats do not verify content or rights. Unknown dimensions remain UNKNOWN until bounded probing.

## Runtime and acquisition
Check Docker Desktop separately from Compose. CWS CLI owns Compose start/stop but does not start Docker Desktop. Keep memory/disk gates. Download only after explicit candidate selection and asset-level rights/content review. Record file bytes, SHA, FFprobe, and full decode; skipped acquisition is NOT_RUN with reason.
