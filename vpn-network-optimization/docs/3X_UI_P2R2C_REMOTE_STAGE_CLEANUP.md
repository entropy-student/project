# 3x-ui P2R2C — Remote Transfer Staging Cleanup

Status: REVIEWER_RELEASED / EXECUTOR_CLEANUP

## GATE_ID

`3XUI_FASTPATH_P2R2C_REMOTE_STAGE_CLEANUP`

## OBJECTIVE

Remove only the two now-redundant root-only transfer files and the empty transfer directory from the accepted fresh VPS, then prove absence.

No local Windows mutation is allowed.

## ACCEPTED FACTS

- Owner-local materialization is accepted by fresh Owner read-back.
- Exact final local files exist and parse.
- Remote staging still exists:

```text
/root/3xui-owner-transfer/subscription.url
/root/3xui-owner-transfer/self-vpn-3xui.yaml
```

- directory mode 0700;
- file modes 0600;
- no other staged files are expected;
- server HTTPS subscription/P1 state remains accepted.

## PREFLIGHT

Using strict SSH to `143.198.159.233`:

1. prove exact directory exists;
2. prove exact file set cardinality = 2;
3. prove both expected filenames are present;
4. do not read or print file contents;
5. do not hash Secret-bearing files.

Unexpected extra file/object -> RETURN, no deletion.

## MUTATION

Delete only:

```text
/root/3xui-owner-transfer/subscription.url
/root/3xui-owner-transfer/self-vpn-3xui.yaml
```

Then remove the now-empty:

`/root/3xui-owner-transfer`

## READ-BACK

Require:

```text
REMOTE_URL_ABSENT=YES
REMOTE_YAML_ABSENT=YES
REMOTE_STAGE_DIR_ABSENT=YES
XUI_ACTIVE=YES
XRAY_RUNTIME_HEALTHY=YES
SUBSCRIPTION_HTTPS_STILL_ACTIVE=YES
OLD_VPS_MUTATION=NO
SECRET_VALUES_EMITTED=0
```

No local Windows checks or writes in this Gate.

## ACCEPTANCE

PASS_CANDIDATE only if the exact remote staging objects are absent and accepted server runtime remains healthy.

## ROLLBACK

No rollback is needed for these duplicate transfer copies because accepted Owner-local copies already exist and parse.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `REVIEWER_HANDOFF.md`;
3. the materialization reconciliation decision.

Do not inspect or modify Owner AppData. Do not enter P3.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：仅清理远端两个 transfer 文件与空目录。
验证：说明精确 absence read-back、x-ui/Xray/HTTPS subscription health。
问题：NONE 或精确阻塞。
回滚：本地 Owner 文件已接受，远端 staging 为冗余副本。
请 Reviewer 检查：远端 cleanup 与服务健康 Evidence。
Owner 转交：NONE。
```
