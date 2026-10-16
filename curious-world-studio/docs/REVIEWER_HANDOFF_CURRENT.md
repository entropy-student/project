# CWS｜下一位Reviewer完整现行交接（2026-10-16）

> **Owner最新意思必须保真：**“我对精准的要求不高，匹配其实就行了”“只要相关就可以了”。前任Reviewer虽然口头同意，仍把爆米花“淀粉脚”研究实录当作不可逾越的素材Gate、重复增加搜索轮次，这是错误升级。**不要继续开展R6/R7精准科研画面调查；画面相关、听得懂、不冒充研究实录即可**。正确科学表述、来源可追溯、具体素材权利/公开发布许可仍要分别审查。

## 一、首读路径和职责

- 项目：`entropy-student/project` → `curious-world-studio/`。**首读[CURRENT_STATE](CURRENT_STATE.md)（唯一事实源）→ [CWS AGENTS](../AGENTS.md)→本文**；仅需特定细节再按链接回溯旧证据，别从历史报告的“下一轮”另开任务。
- Owner选择方向、素材是否达到审美、付款/删除/公开发表等授权；Windows Codex负责具体执行并提交脱敏ZIP+SHA；ChatGPT Reviewer负责独立核源、判断事实、内容和可用性的验收。不要要求Owner反复替你手动做技术看片验收。
- 本次用户要求整理文档并交给下一位Reviewer，**不代表已授权新一次素材搜索、编写新代码、真实制片或公开发布**。历史CW0005状态`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH`照实保留，只有新审核/Owner许可才可改变。

## 二、项目和技术各自走到哪里

| 层面 | 确认事实 | 仍不足 |
|---|---|---|
| 频道 | 不露脸，B站主、抖音/小红书辅助，跨领域“为什么”；频道名“世界有点意思”仅候选；观点/好奇心引导，知识小众、问题大众 | 未验证成片实际观众反应 |
| 选题 | [36条看板](../research/topic-bank/BOARD_V1.md)：11 shortlist、15 verify、9 hold、1 rejected；九源抽样定向搜索 | 非九源稳定全量抓取，SHORTLIST不等于拍摄批准 |
| 故事 | 三种机制“解释/追答案/重建选择”已做原型；CW-0005 R2-M1约50–60秒修订稿及S01–S10分镜 | 正式剧本、Story-Fit最终签收未通过，可按相关素材优化呈现 |
| 视觉 | [STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)：Mac Tiger Aqua短桌面→QuickTime全幅播放器，1920×1080/30fps/单行字幕；HTML和9秒无声工程样片 | 非长片音画字幕成品，渲染稳定性/配音对齐未通过 |
| 配音合成 | Remotion/FFmpeg媒体适配器[PR#116](https://github.com/entropy-student/project/pull/116)合并；OpenMontage Pexels/Pixabay、Qwen TTS `longzhe_v3.1`为已有工具偏好 | 完整正式旁白/字幕对齐、音乐混音、发布未做 |
| MEDIA-R1～R5 | 历史R2下载22视频+31图片；R3盘点300域、试197站、成功153但151属PeerTube实例；R4+R5另核10非PeerTube技术来源 | 不能把站点数算成153独立平台或可商用来源；R4+R5整体PARTIAL |
| G2–G4 | Windows Docker SearXNG+4get真实搜索→两不同PeerTube实例视频+一JPEG下载→FFmpeg QA→Owner Edge播放→容器停止；`G2_G3_G4_TECHNICAL_ACCEPT` | Reviewer没有亲自运行Owner的Windows/Edge，Ubuntu备份tar未亲自恢复 |
| PR#129/#131 | **均已合并main**；PR#131 squash commit `201c39a2b61eae7189cc624d5cb2c18dd671de38`，`cws_media.py`提供`doctor/discover/catalog/fetch/gallery`，按需Docker及Ctrl+C清理 | 上游部分搜索失败默认`PARTIAL_SEARCH/ok:false/exit1`，若仅部分候选足够须明确`--allow-partial`；非公网工具 |
| R6L/R7L试验 | 2026-10-16已结束；既有两段爆米花视频可有限匹配普通画面，95条搜索→90去重；Reviewer历史`PARTIAL_ASSET_GAP` | 5标题相关链接未播放，仅LINK_FOUND；无被核验的原研究高速视频；不能据此自动添加新的素材轮次 |

## 三、CW-0005研究事实、真实素材及“相关即可”的处理方式

- 一手：[2015 The physics of popcorn](https://pmc.ncbi.nlm.nih.gov/articles/PMC4345489/)。历史研究核证：温度实验170°C为17/50、180°C为48/50粒爆开，是统计并非单粒固定阈值；跳跃高速实验裂开/淀粉脚受压/反弹约6.9/13.8/20.7ms；声音另一个实验约100/106ms，部分声学机制是作者假说。**这些是科研实验相对时刻，不是库存视频的截取时码。** 事实细节见[2026-10-12历史交接§5](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)。
- 既有两段真实实拍：[Pexels #854959](https://www.pexels.com/video/cooking-popcorn-854959/) 20.223s/1920×1080，历史文件SHA `D5CACBD2A8158A8B26C3B4E18F43168533B0D7DDA25EC67DE37A39E864385C78`；[Pixabay #2793](https://pixabay.com/videos/id-2793/) 25.7267s/1920×1080，SHA `8C6ED307EF0FF4FC666EF169BE2CC410AD91DEC01B1F003C651B9E92D07E43D7`。Windows Codex历史下载并FFmpeg解码，本轮核SHA/抽6张帧；MP4位于本机忽略目录`.local/R2-M1/provider-output/`。两项具体使用权`PARTIAL`，音轨未审/未用。**可作锅内、未爆粒、爆后氛围等辅助画面候选，不是研究实录**。
- R6L/R7L一轮95搜索结果去重90，5个科研链接仅`LINK_FOUND`。2015原论文Movie S1/S2没有实看+单文件许可；精确“淀粉脚受压反弹”研究实录仍缺，但**用户并不要求必须播放这一镜头才讲科学机制**。可以让旁白负责解释，用相关普通视频和来源文字支撑；只要不误导观众说“眼前就是论文实验画面”。
- **过去不合理的Gate已经修正为编辑偏好**：不建帧级匹配模型，不给每句配精确秒数，不再寻找80站点，不拿`PARTIAL_ASSET_GAP`当追加搜索许可；如果某一镜头表达与画面矛盾，就改镜头承诺/文案或删短，不以精确实录作为自动硬条件。素材是否可复用仍需实际使用时核权利。

## 四、历轮证据索引，防止漏数/误报

- R2-M1：`CWS_MAIN_R2_M1_MEDIA_PATH_STORY_VISUAL_REVISION_20261012.zip` SHA256 `84991ca226e060624eaf7a4ca7c5ade411f8f5f70ab17ee94899e2b0e44b805f`；约50–60秒脚本+S01–S10，2条OpenMontage MP4本机下载解码，历史ZIP仅六帧非MP4全片。旧R1/R2各包SHA和其他选题（CW-0002大象、CW-0004意面、CW-0008指纹）见[原2026-10-12完整交接](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)，Owner曾明确不自动换题。
- Windows G2–G4：`CWS_MEDIA_G2_G3_G4_DOCKER_LOCAL_20261015.zip` SHA256 `651651f7e21cba1428c0cfac30b09fdc814cc31586b63d278eee9d14a551d875`；Reviewer核50SHA/49manifest；Docker搜四类非空、316原始记录→77视频/135图片候选；两不同PeerTube实例并非不同平台家族。
- PR131最终实机：`CWS_MEDIA_PR131_FINAL_RUNTIME_VERIFY_20261015.zip` SHA256 `8881c72b8b9823978080feace136c4dafceee1db6f1731d8867830f046922d30`；Reviewer核23SHA/22manifest；SearXNG 88视频110图片，4get 15视频81图片，190去重候选；真实PTY Ctrl+C，三CWS容器exit(0)、18080/15050释放、无关容器不动。Windows60/60单测为执行端提供的报告。
- R6L/R7L：`CWS_MEDIA_R6L_R7L_FAST_MATCH_PILOT_20261016.zip` SHA256 `81591798ede2c838bbc8cc31c8b5fb22edbd5f497d90e7142cfcae141e78c4f8`；Reviewer核CRC、20/20内部SHA、19manifest、六张1920×1080 JPEG与HTML嵌入。两原MP4**不在包内**，Reviewer未重解码全片；搜索+容器清理28.2秒、QA抽帧3.8秒不含完整人工审阅时间。
- Mac窗口动效/视频工程支线与旧清理审计均是单独历史：MW07 Genie与MW11–13已有人提出KEEP候选但**不能推导Owner最终视觉签收**；9秒/M2技术片亦非成片。其他SHA和状态在[旧交接§7](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)；无需重跑或复制大证据进Git。

## 五、推荐最短路线（**未授权实际制作**）

**只建议下一步一次编辑动作，而不是另一轮素材调查：**拿既有50–60秒条件剧本和S01–S10，删去“必须看到淀粉脚实验”的镜头约束，整理成一句旁白对应一个足够相关实拍/必要出处文字的简短清单。尽量使用已知2条爆米花片，内容不宜硬凑；把尚需校验的真实复用权标`PARTIAL`。Reviewer先判断脚本准确、画面不会误导，再给Owner确认方向。

如Owner明确授权素材使用与制片，Codex可用已有OpenMontage/Remotion/Qwen TTS制作**仅内部观看**30–60秒音画单字幕样片，经真实QA后逐步组织完整自然时长草片；**发布、收费、版权审批须独立授权**。保留旧CW0005 HOLD直至正式内容审查与Owner决定，不自动解除。也不要为了“完成R1–R4几轮”把一个简明工作拆成更多重复任务。

## 六、执行保全、安全和规范

- [正式3+1素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)：①原论文/研究机构；②OpenMontage Pexels/Pixabay；③合法源站yt-dlp（不是内容库）。轻动效只有**2转场/4画面布局/6信息字幕**；默认真横屏（显示比例≥4:3、优先16:9/1080p），排除大陆视频平台。严禁生成AI假实验/图、用代码画真实实体、PPT大拼图代实拍、循环重复镜头凑时长。
- **相关即可不等于虚构**：可用Stock相关素材+准确旁白讲研究；不能标成第一手实验、把库存音轨当科研实录、用未真实出现的动作做科学录像演示。独立记录`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`。视频下载、解码成功≠已确认复用权。
- **运行**：Windows11本机Docker Desktop/WSL2，SearXNG+4get端口只绑回环、用后停止；内存保护门槛历史为1664MiB，实际再测。无需VPS、不干预VPN/Clash/全局代理、WordPress/Woo/别的Docker项目。Ubuntu24.04已安全备份注销，tar Owner本地留存。
- **保全**：历史3项tracked未提交改动+2未追踪缓存、旧媒体/ZIP/Ubuntu tar不覆盖；禁止`git reset --hard`、`git clean`、`docker system prune`、`down -v`、擅清旧目录。未来源码修改需最新main隔离分支→独立Reviewer→经授权合并。日志/原片不传main。
- 技术测试优先Codex隔离浏览器，不附着Owner私人Edge；Reviewer明确标注自己独立验证与Codex执行端报告的区别。Owner只在内容审美/法律权利/发布等关键判断介入，不再承受技术验收轮次。

## 七、有效文档读取清单

1. **[CURRENT_STATE](CURRENT_STATE.md)**：唯一最新项目状态、规划和最新Owner偏好。
2. **[CWS AGENTS](../AGENTS.md)**：角色/守护边界/运行要求。
3. **[3+1正式素材合同](VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)**与**[视觉锁](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)**：真实素材、有限动效和窗口规范。
4. **[MEDIA架构/R1–R5旧结果](MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)**及**[已合并统一CLI](../media-pipeline/README.md)**：工具已足够，不重复执行PR#129/#131或G2–G4。
5. **[2026-10-12历史完整科学/脚本/MP4证据](REVIEWER_HANDOFF_2026-10-12_POST_R2M1_PAUSED.md)**、**[2026-10-15 R6L/R7L已完成试跑合同](MEDIA_R6L_R7L_FAST_MATCH_PILOT_2026-10-15.md)**、**[正式制片四轮泳道](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)**：历史事实保留，但旧“下一步必须搜科研实录/做R3”不再代表授权。

**向Owner交接的一句话**：现有素材工具已正式合并且足够，普通爆米花视频能支持相关画面；接下来应按“画面相关、讲述真实”的原则直接做好第一条内容的脚本与镜头设计，而不是继续搞精确视频识别或再搜一轮；正式Gate暂维持，等待Owner决定下一项执行。
