# Reviewer Decision — M2E-R3 Owner Authorized Shared Caddy Recreate

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly approved the exact bounded Shared Caddy recreate transaction presented after M2E-R2 PASS.

```text
OWNER_EXPLICITLY_AUTHORIZES_M2E_R3_CADDY_RECREATE=YES
```

This authorization is limited to one bounded recreate of the existing Shared Caddy service after all sealed pre-write invariants are freshly re-proven.

## Current Gate

```text
CURRENT_GATE=M2E_R3_SHARED_CADDY_RECREATE
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_SHARED_INFRA_WRITE

CADDY_RECREATE_AUTHORIZED=YES_ONE_BOUNDED_TRANSACTION
CADDY_RESTART_AUTHORIZED=NO
CADDY_RELOAD_AUTHORIZED=NO_SEPARATE_ACTION
CADDYFILE_WRITE_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
APPLICATION_MUTATION_AUTHORIZED=NO
DATABASE_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
```

## Sealed transaction

Only this recreate transaction is authorized:

```sh
sudo -n docker compose --project-name spikersun-edge --project-directory /srv/infra/edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never --no-build caddy
```

The command may be executed exactly once, only after all mandatory pre-write checks below pass.

## Mandatory pre-write invariants

Freshly require:

```text
TARGET_HOST=srv1970241
REMOTE_USER=ops
ACCESS_PATH=CANONICAL_STRICT_SSH

CADDY_COMPOSE_PROJECT=spikersun-edge
CADDY_COMPOSE_SERVICE=caddy
CADDY_CANONICAL_COMPOSE_PATH=/srv/infra/edge/compose.yaml
CANONICAL_COMPOSE_QUIET_VALIDATION=PASS
CANONICAL_COMPOSE_SERVICES=caddy

HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_MINICRAFT_MATCHER=ABSENT
PRE_RECREATE_CADDY_CONFIG_VALID=PASS

CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
LOCAL_IMAGE_TAG_ID_MATCH=PASS

CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge
CADDY_RESTART_POLICY=unless-stopped
CADDYFILE_BIND=/srv/infra/edge/Caddyfile->/etc/caddy/Caddyfile:RO
CADDY_DATA_BIND=/srv/infra/edge/data->/data:RW
CADDY_CONFIG_BIND=/srv/infra/edge/config->/config:RW
```

Also require the pre-write public regression baseline to remain materially healthy:

```text
MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY_RESULT=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY_RESULT=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_HTTP=200
EDGE_TEST_DIRECT_ORIGIN_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
```

If any material invariant differs, do not execute the recreate. Return a precise prewrite drift result.

## Authorized write

If and only if all pre-write invariants match, execute exactly one recreate transaction.

Required scope:

```text
RECREATE_SCOPE=CADDY_ONLY
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
OTHER_SERVICE_RECREATE=NO
CADDYFILE_EDIT=NO
CLOUDFLARE_MUTATION=NO
DNS_MUTATION=NO
TUNNEL_ROUTE_MUTATION=NO
APPLICATION_MUTATION=NO
DATABASE_MUTATION=NO
PAYMENT_ACTION=NO
```

## Mandatory post-write proof

After the recreate, fresh-read and prove:

1. native recreate exit = 0;
2. Caddy service/container is running;
3. current running immutable image ID equals the accepted image ID;
4. restart policy remains `unless-stopped`;
5. published ports remain 80/443;
6. network remains `spikersun-edge`;
7. exactly the three accepted bind mounts remain;
8. container-mounted `/etc/caddy/Caddyfile` now equals the current 143-byte host Caddyfile and accepted SHA-256;
9. Mini Craft matcher is absent from the mounted startup config;
10. current Caddy config validates and active service remains healthy;
11. Caddy-served regression route passes;
12. Mini Craft Home / Shop / WP REST / TLS remain healthy via the Tunnel;
13. `/data` and `/config` persistence remain present;
14. no unrelated container/service was recreated or changed;
15. Cloudflare/DNS/Tunnel/application/database/payment mutations remain zero.

## Failure / ambiguous outcome

No blind second recreate.

If native command result is non-zero, SSH disconnects, container identity is ambiguous, or post-write state is incomplete:

1. stop further mutations;
2. fresh-read actual container/service state;
3. determine whether the recreate committed;
4. preserve the current 143-byte host Caddyfile;
5. do not restore the stale 199-byte Mini Craft matcher;
6. do not change Cloudflare/DNS/Tunnel;
7. return a precise recovery classification to Reviewer.

## Success result

```text
PASS_CANDIDATE_M2E_R3_SHARED_CADDY_RECREATE
M2E_RESTART_PERSISTENCE=PASS
LEGACY_MINICRAFT_CADDY_ROUTE_REINTRODUCTION_RISK=RESOLVED
M2E_FORMAL_PASS=PENDING_REVIEWER
STOP_AT_REVIEWER=YES
```

M2E is not formally closed until Reviewer independently accepts the post-write Evidence.
