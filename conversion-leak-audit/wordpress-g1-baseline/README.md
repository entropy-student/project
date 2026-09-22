# G1 WordPress Local Baseline

Status: **ASSET_PREPARED / RUNTIME_NOT_PROVEN**

This package prepares the local WordPress baseline for Conversion Leak Audit without connecting Scanner, payment, VPS, domain, or production Secrets.

## Pages

- Home
- How it works
- Demo
- Pricing
- FAQ
- Blog

## Theme strategy

- Parent: SaasLauncher 2.0.18
- Child: `conversion-leak-audit-child`
- Minimal project-local styling only
- Gutenberg / Full Site Editing remains the editing surface

## Placeholder

`[cla_scan_placeholder]` renders a disabled URL field and disabled button. It deliberately performs no network request. Scanner connection belongs to G4.

## Local start

Windows PowerShell:

```powershell
./scripts/bootstrap-local.ps1
```

Linux/macOS:

```bash
./scripts/bootstrap-local.sh
```

Requires Docker Compose. This execution environment does not currently provide Docker/MySQL/WP-CLI/PDO SQLite, so runtime proof is intentionally not claimed here.

## Automatic runtime readback

Both bootstrap scripts finish by running `scripts/verify-g1.sh`. It writes `acceptance/G1_RUNTIME_READBACK.txt` and returns exactly one terminal state:

- `PASS_CANDIDATE_G1_WORDPRESS_LOCAL_BASELINE`
- `RETURN_G1_RUNTIME_READBACK_FAILED`

No manual browser clicking is required for the G1B evidence pass.
