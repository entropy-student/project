# 3x-ui P2R1 — Owner-local Mihomo Artifact Repair

Status: REVIEWER_RELEASED / EXECUTOR_P2R1

## GATE_ID

`3XUI_FASTPATH_P2R1_OWNER_LOCAL_ARTIFACT_REPAIR`

## OBJECTIVE

Repair only the contradicted local-delivery portion of P2.

Do not rebuild the server, rotate credentials, recreate inbounds, or alter the accepted HTTPS subscription service.

Required final Owner-visible files:

```text
C:\Users\34707\AppData\Local\vpn-network-optimization\3xui-fastpath\subscription.url
C:\Users\34707\AppData\Local\vpn-network-optimization\3xui-fastpath\self-vpn-3xui.yaml
```

## ACCEPTED SERVER FACTS

Retain as accepted from P2 unless fresh narrow read-back contradicts them:

- target `143.198.159.233`;
- valid HTTPS IP certificate;
- normal TLS validation;
- automatic renewal;
- TLS subscription service on 2096;
- real Mihomo endpoint returns 200;
- three-node Mihomo profile shape parsed successfully;
- no server Secret leakage;
- old VPS untouched.

## REPAIR METHOD

Executor may use strict SSH and protected local process memory to:

1. read the already-existing protected shared client/Sub ID from the new VPS;
2. reconstruct the exact HTTPS Mihomo subscription URL without printing it;
3. fetch the real Mihomo YAML over normal TLS without printing its contents;
4. create the exact Owner-visible directory above if missing;
5. create `subscription.url` and `self-vpn-3xui.yaml` there;
6. disable ACL inheritance on directory/files;
7. grant only the actual Owner SID access;
8. parse the YAML with installed Clash Verge Mihomo;
9. verify both files exist by exact absolute path and are non-empty.

Do not use `%LOCALAPPDATA%` as an ambiguous destination in this repair. Use the exact Owner path above.

## SECRET RULES

Do not emit:

- subscription URL;
- Sub ID;
- UUID;
- HY2 auth;
- WireGuard private key;
- REALITY private key;
- API token.

No Secret enters GitHub, chat, Evidence, command-line arguments or ordinary logs.

## WINDOWS BASELINE

Do not import/activate the profile.

Do not change:

- active Clash profile;
- selector;
- system proxy;
- TUN;
- standalone WireGuard;
- routes.

## REQUIRED EXECUTOR EVIDENCE

```text
P2_SERVER_STATE_REUSED=YES
OWNER_EXACT_TARGET_DIR=C:\Users\34707\AppData\Local\vpn-network-optimization\3xui-fastpath
OWNER_TARGET_DIR_EXISTS=YES
SUBSCRIPTION_URL_FILE_EXISTS=YES
SUBSCRIPTION_URL_FILE_NONEMPTY=YES
MIHOMO_YAML_FILE_EXISTS=YES
MIHOMO_YAML_FILE_NONEMPTY=YES
OWNER_ONLY_ACL_DIR=PASS
OWNER_ONLY_ACL_URL=PASS
OWNER_ONLY_ACL_YAML=PASS
MIHOMO_PROFILE_PARSE=PASS
ACTIVE_CLASH_PROFILE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
WIREGUARD_BASELINE_CHANGED=NO
ROUTE_SNAPSHOT_CHANGED=NO
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## OWNER READ-BACK REQUIRED FOR FORMAL PASS

Executor PASS_CANDIDATE is not enough.

After Executor finishes, Owner must independently run:

```powershell
Get-ChildItem "C:\Users\34707\AppData\Local\vpn-network-optimization\3xui-fastpath" -Force |
Where-Object { $_.Name -in @('subscription.url','self-vpn-3xui.yaml') } |
Select-Object Name,Length,FullName
```

Formal P2 PASS requires both files visible and non-empty in that Owner-session read-back.

## MAX ENDPOINT

Repair local artifacts -> sanitized Evidence -> STOP_AT_REVIEWER.

Do not enter P3.

## OWNER_ONLY_ACTIONS

None during Executor repair. Owner read-back occurs only after PASS_CANDIDATE.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `REVIEWER_HANDOFF.md`;
3. P2 Executor Evidence;
4. the reconciliation decision.

Do not execute P3 or legacy Gates.
