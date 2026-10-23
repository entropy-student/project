# 主分支保存与网页端交接

GATE_ID: FEL-G1D-REMOTE-HANDOFF-20261023
OBJECTIVE: 将已确定/待议/否决/未验事项及执行准备完整保存到Owner指定仓库main，让网页端继续讨论。
MAX_ENDPOINT_THIS_ROUND: entropy-student/project/main 中新增 film-expression-lab/，一次有界提交并读回；不提交其他项目、不建PR、不发布媒体或网站。
MANDATORY_REVIEW_STOP: main身份和文件内容读回，保存提交回执，随后向Owner报告。
TARGET_AND_SCOPE: repo entropy-student/project，branch main，path film-expression-lab/；该路径在写前主分支根目录中不存在。只用当前GitHub插件读写。
APPLICABLE_CRITICAL_CONSTRAINTS: 用户已明确确认目标仓库/分支/目录；源片/秘密/凭据不入仓库；旧方案标记为否决；不得将本机工具的存在说成网页端能力。
PREFLIGHT: 当前规范和本项目状态已读取；本地无origin，已向Owner澄清并获确认。远端main基线由插件读取；使用其base tree创建只新增本目录的tree，不混入本地支付分支。仅非强制fast-forward并带expected_sha。
REQUIRED_EVIDENCE: Owner目标确认、远端base SHA/tree、文件清单/本地字节hash与Git blob ID、内容安全检查、commit/ref、递归tree读回与关键交接文档读回。
ACCEPTANCE_CRITERIA: 交接覆盖原始需求和所有后续纠正；确定/建议/否决/未知分开；全部项目源码文档和历史静态设计都在清单中；忽略pycache/编译缓存；远端文件blob与本地预备清单一致。远端其他tree不变。
ROLLBACK_STATUS_OR_PLAN: 新增目录，不覆盖远端已有路径；保留原base commit，若需回退另做只移除该新增目录的正常提交，不force reset或改写共享main。
OWNER_ONLY_ACTIONS: 已获直接main提交授权；增加范围、改写历史/权限/治理、媒体发布均不在本Gate。
REVIEWER_TO_EXECUTOR_RELAY: 当前Reviewer直接整合交接并经插件提交，上传前做清单与无秘密审查，失败按原始错误停止，不换浏览器。
EXECUTOR_TO_REVIEWER_RELAY: 本地REMOTE_PUBLICATION_RECEIPT.json及远端tree/read-back事实；报告是否已实际落到main，不能只报告创建了悬空commit。
