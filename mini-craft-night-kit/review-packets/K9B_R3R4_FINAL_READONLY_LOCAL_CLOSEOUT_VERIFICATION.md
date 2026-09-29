# K9B-R3R4 — Final Read-only Local Closeout Verification

Status: AUTHORIZED_READONLY_ONLY
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R3R3_OWNER_DELETE_COMPLETE_R3R4_FINAL_READONLY_VERIFY.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical VPS Project Governance latest

## Goal

Verify the final Mini Craft local closeout state after Owner completed the exact allowlisted filesystem deletion.

No deletion or mutation is authorized.

## Exact seven paths — read-only

Verify all are absent:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
```

Required:
`SEVEN_EXACT_LOCAL_PATHS_ABSENT=YES`

## Docker — read-only

Verify:

```text
LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0
LOCAL_MINICRAFT_CUSTOM_IMAGES=0
```

Do not prune or delete anything.

## Protected recovery — read-only metadata only

Search under the OpenAI Codex packaged-app LocalCache namespace.

Required:

```text
PROTECTED_ROLLBACK_METADATA=RETAINED_CODEX_LOCALCACHE;54911_BYTES
DPAPI_PENDING_RECOVERY=RETAINED_CODEX_LOCALCACHE;1686_BYTES
DPAPI_FINAL_RECOVERY=RETAINED_CODEX_LOCALCACHE;1686_BYTES
```

Do not read contents, decrypt, hash, copy, move or delete.

## Shared Git cache — read-only

Verify:
- project-github-sync still exists;
- no cleanup-induced mutation;
- untracked Mini Craft artifact count = 0;
- known tracked dirty cache exception remains carry-forward only.

Do not run git clean/reset/restore/checkout/stash.

## Public production regression — read-only

Verify:

```text
PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PRODUCT_223_PURCHASABLE=NO
WOOCOMMERCE_STORE_CURRENCY=USD

VPS_MUTATIONS=0
PRODUCT_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

Product 1224:
- no write;
- carry forward accepted Published/Hidden/USD 1.00 Canary baseline;
- do not reopen containment in this Gate.

## Persist

Append final verification to:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Fresh-read-back both.

## Success

```text
PASS_CANDIDATE_K9B_R3R4_FINAL_READONLY_LOCAL_CLOSEOUT_VERIFICATION
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
