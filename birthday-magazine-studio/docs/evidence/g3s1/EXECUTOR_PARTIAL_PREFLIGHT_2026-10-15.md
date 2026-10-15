# G3S1 Executor — partial local preflight return

Date: 2026-10-15  
Gate: `G3S1_LOCAL_STRIPE_GATEWAY_STAGING`  
Evidence class: direct local readback + GitHub connector readback  
Result: `RETURN_LOCAL_WORDPRESS_START_BLOCKED_BY_EXECUTION_POLICY`  
Reviewer stop: YES

## Fresh source readback

- GitHub `main`: `f7ee76c5f081cb74466716ab6d1c06474b29fac1`.
- PR #64: open, unmerged; branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`; pre-evidence head `c90e6f93803ad861745cd476106e00d01c68debb`; mergeability remains dirty.
- Read current `REVIEWER_HANDOFF.md`, unchanged G3S1 Gate, and `REVIEWER_DECISION_G3S1_RETURN_GITHUB_PLUGIN_TRANSPORT_CLOSED_2026-10-15.md`. The Reviewer kept G3S1 unchanged and required exact reconciliation of the reported 3-vs-4 containers before startup.
- Read the current Owner Stripe decision and the PR-head G3C Compose/source files. No Gate or product scope change.

## Target identity and the 3-vs-4 discrepancy

Direct local readback from the Owner Windows Docker Desktop host:

- Docker context `desktop-linux`, Docker Desktop Linux engine, server 29.7.2; 12 CPUs and 7,942,586,368 bytes reported memory.
- All four containers carry Compose project label `birthday-magazine-g3c`, use the same Compose working directory/config file under the local G3C worktree, and share the named project network.
- The current Compose file and PR #64 both define four services: the three previously reported core services (`db`, `wordpress`, `mailpit`) plus `wpcli`, a project helper container. This explains the count discrepancy; it is not an unrelated container. `wpcli` has no published host port and mounts the same WordPress volume and read-only project sources.
- Pre-start state: all four were stopped. IDs are recorded only by short prefix: DB `361d58eb5454`, WordPress `21892d72baeb`, Mailpit `35d286e7af50`, WP-CLI `de9742647e06`.
- Retained volumes: `birthday-magazine-g3c_database`, `birthday-magazine-g3c_wordpress`; network: `birthday-magazine-g3c_private`. Docker labels identify all three as local resources of the same Compose project.
- WordPress and Mailpit are bound only to `127.0.0.1:8189` and `127.0.0.1:8190`. No other Docker container or Windows listener occupied either port. No `cloudflared` process was present.
- Compose declares no public host binding. Container source/mount paths resolve to the local project G3C worktree, not a Shared VPS or production host.
- The local Git checkout HEAD is older than the PR head and has existing working-tree differences. No reset, cleanup, or checkout was performed. The exact Compose Git blob and the mounted `.htaccess`, preview-plugin (40 files), commerce-plugin, and Mailpit-plugin contents read from that worktree matched their corresponding PR #64 head blobs; only these content fingerprints were compared, not unrelated artifacts.

Selected mounted-source Git blob fingerprints:
| Source | Blob |
|---|---|
| `poc/g3c/compose.yaml` | `d174843bb0a510003c04c8ce327852860f886f31` |
| `poc/g3c/wordpress/.htaccess` | `fffb6517a4e192fd1594374c128da018455ff6cc` |
| `poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php` | `33ee82dd1c79c8e5f0c6ff85855b3a3537520b8c` |
| `poc/g3c/mailpit-plugin/00-g3a-local-mailpit.php` | `f24413f5978260b1998d121a69a28309a8145e66` |

The local G3C source worktree is mounted and its files were left untouched.

## Startup attempt and current state

- Started only the existing DB container by its exact ID. It reached `running / healthy`.
- The subsequent WordPress-start command was rejected by the local command-execution policy before the command ran. No alternate shell, Docker API, Compose recreation, or other route was used.
- Post-attempt readback: DB remains running/healthy; WordPress, Mailpit, and WP-CLI remain stopped. No host listener appeared on 8189/8190.
- Because WordPress did not start, HTTP/WP/Woo/plugin/gateway/product readback is **not completed**. The DB volume's historical identity is retained, but no logical database backup or restore-compatibility check was created.
- The DB start may have performed normal engine startup writes. No WordPress/Woo SQL or settings operation was executed.

## Gate evidence status

| Requirement | Status |
|---|---|
| Fresh main / PR / Gate readback | PASS |
| Actual local Docker target identity | PASS |
| Four-container count explained and classified | PASS |
| Existing project volumes/network and mounted source identity | PASS |
| No tunnel / no non-loopback host port | PASS |
| Existing DB container start and health | PASS |
| WordPress HTTP + DB/Woo/plugin fresh inventory | NOT RUN — WordPress start blocked |
| PayPal / Stripe enabled, Test, or Live flags | UNKNOWN — runtime unavailable |
| DB-consistent backup and recoverability proof | NOT CREATED |
| Official Stripe Gateway version/hash/install | NOT ATTEMPTED |
| Stripe/provider/auth/payment/webhook actions | 0 |
| PayPal mutation/removal | 0 |
| Checkout/order/refund/model/production/shared-infra/merge actions | 0 |

No secret, token, cookie, payment credential, customer data, SQL dump, or Provider payload is included.

## Reviewer routing

This is a partial **RETURN**, not a PASS candidate. The next permitted step requires the authorized local process path to allow starting the exact existing WordPress container. Then resume the original G3S1 sequence: fresh runtime/plugin/gateway readback, verified local backup barrier, and only if eligible stage the official Stripe Gateway inactive. Do not repeat the DB start, alter PayPal, or use another route to bypass the local execution-policy block.
