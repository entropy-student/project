# Reviewer Decision — K6 Phase D RETURN Accepted; D-R1 Immutable Image Acquisition + Private Deployment Resume

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed Executor result

```text
GATE=K6_PHASE_D_PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE
RESULT=RETURN_REVIEWER_IMAGE_ACQUISITION_AUTHORIZATION_REQUIRED
EVIDENCE_COMMIT=198acb5a8b34659bc8c7ffcc029d7ba171df1fd1
HANDOFF_COMMIT=8508b40dbb68dd7d6145b99c7d14f7f07d63f12b
REMOTE_WRITES=0
```

Reviewer accepts this RETURN as correct and fail-closed.

Fresh preflight remains accepted as a dated snapshot:
- target identity/trust PASS;
- resource headroom PASS;
- Shared Caddy/cloudflared/80-443 ownership unchanged;
- Mini Craft app/mysql/wp-content/backup paths absent;
- existing Secret tree metadata PASS;
- accepted K5 SQL/wp-content package hashes PASS;
- canonical Compose package hash PASS;
- both approved application images absent on target;
- no image pull/build, project write, restore, service start, Shared Infra action, payment or Live action occurred.

## Technical decision

The immutable acquisition method is now explicitly frozen:

1. Registry source is limited to Docker Official Images:
   - `docker.io/library/wordpress:7.1.1-php8.3-apache`
   - `docker.io/library/mariadb:11.4.7`
2. Before any pull, resolve each tag **read-only** against the registry and record:
   - top-level OCI/Docker index/manifest digest;
   - exact `linux/amd64` platform manifest digest;
   - media type and platform tuple.
3. Require the requested tags to resolve successfully to exactly one usable `linux/amd64` image manifest. Any registry/repository/tag/platform ambiguity or mismatch -> RETURN before pull.
4. Freeze the `linux/amd64` manifest digest for each image in the Gate evidence and a non-secret resolved deployment manifest.
5. Pull only by exact immutable digest:
   - `docker.io/library/wordpress@sha256:<resolved-linux-amd64-digest>`
   - `docker.io/library/mariadb@sha256:<resolved-linux-amd64-digest>`
6. After pull, verify local image identity/OS/architecture and digest match. Run bounded no-network/no-port version probes sufficient to confirm the expected WordPress/PHP and MariaDB family without application startup.
7. Generate a resolved canonical Compose whose only semantic change from the sealed candidate is replacing the two tag references with the verified immutable digest references. Render/validate it explicitly.
8. Thereafter deployment/start must use only the resolved digest-pinned Compose with no build and no further pull.

This is a technical implementation decision within the already granted K6 Sandbox-first deployment authorization. No new Owner authorization is required.

## Conditional continuation

```text
IF IMAGE_RESOLUTION_AND_DIGEST_PULL_SEAL=PASS
THEN AUTHORIZE RESUME K6_PHASE_D_PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE
```

Any registry ambiguity, digest mismatch, platform mismatch, pull failure/ambiguity, image identity mismatch, unexpected host drift or package drift automatically cancels the continuation authorization and returns Reviewer.

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME
OWNER_ACTION=NONE
```

## Phase A — immutable image acquisition seal

Allowed:
- registry metadata resolution only;
- no-auth/public official registry access;
- metadata-only digest/platform evidence;
- pull the two exact resolved linux/amd64 digests only after read-only resolution passes;
- inspect pulled image metadata;
- bounded disposable no-network/no-port version probes;
- create/update non-secret resolved deployment manifest/Compose;
- render resolved Compose.

Required:
```text
WORDPRESS_OFFICIAL_REPO=docker.io/library/wordpress
WORDPRESS_REQUESTED_TAG=7.1.1-php8.3-apache
WORDPRESS_LINUX_AMD64_DIGEST=sha256:<...>
WORDPRESS_DIGEST_PULL=PASS
WORDPRESS_IMAGE_PLATFORM=linux/amd64
WORDPRESS_VERSION_PROBE=PASS

MARIADB_OFFICIAL_REPO=docker.io/library/mariadb
MARIADB_REQUESTED_TAG=11.4.7
MARIADB_LINUX_AMD64_DIGEST=sha256:<...>
MARIADB_DIGEST_PULL=PASS
MARIADB_IMAGE_PLATFORM=linux/amd64
MARIADB_VERSION_PROBE=PASS

RESOLVED_COMPOSE_DIGEST_PINNED=PASS
RESOLVED_COMPOSE_RENDER=PASS
UNREVIEWED_IMAGE_PULLS=0
BUILDS=0
```

Do not use a mutable tag for subsequent deployment after digest resolution.

## Phase B — resume private deployment

Only if every Phase A check passes.

Resume the previously authorized private deployment/restore pack:
- fresh recheck immediately before project writes;
- create only Mini Craft project namespaces;
- preserve existing Secret tree unchanged;
- transfer accepted K5 SQL/wp-content artifacts;
- deploy with the digest-pinned resolved Compose;
- restore MariaDB logical dump and wp-content;
- perform serialized-data-safe URL migration;
- start only Mini Craft WordPress + MariaDB;
- no host ports;
- MariaDB project-private internal DB network only;
- WordPress may join existing `spikersun-edge` as membership only;
- internal health/WooCommerce/Sandbox-state validation;
- resource delta, rollback readiness, cleanup.

## Forbidden

- any non-official/unreviewed registry source;
- tag-only production start after digest resolution;
- image build;
- extra image pull;
- Caddy/cloudflared/DNS/UFW/SSH/Docker-daemon/shared-network mutation;
- public ingress/route;
- Secret content/hash/rotation/overwrite;
- PayPal Live/real payment/refund;
- broad prune;
- unrelated project changes.

## Result

Success candidate:

```text
PASS_CANDIDATE_K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME
IMAGE_ACQUISITION_SEAL=PASS
PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE=PASS
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
REAL_PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*` and stop.

A PASS_CANDIDATE still does not authorize Shared Ingress/public HTTPS.
