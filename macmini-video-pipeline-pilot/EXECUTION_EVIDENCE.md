# EXECUTION_EVIDENCE — Mac mini Video Pipeline Pilot

> 证据记录与历史执行事实，不承担当前状态裁决；唯一当前状态是 [REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)。  
> Gate G0 / 2026-10-28 / first entry

## AUTHORIZE_AND_PREFLIGHT

- `AUTHORIZED_GATE`：G0_PROJECT_INIT，Owner 已明确要求独立立项、唯一交接，复用 VPS 项目管理规范。
- `REPOSITORY`：`entropy-student/project`，默认分支 `main`；通过 GitHub 连接直接回读，账号对该仓库 `push/admin=true`。
- `GOVERNANCE`：`entropy-student/spike.skill/vps-project-governance/SKILL.md` 明确 v0.2.7；规范正文为 `VNEXT.md`；检查通用条款与 11 类专项触发器，本轮纯文档、不命中 VPS 运行、秘密、部署、Provider、自动化、Closeout、Codex 生图专项。
- `TARGET`：仅新目录 `macmini-video-pipeline-pilot/**` 与仓库根 README 的导航一行；新目录在 main 分支上不存在；未找到同名新项目分支。
- `REFERENCES`：`ai-story-showrunner/`、`visual-narrative-animation-lab/` 供概念参照；现有独立 Mac mini 文章候选 PR #174 与本项目隔离。
- `INPUT`：Owner 提供的 v0.1 草案以及本次讨论形成的 `WRITING_STANDARD_DRAFT_v0.2.md`；v0.2 为待验证方法，不是实际通过验收的流程。

## CHANGES_AND_RESULTS

- `ACTUAL_CHANGES`：创建分支/目录/README/唯一 Handoff/本 Evidence/写作 v0.2 候选参考；根 README 新增导航。最终 GitHub PR 与 read-back 见后续记录。
- `RESULT`：`PASS` 直到 Reviewer 完成 PR + 文件实际回读；不等于 PASS。
- `VALIDATION`：本 Gate 仅验证文档与仓库变更，不进行作品研究、设备测试、文案交付、视频生成和发布。
- `ANOMALIES`：无已知仓库污染；视频工具/素材状态仍为 UNKNOWN。
- `ROLLBACK`：关闭未合并 PR / 删除本次分支；主分支及其他项目无改变。
- `RESOURCE_OR_BUSINESS_DELTA`：无部署、支付、采购和公开发布；仅 Git 文档文件。

## G0 REVIEWER READ-BACK / 2026-10-28

- `PR`：https://github.com/entropy-student/project/pull/176，Draft；未合并。
- `CHANGED_PATHS`：`README.md`, `macmini-video-pipeline-pilot/EXECUTION_EVIDENCE.md`, `macmini-video-pipeline-pilot/README.md`, `macmini-video-pipeline-pilot/REVIEWER_HANDOFF.md`, `macmini-video-pipeline-pilot/docs/WRITING_STANDARD_DRAFT_v0.2.md`。
- `READBACK`：Handoff 已读取、候选写作规范 v0.2 文件与上传草案逐字一致、根导航链接存在。
- `REVIEWER_DECISION`：`PASS_G0_PROJECT_INIT`；此 PASS 只涵盖项目建档和隔离范围，不涵盖研究、文案或视频。
- `NEXT`：G1_CONTENT_DISCOVERY，后续执行必须先核对当前 Gate/新的证据；本轮强制停止。

## G1 CONTENT DISCOVERY / 2026-10-28

- `AUTHORIZED_GATE`：G1_CONTENT_DISCOVERY。Owner 上轮「继续下一步」；当前 Handoff 标明 G1。
- `PREFLIGHT_FACTS`：GitHub 直接读取 v0.2.7 / VNEXT 通用条款、11 专项触发器扫描；G1 纯公开研究及项目 Markdown 修改，无服务器/Secret/部署/浏览器登录/生图/付费/删除/外部发布专项命中。直接读取本分支唯一 Handoff、历史 Evidence、v0.2 写作规范；确认 G1 待执行。
- `DATA_PROVENANCE`：Apple 中国 2024/2026 新闻稿、苹果官网商品和功耗支持、TrendForce 2026-09-30 新闻稿、Cloudflare/Docker 官方文档；Tom's Hardware/Ars/WIRED/Macworld 独立评论；六条 B站视频页面与四条 Reddit 讨论（sample only）。所有使用过的网址与关键声明在 G1 文档第 1/2/9 节逐项记录。
- `ACTUAL_CHANGES`：新增 `macmini-video-pipeline-pilot/docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md` 研究与编辑决策；Reviewer 更新 `REVIEWER_HANDOFF.md` 为 G1 PASS/G2 NEXT，并在本 Evidence 追加事实。
- `VALIDATION`：6999 与 4499 出自两个 Apple 官方不同年份上市信息；价差 2500/+55.6% 为简单计算；Apple 报告 M6 特定配置闲置 4W；代表样本对涨价、AI服务器/替代做过覆盖，但不推断全站偏好。
- `ANOMALIES_AND_LIMITATIONS`：中文 B站评论逐条采样、二手国内实际成交价/统一的 VPS 档位与生命周期对比、用户实机/流媒体访问稳定性尚不可核实；报告显式 UNKNOWN，G2 禁止填假数据或购买经历。
- `EDITORIAL_RESULT`：主发现 F2（拆分工作站 / 本地 AI Agent / 公网网站任务）；F1 涨价作开场、F3 低功耗与公网可靠性区别作反转；传统实机评测因无设备不选。
- `REVIEWER_DECISION`：`PASS_G1_CONTENT_DISCOVERY`，仅认定所列**有界证据**足够支撑研究型消费调查的 G2 写作，不代表受众数据完整、当前二手价实测或视频已完成。
- `ROLLBACK_EFFECT`：只在独立未合并分支添加/修改项目 Markdown；可 Git revert/关闭 Draft PR，无主分支或外部系统变化。
- `OWNER_ACTION_REQUIRED`：NONE；未购买设备、未生成媒体、未发布。
- `REVIEW_LINKS`：G1 报告与唯一 Handoff 均需 GitHub 读回，实际回读结果附后。

### G1 Reviewer durable read-back / 2026-10-28

- `OBJECTIVE_READBACK`：直接在当前项目分支取回 `docs/G1_RESEARCH_AND_EDITORIAL_DECISION.md` 全文与新提交内容一致；取回唯一 `REVIEWER_HANDOFF.md` 全文与新提交内容一致；Evidence 含本轮接受结果。
- `SCOPE_READBACK`：Draft PR #176 变更路径仅仓库根 `README.md` 与 `macmini-video-pipeline-pilot/**`，无其他项目改动。
- `FINAL_GATE`：`PASS_G1_CONTENT_DISCOVERY`，新 Gate 为 `G2_NARRATIVE_AND_SCRIPT`。研究结论属于有限证据之下的编辑判断，不是实机测试或市场代表性证明。

## G2 NARRATIVE + COMPLETE VOICEOVER / 2026-10-28

- `AUTHORIZED_GATE`：G2_NARRATIVE_AND_SCRIPT。Owner 已指示继续下一步，唯一 Handoff 原 Gate 为 G2。
- `PREFLIGHT_FACTS`：从 GitHub 读取本分支当前 Handoff、G1 报告、v0.2 候选写作规范与现行 VPS Governance 通用段落并扫描 11A–G；本 Gate 仅创作文本/修改项目 Markdown，不触发主机部署、Secret、付费、浏览器登录、删除、Codex 生图专项。
- `FACT_RECHECK`：2026-10-28 重新核对 Apple 中国 2024-10-29 M4 历史发布起价 ¥4,499；Apple 中国 2026-08-25 M6 发布起价 ¥6,999；Apple 支持功耗表 M6 16/256 闲置 4W；Cloudflare Pages Free 静态网站部署/限制。可访问官方源及 G2 文末精确链接；没有拿二手价/实机数据冒充事实。
- `ACTUAL_CHANGES`：新增 `docs/G2_NARRATIVE_AND_SCRIPT.md`：七段完整中文口播、内容决策卡、语义节拍表、可核对事实表、证据限制和 G3 需补之处；更新唯一 Handoff 为 G2 PASS / G3 NEXT。
- `OBJECTIVE_READBACK`：GitHub 直接取回 G2 文本与创建内容一致；Handoff/Evidence 最终写回后另回读。
- `CONTENT_REVIEW`：文本涵盖价格事实与不同世代边界、现有电脑/本地 AI/公网网站三种不同需求、4W“闲置非负载”的限制、最强反方（macOS、本地数据/本地模型等）、适用条件与非亲测身份。没有虚构已购、开箱、长期使用、跑分或模拟家庭故障。七段在逻辑上互相推进；仍须通过后续音画测试验证真实观看节奏。
- `REVIEWER_DECISION`：`PASS_G2_NARRATIVE_AND_SCRIPT`：**仅在文字、叙事逻辑与所列证据范围内通过**，不等于已试听、素材权益合格或已完成视频。
- `ANOMALIES`：本人最终口吻/具体场景是否符合 Owner 的真实体验待 G3/G4 核对；本地设备、素材、剪辑器、配音与真实时长 UNKNOWN；无当前二手/主机/云的同用途实时价，因此避免定量 TCO 结论。
- `ROLLBACK_EFFECT`：文档只落在 Draft PR #176 的独立项目目录；可 Git revert，未触及主分支、服务器、真实用户数据、硬件采购或对外发布。
- `RESOURCE_OR_BUSINESS_DELTA`：NONE。
- `OWNER_ACTION_REQUIRED`：NONE。
- `REVIEW_LINK`：https://github.com/entropy-student/project/blob/project/macmini-video-pipeline-pilot-20261028/macmini-video-pipeline-pilot/docs/G2_NARRATIVE_AND_SCRIPT.md
