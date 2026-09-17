# Conversion Leak Audit — UI + Growth Brief

Status: `DRAFT_FOR_OWNER_REVIEW`
Gate: `G3.5_UI_GROWTH_DESIGN_FREEZE`

## 1. Product job

Target user:

> 已经在经营独立站、已有访问或广告投入，但不知道“为什么有人来却不买”的小商家 / 独立站经营者。

Core job:

> 在继续买流量之前，先用公开页面证据找到最值得优先检查的站内购买摩擦。

V1 claim boundary:

> 发现可观察到的站内因素，这些因素可能增加购买犹豫、不信任或操作阻力。

禁止：root cause / exact revenue loss / guaranteed uplift。

## 2. Growth hypothesis

### Core free Activation / Aha candidate

```text
landing_view
→ scan_started
→ scan_completed
→ top3_viewed
→ 用户看到“这是我网站上的具体事实，而且确实值得先修”
= PRE_TRANSACTION ACTIVATION candidate
```

Activation 不是“完成扫描”，而是用户首次相信结果与自己网站具体相关并具有行动价值。

### Free value

免费层必须给出完整但有限的一次胜利：
- 3 个最值得先看的问题；
- 每个问题都有真实观察事实；
- 每个问题都有证据来源；
- 简短说明“为什么值得关注”；
- 一个可执行的修复方向。

不能故意隐藏证据来制造付费焦虑。

### Paid expansion（后续 G5/G9）

付费不是“把被遮住的文字显示出来”，而是扩展：
- Scope：完整 Fix Queue；
- Depth：更完整解释；
- Prioritization：排序与行动计划；
- Personalization：基于当前站点上下文；
- Continuity：报告保存 / 后续复查能力；
- Certainty：更明确的证据、边界与下一验证动作。

支付暂定在 G9 使用 Direct PayPal；G3.5 不实现支付。

## 3. Competitive UX observations

当前 URL Audit 类产品普遍采用：
- Hero 直接输入 URL；
- 无需注册 / 无需后台权限；
- 明确预计等待时间；
- Sample Report；
- 免费结果 → 付费扩展。

本项目不复制其常见问题：
- 不使用不可解释的总分作为核心价值；
- 不制造“损失了 $X 收入”类伪精确；
- 不让 AI 自由从整页 HTML 生成泛建议；
- 不用大量 category score 掩盖证据本身。

核心视觉概念：

> **Evidence-first Diagnostic**

用户第一眼看到的不是“72 分”，而是“我们发现了什么事实”。

## 4. Primary user journey

```text
Landing
↓
理解：这是给“有流量但订单偏少”的站点
↓
Trust strip：公开页面 / 无后台权限 / 不改网站
↓
输入 URL
↓
Scan progress（真实阶段，不伪造百分比）
↓
Top 3
↓
Evidence / why it matters / first fix direction
↓
用户展开 issue 或查看完整报告价值
↓
Pricing / Paid Expansion explanation
↓
（未来 G9）Checkout
```

## 5. Homepage information hierarchy

### Section 1 — Hero / Immediate action

Headline direction:

> 别急着再买流量，先看看你的网站在哪里漏单。

Supporting copy:

> 输入公开店铺网址。我们会检查可验证的页面事实，找出最值得优先关注的购买摩擦，并免费给你 Top 3。

Primary CTA:
- URL input + `扫描我的网站`

Trust microcopy directly under form:
- 无需注册；
- 无需后台权限；
- 不会修改你的网站；
- 只检查公开可访问页面；
- 通常几十秒内得到结果（最终文案按真实性能校准）。

Hero secondary action:
- `查看示例报告`

### Section 2 — What you actually get

用 3 张真实结果卡预览，而不是功能列表：
- Observed fact；
- Evidence；
- Why it matters；
- First fix direction。

### Section 3 — Why this is different

三点即可：
1. 证据优先，不靠泛 AI 感觉；
2. 只报告机器有资格判断的内容；
3. 告诉你先修什么，而不是给几十条 checklist。

### Section 4 — How it works

```text
Paste URL
→ Inspect public pages
→ Match trusted rules
→ Get Top 3
```

### Section 5 — Claim / limitation transparency

主动说明：
- 公共页面扫描无法知道全部成交原因；
- 报告不是收入损失计算器；
- 它是低成本的第一层诊断入口。

这本身是 Trust Proof。

### Section 6 — Sample report / proof

首发没有真实客户案例时：
- 使用明确标记为 Demo 的公开站样例；
- 不伪造 testimonial；
- 展示 Evidence-backed issue 结构。

### Section 7 — Paid expansion preview

不急着硬卖。
说明完整报告增加什么，而不是说“剩余 24 个问题已锁定”。

## 6. Trust model by stage

### Before scan
用户风险：
- 你会不会抓我的后台？
- 会不会修改网站？
- 这是不是真的？

Proof：
- Public pages only；
- No admin access；
- No install；
- Scanner boundary transparency。

### During scan
用户风险：
- 卡住了吗？
- 你真的在做事吗？

Proof：
- 显示真实阶段：Access → Pages → Evidence → Priority；
- 不显示虚假的 73% 进度；
- blocked / incomplete 明确说明。

### Top 3
用户风险：
- 这些是不是 AI 编的？

Proof：
- fact；
- page/source locator；
- confidence / applicability；
- claim boundary。

### Before paid expansion
用户风险：
- 付钱以后到底多什么？

Proof：
- 对比 Free vs Full 的增量价值；
- 不用模糊“Premium insights”。

## 7. Offer architecture

### Free
`Top 3 Evidence-backed Findings`

### Future paid
`Complete Fix Queue + Priority Action Plan + Explanation`

价格暂不在 G3.5 冻结；支付暂定 Direct PayPal，并后移至 G9。

## 8. Design direction

Recommended direction: **Editorial Diagnostic Console**

关键词：
- clean；
- evidence-led；
- serious but not enterprise-heavy；
- bold hierarchy；
- warm signal accent；
- high whitespace；
- no AI-neon / cyber gimmick；
- no giant opaque score gauge。

页面应像“一个非常清楚的专业诊断工具”，而不是 SEO 工具目录或 AI chatbot。

## 9. Owner approval required later

G3.5 最终 PASS 前仍需 Owner 看到并批准：
- desktop golden screens；
- mobile golden screens；
- Home；
- Scan Progress；
- Free Top 3；
- Full Report shell。

当前文件先冻结产品/增长逻辑，不代表视觉高保真已 PASS。
