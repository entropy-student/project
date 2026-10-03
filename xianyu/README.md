# Xianyu

## 项目状态

**CLOSED / PASS**

本项目目标已经完成：

> **基于闲鱼真实市场需求，形成明确、可复核的商品类型 / SKU 目录。**

最终主交付：
- [docs/FINAL_SKU_CATALOG_2026-10.md](./docs/FINAL_SKU_CATALOG_2026-10.md)

最终目录：
- **6 个 CONFIRMED_DEMAND**
- **44 个 PROBABLE_DEMAND**
- **50 个核心商品类型 / SKU**
- 另保留 19 个 WATCHLIST
- 6 个 MARKET_SIGNAL_ONLY

项目不要求唯一冠军，也不强制 Top N。

## 最终选品方法

经过完整复查，项目最终采用 **platform-first**，不再以“我们能做什么 / 哪些服务能产品化”为主要候选来源。

~~~text
闲鱼官方当前类目
→ 当前直接 SKU
→ 平台 / 商品族交易数据
→ 多卖家 / 多商品复现
→ Provenance + Signal Lineage
→ D4 / D3 / D2 / D1 / U
→ 统一 SKU 粒度
→ Final SKU Catalog
→ PROJECT CLOSEOUT
~~~

### Provenance

~~~text
PLATFORM_TRANSACTION
PLATFORM_CATEGORY
DIRECT_SKU
RELATED_RESULTS_CLUSTER
DERIVED_ADJACENT
~~~

### 需求证据等级

~~~text
D4  平台 / 第一方商品族交易证据，或可归属 SKU 成交证据
D3  多个独立当前闲鱼市场信号
D2  单个当前直接 SKU / 一致相关商品簇
D1  平台类目 / 宏观 / 相邻推导
U   证据不足
~~~

关键纪律：
- “想要/浏览”不等于销量；
- 卖家累计销量不等于 SKU 销量；
- “为你推荐”不等于搜索深度或市场份额；
- 相邻需求只能生成候选，不能直接证明具体 SKU；
- 同一卖家矩阵 / 推荐链不重复计权；
- 货源 UNKNOWN 不用于淘汰市场需求。

## 复查后修正了什么

### 1. 旧 36 SKU 不是完整母集

旧 36 个 SKU 保留为历史种子，但其旧 S/A/B 排名已经 supersede。

原因：
- X1 是 service-first discovery，天然偏向软件 / AI / Office / 服务产品化；
- 若干候选来自少数商品页的推荐模块；
- 部分 SKU 是相邻需求外推；
- SKU 粒度不统一。

### 2. 重建为 15 个平台原生市场面

最终覆盖：

1. 会员 / 充值
2. 卡券 / 票务 / 代金券
3. 游戏虚拟物
4. 软件 / License / 激活码
5. 源码 / 插件 / 工具软件
6. AI 教程 / Workflow / 工具
7. Office / 经营模板
8. 教育 / 考试 / 证书资料
9. 研究数据 / 数据产品
10. 工程图纸 / 技术资料
11. 摄影预设 / LUT / 修图资产
12. 视频 / 音频 / 设计素材
13. 网站 / WordPress / Web 模板
14. 行业 / 专业知识资料
15. 旅行 / 生活 / 菜谱 / 兴趣攻略

X3R3 先建立 70+ seed，再标准化成 60 个可比较候选，最终由 X3R4 形成核心 50 SKU 目录。

## 最强结论摘要

当前证据最强的市场方向包括：
- AI 漫剧教程 + 项目 / 工作流文件；
- 会员类虚拟商品；
- 院校 / 专业考研复试资料；
- 本地化初中 / 中考资料；
- 摄影 Lightroom / PS 预设；
- 漫展 / COS / 人像修图预设口令。

此外，WordPress 模板、AI 标书软件、电商图片效率软件、研究数据产品、SolidWorks 图纸库等进入 PROBABLE_DEMAND 核心目录。

旧的 Excel CRM、通用 Excel 清洗、文件重命名等方向没有被判定“没需求”，而是因为现有证据主要来自相邻需求，降到 WATCHLIST。

## 项目边界

以下全部不属于本项目，也不是未完成事项：

- 找货源 / 找供应商；
- 采购；
- 版权 / 授权方案落地；
- 商品制作；
- 上架；
- 真实订单 / 支付退款；
- 交付与售后；
- 账号自动化；
- VPS/runtime；
- 规模化运营。

如果后续要做这些，应以最终 SKU 目录为输入，另立项目或另开明确独立范围。

## 阅读顺序

1. [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) — 最终项目状态 / CLOSEOUT
2. [docs/FINAL_SKU_CATALOG_2026-10.md](./docs/FINAL_SKU_CATALOG_2026-10.md) — **最终主交付**
3. [docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md](./docs/X3R2_PROJECT_REVIEW_METHOD_RESET_2026-10.md) — 为什么旧方法需要修正
4. [docs/X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md](./docs/X3R3_NORMALIZED_PLATFORM_FIRST_SKU_UNIVERSE_R1_2026-10.md) — 60 个标准化候选
5. [docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md](./docs/X3R3_PLATFORM_FIRST_SKU_UNIVERSE_SEED_2026-10.md) — 70+ seed 市场母集
6. [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) — 全部执行 / Reviewer Evidence
7. [docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md](./docs/X3R1_CONCRETE_SKU_DEMAND_POOL_2026-10.md) — 历史 36 SKU 种子池
8. 更早 X1 / X2 / X2R1 / X3 文档 — 历史研究证据

## 历史 runtime

历史 Xianyu VPS/runtime 与本选品项目已经解耦：

~~~text
LEGACY_RUNTIME_CONTEXT=PRESERVED
CURRENT_PROJECT_DEPENDENCY=NO
CURRENT_PROJECT_READ_REQUIRED=NO
CURRENT_PROJECT_MUTATION_ALLOWED=NO
~~~

本项目 closeout 没有执行任何删除、账号变更、交易、支付或 runtime 修改。
