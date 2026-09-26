# G2A1 Local WordPress PoC

This isolated Compose stack is for the G2A1 component probes only. It binds the WordPress site to `127.0.0.1:8127`, uses project-scoped Docker volumes/network, and contains no payment credentials or external payment service.

The `preview-plugin/` directory is mounted read-only into WordPress. Synthetic fixtures are kept under `fixtures/`. Runtime database and uploaded test files are disposable. Desktop and 375px screenshots were captured inline during execution but were not exported as project files by the browser-control surface.

Start from this directory with:

```powershell
docker compose -p birthday-magazine-g2a1 up -d
```

Remove only this test stack and its project-scoped volumes after the Gate:

```powershell
docker compose -p birthday-magazine-g2a1 down --volumes
```

Do not use broad Docker prune commands.
