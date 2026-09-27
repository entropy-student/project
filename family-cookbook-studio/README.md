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
PP-OCRv6_medium primary
    ↓
critical-value / confidence checks
    ↓
at most one target-language fallback / second pass
    ↓
still uncertain → user confirmation
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

OCR 架构目前已经收束为 **PP-OCRv6_medium 免费本地主力 + 最多一个按需 API 兜底 + 一次统一人工 Review**。R3A 已正式选择 PP-OCRv6_medium；PaddleOCR-VL-1.6 和 TrOCR-small 均不进入主路径。API 兜底只处理主力仍解决不了的 hard handwriting 长尾。

详细复用边界见 [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md)。

## 当前 Gate

第一轮 G2A1 已执行并由 Reviewer 判定 **RETURN**：routing/schema 与静态 0-Token 预览有部分有效证据，但 PaddleOCR/TrOCR 没有真正完成推理，Family Cookbook 专用 WordPress/WooCommerce 测试站也未建立。

G2A1-R1 再次 RETURN：本机最新只剩 **0.62 GiB 可用 RAM**，且其他项目 WordPress/数据库仍在运行，因此 Reviewer 不再允许继续在当前 Windows 主机硬跑。

G2A1-R2 已完成真实 Actions PoC：
- WordPress + WooCommerce + Kadence、0-Token 浏览器本地预览、订单绑定上传、私密交付的可行性证据已被 Reviewer 接受；
- OCR 已完成真实推理，但当前混合语言测试集和未冻结的 UX 门槛不足以支持最终产品级 PASS/FAIL；
- TrOCR-small 当前配置已被淘汰为 MVP fallback。

G2A1-D1 已决策完成：**English-first、not English-only；OCR 完成后只进行一次统一 Review，所有不确定字段集中高亮并支持手动修改。**

G2A1-R3A 已 PASS：**PP-OCRv6_medium** 被 Reviewer 接受为唯一免费本地主力；20 张合成食谱页 77/77 关键事实正确、零人工修改，PaddleOCR-VL-1.6 因漏温度字段且运行更重而被淘汰为主力。

G2A1-R3B 的 Google 技术接入已经证明可行：GitHub OIDC + Workload Identity Federation、Service Account、Document OCR processor 与 processor version 均验证通过，真实 `:process` 请求只因 Billing 未启用而被拒绝。由于当前 Billing 账户要求 **USD 30 一次性预付款**，本轮不为 11 个测试样本启用该预付。

R3B 曾尝试 **Mistral OCR 4.1 Free mode**，但首个 OCR 请求以及 15s/30s/60s/90s 退避重试都返回 HTTP 429，成功 OCR 页数为 0；没有出现 402 Payment Required，因此这是 Free-mode availability/rate-limit blocker，不是识别质量结论。

Owner 决定不为本轮测试启用付费 Mistral，当前已恢复 **Google Document AI + WIF** 路线。Google 仅剩 Billing 激活 blocker；完成后继续相同 11 个公开 hard cases 的 R3B benchmark。

G2A1 通过后，进入 **G2A2 MVP Product Contract Freeze**，冻结页数、食谱数量、输入格式、校对策略、修改规则、QA 和数据保留，再进入本地 OCR→PDF Solution Proof。

## 文档

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — **唯一当前 Reviewer / 项目真相**
- [docs/DOCUMENT_INDEX.md](./docs/DOCUMENT_INDEX.md) — 文档角色和权威等级
- [docs/PROJECT_CHARTER.md](./docs/PROJECT_CHARTER.md) — 初始立项基线
- [docs/TECHNICAL_ROUTE.md](./docs/TECHNICAL_ROUTE.md) — 当前技术路线
- [docs/OCR_PIPELINE_RESEARCH.md](./docs/OCR_PIPELINE_RESEARCH.md) — OCR/手写识别候选与验证原则
- [docs/G2A1_INPUT_OCR_COMPONENT_POC.md](./docs/G2A1_INPUT_OCR_COMPONENT_POC.md) — 原始 G2A1 Gate
- [docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md](./docs/G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md) — G2A1-R1（资源阻塞 RETURN）
- [docs/G2A1_R2_ISOLATED_ACTIONS_RUNNER_COMPLETION.md](./docs/G2A1_R2_ISOLATED_ACTIONS_RUNNER_COMPLETION.md) — G2A1-R2（组件证据已接受）
- [docs/G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md](./docs/G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md) — Owner 决策已完成
- [docs/G2A1_R3_OCR_ARCHITECTURE_BENCHMARK.md](./docs/G2A1_R3_OCR_ARCHITECTURE_BENCHMARK.md) — R3A PASS / R3B framework
- [docs/G2A1_R3B_API_FALLBACK_OWNER_CHECKPOINT.md](./docs/G2A1_R3B_API_FALLBACK_OWNER_CHECKPOINT.md) — Owner 已批准
- [docs/G2A1_R3B_API_FALLBACK_BENCHMARK.md](./docs/G2A1_R3B_API_FALLBACK_BENCHMARK.md) — R3B 执行契约（Google credential RETURN）
- [docs/G2A1_R3B_GOOGLE_PROVIDER_SETUP.md](./docs/G2A1_R3B_GOOGLE_PROVIDER_SETUP.md) — Google 技术接入记录（当前 deferred）
- [docs/G2A1_R3B_MISTRAL_PROVIDER_SETUP.md](./docs/G2A1_R3B_MISTRAL_PROVIDER_SETUP.md) — **当前 Owner 配置步骤**
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


### R3B current provider probe — Baidu Handwriting OCR

Before paying Google's account-level Billing prepayment, the current R3B Gate will benchmark **Baidu Handwriting OCR** on the same 11 public hard handwriting crops.

Boundary:
- free test quota only;
- no automatic paid mode;
- GitHub Secrets only for API Key / Secret Key;
- same semantic fidelity + manual-edit scoring;
- Google remains a swappable deferred adapter;
- Mistral Free mode remains deferred after persistent HTTP 429.
