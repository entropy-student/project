# Google Trends Market Radar（海外需求趋势雷达）

> 项目状态以 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md) 为准；本 README 只解释目标与文档入口，不维护第二套动态状态。

## 目标

建立可重复、可核验的海外需求研究流程：真实搜索趋势采集 → 质量筛选 → 持续增长验证 → 产品/竞品/付费证据验证。研究市场机会，**不将 Google Trends 相对指数直接当作销量、绝对搜索量或购买意图**。

## 运行边界

- 当前数据通道：Owner 的真实 Windows 11 本机通过 Clash 本地代理调用 SerpApi MCP；真实 API Key 仅在获授权的受保护进程内存处理。
- GitHub 仓库只保存**脱敏的项目状态、决定和证据指针**。不上传 API Key、用户账户标识、原始敏感日志、完整本机路径、密钥文件、客户数据或大体积查询结果。
- 真实原始采集证据与 Reviewer 接受 ZIP 保留在 Owner 管理的交接环境；GitHub 中的校验值用于关联，不证明 Owner Windows 主机已完成持久化。
- 任何新 SerpApi 调用、额度支出、跨 Gate 扩大范围，需要独立、明确、受界限约束的授权。

## 文档入口

- [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)：当前唯一被 Reviewer 接受的项目事实、未解决问题、下一步。
- [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md)：已核验 Gate 和 ZIP SHA-256 的不可覆盖式索引。
- [G4A Reviewer 决定](./docs/G4A_REVIEWER_DECISION_2026-10-15.md)：已接受的范围与严格限制。
- [决策日志](./docs/DECISION_LOG.md)：为什么这样推进、哪些结论尚未成立。

## 治理

正式操作规范：[VPS Project Governance v0.2.7（ACTIVE_PROVISIONAL）](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md)。本目录不修改、不覆盖、不扩展该规范。

最后记录日期：2026-10-15。
