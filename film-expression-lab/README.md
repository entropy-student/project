# 影视隐藏表达研究频道

工作名 Film Expression Lab，不代表已确定频道品牌。立项日期 2026-10-23，时区 Asia/Singapore。

本项目服务于看过作品、希望重看并发现新理解的普通观众。用户下一轮提供一段影视片段，执行 agent 根据一段提示词制作可审阅的测试视频。当前没有测试片源，不宣称视频生产链已验收。

## 入口

**最新执行路线先读 `gates/THREE_GATE_PLAN.md` 与 `style/STYLE_REVIEW.md`。** 网页端历史需求继续参阅 `WEB_HANDOFF.md`。 当前目标仓库为Owner确认的 `entropy-student/project/main`，项目路径为 `film-expression-lab/`。用户已纠正为顺序展开的陪伴式拉片；取消90至180秒目标；名称必须含“拉片”；旧品牌/视觉已否决。具体已定和待议事项以交接入口为准。

已读回的完整初始归档提交为 `51864905f07f1eebd390070ca182b109e8ed2fa7`，33个文件。`REMOTE_PACKAGE_MANIFEST.json`对应这份初始快照，后续交接状态/回执修订以各自Git提交为准，不把历史hash误当最新文件hash。核验事实见 `REMOTE_PUBLICATION_RECEIPT.json`。网页端后续以仓库main为项目文档入口，不假设Owner本地路径可访问。

- `REVIEWER_HANDOFF.md` 是 Reviewer 当前状态入口。
- `EXECUTOR_PROMPT.md` 是交给执行 agent 的完整启动提示词。
- `gates/THREE_GATE_PLAN.md` 定义 Owner 新确认的精简 S1 风格 → S2 试产 → S3 成片三 Gate；当前 S1 候选供 Owner 选择。
- `style/style-preview.html` 是无需联网、可切换 A/B 及四种观看状态的设计预览。
- `gates/G2_TEST_VIDEO.md` 作为 S2 的详细执行边界，仍为 CANDIDATE，须由 Reviewer 在收到片源及调用授权后激活。
- `PROJECT_CHARTER.md` 定义频道定位、范围、分阶段目标。
- `TOOLCHAIN.md` 记录本机工具实测与限制。
- `RUNBOOK.md` 定义研究、写作、剪辑、质量验收与交付。
- `EXECUTION_EVIDENCE.md` 追加执行事实，`DECISION_LOG.md` 保存项目决策。

## 治理来源

唯一运行规则为 GitHub 上 `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md`。本地文件只描述本项目的事实、Gate 与执行要求，不复制或替代治理规则。Reviewer 每轮从 GitHub 读取当前规范；Executor 按当前 Gate 与 relay 启动，不遍历历史。

本轮读取版本 v0.2.7 / ACTIVE_PROVISIONAL；读取时 main commit 为 `16e33384dc569629a1527d1c9ec0060823af09ce`，VNEXT blob 为 `3917c88a7f36df7a53758b3879a92703d659ef9d`。此信息用于审计，不是下轮版本锁定。

## 本地边界

项目拥有的新增文件仅位于本目录。父仓库为其他项目工作分支，存在无关未跟踪文件；不得提交父仓库的其他文件、切换分支或清理它们。本轮不建立远端仓库、不部署网站、不公开上传片源、不生成正式节目。
