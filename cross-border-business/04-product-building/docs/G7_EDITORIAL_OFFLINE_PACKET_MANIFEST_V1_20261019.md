# 第四部分《产品搭建》｜G7独立语言审稿工作包登记 V1

> DATE：2026-10-19  
> STATUS：`OWNER_APPROVED_A_B_RESEALED / G7_EDITORIAL_READ_ONLY_PENDING / BOARD_NOT_CLOSED`  
> **GitHub固定快照：** `93020c7f9c2bc8646520760ac45edf96e21ede2e`，不得使用早于A+B补强的旧正文。  
> **工作包ZIP：** `第四部分_G7_语言与连贯性独立Reviewer工作包_20261019.zip`  
> **大小：** 39,580 bytes  
> **SHA256：** `6b08fe47a3b5e3c084419de4c35c4ce967e258dd5f9c3ec17c27d95f4eac4475`  
> **压缩包文件数：** 10；ZIP CRC、9份成员文件的SHA256与`MANIFEST_SHA256.md`比对PASS；内附Python获取脚本编译检查PASS。

## 交付真实性说明

- 本ZIP**并没有物理内嵌九份完整正式正文**；包含正式九章的固定commit原文链接、逐章**Git Blob SHA1**、官方GitHub Contents API下载并计算Git Blob复核的标准库脚本。Agent须实际联网经有读权限GitHub取得全部九章并核对hash；无法读取必须报告阻塞。**不得仅凭ZIP中的G5/G6报告宣称完成了九章语言审稿。**
- 其他已实际内嵌：统一工作说明、正式版本索引、语言审稿规则、A+B变更边界、完整G5原报告、完整G6独立Reviewer报告、转交提示词、官方动态事实风险清单、MANIFEST。
- 获取脚本仅运行在取得GitHub读取权限的独立Agent环境中；该脚本使用标准Python库和只读官方GitHub Contents API，可选择已有GitHub连接器逐章读取（并不强制运行脚本）。
- ZIP仅通过**Owner本次对话附件**交付，**没有二进制上传到GitHub**；仓库此处只做索引、SHA256及状态审计，不能凭路径名称声称二进制已入库。

## 本轮G7审稿冻结边界

- [G7只读独立Reviewer Gate](G7_EDITORIAL_INDEPENDENT_REVIEW_GATE_V1_20261019.md)；[九章G5+G6补强后再次封板记录](G5_G6_OWNER_AUTHORIZED_A_B_RESEAL_EVIDENCE_20261019.md)。
- 必须通读`CHAPTER1_FINAL_SEALED.md`至`CHAPTER9_FINAL_SEALED.md`最新全文；题树1核心/9一级/48二级/117三级不能改；技术/法律事实、范围、算式、代码逻辑、正式来源、`NOT_RUN`与`MODEL_ASSUMPTION`不能改。
- **只交付一份独立Markdown语言、连贯性与可读性审核报告**，逐章定位问题，给最小修改建议与5–10处措辞对照；必要内容变更隔离为`CONTENT_CHANGE_REQUIRES_OWNER`。
- 不修改GitHub、不自行改九章正文、不解冻、不做HTML、不宣称G7 PASS或G8 CLOSE，交付停点`STOP_AT_OWNER_REVIEW`。

## 文件索引

1. `00_先读_本轮任务与冻结边界.md`
2. `01_正式九章索引与版本校验.md`
3. `02_软性审稿范围与交付要求.md`
4. `03_本次G5G6补强与语言禁区.md`
5. `04_G5_原深广度调研完整报告.md`
6. `05_G6_全新独立Reviewer完整报告.md`
7. `06_转交独立Agent的完整提示词.md`
8. `07_获取并校验完整九章.py`
9. `08_官方资料与动态事实核验边界.md`
10. `MANIFEST_SHA256.md`

**注意**：当前正式版本以固定GitHub快照中的九章正文与各自Git Blob为准，旧首次封板证据只作历史溯源；本G7 Gate只读且待执行。