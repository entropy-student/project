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
G3.5 UI + Growth Design Freeze             PASS
G4  WordPress → Scanner → Top 3 本地闭环    PASS
G4.5 Visual + Functional Acceptance        PASS
G4.6 Acquisition + SEO Readiness           PASS
G5  Full Fix Queue + LLM + Skill Dogfood   PASS

VPS / 支付 / 生产                          HOLD
```

G5 已正式 PASS 并合入 `main`。当前进入 G6 VPS Onboarding + Storage：只冻结和验证项目专属存储、备份恢复、Secret 元数据、Compose 隔离、资源预算与私有端口计划；不部署业务、不开放公网、不修改共享 80/443/反向代理/防火墙。

## 阅读顺序

```text
README.md
↓
PROJECT_RECORD.md
↓
docs/REVIEWER_HANDOFF.md
↓
docs/G3_5_UI_GROWTH_FREEZE.md
↓
docs/ROADMAP.md
↓
docs/EXECUTION_EVIDENCE.md
```

Codex / Executor 额外阅读：
- `docs/EXECUTOR_HANDOFF.md`
- `docs/HANDOFF_PROTOCOL.md`

## 理论资产

Canonical Skill：`entropy-student/spike.skill/independent-store-operations/`，当前 `v0.6.0`。

理论已覆盖：八段运营链、L0–L3、H1/C1/E1、店型、P0–P4、交易拓扑、Trust/Proof、经济护栏、Scanner 边界、77 条知识规则与 17 条 Scanner V0 可信规则。

本项目同时通过 `docs/SKILL_DOGFOOD_LOG.md` 反向验证该 Skill；采用某个建议本身不算验证，必须等待真实行为数据。

## 当前产品组件

### WordPress
- WordPress 7.1
- MariaDB 11.4
- SaasLauncher 2.0.18
- project Child Theme
- 6 个基础页面全部 200

G1 是功能基线，不是最终 UI。

### Scanner V0

```text
URL / DNS / SSRF Safety Gate
→ Scrapy static-first
→ bounded browser fallback
→ Normalized Facts
→ frozen Rule Engine
→ evidence-backed Issues
```

回归基线：Scanner `55/55`、Rules `51/51`、Real facts `26/26`、Real rules `28/28`、Unexpected ISSUE `0`、Geo misuse `0`。

## G3.5 — 为什么先设计再交给 Codex

必须先冻结：
- customer journey / Activation；
- Home / Scan / Progress / Free Top 3 / Pricing / Full Report；
- Trust / Proof / Offer / CTA；
- desktop + mobile high-fidelity；
- Design System；
- loading / error / incomplete states；
- analytics events；
- visual + functional acceptance。

`clone-ui` 只用于视觉参考提取，不允许直接大面积改写产品源码。

高保真将通过 Golden Screenshot + Playwright visual regression 落地，而不是只给 Codex 一张参考图。

## Token / API

免费扫描核心路径原则上零 LLM Token：Scrapy、浏览器提取、Rule Engine、WordPress、Top 3 都是代码。

LLM 后续只解释结构化 Issue。API Key 只进入运行环境 Secret Store / 环境变量，不进入聊天或 GitHub。

## Payment

支付现拆成两个阶段：`G6.5` 先做本地 Payment + Entitlement 闭环，`G9` 再做真实支付 Provider 验收。

当前暂定：**Direct PayPal**。

Unified Pay 目前尚未跑通并需要单独修改，因此不作为本项目当前依赖。G6.5 不要求真实支付接口或公网；G9 在 HTTPS 就绪后再做真实 Provider / Webhook 验收。

## 当前下一步

`G6 — VPS Onboarding + Storage`

```text
Codex reads docs/G6_EXECUTION_CONTRACT.md
→ target VPS read-only preflight
→ freeze resource budget
→ create project-owned /srv landing zone
→ freeze Compose/storage/Secret metadata
→ backup + disposable restore canaries
→ rollback plan
→ PASS_CANDIDATE_G6
→ Reviewer independent PASS / RETURN
```

G7 private application deployment remains HOLD until G6 Reviewer PASS.


## 本地目录约定

```text
project-github-sync/  = 正式 Git 项目
workspaces/           = 当前活跃 Gate 工作区
_project-artifacts/   = 截图 / ZIP / Reviewer package / 本地证据
```

每个 Gate 在 Reviewer PASS + merge 后，应执行一次 bounded hygiene：
- 清理已合并且干净的 Gate workspace；
- 将最终本地证据归档到 `_project-artifacts/conversion-leak-audit/archives/<gate>/`；
- 保留 final review package + MANIFEST；
- 不自动删除 ownership 不明的临时目录。

详见：`docs/LOCAL_WORKSPACE_HYGIENE.md`。
