# 3x-ui P2R2 Phase A — Executor Evidence

Execution date: 2026-10-07
Gate: `3XUI_FASTPATH_P2R2_SERVER_STAGE_OWNER_MATERIALIZE`
Target: `143.198.159.233`
Result: `PASS_CANDIDATE`
Scope: Phase A server staging only.

## Sanitized acceptance markers

```text
TARGET_STRICT_SSH=PASS
TARGET_HOSTNAME=PASS
XUI_ACTIVE=YES
ACCEPTED_SHARED_CLIENT_READBACK=PASS
SUBSCRIPTION_NORMAL_TLS=PASS
REMOTE_STAGE_DIR=PASS
REMOTE_DIR_ROOT_0700=PASS
REMOTE_FILE_SET_EXACT=PASS
REMOTE_URL_ROOT_0600_NONEMPTY=PASS
REMOTE_YAML_ROOT_0600_NONEMPTY=PASS
REMOTE_URL_MATCHES_ACCEPTED_ENDPOINT=PASS
REMOTE_YAML_MATCHES_TLS_SOURCE=PASS
REMOTE_YAML_PROXY_COUNT=3
REMOTE_YAML_PROFILE_SHAPE=PASS
SECRET_VALUES_EMITTED=0
SECRET_HASHES_EMITTED=0
OWNER_APPDATA_ACCESSED=NO
OWNER_ACTION_REQUIRED=NONE_PHASE_A
CLASH_IMPORT_OR_ACTIVATION=NO
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

The only staged remote artifacts are `/root/3xui-owner-transfer/subscription.url` and `/root/3xui-owner-transfer/self-vpn-3xui.yaml`. Their contents and Secret-derived hashes were not emitted or committed. Remote read-back confirmed exact file set, root ownership, required modes, non-empty content, normal TLS validation, exact source/profile match, and the accepted three-node profile shape.

Rollback boundary before Phase B acceptance: remove only those two exact remote files and then the now-empty `/root/3xui-owner-transfer` directory. Accepted P2 server configuration remains unchanged.

STOP_AT_REVIEWER. Phase B and P3 were not executed.
