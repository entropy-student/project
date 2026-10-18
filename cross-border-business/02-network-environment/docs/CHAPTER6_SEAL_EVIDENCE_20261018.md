# 第二板块第⑥章《客户访问》｜Owner授权定向修订与正式封板证据（2026-10-18）

> **OWNER_DECISION：正式封板（2026-10-18）**  
> **FINAL_STATE：CHAPTER6_FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_REPAIR_PASS**  
> **修订主体：Reviewer直接修正（不是独立Writer R3）**  
> **唯一正式正文：`CHAPTER6_FINAL_SEALED.md`**。

## 一、授权基线及决定

- Writer R2完整正文：71,527 UTF-8字节，SHA256 `9ccbc5f597c615a76da764dd33afeafd67b4865ac47f7ff73046374cdd42aa51`，635行；Writer核验记录36,289字节，SHA256 `ef1b578251811d56e8695b2e1987f1c7dc5c83f4ea28f295f26ae3cdb16ed98c`。
- Reviewer R2结论：`RETURN_R2_RESIDUAL_IMPLEMENTATION_AND_EVIDENCE_ERRORS`，七组未闭环R2-01—R2-07；原第⑥章R1两个P0缓存和Global AOP错误主体已改善，但尚不足封板。
- **Owner明确授权本次Reviewer直接完成定向修改、正式冻结、落入GitHub项目库并开启下一章。** 因此本次不虚构“Writer R3已完成”，也不将原R2 RETURN稿当成最终封板正文。
- 采用**最小改动原则**：保留R2已有核心知识、案例、诊断方法和冻结问题，仅在七组残留错误的对应段落及证据索引进行定向修订。

## 二、逐项修订矩阵

| 原阻断项 | 原R2风险或证据不足 | Owner授权修改 | 复验结论 |
|---|---|---|---|
| **R2-01** | Zone AOP证书叶/根/私钥混淆；Host `return 444`被描述为TLS阶段阻断；Tunnel“物理上彻底隐藏源站” | 明确私有CA→签发leaf、Cloudflare上传leaf/key、源站校验CA；区分optional/on启用顺序、Host HTTP阶段、Tunnel入站前置条件和其它暴露面；Nginx样例声明不可直接上生产 | PASS（文稿级静态复核） |
| **R2-02** | Bypass路径名单不完整，强缓存规则可能覆盖私有路由 | 明确路由列表示例，必须枚举实际订单、地址、退款、支付和身份API；检查Cache Rules优先级/Edge TTL及“忽略源站头”覆盖，补交叉身份与清理/回滚步骤 | PASS |
| **R2-03** | HSTS一年及预加载混为一谈 | 将逐步增加max-age与可选preload拆开；明确includeSubDomains、preload指令、提交审核、撤销周期与子域名验证 | PASS |
| **R2-04** | k6 20→50 3分钟爬坡被写成50VU稳态3分钟 | 修改为20→50短爬坡，再以50VU维持3分钟的明确stage；标注测试参数纯教学、不得无授权执行 | PASS |
| **R2-05** | Nginx限流被当作具有排位状态的Waiting Room；Always Online误作事故时瞬时开关 | 区分限流/503维护页与真正等待室；规定Always Online预先启用与抓取、静态范围、Bypass冲突和演练 | PASS |
| **R2-06** | Cloudflare Pro年付/月付价格混淆；Shopify DNS-only与Cloudflare O2O官方指南冲突 | 现价快照：Pro按年付折合$20/月、按月付$25/月；以Shopify商户支持路径DNS-only为保守方案，明确Cloudflare另有O2O技术文档及支持责任差异，需双方确认 | PASS（仅2026-10-18价格快照） |
| **R2-07** | 失效OWASP链接、中间跳丢包绝对归因、CrUX当全体买家、CHR普适85–95%阈值 | 更新OWASP Web Cache Security正式URL；调整MTR、Chrome抽样口径；移除普适CHR门槛，保留MODEL_ASSUMPTION示例 | PASS |

## 三、文稿复查及不可变框架

- 原稿→修订稿：**71,527→77,495 UTF-8字节**，正文**645行**；最终SHA-256：`d139d7544683bb360dfafc8ba76219d3d3974b9eec82a72896597108ed2302f3`。
- 最终正文严格保留**5H2/10H3逐字同序**：`5H2 / 10H3`；标题、一级问题、层级、编号和排序没有更改。
- 自动核验无不可见控制字符（除换行/制表）、关键官方来源[S32]–[S38]均可在正文索引找到、旧错误OWASP网址不再出现、公式保留。
- 差异复核：unified diff约**182行**；正文保留原R2技术知识主体，未启动第⑦章正文；冻结8/44/93框架不修改。
- **责任边界**：静态Review及官方文档核对，不是实地完成Cloudflare AOP部署、CDN缓存穿透测试、k6压力测试、账号支付或目标国家真实测量。动态资费及平台文档可能变化，实际开通/变更以前仍须以当期官方和用户授权环境为准。

## 四、外部独立核验来源（2026-10-18）

- Cloudflare Zone-level AOP 官方文档：https://developers.cloudflare.com/ssl/origin-configuration/authenticated-origin-pull/set-up/zone-level/
- Cloudflare Global AOP 共享证书：https://developers.cloudflare.com/ssl/origin-configuration/authenticated-origin-pull/set-up/global/
- Cloudflare Cache Rules：https://developers.cloudflare.com/cache/how-to/cache-rules/settings/
- OWASP Web Cache Security：https://cheatsheetseries.owasp.org/cheatsheets/Web_Cache_Security_Cheat_Sheet.html
- MDN HSTS及预加载条件：https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Strict-Transport-Security
- Grafana k6 Stages：https://grafana.com/docs/k6/latest/using-k6/k6-options/reference/
- Cloudflare Pro定价：https://www.cloudflare.com/plans/
- Shopify域名通过Cloudflare接入指南：https://help.shopify.com/en/manual/domains/add-a-domain/connecting-domains/connecting-to-cloudflare
- Cloudflare Shopify O2O技术指南：https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/saas-customers/provider-guides/shopify/
- Cloudflare Always Online：https://developers.cloudflare.com/cache/troubleshooting/always-online/

## 五、落库及后续流程约束

- 正文文件以 `docs/CHAPTER6_FINAL_SEALED.md` 为唯一正式第⑥章正文，本文件为 `docs/CHAPTER6_SEAL_EVIDENCE_20261018.md`。
- 旧⑥ Writer Gate/ZIP从main当前目录撤出，历史仍可从Git获取；不改前⑤章已封板文件、第三板块CLOSED支付知识库和8/44/93正式冻结题干。
- 第⑦章另开**独立Writer Gate + 完整离线工作ZIP**；Writer无GitHub权限、不得自判PASS；Reviewer RETURN始终同时交完整返修ZIP与传递提示词。
