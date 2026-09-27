# G2B local AI → PDF proof harness

This is a local, synthetic-only Solution Proof harness for `G2B_LOCAL_AI_PDF_SOLUTION_PROOF`. It does not connect WordPress, WooCommerce, payment, email, or a production service. The synthetic order key exercises only the local orchestration boundary.

## Run the reproducible reference pipeline

```powershell
npm ci
npm run proof
```

The runner binds a short-lived HTTP server to `127.0.0.1`, creates synthetic PNG scene tiles in the browser, renders the 12 US Letter pages with the configured local Chrome/Chromium binary, captures screenshots, opens the resulting PDF with `pdf-lib`, and writes the QA/grounding/idempotency reports under `artifacts/`.

Set `BMS_BROWSER_EXECUTABLE` only when the browser is installed outside the runner's standard Chrome paths. Browser network requests to non-loopback origins are blocked and recorded.

## AI provider boundary

`src/provider.mjs` defines the `ContentProvider` interface and a configurable Chat Completions JSON Schema adapter. It does not choose or bundle a vendor. The adapter is not called during this proof because this project Gate has no approved protected model credential. The checked-in `fixtures/reference-content.json` is **human-authored synthetic renderer data, not AI output**; it exists only to prove the downstream deterministic renderer and QA. Never report it as AI generation.

The optional `--live-ai` path requires a future explicit Reviewer authorization and these protected runtime values: `BMS_AI_CHAT_COMPLETIONS_URL`, `BMS_AI_MODEL`, and `BMS_AI_API_KEY`. The key is read only into memory, never printed or persisted. No `.env` file is used or committed.

## G2BR1 ChatGPT-authenticated Codex route

The G2BR1 runner reuses the checked-in intake, schema, metadata selection, renderer, PDF reader, and QA. It requires `codex login status` to report a ChatGPT login. Set `BMS_CODEX_EXECUTABLE` only when the signed-in Codex CLI is not the first `codex` executable on `PATH`, then run `npm run proof:g2br1`. The runner invokes one read-only, ephemeral `codex exec --output-schema` process with the synthetic prompt; API-key and API-endpoint environment variables are removed from that child process. It retains the model JSON and actual-AI artifacts under `artifacts/g2br1/`.

The canonical synthetic job record remains with the evidence to block future duplicate generation. After the first invocation, `npm run proof:g2br1:duplicate` checks that a duplicate is rejected before another Codex process is started. Retries require `--retry-failed`, are limited to schema/runtime/transient failures, and cannot exceed three Codex process runs for the canonical job.

## Synthetic image boundary

The 16 PNG files are deterministic geometric scene illustrations generated from local SVG markup by Playwright. They contain no people, customer photos, or AI-generated imagery. Their fixture metadata includes source-field cues and a deterministic selection rank. Photo mapping proof therefore covers file/type validation, metadata-guided selection, must-use preservation, page-slot assignment, and rendering. It does not prove photographic vision or semantic matching on real-world pictures.

## Dependencies

- Node.js 24.19.0 (local execution runtime).
- Playwright 1.62.1, Apache-2.0: local browser control and real Chromium/Chrome PDF printing.
- `pdf-lib` 1.17.1, MIT: PDF parse/open and page-count read-back.
- Chrome for Testing is not bundled; the captured run used Google Chrome 153.0.8010.54, installed locally. No browser binary is committed.

Package versions are exact in `package.json` and `package-lock.json`. `node_modules/`, temporary registry downloads, and runtime job state are excluded from Git.
