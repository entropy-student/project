# Shared VPS Infrastructure — REVIEWER HANDOFF

## CURRENT REVIEWER UPDATE — M1 PASS / M2A Private Network Preparation Open — 2026-09-29

```text
M1_MINICRAFT_TUNNEL_ARCHITECTURE_CONFIRMATION=PASS
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP

TUNNEL=spikersun-shared-private
MINICRAFT_FUTURE_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MINICRAFT_FUTURE_ORIGIN=http://mini-craft-night-kit-wordpress:80
MARIADB_PRIVATE_NETWORK_ATTACHMENT=NO

CURRENT_GATE=M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_WRITE

CURRENT_PUBLIC_PATH=DNS_A_TO_CADDY
CURRENT_CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES

CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
SHARED_NETWORK_RECREATE_AUTHORIZED=NO
WORDPRESS_PROJECT_NETWORK_MEMBERSHIP_CHANGE=AUTHORIZED_EXACT
MARIADB_CHANGE_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

M1 is formally closed. Authenticated Cloudflare readback proved the existing Shared VPS pattern is direct Tunnel-to-app alias: Dujiao, Unified Pay and Xianyu all use direct origin services behind `spikersun-shared-private`.

M2A authorizes only project-local preparation required for the future Tunnel origin: attach WordPress to the existing `spikersun-private` network with unique alias `mini-craft-night-kit-wordpress`. The existing `spikersun-edge` membership and Caddy route remain unchanged, and MariaDB stays isolated.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_R4_PASS_M1_ARCHITECTURE_SEALED_M2A_AUTHORIZED.md`

Execution packet:
`review-packets/M2A_MINICRAFT_PRIVATE_NETWORK_PREPARATION.md`

## CURRENT REVIEWER UPDATE — M1-R3 RETURN Accepted / M1-R4 Cloudflare Read-only Checkpoint Open — 2026-09-29

```text
M1_R3_RESULT=RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
M1_R3_RETURN_ACCEPTED=YES

TARGET_HOST_EXECUTION_PROVEN=PASS
TARGET_ARCHITECTURE=UNRESOLVED

CURRENT_GATE=M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL
CURRENT_GATE_STATUS=OWNER_ACCOUNT_AUTH_CHECKPOINT_THEN_READONLY

OWNER_ACTION_REQUIRED=CLOUDFLARE_DASHBOARD_LOGIN_ONLY
CLOUDFLARE_MUTATION_AUTHORIZED=NO
VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
PROJECT_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

Accepted R3 host-side facts: Mini Craft WordPress is on its project database network plus `spikersun-edge`; MariaDB remains only on the project DB network; Mini Craft has no current alias on `spikersun-private`; generic `app` is already used by Dujiao and Unified Pay on `spikersun-private`; a future Mini Craft private-network alias must therefore be project-unique. cloudflared is running on `spikersun-private` with image `cloudflare/cloudflared:2026.8.3`, restart count 0, and no token/environment value read.

The only remaining blocker to sealing M1 is authenticated read-only Cloudflare control-plane evidence for the Dujiao public-hostname origin target and resulting Tunnel architecture. Owner login authorizes no DNS/Tunnel write.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_R3_RETURN_R4_CLOUDFLARE_READONLY_SESSION.md`

Execution packet:
`review-packets/M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL.md`

## CURRENT REVIEWER UPDATE — M1-R2 PASS / M1-R3 Architecture Completion Open — 2026-09-29

```text
M1_R2_OWNER_CONSOLE_CHECKPOINT=PASS

TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root

SSH_SERVICE_ACTIVE=YES
SSH_PORT22_LISTENING=YES
SSH_SERVER_SIDE_HEALTH=PASS
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE
SSH_DIRECT_PATH=INTERMITTENT_UNAVAILABLE
SSH_REPAIR_AUTHORIZED=NO
DIRECT_SSH_RETRY_AUTHORIZED=NO

CURRENT_GATE=M1_R3_MINICRAFT_TUNNEL_ARCHITECTURE_COMPLETION
CURRENT_GATE_STATUS=READONLY_RECONCILIATION

TARGET_ARCHITECTURE=UNRESOLVED
MINI_CRAFT_K9_REOPENED=NO

VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
PROJECT_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

Reviewer clarification: the accepted Hostinger provider-console checkpoint proves the target host even though the console user is root. The normal `ops@srv1970241` identity requirement belongs to the SSH connection contract; it is not a universal requirement for all target-host evidence.

Accepted fresh topology facts include Mini Craft WordPress on its project DB network plus `spikersun-edge`, MariaDB on the project DB network only, `spikersun-private` carrying Unified Pay/Dujiao/Xianyu/cloudflared, Mini Craft Compose source at `/srv/apps/mini-craft-night-kit/compose.production.yaml`, and restart count 0 for relevant containers.

M1-R3 finishes only the unresolved architecture facts, including exact aliases/Compose network feasibility and the remote-managed Cloudflare Tunnel public-hostname origin mapping. No SSH repair or ingress mutation occurs in R3.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_R2_PASS_R3_ARCHITECTURE_COMPLETION.md`

Execution packet:
`review-packets/M1_R3_MINICRAFT_TUNNEL_ARCHITECTURE_COMPLETION.md`

### Deferred SSH stability follow-up

```text
SSH_STABILITY_FOLLOWUP=DEFERRED_AFTER_MINICRAFT_INGRESS_MIGRATION
CURRENT_IMPACT=AUTOMATION_AND_REMOTE_MAINTENANCE_RELIABILITY_ONLY
CURRENT_WEBSITE_IMPACT=NONE_PROVEN
SSH_SERVER_SIDE_HEALTH=PASS
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE
SSH_REPAIR_AUTHORIZED=NO
```

The intermittent direct-SSH pre-identity closure is recorded for a separate bounded investigation after the Mini Craft ingress migration is stable. It must not be silently forgotten, but it does not block the current read-only M1 architecture completion. No SSH configuration change is authorized from this note.

## CURRENT REVIEWER UPDATE — M1-R1 RETURN Accepted / M1-R2 Owner Console Recovery Open — 2026-09-29

```text
M1_R1_RESULT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
M1_R1_RETURN_ACCEPTED=YES

SSH_CLIENT_TRUST_PREFLIGHT=PASS
SSH_NETWORK_INVOCATIONS=1
SSH_NATIVE_EXIT=255
REMOTE_IDENTITY=UNPROVEN
DIRECT_SSH_RETRY_AUTHORIZED=NO

CURRENT_GATE=M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY
CURRENT_GATE_STATUS=OWNER_LOCAL_READONLY_CHECKPOINT

TARGET_ARCHITECTURE=UNRESOLVED
MINI_CRAFT_K9_REOPENED=NO

VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
PROJECT_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

Independent GitHub review accepted M1-R1 as a correct fail-closed return. Local SSH trust metadata passed, but the sole strict SSH connection was closed before any remote identity output. Because this pre-identity failure has now repeated, blind direct-SSH retry is no longer authorized.

The next bounded recovery path is the already-authenticated Hostinger Web Terminal / provider console. Owner performs one prepared read-only command block. The checkpoint proves target identity, classifies fresh server-side SSH health, and collects safe M1 host-topology facts. It does not repair SSH and does not perform ingress migration.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_R1_RETURN_R2_OWNER_CONSOLE_READONLY_RECOVERY.md`

Execution packet:
`review-packets/M1_R2_OWNER_HOSTINGER_CONSOLE_READONLY_RECOVERY.md`

## CURRENT REVIEWER UPDATE — M1 RETURN Accepted / M1-R1 Target-host Recovery Open — 2026-09-29

```text
M1_RESULT=RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
M1_RETURN_ACCEPTED=YES
M1_RUNTIME_DRIFT_PROVEN=NO
M1_MUTATIONS=0

CURRENT_GATE=M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY

SHARED_VPS_HANDOFF=CREATED_CANONICAL_METADATA_PARTIAL
MINI_CRAFT_K9_REOPENED=NO
TARGET_ARCHITECTURE=UNRESOLVED_PENDING_M1_R1

VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
PROJECT_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

Independent GitHub review accepted the Executor's fail-closed M1 RETURN. The failure was execution-boundary only: no target-host command was sent and phases B-I were not started.

Governance gap repaired: canonical `SHARED_VPS_HANDOFF.md` now exists. Its exact SSH identity-file reference and expected host-key fingerprints remain pending promotion from the previously accepted Owner-workstation local bootstrap handoff. M1-R1 is authorized to recover that already-proven trust metadata, make one strict read-only SSH attempt, and if target identity passes continue original M1 B-I in the same bounded read-only evidence domain.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_RETURN_R1_TARGET_HOST_ACCESS_RECOVERY.md`

Execution packet:
`review-packets/M1_R1_TARGET_HOST_ACCESS_RECOVERY_AND_M1_RESUME.md`

## CURRENT REVIEWER UPDATE — Mini Craft Tunnel Architecture M1 Open — 2026-09-29

```text
CURRENT_GATE=M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY

AFFECTED_PROJECT=MINI_CRAFT_NIGHT_KIT
MINI_CRAFT_K9_REOPENED=NO

OWNER_DIRECTION=
1_SAFE_MINICRAFT_INGRESS_MIGRATION
2_THEN_VPS_CLEANUP_DECISIONS

TARGET_ARCHITECTURE=UNRESOLVED_PENDING_M1
CURRENT_MINICRAFT_INGRESS=DNS_A_TO_SHARED_CADDY
CANDIDATE_TARGET=EXISTING_CLOUDFLARE_TUNNEL_PATTERN

VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
PROJECT_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

This is a Shared Infrastructure review because the proposed migration concerns cloudflared/Tunnel routing, DNS, shared network membership and eventual retirement of the Mini Craft Caddy route.

M1 is evidence-only. It must determine whether the reusable target should be direct Tunnel-to-app, Tunnel-to-Caddy, another reviewed shape, or remain unresolved.

Reviewer decision:
`docs/REVIEWER_DECISION_M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION.md`

Execution packet:
`review-packets/M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION.md`

## CURRENT REVIEWER UPDATE — Documentation Consolidation R1 PASS — 2026-09-29

```text
SHARED_VPS_DOCUMENT_CONSOLIDATION_R1=PASS
EXECUTOR_COMMIT=cf353a45d7c6fc71fcbc80905376fe8596f3e0b7
REVIEWER_DECISION=docs/REVIEWER_DECISION_DOCUMENT_CONSOLIDATION_R1_PASS.md

VPS_HEALTH=PASS
DISK_PRESSURE=NO

XIANYU=ACTIVE_HEALTHY
DUJIAO_NEXT=ACTIVE_HEALTHY
UNIFIED_PAY=ACTIVE_HEALTHY_RUNTIME_WITH_LIFECYCLE_REVIEW
MINI_CRAFT_NIGHT_KIT=K9_CLOSED_RUNTIME_RETAINED

CURRENT_GATE=NONE_DOCUMENTATION_CONSOLIDATION_CLOSED
CLEANUP_AUTHORIZED=NO
VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
PROVIDER_MUTATION_AUTHORIZED=NO
```

Independent GitHub review verified the Executor documentation commit changed exactly 14 files (11 additions, 3 modifications), preserved historical material, created no competing `CURRENT_STATE.md`, corrected Unified Pay current deployment truth, and left Mini Craft K9 current handoff unchanged.

Future VPS work must open a new bounded Gate. Preferred order: Unified Pay lifecycle decision, bounded Xianyu hygiene where evidence is sufficient, then a final Shared VPS maintenance baseline.

## CURRENT REVIEWER UPDATE — Portfolio Reconciliation R1 Accepted — 2026-09-29

```text
HOST=srv1970241
VPS_HEALTH=PASS
DISK_PRESSURE=NO

ROOT_TOTAL≈96_GiB
ROOT_USED≈11_GiB
ROOT_AVAILABLE≈86_GiB

RUNNING_CONTAINERS=10
DOCKER_REPORTED_RECLAIMABLE=0

SHARED_INFRA=CADDY+CLOUDFLARED+SHARED_NETWORKS
SAFE_DELETE_NOW_COUNT=0
CLEANUP_AUTHORIZED=NO
```

### Current project portfolio

```text
XIANYU=ACTIVE_HEALTHY
DUJIAO_NEXT=ACTIVE_HEALTHY
UNIFIED_PAY=ACTIVE_HEALTHY_RUNTIME_WITH_LIFECYCLE_REVIEW
MINI_CRAFT_NIGHT_KIT=K9_CLOSED_RUNTIME_RETAINED
```

### Current ingress truth

```text
MINICRAFT_INGRESS_OWNER=CADDY_DIRECT
DUJIAO_INGRESS_OWNER=CLOUDFLARE_REMOTE_MANAGED_TUNNEL_LIKELY_UNVERIFIED
UNIFIED_PAY_INGRESS_OWNER=CLOUDFLARE_REMOTE_MANAGED_TUNNEL_LIKELY_UNVERIFIED
XIANYU_INGRESS_OWNER=UNKNOWN
```

`shop.spikersun.com` and `pay.spikersun.com` are publicly reachable but do not appear in the current Caddy hostname set. Their exact remotely-managed Cloudflare Tunnel route metadata was not read in R1.

### Current cleanup truth

```text
CONFIRMED_DELETE_CANDIDATE=
- xianyu_xianyu-network

RETENTION_REVIEW=
- Xianyu pre-X6 source
- two Xianyu X6 build temp trees
- Xianyu slider/debug logs
- eight Xianyu backup generations
- Dujiao recovery/history backup set
- Unified Pay recovery/history backup set

UNKNOWN=
- five anonymous Docker volumes
- Xianyu public ingress
- exact Cloudflare route bindings for shop/pay
- Dujiao payment-channel fresh state
- Dujiao -> Unified Pay runtime dependency
- Unified Pay provider fresh flags
- Unified Pay downstream callers
- Unified Pay DB business aggregate
```

No cleanup is authorized from this handoff.

### SSH current classification

```text
SSH_SERVER_SIDE_HEALTH=PASS
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE
LIKELY_DOMAIN=CLIENT_OR_NETWORK_PATH_TRANSIENT
```

Hostinger Browser Terminal is an accepted bounded target-host read-only recovery path when direct strict SSH cannot prove execution.

### Current next action

```text
CURRENT_GATE=DOCUMENTATION_CONSOLIDATION_ONLY
VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
PROJECT_RUNTIME_MUTATION_AUTHORIZED=NO
PROVIDER_MUTATION_AUTHORIZED=NO
SECRET_CONTENT_READ_AUTHORIZED=NO
```

The documentation goal is to make current truth discoverable without rewriting historical audit records.


### Canonical project handoffs

- [Xianyu](../xianyu/REVIEWER_HANDOFF.md)
- [Dujiao-Next](../dujiao-next/REVIEWER_HANDOFF.md)
- [Unified Pay](../unified-pay-system/REVIEWER_HANDOFF.md)
- [Mini Craft Night Kit](../mini-craft-night-kit/REVIEWER_HANDOFF.md)
- [Shared VPS Portfolio](./SHARED_VPS_PORTFOLIO.md)
