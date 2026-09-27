# Reviewer Decision — K6 G-R3R2R2 PASS / G-R4 Shared Caddy Recreate Owner Checkpoint

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

GATE=K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL
RESULT=PASS_CANDIDATE_K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL
EVIDENCE_COMMIT=a282fb763c27e695abe8ebf61db5d6ccb4f86b1b
HANDOFF_COMMIT=abac19d66c5cd2ec846042bce5106e5195113868

Reviewer decision:

K6_PHASE_G_R3R2R2_READONLY_REMAINDER_AND_RECREATE_PLAN_SEAL=PASS

## Accepted infrastructure facts

STALE_SINGLE_FILE_BIND_MOUNT=CONFIRMED

Host current Caddyfile:
- bytes=76
- SHA256=12fac82e3b1b9733029aa820c4794ccb9359ae494863dd6815f7e29b636d8beb

Running container mounted Caddyfile:
- bytes=153
- SHA256=126292f6bc2a77929539704a84c5d7a4ab3364ec39364a14abafda176b631837

The 153-byte mounted legacy config:
- adapts successfully;
- is semantically equivalent to fresh active Admin config;
- contains the complete current active user-route inventory:
  - edge-test.spikersun.com
  - localhost

The sealed 199-byte Mini Craft target candidate:
- SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
- preserves all unrelated active routes;
- adds only Mini Craft.

## Shared Caddy Compose facts

CADDY_COMPOSE_SHA256=22abbe0b6eee42edee068605b19a4c7168284446bbf723715ff3a27c360cfef5
CADDY_COMPOSE_PROJECT=spikersun-edge
CADDY_SERVICE_NAME=caddy
CADDY_IMAGE=caddy:2-alpine
CADDY_PUBLISHED_PORTS=80/tcp,443/tcp
CADDY_NETWORKS=spikersun-edge

Persistent state:
- /srv/infra/edge/data -> /data RW
- /srv/infra/edge/config -> /config RW
- CADDY_CERT_STATE_PERSISTENCE=PASS
- CADDY_CONFIG_STATE_PERSISTENCE=NOT_REQUIRED_BY_STARTUP_PATH

Caddy startup:
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

A Caddy-only recreate does not require:
- Compose-file mutation;
- network recreation;
- Docker-daemon configuration mutation;
- unrelated container recreation.

Sealed exact recreate command:

sudo -n docker compose -p spikersun-edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never caddy

## Why new Owner authorization is required

The prior Phase G authorization explicitly prohibited Caddy restart/recreate.

The safe fix for the stale single-file bind mount requires replacing only the Caddy container so the new container obtains a fresh bind mount to the current host pathname.

This is a Shared Infrastructure mutation.

It will briefly interrupt the shared Caddy listener on ports 80/443.

Current active user-route impact:
- edge-test.spikersun.com: brief interruption possible;
- localhost: local-only route, brief interruption possible during container replacement.

Mini Craft public DNS does not yet exist, so Mini Craft public traffic is not yet exposed.

## Proposed G-R4 transaction after Owner authorization

1. Fresh Cloudflare Dashboard session and exact Mini Craft DNS absence.
2. Fresh strict SSH/runtime/PPCP safety reconciliation.
3. Persist the exact accepted 153-byte legacy rollback Caddyfile under the Mini Craft project backup namespace.
4. Verify the 199-byte target candidate and Compose source hash.
5. Atomically set host /srv/infra/edge/Caddyfile to the sealed 199-byte target.
6. Validate host target.
7. Recreate only the Caddy service using the sealed command.
8. Prove the new container-mounted /etc/caddy/Caddyfile equals the target hash.
9. Prove:
   - edge-test exact behavior preserved;
   - localhost preserved;
   - Mini Craft private route active;
   - no unrelated route lost;
   - certificate state healthy;
   - no unrelated container recreated.
10. Confirm blog_public=0.
11. Fresh Cloudflare session + exact DNS absence.
12. Create exactly one DNS-only A:
    minicraft.spikersun.com -> 2.24.193.133
13. Public Sandbox validation.
14. Stop at Reviewer.

## Rollback

### Failure before DNS

1. Restore exact sealed 153-byte legacy rollback Caddyfile to host.
2. Recreate only Caddy service.
3. Prove legacy routes restored.
4. DNS remains absent.

### Failure after DNS

1. Delete only the exact Mini Craft A record.
2. Verify Mini Craft A/AAAA/CNAME absent.
3. Restore exact sealed 153-byte legacy Caddyfile to host.
4. Recreate only Caddy service.
5. Prove legacy routes restored.

No blind retry after ambiguous recreate/DNS result.

## Still forbidden

Even after this Owner authorization:
- Compose file mutation;
- Docker network/daemon configuration mutation;
- unrelated container recreate;
- cloudflared/UFW mutation;
- PayPal Live;
- real payment/order/authorization/capture/refund;
- Sandbox buyer transaction;
- Soft Launch/advertising;
- Secret/credential output;
- unrelated Shared Infra mutation.

## Current Gate

CURRENT_GATE=K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=AWAIT_OWNER
OWNER_ACTION=AUTHORIZE_OR_DECLINE_SHARED_CADDY_RECREATE

## Exact authorization marker

To authorize the sealed transaction, Owner must send exactly:

AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE

This authorizes:
- exact Caddy service-only recreate;
- the already-reviewed target Caddyfile write;
- the already-reviewed exact Mini Craft DNS-only A creation after route validation;
- bounded public Sandbox validation;
- the sealed rollback sequence if needed.

It does not authorize any forbidden action listed above.
