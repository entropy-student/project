# CWS media provenance record contract v1

Use this record for each shot-specific discovery and acquisition canary. It is a documentation contract for ordinary JSON/CSV/Markdown records; it does not add a service or change downloader behavior.

## Required identity

- `run_id`, `gate_id`, date/time with timezone, episode and shot/beat ID.
- Frozen visual need and allowed/excluded actions.
- Tool/source version, execution result, and sanitized command/request reference.
- Local worktree state and the commit being exercised; never store private absolute paths or credentials in shared evidence.

## Seven separately reported stages

1. **`SEARCH_URL_FOUND`** — one record per query × search engine × original media site. Store semantic ID, exact query, requested media kind, engine, request time/latency, status, returned count, and upstream errors. An invocation blocked before an upstream request is `NOT_RUN`, with the blocker recorded; it is not an empty result.
2. **`URL_DEDUPED`** — preserve raw result count, valid source-page URLs, canonicalized page URL, dedup key, and duplicate target. Do not count search aggregators as media websites. Keep tracking parameters out of shared records while preserving platform identity parameters when needed.
3. **`ORIGINAL_IDENTITY_DEDUPED`** — record platform asset ID, creator/source identity, mirror/ repost relation, matching prior SHA or visual identity where available, and project use ledger result. Do not equate changed URLs, crops, encodes, or resolution with a new source.
4. **`PROBE_ELIGIBLE`** — record final display width/height after rotation and SAR, aspect ratio, duration, container/codecs, offered formats, and probe evidence. Exclude Mainland video platforms and square/portrait video. Unknown dimensions remain `UNKNOWN` until a bounded probe; do not classify them as portrait.
5. **`CONTENT_PREVIEW_VERIFIED`** — record the actual preview method and evidence, reviewer/date, visible action and relevance score. A thumbnail or title alone is not actual video content preview.
6. **`DOWNLOADED+FULL_DECODE_PASS`** — only after explicit candidate selection and allowed acquisition: record source page, selected format, bytes, elapsed time, SHA-256, FFprobe output reference, FFmpeg full-decode result, and representative-frame evidence. No download is `NOT_RUN` with reason, not success.
7. **`REUSE_RIGHTS_VERIFIED`** — independently record asset-level license/terms URL, author and required attribution, third-party/credit-line exceptions, and intended use scope. Set pass only when evidence supports this exact asset and use. Technical access or a provider-wide license page alone does not automatically establish project rights.

## Independent state fields

Keep these states separate for every candidate:

- `link_found`: `YES | NO | UNKNOWN`
- `content_verified`: `YES | NO | UNKNOWN`
- `reuse_rights_verified`: `YES | PARTIAL | NO | UNKNOWN`

Keep query counts distinct from the number of unique media sites, source identities, previews, downloaded files, and rights-cleared assets. Use `UNKNOWN`, `NOT_RUN`, `NOT_AVAILABLE`, or `NOT_APPLICABLE` where appropriate; never convert missing evidence into zero factual inventory or a pass.

## Minimum candidate fields

`candidate_id`, `search_event_ids`, `provider`, `platform_family`, `original_page_url`, `platform_media_id`, `creator`, `title`, `canonical_url`, `dedup_key`, `duplicate_of`, `project_use_state`, `format_probe`, `display_geometry`, `preview_state`, `visible_action`, `relevance_0_to_3`, `link_found`, `content_verified`, `reuse_rights_verified`, `rights_evidence`, `decision`, `exclusion_reason`.

## Acquisition safeguards and privacy

- Search and downloading are separate operations. Download only an explicit candidate ID after content, source identity, format, and rights checks; record `NOT_RUN` when no candidate meets the Gate.
- Keep the per-round file count and byte budget in the run header. Record actual bytes and a final SHA for each acquired file.
- Shared PR evidence must omit cookies, auth headers, tokens, signed URLs, user identifiers, private absolute paths, and original media. Keep local-only artifacts in the ignored CWS `.local` tree.
