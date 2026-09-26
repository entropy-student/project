# Family Cookbook Studio（家庭食谱成书）

> **Current project truth:** [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)  
> **Start here:** [00_START_HERE.md](./00_START_HERE.md)  
> **Document roles:** [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md)

## 产品目标

把家庭里散落的手写食谱、旧笔记、菜谱卡片和相关照片，整理成一份结构清楚、可校对、可长期保存和送给家人的家庭食谱书。

核心不是“做一个 OCR 工具”，而是完成整条产品链：

```text
手写食谱照片
→ 保真转录
→ 结构化食谱
→ 不确定项显式标记 / 校对
→ 家庭故事与来源信息整理
→ 确定性排版
→ proof
→ final PDF
→ 后续可选实体印刷
```

## 当前产品原则

- **保真优先于自动补全**：AI/OCR 不得静默改写配方、数量、温度、时间或步骤。
- 原始扫描/照片始终是最终校对依据；低置信内容必须显式进入 review queue。
- 免费层优先复用生日杂志项目的“浏览器本地、零模型 Token 预览”思路，先展示成书风格，不在未付款阶段批量跑 OCR/视觉模型。
- 通用电商能力优先复用 WordPress + WooCommerce；家庭食谱专属核心只做 OCR/结构化/校对/排版/PDF。
- 实体印刷后置；先证明数字 PDF 的质量、交付闭环与单位经济。
- 不因为两个项目相似就提前做“大一统平台”；只有生日杂志和家庭食谱都证明稳定需求后，再评估抽取共享 Personalized Publishing Core。

## 当前技术方向

```text
WordPress + WooCommerce
    ↓
Kadence first PoC
(Brandy / Blocksy fallback)
    ↓
FREE: browser-local preview
0 model Token / no real OCR
    ↓
paid order + complete intake
    ↓
private recipe-image upload
    ↓
OpenCV/library preprocessing
    ↓
PaddleOCR first
    ↓
TrOCR second local pass when ambiguous
    ↓
optional bounded VLM only for unresolved regions
    ↓
recipe schema + provenance
    ↓
uncertainty + human/user review
    ↓
deterministic HTML/CSS cookbook layout
    ↓
PDF QA
    ↓
private proof / final delivery
```

当前默认目标不是“每单调用大模型”，而是让常规订单尽可能依赖本地/开源 OCR 与规则完成，因此普通付费路径也可能保持 **0 model Token**；是否需要 VLM 以及每单实际成本必须由 G2A1 证据决定。

详细复用边界见 [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md)。

## 当前 Gate

当前进入 **G2A1 — Input / OCR / Reusable Component Feasibility PoC**。

先验证：

1. PaddleOCR / TrOCR 在真实难度手写食谱上的转录质量，并以 Tesseract 作为印刷体控制组；
2. 配方字段能否稳定结构化且保留原文 provenance；
3. 低置信字段能否 fail-closed 地进入人工/用户确认；
4. WordPress/WooCommerce 的订单绑定上传和私有文件交付能否复用；
5. 付款前预览能否保持浏览器本地、零模型 Token。

G2A1 通过后，进入 **G2A2 MVP Product Contract Freeze**，冻结页数、食谱数量、输入格式、校对策略、修改规则、QA 和数据保留，再进入本地 OCR→PDF Solution Proof。

## 文档

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — **唯一当前 Reviewer / 项目真相**
- [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — 文档角色和权威等级
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 初始立项基线
- [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md) — 当前技术路线
- [docs/OCR_PIPELINE_RESEARCH.md](./docs/OCR_PIPELINE_RESEARCH.md) — OCR/手写识别候选与验证原则
- [docs/G2A1_INPUT_OCR_COMPONENT_POC.md](./docs/G2A1_INPUT_OCR_COMPONENT_POC.md) — **当前 Gate**
- [docs/G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md](./docs/G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md) — 下一 Gate
- [docs/ACQUISITION_GROWTH_PLAN.md](./docs/ACQUISITION_GROWTH_PLAN.md) — 获客/验证计划
- [PROJECT_RECORD.md](./PROJECT_RECORD.md) — legacy compatibility pointer only

## 治理

本项目采用 [VPS Project Governance v0.1.6](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance)。

关键规则：

- `REVIEWER_HANDOFF.md` 是唯一当前项目真相；
- `PASS_CANDIDATE != PASS`；
- 研究、计划、模型 Demo 不能冒充生产事实；
- UNKNOWN 明确写 UNKNOWN；
- Secret、支付凭据、客户照片、家庭信息和真实订单私密数据不得进入普通仓库文档；
- 未来进入 Shared VPS 前必须先建立 `PROJECT_STORAGE_MANIFEST.md` 并满足 Storage Layout Contract。
