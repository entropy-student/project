# Reviewer Decision — M2A-R2 Hash Baseline Correction / Execution Resume

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Reviewed RETURN

```text
RESULT=RETURN_PREFLIGHT_DRIFT
OBSERVED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
PREVIOUS_EXPECTED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf31786f1dded2110e8
COMPOSE_FILE_MODIFICATION=0
WORDPRESS_RECREATE=0
DOCKER_NETWORK_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Reviewer correction

The prior Reviewer baseline string was malformed:

- observed value length: 64 hexadecimal characters;
- previous expected value length: 65 hexadecimal characters.

A SHA-256 digest is exactly 64 hexadecimal characters. Therefore the previous expected string was not a valid SHA-256 value and could never match a correct `sha256sum` output.

The repeated preflight mismatch is therefore attributed to a **Reviewer baseline transcription/normalization error**, not to proven Compose drift.

```text
PREVIOUS_EXPECTED_HASH_VALID_SHA256=NO
PREVIOUS_PREFLIGHT_FAILURE_CAUSE=INVALID_REVIEWER_HASH_BASELINE
CURRENT_COMPOSE_DRIFT=NO_PROVEN_DRIFT
```

## Current pre-M2A source seal

Fresh Hostinger Web Terminal readback established:

```text
TARGET_HOST=srv1970241
CURRENT_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
CURRENT_COMPOSE_BYTES=4966
CURRENT_COMPOSE_OWNER_GROUP=root:root
CURRENT_COMPOSE_MODE=0644
CURRENT_COMPOSE_MTIME=2026-09-26 05:32:19.703025640 +0000
```

The file mtime predates the M2A sequence. Accepted M2A/M2A-R1 execution records report zero Compose/runtime/network mutations. Fresh preflight also repeatedly observed the expected runtime topology:

```text
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_NETWORKS=mini-craft-night-kit-database
TARGET_ALIAS_COLLISIONS=0
PUBLIC_HOME=200
PUBLIC_SHOP=200
PUBLIC_WP_REST=200
```

The valid 64-character digest below is now the Reviewer-sealed pre-M2A source identity:

```text
SEALED_PRE_M2A_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
```

The malformed 65-character value is superseded and must not be used again.

## Early backup deviation reconciliation

Before stopping, Executor created:

`/srv/backups/mini-craft-night-kit/manifests/m2a-pre-private-network-20260929T111649Z.compose.bak`

Fresh read-only verification reported:

```text
BACKUP_BYTES=4966
BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
BACKUP_MATCHES_CURRENT_COMPOSE=YES
```

This is the same project-scoped pre-change backup M2A required before edit. It did not change runtime, Compose source, Docker networks, Caddy, Cloudflare, DNS, DB, payment or other projects.

Classification:

```text
EARLY_BACKUP_CREATION=RECORDED_NONCOMPROMISING_EXECUTION_DEVIATION
BACKUP_REUSE_FOR_M2A=AUTHORIZED_AFTER_FRESH_HASH_READBACK
DELETE_BACKUP_NOW=NO
```

Do not create another backup unless the existing backup fails fresh metadata/hash verification.

## M2A reauthorization

M2A is reauthorized under the existing execution packet.

Immediately before the first source edit, require:

```text
TARGET_HOST=srv1970241
OBSERVED_COMPOSE_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
EXISTING_BACKUP_SHA256=85abaeaae1c75d775937ea2ddd7395e39f364044cc03dcf317861fdded2110e8
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge
MARIADB_NETWORKS=mini-craft-night-kit-database
TARGET_ALIAS_COLLISIONS=0
```

If any differs, return `RETURN_PREFLIGHT_DRIFT` before edit.

If all match:

1. reuse the existing verified backup;
2. edit only `/srv/apps/mini-craft-night-kit/compose.production.yaml`;
3. declare existing external `spikersun-private`;
4. attach WordPress only;
5. assign alias `mini-craft-night-kit-wordpress`;
6. preserve project DB network and `spikersun-edge`;
7. keep MariaDB off `spikersun-private`;
8. render/validate the explicit Compose file;
9. recreate only WordPress, no pull/build/dependency recreation;
10. verify private-origin reachability and the unchanged public Caddy path.

No M2B action is authorized.

## Still forbidden

No Cloudflare/DNS/Tunnel/Caddy/cloudflared change, shared-network create/delete/recreate, MariaDB mutation, payment/provider action, cleanup/prune, or unrelated-project mutation.

## Success boundary

```text
PASS_CANDIDATE_M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
STOP_AT_REVIEWER=YES
```
