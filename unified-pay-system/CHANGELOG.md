# Changelog

## 2026-09-08 — Repository boundary + shared hub decision

### Changed

- Reorganized Unified Pay as a self-contained project under `unified-pay-system/`.
- Removed Unified Pay runtime/deployment artifacts from the `project` repository root.
- Declared the repository root as project index / global configuration only.
- Added Chinese and English project documentation.
- Added `PROJECT_RECORD.md` for long-term handoff and decision tracking.
- Added `docs/SHARED_PAYMENT_HUB.md`.

### Architecture decision

Unified Pay is now explicitly treated as a **single shared payment hub** for multiple products. New products should register App + SKU + fulfillment configuration rather than create a new payment stack.

### Deployment status

Railway service exists but production build is still being debugged. The active deployment entrypoint is kept entirely inside `unified-pay-system/`.
