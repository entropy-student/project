# Reviewer Decision — M2E-R2 PASS / Owner Caddy Recreate Checkpoint

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Executor result: `PASS_CANDIDATE_M2E_R2_CADDY_RECREATE_PREFLIGHT`
- Evidence commit: `55b7eefd5bf3bce898152904c4921cb92b89396b`
- Executor Handoff commit: `7053d1559535d21297397e47dedf345b9a6796b4`
- Current Shared VPS Handoff / Reviewer Handoff
- M2E-R1 accepted stale single-file bind-mount baseline
- M2E-R2 preflight contract

The two non-zero SSH command results in M2E-R2 are accepted as read-only command-construction errors, not target-host mutation failures:
- first probe requested absent optional Docker health metadata and exited before a complete collection;
- third probe failed in a supplemental parser invocation after read-only validation;
- subsequent bounded reads independently completed the required facts;
- no runtime write, recreate, restart, reload, Compose mutation, Cloudflare mutation, DNS mutation, Tunnel mutation or payment action occurred.

The Evidence and Executor Handoff commits each change only their intended project-governance record and were freshly persisted.

## Formal result

```text
M2E_R2_CADDY_RECREATE_PREFLIGHT=PASS
M2E_RESTART_PERSISTENCE=FAIL_NEEDS_RECREATE
M2E_FORMAL_PASS=NO

CURRENT_GATE=M2E_R3_OWNER_CADDY_RECREATE_CHECKPOINT
CURRENT_GATE_STATUS=WAITING_FOR_EXPLICIT_OWNER_AUTHORIZATION

CADDY_RECREATE_AUTHORIZED=NO
CADDY_RESTART_AUTHORIZED=NO
CADDY_RELOAD_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
COMPOSE_MUTATION_AUTHORIZED=NO
```

## Accepted preflight baseline

```text
TARGET_HOST=srv1970241
REMOTE_USER=ops
ACCESS_PATH=CANONICAL_STRICT_SSH

CADDY_CONTAINER_ID=793a5c8fbcd86d3c2b6dc0ba5a47e51de9d372957210efa0912523b8c1e7b9a2
CADDY_CONTAINER_NAME=/spikersun-edge-caddy-1
CADDY_STATE=running
CADDY_RESTART_COUNT=0

CADDY_COMPOSE_PROJECT=spikersun-edge
CADDY_COMPOSE_SERVICE=caddy
CADDY_COMPOSE_WORKING_DIR=/srv/infra/edge
CADDY_CANONICAL_COMPOSE_PATH=/srv/infra/edge/compose.yaml
CANONICAL_COMPOSE_QUIET_VALIDATION=PASS
CANONICAL_COMPOSE_SERVICES=caddy

CADDY_IMAGE_REFERENCE=caddy:2-alpine
CADDY_IMAGE_ID=sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648
LOCAL_IMAGE_TAG_ID_MATCH=PASS

CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge
CADDY_RESTART_POLICY=unless-stopped

CADDYFILE_BIND=/srv/infra/edge/Caddyfile->/etc/caddy/Caddyfile:RO
CADDY_DATA_BIND=/srv/infra/edge/data->/data:RW
CADDY_CONFIG_BIND=/srv/infra/edge/config->/config:RW

HOST_CADDYFILE_BYTES=143
HOST_CADDYFILE_SHA256=f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358
HOST_CADDYFILE_MINICRAFT_MATCHER=ABSENT
PRE_RECREATE_CADDY_CONFIG_VALID=PASS
```

The Compose definition contains only the `caddy` service and no service dependencies. The running container semantics match the canonical definition for image, ports, network, mounts and restart policy. The `/data` and `/config` persistence paths are host bind directories and therefore survive a Caddy-container recreate.

## Regression baseline

Accepted pre-write regression baseline:

```text
MINICRAFT_HOME_HTTP=200
MINICRAFT_HOME_TLS_VERIFY_RESULT=0
MINICRAFT_SHOP_HTTP=200
MINICRAFT_SHOP_TLS_VERIFY_RESULT=0
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_WP_REST_TLS_VERIFY_RESULT=0

EDGE_TEST_PUBLIC_DNS=ABSENT_OR_UNRESOLVED
EDGE_TEST_DIRECT_ORIGIN_HTTP=200
EDGE_TEST_DIRECT_ORIGIN_TLS_VERIFY_RESULT=0
EDGE_TEST_DIRECT_ORIGIN_BODY_BYTES=30
EDGE_TEST_DIRECT_ORIGIN_BODY_SHA256=2a1fbeab0fdc9199b590f3b2b5ebf216271f2f7918df7fbe6a3a0e7587b9a824
```

The unresolved public DNS name for edge-test is not treated as a public-DNS PASS and is not a blocker for this persistence repair. Its Caddy route was validated directly against the origin with TLS verification preserved. The localhost route was validated from the host config; no fresh Admin API claim is accepted for M2E-R2.

## Exact proposed Shared Infrastructure transaction

The following command is sealed as the only intended recreate transaction for the next write Gate:

```sh
sudo -n docker compose --project-name spikersun-edge --project-directory /srv/infra/edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never --no-build caddy
```

Required scope:

```text
RECREATE_SCOPE=CADDY_ONLY
PULL=NO
BUILD=NO
DEPENDENCY_RECREATE=NO
OTHER_SERVICE_RECREATE=NO
CLOUDFLARE_MUTATION=NO
DNS_MUTATION=NO
TUNNEL_ROUTE_MUTATION=NO
APPLICATION_OR_DATABASE_MUTATION=NO
PAYMENT_ACTION=NO
```

This command is **not authorized yet**.

## Mandatory fresh pre-write checks after Owner authorization

Immediately before the write, M2E-R3 must fresh-read and require all of the following to still match:

1. target host is `srv1970241`, user path is canonical strict SSH;
2. Caddy container/service identity remains the accepted Compose-managed service;
3. canonical Compose path remains `/srv/infra/edge/compose.yaml` and quiet validation passes;
4. host Caddyfile remains exactly 143 bytes with SHA-256 `f96a9bab9fa326125de311df9c8c0c6fca20e3d6deb5fcbe22a7c739e819c358`;
5. Mini Craft matcher remains absent from the host source;
6. local `caddy:2-alpine` tag still resolves to immutable image ID `sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648`;
7. port/network/mount semantics remain unchanged;
8. public regression baseline is not materially degraded before mutation.

Any material drift cancels the write authorization and returns to Reviewer.

## Post-write acceptance requirements

A future authorized M2E-R3 may PASS only after proving:

- recreate command native exit = 0;
- new/recreated Caddy container is running;
- running immutable image ID remains the accepted image ID;
- restart policy, ports, network and three bind mounts match;
- container-mounted `/etc/caddy/Caddyfile` now matches the 143-byte host file and accepted SHA-256;
- Mini Craft matcher is absent from the mounted startup Caddyfile;
- active Caddy config is healthy after recreate;
- Caddy-served route regression passes;
- Mini Craft Home / Shop / WP REST / TLS remain healthy independently through the Tunnel;
- Caddy data/config persistence remains present;
- no unrelated container/service was recreated;
- Cloudflare/DNS/Tunnel/application/database/payment mutation count remains zero.

## Failure rule

No blind second recreate.

If the recreate returns non-zero, connection drops, or final state is ambiguous:

1. stop further writes;
2. fresh-read container/service state;
3. classify whether the recreate committed;
4. preserve the current 143-byte host Caddyfile;
5. do not restore the stale 199-byte Mini Craft matcher;
6. do not change Cloudflare/DNS/Tunnel;
7. return a precise recovery classification to Reviewer.

## Owner checkpoint

Owner authorization is required because this is an explicit Shared Infrastructure mutation of the shared Caddy container that owns host ports 80/443.

The exact authorization requested is:

> Authorize one bounded recreate of only the existing Shared Caddy service using the sealed command above, after all mandatory fresh pre-write invariants still match. No pull, build, dependency/other-service recreate, Caddyfile edit, Cloudflare/DNS/Tunnel change, application/database change or payment action is authorized. Any drift or ambiguous outcome must stop and return to Reviewer.

Until the Owner explicitly authorizes that transaction:

```text
M2E_R3_EXECUTION_AUTHORIZED=NO
STOP_AT_OWNER_CHECKPOINT=YES
```
