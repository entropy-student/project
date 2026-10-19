# 04｜产品搭建

> **CURRENT_STATE（2026-10-19）：FRAMEWORK_V2_FROZEN / CHAPTER1_TO_CHAPTER8_FINAL_SEALED / CHAPTER9_WRITER_V1_PENDING**  
> **正式问题树：1核心／9一级／48二级／117三级（冻结）**  
> **CURRENT_GATE：CB04-CH9-INDEPENDENT-OFFLINE-FIRST-DRAFT-20261019**；第4.8章Owner授权Reviewer定向修复R2后正式封板；第4.9章Writer首稿Gate已发布、完整V1待交。HTML尚未启动；整个板块尚未CLOSE。

## 唯一正式问题树、各章正式正文与封板审计

- **[正式V2完整冻结问题树](docs/FROZEN_FRAMEWORK_V2_20261018.md)**：章节题目编号、原文、归属、顺序、层级不可擅改，4.3.4为没有三级的直接成节二级题。
- [4.1《我该把产品做成什么形式？》唯一正式正文](docs/CHAPTER1_FINAL_SEALED.md)（4/10） · [封板证据](docs/CHAPTER1_SEAL_EVIDENCE_20261018.md)
- [4.2《第一版先做哪些东西？》唯一正式正文](docs/CHAPTER2_FINAL_SEALED.md)（4/10） · [封板证据](docs/CHAPTER2_SEAL_EVIDENCE_20261018.md)
- [4.3《怎么用最省事的方式把产品搭出来？》唯一正式正文](docs/CHAPTER3_FINAL_SEALED.md)（5/11） · [封板证据](docs/CHAPTER3_SEAL_EVIDENCE_20261018.md)
- [4.4《怎么让客户顺利购买和使用？》唯一正式正文](docs/CHAPTER4_FINAL_SEALED.md)（6/13） · [封板证据](docs/CHAPTER4_SEAL_EVIDENCE_20261019.md)
- [4.5《商品、库存和订单怎么管清楚？》唯一正式正文](docs/CHAPTER5_FINAL_SEALED.md)（5/12） · [封板证据](docs/CHAPTER5_SEAL_EVIDENCE_20261019.md)
- [4.6《怎么把产品交付到客户手里？》唯一正式正文](docs/CHAPTER6_FINAL_SEALED.md)（6/16） · [封板证据](docs/CHAPTER6_SEAL_EVIDENCE_20261019.md)
- [4.7《交付出问题了怎么办？》唯一正式正文](docs/CHAPTER7_FINAL_SEALED.md)（5/14） · [Owner授权Reviewer直修封板证据](docs/CHAPTER7_SEAL_EVIDENCE_20261019.md)
- **[4.8《上线前怎么检查？》唯一正式正文](docs/CHAPTER8_FINAL_SEALED.md)**（5/14） · **[Owner授权Reviewer直修R2正式封板证据](docs/CHAPTER8_SEAL_EVIDENCE_20261019.md)**。R2原文经定向修复N01–N08、同步代码图示/尾表核验后封板。**没有Writer R3交付**。

## 当前第4.9章独立Writer任务

- **[第4.9章完整独立Writer首稿Gate V1](docs/CHAPTER9_INDEPENDENT_WRITER_GATE_V1_20261019.md)**：一级《上线后怎么维护和改进？》，冻结8二级/17三级，**Writer V1还未交**。
- [8个UTF-8 Markdown的完整离线ZIP与SHA256清单](docs/CHAPTER9_WRITER_OFFLINE_PACKET_MANIFEST_V1_20261019.md)：`第四部分_第九章_独立Writer完整离线工作包_V1_20261019.zip`，40,270 bytes，SHA256 `c85e5a2cf2af3dfa259a639ca839ecc9af2daf1c8d96925baafc7706fd6a6fa0`；包含4.8最新完整正式正文，二进制仅在Owner对话提供，GitHub只保留索引和指纹。
- **[唯一现行Reviewer交接](REVIEWER_HANDOFF.md)**；[五板块统一生产、审核与封板SOP](../PROJECT_WORKFLOW_SOP.md)。

## 九章进度

| 章 | 一级问题 | 二级/三级 | 状态 |
|---|---|---:|---|
| 4.1 | 我该把产品做成什么形式？ | 4/10 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.2 | 第一版先做哪些东西？ | 4/10 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.3 | 怎么用最省事的方式把产品搭出来？ | 5/11 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.4 | 怎么让客户顺利购买和使用？ | 6/13 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.5 | 商品、库存和订单怎么管清楚？ | 5/12 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.6 | 怎么把产品交付到客户手里？ | 6/16 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.7 | 交付出问题了怎么办？ | 5/14 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.8 | 上线前怎么检查？ | 5/14 | **FINAL_SEALED / OWNER_APPROVED** |
| 4.9 | 上线后怎么维护和改进？ | 8/17 | **WRITER V1 PENDING** |

## 已结束的审核历史与边界

- [4.8 Writer V1真实RETURN](docs/CHAPTER8_WRITER_V1_REVIEW_RETURN_20261019.md)（B01–B10）、[4.8 Writer R2真实RETURN](docs/CHAPTER8_WRITER_R2_REVIEW_RETURN_20261019.md)（N01–N08），均被Owner后续特别授权Reviewer基于完整R2全文定向修订并封板的决定覆盖；R3 ZIP准备过但没有独立Writer R3交稿。详细见[4.8封板证据](docs/CHAPTER8_SEAL_EVIDENCE_20261019.md)。
- 4.1–4.7其他历史V1/R2 RETURN已被后续Owner封板覆盖，未执行的R3任务不等于独立Writer R3；正式正文只认对应`CHAPTER*_FINAL_SEALED.md`。这八章未经Owner新授权不得修改。
- 4.9不由Reviewer预写，当前仅准备Writer Gate/离线包/转交话术。Writer交完整正文及事实核验后停在Reviewer，独立审查通过后仍须Owner决定封板。九章全部完成后按照统一SOP另行审深广度、独立盲审、语言连贯、归档CLOSE；HTML属于另行授权，不自动启动。

[返回五板块父项目](../README.md)
