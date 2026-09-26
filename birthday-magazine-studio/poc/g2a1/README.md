# G2A1 Local WordPress PoC

This isolated Compose stack is for the G2A1/G2A1R1 component probes only. It binds WordPress to `127.0.0.1:8127` and the Mailpit web UI to `127.0.0.1:8128`; SMTP is available only to Compose services and is not published to the host. The project-scoped stack contains no payment credentials or external payment service.

The `preview-plugin/` directory and the local Mailpit-only MU plugin are mounted read-only into WordPress. The mail helper is enabled only in this disposable stack and routes mail to `mailpit:1025` without authentication or host-published SMTP; Mailpit has no relay or forwarding configuration. Synthetic fixtures are kept under `fixtures/`. Runtime database, captured mail, and uploaded test files are disposable. G2A1R1 visual evidence is retained under `../../docs/evidence/g2a1r1/`.

Start from this directory with:

```powershell
docker compose -p birthday-magazine-g2a1r1 -f compose.yaml up -d
```

Remove only this test stack and its project-scoped volumes after the Gate:

```powershell
docker compose -p birthday-magazine-g2a1r1 -f compose.yaml down --volumes
```

Do not use broad Docker prune commands.
