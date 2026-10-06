# 3x-ui Fast Path P2 — Executor Evidence

Execution date: 2026-10-06
Gate: `3XUI_FASTPATH_P2_SECURE_MIHOMO_DELIVERY`
Target: `143.198.159.233`
Result: `PASS_CANDIDATE`

## Sanitized acceptance markers

```text
P1_FORMAL_PASS=YES
DELIVERY_MODE=VALID_HTTPS_IP_SUBSCRIPTION
ACME_IP_ATTEMPT=PASS
HTTPS_CERT_NORMAL_VALIDATION=PASS
HTTPS_CERT_IP_SAN=PASS
CERT_AUTO_RENEW=PASS
PUBLIC_REAL_MIHOMO_STATUS=200
PUBLIC_RANDOM_SUB_NEGATIVE=PASS
TCP_2096_TLS_NOT_PLAINTEXT=PASS
SUB_ENABLE=YES
SUB_2096=TLS
SUB_CLASH_ENABLE=YES
PROXY_COUNT=3
PROXY_NAMES=SELF-HY2-SFO3,SELF-WG-SFO3,SELF-REALITY-SFO3
HY2_PROFILE_SHAPE=PASS
HY2_CERT_PIN_PRESENT=YES
HY2_SKIP_CERT_VERIFY=NO
WG_PROFILE_SHAPE=PASS
REALITY_PROFILE_SHAPE=PASS
PROXY_GROUP_ORDER=PASS
FINAL_RULE_MATCH_PROXY=PASS
WINDOWS_OWNER_ONLY_PROFILE=PASS
WINDOWS_OWNER_ONLY_SUB_URL=PASS
MIHOMO_PROFILE_PARSE=PASS
ACTIVE_CLASH_PROFILE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
WIREGUARD_BASELINE_CHANGED=NO
ROUTE_SNAPSHOT_CHANGED=NO
ADMIN_LOOPBACK_ONLY=YES
XRAY_RUNTIME_HEALTHY=YES
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
P3_STARTED=NO
```

The certificate is installed at the Gate-fixed paths; its IP SAN validates, its private key mode is `600`, and acme.sh renewal metadata includes a cron entry and an x-ui restart hook. The panel remains loopback-only; the subscription listener serves TLS on TCP/2096. The public real Mihomo endpoint returned 200 using normal Windows system certificate validation. A random nonexistent Sub ID returned 404 without node data.

The protected Windows files are `%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\self-vpn-3xui.yaml` and `subscription.url`; each has inheritance disabled and only the current Owner SID. The installed Clash Verge Mihomo v1.19.32 parsed the staged profile successfully. The current profile metadata hashes, Clash/Mihomo process state, system proxy state, TUN adapters, standalone WireGuard service/tunnel, and live route snapshot match the pre-P2 baseline. No profile was imported or activated.

Final target resource read-back: RAM `458 MB` total / `209 MB` available, swap `1023 MB`, root filesystem `5249 MB` free. The three P1 inbounds and shared-client attachment count remain unchanged.

P2 executor work is complete. Stop at reviewer; P3 remains unreleased and unstarted.
