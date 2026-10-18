# 第二板块第⑥章《客户访问》｜独立Writer R1审核与R2定向返修（2026-10-18）

> **CURRENT_REVIEW：RETURN_R1_IMPLEMENTATION_SAFETY_SOURCE_MISMATCH**  
> **PROJECT：cross-border-business/02-network-environment/**  
> **FREEZE：8一级 / 44二级 / 93三级（不变）**  
> **CHAPTER6：WRITER_R1_DELIVERED / STRUCTURE_PASS / CONTENT_RETURN / NOT_SEALED**  
> **CURRENT_GATE：CB02-CH6-WRITER-R2-DIRECTED-REPAIR-20261018**  
> **OWNER_ACTION_REQUIRED：转发本轮完整R2返修ZIP和提示词，回收Writer完整R2正文、核验记录及ZIP提交Reviewer。**

## 一、审稿对象、校验与权限边界

- **用户当前上传文件是第二板块第⑥章**，附件名`第六部分_客户访问_独立Writer交付(1).zip`；不能错归为第五板块《获客与用户增长》第二章。
- 原始ZIP **36,661字节**，SHA256 `0f780c65b05102e421dc74115e56aba85896d58ccc36aee5144217273c468d6c`，CRC `testzip()=None`，恰好两份UTF-8 Markdown。
- 正文`第六部分_客户访问_独立Writer完整候选稿.md` **57,793字节、560行**，SHA256 `8377b319a7890287ef37077ccb33a0a9ec3f516803e7c83144d50ba2644865f6`。
- 核验`第六部分_客户访问_事实核验与执行记录.md` **24,766字节、158行**，SHA256 `5942680de38b04f1033eec92689e0b66ed93e147db5bdf5713c3e0ac471144bc`。
- **STRUCTURE_PASS：** 对照[正式冻结V5](FROZEN_FRAMEWORK_V5_20261018.md)和[第⑥章首稿Gate](CHAPTER6_INDEPENDENT_WRITER_GATE_V1_20261018.md)，一一级、五二级、十三级**16道冻结题逐字、顺序、层级、归属全部正确**，代码围栏闭合，五方面内容覆盖充分。
- **CONTENT_RETURN：** 个别可直接照做的安全/缓存配置有错误，高可用服务资格未说明，诊断证据/一手引用越界。**本轮只是Review**，不修改候选正文或①–⑤已封板文档，不产生`CHAPTER6_FINAL_SEALED.md`、不开始第⑦章和HTML，也不执行真实网站/CDN/压测/账号操作。

## 二、必须返修的10组问题（具体原文行号）

| ID | 等级 | 原稿位置 | 需修复的问题与验收条件 |
|---|---|---|---|
| **B01** | **P0** | L289–306 | `Cache-Control: public, no-cache, s-maxage=60`并不等于“浏览器每次验证、边缘60秒无需回源”。[RFC9111](https://www.rfc-editor.org/rfc/rfc9111.html) 和 [Cloudflare缓存控制](https://developers.cloudflare.com/cache/concepts/cache-control/)要求区分`no-cache`重新验证；[默认缓存](https://developers.cloudflare.com/cache/concepts/default-cache-behavior/)不缓存HTML/JSON。按公开/私有数据分流，防止误缓存个性化页面。 |
| **B02** | **P0** | L377–388 | Global AOP证书由不同Cloudflare客户共享，不能证明“只有我本Zone可回源”。按[官方分阶段配置](https://developers.cloudflare.com/ssl/origin-configuration/authenticated-origin-pull/set-up/global/)先观察后强制校验；需要专属识别应区分[Zone级专属证书](https://developers.cloudflare.com/ssl/origin-configuration/authenticated-origin-pull/set-up/zone-level/)，避免源站TLS断站。 |
| **B03** | **P0** | L369–417 | 防火墙收紧、Tunnel关闭入站SSH前未确认备用远程管理/救援回退；Nginx`set_real_ip_from`示例不完整、遗漏IPv6/Worker/上游信任边界，`X-Forwarded-For`不必然等于真实IP。参考[Cloudflare HTTP headers](https://developers.cloudflare.com/fundamentals/reference/http-headers/)和[Tunnel SSH](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/)。 |
| **B04** | **HIGH** | L503–524 | Waiting Room不是Free/Pro通用功能，需[套餐资格](https://developers.cloudflare.com/waiting-room/plans/)；[Always Online](https://developers.cloudflare.com/cache/how-to/always-online/)只在满足条件下提供可能存在的静态存档，不能恢复购物车或结账。删除90%回源削减保证。 |
| **B05** | **HIGH** | L92–143 | MTR中后跳丢包不能单凭探针证明某条物理线路/Peering拥堵；RFC792并非ICMP限速依据，改用[RFC1812§4.3.2.8](https://www.rfc-editor.org/rfc/rfc1812.html#section-4.3.2.8)；403/502/521/522/525/526诊断须分开，结合CDN日志与真实业务请求：[Cloudflare错误分类](https://developers.cloudflare.com/support/troubleshooting/http-status-codes/cloudflare-5xx-errors/)。 |
| **B06** | **HIGH** | L181–216 | INP“绝对最慢交互”忽略官方离群规则；CrUX不是保证各站数万样本；Cloudflare RUM仪表盘不是全量精确，参看[Web Analytics采样](https://developers.cloudflare.com/web-analytics/faq/)；CWV是排名诸多信号之一，不保证SEO排名：[Google页面体验](https://developers.google.com/search/docs/appearance/page-experience)。 |
| **B07** | **HIGH** | L81–85, L281–326 | Shopify接Cloudflare应按[官方DNS only](https://help.shopify.com/en/manual/domains/add-a-domain/connecting-domains/connecting-to-cloudflare)而不是引用普通域名页推断某后端CDN组合；免费层、Pro价格、CHR85–95%、时延10–30ms均应按场景/实测/当前合同限定。 |
| **B08** | **HIGH** | L425–492 | “真实交易验收”与支付沙盒概念混淆；k6演练只可在授权的受控目标进行，低负载起步、事前停点、与支付服务/第三方分离。不得让普通卖家向Shopify/Stripe生产系统或未经授权目标压测。 |
| **B09** | **MEDIUM-HIGH** | L225–266 | 主图必preload、所有折叠下图片必懒加载、TTFB高必为源站、SQL200ms与Redis为必需均属绝对化。改为依据瀑布流/关键渲染/数据一致性和具体站点判断。 |
| **B10** | **MEDIUM-HIGH** | L3–9、L321–326、L528–559 | 未经支持的跳出率/转化率与CDN命中率/削减90%等写成普遍事实；S21、S25、S27的来源标题与支持范围错位；缓存命中率数学公式含控制字符损坏。应逐条校验`主张—URL—产品范围—时间`并修正可读公式。 |

**不得推倒重写：** 已有访问链路分层、合成与真实测速思路、CWV基本定义、CDN命中检查、授权压测原则和k6教学脚本有价值。保留五段结构和原5/10冻结标题。不要为追求更多表格/字数制造返修。

## 三、当前Writer R2离线返修工作包

- 附件：`第二板块_第六章_客户访问_R1审核及R2返修工作包_20261018.zip`；**50,546字节**、SHA256 `787271f0bae2394c4010bc812236eaa24623c905f8ece049e6918e10eba859a7`；`testzip()=None`。
- 共7份文件，含①独立Reviewer完整审核报告；②Writer上一轮**560行完整原稿**；③Writer上一轮**158行完整核验记录**；④R2定向返修指令；⑤官方来源与证据边界；⑥可直接转发Writer的提示词；⑦文件大小/哈希清单。已独立检查ZIP内文件与本地原件字节一致。
- ZIP已在本次对话生成供Owner下载；**不声称ZIP二进制上传GitHub main**。Writer完全离线，没仓库权限。
- R2出口：完整修订后正文Markdown + R01? **应为B01–B10**逐项来源/变化核验Markdown + 包含两者的ZIP，`STOP_AT_REVIEWER`；不自判PASS、不改GitHub、不写⑦、不制作HTML。
- Reviewer下一轮复核全部B01–B10、冻结原题、新增问题及来源。只有Owner明确批准才能正式封板并建立`CHAPTER6_FINAL_SEALED.md`。

## 四、范围、回退与下一步

**只读审核+当前板块文档状态更新**。第一至五章正式封板文件、完整8/44/93题树和跨境五板块其他①③④⑤内容均未触动。Git历史可恢复审核状态文档，尚无营销、支付、系统或线上修改。

**NEXT_STEP：** Owner把完整R2 ZIP及提示词交给Writer → Writer返完整R2两份MD+ZIP → Reviewer独立Review → Owner决定封板。当前`CHAPTER6_R1_RETURN / R2_PACKET_READY / CHAPTER6_NOT_SEALED`。
