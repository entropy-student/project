# Shared VPS Infrastructure

> Shared Hostinger VPS 的运行环境索引。  
> 本目录记录 **Shared VPS 当前环境真相与跨项目资产索引**，不替代各业务项目自己的 `REVIEWER_HANDOFF.md`。

## 当前主机

```text
HOSTNAME=srv1970241
OS=Ubuntu 24.04
CPU=2 vCPU
RAM≈7.8 GiB
ROOT_DISK≈96 GiB
ROOT_USED≈11 GiB
ROOT_AVAILABLE≈86 GiB
```

当前共享基础设施包括：

- Caddy
- cloudflared
- `spikersun-edge`
- `spikersun-private`
- Shared VPS SSH / Hostinger Browser Terminal 访问边界

## 当前业务 Runtime

- Xianyu
- Dujiao-Next
- Unified Pay
- Mini Craft Night Kit

完整总览：

- [`REVIEWER_HANDOFF.md`](./REVIEWER_HANDOFF.md) — Shared VPS 当前唯一环境级 Reviewer 真相
- [`SHARED_VPS_PORTFOLIO.md`](./SHARED_VPS_PORTFOLIO.md) — 项目资产索引

## 原则

1. Governance 规则来自 `entropy-student/spike.skill/vps-project-governance`。
2. 本目录记录 Shared VPS 的当前实际状态，不复制 Governance 规则。
3. 每个业务项目的深层状态仍以其自己的 `REVIEWER_HANDOFF.md` 为准。
4. UNKNOWN 不因“看起来没用”而删除。
5. Secret 值不得进入本目录。
