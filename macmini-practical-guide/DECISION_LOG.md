# DECISION LOG（追加式）

## 2026-10-28 · D-001：把这份压缩包作为独立图文项目
- 来源：Owner「请你按照 VPS 项目管理规范承接这个项目」+ 当前上传包。
- 选择：`entropy-student/project/macmini-practical-guide/`，与 Shared VPS、个人博客及视频模板项目分开。
- 理由：实际入口是静态 HTML 图文教程，不需要新 VPS 或产品后端。
- 非选择：不把它当成 Mac mini 主机采购或部署；不并入视频模板工程。

## 2026-10-28 · D-002：本轮治理记录，不做创意改稿
- 已知历史决定：上轮《文案与封面打磨记录》明确只记录反馈，不改 HTML、文案、图片。
- 当前执行：只读取、校验、归档现状与设置下一 Gate；保留原稿、现封面、现图片。
- 解封要求：必须进入单独内容/封面 Gate，带具体验收标准。

## 2026-10-28 · D-003：图片许可分离
- Apple 官方示意图随源包保留作为原始工作资料；公开仓库再发布/公开出版仍待授权核验。
- 男主形象与风格参考图不在本 ZIP：标为 `MISSING`，禁止从临时路径推断它们还存在。
- 下一 Gate 优先可回溯的源包导入/来源确认，再逐轮设计封面、修改文案、完成 QA。

## 2026-10-28 · D-004：Reviewer / Codex 工作方式
- Reviewer 负责确定每个 Gate、验收标准和最终 PASS/RETURN。
- Codex 仅按本轮自包含 relay 执行，输出 `PASS_CANDIDATE` 或 `RETURN_*` 并停在 Reviewer。
- 关键动作必须持久化 Evidence/Handoff，并 fresh read-back；不自行跳 Gate、发布、合并或者修改共享设施。

## 2026-10-28 · D-005：Owner 范围纠偏（覆盖 D-001/D-002 的目标判断，不删除历史）
- **Owner 直接决定**：还没有确定好的视频文案格式、开头结构、配图方法；本项目需先研究并试验实操型自媒体视频的叙事方法，而不是确定 Mac mini 的固定教程样式。
- Mac mini 只是第一期试验题目；原 HTML/封面只是既有参考，HTML 仅用于在一个文件中审阅口播、画面和封面，不进行移动端或 HTML 美术单独迭代。
- Human Writing Skill + 精简语料是可能帮助贴近个人表达的方案，需后续实测；不应当成用户已经认可的最终固定写作流水线。
- Reviewer 先调查优秀视频结构并提出可修改的框架，给 Codex 一个有界的首轮文案 + 声画方案提示词；等样稿出来才确认修改点。
- 取消尚未执行的旧 `G1_SOURCE_IMPORT_AND_RIGHTS_RECONCILIATION_20261028`；下一 Gate 改为 `G1_VIDEO_SCRIPT_AND_VISUAL_BEATS_PILOT_20261028`。旧 G1 不转为历史 PASS。
- 当前研究方案状态 `CANDIDATE`，不是 Owner 冻结的通用模板。
