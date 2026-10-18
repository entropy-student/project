# 第二板块第四章《网站与程序运行》—Owner授权直修与正式封板证据

> **DATE：2026-10-18**  
> **OWNER_DECISION：Reviewer在Writer R2基础上定向修复，核验后正式冻结并落入main；随后启动第⑤章独立Writer。**  
> **FINAL_STATUS：OWNER_AUTHORIZED_CH4_FINAL_SEALED / NO_WRITER_R3**

## 一、合法基线和批准边界

- 现行冻结框架：`FROZEN_FRAMEWORK_V5_20261018.md`；第二板块8一级/44二级/93三级（三级暂时冻结）。第④章**6个二级/13个三级**逐字同序，数量与层级由脚本自检通过。
- 原Writer R2全文：`第四部分_网站与程序运行_Writer_R2返修交付(1).zip`，正文SHA256 `a5e811dedc029dbc4d1114e876b7912917c267ce6b245d5166464edd7fe3ef15`，66,242字节；Writer R2核验记录作为历史只读基础，不宣称作者完成R3。
- 独立Reviewer R2：`RETURN_R2_RESIDUAL_IMPLEMENTATION_AND_SOURCE_ERRORS`，主要残留R2-01至R2-06。
- Owner明确授权本次由Reviewer最小改动修订、正式冻结并更新项目库，不扩展授权到第⑤章、其他项目或生产系统。

## 二、R2-01至R2-06最小修复对照

| 阻断 | 原问题 | 具体修订和复核 |
|---|---|---|
| R2-01 | 将浏览器SSH通道当作真正带外救援 | 先核实sshd真实监听端口、云安全组、保留旧会话、从第二会话验证；区分EC2 Instance Connect SSH 与 Serial Console真实恢复限制，[S34][S35]。 |
| R2-02 | Stripe Webhook“解密验签”与错误引用[S03] | 使用raw body、`Stripe-Signature`和本端点签名密钥核验；CLI与Dashboard可能不同；新增[S36]。 |
| R2-03 | 生产回滚仅以可覆盖标签保证制品复现 | 保留标签用于可读性，新增Digest固定、制品留存、配置/迁移兼容性和沙盒回滚验证，新增[S37]；不承诺Compose单实例零停机。 |
| R2-04 | RDS备份0天与PITR混同；托管DB强制私网 | 明确实例0天禁用自动备份、PITR须有非零保留期；Multi-AZ cluster 1–35天；分流RDS与BaaS默认连接/TLS/鉴权/可选私网[S27][S28][S38]。 |
| R2-05 | Workers CPU/wall-clock/Cron及跨服务计费混同 | 明确Free HTTP 10ms CPU；Paid默认30秒、可配置最高5分钟；HTTP wall-time不设统一硬期限而Cron/Queue有限制；AWS Lambda另行核验，[S07][S19]。 |
| R2-06 | curl断行、卷检查证明不足、S13错误支持部署、R2费用不全 | 恢复可复制`curl`单行；标注卷/容器占位符并验证容器Mounts+测试写入/重建读回；增加Compose来源[S37]；补R2标准/低频容量、A/B操作、低频检索与30天期限[S31][S39]。 |

**保留原R1通过的两项P0修复**：不再盲放行SSH 2222；不再声称外部扣款可由本地数据库事务回滚。其余通过的知识主体保留。

## 三、正式正文完整性自检

- 原Writer R2 SHA256：`a5e811dedc029dbc4d1114e876b7912917c267ce6b245d5166464edd7fe3ef15`；正式文件 SHA256：`72be3fa9dc21344a3d0365b67189065dc279691ef03c91cd88b16475d613e82e`。
- 正式稿行数：671；UTF-8字节数：70881。
- 内容修正断言：全部六组阻断对应修复均在正式正文；6H2/13H3逐字同序；来源索引[S34–S39]新增。
- 本次仅**文稿静态、官方资料与算式审核**。没有真实服务器、AWS、Cloudflare、Stripe、数据库、真实客户数据或生产支付环境的上线验证；官方政策可能变化，仍应以使用时的合同/产品文档为准。
- 源码/产品/支付第三板块均保持不变；第④章正式正文封板属于Owner批准的知识教材质量决定，不代表所有价格和法律条件通用。

## 四、归档和下一步

- 正式文档：`docs/CHAPTER4_FINAL_SEALED.md`；封板证据：`docs/CHAPTER4_SEAL_EVIDENCE_20261018.md`。
- 旧第④章Writer Gate/ZIP完成后退出main当前目录，保留Git历史供追溯；不把R2返修稿与正式正文并列。
- 下一章：第⑤章《安全防护》独立Writer首稿，6二级/13三级；先发完整离线工作包，不指定案例篇幅或工具结论，Writer无GitHub权限，交稿停在Reviewer。
