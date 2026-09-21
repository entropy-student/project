# Conversion Leak Audit — Interaction States

Status: `FROZEN_G3_5`

## 1. URL Form State Machine

```text
IDLE
→ TYPING
→ VALIDATING
├→ INVALID
├→ UNSAFE_REJECTED
└→ READY
    → SUBMITTING
    ├→ JOB_CREATED
    └→ CREATE_FAILED
```

Rules：
- invalid/unsafe 不创建 scan job；
- submitting 时 primary button disabled，避免重复创建；
- error 不清空用户输入；
- unsafe message 对用户描述边界，不泄露内部网络安全细节。

## 2. Scan State Machine

```text
QUEUED
→ CHECKING_ACCESS
→ READING_PAGES
→ MATCHING_EVIDENCE
→ PRIORITIZING
├→ COMPLETE
├→ INCOMPLETE
└→ FAILED
```

前端只显示后端真实状态或真实状态的稳定映射。

禁止独立 timer 推进虚假阶段。

## 3. Progress presentation

### QUEUED
文案：准备扫描。

### CHECKING_ACCESS
文案：正在确认网站是否可以安全读取。

### READING_PAGES
文案：正在检查公开页面与购买相关信息。

如果已知真实 page count，可以显示：`已检查 3 / 6 页`。

### MATCHING_EVIDENCE
文案：正在把观察到的事实与可信规则匹配。

### PRIORITIZING
文案：正在整理最值得先看的问题。

### COMPLETE
进入结果页。

## 4. Incomplete state

Reason mapping：

```text
RATE_LIMITED
BLOCKED
LOGIN_REQUIRED
JS_INCOMPLETE
GEO_CONTEXT_MISMATCH
SITE_UNAVAILABLE
UNKNOWN_FAILURE
```

UI 必须：
- 明确扫描未完整完成；
- 不显示虚构 Top 3；
- 给出可重试与否；
- 保留 scan reference 以便支持/调试；
- 不把 failure 说成商家网站缺陷。

## 5. Top 3 states

### 3 findings
标准 Top 3。

### 1–2 findings
诚实显示实际数量，不补齐三条。

### 0 findings
不能写“你的网站完美”。

推荐：
> 在本次可审计范围内，没有发现首版可信规则能够确认的高优先级问题。

并解释扫描边界。

## 6. Finding card states

```text
COLLAPSED
→ HOVER/FOCUS
→ EVIDENCE_OPEN
→ EVIDENCE_CLOSE
```

Mobile：Evidence open 使用 full-screen/bottom-sheet pattern。

## 7. Paid expansion states

G3.5–G5：
- VIEW_PREVIEW
- VIEW_FREE_VS_FULL

G9 才允许：
- CHECKOUT_STARTING
- CHECKOUT_REDIRECT
- PAYMENT_PENDING
- PAYMENT_SUCCESS
- PAYMENT_FAILED

当前这些支付状态只保留接口语义，不实现。

## 8. Analytics coupling

事件必须跟状态变化绑定：
- `scan_started` = JOB_CREATED；
- `scan_completed` = COMPLETE；
- `scan_incomplete` = INCOMPLETE；
- `top3_viewed` = result viewport actually rendered；
- `issue_expanded` = evidence detail opened；
- `payment_completed` = future server-confirmed payment truth。

## 9. Retry rules

允许用户重试：
- transient create failure；
- SITE_UNAVAILABLE；
- UNKNOWN_FAILURE；
- 部分 rate-limit 情况（应加入冷却提示）。

不应提示立即重试：
- unsafe/private target；
- login-required site；
- persistent geo-context mismatch，除非未来支持地区选择。

## 10. Loading UX

- 不用 fake terminal；
- 不用 AI thinking 文案；
- 可使用轻量 skeleton / progress steps；
- 页面刷新后如果 scan_id 有效，应恢复当前状态；
- 结果完成后不能因为动画阻止用户立即阅读。
