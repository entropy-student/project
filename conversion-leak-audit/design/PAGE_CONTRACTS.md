# Conversion Leak Audit — Page Contracts

Status: `DRAFT_FOR_G3_5`

Codex 后续实现时，每个页面都必须满足“目的 / 用户问题 / 必须内容 / 禁止内容 / 状态 / CTA / 证据”合同。

## 1. Home / Landing

### Job
让目标用户在 5–10 秒内回答：
- 这是给谁的？
- 它做什么？
- 我需要提供什么？
- 风险是什么？
- 下一步是什么？

### Must contain
- 明确 Problem framing：已有流量但订单偏少；
- URL input；
- Primary CTA：扫描我的网站；
- Public only / no admin / no install / no modification；
- Sample report entrance；
- What you get preview；
- evidence-first difference；
- limitation transparency；
- paid expansion preview；
- FAQ / privacy / terms入口。

### Must NOT contain
- guaranteed uplift；
- exact revenue loss；
- fabricated testimonials；
- fake scan count / fake customer count；
- giant opaque conversion score as core promise。

### Primary success event
`scan_started`

---

## 2. Scan Input State

### Required states
- empty；
- typing；
- invalid URL；
- unsafe/private URL rejected；
- accepted / submitted；
- temporary failure。

### Contract
- 用户不需要创建账号；
- URL 输入不允许暗示需要后台登录；
- unsafe URL 错误必须说明“只支持公开网站”，不能暴露内部安全实现细节。

---

## 3. Scan Progress

### Job
降低等待焦虑，同时诚实表达系统状态。

### Stage model

```text
CHECKING_ACCESS
→ READING_PAGES
→ MATCHING_EVIDENCE
→ PRIORITIZING
→ COMPLETE
```

### Rules
- 不伪造线性百分比；
- 如果后端能提供真实 page count，可显示“已检查 3 / 6 页”；
- browser fallback 不作为营销卖点暴露；
- 超时 / block / rate limit 转入明确 incomplete state。

### Copy principle
描述“系统正在做什么”，不要说“AI 正在思考”。

---

## 4. Scan Incomplete / Blocked / Error

必须区分：
- site unavailable；
- rate limited；
- blocked；
- login required；
- region/context mismatch；
- dynamic page incomplete；
- unknown technical failure。

### UI principle
Fail closed is a feature.

显示：
- 我们能确认什么；
- 为什么不能继续；
- 用户可以做什么；
- 是否可重试。

禁止：
- 在证据不完整时仍生成 Top 3；
- 把 crawler failure 描述为商家网站问题。

---

## 5. Free Top 3 Results

### Job
制造真正的 Aha，而不是制造焦虑。

### Summary header
建议显示：
- `我们找到 3 个最值得先看的点`
- 扫描范围概览，例如页面数量 / 交易类型（仅当真实已知）；
- claim boundary microcopy。

不建议把“总分”放在第一视觉中心。

### Finding card contract
每张卡至少包含：
1. Priority badge：`先看这个 / Next / Later` 或 P1/P2/P3；
2. Finding title；
3. **Observed fact**；
4. **Evidence**：page / locator / structured source；
5. Why it may matter；
6. First fix direction；
7. Confidence / applicability when relevant；
8. Expand details。

### Example structure

```text
退货信息离购买决策太远

Observed
产品页和购买区域未发现退货入口；当前只在深层帮助页找到。

Evidence
/product/example → no return link
/help/returns → policy found

Why it may matter
高考虑型商品的风险信息离购买位置较远，可能增加不确定性。

First move
在商品购买区域增加清晰的退货摘要和政策入口。
```

### CTA after Top 3
Primary：`查看完整修复队列`
Secondary：`查看这些证据是怎么判断的`

G3.5/G4 阶段 primary 可先进入 paid-expansion preview，不进入真实支付。

---

## 6. Issue Detail / Evidence Drawer

Purpose：证明“不是 AI 随便说”。

Must contain：
- finding；
- exact observed fact；
- source page；
- evidence type；
- rule explanation；
- applicability / limitations；
- suggested first move。

Optional：
- screenshot crop（后续）；
- technical source / JSON-LD excerpt（折叠显示）。

不能直接暴露大量原始 HTML。

---

## 7. Pricing / Paid Expansion Preview

G3.5 不冻结价格，只冻结价值边界。

Free vs Full 必须写清楚：

| Free | Full |
|---|---|
| Top 3 | Complete Fix Queue |
| Evidence | More complete evidence context |
| First move | Prioritized action plan |
| Bounded explanation | Personalized detailed explanation |
| Single scan value | Future continuity/history if built |

禁止把免费层故意做残。

支付 Provider 当前 tentative = Direct PayPal，但此页面在 G9 前不能调用真实支付。

---

## 8. Full Report Shell

G5 才实现完整价值，但 G3.5 要冻结骨架。

Recommended hierarchy：

```text
Executive Summary
↓
Top Priorities
↓
Complete Fix Queue
↓
Evidence Detail
↓
Action Plan
↓
What needs measurement / experiment
↓
Limitations
```

关键区别：
- FIX 和 EXPERIMENT 分开；
- L0/L1 不能冒充 L3；
- 不能把所有建议都叫“critical”。

---

## 9. Mobile contract

Mobile 不是桌面缩小版。

要求：
- Hero URL form 首屏可见；
- Primary CTA 无需横向滚动；
- Finding card Evidence 折叠；
- 优先级与标题在第一屏内可理解；
- Drawer 转为 bottom sheet / full-screen detail；
- progress state 不使用过宽 timeline；
- 表格转 cards / stacked rows。

Target golden viewport：`390 × 844`。
Desktop golden viewport：`1440 × 900`。
