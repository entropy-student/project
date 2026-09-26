# WordPress 模板与插件候选（调研快照）

调研日期：2026-09-26。插件版本、活跃安装量、服务价格和功能边界会变化；进入 PoC 前应再次核对官方页面、隐私政策、服务条款和结账/履约实测结果。

## 结论摘要

WordPress 有免费的电商模板、订单插件和上传/编辑组件可复用，但截至本次检索，没有发现一个免费开源模板能直接完成这条完整链路：

```text
问答 + 多张用户照片
→ 自动生成有故事结构的逐单生日杂志
→ 逐页预览 / 买家确认
→ 订单支付
→ 逐单 PDF 自动交付 / 实体成书寄送
```

比较现实的路线是：免费主题与 WooCommerce 承接站点和订单；一款组件负责素材采集/画布预览；杂志内容生成、版面编排、单订单 PDF 授权与生产履约仍须通过 PoC 确认（可能需要小型定制开发或云服务）。如果为验证市场先人工/AI 辅助制作，可暂缓搭完整生成系统。

## 能力比较

| 候选 | 免费 / 开源状况 | 照片上传 | 商品制作 / 版面编辑 | 预览 | 下单 / 支付 | 付款后自动交付 | 适合用途与优缺点 |
|---|---|---|---|---|---|---|---|
| [Blocksy + Starter Sites](https://wordpress.org/themes/blocksy/) | WordPress.org 免费主题；有付费升级，免费/Pro 起步站需按模板查看 | 否 | 只搭站点外观，不编排杂志 | 页面预览 | 需配 WooCommerce 和支付网关 | 否 | 快速做品牌页和产品页的候选，主题本身不等于个性化产品生成器；导入演示站前用空白/测试站 |
| [WooCommerce](https://wordpress.org/plugins/woocommerce/) | 免费开源核心；另有付费扩展 | 核心不解决逐单杂志照片问卷采集 | 建商品、购物车、订单等 | 不负责个性化杂志预览 | 是；可扩展支付网关 | 静态下载文件可以付款后授权；逐单生成 PDF 并安全挂到对应订单还需衔接 | 可靠的店铺/订单候选；支付方式依赖商户国家与网关，可复用现有能力 |
| [Printcart Photobook](https://wordpress.org/plugins/printcart-photobook/) | 插件在 WordPress.org 免费；必须连接 Printcart Cloud；云端商业费用/生产价格需单独确认 | 是，编辑器内上传与摆放图片 | 有封面、内页画布、分页布局；不从人物问答自动写杂志内容 | 有在线设计、保存与校样流程 | 桥接 WooCommerce 产品/订单 | 插件称可经云端渲染 CMYK 文件并供生产履约；地址数据流与具体地区/费用需向供应商确认 | 最接近现成“照片书画布 + 印刷”流程；不是故事杂志自动生成器。用户图像会送到 Printcart Cloud；订单个人信息也会同步。调研时版本 1.2.0、活跃安装少于 10、尚无评价，生产级依赖需做完整实测 |
| [Storelly Product Builder](https://wordpress.org/plugins/storelly-product-builder-for-woocommerce/) | WordPress.org 免费开源基础版；本地运行的商品选项、上传和画布编辑可免费用；生产级印刷 PDF/订单同步属于可选 Cloud 服务，需要付费计划 | 是，可传图 | 有商品选项、文字/图片画布、报价和 Woo 购物车流程；不从问答生成完整故事/多页杂志 | 有实时画布预览 | 与 WooCommerce 集成 | 普通 Woo 下载仍可配置；Storelly Cloud 印刷渲染/同步需付费服务 | 更适合自托管做商品定制或验证单页个性化画布；多页杂志生成与履约没有被验证。调研时版本 1.7.1、活跃安装少于 10、暂无评价，生态成熟度有限 |
| [Vanquish Upload Files for WooCommerce](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/) | 免费开源上传插件；也有独立 Premium 版本 | 是，上传可附在商品/购物车/订单等流程；免费版为每个上传字段一个文件，可设置多个字段 | 不生成/排版产品 | 不负责成品预览 | 通过 WooCommerce 订单 | 不负责文件生产/交付 | 可作为人工/AI 辅助 MVP 的订单素材采集候选；帮助把素材与订单关联，但需验证图片数量配置、访客流程与移动端体验 |

## 推荐候选组合（不是最终选型）

| 目标 | 起步组合 | 主要缺口 |
|---|---|---|
| 快速验证卖点，先人工完成成品 | 免费 WordPress 主题 + WooCommerce + 一个表单/上传方案；先做样刊和人工生产 SOP | 逐单内容质量、接单工时、下载链接分配和素材保留规则要用小规模订单验证 |
| 验证消费者是否愿意在线排版 | WooCommerce + Storelly 画布编辑器 | 仍需自行做问答转杂志结构/故事、逐单多页 PDF 和电子/实体交付 |
| 尽量借用现成照片书印刷流水线 | WooCommerce + Printcart Photobook | 外部云服务依赖、数据/隐私/地址流、商业费用、产区/运输、低安装量；也不自动完成杂志叙事 |

主题起步站仅解决展示页面。不要因为一个 starter site 视觉上像杂志/书店，就认为已包含定制编辑器、支付、文件权限或打印履约。

## 关键流程边界

### 上传

Vanquish 可把文件接入订单；免费版每个字段支持一个文件，可以为一个商品配置多个字段。Storelly 与 Printcart 提供更接近在线产品画布的上传体验，但存储路径与外部云功能需分别验证。

### 个性化成品与预览

截至调研日，没有免费主题会把生日问卷自动编成文章、将照片匹配版式并生成一整本有完整叙事结构的杂志。必须做一份从输入到可下载 PDF 的 PoC，检查错字、照片裁切、打印出血/分辨率、字体和页面预览一致性。

### 支付与电子交付

WooCommerce 的下载品可在付款后给客户订单页、邮件和账户下载链接；这是静态/已生成文件的发放功能，不会替每位买家自动制作独立 PDF。PoC 要验证“成品生成成功 → 授予正确订单下载权限 → 通知客户”，并覆盖生成失败和退款。详见 [WooCommerce 下载品交付文档](https://woocommerce.com/document/digital-downloadable-product-handling/)。

### 实体印刷和自动发货

“插件有 POD/CMYK/fulfillment 功能”不代表目标市场可按目标成本和交期寄送。下单前应确认生产服务地区、单价/运费、配送地址字段、运输时效、追踪、重印/退款、订单状态同步，以及照片/个人资料的第三方处理。

### 支付方式

商户所在国家/地区尚未确定，因此不选择 Stripe、PayPal、本地网关或具体结账插件。先由 Owner 决定首发市场，再查可用网关、结算币种、手续费、争议处理和提现要求。

## 建议插件策略

- 先复用 WordPress + WooCommerce 这类成熟核心；主题先在测试站对比，不急于安装付费扩展。
- G1 需求实验不需要做全自动杂志编辑器；可用表单/订单上传和后台人工生产验证一单。
- 若确定 WooCommerce 且要试在线画布：PoC 优先分别测试 Storelly（自托管基础画布）和 Printcart（多页照片书 + Cloud）。不要一开始同时生产安装多个上传/产品设计插件。
- 若只需要上传资料供人工制作：Vanquish 是精简候选；需设多个上传字段并验证照片数量和上传失败恢复。
- 正式接单前，任何候选必须通过完整的匿名/账户下单、支付成功/失败、订单关联、预览、下载/印刷、取消退款、手机浏览器测试。
- 因订单中可能含他人照片和家庭信息，先写清使用授权、访问权限、保留和删除方式；涉及第三方云前读其条款/隐私政策。

## 官方来源

- [WordPress.org — Blocksy theme](https://wordpress.org/themes/blocksy/)
- [WordPress.org — WooCommerce](https://wordpress.org/plugins/woocommerce/)
- [WordPress.org — Printcart Photobook](https://wordpress.org/plugins/printcart-photobook/)
- [WordPress.org — Storelly Product Builder](https://wordpress.org/plugins/storelly-product-builder-for-woocommerce/)
- [WordPress.org — Vanquish Upload Files](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/)
- [WooCommerce — Digital/Downloadable Product Guide](https://woocommerce.com/document/digital-downloadable-product-handling/)
- [Blocksy — Starter Sites](https://creativethemes.com/blocksy/starter-sites/)


## 2026-09-26 增补：美国 PDF 试点的逐单交付

前文的插件候选用于比较自助产品编辑器和实体照片书生产。本项目首轮已确定美国英语 + 电子 PDF，且 Owner 报告需求已验证。短期不需要让顾客在线设计整本杂志；更小的验证链路是“付款 → 订单专属照片/问题采集 → 后台人工/AI 制作 → 买家看 proof → 最终 PDF”。

| 试点角色 | 候选/做法 | 选择理由 | 已知限制 |
|---|---|---|---|
| 主题 | [Blocksy](https://wordpress.org/themes/blocksy/) 免费版 | WordPress.org 标注免费，页面显示 300,000+ 活跃安装及 WooCommerce 支持 | 具体 Starter Site 和付费功能逐项核对；不包含杂志排版系统 |
| 商店 | [WooCommerce](https://wordpress.org/plugins/woocommerce/) | WordPress.org 开源免费核心，支持商品、订单和数字品 | 每位客户的内容生产和 PDF 绑定仍需人工或衔接 |
| 上传方案 A | [PPOM](https://wordpress.org/plugins/woocommerce-product-addon/) | WordPress.org 开源、20,000+ 活跃安装，免费插件页面列出文件上传字段、大小/文件类型限制、进度和缩略图 | 需在暂存环境确认每张照片如何映射到订单；主要适用于下单前收集资料 |
| 上传方案 B | [Vanquish Upload Files](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/) | 免费版可在订单页提交素材，支持订单关联；每字段一个文件，支持多个字段 | 页面显示 20+ 活跃安装；需验证访客订单链接、订单绑定、访问控制和移动端。使用前先暂存核验 |
| 逐单文件 | [Vanquish Attach Me](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/) 或 WooCommerce 逐单下载权限 | Attach Me 免费版主张使用受订单权限检查的私有链接，并可把文件放进订单邮件；原生下载品支持付款后邮件和下载页面 | Attach Me 页面显示少于 10 个活跃安装，客户审批属于 Premium；不得仅凭描述视为已安全/兼容，需在暂存站验 guest order。WooCommerce 原生商品文件适合静态文件，不会为客户自动生成 PDF |
| 支付 | WooCommerce Stripe Gateway | 官方文档称扩展没有开通/月费；标准 Stripe 费率另算 | 必须先确认卖家收款主体所在国家与开户资格，不能只以美国客户市场推断 |
| 邮件 | Resend 免费档 | 当前价格页列 3,000 封/月、100 封/日 | 需设置发信域名、SPF/DKIM 并验证 WooCommerce 发信接入 |

**建议：** 上传 PoC 先比较 PPOM 与 Vanquish Upload，只留一款；逐单 proof/final 另验证附件访问权限。Vanquish 的低安装量是主要风险，不应跳过兼容和访客权限验证。即使自动化邮件失败，试点仍可由后台逐单发送私有文件，不用先开发新系统。

WooCommerce 的下载品在付款后可出现在订单页、邮件或账户下载页，但只会交付已配置的下载文件。可参阅 [WooCommerce Digital/Downloadable Product Guide](https://woocommerce.com/document/digital-downloadable-product-handling/)。美国销售税计算工具不判断商户义务，也不会申报/代缴，见 [WooCommerce Tax Guide](https://woocommerce.com/document/woocommerce-shipping-and-tax/woocommerce-tax/)。

托管价格仅作估算：Bluehost 当前官网列举的 Starter 首期价与续订价分别为 US$3.99 和 US$9.99/月（36 个月期限），Business 为 US$6.99 和 US$13.99/月；结账条款会变，暂不视为已选供应商或最终预算。见 [官方 WordPress hosting prices](https://www.bluehost.com/pricing/wordpress-hosting)。

核心成本公式、隐私原则和开发前决策门已写入 [G1 剩余调研](./G1_REMAINING_RESEARCH.md)。
