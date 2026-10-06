# Reviewer Decision — 3x-ui P0 Fresh VPS Bootstrap Install PASS

Status: PASS

Date: 2026-10-06

## Gate

`3XUI_FASTPATH_P0_FRESH_VPS_BOOTSTRAP_INSTALL`

Executor candidate commit:

`e8b57860f1a70462f3f3bd9d30e37baecc706ebd`

## Accepted evidence

- Owner host-key fingerprint match: PASS
- explicit known_hosts trust: PASS
- strict SSH: PASS
- target identity: PASS
- fresh target: PASS
- target ports 443/TCP, 8443/UDP, 51820/UDP free before and after install
- no legacy VPN runtime
- 3x-ui pre-existing: NO
- 3x-ui version: v3.9.0
- SQLite: active backend
- x-ui service: active
- install-result metadata: root:root / 0600 / non-empty
- install-result contents: not read or emitted
- panel config: 127.0.0.1:54912
- panel public binding: NO
- RAM: 458 MB total / 210 MB available
- swap: 0 MB
- root free: 6276 MB
- x-ui RSS: 90 MB
- OOM kill counter: 0
- Secret values emitted: 0
- old VPS mutation: NO
- P0 inbounds created: NO

## Listener classification

Executor reported a second x-ui process listener at `*:2096`.

Reviewer inspected 3x-ui v3.9.0 source and documentation:

- `main.go` starts the admin web server and a separate subscription server.
- `internal/web/service/setting.go` defaults `subEnable=true`, `subPort=2096`, `subListen=""` (all interfaces).
- `internal/sub/sub.go` starts that listener only when `subEnable` is true.
- Subscription routes require a `:subid`; nonexistent IDs return 404.
- No client/subscription object exists at P0.

Therefore `*:2096` is the expected subscription server, **not an admin-panel exposure**, and it does not invalidate the P0 acceptance criterion `PANEL_PUBLICLY_BOUND=NO`.

## Security follow-up

Before P1 creates any client, the subscription server must be temporarily disabled and `*:2096` must close. P2 will later re-enable it only after the HTTPS/Mihomo subscription boundary is explicitly configured and verified.

## Formal result

```text
P0_RESULT=PASS
PANEL_ADMIN_LOOPBACK_ONLY=YES
SUBSCRIPTION_LISTENER_CLASS=EXPECTED_DEFAULT_PUBLIC_SERVER
SUBSCRIPTION_CLIENT_CONTENT_PRESENT=NO
P1_MUST_CONTAIN_SUB_SERVER_BEFORE_CLIENT_CREATE=YES
OLD_VPS_MUTATION=NO
```
