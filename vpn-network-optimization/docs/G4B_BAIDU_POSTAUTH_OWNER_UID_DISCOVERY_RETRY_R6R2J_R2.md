# G4-B Baidu Post-Auth Owner UID Discovery Retry R6R2J-R2

Status: ACTIVE / OWNER_LOCAL_READ_ONLY / ONE_SHOT

## GATE_ID

`G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_RETRY_R6R2J_R2`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1`

## LOCKED SOURCE

```text
UID_HELPER_BLOB=ebba88863d55d74956d3b745eab8f0f18a7d1dee
UID_VALIDATOR_BLOB=59a6bd86cf021986b7e8066fa08108e9435852c5
```

The authenticated Baidu config remains accepted/frozen. No re-authentication is authorized.

## OBJECTIVE

Run exactly one Owner-local read-only UID discovery using the repaired parser and the already authenticated config.

The numeric UID is local-only and must never enter chat, GitHub, Evidence, logs, screenshots, or normal files.

## OWNER SHELL

PowerShell 7.6.6, Administrator / High integrity, accepted Owner Windows host.

Before execution, verify the helper blob exactly matches the locked source above.

## ALLOWED REAL ACTIONS

The reviewed helper may:

- inspect the accepted config metadata/ACL/location;
- download and verify the already pinned BaiduPCS-Go v4.0.2 archive into a temporary Owner-only runtime;
- execute exactly one read-only `who`;
- parse exactly one canonical `当前帐号 uid: <numeric>, ...` line;
- display the numeric UID only on the local Owner console;
- remove the temporary runtime.

## FORBIDDEN

- login/re-authentication;
- auth material input/output;
- config-content print/copy/edit/delete;
- provider upload/download/mkdir/mv/rm;
- UID disclosure outside the local console;
- VPS/SSH/Clash/service/route/proxy/TUN changes;
- G4-B deployment or G4-C workloads.

## OWNER RETURN CONTRACT

Do not paste the numeric UID or provider raw output.

Return only:

```text
BAIDU_UID_DISCOVERY=...
UID_DISPLAYED_LOCALLY=YES|NO
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=...
BAIDU_UID_FAILURE_CODE=...
BAIDU_UID_RUNTIME_CLEANUP=...
OWNER_REMINDER=...
```

## SUCCESS

```text
BAIDU_UID_DISCOVERY=READY
UID_DISPLAYED_LOCALLY=YES
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES
BAIDU_UID_FAILURE_CODE=NONE
BAIDU_UID_RUNTIME_CLEANUP=PASS
```

On any non-success, do not retry again under this Gate.

`STOP_AT_REVIEWER=YES`
