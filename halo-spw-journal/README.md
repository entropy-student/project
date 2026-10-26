# SPW Journal · Halo

这是 SPW/spike 个人网站的长期入口。当前状态、问题与下一步统一读取 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)，当前任务边界读取 [CURRENT_GATE.md](CURRENT_GATE.md)。

## 后续 Agent 从哪里开始

1. 从 [AGENTS.md](AGENTS.md) 进入 GitHub 当前 Governance，不使用旧的本地规则副本。
2. 阅读当前 Handoff、Gate 与其点名的 Evidence；发现现场变化先做限定核对。
3. 根据任务进入操作、设计、开发或恢复说明；不重播旧部署、旧授权或历史清理。

## 网站与日常更新

公开网站为 [spikersun.com](https://spikersun.com/)，由 Cloudflare Pages 托管。Windows 本地 Halo/PostgreSQL 是编辑源，电脑与 Docker 关闭后公开静态网站仍可使用；后台编辑与实时服务端功能需要本地运行。

日常更新：打开 Docker Desktop → 进入本地 Halo 后台发布内容 → 双击项目根目录 Publish-Website.cmd → 等待“更新成功”并检查网页。Markdown 导入工具只保存草稿；未发布草稿不会导出。启动与写作见 [OPERATIONS](docs/OPERATIONS.md)，静态更新细节见 [STATIC-SITE](docs/STATIC-SITE.md)。

## 文档导航

- [当前状态](REVIEWER_HANDOFF.md) / [当前 Gate](CURRENT_GATE.md) / [决策记录](DECISION_LOG.md) / [追加式执行证据](EXECUTION_EVIDENCE.md)
- [现行设计](DESIGN.md) / [运维与写作](docs/OPERATIONS.md) / [静态发布](docs/STATIC-SITE.md)
- [开发与主题回退](docs/DEVELOPMENT.md) / [存储与恢复能力](docs/RECOVERY.md) / [历史归档与清理清单](docs/ARCHIVE.md)

## 目录与归档边界

本地 source/theme-spw-cinema、components、scripts 是主题与工具；content 为本地原稿，design 保留图片和来源材料。halo2、db、backups、.env、LOCAL-ACCESS、CLI/Wrangler 凭据保留在本机，不上传到公开文档库。

canonical 项目档案为 [entropy-student/project/main/halo-spw-journal](https://github.com/entropy-student/project/tree/main/halo-spw-journal)。文档库还保留静态导出/发布辅助脚本，但不含完整主题源码和运行数据，不能代替完整备份。恢复边界必须以 docs/RECOVERY.md 为准。
