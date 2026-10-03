# M2E-R3 — Owner Authorized Shared Caddy Recreate

## Gate

```text
GATE=M2E_R3_SHARED_CADDY_RECREATE
OWNER_AUTHORIZATION=YES
NORMAL_ACCESS_PATH=CANONICAL_STRICT_SSH
STOP_AT_REVIEWER=YES
```

## Read first

Read completely:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R2_PASS_OWNER_CADDY_RECREATE_CHECKPOINT.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_R3_OWNER_AUTHORIZED_CADDY_RECREATE.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use canonical strict SSH as `ops@srv1970241`. Use bounded `sudo docker ...` / `sudo docker compose ...` only as authorized.

## Phase A — fresh pre-write seal

Freshly prove the exact accepted target/Compose/runtime/config baseline. Do not rely only on M2E-R2 carried-forward values.

Require all of the following to match exactly:

```text
TARGET_HOST=srv1970241
REMOTE_USER=ops

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

Recheck:

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

If any material drift is found:

```text
RETURN_M2E_R3_PREWRITE_DRIFT
CADDY_RECREATES=0
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase B — execute the one authorized transaction

Execute exactly once:

```sh
sudo -n docker compose --project-name spikersun-edge --project-directory /srv/infra/edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never --no-build caddy
```

No alternate recreate/restart/reload command is authorized.

Record native exit.

## Phase C — fresh post-write readback

Prove actual target-host state, including:

```text
POST_CADDY_STATE=running
POST_CADDY_IMAGE_ID=<must equal accepted immutable image ID>
POST_CADDY_RESTART_POLICY=unless-stopped
POST_CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
POST_CADDY_NETWORKS=spikersun-edge
POST_CADDY_MOUNTS=<exact accepted 3 binds>

POST_CONTAINER_CADDYFILE_BYTES=143
POST_CONTAINER_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
POST_CONTAINER_MINICRAFT_MATCHER=ABSENT

POST_CADDY_CONFIG_VALID=PASS
CADDY_DATA_BIND_PRESENT=YES
CADDY_CONFIG_BIND_PRESENT=YES
```

Do not infer success from recreate exit alone.

## Phase D — regression

Freshly verify:

- Caddy-served direct-origin edge-test HTTP/TLS/body fingerprint;
- Mini Craft Home / Shop / WP REST HTTP 200 with normal TLS;
- no Mini Craft route is reintroduced into Caddy startup config;
- no unrelated Compose service/container was recreated or changed;
- no Cloudflare/DNS/Tunnel/application/database/payment mutation occurred.

Do not add unrelated health checks or mutation scope.

## Ambiguous outcome rule

No blind retry.

If the recreate command is non-zero or any state is ambiguous:

```text
RETURN_M2E_R3_RECREATE_OUTCOME_AMBIGUOUS
```

Then perform read-only reconciliation only and return the actual state to Reviewer.

## Hard boundaries

```text
CADDY_RECREATE_MAX_COUNT=1
CADDYFILE_WRITES=0
CADDY_RELOADS=0
CADDY_RESTARTS=0
OTHER_SERVICE_RECREATES=0
PULLS=0
BUILDS=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
APPLICATION_MUTATIONS=0
DATABASE_MUTATIONS=0
PAYMENT_ACTIONS=0
BROAD_PRUNE=NO
```

## Evidence

Append one bounded M2E-R3 section to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read GitHub after each persistence write.

## Success return

```text
PASS_CANDIDATE_M2E_R3_SHARED_CADDY_RECREATE
CADDY_RECREATE_COUNT=1
RECREATE_NATIVE_EXIT=0
M2E_RESTART_PERSISTENCE=PASS
LEGACY_MINICRAFT_CADDY_ROUTE_REINTRODUCTION_RISK=RESOLVED
OTHER_SERVICE_RECREATES=0
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
APPLICATION_MUTATIONS=0
DATABASE_MUTATIONS=0
PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
```
