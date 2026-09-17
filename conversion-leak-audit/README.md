# Conversion Leak Audit（独立站转化漏损诊断）

面向**已经有流量、但订单偏少**的独立站商家：输入公开店铺 URL，系统通过受限扫描找出可观察到的购买犹豫、信任损失和操作摩擦，免费展示 Top 3，再逐步解锁完整修复队列。

> 核心卖点：**别急着再买流量，先看看你的网站在哪里漏单。**

## 当前状态

```text
P0  产品 / 治理立项                         PASS
P0A WordPress-first                        PASS
P0B 最终目标 = Shared VPS 正式上线          PASS
PF  理论 / 规则 / 开发前验证                PASS

G1  WordPress Local Baseline               PASS
G2  Safe Scanner V0                        PASS
G3  Rule Engine V0                         MERGED / CLOSED
G4  WordPress → Scanner → Top 3 本地闭环    NEXT

VPS / 支付 / 生产                          HOLD
```

当前不是继续研究理论，而是进入**本地产品闭环**阶段。

## 阅读顺序

```text
README.md
↓
PROJECT_RECORD.md
↓
docs/REVIEWER_HANDOFF.md
↓
docs/ROADMAP.md
↓
docs/EXECUTION_EVIDENCE.md
```

如果由 Codex / Executor 接手，再读：

- `docs/EXECUTOR_HANDOFF.md`
- `docs/HANDOFF_PROTOCOL.md`

## 理论资产

独立站运营理论不在本项目重复维护。

Canonical Skill：

- Repository: `entropy-student/spike.skill`
- Path: `independent-store-operations/`
- Current version: `v0.6.0`

理论体系已经覆盖：八段运营链、L0–L3 证据层、H1/C1/E1 规则类型、店型、信息距离 P0–P4、交易拓扑、Trust/Proof、经济护栏、Scanner 能力边界、77 条知识规则与 17 条 Scanner V0 可信规则。

## 当前产品组件

### WordPress

已验证本地基线：

- WordPress 7.1
- MariaDB 11.4
- SaasLauncher 2.0.18
- 项目 Child Theme
- Home / How it works / Demo / Pricing / FAQ / Blog
- 6 / 6 页面 HTTP 200

### Scanner V0

Python 实现，采用：

```text
URL / DNS / SSRF Safety Gate
→ Scrapy static-first
→ bounded browser fallback
→ Normalized Facts
→ frozen Rule Engine
→ evidence-backed Issues
```

当前回归基线：

- Scanner project tests: `55 / 55 PASS`
- Rule fixtures: `51 / 51`
- Real-network facts: `26 / 26`
- Real rule assertions: `28 / 28`
- Unexpected ISSUE: `0`
- Geo context misuse: `0`

## Claim Boundary

V1 只允许声称：

> 发现可观察到的站内因素，这些因素可能增加购买犹豫、不信任或操作阻力。

不得声称：

- 找到了没有订单的真正根因；
- 能精确计算收入损失；
- 保证提高转化率。

## 当前下一步

`G4 — WordPress → Scanner → Top 3 Local Integration`

目标：

```text
WordPress URL input
→ create scan job
→ progress/status
→ Scanner V0
→ evidence-backed findings
→ Top 3
→ WordPress free result page
```

限制：local only / no payment / no VPS / no production secret / no public production scanner。
