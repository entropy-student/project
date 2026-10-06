# Reviewer Decision — P2 PASS with Remote Transfer Cleanup Deferred

Status: PASS

Date: 2026-10-07

## Decision

P2 is formally accepted.

The two temporary transfer files under:

```text
/root/3xui-owner-transfer/subscription.url
/root/3xui-owner-transfer/self-vpn-3xui.yaml
```

are intentionally retained for now and their cleanup is deferred to P4 closeout.

## Why cleanup is not a P3 blocker

Fresh accepted evidence proves:

- the Owner-local final files exist at the real Owner Windows paths;
- both local files are non-empty;
- Owner-only ACLs are correct;
- the Owner-visible Mihomo YAML parses successfully;
- the remote transfer directory is root-only `0700`;
- both transfer files are root-only `0600`;
- the transfer copies are on the already trusted new VPS and are not public-serving paths;
- no Secret value or Secret-derived hash was emitted;
- the HTTPS subscription service and three-node server state remain accepted.

Therefore the remote transfer copies are a closeout hygiene item, not a functional or security boundary that must block Clash import/smoke.

## Deferred obligation

```text
REMOTE_TRANSFER_CLEANUP=DEFERRED_TO_P4
DEFERRED_STATUS=DEFERRED_NOT_PASS
P2_FORMAL_PASS=YES
P3_MAY_PROCEED=YES
```

P4 must re-check the exact remote staging path before deletion and remove it only if the same two expected files remain and no new dependency was introduced.

## Accepted P2 final state

```text
HTTPS_MIHOMO_SUBSCRIPTION=PASS
OWNER_LOCAL_SUBSCRIPTION_URL=PASS
OWNER_LOCAL_MIHOMO_YAML=PASS
OWNER_LOCAL_ACL=PASS
OWNER_LOCAL_MIHOMO_PARSE=PASS
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
REMOTE_TRANSFER_CLEANUP=DEFERRED_TO_P4
```
