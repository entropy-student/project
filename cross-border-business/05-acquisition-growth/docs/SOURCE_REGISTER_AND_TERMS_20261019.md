# 第五部分｜指标口径与动态事实来源索引（Owner批准的T8）

> **内容维护：2026-10-20定向补强**。本文件记录经营指标、术语和官方核验入口，不替代正式章节、商业账簿或法律意见。原有平台资料核对日期为2026-10-19，本轮新增材料核对日期为2026-10-20；任何实际经营操作前须按地区、商户资格和当期规则再核。

## 一、统一经营指标：先定分子、分母、观察窗

| 术语 | 经营侧推荐口径 | 容易混淆 |
|---|---|---|
| Click / Visit | 按渠道工具定义的有效点击／会话 | 不等于独立真人买家，Cookie同意会影响观测 |
| CPL | 归属一类有效线索的总费用÷该线索数量 | 线索质量与去重条件必须一致 |
| CPA | 指定转化动作（注册、合格询盘、购买等）的广告成本÷该动作有效次数 | “购买CPA”特例可用订单数量作分母；不必然是新客CAC |
| CAC | 针对同一新增付费客户cohort及观察期，合理归属的全部获客投入÷净新增付费客户数 | 工时与历史试验投入在回顾中计入；不可与订单混同 |
| Pre-CAC Contribution | 实际实收销售额−订单直接成本−相关交易费用、退款等已知调整，尚未扣获客投入 | 不是总净利润；包含项目必须明确 |
| 增量贡献 | 某个追加经营动作相对于不做/基准在同一期间的**额外**已列贡献及新增成本差额 | 不能把历史沉没投入重扣，也不能把前后观察误叫因果 |
| LTV | 指定cohort、时间窗、贡献利润与留存假设的客户价值估计 | 不是客户未来保证付款；尚未观察月份应为UNKNOWN |
| Activation / TTFV | 已定义的首次价值事件/从真实起点到首次有用结果的时间 | 注册、按钮点击不必然代表激活 |
| SQL / B2B商机 | 满足明示资格、决策角色、采购时点且有下一步证据 | RFQ、报价、付费客户是三个阶段 |
| 复购率/订阅留存 | 用明确客户cohort、有效后续收款与统一观察周期 | 一次性项目的二次成交和SaaS月留存不可直接横比 |
| ROAS / MER | 平台归因收入÷该平台广告花费；总营收÷总广告花费（实际定义需说明） | 收入不是贡献利润，广告报表不等于已收款 |

### 核心缩写速查：什么是、何时要用、哪里不能混用

| 缩写 | 零基础解释与常见使用情景 | 不应做的误判 |
|---|---|---|
| CRM | **客户关系管理**：记录合法线索、商机阶段、负责人与下次行动。B2B早期用表格即可，出现多人交接/漏跟进才考虑专用CRM | 客户联系人总数不等于商机与成交 |
| CTR | **点击率**＝点击数÷展示数（按各平台报表口径）；适合发现广告/搜索展示吸引力问题 | 点击率高不等于付款多 |
| CPC | **每次点击成本**＝广告支出÷有效计费点击；用于估算买流量的现金 | 不等于每订单成本 |
| CVR | **转化率**＝指定转化动作次数÷明确的访问/点击/用户基数；必须说明是什么动作与哪个分母 | “注册CVR”不能称“购买CVR”，按用户/订单计数也不能偷换 |
| CPA | **每指定动作成本**＝归属费用÷该转化动作有效次数；例如广告购买CPA按归因订单计算 | 不等于去重新客户的全口径CAC |
| CAC | **每净新付费客户获客成本**＝同群合理归属的完整获客投入÷同群净新增付费客户数 | 不能把老客再购算新客户、也不能拿每单贡献直接相减 |
| UTM | 营销链接的来源、媒介和活动标签；用于辅助渠道回溯 | 缺标签不表示无人购买，标签不证明支付成功 |
| GA4 | Google Analytics 4：访客与事件分析工具，能看访问/行为和上报购买事件 | 不是支付服务商的收款凭据 |
| GSC | Google Search Console：验证网站的抓取、收录及搜索表现（查询/展示/点击） | 提交URL或有索引不保证排名 |
| SQL | Sales Qualified Lead：**销售资格合格线索**，须按本业务明确资格与下一步 | 有RFQ或报价不自动成为SQL |
| LTV | 客户生命周期价值估算，需按客户群、观察窗、后续净贡献与留存假设推算 | 不是长期收入的保证 |
| ROAS / MER | 广告归因收入÷广告花费 / 整体营收÷整体广告花费（须先约定报表口径） | 两者都不是贡献利润或净回款 |

## 二、动态规则官方来源与更新触发

| 主题与性质 | 主要核验入口 | 适用对象及不能推断的内容 | 下次重新核查触发 |
|---|---|---|---|
| Google Ads CPA定义【平台定义】 | https://support.google.com/google-ads/answer/13278730 | 购买/注册/询盘等指定动作的成本；非默认订单和新客成本 | 优化目标或新广告后台变动 |
| GA4 交易去重【技术行为】 | https://support.google.com/analytics/answer/12313109 | 网站流使用唯一交易ID去重；非对全部App数据流自动适用 | 更换统计工具/订单平台 |
| Google AI搜索【平台明示】 | https://developers.google.com/search/docs/appearance/ai-features | 基础SEO适用、无需额外“AI SEO秘诀”；引用/曝光不保证 | Google搜索AI展示规则更新 |
| Merchant Center免费商品展示【平台规则】 | https://support.google.com/merchants/answer/13889434 | 商品数据、国家与政策资格相关；免费不保证展示 | 新国家/Feed/账户资格调整 |
| Etsy搜索【平台明示/未知】 | https://www.etsy.com/seller-handbook/article/how-etsy-search-works/375461474487 | 公开的匹配与店铺因素；不可推导内部固定算法权重 | Etsy官方搜索政策变动 |
| Gmail发送者要求【平台规则】 | https://support.google.com/mail/answer/81126 | 全部发送者与达到量级者有不同要求；送达率不保证 | 提升发信规模、投诉波动 |
| 英国邮件营销【法律/监管指南】 | https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guidance-on-direct-marketing-using-electronic-mail/ | PECR与UK GDPR按订户类型、来源及用途判断 | 改目标国/营销方式/法规修订 |
| 美国商业邮件【法律/监管指南】 | https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business | 美国CAN-SPAM对B2B同样适用；不能替代UK PECR | 新市场/商业邮件形式变化 |
| FTC消费者评价规则【法律/监管指南】 | https://www.ftc.gov/business-guidance/resources/consumer-reviews-testimonials-rule-questions-answers | 对评价倾向激励、虚假评价等有要求；不等于平台允许奖励 | 设计任何评价奖励或证言计划 |
| FTC背书指南【监管指南】 | https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking | 达人、免费样品、关联佣金需检查重大关系披露 | 新达人/推荐计划 |
| Amazon公开评价政策【平台规则】 | https://sellercentral.amazon.com/help/hub/reference/external/E8SYAZUBGVFBHCH?locale=en-US | 商家自行以补偿换评价通常禁止；必须看所属平台当前政策 | 新评价激励动作或政策调整 |
| EU GDPR同意和个人数据【监管规则】 | https://commission.europa.eu/law/law-topic/data-protection_en | 需确认具体法律基础和例外；不能认为信息公开/哈希即免费可用 | 收集新的个人数据/共享/自动化 |
| Google Consent Mode【条件性技术说明】 | https://developers.google.com/tag-platform/security/guides/consent | 根据真实同意状态调整标签，**不负责取得法律授权** | 新CMP、新统计部署或法域变化 |
| 欧盟DSA【平台生态】 | https://digital-strategy.ec.europa.eu/en/policies/digital-services-act | 不可把平台法定义务全部当小卖家义务，需看卖家/平台身份 | 增欧洲市场或变更平台 |
| Shopify客户流失分析【商业实践，非法律】 | https://www.shopify.com/blog/customer-attrition | 付费失败只是可能的非自愿流失原因，不能证明破产 | 订阅产品/付款服务改变 |

**信息分类标签：**【法规硬规则】只针对明确适用的法域和身份；【平台明示】指有可核实官方页面但需账户资格；【商业经验】可借鉴但不能保证效果；【MODEL_ASSUMPTION】仅教学模型；【UNKNOWN】证据尚不足。此分类用于关键或动态事实，不需要机械给每一句话贴标签。

**维护建议：** 未来变更时先记：来源→最后核验日期→法域/平台/资格→受影响章节→证据更新前后差异→是否要求Owner解冻正文。这里只是可追踪索引，并不触发自动修改。
## 三、2026-10-20经营实操补充来源

本节**仅补充新修订关联来源**，不以本次核验日期替换原章节2026-10-18或来源索引2026-10-19的历史核验日期。平台菜单、字段、权限及政策可能变化；经营者执行前须按主体/地区/套餐再次查当前规则。

| 补强主题 | 官方来源 | 已核的事实边界、适用对象及重新查验条件 |
|---|---|---|
| SEO索引/工具 | https://support.google.com/webmasters/answer/9012289 / https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview | URL检查有索引诊断；提交URL/sitemap不承诺展示或排名。站点属性/网址变更时核 |
| 广告主次转化 | https://support.google.com/google-ads/answer/11461796 | 标准目标中的Primary通常用于出价；**自定义目标中的Secondary也可能用于出价**。更换目标/出价策略时核 |
| 真实搜索词与关键词 | https://support.google.com/google-ads/answer/2472708 | 搜索词不是后台设置的关键词；出于隐私限制某些低量查询不会逐条显示。匹配方式/产品变更时核 |
| GA4 DebugView与电商 | https://support.google.com/analytics/answer/7201382 / https://developers.google.com/analytics/devguides/collection/ga4/ecommerce | 需启用调试；未授予Analytics cookies同意时可能看不到相应事件。埋点/Consent Mode/订单流程变更时核 |
| Shopify营销口径 | https://help.shopify.com/en/manual/reports-and-analytics/shopify-reports/report-types/default-reports/marketing-reports | 某些Orders指标计入待付款、未付款及取消订单；2026-09渠道绩效报告扩大流量范围，不可假定旧时期可直接同比。变更报告时核 |
| Chrome Web Store指标 | https://developer.chrome.com/docs/webstore/metrics | impressions、安装/卸载与用户活跃不同；Users指标为安装，不证明实际使用。商店控制台变更时核 |
| 英国B2B营销动态 | https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/business-to-business-marketing/ | **ICO页面当前提示因Data (Use and Access) Act修订而处于审查中**；法人订户和sole traders等个人订户所适用的PECR邮件营销规则不同，UK GDPR在处理联系人个人数据时仍需单独核。开发信名单上线前复核修订和业务条件 |

**维护触发**：当某条以上平台规则发生变化时，先更新证据/本索引，并记录需要调整的章节与Owner授权；不据此自动重开六章已冻结正文。

## 四、2026-10-20第二轮定义与操作路径复查

- **广告购买CPA与全口径新客CAC**：按同一指定转化动作计算的广告Cost/conv.不应直接写成新客CAC；后者需把新客户去重，并与全口径费用及cohort对齐。[Google Ads转化计数](https://support.google.com/google-ads/answer/6270625) / [Shopify CAC解释](https://www.shopify.com/blog/customer-acquisition-cost)。
- **Search Console、GA4、支付后台的职责**：GSC核网站索引/搜索表现，GA4核经许可观察到的事件，实际付款/退款由订单与支付服务商核；调试事件成功不代表收款。相关工具路径已在附录T3-F/T5-C/T6-C集中说明。
- **英国B2B分叉**：法人订户与sole trader个体经营者营销规则不可等同，处理具名员工邮件仍需判断个人数据法律基础。具体情境演练见附录T6-E，执行时复核ICO更新中的指引。
- **演练数字**：附录D001/D002的订单、退款、$30广告成本及预算公式均为MODEL_ASSUMPTION；不代表真实平台指标、可保证的投放上限或任何市场平均转化率。

