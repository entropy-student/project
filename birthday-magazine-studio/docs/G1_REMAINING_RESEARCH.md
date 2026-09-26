# G1 剩余调研：产品规格、履约、经济性与 WordPress MVP

调研日期：2026-09-26  
项目范围：美国英语市场；首轮交付为个性化电子 PDF。家庭食谱书不在本项目范围内。

## 结论摘要

- Owner 表示“需求已验证存在”。项目记录据此更新为 **Owner 报告的需求验证**；目前尚未把验证的样本、日期、渠道、方法和行为证据归档到项目库，因此不能把它写成独立审计通过，也不能推导出本产品已获得订单。
- 最适合先试卖的是“人工/AI 辅助制作 + 客户在线确认 PDF proof + 最终 PDF 交付”。不用先开发自动排版系统，也不需要先接印厂。
- 竞品显示跨度很大：DIY Canva 模板约 US$5.19（促销快照）、单封面定制 US$10.99、人工定制 32 页 PDF US$165。它们是 Etsy 列表快照，不等于本项目的可实现售价或成交证据。
- 建议供 Owner 决策的试点 Offer 假设：**12 页 Mini Birthday Edition，8–12 张照片，6 个短问答，1 次合并修改，建议测试价 US$69**。页数、工时、交期和售价都必须用样刊与真实订单验证。
- WordPress MVP 建议方向：Blocksy 免费主题 + WooCommerce + 一个订单素材采集插件 + 一个逐单文件交付办法 + Stripe/WooCommerce 网关（须先确认商户注册/收款国家）。这是一条候选路线，不是已批准或已实测的生产选型。

## 一、竞品与 Offer 定价锚点

| 可比商品 | 当前页面快照 | 买家自行完成的工作 | 对本项目的启示 / 限制 |
|---|---|---|---|
| [DIY 54 页 Canva 生日杂志模板](https://www.etsy.com/listing/4405876465/birthday-magazine-template-personalized) | 页面显示促销价 US$5.19、原价 US$12.98；54 页，用户自己填照片和文字；页面聚合 34 条商品评论 | 买家用 Canva 自己编辑、排版和导出 | 低价替代清楚地锚定“模板很便宜”；我们的溢价必须来自替买家组织内容、完成设计、校对和提供预览 |
| [定制数字杂志封面](https://www.etsy.com/listing/1682864935/custom-magazine-cover-digital-file) | 页面显示 US$10.99；数字文件，无实物；页面称照片经 Etsy 消息/邮件提交，通常 24 小时内邮件交付 | 买家提供封面信息和照片，卖家只做封面 | 代表小范围快速定制的低端服务，不等于一本完整杂志 |
| [32 页定制生日杂志 PDF](https://www.etsy.com/listing/4377447022/custom-vogue-style-birthday-magazine) | 页面显示 US$165；32 页；包含 3 次修改；在全部资料收到后通常 3–7 个工作日；电子 PDF | 买家提交高分辨率照片、文字/回忆、风格偏好和指定版块 | 最接近“免 Canva、全包设计”的公开可比项；也揭示输入要求和修改轮次会影响工时 |

以上是动态市场页面，价格、促销、评价和交期会变化。Etsy 上的卖家总店销量不能视为单个商品销量。来源：[DIY 模板列表](https://www.etsy.com/listing/4405876465/birthday-magazine-template-personalized)、[定制封面列表](https://www.etsy.com/listing/1682864935/custom-magazine-cover-digital-file)、[32 页定制服务列表](https://www.etsy.com/listing/4377447022/custom-vogue-style-birthday-magazine)。

### 推荐测试 Offer（待 Owner 决策，不代表已验证价格）

**英文定位草案：**  
“Turn their photos and memories into a birthday magazine. We handle the story structure and layout, then send you a digital proof to approve before delivering the final PDF.”

| 项目 | 首测建议 | 状态 |
|---|---|---|
| 商品名 | Mini Birthday Edition | 假设 |
| 成品 | 12 页、US Letter PDF；可屏幕分享，也可供用户自行打印 | 假设；样刊验证后定稿 |
| 输入 | 最多 8–12 张照片 + 6 个简短问题（称呼/年龄、关系和相识、3 个性格/趣事、共同回忆、喜好/歌单、生日寄语） | 假设 |
| 内容结构 | 封面、编辑短序、人物档案、相识/时间线、共同记忆、趣味事实/最爱、朋友寄语、生日信、照片收尾 | 假设 |
| 客户确认 | 先发逐单数字 proof；含 1 次合并修改；避免反复零散返工 | 假设 |
| 交期承诺草案 | 资料完整后 5 个工作日内发首版 proof；确认后 2 个工作日内交付最终 PDF | 需用计时样刊和试点确认后才能公开 |
| 售价锚点 | 建议从 US$69 做一个固定价测试；若 Owner 不接受，可在 US$59–79 中选定单一公开价后再测 | 未验证，Owner 批准前不可当作最终定价 |
| 不包含 | 实体印刷、加急、额外修改、客户自助编辑器 | 首测范围 |

**价格解释：** US$69 明显高于 DIY 模板和单封面服务、低于一个公开的 32 页全定制服务。由此可做价格假设，但页面对比不能证明买家愿意为 12 页版本付 US$69。测试时只展示一个价格，避免把小样本的多价测试误当成有统计意义的价格弹性。

## 二、低复杂度人工交付流程

1. **商品页展示**：明确“数字 PDF、没有实物寄送”；展示 3–5 张自制/获授权的样刊页面；写清页数、所需素材、交期、一次合并修改和联系渠道。
2. **支付后采集**：支付成功后发送订单专属素材表单/订单页，让用户上传照片、回答问题并确认有权提供照片。把素材绑定订单，避免将未下单访客的亲友照片长期留在站上。
3. **制作**：运营者用模板人工/AI 辅助组织文字与排版，人工校对姓名、年龄、人物关系、照片和拼写；保存工时、工具、异常。
4. **预览**：给该订单附上私有 proof PDF，邮件通知买家核对；首测以邮件回复收集一次合并修改。首测不需要付费在线翻页审批系统。
5. **交付**：上传最终 PDF 到订单私有附件/下载权限，订单邮件通知；记录是否成功打开/下载及买家是否接受。
6. **结单与数据清理**：记录订单状态、制作时间、修改、退款/补做和支付费；按已披露的保留规则删除不再需要的原始照片和中间文件。

### 单位经济公式

贡献利润 = 成交价 − 支付手续费 − 实际制作人工 − 邮件/存储/AI 等逐单成本 − 退款/补做准备金 − 获客成本。

若用美国 Stripe 标准国内卡费率举例，US$69 订单手续费约为 **US$2.30**，扣费后约 US$66.70，尚未减人工、工具、税和获客成本。Stripe 官方当前列出国内卡每笔 2.9% + US$0.30；实际费用以商户所在国家、卡种和账户费率为准：[Stripe Pricing](https://stripe.com/pricing)。

**试点必须计时**：至少记录样刊和每笔订单的素材沟通、制作、校对、修改、售后时间。售价还没有扣除工时，当前不能说利润已验证。

## 三、WordPress 免费开源 MVP 候选

| 功能 | 推荐候选 | 免费/开源和匹配点 | 缺口、风险及选择条件 |
|---|---|---|---|
| 网站外观 | [Blocksy](https://wordpress.org/themes/blocksy/) 免费主题；或 WooCommerce 的 Storefront | Blocksy 在 WordPress.org 页面标为免费主题，活跃安装量 300,000+，有 WooCommerce 支持 | Starter Sites 有的设计可能涉及付费版；模板只做网站外观，不生成生日杂志。演示站导入前在空白测试站检查许可和依赖 |
| 商品、订单、结账 | [WooCommerce](https://wordpress.org/plugins/woocommerce/) | WordPress.org 的开源免费电商核心；可管理数字/实体商品、购物车、订单 | 原生没有自动问答转故事、多页编排或逐单设计能力 |
| 商品问卷与照片上传（较成熟候选） | [PPOM Product Addons](https://wordpress.org/plugins/woocommerce-product-addon/) | WordPress.org 开源；页面列有文本字段、File Upload（文件类型/大小、进度条、缩略图）；活跃安装量 20,000+ | 应确认免费字段组合、上传数量和文件如何进入订单；更适合商品页先收集素材，可能会在未付款前接触私人图片 |
| 订单后照片采集（流程匹配、生态较新） | [Vanquish Upload Files](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/) | 免费版可在商品、购物车、结账和订单页放多个上传字段，每字段一个文件；支持文件类型/尺寸限制、订单关联、分块上传；可让订单提交后补上传 | 当前 WordPress.org 页面显示安装量仅 20+；先在暂存站确认访客订单的专属链接、登录要求、文件访问权限和移动端上传。每张照片需要一个上传字段 |
| 逐单 proof/final PDF | [Vanquish Attach Me](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/) | 免费版可把文件附到具体订单并放在订单页/标准订单邮件；官方描述为订单权限检查后的私有链接，文件留在自有服务器 | 当前安装量少于 10；买家在线审批、自动过期/下载次数限制属于付费功能。首测用“私有 proof + 邮件回复”绕开付费审批；上线前必须实测安全与访客下单行为 |
| 样刊预览 | WooCommerce 商品相册放 3–5 张自制/获授权样刊页面 | 免费、直观、不依赖另一个翻页插件 | 是公开样刊预览，不是个人定制 proof；私人 proof 在支付后订单页面查看 |
| 付款 | [WooCommerce Stripe Gateway](https://woocommerce.com/document/stripe/) | WooCommerce 扩展可免费安装使用，官方称无开通/月费；Stripe 另收交易费 | 只有商户主体/银行账户所在地支持且通过 Stripe 入驻后才能用。买家在美国不代表卖家商户也在美国 |
| 付款后的静态下载 | WooCommerce 原生 downloadable product | 付款后可以在订单页、邮件和账户页开放文件下载：[官方文档](https://woocommerce.com/document/digital-downloadable-product-handling/) | 适用于预先固定的文件；不会自动为每单生成 PDF。逐单成品要绑定正确订单并限制访问 |
| 交易邮件 | [Resend](https://resend.com/pricing) 作为低量候选 | 当前免费档 3,000 封/月、每天最多 100 封 | 需验证 WordPress 的邮件接入、域名 SPF/DKIM、送达情况和隐私条款；超限/升级费用以后复核 |
| 主题/插件和托管预算锚点 | Bluehost WordPress Starter / Business 仅作比较样例 | 官方目前列 Starter 首期 US$3.99/月（36 个月）后续同为 36 个月续订 US$9.99/月；Business 首期 US$6.99/月，续订 US$13.99/月 | 促销有长合约；WooCommerce 商店是否需要更高规格需实际配置判断。不要以促销价代替长期预算；购买前复核结账页：[官方价格](https://www.bluehost.com/pricing/wordpress-hosting) |

**简化建议：** 先做“Blocksy + WooCommerce +（PPOM 或 Vanquish Upload 二选一）+ 逐单私有 PDF 附件方案”。上传插件不同时装两款。先验证支付→素材归单→私有 proof→反馈→final PDF→邮件这一条路径；若文件插件暂存核验不过，先用人工方式向订单发私有、可撤销的文件链接，不要用任何人拿到 URL 都能访问的公开链接。

## 四、可预计的成本项

| 成本 | 初步预算方式 | 已知信息 / 未知项 |
|---|---|---|
| WooCommerce、候选免费主题和免费插件 | US$0 软件许可费 | 托管、域名、付费升级、维护不含在内 |
| WordPress 托管 | 以约 US$10–14/月续费价做小站初始比较，不代表最终采购 | Bluehost 价格示例见上；需比较备份、暂存站和上传容量 |
| 域名 | 在结账时确认首年/续费价格 | 取决于注册商与域名后缀 |
| 邮件 | Resend 当前免费档可能足够低量试点 | 需验证 SMTP/API 集成和域名认证 |
| 收款 | 以实际商户国家费率计算；如果适用美国国内卡标准费率，2.9% + US$0.30/笔 | US$69 示例手续费约 US$2.30 |
| 制作人工 | 每单实际工时 × Owner 认可时薪/机会成本 | 当前未知，最关键的可变成本 |
| AI、素材存储与备份 | 记录按订单实际调用费用 | 若第三方 AI/存储处理买家图像，须先检查数据用途、留存和删除政策 |

美国数字商品的销售税义务不能仅靠 WooCommerce 插件决定。WooCommerce Tax 文档说明它按配置计算税额，但不会判断商户是否有纳税义务，也不会申报或代缴；应结合卖家主体所在地与销售范围请税务专业人士确认：[WooCommerce Tax Guide](https://woocommerce.com/document/woocommerce-shipping-and-tax/woocommerce-tax/)。

## 五、政策与客户素材处理

- 商品页和结账前清楚显示：数字 PDF、不会寄实体、页数/文件规格、开始制作条件、首版时间、修改次数、客户需要提供什么、客户如何提交反馈。
- 拟定取消/退款/错误更正流程：开工前的取消如何处理；开工后的个性化制作如何沟通；卖家错误、文件无法交付或长时间延迟时如何补正/退款。不要照抄竞品“All sales final”；当前没有对个性化数字服务退款法律适用范围作法律结论，上线前需根据商户所在地和目标市场复核条款。
- 对买家提交的照片/朋友信息采取最少收集、限制访问、传输加密、设定保留与删除期限；只用于订单制作。FTC 的企业资料保护指南建议盘点、减少、保护并在不再需要时妥善处置个人信息：[FTC Guide](https://www.ftc.gov/business-guidance/resources/protecting-personal-information-guide-business)。
- 不要默认把顾客照片上传到公开素材库或用于营销、模型训练。若计划用第三方 AI/设计/存储服务，先查供应商条款、数据留存与训练政策，并在采集页面说明处理方式。
- 素材表单增加“我有权提交这些照片/文字用于本订单”的确认，并单独征求可选营销展示许可，不要把营销授权设为购买条件。

## 六、进入建站前的决策门

| 决策 / 产物 | 为什么需要 | 当前状态 |
|---|---|---|
| 记录“需求验证”的证据摘要（样本、时间、渠道、发生了什么） | 让项目库可审计；不否认 Owner 当前确认 | Owner 口头确认存在，细节未归档 |
| 英文 12 页样刊和交付 SOP | 验证可看、可改、可导出并估算工时 | 未制作 |
| 选择一个固定试点价（建议测试锚点 US$69）与支出/接单上限 | 付费验证必须是具体可购买 Offer；防止小样本多变量混淆 | 待 Owner 决策 |
| 确认商户主体和收款账户国家 | 决定 Stripe 是否可开户、结算、手续费和税务配置 | 买家市场已选美国；卖家所在地未知 |
| 上传和逐单附件插件暂存验证 | 检查订单关联、访客访问权限、手机端和安全链接 | 候选已调研，未安装/验证 |
| 公开交期、修改、取消/退款和隐私条款 | 形成可理解且可履约的承诺 | 待样刊和商户信息后起草 |
| 单笔工时与成本表 | 判断每单贡献利润与是否值得自动化 | 未验证 |

### 下一步建议

1. Owner 决定是否以 US$69 作为首个公开测试价，并给出试点投入上限和可接单数。
2. 制作 1 份英文 12 页样刊，计时完成素材整理、排版、校对、修改和导出。
3. 再用 WordPress 暂存站做最小链路 PoC；确认商户收款主体国家后选择支付方式。
4. 完成以上后才开放真实订单。初期人工制作；只有当重复订单、工时和贡献利润支持时，再开发自动生成。

## 来源快照

- Etsy：[DIY 模板](https://www.etsy.com/listing/4405876465/birthday-magazine-template-personalized)、[数字封面](https://www.etsy.com/listing/1682864935/custom-magazine-cover-digital-file)、[32 页定制 PDF](https://www.etsy.com/listing/4377447022/custom-vogue-style-birthday-magazine)
- WordPress.org：[Blocksy](https://wordpress.org/themes/blocksy/)、[WooCommerce](https://wordpress.org/plugins/woocommerce/)、[PPOM](https://wordpress.org/plugins/woocommerce-product-addon/)、[Vanquish Upload](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/)、[Vanquish Attach Me](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/)
- 官方产品文档：[WooCommerce 下载品](https://woocommerce.com/document/digital-downloadable-product-handling/)、[WooCommerce Stripe](https://woocommerce.com/document/stripe/)、[WooCommerce 税务](https://woocommerce.com/document/woocommerce-shipping-and-tax/woocommerce-tax/)、[Stripe Pricing](https://stripe.com/pricing)、[Resend Pricing](https://resend.com/pricing)、[Bluehost Hosting](https://www.bluehost.com/pricing/wordpress-hosting)
- 隐私：[FTC Protecting Personal Information](https://www.ftc.gov/business-guidance/resources/protecting-personal-information-guide-business)
