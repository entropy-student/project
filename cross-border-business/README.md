# 跨境业务知识库｜总导航

> **知识正文状态（第三板块2026-10-20更新，其余依各自交接）：** ①G8/CLOSED · ②FINAL_SEALED/CLOSED · ③G1框架冻结、已封第1/4/6/8章、四线并行 · ④G8/CLOSED · ⑤G7/PASS、G8/CLOSE待Owner授权。  
> **范围：** 本页是五板块知识与文档的入口，不代表HTML/PDF已制作、业务实际运行或动态政策已完成生产验收。  
> **当前执行Gate：** 以每个板块的 `REVIEWER_HANDOFF.md` 为准；不得因为本页的状态描述自动解冻或启动新任务。

**[统一项目操作规范：PROJECT_WORKFLOW_SOP.md](PROJECT_WORKFLOW_SOP.md)**：框架设计→独立写作→Reviewer审稿→逐章封板→全书研究→独立复审→语言优化→G8归档CLOSE。

## 一、五板块与正式入口

| 顺序 | 需要解决的问题 | 正式内容 | 当前知识正文状态 | 查看入口 |
|---|---|---|---|---|
| ① 机会挖掘与市场判断 | 什么跨境生意值得做？ | 8章；冻结框架核心1/一级8/二级34/三级83 | **G8 PASS / CLOSED** | [第一板块：正文、框架、唯一交接](01-opportunity-market/README.md) |
| ② 网络环境搭建 | 如何搭建靠谱的跨境经营环境？ | 8章；冻结框架一级8/二级44/三级93 | **最终编辑PASS / CLOSED** | [第二板块：正文、框架、唯一交接](02-network-environment/README.md) |
| ③ 支付、税务与经营主体 | 做跨境生意，钱怎么收、税怎么交？ | **新版核心1/一级10/二级52/三级113正式冻结**；二级直接成节4处。另有旧支付指南七章只读CLOSED | **新板块G1_FRAMEWORK_FROZEN / CH1_CH4_CH6_CH8_FINAL_SEALED / A_CH2_G2 / B_CH5_G2 / C_CH7_G2 / D_CH9_G2 / NOT_CLOSED**；旧子项目独立CLOSED | [第三板块：唯一完整冻结框架、唯一交接](03-payment-tax-entity/README.md) · [原七章](../modern-commercial-payment-guide/docs/) |
| ④ 产品搭建 | 产品怎么做、怎么交付？ | 9章；冻结框架核心1/一级9/二级48/三级117 | **G8 PASS / CLOSED** | [第四板块：正文、框架、唯一交接](04-product-building/README.md) |
| ⑤ 获客与用户增长 | 怎么才能持续有客户下单？ | 6章＋1份经营实操附录＋1份术语/来源索引；冻结框架核心1/一级6/二级35/三级78 | **G7 PASS；G8/行政CLOSE尚未执行** | [第五板块：正文、附录、框架、唯一交接](05-acquisition-growth/README.md) |

**严格区分状态：** 各章 `FINAL_SEALED`、本板块 `CONTENT_COMPLETE` 和 `BOARD_CLOSED` 不是同一件事。第五板块虽然六章均封板，但不得写成已经G8/CLOSED。第三板块Owner已授权完成并冻结新版完整问题框架（核心1/一级10/二级52/三级113）；新正文未完成，已获Owner批准四线并行；第1/4/6/8章均已获Owner逐章授权Reviewer在Writer完整底稿上定向直修并G4封板；A线第2章、B线第5章、C线第7章、D线第9章进入G2，均不因此视为Writer正文已完成。原独立支付指南仍单独封板且不得直接覆盖。

## 二、以后怎么查看、学习或交给 Agent

1. **人自己阅读：** 进入本页→选择板块→打开该板块 `README.md`→按顺序阅读 `docs/CHAPTERN_FINAL_SEALED.md`；按需要先看 `FROZEN_FRAMEWORK_*.md` 快速定位章节。第五板块的实操附录和来源索引也在其README中。
2. **让 Codex / 新 Agent 读取：** 给出本仓库和具体板块路径，要求“以最新GitHub `main`为准，先读 `PROJECT_WORKFLOW_SOP.md`、当前板块 `REVIEWER_HANDOFF.md`、正式冻结框架与相关正式章节；以这些文件为依据回答，不把旧Gate当成现行状态”。需要真实修改时另指明文件、权限和目标。
3. **查询某个具体问题：** 用自然语言描述需求，让 Agent 先定位五板块中的知识主归属，再从正式文档抽取原有结论、适用条件、操作方法和来源，明确区分**原文已有知识**与后续联网核实的更新。
4. **查历史或恢复旧稿：** 先查看对应板块唯一交接中提供的不可变Commit/历史链接；当前正式内容永远以 `main` 的唯一 `FINAL_SEALED` 文件为准。

> **可直接转交的通用问题模板：** “请阅读 `https://github.com/entropy-student/project/tree/main/cross-border-business/`。以 `PROJECT_WORKFLOW_SOP.md`、相关板块 `REVIEWER_HANDOFF.md` 和正式章节为准，回答我的问题：【问题】。请标明来自哪一板块/哪一章，说明为什么、怎么做、适用边界；涉及价格、政策、服务商功能等动态事实时另行核查最新官方信息。本轮只读，不修改仓库。”

## 三、版本规则、当前停点与后续工作

- **唯一规则入口：** `PROJECT_WORKFLOW_SOP.md`。各板块的 `README.md` 仅导航、`REVIEWER_HANDOFF.md` 负责真实状态与审计，`docs/FROZEN_FRAMEWORK_*.md` 和 `CHAPTERN_FINAL_SEALED.md` 分别是唯一冻结框架与正式正文。
- **第五板块下一步：** 现状为 `G7_EDITORIAL_PASS / BOARD_NOT_CLOSED`。Owner日后如授权，才开展G8最终归档与行政CLOSE；不自动重做六章润色，不新开第七章。
- **第三板块：** 新版完整问题框架已正式冻结（1/10/52/113，4处直接成节）；四线G2/G3并行推进，第1/4/6/8章已正式封板；A线第2章、B线第5章、C线第7章、D线第9章G2独立Writer首稿待交，新版正文目前4/10章完成。旧独立支付指南保持CLOSED。其余板块按各自交接文件的最新状态执行；第五板块的附录与来源索引应保留。
- **格式与发布：** 五板块HTML、PDF或线上公开阅读平台均不属于这次文档整理；除另有Owner批准，不制作、不宣称完成。
- **历史资料：** 原父项目 `docs/` 的四份旧框架征稿任务书/参考标准已从当前 `main` 目录归档清理，完整原件仍在[整理前固定 Git 快照](https://github.com/entropy-student/project/tree/d907b59632e7abd98f33dafce26071656cc6a131/cross-border-business/docs)。其后续职责由本SOP、每个板块冻结框架和唯一交接承担。

## 四、项目文件边界

- **父目录 `cross-border-business/`：** 本README、唯一SOP、五个板块子目录。
- **每个正式板块：** README、唯一交接与唯一正式框架、正式正文（若已完成）。③已有唯一正式完整冻结框架，当前由Owner授权四线并行G2/G3；原独立支付指南留在旧路径且不改动。
- **历史证据：** 保留在固定Git Commit，不在当前根目录保留多套并行的候选或旧版工作指南。

重要：学习资料和文稿审核通过不等于真实服务部署、平台资格、交易链路、法律合规或经营结果已获验证。
