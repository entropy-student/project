# 获客与验证计划：Birthday Magazine Studio

依据：[Acquisition Growth Radar](https://github.com/entropy-student/spike.skill/tree/main/acquisition-growth-radar)。采用 Evidence → Bottleneck → Lever → Experiment → Decision；明确区分 Owner 决策、市场线索和本项目成交。

## 当前阶段

需求由 Owner 报告为已验证。Owner 已锁定 **US$39.99**、美国优先并面向其他海外市场、英语首发、免费零 AI Token 预览和付费后全 AI 生成。没有设置预设试点预算或订单数量上限。需求验证细节待归档；具体预览转化、本项目实付、生成质量和单位经济仍未测。

产品流程方案见 [两步式全 AI 生日杂志](./G1_TWO_STEP_AI_PRODUCT_FLOW.md)，offer和实现候选见 [G1 剩余调研](./G1_REMAINING_RESEARCH.md)。

## Validation Spine

| 证据层 | 状态 | 结论 |
|---|---|---|
| Problem Evidence | Owner 报告已验证；详情未归档 | 保留 Owner 输入；补样本/行为摘要以便复核 |
| Solution Proof | 方向已定，未实现 | 本地预览模板、AI 内容生产和 PDF 成品未制作 |
| Attention / Interest / Intent | 未测 | 免费预览尚未上线，无预览完成率/结账启动数据 |
| Transaction | 未测 | 无本项目实付订单 |
| Repeatability / Economics | 未知 | 无每单模型用量、重跑、收款、存储、退款、CAC 与利润数据 |

## 当前 Lever：免费预览 → 付费解锁 AI 成品

- 第一步提供浏览器本地静态版式预览，不调用 LLM、视觉或图像生成 API；让用户体验视觉方向。
- 付费墙显示固定价 **US$39.99**；买家支付后上传完整照片并回答问题。
- 第二步由后台全 AI 生成内容、固定模板排版、质量检查、proof 与 final PDF。
- 试点区域：美国优先；面向其他海外市场，初期英语。目标国家/商户收款地需后续明确。
- 预览不能让免费用户下载完整可送礼 PDF；必须让付费后生成的内容更完整、更个性化，形成真实价值边界。

这一模式借鉴 Conversion Leak Audit 的确定性免费体验与付费增值边界；其真实收费链路当前仍未上线，所以是架构参考，不是已验证的转化率证据。

## 实验与数据

不设置预设总预算或订单数上限（Owner 已决定），仍需逐层记录转化与成本，避免只看总流量。

| 环节 | 事件/指标 |
|---|---|
| 访问 | market/country、language、traffic source、landing_view |
| 预览 | preview_started、preview_completed、preview_style_changed；确认预览端未请求 AI Provider |
| 付费意向 | offer_viewed、checkout_started、payment_completed、退款/放弃原因 |
| AI 生产 | intake_completed、generation_started/completed/failed、proof_viewed、revision_requested、pdf_delivered |
| 单笔经济 | 支付费、文本/视觉 Token、重试用量、图片/PDF 存储、邮件、退款、获客来源成本 |

按照用户同意和隐私说明记录必要的事件；不要把照片、问卷答案或原始亲友信息写进分析事件日志。

## 决策逻辑

- **预览体验**：测是否从预览进入结账，而不是把预览打开次数当作成交。
- **真实价值**：记录 US$39.99 是否实付、买家是否打开 proof 并完成交付。
- **自动化成本**：按订单核对实际模型 usage 和重跑，不用平均 token 数掩盖个别异常。
- **质量**：统计自动 QA 拦截、姓名/事实错误、PDF 失败、退款和客户主动重新生成。
- **扩展国家**：除美国外，先验证支付、币种展示、法律/税务与客服处理，再开放该国家。
- 用户不设预算/订单硬上限；如系统发生循环 Webhook 或异常高频模型调用，按运行故障处理并暂停异常任务，而不是压低正常订单量。

## 当前决策

G1 进入 **两步式全 AI 生日杂志 PoC**。下一步是做零 Token 本地预览，以及支付后订单任务到 AI 生成/私有 PDF 的技术规格；支付生产前确认卖家收款国家。任何实现和点击数据都不等于交易验证；要以真实付款、成功交付和逐单成本决定是否继续扩大。
