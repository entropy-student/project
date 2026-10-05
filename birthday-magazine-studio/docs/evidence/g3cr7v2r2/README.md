# G3CR7V2R2 — Brand polish and retained runtime alignment

**Executor result: `PASS_CANDIDATE_G3CR7V2R2_BRAND_POLISH_RUNTIME_ALIGNMENT`; `STOP_AT_REVIEWER=YES`.** PR #64 remains open and unmerged. The gate's frozen source anchor was `18ab6b0e6d18d973bd4cc9376cec97b6fb89b830`; latest fetched `main` at execution was `07bdc6cf47dc6499de44dfa8b262ad1a6b7899d3`.

## Scope and result

The retained WordPress runtime was reconciled to the reviewed candidate before visual edits. Its active `birthday-magazine-poc.php` differed only in raw line endings; its normalized Git blob already matched the accepted candidate and no material local-only dependency was found. An exact pre-alignment byte backup remains local and ignored at `poc/g3c/.tmp/g3cr7v2r2-runtime-rollback/birthday-magazine-poc.php` (6,679 bytes; SHA256 `9de7b8f9ef1a7f646dcc7d2d2959164949ad310bad4921cea1f6915466d6a480`). The runtime PHP now matches the candidate bytes. `frontend-reproduction.php` and `.js` remain frozen; their runtime line endings normalize to the accepted blobs.

Only these tracked application paths changed:

- `poc/g3c/preview-plugin/magazine-preview.css`
- `poc/g3c/preview-plugin/frontend-reproduction.css`
- deleted `poc/g3c/preview-plugin/assets/g3cr7v2r1-soft-mesh.svg`

The two application CSS files now use Owner's Birthday Magazine mulberry and neutral tokens. The mesh pseudo-element, mobile override, SVG file, and runtime asset are absent. No replacement decoration was added. The magazine artwork retains its separate ivory/editorial palette. No PHP/JS, Gutenberg content, layout, intake fields, routing, payment, order, database, or business behavior was changed.

## Retained runtime

The existing container `birthday-magazine-g3c-wordpress-1` stayed running with the same container ID and start time. It still publishes only `127.0.0.1:8189`; its bind-mounted preview plugin points to the G3C project worktree. No build, pull, recreate, restart, teardown, volume/network mutation, or global cleanup occurred. Direct no-proxy HTTP GET read-back returned 200 for the homepage, intake, and visual status fixture. The runtime remains mounted at [http://127.0.0.1:8189/](http://127.0.0.1:8189/).

See [`runtime-readback.json`](runtime-readback.json) for container identity, source/runtime hashes, token values, mesh checks, actions, and limitations. See [`after/browser-smoke.json`](after/browser-smoke.json) for the route and interaction read-back.

## Screenshots

All six requested final states are under [`after/`](after/) and listed with dimensions, byte sizes, viewport, and SHA256 in [`screenshot-manifest.json`](screenshot-manifest.json):

1. Homepage Preview/core-entry with one browser-local synthetic photo — 1440×1000 viewport.
2. Same homepage Preview/core-entry — 375×812 viewport.
3. Intake Photos step with 12 synthetic geometric fixtures and one must-use selection — 1440×1000 viewport.
4. Same intake state — 375×812 viewport.
5. Clearly labeled local visual status fixture, not an order — 1440×1000 viewport.
6. Same status fixture — 375×812 viewport.

The homepage photo was created in the browser from a neutral canvas fixture and selected through the existing file input. Both preview images used `blob:` URLs. The 12 intake fixtures were also generated in browser memory; no fixture asset was added to the project.

## Verification

- Microsoft Edge 154.0.4258.53 + Playwright 1.62.1 (Node v24.19.0) capture/smoke: 6/6 screenshots; all six routes returned HTTP 200.
- At both widths, document width equaled viewport width; no horizontal overflow, active-surface broken images, or preview/photo-grid internal overflow.
- Homepage name, age, and photo updated; both displayed image sources remained `blob:`.
- Intake accepted 12 local fixtures, showed one must-use selection, retained the native `/checkout/` handoff URL, and Next/Back worked at both viewports.
- Computed application tokens read back as Owner-approved values; mesh pseudo-background computed as `none`.
- Browser network: 189 requests; 0 non-GET/HEAD requests, 0 model-provider requests, 0 external image requests, and 0 mesh requests. No orders, checkout submissions, payment/provider calls, or model calls were made.
- Edge reported two failed GETs for the existing Google-hosted Lato font. The UI rendered with its declared local/system fallback; these were recorded separately as non-critical font fallbacks, not hidden or treated as image/network-upload evidence.
- One initial PowerShell HTTP request followed the machine's loopback proxy and was refused; explicit no-proxy requests to Home, intake, and status all returned 200. Proxy settings were not changed and the container was not restarted.
- All forbidden action counters are zero. See the JSON read-backs for the exact list.

## Rollback and limits

Restore the two CSS files and mesh SVG from the frozen source anchor `18ab6b0e6d18d973bd4cc9376cec97b6fb89b830` to undo the source brand refinement. The local runtime PHP byte backup above restores its pre-alignment raw bytes if needed; it is intentionally not committed. This evidence records the executor candidate only; Reviewer acceptance remains pending.
