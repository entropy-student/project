# Reviewer Decision — K6 SSH Recovery Reconciliation

Date: 2026-09-24 (Asia/Shanghai)  
Status: PARTIAL READ-ONLY RECOVERY ACCEPTED; DEPLOYMENT PREFLIGHT STILL OPEN  
Governance: canonical `entropy-student/spike.skill/vps-project-governance` v0.1.6 with current operational addenda

## Reviewer finding

Current GitHub project truth is K5 Release Candidate PASS and Owner-authorized K6 Sandbox-first deployment. The latest formal Gate was `K6R2R1_FRESH_CODEX_HOSTINGER_TOOL_SURFACE`, created after an Executor SSH attempt closed before host-key presentation. That earlier return remains a correct account of the 2026-09-23 attempt.

A later independent Reviewer read-only probe from the recorded Windows host succeeded on 2026-09-24 using the existing `ops` identity and normal `known_hosts`. The recorded client public-key fingerprint and all three stored host-key fingerprints matched `SHARED_VPS_HANDOFF.md` before the connection. SSH used `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes` and a bounded connect timeout. Native exit status was 0.

Remote read-back returned `ops`, hostname `srv1970241`, and Ubuntu 24.04.5 LTS. The root filesystem was 96G total, 8.7G used, 88G available (10% used). Existing Dujiao-Next, Unified Pay, and Xianyu application containers were healthy; shared Caddy and cloudflared were running; Caddy continued to own host 80/443. The `spikersun-edge` and `spikersun-private` networks were present. No Mini Craft container or `/srv/apps/mini-craft-night-kit`, `/srv/data/mini-craft-night-kit`, or `/srv/backups/mini-craft-night-kit` path was present. No Secret value or business data was read. No remote write occurred.

This proves that the recorded SSH path was reachable at the time of the probe; it does not prove the full K6 Phase A inventory or authorize deployment. The previous pre-host-key failure was transient or path-dependent; its exact cause remains UNKNOWN. The Hostinger tool-surface diagnostic is superseded for this project because the governed SSH path is currently usable; it is not marked PASS, since the Hostinger VPS tools were not exercised.

## Decision

```text
K5_RELEASE_CANDIDATE=PASS_RETAINED
K6_DEPLOYMENT=OWNER_AUTHORIZED_SANDBOX_FIRST_BUT_NO_WRITE_IN_NEXT_GATE
SSH_TRANSPORT=PASS_READ_ONLY_2026-09-24
K6R1_PRIOR_SSH_RETURN=HISTORICALLY_VALID_SUPERSEDED_BY_FRESH_SUCCESS
K6R2R1_HOSTINGER_TOOL_SURFACE=SUPERSEDED_NOT_EXECUTED
SHARED_VPS_FULL_PHASE_A=PENDING
MINICRAFT_REMOTE_NAMESPACE=ABSENT_AT_2026-09-24_PROBE
CURRENT_GATE=K6R3_SHARED_VPS_READONLY_PREFLIGHT_COMPLETION
OWNER_ACTION=NONE_NOW
```

The local checkout under `project-github-sync` is on a non-main branch with existing uncommitted work. Its earlier K4/K5 files are stale relative to GitHub `main`. Executor must read the current GitHub project Handoff and accepted decisions and must not overwrite, stash, reset, or merge the shared checkout as part of this Gate.

## Next Gate — K6R3 shared VPS read-only preflight completion

Goal: complete the K6 Phase A host and storage baseline on the existing governed SSH path, then stop before any mutation. The 2026-09-24 successful probe may be cited but does not replace missing checks.

Read before work:
- canonical GitHub `vps-project-governance/SKILL.md` and active SSH/Target Host Reality/Storage addenda;
- current `mini-craft-night-kit/REVIEWER_HANDOFF.md`, `PROJECT_RECORD.md`, `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K5_RELEASE_CANDIDATE_PASS.md`, `docs/REVIEWER_DECISION_K6_VPS_PRODUCTION_DEPLOYMENT.md`, and this decision;
- the unique local `SHARED_VPS_HANDOFF.md`.

Allowed: one bounded strict SSH read-only inventory using the recorded identity, explicit normal `UserKnownHostsFile`, host-key checking and native exit-code checks. Verify target host identity, OS/kernel, CPU/RAM/disk, Docker/Compose versions, current containers/health/restart counts, networks and memberships, published host ports, UFW summary, exact 80/443 owner, Caddy config source, cloudflared state, `/srv/apps`/`data`/`backups` project collision, and resource headroom. Read metadata only; do not inspect Secret values, provider credentials, private business data or unrelated application files. Reconcile the current topology against the project storage manifest and Shared VPS handoff.

Forbidden: VPS or Docker writes, directory creation, deployment/restore, image pull/build, route/DNS/UFW/SSH/Caddy/cloudflared/network changes, Hostinger control-plane writes, payment, PayPal Live, Secret handling, and broad cleanup. If the strict connection fails, the host key differs, or material topology/collision/resource drift appears, stop with the precise `RETURN_*` code. Do not switch keys, weaken trust, retry blindly, or use the Hostinger AI Builder tools as a substitute.

Return `PASS_CANDIDATE_K6R3_SHARED_VPS_READONLY_PREFLIGHT_COMPLETION` only with exit statuses and a compact non-sensitive host-local inventory covering every required Phase A field, plus explicit `REMOTE_WRITES=0` and `STOP_AT_REVIEWER=YES`. Record the facts in `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`. Reviewer will independently decide PASS/RETURN and the subsequent production-write boundary. No Owner intervention is needed for this read-only Gate.

## Risk and rollback

No deployment or host mutation was made in this review, so no runtime rollback is required. The accepted K5 local release/backups and existing shared-host services remain unchanged. Do not infer current host state from this dated snapshot after material drift.
