# G3C — local UI/UX productization proof

**Current result: `RETURN_STARTER_IMPORT_FAILED`.** This Gate did not productize the home page because the official Starter Templates 4.7.7 Gutenberg library returned no `Bestselling Author` item in either Popular or Latest order. Astra's official page lists this exact starter as Free and Block Editor-compatible ([official template page](https://wpastra.com/templates/bestselling-author-02/)); the local importer fetched the catalog successfully but did not expose the required template. No other template was substituted, and no page was hand-built to imitate a successful starter import.

The G3C local scaffold reuses the G2A1 browser-local Good Issue preview and G3A WooCommerce/private-workspace boundary by copying their sources into this Gate directory; historical source directories remain unchanged. Since the required starter import failed, the product landing page, preview integration, visual screenshots, commerce CTA regression, and private-workspace regression were not run.

## Runtime boundary

- Docker Compose project: `birthday-magazine-g3c`
- WordPress: `http://127.0.0.1:8147/`
- Mailpit UI: `http://127.0.0.1:8148/`
- MariaDB has no published host port.
- WordPress and Mailpit bind only to loopback.
- Generation is disabled; no PayPal plugin/provider is installed or connected.
- Only synthetic fixture data is used. No payment or checkout submission is part of this Gate.

Compose uses its own `birthday-magazine-g3c_*` network and volumes. Never use global Docker cleanup.

## Reproduction

From this repository root:

```powershell
docker compose -p birthday-magazine-g3c -f birthday-magazine-studio/poc/g3c/compose.yaml up -d
node birthday-magazine-studio/poc/g3c/scripts/bootstrap-g3c.cjs
pwsh -NoProfile -File birthday-magazine-studio/poc/g3c/scripts/download-packages-g3c.ps1
node birthday-magazine-studio/poc/g3c/scripts/configure-g3c.cjs
```

The Starter Templates inspector selects **Build with Templates → Block Editor**, searches the exact template, then checks both Popular and Latest ordering. It never imports a template or selects an AI builder:

```powershell
node birthday-magazine-studio/poc/g3c/scripts/inspect-bestselling-author.cjs
```

Current sanitized result and screenshot are in `artifacts/reports/starter-template-importer-inspection.json` and `artifacts/screenshots/starter-template-importer.png`. Productization must stop until the required starter appears in the official free importer.

The import and runtime versions, sanitized browser network observations, responsive checks, screenshots, and local Docker inventories are stored under `artifacts/`. The local admin password and package cache live only under ignored `.tmp/` and must not be committed.

## Preview boundary

The adapted preview uses the G2A1 input model and `URL.createObjectURL()` for the selected optional cover photo. The browser does not POST that file. It does not call any model or image service.

## Cleanup

This attempt returned before product-page creation because the exact required starter was unavailable in the official importer. The G3C WordPress, MariaDB, Mailpit containers, project volumes/network, and ignored temporary files have already been cleaned; see `artifacts/reports/cleanup-readback.json`. To reproduce the local importer inspection from the repository root, use the setup steps above. After any future inspection, remove only this project's resources:

```powershell
docker compose -p birthday-magazine-g3c -f birthday-magazine-studio/poc/g3c/compose.yaml down --volumes --remove-orphans
```

Do not run `docker system prune`, volume prune, or cleanup against another project.
