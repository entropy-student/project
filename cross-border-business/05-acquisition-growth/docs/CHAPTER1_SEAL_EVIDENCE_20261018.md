# 第五部分第一章《我的客户在哪里？》｜Owner授权直接修复与正式封板证据

> **STATUS：CHAPTER1_FINAL_SEALED / OWNER_AUTHORIZED_DIRECT_CORRECTION / 2026-10-18**  
> **唯一正式正文：** [docs/CHAPTER1_FINAL_SEALED.md](CHAPTER1_FINAL_SEALED.md)  
> **冻结问题权威：** [正式V2框架：核心1/一级6/二级35/三级78](FROZEN_FRAMEWORK_V2_20261018.md)，未经Owner进一步批准保持不动。  
> **后续：** 第二章Writer Gate单独启动；不将本章授权自动推广到以后章节。

## 1. Owner授权、原稿与精确范围

- R1：独立Writer首稿结构PASS，事实/线索筛选等十项问题RETURN；R2：Writer按R1定向修复交付完整正文（37,255字节/364行，SHA256 `4d476b895bcbd980889ffe9e2dad5c5ca2cc67976724b9d1a3fd368cdffa3e00`）及核验记录（16,764字节/91行，SHA256 `2dcc31d745be9f1b06599b76e2c8c4c2a25cf4b86e253da3af4b1d4338486c4a`）。
- R2 Reviewer独立审核判`RETURN_R2_RESIDUAL_SOURCE_MAPPING_AND_LEAD_FILTERING`，仅剩B01–B04四项必修和N01–N03三项低风险修订，审查报告：[R2 Review](CHAPTER1_WRITER_R2_REVIEW_RETURN_20261018.md)；R3完整返修包已准备但未发起真正Writer R3。
- **Owner于2026-10-18明确授权：** “这部分内容暂时由你来修改完成之后嗯，正式冻结，然后填入我们的项目库当中。记得记录相关文档。完成之后开启下一个1级问题的部分。” 因此Reviewer**一次性直接修复R2全稿的明确残留、校验后正式封板，再发布第②章Writer Gate**。这个范围限于第一章正文和第五板块项目文档，不改变完整问题框架。
- **没有Writer R3实际交付，也无理由把Reviewer直修称为Writer R3。** 保留R2原件与R1/R2审核为历史证据。

## 2. B01–B04与N01–N03修订闭环

| ID | 原稿定位 | 最小修改与复核要点 | 事实边界 |
|---|---|---|---|
| **B01** | §1.1.1 搜索意图三分类错误引用Google Search Essentials | 把Informational/Commercial/Transactional明确改成**营销分析启发性分类**，说明Google官方规范只支持技术要求、反垃圾规则、真实用户用词最佳实践，并**不定义**三分法 | Google官方 https://developers.google.com/search/docs/essentials |
| **B02** | §1.1.2 第三方引荐 + §1.4.1 国别榜单 | 引荐流量概念单独由Referral文档支撑，**账户有权限时**才可能访问Incoming Traffic详情，不保证免费明细；国别行业流量榜单单引Top Websites文档和公开榜单，明确访问≠采购≠销量 | Similarweb https://support.similarweb.com/hc/en-us/articles/212849049-Referral-Traffic 及 https://support.similarweb.com/hc/en-us/articles/213856729-Top-Websites |
| **B03** | §1.4.2 原“凡涉及欧洲居民个人数据就需GDPR” | 改为**先核定EU GDPR第3条欧盟机构设立活动或境外对欧盟境内个人提供商品/服务、监测行为的适用条件**，再判断合法依据；UK GDPR独立判断、营销邮件/短信另核欧盟成员国规则或英国PECR | 欧盟委员会 https://commission.europa.eu/law/law-topic/data-protection/information-business-and-organisations/application-gdpr_en |
| **B04** | §1.2.2 表格与筛选文字 | 将免费邮箱、无签名、索取价目表改成“**身份与用途待核实**”，不认定竞对/诈骗；只向未验证方提供公开资料，机密底价单独审权限；注意采购助理/初创公司/早期询盘 | 多证据资格审查原则，不作为某单一权威平台颁布的筛选法规 |
| **N01** | §1.1.2 社区活跃度 | 删除“几个月无帖=衰退”绝对规则；提示工业低频/季节性需求应按行业讨论节奏交叉验证 | 不设统一最低发帖频率 |
| **N02** | 章末行动清单 | 删除“至少2–3个社区”凑数指标，改为至少一个**有可复核买家需求证据的入口**，允许行业目录/采购活动不局限社群 | “至少一个”用于引导实际行动，不是保证有真实客户的法定或统计门槛 |
| **N03** | §1.4.1 Companies House | 明确英国登记处仅核公司存在及法定信息，**不证明在此采购或特定联系人有授权**；客户活跃度仍要另外核验 | https://find-and-update.company-information.service.gov.uk/ |

**连带小修：** §1.2.2的具体问询、线索筛选流程图不再把邮箱域名与技术问题回答当买家真假认证；最终章附官方来源适用条件提示。其余正确的CAN-SPAM/UK PECR基础、WHOIS/RDAP遮蔽、B2B角色不同、案例示意和教学知识主体全部保留，不因源局限重写整章。

## 3. 结构与质量验收

| 检验 | 验收事实 |
|---|---|
| 第一章全部冻结题 | **1一级、4二级、8三级，13问句原文逐字、同顺序、同层级** |
| 原二级标题 | 1.1 买家通常在哪里找这类产品？；1.2 怎么找到真正想买的人？；1.3 企业客户应该先联系谁？；1.4 不同国家的客户怎么找？ |
| 冻结全板块 | V2核心1/一级6/二级35/三级78维持；第二章2.2直接成节不改 |
| Markdown | UTF-8；代码围栏成对；原完整教学案例与全部4/8节齐备；无只提交差异补丁 |
| 成品路径 | `cross-border-business/05-acquisition-growth/docs/CHAPTER1_FINAL_SEALED.md` |
| 正文指纹 | **40,489字节；377行；SHA256=`c8fa6d7de2766a8aa07407d5b53114912e028f354611d83404ae163d71071f19`**。最终以GitHub `main`实际回读为准。 |
| 修改范围 | 仅第五板块第一章正式正文、封板证据、第五板块状态/交接、第二章Writer Gate/离线包清单与父项目导航 |
| 未触碰 | 第一、第二、第三、第四板块正式正文/框架，任何网站源码、运行服务器、数据库、广告和客户账户、支付及正式HTML |

## 4. 适用局限与Owner决策

- 已独立核验Google、Similarweb、欧盟委员会、FTC等与直接修订有关的官方来源及支持范围。**不是**对任何实时SEO排名、广告销售效果、欧洲各国法律许可、平台免费账号功能或实际商家合规资格的保证。
- Writer R2的“自检全部解决”不等于事实；上述Reviewer修复才构成最终本章内容状态。这个直修授权不等于后续所有章节可以跳过Writer/Reviewer审核。
- **结论：PASS_FOR_OWNER_AUTHORIZED_SEAL / CHAPTER1_FINAL_SEALED**。Owner已授权修复后正式封板，因此本章不再等待Writer R3，不要求Owner重复批准相同修订。
- 后续第②章《我该怎么找到客户？》固定**1一级/9二级/22三级、2.2直接成节**，按照第二部分成熟 Writer→Reviewer→Owner 协作方式**只发布独立完整首稿离线工作包**，不自行撰写第二章正文、更不封板。
