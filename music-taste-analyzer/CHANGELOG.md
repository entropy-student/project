# Changelog

## v0.2.1 — Same-page QR + Analysis Calibration

### Login / UX
- QR login now stays entirely inside the same Web page.
- One-time login URLs are converted by the embedded Go server into in-memory PNG Data URIs.
- Removed the need for a second PowerShell window, external QR generator, or `netease-login.png`.
- QR rendering itself has no CDN or external QR-service dependency.

### Privacy / storage
- User cookies, raw playlists and results are not written into the project directory by default.
- Raw observations are removed from the active analysis flow after profile generation and left to Go GC for memory reclamation.
- Completed profiles are removed on explicit delete/page cleanup or TTL expiration.
- JSON export remains an explicit browser-side action.
- Representative tracks in the retained Profile no longer carry raw private playlist names.

### Session lifecycle
- A successful QR login now switches from the short authentication TTL to a bounded queue window; once an analysis worker is acquired, the analysis deadline is refreshed so long queue waits do not consume the actual collection budget.
- Kept random per-session tokens, per-IP session caps and global active-analysis limits.
- Each login session keeps its own upstream music client.

### Analysis v2.1
- Added `DataQuality`: missing rows, merged duplicates, filtered noise-artist mentions and samples.
- Noise-only artist rows no longer dilute valid artist-share and Top10 concentration metrics.
- Added signal coverage for style / mood / scene / energy deductions.
- Playlist semantic evidence is computed from raw playlist placements instead of replaying a deduped track's full accumulated weight into every playlist label.
- Added ASCII keyword boundaries (`workout` no longer matches `work`; `golden` no longer matches `old`).
- Removed generic `pop` matching from western-pop rules, avoiding accidental K-pop → western-pop classification.
- Expanded style rules, including Mandarin pop.
- Kept collaboration weight splitting, song-first/artist-first mode, exploration type, favorite share, multi-playlist share and representative-track diversification.
- Fixed percentage formatting where values such as `20%` could previously display as `2%`.

### UI
- Added behavior profile, favorite/multi-playlist metrics, semantic-signal coverage and data-cleaning summary.
- Kept explicit caveats distinguishing playlist-title evidence and text-system inference from real audio/language analysis.

### Verification
- Unit tests cover weighting/deduplication, text systems, noise filtering, keyword boundaries, semantic evidence accounting, data-quality counters, percentage formatting and local QR rendering.
- `go test ./...`, `go vet ./...` and Windows amd64 cross-build pass against compile-time stubs of the pinned external APIs in the sandbox.
- Live music-platform behavior still needs user-side network testing because the sandbox cannot authenticate to those services.
