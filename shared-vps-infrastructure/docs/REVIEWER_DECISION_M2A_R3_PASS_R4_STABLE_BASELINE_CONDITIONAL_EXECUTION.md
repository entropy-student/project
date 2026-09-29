# Reviewer Decision — M2A-R3 PASS / R4 Stable Baseline + Conditional M2A Execution

Date: 2026-09-29  
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `4e9ece3d65445f64d6b994547ab9c77d4555271d`
- Executor Handoff commit `181359ab7be5450ca60f8a4265bec29b3b361b15`

R3 is accepted as a correct read-only reconciliation result.

## Formal R3 result

```text
M2A_R3_RUNTIME_NETWORK_MEMBERSHIP_RECONCILIATION=PASS
RUNTIME_NETWORK_DRIFT_CLASS=UNRESOLVED
MUTATIONS=0
```

Accepted facts:

```text
COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
COMPOSE_PRIVATE_NETWORK_DECLARATION=ABSENT

FINAL_WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
FINAL_WORDPRESS_PRIVATE_ENDPOINT=ABSENT
TARGET_ALIAS_PRESENT=NO

MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_HEALTH=HEALTHY

PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
```

One earlier `docker inspect` in the same read-only session showed a contradictory transient private endpoint with only the default aliases. Later network inspection and repeated final container/network readbacks consistently showed that endpoint absent. Retained Docker events did not establish provenance.

The contradiction remains unexplained; Reviewer does not assign a cause.

## Risk ruling

Because:

1. the final repeated runtime state matches the sealed Compose topology;
2. the WordPress container ID, creation time and restart count remained stable;
3. MariaDB remained isolated and healthy;
4. the Compose source remained on the exact sealed hash;
5. no Docker/Compose/network mutation was performed in R3;

the unresolved earlier observation does not by itself require abandoning M2A. However, M2A may proceed only after one stronger same-session stability qualification immediately before write.

## Current Gate

```text
CURRENT_GATE=M2A_R4_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
CURRENT_GATE_STATUS=CONDITIONAL_BOUNDED_WRITE
```

## R4 prewrite stability requirement

In one Hostinger Web Terminal session, before any source edit:

- prove `TARGET_HOST=srv1970241`;
- record exact WordPress container ID;
- perform two independent container-network readbacks separated by a short bounded interval;
- perform two independent `spikersun-private` endpoint readbacks;
- require the same WordPress container ID across both reads;
- require WordPress to be on exactly:
  `mini-craft-night-kit-database + spikersun-edge`;
- require WordPress absent from `spikersun-private` in both container and network views;
- require target alias collision count 0;
- require MariaDB only on project DB network and healthy;
- require current Compose and existing backup both hash to:
  `85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8`.

If any view conflicts again, stop before write:

```text
RETURN_RUNTIME_READBACK_UNSTABLE
STOP_AT_REVIEWER=YES
```

## Compose invocation reconciliation

The previous `docker compose config --quiet` failure occurred because required deployment variables were not available in that invocation.

R4 must use the canonical project working directory and the existing deployment environment resolution used by the running Compose project. It may inspect only file existence/metadata and environment variable **names**, never values.

Before edit, require that the unmodified canonical Compose validates successfully without outputting resolved Secret/environment values.

If the canonical deployment environment source cannot be safely resolved:

```text
RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Conditional M2A execution

Only if the stability and Compose validation preflight pass:

1. reuse the already verified pre-change backup;
2. edit only `/srv/apps/mini-craft-night-kit/compose.production.yaml`;
3. declare existing external `spikersun-private`;
4. attach WordPress only;
5. add unique alias `mini-craft-night-kit-wordpress`;
6. preserve `spikersun-edge` and project DB network;
7. keep MariaDB off `spikersun-private`;
8. validate rendered Compose using the same canonical deployment environment resolution;
9. recreate only WordPress, no pull/build/dependency recreation;
10. verify target alias and private endpoint from both container and network views;
11. verify MariaDB isolation and health;
12. verify private-origin HTTP behavior using a bounded probe with no Secret access;
13. verify public Home/Shop/REST remain healthy on the existing Caddy path.

No M2B action is authorized.

## Forbidden

No Cloudflare/DNS/Tunnel/Caddy/cloudflared mutation, shared-network create/delete/recreate, MariaDB mutation, payment/provider action, cleanup/prune, unrelated-project mutation, or SSH retry.

## Success

```text
PASS_CANDIDATE_M2A_R4_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
WORDPRESS_PRIVATE_NETWORK_READY=PASS
PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_ISOLATION=PASS
CURRENT_CADDY_PUBLIC_PATH_REGRESSION=PASS
MUTATIONS=BOUNDED_M2A_ONLY
STOP_AT_REVIEWER=YES
```
