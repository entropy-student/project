# K6 Phase G-R4 — Shared Caddy Service Recreate + Public Sandbox Activation

Gate:
K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE_AND_PUBLIC_SANDBOX_ACTIVATION

Owner authorization:
AUTHORIZE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE

Read current:
- REVIEWER_HANDOFF.md
- PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K6_G_R4_SHARED_CADDY_RECREATE_AUTHORIZED.md
- prior G-R3R2R2 PASS evidence/handoff
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- Shared VPS Handoff
- canonical VPS Governance latest

## Transaction

1. Cloudflare session + exact Mini Craft DNS absence.
2. Fresh strict SSH/runtime/PPCP safety.
3. Persist exact 153-byte mounted legacy Caddyfile as rollback artifact.
4. Verify exact 199-byte target candidate + Compose SHA.
5. Atomically replace host Caddyfile with target candidate.
6. Validate host target.
7. Recreate only Caddy once with sealed command.
8. Verify new mount hash, old routes, Mini Craft route, cert persistence, unrelated containers unchanged.
9. Confirm blog_public=0.
10. Recheck Cloudflare session + exact DNS absence.
11. Create exactly one DNS-only Mini Craft A.
12. Public Sandbox validation.
13. Evidence/Handoff.
14. STOP_AT_REVIEWER.

## Exact recreate

sudo -n docker compose -p spikersun-edge -f /srv/infra/edge/compose.yaml up -d --no-deps --force-recreate --pull never caddy

No blind retry.

## Rollback

Before DNS:
legacy backup -> host Caddyfile -> validate -> recreate only Caddy -> prove legacy routes restored.

After DNS:
delete exact Mini Craft A -> prove absent -> legacy backup -> host Caddyfile -> recreate only Caddy -> prove legacy routes restored.

## Success

PASS_CANDIDATE_K6_PHASE_G_R4_SHARED_CADDY_SERVICE_RECREATE_AND_PUBLIC_SANDBOX_ACTIVATION
STOP_AT_REVIEWER=YES

Return every success marker required by the Reviewer Decision.

## Forbidden

No Compose/network/daemon/cloudflared/UFW mutation, unrelated container recreate, Secret output, PayPal Live, real/Sandbox buyer payment, order/auth/capture/refund, Soft Launch, or unrelated Shared Infra mutation.
