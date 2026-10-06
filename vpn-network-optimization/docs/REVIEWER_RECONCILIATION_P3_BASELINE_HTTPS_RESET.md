# Reviewer Reconciliation — P3 Baseline HTTPS Reset Before Node Attribution

Status: RETURN_BASELINE_NETWORK_PATH

Date: 2026-10-07

## Trigger

During P3, Owner imported the accepted three-node subscription and selected HY2. The first bounded probe failed at TLS handshake. Reviewer then instructed a read-only DIRECT control inside the same Clash profile and an additional Windows-direct control.

Observed Owner evidence:

```text
WINDOWS_DIRECT_OPENAI_HTTP=000
WINDOWS_DIRECT_OPENAI_EXIT=35
CLASH_DIRECT_SOCKS5_OPENAI_HTTP=000
CLASH_DIRECT_SOCKS5_OPENAI_EXIT=35
CLASH_DIRECT_SOCKS5H_OPENAI_HTTP=000
CLASH_DIRECT_SOCKS5H_OPENAI_EXIT=35
CLASH_DIRECT_PLAIN_HTTP_EXIT=52
```

Representative errors:

- Windows direct: connection reset during TLS;
- Clash DIRECT via SOCKS: Schannel TLS handshake failure;
- plain HTTP through Clash DIRECT: empty reply.

## Reviewer interpretation

The failure is not attributable to HY2 because the control path fails even with Clash selector `DIRECT`, and the Windows-direct request also fails.

P3 node smoke is therefore invalidated by a broken/uncertain baseline network path before protocol attribution.

No WG or REALITY node smoke is authorized until baseline connectivity is reconciled.

## Required immediate state

- stop P3 node testing;
- restore the exact pre-P3 Clash profile;
- keep the new 3x-ui subscription imported;
- keep system proxy OFF;
- keep TUN OFF;
- keep standalone old WireGuard connected;
- do not mutate either VPS;
- run one Owner-host read-only baseline diagnostic.

## Classification

```text
P3_RESULT=RETURN_BASELINE_NETWORK_PATH
HY2_RESULT=UNVERIFIED
WG_RESULT=NOT_TESTED
REALITY_RESULT=NOT_TESTED
SERVER_REPAIR_AUTHORIZED=NO
P3_RETRY_AUTHORIZED=NO
```
