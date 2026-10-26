# Halo / SPW 项目入口

本目录是仍在使用的 Windows Halo 编辑源，不是已退役工作区。

后续 Reviewer 从 GitHub 读取 [Governance Skill](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/SKILL.md)，按其要求读取当前 main 上的 VNEXT.md；本项目不保存或改写治理规则副本。然后读取 [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)、[CURRENT_GATE.md](CURRENT_GATE.md) 和其点名的证据。Executor 仅从当前 Gate 的 relay 开始。

项目档案的远端位置是 `entropy-student/project` 的 `main:halo-spw-journal/`。GitHub 访问使用会话 GitHub 插件。现场状态与记录不一致时，先做限定范围的只读核对。

已确认的项目边界：

- 公网 `spikersun.com` 使用 Cloudflare Pages；本地 Halo、PostgreSQL 可以关闭，暂不搬 VPS。
- 本地工作区为 `halo-fuwari/`；同级商城、new-api 等是其他项目。
- 文章公开发布由用户决定；Markdown 上传工具默认只创建草稿。同步已经公开的内容使用 `Publish-Website.cmd`。
- 数据库、附件、密钥、令牌、账号资料、恢复备份不进入 GitHub 文档库。恢复边界见 `docs/RECOVERY.md`。

这里是项目导航和用户约束记录；治理规则仍以 GitHub 当前 VNEXT.md 为准。
