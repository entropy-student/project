# CWS｜PR #156 素材来源追溯和多平台Canary独立Review（2026-10-18）

> **正式结果：`PARTIAL_SEARCH`；证据归档范围`PASS_EVIDENCE_INTEGRITY`；真实素材获取闭环`NOT_PASS`。** 对历史[PR#155](CW0005_PR155_MEDIA_PROCESS_AND_VISUAL_INDEPENDENT_REVIEW_RETURN_2026-10-18.md)的`RETURN_PROCESS_COMPLIANCE`不追溯翻案，`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / RIGHTS_PARTIAL / NO_PUBLISH / VOICE_BY_EAR_UNVERIFIED`保留。

## 1. 对象与不可混淆的证据边界

- [Owner交付PR#156](https://github.com/entropy-student/project/pull/156)原HEAD `d01a18f2b8565966546b65a327119ca63ea8fda9`，仅新增九项脱敏文档，没有代码、声轨、视频或现有六模板改动；[独立PR Review](https://github.com/entropy-student/project/pull/156#pullrequestreview-5563457317)事件为`COMMENT`，未将该PR判为完整功能PASS。
- Owner当轮上传的真实ZIP `CWS_CW0005_MEDIA_PROVENANCE_BOUNDED_MULTISOURCE_VALIDATION_20261018_PR156_FINAL5.zip`，SHA256实际重算`d1fbe31b2499d3711ffeda2fed6a1b6791f9693323fe3517cc28b6e9f58bff3c`；48,619 bytes、35个成员，`SHA256SUMS.txt`34项均逐件SHA256匹配，ZIP解压完整。Reviewer逐件计算`github-pr/`九份文件的Git Blob SHA-1，**9/9与PR#156 GitHub真实文件blob相等**（不是仅对比名字/日志）。ZIP raw reports、候选清单和真正CLI结果之间的统计也做独立交叉核对。
- 这轮Owner Windows运行环境/网络实际行为仍主要是Executor记录；Reviewer直接证据是ZIP原字节、GitHub变更/规范与工具静态源码，不冒充Reviewer在Owner Windows实际重跑Docker、请求DNS、搜索或播放。

## 2. 可接受的事实/统计

| 项目 | 直接核对与判断 |
|---|---|
| 唯一派发的S01-A搜索 | `popcorn kernels popping and jumping in a pan slow motion`；实际CLI `PARTIAL_SEARCH`、return ok=false |
| 两引擎原始记录 | SearXNG 84条（brave.videos、google videos上游报错，`UPSTREAM_PARTIAL`）；4get 11条（`OK`）；合计95条搜索记录 |
| 去重 | SearXNG独有76＋4get独有3＋两引擎共有8＝87条URL唯一页面；候选库存87行实算成立 |
| 平台统计 | **14个网页host，不等于14个独立合法可复用素材网站**；YouTube 62、Dailymotion 10、PeerTube实例5、其余10；候选主要为分享/视频平台，Pexels/Pixabay本轮未新发现 |
| 第二个语义S01-B | 现有内存门槛`1664MiB`，两次本机分别只有`685MiB/794MiB`，均先于上游请求被`LOW_MEMORY`拒绝；需停止重复尝试 |
| 探测与实际画面 | 4条候选原格式`NOT_VERIFIED`；PeerTube公开API宣称53s、16:9、1920×1080@30fps，**并非已下载或实际播放帧**；YouTube浏览器超时、Dailymotion不可播放、PeerTube未点击播放；`CONTENT_PREVIEW_VERIFIED=0` |
| 下载/版权 | `DOWNLOADED=0 / FULL_DECODE=NOT_RUN / REUSE_RIGHTS_VERIFIED=0`；由于无合法且实看合适的新源，**0下载为正确停线**；0素材作品级判重，不能称87作品唯一 |
| PR#155旧历史 | 未保存真正SearXNG/4get查询、内容比选与下载网络完整轨迹，仍`HISTORICAL_UNKNOWN`；先前10/15候选缓存85条与本次87 URL有4条**页面URL**完全重叠，不能据此宣称作品身份已完成跨站去重 |
| 资源清理 | 本次CWS Compose运行及仅CWS项目容器停止/本轮18080、15050端口释放属Executor有界证据；**Docker Desktop本身仍运行**，需要区别全局应用/后台引擎和本项目容器，不可擅停Owner其它Docker依赖 |
| 本地缓存 | 2个未跟踪`.pyc`未入PR/ZIP，因安全策略阻止删除而保留；不为工作树“漂亮”绕过安全或擅自清除 |

重要细节：`evidence/raw_sanitized/search/catalog-after-S01A.json`的index query event错误地将SearXNG汇总标为`OK`，而原命令封装器`discover-S01A-video.json`真实是`UPSTREAM_PARTIAL`，应当**以调用 envelope + 上游errors为当前执行结果权威**；旧index event保留作原始历史不静默篡改。

## 3. 必须保留的三个独立诊断问题

1. **地址验证`NON_PUBLIC_MEDIA_ADDRESS`属于安全门槛而非应被绕开的报错**。`media-pipeline/media_pipeline.py`现行main`_validate_public_url`使用`socket.getaddrinfo`检查目标域解析地址，若含非global IP就拒绝yt-dlp调用；按设计这样做是为避免私网探测/下载。但本ZIP最底层`probe-four-candidates.jsonl`实际只保留`FAILED ValueError`及候选ID，没保留每个异常的**精确安全错误code/DNS解析类型/是否代理或TUN Fake-IP导致**。正式`NON_PUBLIC_MEDIA_ADDRESS`只是Executor在CSV/记录中作的错误归类，Reviewer静态源码能确认这种故障可能且会被拒，**不能据原始ZIP证明四个站点真实IP均私有**。需要零副作用的受限DNS+错误码诊断；绝不可关闭守卫/对YouTube或PeerTube泛域名白名单直放。
2. **资源阈值不应降低**。Docker Desktop启动后的`doctor`本机1705MiB可用，只比1664MiB安全线多41MiB；第一次完成后本机不足800MiB，属于真实资源余量风险。Docker Desktop此前未启动、Executor报告依Owner本机请求手动打开既有应用，这**不等于**CWS CLI能够自动启动全局Docker Desktop；CWS CLI只管理自己的Compose。启动权限归属由执行者报告，本Reviewer未在此对话独立读取那条Owner→Executor授权。以后必须明确3层状态`Desktop engine / CWS Compose / temporary ports`，不必改造成自动启动全局Docker的功能。
3. **混用本机源与main helper的可重复性不足**。执行方明确本机导入的`media_pipeline.py`与main不一致，用本地一次性harness注入main`media_pipeline.py`、`media_filter.py`完成测试，却未在ZIP留下可独立复验的完整harness代码/哈希与CLI命令。CLI、Compose Git Blob可核，但**这次Canary并不能证明“标准本机CWS源码原样就能执行同一网络流程”**；需在以后下一轮只读分类版本漂移/环境，而非悄悄修改正式src或扩大替换架构。

### 结果解释防误导

`catalog_status=ELIGIBLE`及`queue_status=ALLOW_BOUNDED_FORMAT_PROBE`只代表**搜索URL通过粗筛、允许下一步受限格式探测**，87条全部`display_* = UNKNOWN`；其中包括短视频/可能竖屏/TikTok等内容，尚未核横屏或License。任何用户可读报告不得说“已拿到87条合格视频”或“14个平台内容都可用”。七层应依次分开：95搜索记录→87去重URL→原作品判重未做→可用格式未证明→实看0→下载及解码0→许可0。

## 4. Reviewer裁决、治理和最小下一步

**通过的证据范围**：`PASS_ZIP_MANIFEST_AND_PR_9_OF_9 / PASS_COUNTS_95_87_8 / PASS_SAFE_LOW_MEMORY_AND_ADDRESS_STOP / PASS_ZERO_UNAUTHORIZED_DOWNLOAD`。

**未通过的流程范围**：`PARTIAL_SEARCH_UPSTREAM / SECOND_SEMANTIC_NOT_RUN / ORIGINAL_WORK_DEDUP_NOT_RUN / FORMAT_PROBE_NOT_VERIFIED / CONTENT_PREVIEW_ZERO / RIGHTS_ZERO / DOWNLOAD_NOT_RUN / FULL_CANARY_NOT_PASS`。

**最终正式结论：`PARTIAL_SEARCH`**。不得用`PASS_MEDIA_DISCOVERY_PROCESS_CANARY`或`PR#155_SEARCH_PROCESS_PASS`替代。**允许将本次PR#156九份真实执行记录作为“失败/部分成功的审计证据”单独squash merge进main**；Reviewer已完成符合性核对，此合并不等于启用新功能、视频生产或发布权限。实际合并为`890d52b1c5b767bffa6677eeffafe8be96de5cbb`。

**下轮最小修复路径（建议，不构成本报告内自动执行授权）**：一次**只读诊断**，用现有Windows运行时分别确认`getaddrinfo`给出的解析地址类别/代理Fake-IP情况、`NON_PUBLIC_MEDIA_ADDRESS`异常真实原code、CLI实际导入源码与harness指纹、Desktop与Compose资源占用；不启动Docker、不下载/搜索、不删`.pyc`。只有确定安全且有用的合法素材入口后，才安排下一次有界真实操作；**优先已有OpenMontage Pexels/Pixabay及可复用库存，减少Docker重启和社交媒体“有链接无版权”的大列表**。历史PR#155流程RETURN、CW0005内容/权利/发布HOLD不变。
