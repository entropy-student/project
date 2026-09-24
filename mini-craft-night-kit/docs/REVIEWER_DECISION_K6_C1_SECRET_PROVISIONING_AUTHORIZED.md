# Reviewer Decision — K6 Phase C1 Secret Provisioning and Recovery AUTHORIZED

Date: 2026-09-24 (Asia/Shanghai)  
Gate: `K6_PHASE_C1_SECRET_PROVISIONING_AND_RECOVERY`  
Status: **AUTHORIZED — exact Owner delegation received in chat: “我授权，开始吧。”**  
Prerequisite: `docs/REVIEWER_DECISION_K6_C0_PASS_C1_SECRET_OWNER_CHECKPOINT.md`

The Owner's reply directly accepts the immediately preceding exact ten-file, host, path, no-overwrite, mode, CSPRNG and DPAPI CurrentUser scope, including its profile-bound recovery limitation. This is the required exact Secret delegation under canonical `vps-project-governance/references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md`. The earlier general K6 deployment authorization did not itself delegate Secret creation; this explicit reply does.

## Exact allowlist and permissions

Target: the existing verified Hostinger shared VPS `ops@srv1970241` at the recorded SSH endpoint; no substitute host/account/key. Only `/srv/data/mini-craft-night-kit/secrets/` and the parent project data directory may be created if absent. The Secret directory target is `root:root 0700`.

| File basename | Random source / value format | Owner:group / mode | Consumer |
|---|---|---|---|
| `db-app-password` | target OS CSPRNG, 32 random bytes as newline-free lowercase hex | `root:33 0440` | MariaDB and WordPress |
| `db-root-password` | target OS CSPRNG, 32 random bytes as newline-free lowercase hex | `root:root 0400` | MariaDB only |
| `wordpress-auth-key` | target OS CSPRNG, 64 random bytes as newline-free lowercase hex | `root:33 0440` | WordPress only |
| `wordpress-secure-auth-key` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-logged-in-key` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-nonce-key` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-auth-salt` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-secure-auth-salt` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-logged-in-salt` | same 64-byte format | `root:33 0440` | WordPress only |
| `wordpress-nonce-salt` | same 64-byte format | `root:33 0440` | WordPress only |

No other file or credential is authorized. Every file must use atomic exclusive creation and the Gate must refuse any unexpected existing target. No overwrite or rotation. All mounts remain read-only and the DB-root file must not be available to WordPress.

## Executor instruction and safety gates

1. Re-read canonical Governance, SSH/Delegated Secret Operations, Target Host Reality, Storage Layout, current Reviewer/Shared VPS handoffs, Storage Manifest, C0 PASS, and the exact local production Compose. Before any write, prove the real Owner Windows host/profile and DPAPI availability, the recorded identity/public fingerprint and normal `known_hosts`, strict SSH target identity, `sudo -n` capability, fresh disk/RAM and namespace/container/path collision status. Stop on material drift or if any of the ten paths already exists. Confirm no Mini Craft service is running. Re-render the explicit production Compose without Secret values. Do not weaken SSH trust.
2. Prepare a protected Owner-profile recovery leaf at `%LOCALAPPDATA%\MiniCraftNightKit\secret-recovery\`, outside Git and ordinary artifacts. Verify its actual host-local ACL/inheritance. Prove the DPAPI CurrentUser serialization/parser and pending → round-trip → finalization workflow first with **synthetic fixture bytes**, with no Secret values or hashes printed. If the real Owner host/profile, transport, or DPAPI path cannot be proven, return before generating any real Secret.
3. Generate each real value directly inside the protected target using the target OS CSPRNG and exact formats. Create only the allowlisted target files with restrictive umask and atomic exclusive semantics. Never put values in command arguments, environment variables, PowerShell/SSH transcript, ordinary temp files, stdout/stderr returned to a tool, chat, GitHub, logs or Evidence. A reviewed in-memory SSH stream consumed only by the local encryption process is permitted; it must never surface in agent-visible tool output. If no implementation can guarantee this boundary, stop **before generation**.
4. Create the DPAPI CurrentUser **pending** encrypted recovery artifact on the proven Owner Windows profile and immediately decrypt/compare exact canonical payload bytes in memory. Then read back target file inventory, owner/group/mode, nonempty/format/uniqueness results, and intended runtime read access plus DB-root exclusion **without showing values or value hashes**. Promote pending to final only after all remote and local checks pass; verify the final artifact path, size and ACL on the real Owner host. Record the limited failure domain.
5. If an operation fails or the remote outcome is ambiguous, stop and read back before any retry. Never overwrite. Do not promote a pending artifact after a remote/access failure. Do not delete a protected Secret or pending recovery artifact on an uncertain result; return the precise state to Reviewer for an exact recovery decision. No service is started by this Gate.
6. Commit only redacted factual `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` updates. Return `PASS_CANDIDATE_K6_PHASE_C1_SECRET_PROVISIONING_AND_RECOVERY` or a precise `RETURN_*`, then `STOP_AT_REVIEWER=YES`.

Allowed remote mutations are only creation of `/srv/data/mini-craft-night-kit`, its `secrets` child and the ten exact files, plus their exact ownership/mode. Allowed Owner-host mutation is only the protected DPAPI recovery leaf/pending/final artifact. A bounded temporary verification mechanism is allowed only if it cannot expose values, alter shared resources, or leave residue; any Docker container/image pull requires separate Reviewer review before running. No `/srv/apps` or `/srv/backups` creation, backup transfer, database restore, Compose start, Caddy/cloudflared/DNS/UFW/SSH/shared network change, public route, payment, PayPal Live, or commercial launch is authorized.

## Acceptance

A C1 candidate needs target-host identity and strict SSH PASS, exact inventory with no collision/overwrite, actual target owner/group/mode and runtime access PASS, Owner-host DPAPI pending round-trip PASS, final artifact host-local ACL/path read-back PASS, unrelated services unchanged, no value/hash exposure, and clear remote/local cleanup state. `REMOTE_WRITES` must enumerate only the exact authorized paths. A successful C1 candidate does not authorize Phase C2 deployment; Reviewer will decide that Gate independently.
