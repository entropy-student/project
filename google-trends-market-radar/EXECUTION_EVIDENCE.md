# EXECUTION_EVIDENCE — 已审查证据索引

> 追加式记录。此处仅含脱敏的校验值、事实来源与限制，不收录原始凭据、账户信息、原生敏感 Provider 响应或文件系统用户标识。实际 Provider 使用量须以账户控制台为准。

## 2026-10-15 — G2 真实历史数据 Canary

- **REVIEWER_DECISION**：`PASS_GT_SERPAPI_G2_REAL_TIMESERIES`。
- **EVIDENCE_ORIGIN**：Owner 上传执行 ZIP；Reviewer 对可访问 ZIP 和脱敏 JSON/CSV 做独立一致性审查（非 Google 重新采样）。
- **FACTS**：3 次实际搜索；取得 182 个数值点（`iphone` 91 天非零；`custom birthday magazine` 91 天序列、仅 1 个非零；`birthday magazine template` 无序列）。
- **REVIEWER_ACCEPTANCE_ZIP_SHA256**：`e84f97e5bc67f79a0d9cbad3f4f9bc20878ee5767c294513e26f530d15926da9`。
- **LIMITS**：无法把相对 Google Trends 数值转换为销量或绝对搜索量，实际账户扣次未直接复核。

## 2026-10-15 — G3 关键词质量校准

- **REVIEWER_DECISION**：`PASS_GT_SERPAPI_G3_QUALITY_CALIBRATION`。
- **EVIDENCE_ORIGIN**：Owner 上传 ZIP、逐项核验 CSV/脱敏响应与窗口/日期。
- **FACTS**：7 次新增搜索、复用 1 条 G2 结果；485 个数字点；三个词12个月周序列完整输出 53 个周桶，但首末桶 partial 状态未知。90 天部分词非零比例约18%–21%，日曲线仅宜探索。
- **REVIEWER_ACCEPTANCE_ZIP_SHA256**：`cc8ff7428eafce212e35df64ae9dc590df2a49313ee1db961d14c14210b2aa69`。
- **LIMITS**：不能把序列长度等同于稳定的持续增长；独立归一化曲线不可横向比较绝对量。

## 2026-10-15 — G4A 热点发现与缓存审计

- **GATE_ID**：`GT-SERPAPI-G4A-TREND-DISCOVERY-REPEATABILITY-20261015`。
- **EXECUTOR_RESULT**：`PASS_CANDIDATE_GT_SERPAPI_G4A`，仅为执行者提出的候选状态。
- **REVIEWER_DECISION**：`PASS_GT_SERPAPI_G4A_BOUNDED_DISCOVERY_AND_CACHE_AUDIT`，仅覆盖 G4A。
- **EVIDENCE_ORIGIN**：Owner 上传 ZIP；Reviewer 核验文件哈希、79 项 Manifest、脱敏查询记录与 9 组曲线计算；`PROVIDER_BILLING_READBACK=UNKNOWN`。
- **EXECUTION_ZIP_SHA256**：`63ab230f8b2268a042a4c5f9b55e1a0897010d65889135351a15f0805b59c618`；大小 138144 字节，80 个条目，79/79 Manifest 通过。
- **REVIEWER_ACCEPTANCE_ZIP_SHA256**：`41d1330aff15d1c60663e28e8843416e308189ccdbce5942457f6fb7b470beed`。
- **FACTS**：执行记录 8 次搜索；美国 30、英国 15 条最近7天热点，去重 41 个关键词；6 条重复周序列各 53 点（318）+ 3 条 G3 基线各 53 点（159），合计 477 点用于缓存审计。
- **CACHE_INTERPRETATION**：同一词的基线和两次重复请求显示相同 Provider Search ID、创建时间与全部 53 点。`CACHE_REUSE` 是审慎分类；Provider 没有直接提供 cache_hit=true，不能声称独立样本稳定。
- **OTHER_LIMITS**：周序列日期桶端点可能超出请求窗口且 partial 未知；45 条热点与长期需求、购买行为的关系未建立；精确 Secret 检查有 Executor 证据，但 Reviewer 未接触原始 API Key 作独立秘密值比对。
- **PERSISTENCE**：G4A Reviewer 接受 ZIP 在 Reviewer 环境生成、核验；Owner Windows 本机持久化和回读 `PENDING_OWNER_RELAY`。

## 保存规则

如后续发现更强新证据，应追加后续记录与 Reviewer 新决定，不回写抹掉上述执行事实。新 Gate、真实购买/计费或查询调用需要另行授权。
