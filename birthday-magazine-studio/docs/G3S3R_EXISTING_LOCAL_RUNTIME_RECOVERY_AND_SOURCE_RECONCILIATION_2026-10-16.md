# G3S3R — Bounded recovery of existing local G3C runtime and source correlation

> Date: 2026-10-16
> Status: **AWAIT_OWNER_AUTHORIZATION_FOR_EXISTING_CONTAINER_START**; read-only preflight may be prepared; do not start until Owner explicitly approves.
> Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S3_RETURN_PREFLIGHT_DRIFT_2026-10-16.md`
> Source of Executor outcome: PR #64 `docs/evidence/g3s3/G3S3_EXECUTOR_PREFLIGHT_2026-10-16.md` at `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3`
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7

## Gate contract

```text
GATE_ID=G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_AND_SOURCE_RECONCILIATION_20261016
OBJECTIVE=Safely recover the already-existing local WordPress/Woo read-only observability without recreating, resetting or losing prior unique state; classify local source/PR differences sufficiently to avoid a wrong-target Test Gate.
MAX_ENDPOINT_THIS_ROUND=ONE CONDITIONAL existing-container start sequence (DB then WordPress then WP-CLI), one read-only Woo/Stripe/product/runtime/source verification and sanitized append-only Evidence; stop to Reviewer. Nothing further.
MANDATORY_REVIEW_STOP=YES; must stop for Reviewer even after successful runtime readback.
TARGET_AND_SCOPE=Owner physical Windows 11 G3C Compose birthday-magazine-g3c, existing container IDs and named volumes birthday-magazine-g3c_database and birthday-magazine-g3c_wordpress, loopback 127.0.0.1:8189; existing dirty g3cr2 checkout; PR #64 reference only.
APPLICABLE_CRITICAL_CONSTRAINTS=No git reset/clean/stash/checkout/rebase/merge; no deletion or screenshot restoration; no new worktree required; no Docker Compose up/down/recreate/stop-all/volume prune/pull/build/new container/DB import; no backup overwrite; no WordPress migration or plugin install/activation/config change; no paid/test checkout/refund/account/OAuth/tunnel/exposure/PayPal actions; no public site change or PR merge.
PREFLIGHT=Verify original project/container/host exact identities and mounted source before action, target still stopped, Docker Engine health, ownership and private loopback port, original two named volumes present, old backup+manifest metadata intact, unexpected external listeners absent, source diff/working tree preserved, no unexpected pending migrations/restarts; classify prior exit-137 cause UNKNOWN unless independent evidence. Check available disk/memory and that start cannot silently use a different source/volume/project. If any material anomaly, STOP before start.
REQUIRED_EVIDENCE=HOST_AND_DOCKER_CONTEXT; EXACT_EXISTING_CONTAINER_IDS_IMAGE_CONFIG_STATUS_MOUNTS; PROJECT_ISOLATION_PORT_NEGATIVE_CHECK; SRC_HEAD_VS_PR_AND_UNCOMMITTED_DIFF_CLASSIFICATION_WITHOUT_MUTATION; DURABLE_VOLUME_AND_BACKUP_METADATA; PRE_START_RISK_CLASSIFICATION; CONDITIONAL_OWNER_AUTHORIZATION; ACTUAL_START_EXIT_STATUS_AND_HEALTH_IF_PERFORMED; FRESH_WOO_STRIPE_PRODUCT_CHECKOUT_AND_PRIVATE_OWNERSHIP_READBACK; SOURCE_RUNTIME_CORRELATION; NON_TARGET_DELTA_AND_STOP; NO_SECRET_OUTPUT.
ACCEPTANCE_CRITERIA=No local existing changes lost and no unrelated container/volume/network altered; if authorized and preflight safe, exact previously stopped containers started once in order and healthy, original loopback responds, verified plugin version/activation/gateway status, Woo #1113 price/currency/virtual and owner/checkout invariants using read-only queries; source divergence is exactly classified and next integration source target is unambiguous or explicitly UNKNOWN. If not safely resolvable, report RETURN with facts; don't claim runtime recovered.
ROLLBACK_STATUS_OR_PLAN=No mutation through phase A. For an allowed start, record exact pre-start identity/status and prior recovery assets. Start may allow crash recovery inside the DB and is not bytewise reversible; do not assume returning to Exited state undoes writes. On unexpected errors, stop further service launches, preserve DB/volumes/logs (no blind restore), and return for Reviewer decision. If necessary, gracefully stop only services this Gate started after recording state and readbacks, not unrelated projects.
OWNER_ONLY_ACTIONS=Owner must explicitly approve one bounded restart of ONLY the existing G3C DB/WordPress/WP-CLI containers knowing that a database may automatically recover/update its internal state on startup. Approval of this Gate is NOT approval to restore/recreate, activate Stripe, pay/refund or merge.
REVIEWER_TO_EXECUTOR_RELAY=See the phase A/B/C instructions in this file; do not read the entire project history.
EXECUTOR_TO_REVIEWER_RELAY=Short fixed completion packet and exact sanitized Evidence commit, or RETURN with smallest blocker.
```

## Reviewer-to-Executor relay

**Accepted facts:** G3S3 Reviewer returned because all four services were stopped and local mounted repo source was dirty/stale. Earlier G3S1SV/SVE inactive Woo Stripe 11.1.0 staging and isolated 58-table DB backup proof remain accepted only for that prior staging. Existing PR #64 evidence-only head at planning time `2eb033658ad0ed04dacfe3a0f2b26101ab4697e3`. No provider change authorized.

**Exact startup references (read only):**
- This Gate;
- `docs/REVIEWER_DECISION_G3S3_RETURN_PREFLIGHT_DRIFT_2026-10-16.md`;
- PR #64 `docs/evidence/g3s3/G3S3_EXECUTOR_PREFLIGHT_2026-10-16.md` (only current evidence);
- current exact `poc/g3c/compose.yaml` and three preexisting edited G3C source files (paths discovered in git status), WooCommerce product #1113;
- current existing container and volume inspect metadata.
No reread of broad historical proofs unless a specific concrete contradiction demands it.

### Phase A — read-only, no runtime startup

1. Verify the native Windows machine and Docker context `desktop-linux`; inventory **only** Compose-labeled `birthday-magazine-g3c` containers, their current IDs, image IDs/configured mounts, restart policy, exact network and ports, present named volumes. Check neither container nor local bound paths were replaced since G3S3. Record sanitized fields; never print raw environment, DB data, secrets or unredacted provider logs.
2. Inspect exit-137 diagnostic metadata (`OOMKilled`, `State.Error`, recent system/daemon clues **where accessible without mutation**) and classify root cause as evidenced or UNKNOWN. Do not infer OOM from exit code alone.
3. Confirm backup archive+manifest file *metadata* and actual current filesystem/volume inventory; do not import SQL or read private backup data, export live contents, or delete installer temp ZIPs. Existing backup is older; do not describe it as a fresh Test-write rollback.
4. Capture the local HEAD/PR head and working-tree changed-path/status inventory; for three G3C edited files and 17 screenshot deletions compare **path-level** source to PR and accepted recent frontend source. Preserve every existing change. Do not reset, stash, clean, checkout, rebase or replace files. Source mismatch may remain a later task; identify which differences affect startup/payment readback and which do not.
5. Check that launching **the existing container IDs** will not cause Compose recreation, use another DB volume, rewrite source bindings, trigger an unapproved payment worker, change external network exposure, or run WordPress migrations. Inspect loopback listeners and available resource headroom. If material risk/data-source uncertainty or unexplained image/mount change is observed, **RETURN_PREFLIGHT_DRIFT** before any start.

### Phase B — only after explicit Owner approval and phase-A PASS

- Owner authorization must be in the current relayed execution request, **not implied merely by this GitHub Gate existing**. If missing, stop at `RETURN_OWNER_ACTION_REQUIRED` after phase A; do not start.
- Start **already-existing container ID** for G3C `db` exactly once; wait for verified healthy MariaDB readback. An exit 137 may reflect an unclean shutdown; unexpected InnoDB errors/recovery risk are STOP conditions. Do not re-create or import the DB and do not retry a failed startup without Reviewer reconciliation.
- Then start the **already-existing** `wordpress` container exactly once and read back loopback `http://127.0.0.1:8189/`. If healthy and target still matches, start the **already-existing** `wpcli` container exactly once solely for non-mutating structured WP queries; it must not install/activate/modify anything.
- Leave `mailpit` STOPPED: not required for read-only plugin/order inspection. Do not let start commands auto-create replacement containers or start other projects.
- For each actual start: check native exit code, post-state, exact image/volume/mount identity, health/port behavior and non-target delta. Log unexpected restart effects without printing credentials.

### Phase C — read-only verification and stop

- Query WP/Woo runtime current state with read-only commands: WordPress identity/site URL, installed Woo/Stripe plugin version and activation, registered/active payment methods (excluding any option values that may be Secrets), Woo product #1113 status/virtual/USD price, non-sensitive order ownership guard and private-workspace source linkage. No checkout, order mutation, webhook delivery, refund, login or test customer creation.
- Re-check whether runtime bind-mounted plugin source genuinely matches either existing dirty checkout or PR canonical source; report exact mismatches. If source is not proven canonical, do not declare production Test readiness. Recommend isolated future source-sync plan (preserve old checkout and its 17 deletions).
- Evidence is one sanitized append-only `docs/evidence/g3s3r/G3S3R_EXISTING_LOCAL_RUNTIME_RECOVERY_2026-10-16.md` on PR #64 **only if within agreed execution transport policy**. Do not accidentally mix existing dirty worktree files into a commit. Keep source/doc writes to zero except the evidence commit. Reviewer will update main Handoff.
- Stop at Reviewer with either `PASS_CANDIDATE_G3S3R` or a precise `RETURN_*`. This Gate never permits Stripe Test activation or a subsequent unreviewed step.

## Executor-to-Reviewer packet

```text
结果：PASS_CANDIDATE_G3S3R / RETURN_*
改动：是否原位启动了哪三个既有容器；其他本地/Provider/源码改动为零。
验证：当前本机容器、数据库健康、Woo/Stripe 状态与源码一致性；保存 Evidence 位置。
问题：NONE 或准确 STOP 原因，不凭 exit 137 猜测 OOM。
回滚：启动会使数据库执行内部恢复，不能声称完全无状态变化；停止后保留原卷和原备份。
请 Reviewer 检查：是否足以进入独立 Stripe Test-only 写入 Gate，或仍需隔离源码/恢复处理。
Owner 转交：NONE 或明确需要重新批准的具体单次本机动作。
```
