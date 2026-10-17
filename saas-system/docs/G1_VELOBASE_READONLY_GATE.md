# SAAS-G1-VH-READONLY-PREFLIGHT-20261017

> STATUS=HISTORICAL_CLOSED / REVIEWED_RETURN_RESOURCE_HEADROOM_INSUFFICIENT
> GOVERNANCE=https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md
> SOURCE_TARGET=https://github.com/velobase/velobase-harness
> PROJECT_CANONICAL=`entropy-student/project@main:saas-system/`

## GATE_ID
`SAAS-G1-VH-READONLY-PREFLIGHT-20261017`

## OBJECTIVE
只读确认 Velobase 演示是否值得部署：源码身份/许可/支付与 Affiliate 风险、**Owner 真实测试主机** 的可用资源及隔离条件、可选择的启动方式。给下一轮私有运行 Gate 提供准确依据。

## MAX_ENDPOINT_THIS_ROUND
只读报告、非敏感摘要、候选实验配置方案与资源风险；**停止在 Reviewer**。不下载、clone、安装、构建、启动/停止服务、pull 镜像、写配置、购买插件、配置 Stripe 或执行真实/TEST 支付。

## MANDATORY_REVIEW_STOP
`YES`。任何资源不足、目标身份不明、项目隔离冲突、源码/许可证漂移或可能触碰既有服务都作为 RETURN/UNVERIFIED，不自动切换第二候选或改成 VPS/云平台。

## TARGET_AND_SCOPE
- 权威源码：GitHub `velobase/velobase-harness`，通过只读 API 记录目标 commit、许可证、`README.zh-CN.md`、`compose.demo.yml`、`services/demo/start.mjs`、Affiliate/Stripe 相关代码路径。
- 真实主机：由 Owner 在本机 Codex 执行 **只读** Windows、PowerShell、Docker/Node/pnpm 可用性、剩余 RAM/磁盘、相关端口/容器/镜像/卷冲突检查，不信任历史截图/代理所在地当当前事实。
- 拟定实验位置：新的**项目独立路径**，由主机只读盘点后提出，**本 Gate 不创建目录**。
- 不触碰项目库其他 Git 路径、共享 VPS、生产服务、个人浏览器会话、Windows 系统/网络配置、任何真实 Provider。

## APPLICABLE_CRITICAL_CONSTRAINTS
Governance v0.2.7 §0–10, §11 trigger scan, §12–13。当前是只读 Discovery；若后续涉及 Windows/Shared Docker、部署、授权或 Stripe，分别在独立下一 Gate 完整执行 §11A/B/C/D/E 的有效保护。严禁输出 Secret 或在普通文档里保存它们。可验证范围以实际本机证据为准。

## PREFLIGHT
1. 校验实际读取的是规范仓库主分支以及本 Gate；项目路径为 `saas-system/`。
2. 证明本轮动作仅为只读 GitHub 与本机诊断，且来源/作用域明确；不推定安装、删除、账号授权或费用许可。
3. 当地设备实测（非猜测）：主机身份和账户权限类别、OS/PowerShell、内存剩余、磁盘剩余、Docker 可用/是否运行、Node/pnpm、`127.0.0.1:3003` 占用、相关 Compose 项目资源列表（仅名称/大小等非敏感元数据）。
4. 审查候选 `compose.demo.yml` 中 4 CPUs/8 GB container memory limit（不是最低要求）、本地演示管理员、`127.0.0.1` 绑定与开发环境限制；不得泄漏用户现有私有容器环境变量。
5. 审查静态风险：部分退款状态/佣金整笔逆转、30%/30 天/$4.99/$50 示例规则、事件失败后返佣补偿证据，区分已知代码与未实测未知。

## REQUIRED_EVIDENCE
`SOURCE_COMMIT`; `SOURCE_FILES_AND_LICENSE`; `TARGET_LOCAL_PROOF`; `RESOURCE_HEADROOM`; `EXISTING_RESOURCE_CONFLICTS`; `PRIVATE_STARTUP_OPTIONS`; `STRIPE_AND_AFFILIATE_RISK_BOUNDARIES`; `OWNER_SIDE_EFFECT_COUNT=0`; `RECOMMENDATION_AND_BLOCKERS`。
主机证据仅输出必要脱敏字段，不得上传原始配置/认证凭据、完整私人进程日志或第三方数据。

## ACCEPTANCE_CRITERIA
- 源码 SHA/许可可重现，明确没有付费裂变插件的隐藏依赖。
- 有可审核的主机实测和隔离启动建议；明确资源/端口冲突，未凭经验假设可用内存。
- 高风险缺口不被掩盖，明确先演示 UI，再另行按 Gate 实测支付/奖励；`RUNTIME_PASS=NOT_TESTED`。
- 所有写入、安装、运行和支付的数量均为零，且不改变已有系统；Reviewer 可复核完整证据。

## ROLLBACK_STATUS_OR_PLAN
`READ_ONLY_NO_MUTATION`。若发生意外修改立即停止并分类，不能以“预检”名义清理或修复；任何未来部署必须独立规划数据隔离、备份/恢复、关停与资源回滚。

## OWNER_ONLY_ACTIONS
仅需要 Owner 在**真实本机 Codex** 转交此 Gate；无 Secret、支付资料、管理员密码、开通账号或购买动作。后续私有安装另设 Gate；公网/Live/真实资金另需明确 Owner 授权。

## REVIEWER_TO_EXECUTOR_RELAY
角色：本机只读 Executor。唯一 Gate 为本文；权威规范已由 Reviewer 解读，不要遍历历史。读取 `saas-system/REVIEWER_HANDOFF.md` 的 SYSTEM_MAP / CURRENT_GATE / CRITICAL_CONSTRAINTS，以及仓库内本 Gate；仅只读采样当前 Windows 主机环境与 GitHub 指定 Velobase 上游源码，不做任何资源变更。按 REQUIRED_EVIDENCE 形成最小脱敏报告，停在 Reviewer。若无法证明本机真实目标环境，返回 `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`，不要改用另一台机器顶替。

## EXECUTOR_TO_REVIEWER_RELAY
按 Governance §9 固定短格式：`结果 / 改动 / 验证 / 问题 / 回滚 / 请 Reviewer 检查 / Owner 转交`。结果只能 `PASS_CANDIDATE` 或精确 `RETURN_*`，不能自称 Reviewer PASS。

## LIMITATION
本文授权的是**只读准备**，不是“连续安装三个 SaaS”的总授权。任何后续实验先依据新证据签发独立运行 Gate。
