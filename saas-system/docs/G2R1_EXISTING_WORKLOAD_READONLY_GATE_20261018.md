# G2R1｜既有 Docker 容器退出只读诊断

> GATE_ID=`SAAS-G2R1-EXISTING-WORKLOAD-READONLY-20261018`  
> STATUS=`REVIEWER_READY / OWNER_LOCAL_NOT_YET_EXECUTED`  
> GOVERNANCE=`entropy-student/spike.skill@main:vps-project-governance/VNEXT.md` v0.2.7

## OBJECTIVE
仅调查 G2 期间三个**原本运行中的 Docker 容器**同时退出（137、0、0）的**现在状态和最低限度的原因证据**，以及 G2 实验容器是否仍安全停机。**不启动、不恢复、不复现任何服务**。

## MAX_ENDPOINT_THIS_ROUND
Owner Windows 本机 Codex 只读获取容器项目归属/状态和退出时间、Docker Desktop/Engine 启停及有限 Windows/WSL 相关事件，返回脱敏证据给 Reviewer 即止。不得下载、构建、启动/停止容器、重启 Docker Desktop/WSL、修改 Compose/Windows 设置、清理数据、触发业务或访问任何 Provider/Stripe。

## MANDATORY_REVIEW_STOP
`YES`；信息不足时以 `CAUSE_UNKNOWN` 结束，不再尝试运行复现。即使检测到其他项目容器仍退出，也只能报告所属项目和可能影响，不能自行恢复它们。

## TARGET_AND_SCOPE
真实 Owner Windows 11、Docker Engine；三个旧容器必须按 G2 执行当轮的**脱敏指纹映射**准确识别，不能用指纹充当完整容器 ID，也不能猜测归属；旧指纹 `B1A52AC5143F8D42`、`F80E1D715DDC2D45`、`EA4E534D3ECBA0DE`。新实验项目仅 `saasvh-e88e259`、项目独立源目录。关键 UTC 时间约 `2026-10-17 16:32:30–16:32:36`，本机应记录时区换算。

## APPLICABLE_CRITICAL_CONSTRAINTS
Governance §0–10、§11A/B/C、§11D（只读）、§12–13。保护共享 Docker/其他项目、Secret/私人日志；绝对不运行或恢复任何容器。Owner 的“内存不设限制”仅废止事前硬阈值，不废除已经发生工作负载回退时的 STOP。G2 原实验结果和历史 G1 RETURN 不改写。

## PREFLIGHT
1. 阅读本 Gate，及 `saas-system/REVIEWER_HANDOFF.md` 的 SYSTEM_MAP/CURRENT_GATE/CRITICAL_CONSTRAINTS，验证目标是真实 Owner 本机和同一个 Docker Engine。
2. 使用 G2 已保留的只读容器身份关联，逐个核对原 A/B/C 的当前 `State`、`ExitCode`、`StartedAt`、`FinishedAt`、`RestartCount`、`OOMKilled`、`RestartPolicy`、健康状态、Compose project/service 标签。**仅取这些 allowlist 字段，不输出完整 `docker inspect`、环境变量、卷挂载 Secret 路径或原始日志。**
3. 限 G2 退出前后数分钟核对 Docker 事件保留范围、Engine/桌面重启证据、Windows/WSL 资源终止/强制关停信号。日志缺失记 `UNKNOWN`，不能据没有 OOM 事件直接否定宿主机级内存问题。
4. 只读查看 `saasvh-e88e259` web/postgres/redis 的状态、3003 监听、2 卷、镜像/网络保留与否。不触碰 Docker Desktop 配置，也不清理构建缓存。
5. 如果三个旧容器已有外部流程恢复，记录当前状态和时间，**不再次重启**。如果仍停止，分类所属项目是否业务相关，并提出需谁批准恢复；不得代为修复。
6. 返回明确定性：`ENGINE_STOP_SUPPORTED / RESOURCE_PRESSURE_SUPPORTED / INDIVIDUAL_EXIT_SUPPORTED / CAUSE_UNKNOWN`，将**直接证据**与**推测**分开。

## REQUIRED_EVIDENCE
`TARGET_LOCAL_PROOF`、`ORIGINAL_CONTAINERS_A_B_C`、`CURRENT_RUNNING_STATE`、`EXIT_TIMELINE`、`DOCKER_ENGINE_EVENTS_COVERAGE`、`WINDOWS_WSL_EVENTS_SUMMARY`、`G2_RESIDUAL_RESOURCES`、`BUSINESS_IMPACT_IF_KNOWN`、`CAUSE_AND_CONFIDENCE`、`READONLY_SIDE_EFFECT_COUNT=0`、`RECOVERY_AUTHORIZED=NO`、`STOPPED_VELOBASE=YES/UNKNOWN`。

## ACCEPTANCE_CRITERIA
能审阅三个旧容器现在是否恢复、各属于什么业务类别，以及是否存在足以支持共同引擎停止/独立退出/资源压力的证据。无法明确原因时 `CAUSE_UNKNOWN` 是可接受的诊断结论。**诊断 PASS 不是 SaaS 演示 PASS。**

## ROLLBACK_STATUS_OR_PLAN
本 Gate 完全只读，不预计有回滚；原 G2 两卷、镜像、网络和代码保留。运行新容器、恢复旧容器、删除项目和转场均另设 Gate。

## OWNER_ONLY_ACTIONS
无需密码、Stripe Key、账号购买或人工释放内存。若旧项目需要恢复，交给 Reviewer 另定范围，不能本 Gate 直接重启。

## REVIEWER_TO_EXECUTOR_RELAY
请作为 Owner Windows 本机 Codex，仅执行当前 G2R1 Gate。前提是 G2 原 Docker 实验 stopped、旧三容器退出原因未知。只读检查原容器当前状态、Docker/Windows 窄时间线、G2 剩余物，不复制原始日志/Secret；任何不确定保持 UNKNOWN。完成即停 Reviewer；不重试部署、不继续 Open SaaS/Wave。

## EXECUTOR_TO_REVIEWER_RELAY
按 Governance §9：结果、改动、验证、问题、回滚、请 Reviewer 检查、Owner 转交。输出脱敏小报告（禁止真实容器 ID、敏感标签或环境变量）。