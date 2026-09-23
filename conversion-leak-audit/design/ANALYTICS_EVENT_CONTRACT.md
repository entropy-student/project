# Conversion Leak Audit — Analytics Event Contract

Status: `FROZEN_G3_5`

目标：把本项目做成可验证产品，而不是只看页面“感觉不错”。

G3.5 只冻结事件语义，不强制现在接入 PostHog 或其他 Provider。

## 1. Core funnel events

### `landing_view`
用户看到落地页。

Properties：
- `referrer_type`
- `campaign_source`（如有）
- `device_class`
- `locale`

禁止上传完整敏感 URL query。

### `scan_started`
用户提交了可接受的公开 URL，系统创建扫描任务。

Properties：
- `site_id_hash`
- `normalized_host_class`
- `device_class`
- `source_page`

默认不把完整被扫 URL 作为 analytics property；业务数据库可以保存必要的扫描目标，分析系统只保留 hash / 分类。

### `scan_rejected`
输入在创建任务前被拒绝。

Reason enum：
- INVALID_URL
- UNSAFE_TARGET
- UNSUPPORTED_SCHEME
- OTHER

### `scan_completed`
Scanner 完成并产生可展示结果。

Properties：
- `site_id_hash`
- `pages_checked`
- `finding_count`
- `top3_available`
- `scan_duration_bucket`

### `scan_incomplete`
Scanner 正确 fail-closed，没有伪造结论。

Reason enum：
- RATE_LIMITED
- BLOCKED
- LOGIN_REQUIRED
- JS_INCOMPLETE
- GEO_CONTEXT_MISMATCH
- SITE_UNAVAILABLE
- UNKNOWN_FAILURE

### `top3_viewed`
用户实际进入并看到 Top 3 区域。

这是 Activation candidate 的必要事件，但单独发生不等于已经证明 Aha。

Properties：
- `site_id_hash`
- `top3_count`
- `scan_duration_bucket`

### `issue_expanded`
用户主动查看更多证据/解释。

Properties：
- `site_id_hash`
- `rule_id`
- `priority_rank`
- `finding_type`

### `paid_expansion_viewed`
用户看到完整报告价值说明。

替代旧的模糊 `pricing_viewed` 作为产品价值层事件。

### `checkout_started`
保留给 G9。
当前不发送真实支付事件。

Properties：
- `provider`
- `sku`
- `currency`

### `payment_completed`
G9 才启用，必须由可信服务端事实触发，不由前端按钮点击伪造。

### `full_report_viewed`
用户第一次看到已解锁完整报告。

G5 本地 dogfood 使用同名事件时，必须同时发送 `report_mode=local_preview` 与 `access_state=not_entitled`；该本地预览不表示用户已解锁、付费或获得 entitlement。G9/G10 的付费语义仍以后续 Gate 的合同为准。

G5 本地预览属性：
- `site_id_hash`
- `report_mode`（固定为 `local_preview`）
- `access_state`（固定为 `not_entitled`）
- `queue_count`

### G5 local full-report preview events

这些事件仅记录本地完整队列与解释预览中的界面行为，不证明付费意向或真实用户价值：

| Event | Required properties |
| --- | --- |
| `full_issue_expanded` | `site_id_hash`, `rule_id`, `queue_position` |
| `llm_explanation_requested` | `site_id_hash`, `rule_id`, `schema_version`, `queue_position` |
| `llm_explanation_viewed` | `site_id_hash`, `rule_id`, `source` (`llm`, `deterministic_fake`, or `deterministic_fallback`) |
| `llm_explanation_failed` | `site_id_hash`, `rule_id`, `reason` (`provider_unavailable`, `timeout`, `malformed_output`, `guard_rejected`, or `payload_too_large`) |

G5 analytics 不得发送扫描 URL、证据正文/引用列表、prompt、LLM 输入/输出、API key 或支付属性。`site_id_hash` 必须是 lowercase SHA-256；事件名不得包含 `checkout_started` 或 `payment_completed`。
`deterministic_fake` 仅用于本地 automated acceptance，不代表调用真实 LLM 或产生真实用户行为证据。

## 2. Aha proxy events

`top3_viewed` 只是候选 Activation。

为了判断用户是否真的感到“结果与我有关”，优先观察组合：

```text
top3_viewed
+
issue_expanded OR meaningful_dwell
+
paid_expansion_viewed / return_visit / fix_action_click（未来）
```

G3.5 不制造一个虚假的 `aha_happened` 事件。

## 3. Diagnostic funnel

```text
landing_view
↓
scan_started
↓
scan_completed | scan_incomplete
↓
top3_viewed
↓
issue_expanded
↓
paid_expansion_viewed
↓
checkout_started   [G9]
↓
payment_completed [G9]
↓
full_report_viewed [G9/G10]
```

每一层只证明对应行为，不越级推断需求或购买意愿。

## 4. Initial metrics

### Landing → Scan Start
衡量 Message / Relevance / CTA / initial trust。

### Scan Start → Scan Complete
衡量技术完成率，不是营销转化率。

### Scan Complete → Top3 Viewed
衡量结果页到达与呈现问题。

### Top3 → Issue Expanded
衡量结果是否值得继续理解。

### Top3 → Paid Expansion Viewed
衡量免费价值是否自然引向更深价值。

### Paid Expansion → Checkout
G9 后才有意义。

## 5. Provider policy

Preferred candidate：PostHog or equivalent。

原则：
- 优先 project-owned integration；
- 不为了一个 tracking snippet 引入重型 WordPress plugin；
- analytics provider 可替换，事件语义不可随 provider 改变；
- 不记录 raw HTML；
- 不记录 Secret；
- 不把完整被扫描 URL 当默认行为分析字段；
- payment truth 来自服务端。

## 6. Dogfood relation

这些事件同时服务 `docs/SKILL_DOGFOOD_LOG.md`。

例如：

Hypothesis：Free Top 3 是 Activation。

需要观察的不是“多少人完成扫描”，而是：
- Top 3 是否被实际看到；
- 是否展开证据；
- 是否继续了解完整价值；
- 后续是否出现 Intent / Transaction。

只有真实行为出现后才能更新 Skill 证据等级。
