# G1 Version Lock

As of 2026-09-17:

- WordPress: **7.1**
- SaasLauncher: **2.0.18**
- SQLite Database Integration: **3.0.2** (local fallback only; not production target)
- PHP baseline for local package: **8.2+ recommended**

## Notes

- Production database remains unresolved until VPS storage/onboarding Gate; do not infer SQLite production use from this local fallback.
- SaasLauncher is the parent FSE theme. The project child theme only carries minimal project-local styling and must not fork the parent theme.
- No production domain, payment provider, Secret, or Scanner URL is embedded here.
