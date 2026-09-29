# K9B-R3R3 — Owner Manual Exact-Path Deletion Checkpoint

Status: AWAIT_OWNER_LOCAL_IRREVERSIBLE_ACTION
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R3R2_PARTIAL_PASS_R3R3_OWNER_MANUAL_EXACT_PATH_DELETION.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md

## Owner action

Using Windows File Explorer, manually delete exactly these seven paths:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
```

Do not delete the parent `VPS基建` folder.

Do not delete or modify:
- `%LOCALAPPDATA%\MiniCraftNightKit\protected-recovery`
- `%LOCALAPPDATA%\MiniCraftNightKit\secret-recovery`
- shared `project-github-sync` repo
- shared `.git`
- unrelated project directories

Do not use alternate automation/shell methods to bypass the Executor execution-policy block.

## Resume after Owner confirms completion

Executor is read-only only.

Verify:

```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS

PATH_1_EXISTS=NO
PATH_2_EXISTS=NO
PATH_3_EXISTS=NO
PATH_4_EXISTS=NO
PATH_5_EXISTS=NO
PATH_6_EXISTS=NO
PATH_7_EXISTS=NO

LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0
LOCAL_MINICRAFT_CUSTOM_IMAGES=0

LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED
LOCAL_DPAPI_RECOVERY=RETAINED
SHARED_GIT_CACHE_EXCEPTION=RETAINED
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=0
```

Public read-only regression:

```text
PUBLIC_ORIGIN_HEALTH=PASS
PRODUCT_223_PURCHASABLE=NO
WOOCOMMERCE_STORE_CURRENCY=USD
VPS_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

Product 1224:
- no write;
- carry forward accepted Hidden Canary baseline;
- do not reopen containment in this Gate.

## Persist

Append verification to:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Fresh-read-back both.

## Success

```text
PASS_CANDIDATE_K9B_R3R3_OWNER_MANUAL_EXACT_PATH_DELETION_VERIFIED
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
