# 3x-ui P3R1 — ChatGPT Three-Node Functional Smoke

Status: REVIEWER_RELEASED / OWNER_INTERACTIVE

## GATE_ID

`3XUI_FASTPATH_P3R1_CHATGPT_THREE_NODE_SMOKE`

## OBJECTIVE

Validate the three accepted 3x-ui nodes in Clash Verge using the Owner's actual final use case: normal ChatGPT conversation.

Required nodes:

- `SELF-HY2-SFO3`
- `SELF-WG-SFO3`
- `SELF-REALITY-SFO3`

## ACCEPTED BASELINE

- old standalone WireGuard remains connected as rollback protection;
- system proxy currently OFF;
- TUN OFF;
- new 3x-ui remote subscription imported and three nodes visible;
- Owner-local subscription/profile files accepted;
- general HTTPS baseline works;
- `api.openai.com/v1/models` reset occurs on old accepted baseline and is excluded from P3 acceptance.

## PER-NODE PROCEDURE

For each node, in order HY2 -> WG -> REALITY:

1. system proxy OFF;
2. TUN OFF;
3. old standalone WireGuard connected;
4. select the target node in Clash `PROXY`;
5. run one explicit local-Clash SOCKS request to `https://api.ipify.org`;
6. require public exit `143.198.159.233`;
7. enable Clash system proxy;
8. refresh the current ChatGPT page to force a fresh browser connection;
9. Owner sends one short node-test message;
10. require a normal assistant response;
11. turn system proxy OFF before moving to the next node.

No performance benchmark.

## FAILURE RULE

If explicit SOCKS egress does not match the new VPS, do not enable system proxy.

If ChatGPT fails to reload/respond after system proxy is enabled:

- turn system proxy OFF;
- restore current chat/network access;
- stop further tests;
- record that exact node as RETURN;
- do not change server configuration in this Gate.

## FINAL RESTORE

After all three PASS:

- system proxy OFF;
- TUN OFF;
- old standalone WireGuard connected;
- restore the exact pre-P3 Clash profile;
- keep the new 3x-ui subscription imported;
- no persistent route changes.

## REQUIRED EVIDENCE

```text
HY2_PUBLIC_EXIT_MATCH=YES
HY2_CHATGPT_CONVERSATION=PASS
WG_PUBLIC_EXIT_MATCH=YES
WG_CHATGPT_CONVERSATION=PASS
REALITY_PUBLIC_EXIT_MATCH=YES
REALITY_CHATGPT_CONVERSATION=PASS
SYSTEM_PROXY_FINAL=OFF
TUN_FINAL=OFF
OLD_WG_FINAL=CONNECTED
BASELINE_PROFILE_RESTORED=YES
NEW_3XUI_PROFILE_RETAINED=YES
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## OWNER_ONLY_ACTIONS

Reviewer directly guides the Owner through the bounded Clash GUI actions.

No Codex/Executor interaction is required for P3R1.

## MAX ENDPOINT

Three-node functional smoke -> baseline restore -> Reviewer decision.

Do not enter P4 automatically.
