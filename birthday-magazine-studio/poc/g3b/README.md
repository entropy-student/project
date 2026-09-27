# G3B local PayPal Sandbox readiness proof

This disposable runtime is derived from the accepted G3A Docker/MariaDB package. It has its own
Compose project, network, named volumes and loopback-only ports so it does not reuse G3A or Mini
Craft resources. The G3A Good Issue preview, order-bound workspace plugin, and Mailpit routing are
mounted read-only. The local generation gate remains disabled.

Services:

- WordPress: `http://127.0.0.1:8137`
- Mailpit UI: `http://127.0.0.1:8138`
- MariaDB and SMTP: private to `birthday-magazine-g3b_private`, with no host port published

Use the G3B-scoped Compose file from the repository root:

```powershell
docker compose -p birthday-magazine-g3b -f birthday-magazine-studio/poc/g3b/compose.yaml up -d
```

The HTTPS forward-proxy detection only marks WordPress requests secure when the temporary HTTPS
origin reports `X-Forwarded-Proto: https` or Cloudflare's HTTPS visitor marker. It does not change
the canonical local Compose runtime or enable PayPal Live.

Remove only this stack after its evidence/Owner checkpoint no longer needs the local DB:

```powershell
docker compose -p birthday-magazine-g3b -f birthday-magazine-studio/poc/g3b/compose.yaml down --volumes --remove-orphans
```

Never use a global Docker prune command.
