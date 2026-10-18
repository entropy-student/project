# 第五部分第三章《客户来了，怎么让他下单？》独立Reviewer R2审核

> **2026-10-18** ｜ **RETURN_R2_EU_REFUND_PECR_SOURCE_SCOPE** ｜ **第三章：结构PASS、内容RETURN、NOT_SEALED**
> 现行Gate：`CB05-CH3-WRITER-R3-MINIMAL_FACTUAL_REPAIR-20261018`；第五部分完整1/6/35/78框架与前两章正式封板成果保持不变。

## 输入、冻结题及知识质量

- Owner上传：`第五部分_第三章_Writer_R2完整交付.zip`，**38,393字节**，SHA256 `21d466da5bb894925cef6c19d63b8ffbe37fee5d6629c83c2afca8fb611f91f5`；ZIP CRC `testzip()=None`。
- Writer R2正文：**46,990字节、453行**，SHA256 `2ffe4336ef2f97307df6374474e60f22a889eac972cba42c6bc3d0d2b406c8d4`。Writer R2核验/返修记录：**33,284字节、193行**，SHA256 `c34f336e1af2332602d7ea8f966f0a0a57f1e0108614e97f8a8f0fe9899d9d84`。
- 与 `docs/FROZEN_FRAMEWORK_V2_20261018.md` 逐字核对：**1个一级、6个二级、14个三级，标题、层级、顺序、父题完整一致**；Markdown代码围栏18个成对，涵盖价值表达、信任、跨境售后、疑虑、付款流失与B2B推进。
- R1问题主要已修：DDU旧称、EU数字内容豁免主要条件、UK CRA、FTC 2023/2024区别、基础电邮许可、付款故障推断、演示客单价与80%错误阈值、错误的五板块自检框架。**保留所有正确内容，不重写整章**。

## 四项必须返修（精确定位）

| ID | 严重性 | 实际缺陷 | 最小修复及验收 |
|---|---|---|---|
| **B01** | **BLOCKER**，正文L163–180，尤其L166–167 | 退货一律写“个人喜好/尺码选错由买家承担退件费”，没有说明欧盟14天撤回前未告知退运费时**商家需承担**；又写“收到退货检验合格后几个工作日退款”，错误覆盖欧盟法定撤回退款时点。EU Directive 2011/83/EU Art.13要求通常**收到撤回通知后14天内**退款，商家可暂缓到**收到货或收到寄回证明（二者较早时点）**，不能一律先检验合格才开始退款。 | 相邻正文把自愿退换、法定撤回、瑕疵救济分开；写清退件费事先告知与原最低标准运费、退款期限/暂缓条件，不取消合法商品状态检查的合理应用。同步自检及法源。 |
| **B02** | **HIGH**，正文L322–332 | UK soft opt-in写“在结账或询价过程中买家自行留下邮箱”而未确认对方**主动表示购买兴趣或销售洽谈**；仅浏览/单纯存入联系信息不够。写“每封邮件必须有**一键**退订链接”，ICO官方准则为**方便且免费的退出渠道**，如可回复退订、清晰退订链接，未要求所有信件必须是技术意义的一键。英国PECR与各欧盟成员国不可混写。 | 在正文说明询价/试用/寻购的实际主动互动及全部并行条件；删除“邮箱收集即足够”的误读；一键链接可作为优选设计而非法定普遍强制；写明英国适用范围与其他法域另核。 |
| **B03** | **HIGH**，正文L255–272，核验记录L91 | Baymard统计把“42% **美国**线上消费者近期因为浏览而弃购”写成“42% **海外**消费者”；自检更称“全球结账弃单实证研究”。图表中的40/20/19/18/17%为同一**美国受访者**调查条件下、排除浏览后的自报弃购原因，不能推为全球买家比例；受访者可报告不止一项。 | 保留数值但明确美国调查、调查时间/口径与允许多原因、不必加总100%，区分官网50项研究汇总的弃购率与美国调查的原因比例。正文图文和核验表都改。 |
| **B04** | **MEDIUM-HIGH**，正文L140–155、自检L130–149 | DAP图里写售价“包含运费与**保费**”，但Incoterms 2020 DAP双方并无强制投保义务；同段又错称复杂海关关务属**第二部分《网络环境搭建》**，即使Writer自检把第二部分名称改正，正文仍遗留旧归属。 | 改成卖方按DAP负担运至指定地点的运输与相关约定成本、保险看合同而非DAP强制；关税清关主要落第三部分税费合规+目标国官方或有资质代理查证，第二部分仅网络环境，不承担海关专门教程。 |

## 三项顺手小修，不扩大返修轮数

- **N01 正文L176–178**：高度个性化商品及健康卫生密封商品例外要把定制的具体性质和**拆封后**不可退等条件完整呈现；不能让商家认为“密封包装或自行标定制就自动豁免”。
- **N02 正文L36**：3–5秒仅是清晰度启发式测试，不要以无证据的“绝大多数访客直接关闭网页”描述实际统计。
- **N03 正文L390–445**：B2B采购角色和销售绩效的“只关心/必须/总会”视角色和公司区别酌情软化，不要求重写结构或全面扩充。

## 原R1逐项回查

| 原问题 | R2独立判断 |
|---|---|
| B01 DDU与进口关税 | **PARTIAL**；正式术语修好，DAP保险及跨板块映射残留B04 |
| B02 EU退换货 | **PARTIAL**；数字内容豁免修好，退款义务B01仍阻断 |
| B03 遗弃购物车电邮 | **PARTIAL**；合规意识与沙盒已加强，UK soft opt-in依据B02需精准 |
| B04 虚构收益或质检 | PASS_WITH_NOTE，正确主体保留 |
| B05 Baymard | **PARTIAL**；百分数正确但US误称全球，B03 |
| B06 支付故障推断 | PASS，UNKNOWN与多证据保留 |
| B07演示/试用/套餐硬规则 | PASS，数字示意归位 |
| B08项目架构与CBP | **PARTIAL**；自检项目名称正确，正文错误海关归属B04 |
| N01–N04 | 主要PASS，局部措辞小修可顺带完成 |

## 独立核对的一手来源（不是自评即通过）

1. 欧盟官方面向商家远程电商撤回权/退款与退件费用：https://europa.eu/youreurope/business/selling-in-eu/selling-goods-services/ecommerce-distance-selling/index_en.htm
2. 欧盟消费者退件费与例外：https://europa.eu/youreurope/citizens/consumers/shopping/returns/index_en.htm
3. EU Directive 2011/83/EU Art.13/14：https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A02011L0083-20260927
4. UK ICO电子邮件营销/soft opt-in：https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guidance-on-direct-marketing-using-electronic-mail/how-do-we-comply-with-the-pecr-electronic-mail-marketing-rules/
5. Baymard 2026 US调查与购物车弃单率汇总：https://baymard.com/lists/cart-abandonment-rate
6. ICC DAP/DDP保险与风险：https://academy.iccwbo.org/incoterms/article/incoterms-2020-dap-or-ddp/ 及 https://library.iccwbo.org/content/tfb/BOOKS/BK_0049/BK_0049_04_RulesAny.htm

## 复审标准与停点

仅修B01–B04及N01–N03，**不修改冻结6二级/14三级原文及排序，不删减其他已有示例、图示、知识深度**。Writer无GitHub仓库访问权限；返回完整R3正文Markdown、逐项修订与一手来源核验Markdown、两文件完整ZIP，STOP_AT_REVIEWER。独立Reviewer下轮核新引错误并判PASS_CANDIDATE或RETURN。**只有Owner明确批准才能建立CHAPTER3_FINAL_SEALED.md；第四章未启动。**
## 完整返修ZIP指纹（报告创建后另行确认）

- `第五部分_第三章_R2独立审核与R3最小返修包_20261018.zip`，**46,824字节**，SHA256 `49312f7e13a19b6e803d1afe925226b6fdaf304496809d281fa5c00d653bb347`；7份文件，`testzip()==None`，R2 Writer的两份文件原始字节完整保存，附R3指令、官方核查边界和Manifest。
- 二进制ZIP只在本轮对话作为附件提供Owner，未上传GitHub。
