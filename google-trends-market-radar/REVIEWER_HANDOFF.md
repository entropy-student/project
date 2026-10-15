# REVIEWER_HANDOFF — Google Trends Market Radar

> 2026-10-15 · Reviewer 同步记录。此文件是项目在 GitHub 的**唯一当前状态面板**。证据详情在 EXECUTION_EVIDENCE；历史决定在 docs/。状态不会因 Executor 自报 PASS_CANDIDATE 自动升级。

## PROJECT_GOAL

从 Google Trends 及其他真实来源识别美国等海外市场近期（尤其近 90 天）持续增长的消费需求，之后用竞品、真实交易、付费意愿和获客证据筛选可售产品。技术采集成功不等于发现畅销品。

## PROJECT_STAGE

`G4A_REVIEWED_PASS / G4B_NOT_AUTHORIZED`。G0–G2 采集链路、G3 数据质量校准及 G4A 有界热点发现与缓存审计已完成相应技术 Gate；G4B 真实增长验证和 G5 商业验证尚未执行。

## SYSTEM_MAP

- **Runtime / channel**：Owner 真实 Windows 11 + PowerShell / Codex；Clash Verge/Mihomo 当前已证实的代理端口 `127.0.0.1:7897`。
- **Provider/API**：SerpApi MCP；MCP JSON-RPC 版本协商 `2025-06-18`；Google Trends 历史兴趣曲线和 Trending Now。
- **Authentication**：Owner 控制的本地 Secret 文件；受控进程内存 Bearer 使用；密钥值从不进 GitHub、日志、命令行、截图或普通交接包。
- **Persistence**：Owner Windows 项目目录内的脱敏 JSON/CSV/证据 ZIP；GitHub 仅保存无敏感材料的接受记录与证据哈希。不存在本项目的新服务器部署、数据库或公网服务。
- **Execution authority**：Owner 授权费用与 Gate 边界；Reviewer 决定 PASS/RETURN；Executor 仅执行当前 Gate 并停在 Reviewer。

## CURRENT_ACCEPTED_STATE

1. G2 已取得带日期的真实历史兴趣数值序列。采集端到端工作，不声称 Google 官方源独立复测完成。
2. G3 的 90 天日序列在较小众的产品词上大量为零，12 个月周序列更有利于观察；不能跨独立归一化查询直接比较绝对量。周桶末端的 partial 标志未知。
3. G4A：8 次实际搜索记录（2 次美国/英国 7 天热点、6 次历史重复查询）；美国 30 + 英国 15 条线索，去重为 41 个关键词；周曲线新增 318 点、基线 159 点，共比较 477 点；原始执行包 80 个文件、79/79 Manifest 完整。以提供的脱敏证据核验，不代表 Provider 账单直接回读。
4. 3 个关键词的重复采样共沿用各自基线的 Search ID 和创建时间，曲线均相同：`CACHE_REUSE`；**独立采样稳定性未建立**。
5. Reviewer 已签发 `PASS_GT_SERPAPI_G4A_BOUNDED_DISCOVERY_AND_CACHE_AUDIT`，仅针对 G4A 的来源、边界及缓存审计；不批准 G4B/G5。
6. G4A Reviewer 接受 ZIP 已生成并独立审查；**Owner Windows 主机的接受记录持久化及同机哈希回读仍未得到证实**。

## CURRENT_GATE

`NONE — G4A COMPLETE; G4B PENDING SEPARATE REVIEWED GATE AND OWNER AUTHORIZATION`。本次 GitHub 操作仅同步脱敏项目状态，不发出 SerpApi 请求、不改变运行时、不视为 G4B 执行授权。

## CRITICAL_CONSTRAINTS

- 绝不提交密钥、账户信息、真实用户私密材料或包含 Secret 的原始 Provider payload。
- 不将 7 天新闻/体育/政治热搜视为 90 天增长商品；45 条线索不是验证后的商机。
- 不从 Search ID 和重复缓存值相同推导独立重复采样稳定性；不将 Google Trends 的相对热度推导为绝对销量、搜索量或支付行为。
- 保留完整失败记录和 Reviewer 限定，禁止覆盖既有 Gate/Evidence；不因 GitHub 上传推定 Owner 本机有同样文件。
- 禁止无新 Gate 的实时搜索、自动重试、套餐升级、自动付费或外部配置/ACL/代理修改。

## DEFAULT_EXECUTION_CHANNEL

Owner Windows 本机受控 Codex，先核验有效 Gate、真实本机身份与路径，后经 Clash 7897 连接 SerpApi MCP。GitHub 文档同步不替代 Windows 实际读取回证。

## CURRENT_ROLLBACK_STATUS

近期 Gates 仅新增证据，无需回滚运行配置；已存在的 Owner-local ZIP/CSV/Reviewer 文件保留不覆盖。本次 GitHub 仅记录文件的新增/导航修改，可通过 Git 历史回退。

## UNRESOLVED

- G4A 接受记录在 Owner Windows 的持久化与同机读回：`PENDING_OWNER_RELAY`。
- 缓存之外的独立采样稳定性：`UNKNOWN`。
- 12 个月周序列首末周完整性（partial）：`UNKNOWN`。
- Google 原始曲线独立对照、Provider 实际累计扣次和最新余额：`UNKNOWN`。
- 长期增长、需求规模、购买意图、商品利润及获客能力：`NOT_ESTABLISHED`。

## NEXT_STEP

1. 先在 Owner Windows 主机核验并原样持久化 G4A Reviewer 接受包，完成同机哈希回读，保持现有配置不动。
2. Reviewer 另行设计 G4B 的有界 Gate，优先选择带购买意图的跨领域词、长期与 90 天曲线交叉校准、过滤事件热搜和稀疏数据；费用与调用上限由 Owner 明确授权。
3. G4B 经独立审核后才可进入 G5 真实付费/竞品/获客验证。

## OWNER_ACTION_REQUIRED

G4A Windows-local 接受记录持久化所需的实际下载路径和执行授权由 Owner 在本机交给 Codex；之后提交回读证据。G4B 尚待单独授权，当前不需要提供 API Key 内容。

## EVIDENCE_POINTERS

参见 [EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md) 及 [G4A Reviewer 决定](./docs/G4A_REVIEWER_DECISION_2026-10-15.md)。G4A 源执行 ZIP SHA-256：
`63ab230f8b2268a042a4c5f9b55e1a0897010d65889135351a15f0805b59c618`。
G4A Reviewer 接受 ZIP SHA-256：
`41d1330aff15d1c60663e28e8843416e308189ccdbce5942457f6fb7b470beed`。
