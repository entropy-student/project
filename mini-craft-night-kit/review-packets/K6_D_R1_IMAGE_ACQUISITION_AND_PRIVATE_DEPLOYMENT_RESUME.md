# K6 Phase D-R1 — Immutable Image Acquisition Seal + Private Deployment Resume

Gate:
`K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_D_RETURN_D_R1_IMAGE_ACQUISITION_AND_RESUME.md`;
- prior Phase D execution pack;
- latest Evidence/Executor Handoff;
- unique current Shared VPS Handoff;
- accepted K5 release package.

## Objective

Resolve the two approved Docker Official Image tags to immutable `linux/amd64` digests, acquire only those exact digests, verify them, then continue the previously authorized private runtime deployment/restore without public ingress.

## Phase A — image resolution and acquisition seal

### Read-only resolution first

For:
- `docker.io/library/wordpress:7.1.1-php8.3-apache`
- `docker.io/library/mariadb:11.4.7`

Resolve and record, without pulling:
- registry/repository;
- requested tag;
- top-level digest;
- media type;
- exact `linux/amd64` child manifest digest;
- platform tuple.

Fail closed if:
- registry source is not Docker Official Images;
- tag is absent;
- manifest cannot be resolved;
- linux/amd64 child is absent/ambiguous;
- returned metadata is inconsistent.

### Exact pull

Only after both read-only resolutions pass:
- pull each image by exact resolved `linux/amd64` digest only;
- no tag-only pull;
- no build;
- no extra image acquisition.

After each pull:
- verify local image digest identity;
- verify OS=linux, architecture=amd64;
- run bounded disposable `--network none`, no-port, no-persistent-state version probes;
- do not start WordPress or MariaDB as applications.

### Resolved deployment manifest

Create a non-secret resolved production Compose/manifest where the only image-identity semantic change from the sealed candidate is:
- WordPress tag → exact verified digest ref;
- MariaDB tag → exact verified digest ref.

Render with explicit `-f`.
Subsequent deployment must use only this resolved digest-pinned Compose with no build and no further pull.

If any Phase A step fails or is ambiguous:
- stop;
- do not create project directories;
- do not transfer backups;
- do not start services;
- return precise `RETURN_*`.

## Phase B — resume private deployment

Only if Phase A fully passes.

Repeat a fresh bounded prewrite check, then follow the prior Phase D pack:

1. create only Mini Craft project-scoped apps/data/mysql/wp-content/backups paths;
2. preserve existing Secret tree unchanged;
3. transfer only accepted K5 SQL/wp-content and canonical deployment files;
4. deploy using resolved digest-pinned Compose;
5. restore MariaDB logical dump;
6. restore wp-content;
7. perform serialized-data-safe URL migration to `https://minicraft.spikersun.com`;
8. start only Mini Craft WordPress + MariaDB;
9. no host ports;
10. MariaDB only on project-private internal DB network;
11. WordPress may join existing `spikersun-edge` by membership only;
12. verify internal application/DB/WooCommerce/Sandbox state;
13. record resource delta and rollback readiness;
14. clean temporary transfer/restore artifacts.

## Hard boundaries

No:
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- public route;
- PayPal Live/real payment/refund;
- Secret value/hash/read/rotation/overwrite;
- extra image pull/build;
- unrelated project changes;
- broad prune.

## Required Evidence

Phase A:
```text
WORDPRESS_OFFICIAL_REPO=docker.io/library/wordpress
WORDPRESS_REQUESTED_TAG=7.1.1-php8.3-apache
WORDPRESS_TOP_LEVEL_DIGEST=
WORDPRESS_LINUX_AMD64_DIGEST=
WORDPRESS_DIGEST_PULL=
WORDPRESS_LOCAL_DIGEST_MATCH=
WORDPRESS_IMAGE_PLATFORM=
WORDPRESS_VERSION_PROBE=

MARIADB_OFFICIAL_REPO=docker.io/library/mariadb
MARIADB_REQUESTED_TAG=11.4.7
MARIADB_TOP_LEVEL_DIGEST=
MARIADB_LINUX_AMD64_DIGEST=
MARIADB_DIGEST_PULL=
MARIADB_LOCAL_DIGEST_MATCH=
MARIADB_IMAGE_PLATFORM=
MARIADB_VERSION_PROBE=

RESOLVED_COMPOSE_DIGEST_PINNED=
RESOLVED_COMPOSE_RENDER=
UNREVIEWED_IMAGE_PULLS=0
BUILDS=0
```

Phase B: all prior Phase D required markers, including:
```text
MARIADB_RESTORE=
WP_CONTENT_RESTORE=
URL_MIGRATION=
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
SECRET_VALUE_OR_HASH_ACCESS=0
STOP_AT_REVIEWER=YES
```

## Return

Success:
`PASS_CANDIDATE_K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME`

Otherwise return a precise `RETURN_*`.

Do not enter Shared Ingress/public HTTPS after this Gate.
