# K6 D-R2 — Compose SoT Reconciliation + Private Restore Execution Pack

Gate:
`K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_R1_RETURN_D_R2_COMPOSE_SOT_AND_PRIVATE_RESTORE.md`;
- latest accepted Evidence/Executor Handoff;
- unique current Shared VPS Handoff;
- accepted K5 release package.

## Canonical source ruling

The only accepted Compose source baseline is:

`C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B`

The previously referenced `03DCB12E...` value is a stale/unaccepted local execution-record value and must not block this Gate.

Do not search for or restore the `03DC...` artifact.

## Accepted immutable images

Use only:

- `docker.io/library/wordpress@sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`
- `docker.io/library/mariadb@sha256:b105d14ee1f4688769a57d432a9b52179e4d95f4495783ca8a41f3c783eab03c`

Freshly verify local cache identity/platform before use.

If either is absent, reacquire only that exact digest. No tag-only pull, build or extra image.

## Phase A — Compose reconciliation

1. Re-hash the current Phase-B source candidate.
2. Require exact SHA:
   `C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B`.
3. Derive a resolved production Compose by changing only the two image references to the accepted immutable digest refs.
4. Produce a normalized semantic comparison proving no other service/network/mount/logging/tmpfs/secret/port/restart/config semantics changed.
5. Render with explicit `docker compose -p mini-craft-night-kit -f <resolved-compose> config`.
6. Require:
   - exactly WordPress + MariaDB;
   - zero host ports;
   - MariaDB private internal DB network only;
   - WordPress existing `spikersun-edge` membership plus project DB network as designed;
   - exact ten read-only Secret mounts;
   - no anonymous durable volume;
   - existing tmpfs/logging/restart controls preserved.

Any mismatch -> RETURN before runtime creation.

## Phase B — fresh target prewrite

Before write:
- strict SSH identity/pin;
- fresh disk/RAM;
- existing shared service/network/80-443 baseline;
- exact Secret metadata-only state;
- Mini Craft container/network collision;
- accepted staged K5 SQL/wp-content hashes under `/srv/backups/mini-craft-night-kit`;
- accepted image digest cache identity.

Do not retransfer recovery artifacts if staged copies match.

## Phase C — project-private runtime + restore

Allowed:
- create/recreate only project-local:
  - `/srv/apps/mini-craft-night-kit`
  - `/srv/data/mini-craft-night-kit/mysql`
  - `/srv/data/mini-craft-night-kit/wp-content`
- use existing `/srv/backups/mini-craft-night-kit`;
- preserve existing `/srv/data/mini-craft-night-kit/secrets` unchanged;
- install resolved digest-pinned Compose/non-secret manifest in app path;
- start only Mini Craft MariaDB + WordPress;
- restore accepted MariaDB logical dump;
- restore accepted wp-content;
- join WordPress to existing `spikersun-edge` as service membership only; do not alter/recreate shared network.

No host ports.

## WordPress origin handling in this Gate

After DB restore, update only the scalar options:

- `home`
- `siteurl`

to:

`https://minicraft.spikersun.com`

Use an exact DB update scoped to those two option rows.

Forbidden:
- broad SQL search/replace;
- editing serialized option/postmeta payloads;
- installing migration tooling in this Gate.

Record:

`FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED`

## Internal validation

Prove:
- exact running digest image identities;
- MariaDB healthy;
- WordPress healthy;
- zero host ports;
- MariaDB not on shared edge network;
- WordPress joins only intended networks;
- DB integrity/basic query checks;
- restored wp-content/media presence;
- `home/siteurl` exact values;
- private/internal primary page responses;
- WooCommerce core/product/cart/checkout state where practical;
- PayPal remains Sandbox/Live disabled without Provider action;
- unrelated services/networks/ports unchanged;
- resource delta recorded.

Do not require the entire site to be free of legacy `localhost:8093` references in this Gate. That is the next serialized-migration Gate.

## Rollback / cleanup

Rollback must remove/stop only Mini Craft project runtime while preserving:
- Secret tree;
- staged recovery artifacts;
- Shared Infra;
- unrelated services.

No broad prune.

Clean temporary transfer/render/restore artifacts.

## Forbidden

No:
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- public route;
- full serialized URL migration;
- extra tool/image acquisition beyond exact accepted WP/MariaDB digests;
- Secret content/hash/rotation/overwrite;
- PayPal Live/payment/refund;
- unrelated project changes.

## Required Evidence

```text
CANONICAL_SOURCE_SHA=C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B
STALE_03DC_RECORD_IGNORED=YES
RESOLVED_COMPOSE_DIGEST_PINNED=
SEMANTIC_DIFF_IMAGE_REFS_ONLY=
RESOLVED_COMPOSE_RENDER=
FRESH_SHARED_VPS_PREFLIGHT=
STAGED_K5_SQL_HASH=
STAGED_K5_WP_CONTENT_HASH=
WORDPRESS_DIGEST_IDENTITY=
MARIADB_DIGEST_IDENTITY=
MARIADB_RESTORE=
WP_CONTENT_RESTORE=
HOME_SITEURL_SCALAR_UPDATE=
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
MARIADB_HEALTH=
WORDPRESS_HEALTH=
WORDPRESS_INTERNAL_PRIMARY_ROUTES=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
PUBLIC_INGRESS_CHANGE=0
PUBLIC_ROUTE_ENABLED=NO
UNRELATED_SERVICES_CHANGED=
ROLLBACK_READY=
RESOURCE_DELTA_RECORDED=
REMOTE_TEMP_CLEANUP=
SECRET_VALUE_OR_HASH_ACCESS=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE`

Otherwise precise `RETURN_*`.

Do not enter serialized migration or public ingress after this Gate.
