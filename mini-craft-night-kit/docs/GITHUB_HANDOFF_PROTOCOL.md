# Mini Craft Night Kit — GitHub Reviewer / Executor Handoff Protocol

Last reviewed: 2026-09-21  
Status: **V2 TRIAL — ORIGINAL GOVERNANCE INHERITED**

## 1. Goal

减少 Owner 在聊天中复制粘贴长日志与文档。

GitHub `entropy-student/project/mini-craft-night-kit/` 作为 Mini Craft 项目的长期可查阅记录面。

## 2. Reviewer-owned documents

Reviewer 维护：

- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- `docs/*DECISION*.md`
- Gate / architecture / acceptance truth

Reviewer 聊天回复默认简化为：

> Reviewer 已完成，可查阅 `mini-craft-night-kit/REVIEWER_HANDOFF.md`。

如果有专项 Decision，则附对应文档名。

## 3. Executor-owned documents

Executor / Codex 维护：

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- 必要的 manifest / evidence index
- 当前 Gate 的实现代码与可安全提交的测试证据

Executor 聊天回复默认：

> 执行完成，可查阅 `mini-craft-night-kit/EXECUTION_EVIDENCE.md` 与 `EXECUTOR_HANDOFF.md`。

## 4. Secret Boundary

GitHub 永远不得写入：

- .env；
- password；
- token；
- private key；
- Provider Secret；
- cookies；
- credential dump；
- production customer sensitive data。

Evidence 只记录：
- Secret 是否存在；
- Secret 配置位置类别；
- read-back 成功/失败；
- 必要的非敏感标识。

## 5. PASS Boundary

Executor 只能写：

`PASS_CANDIDATE`

只有 Reviewer 能写正式：

`PASS`

## 6. Promotion to Global Governance

当前先在 Mini Craft 项目试运行。

满足以下条件后再写入全局 Governance：

- 至少连续 3 个 Gate 顺利；
- Reviewer 能直接从 GitHub 接管；
- Executor 不覆盖 Reviewer Truth；
- Owner 不需要搬运长日志；
- Secret / evidence boundary 无事故；
- 历史记录可追踪。

成功后建立 Governance Change Gate，将其推广到其他项目。


## 7. Mandatory Diagnostic Evidence Packet

For any diagnostic RETURN, conflict-isolation Gate, compatibility investigation, runtime failure, or nontrivial root-cause claim, Executor must include a compact but sufficient `DIAGNOSTIC_PACKET` in `EXECUTOR_HANDOFF.md` and detailed supporting evidence in `EXECUTION_EVIDENCE.md`.

A diagnostic handoff is incomplete if it contains only a conclusion label such as `NETWORK_FAILURE`, `PLUGIN_CONFLICT`, `LOCAL_REQUEST_FAILURE`, or `COMPATIBILITY_ISSUE` without the supporting observations.

Minimum packet:

```text
DIAGNOSTIC_PACKET
GATE=<gate>
ENVIRONMENT=<runtime/version/target>
TRIGGER=<exact sanitized symptom/error>
REPRODUCTION=<exact bounded command/route/action, sanitized>
OBSERVED=<HTTP/status/error type/timing/CPU/etc.>
CONTROL_OR_BASELINE=<comparison result, if any>
HYPOTHESES_RULED_OUT=<evidence-backed exclusions>
HYPOTHESES_REMAINING=<ranked candidates, not conclusions>
ARTIFACTS=<safe local evidence/helper paths + hashes when relevant>
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=<single smallest next test>
STOP_REASON=<why Executor stopped>
```

For exceptions, include sanitized exception class/category, stage marker, and HTTP status when available. Do not include credentials, tokens, cookies, authorization headers, raw sensitive response bodies, or secret-bearing command lines.

Reviewer must not promote a diagnostic conclusion to formal truth if the packet lacks enough evidence to distinguish it from adjacent hypotheses. In that case, return for evidence completion rather than inventing the missing chain.

This rule is project-local trial governance. Global promotion still requires a separate Governance Change Gate.


## 8. Owner Checkpoint Artifact Readiness

Before Executor returns an Owner-run command, every referenced local artifact must still exist at the final stop point and the exact Owner command must be dry-run validated through the same staging path without credentials.

Minimum readiness evidence:

```text
OWNER_CHECKPOINT_READINESS
COMMAND=<exact sanitized Owner command>
LOCAL_ARTIFACTS_PRESENT=PASS
CONTAINER_STAGING_PATH=PASS|N/A
POST_CLEANUP_EXISTENCE_CHECK=PASS
NO_SECRET_DRY_RUN=PASS
EXPECTED_PRE_AUTH_STAGE=<stage reached without credentials>
CLEANUP_AFTER_OWNER_RUN=<what is removed and when>
```

Executor must not delete or move any helper needed by the Owner before the Owner checkpoint is completed. Cleanup may remove container-temporary copies only if the Owner wrapper deterministically recreates them from a retained local source on every run and that exact path is verified after cleanup.

A syntax/lint check alone is not sufficient for Owner checkpoint readiness. The exact wrapper/staging chain must be validated after cleanup.


## 9. V2 — Inherit the original Reviewer / Executor Governance

This GitHub protocol is a transport/audit implementation of the original project-management governance. It does **not** replace the governance model.

Canonical flow:

```text
Owner
  ↓
Reviewer / Architect / Gatekeeper
  ↓
Execution Agent
  ↓
Raw Evidence + Actual Artifacts
  ↓
Reviewer Independent Verification
  ↓
PASS / RETURN
```

Core invariants:

- Execution Agent is not a second Reviewer.
- `PASS_CANDIDATE != PASS`.
- GitHub is the message bus / evidence surface, not an authority that makes Executor claims true.
- Reviewer must independently inspect enough source, diff, runtime read-back, raw evidence, screenshots or artifacts to support the decision.
- A conclusion written by Executor is a navigation hint only until Reviewer verifies the underlying material.
- Unknown state must remain `UNKNOWN`; do not fill gaps from old plans, README, or Executor inference.
- Accepted Gates are not rerun unless fresh material drift exists.

## 10. Handoff roles — V2

### `EXECUTOR_HANDOFF.md`

Purpose: **navigation only**.

It should answer briefly:

- what changed;
- what result Executor claims;
- where the actual evidence is;
- what Reviewer must inspect;
- why Executor stopped.

It must not be treated as sufficient evidence for a Reviewer PASS.

### `EXECUTION_EVIDENCE.md`

Purpose: append-only execution evidence index / bounded evidence summary.

It should contain sanitized command/result facts and point to reviewable artifacts.

### `review-packets/<GATE>/`

Purpose: Reviewer-verifiable material for nontrivial Gates.

Required for:

- diagnostic RETURNs;
- payment/auth/webhook work;
- database/runtime migrations;
- architecture changes;
- production/deploy work;
- UI/visual acceptance where source evidence alone is insufficient;
- any Gate where the implementation is not fully represented by a normal Git diff.

Recommended structure:

```text
review-packets/<GATE>/
  MANIFEST.md
  FILES_CHANGED.md
  COMMANDS.md
  DIAGNOSTIC_PACKET.md        # when diagnostic
  OWNER_CHECKPOINT_READINESS.md # when Owner action required
  snapshots/
  logs/
  scripts/
  config-snapshots/
  hashes.txt
```

Do not add secrets, cookies, tokens, private keys, customer-sensitive data, or credential-bearing raw bodies.

## 11. Mandatory Reviewer Verification Set

Before formal PASS on a nontrivial Gate, Reviewer must independently inspect the applicable items below rather than only reading Executor conclusions:

1. **Scope / diff**
   - actual changed source/config files or a faithful sanitized snapshot;
   - expected vs actual file/resource delta.

2. **Runtime truth**
   - post-change read-back from the real target runtime;
   - versions, routes, service/container state, relevant settings;
   - post-cleanup state when cleanup is part of the Gate.

3. **Test evidence**
   - exact sanitized command/action;
   - exit/HTTP/status result;
   - negative tests where relevant;
   - control/baseline comparison for diagnostics.

4. **Rollback / safety**
   - rollback artifact/path/hash when required;
   - proof destructive/production actions did not exceed scope.

5. **Artifacts**
   - any helper/script/config/snapshot the Owner or Reviewer still needs must be present and hash/size checked at handoff time.

6. **Boundary checks**
   - secrets not exposed;
   - unrelated projects/resources untouched;
   - Owner-only actions not crossed.

Reviewer may sample or expand evidence based on risk, but must not downgrade this into “Executor said PASS, therefore PASS.”

## 12. Evidence retention / cleanup lifecycle

Use the original lifecycle:

```text
KEEP CURRENT
→ ARCHIVE UNIQUE HISTORY
→ DELETE REPRODUCIBLE DUPLICATES
```

Before Reviewer PASS:

- do not delete any artifact needed to independently verify the Gate;
- only pure cache/download/extraction junk may be removed;
- if an Owner command depends on a local artifact, that artifact must survive until the Owner checkpoint completes;
- temporary container copies may be removed only when the retained local source can deterministically recreate them and that chain has been verified.

After Reviewer PASS:

- retain current Source of Truth;
- retain unique evidence and rollback references required for recovery/audit;
- archive useful history;
- remove reproducible duplicates and temporary clutter.

## 13. Owner burden minimization

The desired Owner experience is:

```text
Owner gives goal
→ Reviewer writes Gate to GitHub
→ Executor executes and writes evidence/artifacts to GitHub
→ Owner says only “Review latest result” when needed
→ Reviewer independently reviews GitHub
```

Owner should not routinely copy/paste long logs, evidence, diffs, screenshots, or files between Executor and Reviewer.

Owner intervention is reserved for actual external boundaries such as:

- account / identity authorization;
- Secret entry;
- payment;
- irreversible/destructive decision;
- manual provider UI where no safe automation exists;
- explicit visual acceptance.

If Reviewer cannot access a required binary/visual artifact through GitHub, request only that missing artifact instead of asking the Owner to repackage the entire project.

## 14. Full-project review cadence

The earlier three-cycle review principle is retained.

After approximately 3 meaningful Executor → Reviewer cycles, and also after a major runtime/payment/architecture incident, perform a deeper 2–3 round project review before continuing broad feature expansion.

A full review should inspect the actual project state, not only management documents:

- architecture / source-of-truth boundaries;
- canonical runtime and deployment assumptions;
- actual source/configuration;
- dependencies/plugins/versions;
- database/order/payment state boundaries;
- security / Secret handling;
- rollback/recovery;
- payment/idempotency/webhook assumptions;
- UI and responsive drift where applicable;
- documentation truth vs runtime truth;
- obsolete/reproducible artifacts;
- implementation order and remaining risks.

## 15. Mini Craft specific full-review trigger

For Mini Craft:

```text
FULL_PROJECT_REVIEW_AFTER_K3R8_RESOLUTION=REQUIRED
ROUNDS=2_TO_3
K4_BROAD_FEATURE_EXPANSION_BEFORE_FULL_REVIEW=HOLD
```

Once the current K3R8* PayPal/helper incident reaches a stable resolved checkpoint, Reviewer must perform a fresh whole-project review using actual source/runtime/evidence available through GitHub plus only the minimum extra Owner-supplied artifact if GitHub cannot expose a required binary/visual.
