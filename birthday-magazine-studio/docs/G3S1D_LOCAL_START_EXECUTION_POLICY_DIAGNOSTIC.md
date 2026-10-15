# G3S1D — Read-only diagnosis of blocked local WordPress start

> Created: 2026-10-15
> Governance: vps-project-governance v0.2.7
> Parent RETURN: `docs/REVIEWER_DECISION_G3S1_RETURN_LOCAL_WORDPRESS_START_BLOCKED_2026-10-15.md`
> Parent staging Gate: `docs/G3S1_LOCAL_STRIPE_GATEWAY_STAGING.md`
> Owner conditional recovery request: `docs/OWNER_DECISION_G3S1_LOCAL_RECOVERY_PRIORITY_2026-10-15.md`
> Active diagnostic Gate only; does not reopen G3S1 staging or expand execution authority.

## Gate

```text
GATE_ID=G3S1D_LOCAL_START_EXECUTION_POLICY_DIAGNOSTIC
OBJECTIVE=Classify why the exact previously authorized existing WordPress container start was denied by the local command-execution policy; reconcile current G3C runtime and Owner-reported possible cleanup impact read-only; establish an explicitly permitted next route or precise blocker.
MAX_ENDPOINT_THIS_ROUND=Sanitized read-only policy/target diagnosis and durable evidence; no WordPress start attempt or new container mutation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Codex-approved Owner Windows G3C Docker runtime + existing project-only GitHub source/evidence; no Shared VPS/production.
APPLICABLE_CRITICAL_CONSTRAINTS=READ_ONLY_ONLY; NO_DOCKER_START_STOP_EXEC_RECREATE; NO_ALTERNATE_TOOL_OR_POLICY_BYPASS; NO_HOST_PERMISSION_POLICY_CHANGE; NO_BACKUP_RESTORE_OR_PLUGIN_INSTALL; NO_STRIPE_AUTH_OR_PAYMENT; NO_PAYPAL_MUTATION; NO_PUBLIC_TUNNEL; NO_FRONTEND_REDESIGN; NO_PR64_MERGE; NO_SECRETS_OR_PII.
PREFLIGHT=Fresh project-scoped main/PR/Gate check; verify own execution channel; reread only the referenced parent RETURN and Executor partial evidence; ensure read-only diagnostic calls are permitted.
REQUIRED_EVIDENCE=FRESHNESS; ORIGINAL_DENIAL_TOOL_AND_STAGE; SANITIZED_FAILURE_CLASS_AND_DOCUMENTED_POLICY_BOUNDARY_IF_AVAILABLE; WHETHER_DENIED_COMMAND_STARTED; PERMITTED_NEXT_PATH_OR_UNKNOWN; LAST_EXECUTOR_RUNTIME_STATE_VS_NEW_READONLY_STATE; CLEANUP_MISSING_RESOURCE_CLASSIFICATION_OR_UNKNOWN; SOURCE_AND_VOLUME_IDENTITY_REUSE_SCOPE; NO_MUTATION_CHECK; NEXT_ACTION_WITH_AUTHORITY; STOP_AT_REVIEWER
ACCEPTANCE_CRITERIA=Reviewer-reviewable classification supported by actual allowed evidence, with explicit remaining unknowns and a policy-compliant decision route; failure to access the relevant policy reason is a precise RETURN, not a guessed workaround.
ROLLBACK_STATUS_OR_PLAN=No new target writes permitted. The DB is last Executor-reported running/healthy, not Reviewer current direct proof. Keep retained containers/data untouched; do not stop/restore/recreate as a cosmetic rollback.
OWNER_ONLY_ACTIONS=NONE for this read-only diagnosis. Any explicit permission, execution-policy change, elevated access or one-shot Owner-local command must be separately reviewed and authorized after diagnosis if genuinely permitted.
```

## Read-only execution plan

1. **Source:** Confirm current `main`, PR #64 and the existing parent decision/evidence. Project-scoped drift only. Reuse accepted Compose/source fingerprint findings; do not broadly repeat prior Git or runtime inventory.
2. **Policy refusal:** Retrieve only the already available non-secret original failure/denial metadata from the **same approved execution channel**: command category, tool interface, process-start status, code/policy error class, whether the tool rejected before starting, and what policy authority would permit normal execution. Do not print credentials, unrelated settings, entire tool logs or hidden/private policy contents. If the platform does not expose its policy reason, record `UNKNOWN`.
3. **State and cleanup hypothesis:** Owner reported possible cleanup and requested recovery; that report does **not** prove a missing resource. If the previously accepted read-only Docker inventory interface still permits it, re-read exact four existing G3C container statuses, health, same IDs, mounts, volumes and ports. Through that same authorized read-only path, classify only any **observably missing** named project-owned resource or tooling prerequisite and correlate with baseline; otherwise record `NO_LOSS_PROVEN` or `UNKNOWN`. Do not fetch WordPress options, DB contents, secrets or user records. If even these reads are blocked, preserve the previous report as timestamped historical evidence and record new runtime `UNVERIFIED`. No reinstall/recreate/restore/cleanup.
4. **Classification:** Distinguish among `EXECUTOR_TOOL_POLICY_DENIAL`, `HOST_OS_PERMISSION_DENIAL`, `DOCKER_ENGINE_DENIAL`, `UNKNOWN` using **evidence**, not the word “policy” alone. State which original action was blocked and the exact *authorized* escalation route, if officially documented and available. Do not invent an approved alternate execution channel.
5. **Stop:** Do not run, re-run, rephrase, script, automate, elevate or tunnel around the denied `docker start`/equivalent. Do not try Docker API/SDK, Compose, UI automation, another shell or a different agent as a workaround. Do not start or stop the DB, WordPress, Mailpit or wpcli in this Gate. Do not prepare/modify backup, plugin or settings. Write sanitized project-scoped diagnostic Evidence only and RETURN to Reviewer.

If repeated failures cannot be explained with accessible metadata, report `RETURN_EXECUTION_POLICY_SOURCE_UNKNOWN` and request Reviewer routing; **not** an experiment with another command surface.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
- This diagnostic Gate.
- `docs/OWNER_DECISION_G3S1_LOCAL_RECOVERY_PRIORITY_2026-10-15.md` (recovery intent, not permission to bypass policy).
- `docs/REVIEWER_DECISION_G3S1_RETURN_LOCAL_WORDPRESS_START_BLOCKED_2026-10-15.md`.
- `docs/evidence/g3s1/EXECUTOR_PARTIAL_PREFLIGHT_2026-10-15.md` from PR #64 commit `715be642c59f40672f6d83b00aa9bc4a7997dc31`.
- `poc/g3c/compose.yaml` at current PR #64 head, only if a source identity cross-check is necessary.
- Previously available non-secret command rejection evidence and the authorized read-only local status interface, if permitted.

Do not reread general Governance or project history. This is a **diagnostic-only stop** before returning to Reviewer. Existing G3S1 staging remains on hold.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S1D / RETURN_*
改动：仅新增脱敏诊断证据；本地容器与插件零操作。
验证：策略拒绝来源、实际命令是否启动、已证实缺失项或 UNKNOWN、最新只读容器状态、允许的后续审批路径。
问题：明确失败原因或无法获取的证据，不猜测。
回滚：未变更本地运行态；DB 延续上轮状态，以本轮读回为准。
请 Reviewer 检查：策略来源、是否存在合规继续路径及容器状态。
Owner 转交：NONE，除非 Reviewer 明确要求。
```
