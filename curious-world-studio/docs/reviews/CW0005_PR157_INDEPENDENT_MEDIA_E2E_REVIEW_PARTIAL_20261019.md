# CWS｜PR #157 独立Reviewer｜MEDIA E2E Canary（2026-10-19）

> **结论：`PARTIAL_SAFE_ADDRESS_GUARD / RIGHTS_UNKNOWN`，`END_TO_END_MEDIA_CANARY_NOT_PASS`。** 单个新增负例测试`PASS_SCOPED_REGRESSION`，不等于整个素材来源→预览→许可→下载→FFmpeg QA的链路PASS。原PR#155历史`RETURN_PROCESS_COMPLIANCE`、PR#156 `PARTIAL_SEARCH`、`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`保持。

## 证据身份和独立复核范围

- Owner实际上传的`CWS_MEDIA_END_TO_END_BLOCKER_REPAIR_REAL_ASSET_CANARY_20261019.zip`，Reviewer重新计算实际SHA-256：`48cf3d7fd01a8be4bb20e9f29a872fd373ab4b6c5ee1552d4c223597c842721f`，实际44,209字节，29个ZIP成员、`SHA256SUMS.txt`的28/28条文件内容SHA一致；无ZIP路径穿越；证据是Owner本轮真实文件，不是Codex摘要。
- [PR#157](https://github.com/entropy-student/project/pull/157) Head `db044a53ac4222ffc73b47e5cbdaaa89b53c4c72`，仅改`curious-world-studio/media-pipeline/tests/test_integration.py` **新增8行**，没有修改产品媒体管线、冻结模板、视频或图片；[本PR独立审阅](https://github.com/entropy-student/project/pull/157#pullrequestreview-5570696884)已COMMENT，不擅自合并或发布。
- 直接读取GitHub `main`现行`media_pipeline.py`：`_validate_public_url`对`getaddrinfo`结果采用`any(not is_global)`，若含任一私有/保留地址即报`NON_PUBLIC_MEDIA_ADDRESS`。PR新测试Mock `198.18.0.1` + `93.184.216.34`，期待ValueError是准确的防护负例；`198.18.0.0/15`是测试/基准用途保留网段，不可视为可安全外部连接的公网IP。**测试验证安全拒绝，不解决Fake-IP模式下的合法网站下载通路。**
- ZIP包含baseline 60项与分支61项测试全部OK及单测1项OK的命令输出，Reviewer核了对应PR测试代码及防护源码；**未在Owner Windows本机重新执行61个测试/获取DNS原始解析或浏览器画面**。汇报运行环境状态只能标为`EXECUTOR_EVIDENCED`而非`REVIEWER_LIVE_REPRODUCED`。

## 数量与阶段完整性（Reviewer从ZIP CSV逐项重算）

| 量化项目 | 直接计算结果 | 适用边界 |
|---|---:|---|
| 两个S01查询，六个聚合器×媒体类型行 | 6 | `S01A`视频/图片，`S01B`视频 |
| 原始provider结果 | 414 | SearXNG 81+136+77=294；4get 5+98+17=120 |
| 候选目录去重后 | 274 | 274不同catalog ID、274标准化URL/页面身份 |
| 视频 / 图片 | 146 / 128 | 不是横屏/1080p/权利已确认的真实资产 |
| 与PR#156历史候选身份重合 | 54 | 与旧87目录重合；不代表跨站原创作品判重完毕 |
| 本轮新页面身份 | 220 | 目录候选增加；不代表220条真实新素材 |
| 来源网站主机 | 55 | 不是55个独立来源平台家族，也不是55个持许可证站点 |
| 上游搜索状态 | SearXNG 3×`UPSTREAM_PARTIAL`；4get 3×`OK` | HTTP200/有结果不等于聚合器完全健康 |
| 真实视频完整动作与时码核验 | 0 | 仅1个YouTube页面被部分观察；时间码不可靠，未提供实际可复验视频帧 |
| 本轮图片打开核验 | 0 | 图片标题/缩略图不算已审画面 |
| 逐件合法复用权验收 | 0/274 | 274行`rights_status=UNKNOWN` |
| 实际下载、FFprobe/FFmpeg/SHA | 0/`NOT_RUN` | 合理停线，但非素材E2E PASS |

`candidate_inventory.csv`全部274行的`query_provenance=AGGREGATE_ONLY_NOT_EXPOSED`，所以只能确认来自此轮六个查询子行的总集合，**不能独立把每条具体候选映射回唯一query语义**。54条`historical_url_overlap.csv`与主目录标志的canonical identity集合精确相等；55个站点的`provider_summary.csv`计数合计274。标准化URL唯一性不等于版权或视频的独立原作品唯一性。

## 阻塞根因分离

1. **资源/代码（本轮改善）**：`diagnostics.json`报告内存`2397 / 3110 / 1997MiB`，实测值均超过保持不变的`1664MiB`门槛；`main`及旧/隔离工作树的`media_pipeline.py`blob报为`0204d11569ca64de7ca31c55975859f95c9eaa32`，`cws_media.py`报为`0eafb5b601956286968f99a2c25d01488ea04e2f`，没有再提交临时harness。故`LOW_MEMORY`本轮未复发、历史源码不一致已被重新核对，**但不能断言未来所有进程均无内存风险**。
2. **网络地址/代理**：四个测试域名的本机DNS集合被分类为`PRIVATE`/ `RESERVED_FAKE_IP`，从当前校验器调用前止步符合安全设计；`mihomo_tunnel_adapter=UP`、系统代理开关off、另一个Clash监听器HTTP CONNECT与SOCKS5协议检测通过，是执行方脱敏记录。**没有原始DNS多域逐跳/实际代理出口的安全终点证明**。不应关闭`_validate_public_url`、给YouTube泛域名放行、用DoH一条公网答案代替连接审计，或修改全局代理与TUN设置。该Canary **网络访问路径未修复**。
3. **真正内容/权限**：唯一浏览器页面YouTube `FSZd33awqQk`，描述见`CONTENT_PREVIEW_RIGHTS.md`；Executor观察部分动作但播放时码不可靠、研究来源和视频30,000fps的真实含义不能证明；权利`UNKNOWN`，故不能把该YouTube片用作新素材。其他273页未真正实看。**即便修复网络，274条还缺逐件权利判定与实际画面**。
4. **执行记录和可复用性**：`reports/`、`tables/`分层证据真实，但绝大多数还是宽泛网页索引，缺query→候选分配、可信原媒体提供方筛选/作者+许可、实际下载格式ID/源hash、实际视频QA。源站候选多并不能代替渠道质量。

## 最小Reviewer建议（下一轮尚未授权）

- **停止“再多搜几百个链接”的做法**。拿已有274候选和真正经过许可的提供方能力做**Licensed-provider-first**的一次小样本。先查OpenMontage现有Pexels/Pixabay官方适配器及可核对原站许可证的科研/开放视频；不安装新工具、不为满足指标再搜80网站。
- 选择一个未被项目历史使用、来源明确、实际预览能展示S01相关爆裂/起跳、许可清晰的横屏视频；**先验证其可下载性/权限/媒体端点安全，再尝试一次有限下载**，不得因旧YouTube页面有播放就自动推定合法素材。
- DNS/Fake-IP必须走**有真实出口与跳转/分段URL逐跳公有目的地校验**的可信受支持路径；只证明“HTTP代理协议可连接”不证明实际代理出口对任意素材URL安全。如现成提供方SDK/既有受控路径没有等价保护，则保持`PARTIAL_SAFE_ADDRESS_GUARD`，只做metadata/画面预览不下文件。绝对不建议泛域白名单/禁私网守卫。
- Reviewer在完成一个**安全、可复用的真正媒体获取Canary**后才可以对今后视频素材流程提出PASS，而不追溯宣布PR#155历史执行已合规。先前59.933秒MP4技术PASS及6模板冻结不重新测。

## PR和下一状态

`PR#157`当前仍**Open，未合并**；仅新增一个安全负例测试且经代码审阅可接受，**是否合并这个测试应与素材Canary的完整PASS分开裁决**。该PR的基线比Review时新`main`落后13提交，`mergeable=true`，如之后要合并，应新核冲突/HEAD及CI，不能把合并解释成媒体下载通路已修复。

本轮建议归档`PARTIAL_SAFE_ADDRESS_GUARD / RIGHTS_UNKNOWN`，设置`CURRENT_GATE=NONE / REVIEWER_COMPLETE / NEXT_GATE_NOT_DISPATCHED`；保存全部历史ZIP/台账，旧PR#155保持原流程RETURN，后续只签发一次真正聚焦**合法原提供方＋安全下载**的有界Gate。