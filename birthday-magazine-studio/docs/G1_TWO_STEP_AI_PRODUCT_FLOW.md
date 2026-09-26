> **Governance status: CURRENT SUPPORTING PRODUCT-FLOW DESIGN.**  
> This document contains detailed design hypotheses. Accepted decisions, implementation status, current Gate and UNKNOWNs remain controlled by [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md).  
> It is not evidence that payment, AI generation or PDF delivery is implemented.

# 两步式全 AI 生日杂志：产品与生成流程

更新时间：2026-09-26

## Owner 已确认

| 决策 | 项目记录 |
|---|---|
| 首测价格 | **US$39.99** |
| 预算与订单上限 | Owner 不要求设置预设预算或订单数量上限；不代表允许重复扣款/无限重跑生成 |
| 首发/目标市场 | 美国优先，面向其他海外市场；具体国家清单待定 |
| 首发语言 | 英语（沿用此前决定）；多语言本地化待定 |
| 产品形态 | 生日纪念杂志电子 PDF |
| 生产方式 | 目标为全 AI 自动生成；只有付款后才调用生成模型 |
| 预览方式 | 付款前提供不调用 AI 模型的免费预览 |
| 商店 / 订单 | **WordPress + WooCommerce** |
| 支付 | **PayPal，使用官方 WooCommerce PayPal Payments；实现顺序参考 Mini Craft** |

US$39.99 是 Owner 指定的测试价，不是竞品推导的价格判断。预算/订单上限按 Owner 指示不设硬值，但每笔订单仍须限制意外重复生成并记录实际成本。

## 方案结论

借鉴 Conversion Leak Audit 的价值分层方式：用户可先获得不依赖 LLM 的免费体验；需要完整个性化结果时再付费。Conversion Leak Audit 当前是“确定性规则免费呈现 Top 3、LLM 仅解释结构化发现”的产品架构参考；它的 README 仍将真实支付列为后续阶段，因此这里复用的是分层和 token 边界思路，不是现成可直接用的支付或杂志生成插件。

- [Conversion Leak Audit README](https://github.com/entropy-student/project/blob/main/conversion-leak-audit/README.md)
- [Conversion Leak Audit Architecture](https://github.com/entropy-student/project/blob/main/conversion-leak-audit/docs/ARCHITECTURE.md)

## 用户流程

~~~text
商品页
→ 免费预览（固定模板 + 浏览器本地照片/文字；不请求 AI）
→ WooCommerce Checkout
→ PayPal 支付 US$39.99
→ 服务端确认 PayPal/WooCommerce 已付款状态
→ 订单空间上传完整照片、回答问题
→ 服务端确认「已付款 + 资料完整 + 无重复任务」
→ 创建唯一 generation job
→ AI 编写/整理内容 + 系统模板排版 + PDF 生成与自动检查
→ 买家查看该订单的个性化 proof
→ 按已公布的修改政策确认/请求修改
→ 最终 PDF 安全交付
~~~

这里有两种不同预览，商品页的免费预览是“让用户看到风格和基本版式”，付款后的 proof 才是“该买家完整个性化内容”。不能把免费模板预览描述成已经生成过整本杂志。

## 第一步：零 AI Token 的免费预览

### 体验

- 用户选一个杂志视觉风格，输入寿星称呼/年龄等少量非敏感字段。
- 可选上传 1 张封面照片；浏览器用固定页面模板实时替换文字和图片，展示封面和 1–2 个样例跨页。
- 图片用浏览器本地预览，不上传到服务器、不传给模型；离开或刷新后可清除。
- 预览低分辨率并加水印，不提供完整 PDF 下载或可直接送礼的整本定制成品。
- CTA 清楚显示“Unlock your complete AI-generated birthday magazine — US$39.99”。

### Token 与成本边界

- 预览代码不调用 LLM、图像识别或图像生成 API，因此**模型 API Token 用量为 0**。
- 本地 DOM/Canvas/PDF 预览仍可能有网页托管、带宽和浏览器计算成本；“零 Token”不等于所有基础设施成本为零。
- 若把预览照片上传到服务器、调用 OCR/视觉模型、云端渲染或调用 AI 改写，即使只展示一页也会发生非零成本。要维持严格零模型费用，预览只做浏览器本地的确定性合成。
- 预览页只展示少量基本字段。完整故事采集、照片批量上传和 AI 内容生产放在支付后，减少免费试用时的隐私数据收集。

## 第二步：付款后的 AI 正式制作

付款采用 **WooCommerce → 官方 WooCommerce PayPal Payments → PayPal**。实现顺序参考 Mini Craft：先验证 WooCommerce 本地订单闭环，再验证 PayPal Sandbox checkout/capture/callback/refund，最后才允许进入 bounded Live Canary。

仅当服务端确认 WooCommerce/PayPal 已付款状态，且必填资料完整时，才允许建立生成任务。不得让浏览器成功页、return URL 或单次前端状态直接决定付款成功。

核心授权条件：

~~~text
GENERATION_ALLOWED =
  payment_entitlement_confirmed
  AND intake_complete
  AND canonical_generation_job_absent
~~~

免费预览、未付款订单、付款失败/取消订单均不得触发任何 LLM、视觉或图像生成调用。

| 子步骤 | 自动化工作 | AI/API 成本 |
|---|---|---|
| 订单初始化 | 验证支付事件与订单状态；给订单绑定唯一生成任务 | 无模型费用 |
| 素材采集 | 买家在专属订单页上传 8–12 张照片并回答结构化问题 | 文件存储/传输成本；仅在调用视觉模型时产生 Token |
| 事实结构化 | 将姓名、关系、回忆、喜好、生日寄语等整理成字段；约束模型只依据用户输入写作 | 文本/可能的视觉输入 Token |
| 内容撰写 | 为封面、人物简介、共同回忆、趣味事实、信件等页面生成短文案 | 文本 Token |
| 版面排版 | 固定模板/确定性排版引擎选择版块、放置用户原照片并输出页面 | 主要是服务器 CPU/内存，不需要用 LLM 决定像素 |
| PDF 生成 | 后台渲染 12 页 US Letter PDF，生成订单私有 proof | 服务器渲染/存储成本 |
| 自动质量检查 | 检查页数、姓名/年龄字段、必填内容、图片缺失、文本溢出和 PDF 是否可打开；不通过时进入有限的错误处理 | 若重跑 AI 会再次花费 Token |
| 成品交付 | proof 安全展示；确认/修改后最终 PDF 按订单私有链接发送 | 邮件、下载带宽和存储成本 |

### 为什么“全 AI”不等于让模型自由画每一页

建议让 AI 负责故事整理和文案，使用固定设计系统负责排版、字体、图片裁切和 PDF。这样无需客户学 Canva，同时可控制品牌一致、分页、价格和质量。第一版用买家原照片，不给每一页再生成一张装饰图；如以后增加 AI 图片，单独计价和告知。

### 生成任务控制

- 一个已付订单绑定一个唯一 generation job；重复支付 Webhook、刷新页面和重复点击不能创建重复任务。
- AI Provider Key 只保存在服务端 Secret/环境配置，浏览器与 WordPress 页面不暴露密钥。
- 记录每个订单的模型、输入/输出 Tokens、视觉请求数、重试、耗时、失败原因和实际美元成本。
- 自动重试必须有状态和次数控制；用户主动重新生成/修改也可能再次花费 Token。应在商品页明确哪些修改包含在 US$39.99 内，超出范围是否加价。
- 免费预览不调用模型；未付款时不得后台预生成完整故事或先生成再隐藏。
- 付款成功但 AI 服务失败时，不应丢失订单；保留任务状态并提供可追踪的重试/退款/人工处理路径。

## 价格与 AI 成本粗估

### 收款费

支付渠道已固定为 **PayPal**。实际手续费、跨境费、币种转换费与结算条件取决于最终 PayPal 商户账户所在国家/地区及交易类型，因此当前**不写死费率**。试点必须按真实订单记录 PayPal 实扣手续费，不用 Stripe 或其他渠道的费率代替。

### 文本 Token 示例（仅用于数量级判断，不是供应商选型）

OpenAI 当前 API 定价页中，GPT-6 Luna 的标准短上下文价列为每百万输入 Token US$0.05、每百万输出 Token US$0.25。若单笔示例为 20,000 输入 + 10,000 输出 Token，则文本费用约 **US$0.0035**。真实请求若多轮生成、含视觉图片、重试或换用其他模型，费用会不同；该计算不能代表每本 PDF 的完整 AI 成本：[OpenAI API Pricing](https://developers.openai.com/api/docs/pricing)。

图像模型另按图像 Token/分辨率/质量计费。OpenAI GPT-Image-1 Mini 当前文档列出的单张图像生成价按尺寸与质量约 US$0.005–0.052。建议 MVP 不生成大量 AI 插画，而把顾客照片放进程序化模板；若以后添加，应给订单设置单独的图像预算估算并先向客户说明：[GPT-Image-1 Mini model](https://developers.openai.com/api/docs/models/gpt-image-1-mini)。

### 试点经济性记录

每单贡献利润仍按下式计算：

成交价 US$39.99 − 实际收款费 − 文本/视觉 Token − 额外重跑/修改 − 文件存储与下载 − 邮件/托管分摊 − 退款准备 − 获客费用。

总预算/订单数不封顶，但要按订单看到收入、模型实际用量和毛利；连续出现异常的单笔生成费用时，先暂停该生成任务并排查调用链，避免程序错误造成 Token 消耗失控。

## WordPress + WooCommerce + PayPal 实现基线

- **WordPress + WooCommerce 已从候选升级为本项目 accepted commerce baseline**，负责品牌站、产品页、Checkout、订单、支付状态和下载记录。
- **支付固定使用官方 WooCommerce PayPal Payments**；不手写 PayPal API，不引入第二套 canonical order system。
- 支付 Gate 参考 Mini Craft 的顺序：WooCommerce 本地 commerce loop → PayPal Sandbox → order/provider correlation → callback/webhook → refund → 后续 bounded Live Canary。
- 免费 preview 可作为独立前端页面/轻型自定义插件，前端模板合成并不需要 AI 插件。
- 订单支付后触发后台 generation job；生成和 PDF 渲染属于耗时工作，建议经服务端队列/worker处理，不把全部工作塞进一次 WordPress 前端请求。
- 输入照片应绑定订单并私有存储。前面调研的 PPOM、Vanquish Upload Files 和订单附件插件只是候选，必须检查访客订单权限、文件可发现性、Webhook 幂等和实际 PDF 下载授权。
- WooCommerce 原生下载是付费成品的授权/通知能力，不负责内容生成。确认订单下载授权只绑定该订单、支付成功后才开放。
- 采用此前的 Blocksy + WooCommerce 是轻站候选，不代表全 AI 架构已经能仅靠“安装插件”实现；表单到生成任务、LLM Prompt、版面映射、PDF QA 和回调仍需要自定义 glue code 或自动化服务。

## 国际市场范围

- Owner 指定美国为首要市场，并希望覆盖其他海外国家。首版已沿用英语；具体国家/地区、币种展示、商户开户地、税务、隐私告知和当地消费者条款尚未锁定。
- 定价暂以 US$39.99 为基础标价。其他市场显示当地币种或加收/含汇兑费需单独做支付和汇率方案，不假设所有国家同一费率。
- 仅开放到支付、数据隐私和交付条件已确认的国家/地区。当前调研未完成逐国税务或消费者法审查。
- 商户所在注册国和银行账户地仍是支付集成前置输入，不影响先制作无 Token 浏览器预览 PoC。

## 尚待 Owner 决策 / 研发前置

| 项目 | 当前建议/状态 |
|---|---|
| 首测价 | 已确认 US$39.99 |
| 整体试点预算与订单上限 | Owner 不要求设置；按订单记录成本，不设硬上限 |
| 目标国家 | 美国优先；其他海外国家需要再列允许地区清单 |
| 首发语言 | 英语 |
| 修改政策 | 是否含额外免费 AI 再生成/客户更改要求，待定 |
| 商户注册/收款国家 | 待提供；PayPal 已定，但账户资格、实际费率、结算币种仍需按最终商户账户确认 |
| 免费预览 | 前端固定模板本地生成；不请求任何 AI Provider；未实现 |
| 正式 AI 生成 | 付款和订单资料完整后，后台生成；当前尚未实现 |
| WordPress/PDF/文件访问 | 候选已调研，尚未部署或集成 |

## 推荐下一步

1. 冻结免费的本地预览规格（封面 + 1–2 个样例页面、上传图片不上服务器）。
2. 定义付费后问卷、照片数量、AI 生成输出结构和 QA 条件。
3. 先按 Mini Craft 路径完成 WooCommerce 本地订单闭环与 PayPal Sandbox；再把“已付款 entitlement → 唯一生成任务 → 私有 proof → final PDF”接通。
4. 记录每单 API 用量、重试和存储成本；再决定额外重新生成规则以及开放哪些国际市场。
