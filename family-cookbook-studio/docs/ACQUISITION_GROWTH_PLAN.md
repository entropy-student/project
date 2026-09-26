# 获客与验证计划：Family Cookbook Studio

> Status: SUPPORTING VALIDATION PLAN  
> Plans/metrics here are not observed results unless separately evidenced.  
> Current authority: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md).

采用 Evidence → Bottleneck → Lever → Experiment → Decision。

## 1. Current validation spine

| 证据层 | 当前状态 | 需要证明 |
|---|---|---|
| Problem Evidence | UNKNOWN / 未归档 | 用户是否真的有散落食谱、是否愿意花钱整理 |
| Solution Proof | 未实现 | 手写→结构化→校对→成书是否让用户满意 |
| Attention | 未测 | before/after 成品是否吸引点击/停留 |
| Intent | 未测 | 是否愿意上传样本、进入结账 |
| Transaction | 未测 | 是否真实付款 |
| Repeatability | 未测 | 不同字迹/家庭能否稳定交付 |
| Economics | 未知 | OCR/AI/校对/存储/PDF/客服/CAC 后是否有利润 |

## 2. 核心市场表达假设

优先测试的不是“OCR 很强”，而是：

**把家里散落的手写食谱，整理成一本真正能留下来的家庭食谱书。**

价值层可以拆成：

1. Preserve — 保存原始配方与字迹；
2. Organize — 把散乱内容整理成统一食谱；
3. Remember — 保留是谁写的、什么时候吃、相关故事；
4. Share — 变成 PDF/后续实体书，能送给家人。

## 3. 最适合验证的素材

获客素材优先做“before → after”：

```text
旧食谱卡 / 手写笔记
→
清晰转录 + 原始字迹保留
→
正式 cookbook spread
```

避免只展示漂亮模板。用户需要立刻理解“我的旧纸张会变成什么”。

## 4. Funnel

```text
landing_view
→ example_before_after_view
→ preview_started
→ preview_completed
→ offer_viewed
→ checkout_started
→ payment_completed
→ intake_completed
→ ocr_review_completed
→ proof_viewed
→ final_delivered
→ refund/revision/reprint
```

不要把“上传了一张照片”当成购买证据。

## 5. 核心实验

### Experiment A — Offer/visual resonance

给用户看真实风格的 before/after 样例，测试：
- 是否继续看；
- 是否点“make my cookbook”；
- 最常见疑问；
- 是否担心 OCR 错误、隐私、价格、交期。

### Experiment B — Fidelity trust

展示：
- 原图；
- 自动转录；
- 模糊字段被高亮；
- 用户确认后的 final recipe。

目标：验证“系统不会乱改祖传配方”是否能成为信任点。

### Experiment C — Package willingness-to-pay

只有真实价格页/checkout 才能验证：
- 不同食谱数套餐是否可理解；
- 用户更在意数字 PDF 还是实体书；
- 对价格、食谱数量、交期的异议。

具体价格必须在 G2A2 由 Owner 冻结。

## 6. Unit economics to record

每单至少记录：

- 成交价；
- payment fee；
- source image count；
- OCR/API cost；
- VLM fallback count/cost；
- manual review minutes；
- customer correction count；
- PDF render/storage/email；
- refund/rework；
- acquisition source/CAC；
- physical print/shipping when introduced.

家庭食谱项目的关键成本变量很可能不是文本 Token，而是**难字迹带来的人工校对时间**。

## 7. Privacy analytics boundary

分析事件不得包含：
- 原始食谱文本；
- 图片；
- 家庭成员名字；
- 地址；
- 私密故事；
- OCR 原文。

只记录必要的匿名/订单级状态和计数。

## 8. Decision logic

- 漂亮样例但无人开始 checkout → Offer/价格/信任问题优先；
- 很多人上传但 OCR 校对时间过长 → 技术/范围问题优先；
- 支付成立但大量退款 → 质量/承诺不匹配；
- 数字 PDF 交付稳定且需求重复出现后，再进入实体印刷；
- 不因单个好看的 demo 宣布可规模化。
