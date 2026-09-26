# 项目立项书：Family Cookbook Studio（家庭食谱成书）

立项日期：2026-09-26  
项目状态：Governance bootstrap complete / Solution feasibility next  
Owner：用户（商业目标、市场、价格、产品承诺和重大风险决策）  
Reviewer / Executor：按 VPS Project Governance v0.1.6 分工

> Current stage/Gate/accepted truth lives only in [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md).

## 1. 一句话目标

让用户把奶奶、妈妈或其他家人留下的手写食谱、旧菜谱卡和相关照片上传，系统帮助保真转录、整理、结构化、校对和排版，最终得到一份正式的家庭食谱书，而不是要求用户自己做 OCR、Word 或 Canva。

## 2. 用户与问题假设

首轮用户假设：

- 家庭里有散落的手写食谱、旧笔记或拍照存档；
- 配方承载的不只是“怎么做菜”，还有家庭记忆、来源和传承意义；
- 用户愿意花钱减少手工录入、整理、统一格式和排版的工作；
- 仅有 OCR 文本不够，用户真正想要的是可保存、可赠送、可打印的成品。

这些是假设，不应写成已验证市场事实。

## 3. 核心产品体验

目标流程：

```text
选择产品 / 风格
→ 看到成书样例或浏览器本地预览
→ 下单
→ 上传手写食谱照片与可选家庭照片/记忆
→ OCR / handwriting transcription
→ 结构化 recipe schema
→ 不确定项 review queue
→ 买家校对 / 确认
→ 稳定版式排版
→ cookbook proof
→ final PDF
→ 后续可选实体印刷
```

### 产品核心原则：Preserve, don't invent

对于配方中的以下字段：

- 数量；
- 单位；
- 温度；
- 时间；
- 配料；
- 顺序；
- 特殊备注；

系统不得因为 OCR/AI “看起来不确定”而静默补成一个合理答案。任何低置信或冲突内容必须：

```text
保留原图
+ 保留原始 OCR
+ 标记 uncertainty
+ 进入 review
+ 只有经确认后才能进入 final recipe
```

## 4. 范围与非目标

### 最终能力范围

- 商品页、样例与清晰 Offer；
- 多张食谱图片上传并绑定订单；
- 图像预处理与 OCR/手写识别；
- 食谱字段结构化；
- 模糊/冲突字段显式提示；
- 用户/运营校对；
- 家庭来源、人物、故事等可选字段；
- 多食谱目录与章节组织；
- 确定性版式与 PDF；
- 私有 proof 与 final delivery；
- 后续实体印刷/寄送；
- 数据保留、删除和第三方处理说明。

### 第一阶段 MVP 边界

- 先证明数字 PDF；
- 用有限食谱数量和固定模板，避免第一版成为开放式排版编辑器；
- OCR/AI 只帮助转录与整理，final 事实必须可追溯到输入/用户确认；
- 先验证订单级私有上传/交付，再决定实体印刷；
- 可保留人工异常处理，但标准路径应尽量可自动化。

### 当前明确非目标

- 通用 OCR SaaS；
- 通用文档扫描器；
- Canva/Figma 替代品；
- AI 自动“修正”老食谱；
- 首轮就支持无限食谱/无限页数；
- 首轮就支持复杂 POD 全球印刷；
- 在技术/交易/经济性未验证前构建大型共享平台。

## 5. 成功标准

### Solution Proof

- 混合难度的真实风格 fixture 能被处理，而不是只测清晰印刷体；
- recipe schema 对关键字段不丢失 provenance；
- 低置信字段能稳定 fail-closed；
- 用户/Reviewer 能看到原图与转录的对应关系；
- 多食谱能稳定进入固定模板并生成可打开 PDF；
- 文本溢出、缺图、页数、目录/索引等能自动检查。

### Paid MVP

- 已支付订单才能进入付费 OCR/结构化/生成链；
- 买家素材与订单准确关联；
- 未授权用户不能访问原始上传、proof 或 final PDF；
- 重复 callback/刷新不会重复生成和重复花费；
- 生成失败不会丢订单/素材；
- 退款/取消后的 entitlement 行为明确；
- 成品与用户批准版本一致。

### Physical Print Gate

实体印刷只有在数字产品质量稳定后才进入独立 Gate，必须验证：

- 纸张/尺寸/装订/出血；
- 色彩、裁切、图片分辨率；
- 单本成本与运费；
- 地址/隐私数据流；
- 生产区域与交期；
- 追踪；
- 重印/退款；
- 样书质量。

## 6. Gate 路线

| Gate | 要回答的问题 | 通过后允许 |
|---|---|---|
| P0 Governance Intake | 项目真相、边界、Handoff 是否建立？ | 进入解决方案验证 |
| G1 Core Product Boundary | 产品到底解决什么、不解决什么？ | 冻结“保真成书”方向 |
| G2A1 Input/OCR/Component PoC | OCR、结构化、uncertainty、上传/私有交付是否可行？ | 进入精确 MVP 冻结 |
| G2A2 MVP Contract Freeze | 食谱数、页数、字段、校对、修改、QA、数据规则是否明确？ | 开始 OCR→PDF 实现 |
| G2B Local Solution Proof | 输入到 cookbook PDF 是否端到端稳定？ | 做本地 Commerce |
| G3A Commerce Loop | WooCommerce 订单/状态/素材关联是否闭环？ | 连接支付 Sandbox |
| G3B Payment Sandbox | 支付→entitlement→job→private delivery 是否闭环？ | 真实 Canary |
| G4 Live Canary | 单笔真实交易能否安全完成/退款/恢复？ | 小规模真实订单 |
| G5 Repeatability/Economics | 多单质量、工时、模型/存储/客服/CAC 是否成立？ | 决定扩大 |
| G6 Production/Print | 生产加固、存储、备份、实体印刷是否成立？ | 扩展产品 |

## 7. 主要风险

| 风险 | 影响 | 缓解 |
|---|---|---|
| 手写 OCR 错把 1/2、1/4、7、1 等关键数字识别错 | 直接改变配方 | 保留原图、低置信 review、关键字段特殊 QA |
| AI 为了“合理”补齐缺失配方 | 破坏家庭原始记录 | 禁止 silent inference；所有推断必须显式且默认不进入 final |
| 照片质量差/阴影/倾斜 | OCR 不稳定 | 图像预处理 + fixture benchmark + 上传质量提示 |
| 多语言/混写 | 识别错误 | G2A1 按实际首发语言 benchmark，未验证语言不承诺 |
| 客户上传家人照片和私人信息 | 隐私风险 | 私有存储、最小权限、删除/保留策略、分析日志不写内容 |
| 每本需要大量人工校对 | 毛利受损 | 记录每单 review minutes、uncertain-field count 和返工 |
| 实体印刷过早引入 | 范围/成本爆炸 | 先 digital-first 技术证明，print 独立 Gate |

## 8. 当前未决事项

- 首发国家/语言；
- 目标买家细分；
- 测试价格；
- 每本包含多少食谱/页；
- 是否提供不同套餐；
- 是否允许客户直接在线修正 OCR；
- 包含多少次 proof/revision；
- 何时提供实体版；
- 支付 Provider/account；
- OCR/VLM/provider；
- PDF render；
- 数据保留/删除政策；
- 生产部署位置。
