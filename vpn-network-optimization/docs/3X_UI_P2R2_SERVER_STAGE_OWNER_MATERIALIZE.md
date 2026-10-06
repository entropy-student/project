# 3x-ui P2R2 — Server Stage + Owner-host Materialization

Status: REVIEWER_RELEASED / EXECUTOR_SERVER_STAGE

## GATE_ID

`3XUI_FASTPATH_P2R2_SERVER_STAGE_OWNER_MATERIALIZE`

## OBJECTIVE

Repair the P2 local delivery without asking Executor to discover, diagnose, or write into potentially virtualized/redirected Owner `AppData`.

Two fixed phases:

1. Executor creates two root-only transfer files on the already accepted fresh VPS.
2. After Reviewer accepts the server staging evidence, Owner runs one atomic PowerShell checkpoint on the real Windows host to copy those exact files into the real Owner `AppData\Local`, lock ACLs, parse the Mihomo YAML, read back the exact paths, and remove the remote staging copies.

No path discovery or AppData troubleshooting is delegated to Executor.

## GOVERNANCE APPLICATION

This Gate applies the existing Governance rule from `vps-project-governance/VNEXT.md` section 11B:

- sandbox/container/redirected path equality is not host proof;
- Windows path virtualization/redirected storage must be ruled out;
- host-local writes require target identity and same-target read-back;
- Owner-local checkpoints are one-shot/minimal and emit bounded non-secret Evidence.

## ACCEPTED SERVER STATE

Retain accepted P2 server facts:

- target `143.198.159.233`;
- strict SSH trust accepted;
- valid HTTPS IP subscription;
- normal TLS validation;
- cert auto-renew;
- three-node Mihomo endpoint available;
- three P1 inbounds/client remain accepted;
- old VPS untouched.

## PHASE A — EXECUTOR SERVER STAGE ONLY

Executor must **not write anywhere under `C:\Users\34707\AppData`**.

Using strict SSH and protected target process memory, create:

```text
/root/3xui-owner-transfer/subscription.url
/root/3xui-owner-transfer/self-vpn-3xui.yaml
```

Required state:

```text
/root/3xui-owner-transfer          root:root 0700
subscription.url                  root:root 0600 non-empty
self-vpn-3xui.yaml                root:root 0600 non-empty
```

The URL must be the accepted HTTPS Mihomo subscription URL with the real protected Sub ID.

The YAML must be fetched from that accepted endpoint with normal TLS validation and contain exactly the accepted three nodes.

Do not emit file contents, Sub ID, credentials or hashes derived from Secret-bearing content.

Sanitized checks:

```text
REMOTE_STAGE_DIR=PASS
REMOTE_URL_FILE=PASS
REMOTE_YAML_FILE=PASS
REMOTE_YAML_PROXY_COUNT=3
REMOTE_YAML_PROFILE_SHAPE=PASS
SECRET_VALUES_EMITTED=0
```

After staging, STOP_AT_REVIEWER.

Do not touch Owner AppData.
Do not execute P3.

## PHASE B — OWNER ATOMIC MATERIALIZATION CHECKPOINT

This phase is not released until Reviewer accepts Phase A.

The Owner will run one Reviewer-supplied PowerShell block in their **actual Windows PowerShell/PowerShell session**.

The checkpoint will:

1. require the real Owner context:
   `$env:LOCALAPPDATA -ceq 'C:\Users\34707\AppData\Local'`;
2. use the accepted SSH identity:
   `C:\Users\34707\.ssh\digitalocean_ed25519`;
3. use explicit:
   `C:\Users\34707\.ssh\known_hosts`;
4. create exactly:
   `C:\Users\34707\AppData\Local\vpn-network-optimization\3xui-fastpath`;
5. disable ACL inheritance and grant only the current Owner SID full control;
6. SCP the two exact remote staged files without printing their contents;
7. explicitly protect each leaf file with the current Owner SID;
8. prove both exact paths exist and are non-empty from that same Owner session;
9. parse the YAML with the installed Clash Verge `verge-mihomo.exe` while suppressing parser output;
10. delete only the two exact remote staging files and their now-empty staging directory after local validation succeeds;
11. emit only bounded non-secret PASS markers and file lengths/paths.

Owner is not asked to debug or discover alternate paths.

## FORMAL PASS REQUIREMENT

P2 cannot return to PASS until:

- Phase A Executor staging = PASS_CANDIDATE and Reviewer accepted;
- Phase B actual Owner-host checkpoint = PASS;
- same Owner session reads both exact paths back as non-empty;
- Mihomo parse from the Owner-visible YAML = PASS.

## SECRET BOUNDARY

Never emit or commit:

- subscription URL;
- Sub ID;
- VLESS UUID;
- HY2 auth;
- WG private key;
- REALITY private key;
- API token.

Remote staging and final Owner-local files are Secret-bearing and stay outside Git.

## WINDOWS BASELINE

Neither phase may import or activate Clash.

Do not change system proxy, TUN, standalone WireGuard, selector, active profile or routes.

## ROLLBACK

Before Phase B success, remote staging can be deleted exactly and P2 server state remains accepted.

If Phase B fails after one local file is copied, do not guess another location. Stop; preserve exact sanitized phase/error and reconcile. No broad AppData search is needed.

## OWNER_ONLY_ACTIONS

Phase A: NONE.

Phase B: run one exact atomic PowerShell checkpoint supplied by Reviewer after Phase A PASS_CANDIDATE.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `REVIEWER_HANDOFF.md`;
3. P2 server-side accepted Evidence/reconciliation.

Executor scope is **remote staging only**.

Do not inspect or write Owner AppData.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：只说明 VPS 上两个 root-only transfer 文件是否已安全准备。
验证：说明远端权限、非空、三节点 YAML shape 和 Secret boundary。
问题：NONE 或精确阻塞。
回滚：说明两个远端 staging 文件的精确删除边界。
请 Reviewer 检查：Phase A staging Evidence。
Owner 转交：NONE。
```
