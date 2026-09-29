# Reviewer Decision — M2A-R1 Reconciled / M2A Reauthorized

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## New read-only evidence

Owner relayed a fresh Hostinger Web Terminal readback:

```text
TARGET_HOST=srv1970241
CURRENT_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
EXPECTED_HISTORICAL_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
CURRENT_COMPOSE_BYTES=4966
CURRENT_COMPOSE_MTIME=2026-09-26 05:32:19.703025640 +0000
CURRENT_COMPOSE_OWNER_GROUP=root:root
CURRENT_COMPOSE_MODE=0644
MUTATIONS=0
```

The Hostinger session expired before the remaining semantic/backups read-only checks completed.

## Reconciliation

The prior M2A prewrite `PREWRITE_COMPOSE_HASH_MATCH=NO` did not record the observed hash and is not reproducible.

The current exact file hash matches the accepted historical K6 resolved Compose hash byte-for-byte, and the file mtime predates the current M2A sequence. During the intervening M2A/M2A-R1 attempts, all accepted execution records report zero Compose/VPS/Docker writes.

Immediately before the anomalous hash comparison, the fresh M2A preflight also reported the expected runtime topology:

```text
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_NETWORKS=mini-craft-night-kit-database
TARGET_ALIAS_COLLISIONS=0
PUBLIC_HOME=200
PUBLIC_SHOP=200
PUBLIC_WP_REST=200
```

Historical accepted K6 Evidence binds the same exact Compose hash to the expected semantic structure: WordPress + MariaDB services, no host ports, project DB network internal, shared edge external.

Therefore the current evidence does not support real Compose drift. The earlier mismatch is classified as an unretained/non-reproducible comparison anomaly, not as proven file mutation.

```text
M2A_R1_COMPOSE_BASELINE_RECONCILIATION=PASS
CURRENT_COMPOSE_SOURCE_IDENTITY=PASS_EXACT_HISTORICAL_HASH
CURRENT_COMPOSE_DRIFT=NO_PROVEN_DRIFT
PRIOR_HASH_MISMATCH=NONREPRODUCIBLE_COMPARISON_ANOMALY
COMPOSE_DRIFT_CLASS=BYTE_ONLY_NONSEMANTIC_NOT_APPLICABLE_EXACT_HASH_MATCH
```

## M2A reauthorization

M2A may resume under the existing M2A packet.

Before the first write, perform one compact fresh prewrite and print/store the actual observed SHA string, not only a boolean comparison.

Required:

```text
OBSERVED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
TARGET_HOST=srv1970241
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_NETWORKS=mini-craft-night-kit-database
TARGET_ALIAS_COLLISIONS=0
```

If any differs, stop before write with `RETURN_PREFLIGHT_DRIFT`.

If they match, continue the previously sealed M2A sequence:

1. backup exact current Compose;
2. edit only the canonical Compose;
3. add existing external `spikersun-private` to WordPress only;
4. assign alias `mini-craft-night-kit-wordpress`;
5. keep MariaDB isolated;
6. render/validate;
7. recreate only WordPress, no pull/build/dependency recreate;
8. verify private origin reachability and existing Caddy public path.

No M2B action is authorized.
