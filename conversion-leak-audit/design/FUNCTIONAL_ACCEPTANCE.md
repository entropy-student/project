# Conversion Leak Audit — Functional Acceptance

Status: `FROZEN_G3_5_ACTIVE_FOR_G4`

本文件定义 Codex 后续实现必须满足的功能契约。视觉 PASS 不能替代功能 PASS。

## 1. Home

必须：
- URL form 可键盘操作；
- 无效 URL 显示 inline error；
- unsafe/private target 不创建 job；
- primary CTA 状态清晰；
- sample report 可访问；
- 不要求登录即可开始免费扫描。

## 2. Scan job creation

提交有效公开 URL 后：
- 创建 job；
- 返回 scan_id；
- 前端进入 progress state；
- 多次点击不可创建不可控重复 job；
- 网络异常有明确可重试状态。

## 3. Progress

必须映射真实后端状态，至少：
- queued；
- checking access；
- scanning / reading pages；
- matching evidence；
- prioritizing；
- completed；
- incomplete；
- failed。

禁止：
- 独立前端 timer 假装后端有进度；
- 后端失败但 UI 一直 loading。

## 4. Incomplete / error

若 Scanner 返回 fail-closed：
- UI 不生成任何虚构 Top 3；
- 显示真实可公开错误类别；
- 不暴露内部 IP / resolver / stack trace；
- 可重试时给 retry；不可重试时解释边界。

## 5. Top 3

必须：
- 只来自 Scanner 返回的 evidence-backed finding；
- 最多 3 个；
- deterministic ordering；
- 每个 finding 有 evidence reference；
- issue detail 可打开；
- Finding 文案必须保持 claim boundary；
- 不从 raw HTML 临时调用 LLM 补内容。

## 6. Evidence detail

必须显示：
- source page / normalized location；
- observed fact；
- rule or evidence type；
- why it may matter；
- limitation/applicability when present。

不得默认显示完整 raw HTML。

## 7. Paid expansion preview

G4/G4.5：
- 可以进入“完整报告包含什么”页面/区块；
- 不能发起真实 PayPal 订单；
- checkout_started/payment_completed 事件不得伪造。

真实支付延后 G9。

## 8. Analytics

实现后事件必须符合 `ANALYTICS_EVENT_CONTRACT.md`。

G4 可先采用 analytics adapter/no-op provider，事件接口先固定。

必须保证：
- payment_completed 不由 client click 触发；
- 不把 raw HTML 发进 analytics；
- 默认不把完整被扫 URL 当行为属性。

## 9. Persistence

Local phase：
- scan job/report 在正常本地服务重启后保持符合现有 Scanner persistence contract；
- WordPress 不复制一套 Scanner truth；
- WordPress 保存映射/展示所需最小状态即可。

## 10. Security

必须保持 G2：
- public URL only；
- private / localhost / metadata blocked；
- redirect revalidation；
- fail closed；
- browser 不绕过 explicit block/rate limit；
- Scanner internal API 不因 UI 集成而直接无限公开。

## 11. Functional test set

Codex 至少覆盖：

```text
valid_url_happy_path
invalid_url
unsafe_private_url
scanner_unavailable
scan_incomplete
scan_completed_0_findings
scan_completed_1_2_findings
scan_completed_3plus_findings
evidence_expand
refresh_result_page
mobile_form_submit
analytics_event_contract
no_payment_call_before_g9
```

## 12. PASS condition

G4 功能实现只有在：
- tests pass；
- Reviewer 能重现实测；
- evidence no fabrication；
- error states complete；
- G1/G2 regression still pass；

时才可进入 G4.5 视觉验收。
