# 第四部分｜第4.1章完整草稿：结构与事实来源初检（2026-10-18）

> **CURRENT_RESULT：DRAFT_STRUCTURE_PASS / FACT_SOURCE_SPOT_CHECK_PASS / INDEPENDENT_CONTENT_REVIEW_PENDING**
> **对象：** [4.1完整正文候选](CHAPTER1_FULL_DRAFT_V1_20261018.md)
> **冻结题目：** [V2正式1/9/48/117问题树](FROZEN_FRAMEWORK_V2_20261018.md)
> **判定边界：** 这是作者/执行方的自检记录，**不是独立Reviewer PASS，更不是Owner正式封板。**

## 一、已执行的机器可核对项目

| 核验项 | 证据及结果 |
|---|---|
| 唯一核心没有变 | “产品怎么做、怎么交付？”未改 |
| 一级章节 | 4.1 我该把产品做成什么形式？；当前只写4.1 |
| 二级 | 4.1.1–4.1.4，共4题；正文 `##` 二级标题与正式框架逐字、同序匹配 |
| 三级 | 4.1.1.1–4.1.4.2，共10题；正文 `###` 三级标题与正式框架逐字、同序匹配 |
| 深度初查 | 各二级包含方案比较/判断流程/反例或示范、具体能力核对，末尾有读者可执行“产品形式决定卡” |
| 案例真实性 | A/B/C/D四种示范均标 `MODEL_ASSUMPTION`，总案例也是教学假设；非真实客户或销售实测 |
| 跨章/板块边界 | 4.2才定首版范围，4.3才选实现工具；金融与经营主体归③，底层网络与域名归②，营销归⑤，机会归① |
| 地区与平台资格 | 将商店创建能力和支付通道资格区分；没有承诺中国大陆个人必然获准某个收款方式 |
| 网页/原生App | 说明浏览器能力、应用市场发行与数字内购等条件性差异，不宣称任何形态必胜 |
| 数字URL | 明确临时签名URL不等于一次性、不保证防传播 |
| 敏感订单恢复 | 未用仅姓名/订单号等可猜信息作为订单内容访问的充分凭据 |

## 二、事实来源核验（官方网页优先）

1. [Etsy · How to Manage Your Digital Listings](https://help.etsy.com/hc/en-us/articles/115015628347-How-to-Manage-Your-Digital-Listings)：证实平台区分即时下载与定制数字商品；同时存在对应平台商品/作品规则，不能推广至所有平台。
2. [WooCommerce · Virtual and Downloadable Products](https://woocommerce.com/document/managing-products/virtual-downloadable/)：证实虚拟/下载商品与到期/次数配置能力；不代表平台内置完整的数字版权保护。
3. [Shopify · Domains](https://help.shopify.com/en/manual/domains)：证实默认商店URL与自定义域名为不同选择。
4. [Shopify Payments · Supported Countries](https://help.shopify.com/zh-CN/manual/payments/shopify-payments/supported-countries)：证实资格依国家/行业/商户条件，不可由“能开店”推导“能收款”。
5. [Apple Developer · App Review](https://developer.apple.com/app-store/review/) 及 [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)：上架有审核、数字商品和内购具体规则；注意Apple于2026-10-16更新过指南，后续还要核对最新细则。
6. [AWS · Presigned URL FAQ](https://docs.aws.amazon.com/prescriptive-guidance/latest/presigned-url-best-practices/faq.html)：证实预签名URL可以重复请求，单次使用须额外控制。

**检验时间：** 2026-10-18；验证范围仅是上述事实点和来源支持关系，未实际访问任何商家后台、进行平台实名认证、资金流或软件实际测试。

## 三、尚需真正独立Review确认的内容

- **可读性与知识密度：** 章节当前为完整草稿，需按第二部分正式封板文章的深度、广度和自然表达标准进一步冷读，而不能因出现了4个案例或一个表格就自评通过。
- **案例假设与现实差异：** 现成平台对定制商品、服务预约、具体国家和收款/数据政策的支持随平台而异，所有实操建议必须带核验条件。
- **知识重复：** 4.1选择产品形式，4.2定首版范围、4.3选择工具、4.4客户使用、4.6真实履约。若重复泛讲功能不应破坏这些唯一职责。
- **来源完整性：** 若独立Reviewer发现需要支持的具体产品事实或政策未有匹配官方来源，应追加材料或弱化表述，不把假设当实证。
- **第4.1章状态：** `FULL_DRAFT / REVIEW_PENDING / NOT_SEALED`；其余4.2–4.9未开始，不自动推进。

## 四、下一步

独立Reviewer阅读全文，核对每一道二/三级是否实质回答、决策对普通卖家有用，并验证事实；给 `PASS_CANDIDATE_OWNER_REVIEW` 或精确 `RETURN_*`。仅Owner授权后才生成 `CHAPTER1_FINAL_SEALED.md` 并将旧Gate退出当前视图。
