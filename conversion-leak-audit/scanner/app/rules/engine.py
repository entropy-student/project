
from __future__ import annotations
from dataclasses import dataclass
from typing import Any, Dict

VALID_RESULTS = {
    "PASS",
    "ISSUE",
    "NOT_APPLICABLE",
    "CONTEXT_INSUFFICIENT",
    "AUDIT_INCOMPLETE",
    "MANUAL_REVIEW_REQUIRED",
}

@dataclass(frozen=True)
class Decision:
    rule_id: str
    result: str
    message: str
    evidence_level: str = "L0"
    confidence: str = "HIGH"

def d(rule_id: str, result: str, message: str, evidence_level: str = "L0", confidence: str = "HIGH") -> Decision:
    assert result in VALID_RESULTS
    return Decision(rule_id, result, message, evidence_level, confidence)

def gate_001(s: Dict[str, Any]) -> Decision:
    rid = "GATE-001"
    if s.get("http_status") == 429:
        return d(rid, "AUDIT_INCOMPLETE", "ACCESS_RATE_LIMITED")
    if s.get("waf_blocked"):
        return d(rid, "AUDIT_INCOMPLETE", "ACCESS_BLOCKED")
    if s.get("login_required"):
        return d(rid, "AUDIT_INCOMPLETE", "ACCESS_LOGIN_REQUIRED")
    if not s.get("critical_js_complete", True):
        return d(rid, "AUDIT_INCOMPLETE", "ACCESS_JS_INCOMPLETE")
    if s.get("http_status") == 200 and s.get("dom_complete", False):
        return d(rid, "PASS", "ACCESS_OK")
    return d(rid, "AUDIT_INCOMPLETE", "ACCESS_UNKNOWN_FAILURE", confidence="MEDIUM")

def gate_002(s: Dict[str, Any]) -> Decision:
    rid = "GATE-002"
    required = ["final_url", "region", "currency", "viewport", "timestamp"]
    complete = all(bool(s.get(k)) for k in required)
    if s.get("geo_redirect") and not complete:
        return d(rid, "CONTEXT_INSUFFICIENT", "上下文不足")
    if not complete:
        return d(rid, "CONTEXT_INSUFFICIENT", "CONTEXT_INSUFFICIENT")
    if s.get("geo_redirect"):
        return d(rid, "PASS", "ACCESS_OK_WITH_GEO_CONTEXT")
    return d(rid, "PASS", "上下文完整")

def core_001(s: Dict[str, Any]) -> Decision:
    rid = "CORE-001"
    if s.get("intentionally_protected") or s.get("login_required"):
        return d(rid, "NOT_APPLICABLE", "受保护页面")
    if not s.get("core_page", False):
        return d(rid, "NOT_APPLICABLE", "非关键商业页面")
    status = s.get("http_status")
    if isinstance(status, int) and 400 <= status <= 599:
        return d(rid, "ISSUE", "关键商业页面不可访问")
    if status == 200 and s.get("dom_complete", True):
        return d(rid, "PASS", "页面可访问")
    return d(rid, "MANUAL_REVIEW_REQUIRED", "页面状态需要人工复核", confidence="MEDIUM")

def core_002(s: Dict[str, Any]) -> Decision:
    rid = "CORE-002"
    if not s.get("direct_purchase"):
        return d(rid, "NOT_APPLICABLE", "非直接购买交易")
    if s.get("out_of_stock") or not s.get("in_stock", True):
        return d(rid, "NOT_APPLICABLE", "当前不可购买状态")
    if not s.get("required_options_selected", True):
        return d(rid, "MANUAL_REVIEW_REQUIRED", "必选项尚未完成", confidence="MEDIUM")
    if s.get("cta_action_success"):
        return d(rid, "PASS", "购买动作可操作")
    if s.get("cta_present") and s.get("cta_action_success") is False:
        return d(rid, "ISSUE", "购买动作在测试状态不可操作")
    return d(rid, "MANUAL_REVIEW_REQUIRED", "购买动作状态不确定", confidence="MEDIUM")

def core_003(s: Dict[str, Any]) -> Decision:
    rid = "CORE-003"
    if not s.get("mobile_context"):
        return d(rid, "NOT_APPLICABLE", "非移动端测试")
    if s.get("blocking_overlay") and not s.get("overlay_dismissible", False) and s.get("cta_covered", False):
        return d(rid, "ISSUE", "测试视口核心任务被阻断")
    if s.get("horizontal_overflow_blocks_task"):
        return d(rid, "ISSUE", "测试视口核心任务被阻断")
    if s.get("blocking_overlay") and s.get("overlay_dismissible") and not s.get("cta_covered_after_dismiss", False):
        return d(rid, "PASS", "可恢复遮挡")
    return d(rid, "PASS", "移动核心任务未阻断")

def core_004(s: Dict[str, Any]) -> Decision:
    rid = "CORE-004"
    if not s.get("key_form"):
        return d(rid, "NOT_APPLICABLE", "非关键表单")
    if s.get("accessible_name"):
        return d(rid, "PASS", "存在合法可访问名称")
    if s.get("placeholder_only") and not s.get("accessible_name"):
        return d(rid, "ISSUE", "关键表单控件缺少可识别标签")
    return d(rid, "ISSUE", "关键表单控件缺少可识别标签")

def core_006(s: Dict[str, Any]) -> Decision:
    rid = "CORE-006"
    if not s.get("core_internal_link"):
        return d(rid, "NOT_APPLICABLE", "非核心内部链接")
    status = s.get("target_status")
    if isinstance(status, int) and 400 <= status <= 599:
        return d(rid, "ISSUE", "核心内部导航链接损坏")
    if status == 200:
        return d(rid, "PASS", "核心导航有效")
    return d(rid, "MANUAL_REVIEW_REQUIRED", "导航目标状态不确定", confidence="MEDIUM")

def core_007(s: Dict[str, Any]) -> Decision:
    rid = "CORE-007"
    if s.get("quote_based") or not s.get("direct_purchase"):
        return d(rid, "NOT_APPLICABLE", "定制报价交易")
    if s.get("price_visible") or s.get("price_rule_visible"):
        return d(rid, "PASS", "购买前价格可见")
    return d(rid, "ISSUE", "直接购买价格不可确定")

def core_009(s: Dict[str, Any]) -> Decision:
    rid = "CORE-009"
    if not s.get("intended_indexable_commercial"):
        return d(rid, "NOT_APPLICABLE", "非目标索引页")
    if s.get("noindex"):
        return d(rid, "ISSUE", "目标商业页被标记noindex")
    return d(rid, "PASS", "商业页允许索引")

def core_010(s: Dict[str, Any]) -> Decision:
    rid = "CORE-010"
    if not s.get("product_page"):
        return d(rid, "NOT_APPLICABLE", "非商品页")
    vp, vc = s.get("visible_price"), s.get("visible_currency")
    sp, sc = s.get("structured_price"), s.get("structured_currency")
    if None in (vp, vc, sp, sc):
        return d(rid, "MANUAL_REVIEW_REQUIRED", "结构化数据比较信息不足", confidence="MEDIUM")
    if float(vp) != float(sp) or str(vc).upper() != str(sc).upper():
        return d(rid, "ISSUE", "结构化价格与页面价格冲突")
    if s.get("localized"):
        return d(rid, "PASS", "当前地区数据一致")
    return d(rid, "PASS", "结构化数据与可见事实一致")

def phys_001(s: Dict[str, Any]) -> Decision:
    rid = "PHYS-001"
    if not s.get("physical"):
        return d(rid, "NOT_APPLICABLE", "非实物交易")
    p = s.get("return_proximity")
    if p in ("P0", "P1", "P2"):
        return d(rid, "PASS", "退货信息可合理发现", evidence_level="L1")
    if p == "P3" and s.get("high_consideration"):
        return d(rid, "ISSUE", "退货信息存在但离购买决策较远", evidence_level="L1")
    if p == "P4" or p is None:
        return d(rid, "ISSUE", "未找到适用于当前交易的退货信息", evidence_level="L1")
    return d(rid, "PASS", "退货信息可合理发现", evidence_level="L1")

def phys_002(s: Dict[str, Any]) -> Decision:
    rid = "PHYS-002"
    if not s.get("physical"):
        return d(rid, "NOT_APPLICABLE", "非实物交易")
    if s.get("international") and not s.get("region_context_ok"):
        return d(rid, "CONTEXT_INSUFFICIENT", "地区上下文不足")
    if s.get("shipping_cost_known") and s.get("shipping_timing_known"):
        if s.get("international"):
            return d(rid, "PASS", "当前地区配送信息清楚", evidence_level="L1")
        return d(rid, "PASS", "配送关键条件可合理发现", evidence_level="L1")
    return d(rid, "ISSUE", "关键配送信息未合理发现", evidence_level="L1")

def sub_001(s: Dict[str, Any]) -> Decision:
    rid = "SUB-001"
    if not s.get("promo_to_standard"):
        return d(rid, "NOT_APPLICABLE", "无首期转标准价结构")
    if s.get("intro_price_visible") and s.get("standard_price_visible"):
        return d(rid, "PASS", "首期与后续标准价清楚", evidence_level="L1")
    return d(rid, "ISSUE", "后续标准收费难以发现", evidence_level="L1")

def sub_002(s: Dict[str, Any]) -> Decision:
    rid = "SUB-002"
    if not s.get("recurring"):
        return d(rid, "NOT_APPLICABLE", "非周期交易")
    if s.get("cadence_visible"):
        return d(rid, "PASS", "扣费周期清楚", evidence_level="L1")
    return d(rid, "ISSUE", "扣费周期无法确认", evidence_level="L1")

def sub_003(s: Dict[str, Any]) -> Decision:
    rid = "SUB-003"
    if s.get("prepaid_fixed_term_no_renew"):
        return d(rid, "NOT_APPLICABLE", "非自动续费")
    if not s.get("recurring"):
        return d(rid, "NOT_APPLICABLE", "非自动续费")
    if s.get("auto_renew_visible"):
        return d(rid, "PASS", "自动续费事实清楚", evidence_level="L1")
    return d(rid, "ISSUE", "自动续费事实难以发现", evidence_level="L1")

def sub_004(s: Dict[str, Any]) -> Decision:
    rid = "SUB-004"
    if s.get("free_forever"):
        return d(rid, "NOT_APPLICABLE", "非trial-to-paid")
    if not s.get("trial_to_paid"):
        return d(rid, "NOT_APPLICABLE", "非trial-to-paid")
    if s.get("trial_length_visible") and s.get("post_trial_amount_visible") and s.get("auto_conversion_visible"):
        return d(rid, "PASS", "试用转付费关键事实清楚", evidence_level="L1")
    return d(rid, "ISSUE", "试用后的收费事实不完整", evidence_level="L1")

def sub_005(s: Dict[str, Any]) -> Decision:
    rid = "SUB-005"
    if not s.get("recurring") and not s.get("marketplace_dependent"):
        return d(rid, "NOT_APPLICABLE", "非周期交易")
    if s.get("marketplace_dependent") and s.get("third_party_cancel_provider_visible"):
        return d(rid, "PASS", "第三方取消责任方清楚", evidence_level="L1")
    if not s.get("cancel_method_visible"):
        return d(rid, "ISSUE", "取消核心条件难以合理发现", evidence_level="L1")
    if s.get("cancel_deadline_material") and not s.get("cancel_deadline_visible"):
        return d(rid, "ISSUE", "取消截止条件难以合理发现", evidence_level="L1")
    return d(rid, "PASS", "取消核心条件可合理发现", evidence_level="L1")

RULES = {
    "GATE-001": gate_001,
    "GATE-002": gate_002,
    "CORE-001": core_001,
    "CORE-002": core_002,
    "CORE-003": core_003,
    "CORE-004": core_004,
    "CORE-006": core_006,
    "CORE-007": core_007,
    "CORE-009": core_009,
    "CORE-010": core_010,
    "PHYS-001": phys_001,
    "PHYS-002": phys_002,
    "SUB-001": sub_001,
    "SUB-002": sub_002,
    "SUB-003": sub_003,
    "SUB-004": sub_004,
    "SUB-005": sub_005,
}

def evaluate(rule_id: str, state: Dict[str, Any]) -> Decision:
    if rule_id not in RULES:
        raise KeyError(f"Unknown rule_id: {rule_id}")
    return RULES[rule_id](state)
