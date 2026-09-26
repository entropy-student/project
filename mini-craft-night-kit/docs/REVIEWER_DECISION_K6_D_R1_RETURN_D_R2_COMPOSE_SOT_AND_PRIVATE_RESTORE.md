# Reviewer Decision — K6 D-R1 RETURN Accepted; D-R2 Compose SoT Reconciliation + Private Restore

Date: 2026-09-26
Role: Reviewer / Architect / Gatekeeper
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest

## Reviewed result

```text
GATE=K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME
RESULT=RETURN_REVIEWER_K6_D_R1_COMPOSE_SOURCE_HASH_MISMATCH
EVIDENCE_COMMIT=933413ba00b77b8e16dab8173ba6c3868cffd942
HANDOFF_COMMIT=2cd3e2ab174ee80092670d3bcae80deef1ccb614
```

Reviewer accepts the Executor RETURN as fail-closed, but does **not** accept the conclusion that the current candidate Compose violates the accepted project baseline.

## Source-of-Truth reconciliation

The formal accepted K6 Phase B R1 Reviewer decision and accepted Evidence record:

```text
CANONICAL_ACCEPTED_COMPOSE_SOURCE_SHA256=
C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B
```

This value was explicitly reviewed in:
- `docs/REVIEWER_DECISION_K6_PHASE_B_R1_PASS_PHASE_C0_PREWRITE_READONLY.md`;
- accepted `EXECUTION_EVIDENCE.md` for `K6_PHASE_B_R1_PACKAGE_RECONCILIATION`.

The conflicting value:

```text
03DCB12E3B8FCFC1A58329CCACE3949DEEAB64DA292AF885FA8817A16DA829BF
```

is only referenced by the D-R1 Executor as coming from a local `K6B execution record`. It was never promoted into a Reviewer PASS decision or accepted project Evidence as the canonical Compose source identity.

Under Governance project-fact priority, the formal accepted Reviewer decision + accepted Evidence supersede this stale/unaccepted local execution-record value.

Formal ruling:

```text
C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B=CANONICAL_ACCEPTED_SOURCE
03DCB12E3B8FCFC1A58329CCACE3949DEEAB64DA292AF885FA8817A16DA829BF=STALE_UNACCEPTED_LOCAL_RECORD
COMPOSE_SOURCE_INTEGRITY_BLOCKER=RESOLVED_BY_REVIEWER_SOT_RECONCILIATION
OWNER_ACTION=NONE
```

Do not search for or restore the `03DC...` artifact as a prerequisite.

## Accepted image seal from D-R1

The following image-resolution facts are accepted for continued use, subject to fresh local cache/read-back before start:

WordPress:
- official repo: `docker.io/library/wordpress`
- requested tag: `7.1.1-php8.3-apache`
- top-level index: `sha256:51464c8fdb100c5cd2ebfaec1834cf111d993bc4929ef2330c1cc721eda0fc30`
- linux/amd64 manifest: `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`
- version probe: WordPress 7.1.1 / PHP 8.3.33

MariaDB:
- official repo: `docker.io/library/mariadb`
- requested tag: `11.4.7`
- top-level index: `sha256:39596f079862334be04f4231664862e55d4febe54309cc62f750f2297de85b06`
- linux/amd64 manifest: `sha256:b105d14ee1f4688769a57d432a9b52179e4d95f4495783ca8a41f3c783eab03c`
- version probe: MariaDB 11.4.7

No repull is required if these exact linux/amd64 digests remain present and inspect correctly. If absent, only these exact digests may be reacquired.

## Accepted remote staging from D-R1

The accepted K5 SQL and wp-content artifacts already staged under `/srv/backups/mini-craft-night-kit` may be reused after fresh hash/read-back verification.

Do not retransfer them merely because D-R1 returned.

## URL migration scope correction

D-R1 established that WP-CLI is absent from the accepted WordPress image.

To avoid mixing a new migration-tool acquisition with runtime deployment, D-R2 does **not** perform the full serialized-data-safe search/replace.

D-R2 may only update the scalar WordPress `home` and `siteurl` option values after DB restore to:

`https://minicraft.spikersun.com`

using a database-aware exact update that touches only those two scalar option rows.

It must **not** perform broad SQL string replacement.

The full serialized-data-safe origin migration remains mandatory before public ingress and will be a separate Reviewer Gate after private runtime health is accepted.

```text
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
PUBLIC_INGRESS_BEFORE_FULL_SERIALIZED_MIGRATION=FORBIDDEN
```

## Current Gate

```text
CURRENT_GATE=K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE
OWNER_ACTION=NONE
```

## D-R2 objective

Using the exact accepted `C52...` Compose source as the only base:

1. verify source SHA exactly matches `C52...`;
2. mechanically replace only the two image references with the already accepted immutable digest refs;
3. prove normalized semantic diff contains image-reference changes only;
4. render/validate explicit resolved Compose;
5. fresh target prewrite read-back;
6. reuse the verified staged K5 recovery artifacts;
7. create only Mini Craft project-local app/mysql/wp-content paths;
8. preserve Secret tree unchanged;
9. start digest-pinned MariaDB + WordPress privately;
10. restore accepted DB + wp-content;
11. update only `home` and `siteurl` scalar options;
12. validate private/internal WordPress, DB, WooCommerce and Sandbox state;
13. stop before full serialized migration/public ingress.

## Required result

Success:

```text
PASS_CANDIDATE_K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE
CANONICAL_SOURCE_SHA=C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B
STALE_03DC_RECORD_IGNORED=YES
DIGEST_PINNED_COMPOSE_SEAL=PASS
PRIVATE_RUNTIME_RESTORE=PASS
HOME_SITEURL_SCALAR_UPDATE=PASS
FULL_SERIALIZED_URL_MIGRATION=DEFERRED
PUBLIC_INGRESS_CHANGE=0
PAYPAL_LIVE=NO
REAL_PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*`.

A PASS_CANDIDATE does not authorize serialized migration, Shared Ingress or public HTTPS.
