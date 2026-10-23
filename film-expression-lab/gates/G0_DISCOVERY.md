# G0 只读 Discovery

GATE_ID: FEL-G0-20261023
OBJECTIVE: 核实治理入口、当前项目事实、本地视频、旁白与研究工具。
MAX_ENDPOINT_THIS_ROUND: 只读发现，交由 Reviewer 接受发现结果后才能进入本地规划准备。
MANDATORY_REVIEW_STOP: 发现结束，不将配置存在提升为运行通过。
TARGET_AND_SCOPE: 当前工作区；用户级相关技能；OpenMontage 对应源码、配置存在性；Exa/Crossref 有界公开只读搜索。
APPLICABLE_CRITICAL_CONSTRAINTS: 不输出凭据或 Workspace 值；不调用付费生成；不访问无关私人素材；GitHub 只使用插件。
PREFLIGHT: 读取 GitHub canonical；确认 cwd/Git root/branch/HEAD/工作区变化；确认 Windows 用户、运行时版本。
REQUIRED_EVIDENCE: 规范版本、目录状态、工具路径/运行结果、非秘密配置布尔值、UNKNOWN 与失败原文。
ACCEPTANCE_CRITERIA: 每项发现区分直接核验、历史记录、推断；明确默认执行链的前置缺口。
ROLLBACK_STATUS_OR_PLAN: 只读操作，无目标数据回滚；工具自身可能写缓存日志，不视为媒体或生产写入。
OWNER_ONLY_ACTIONS: NONE。
REVIEWER_TO_EXECUTOR_RELAY: 本轮由当前 Reviewer 直接执行只读发现，不启动独立 Executor。
EXECUTOR_TO_REVIEWER_RELAY: 执行事实见 EXECUTION_EVIDENCE.md E001。

触发器扫描 A 不适用；B 本地主机与配置元数据适用；C 无部署，工具资源验证适用时按其边界；D 无真实自动化业务动作；E 供应商配置核查适用；F 无归档删除；G 无图像生成。本轮已读取通用部分、触发表、B/C/E 专项，不调用其他专项功能。
