# 第五部分｜第一章《我的客户在哪里？》离线Writer包清单与校验

> **STATUS：GATE_RELEASED / WRITER_NOT_STARTED / STOP_AT_REVIEWER**  
> **离线包：** `第五部分_第一章_我的客户在哪里_独立Writer首稿工作包_V1_20261018.zip`  
> **ZIP字节数：** 20,286  
> **ZIP SHA256：** `dec7163f43cf553f99ea21412e0c59d1df3e3daac72bfb0461fae5486776e5a0`  
> **完整性：** 本轮生成后ZIP可正常解压（`testzip()=None`）；9个Markdown文件均存在，含首稿转交提示词。**对话离线附件已生成，不能以此记录推断ZIP二进制已经上传GitHub仓库。**

## 权威与历史

- **现行冻结：** [完整V2 1/6/35/78](FROZEN_FRAMEWORK_V2_20261018.md)。Owner在2026-10-18明确批准“我没问题，正式通过落库吧”，现行问题不可擅改。
- **首稿Gate：** [第一章独立Writer Gate](CHAPTER1_INDEPENDENT_WRITER_GATE_V1_20261018.md)。一章、4二级、8三级，Writer只做正文首稿，不能变更题目。
- **对照流程：** 第二板块[长期Writer→Reviewer→Owner工作规范](../../02-network-environment/docs/WRITER_REVIEWER_WORKFLOW_V1_20261018.md)。可参考其成熟流程，但不影响第二板块已封板章节。
- **离线Writer：** 无GitHub仓库权限，不要求登陆仓库。完整正式树和第一章原题已作为ZIP内资料提供。

## ZIP内完整9文件

| 编号 | 文件 | 作用 |
|---|---|---|
| 00 | `00_先读_当前任务与范围.md` | 当前边界、Reader/Writer任务与阅读顺序 |
| 01 | `01_五板块第五部分完整冻结框架.md` | 全部1/6/35/78原问题树；候选状态被替换为正式批准的离线说明 |
| 02 | `02_第一章冻结题目和知识职责.md` | 第一章1H1/4H2/8H3逐字同序题目 |
| 03 | `03_读者背景_全项目边界与已有成品.md` | 中国大陆商家读者与五板块分工 |
| 04 | `04_独立Writer创作及Review合同.md` | 独立首稿自由度、Reviewer职责及Owner封板 |
| 05 | `05_事实核验_未知事项及引用原则.md` | 官网来源、国别/时间限制、UNKNOWN及MODEL_ASSUMPTION |
| 06 | `06_交付要求_完整性自检及停点.md` | 全章正文、核验记录、交付ZIP、停点 |
| 07 | `07_给独立Writer的转交提示词.md` | 可单独复制转交的指令 |
| 08 | `MANIFEST_SHA256.md` | 离线包每个内部文件字节数和SHA256，可独立核对 |

## 生成后验收

| 检查点 | 结果 |
|---|---|
| 正式完整版问题树 | 从Owner批准V2提取，核心1/一级6/二级35/三级78 |
| 第一章问题原文 | 4二级/8三级按原次序生成标题 |
| 章节职责 | 第一章只讲买家接触点、购买意图、B2B角色、国家语言差异；获客执行属于第二章 |
| 完整包 | `zipfile.testzip()=None`，9个文件 UTF-8，可全量脱机阅读 |
| Reviewer上限 | 仅发布独立Writer首稿Gate和离线资料包；**尚无任何Writer候选正文或事实核验交付** |
| Owner当前唯一动作 | 下载对话中的ZIP、附带话术转给Writer；回传其正式候选ZIP供Review |

完成首稿后，Reviewer先独立审核；若RETURN，同轮给Owner完整返修ZIP及可直接转发的修订提示词。Owner批准后才创建`CHAPTER1_FINAL_SEALED.md`并封板。
