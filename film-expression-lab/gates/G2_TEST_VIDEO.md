# G2 单段影视测试

GATE_ID: FEL-G2-TEST-001
STATUS: CANDIDATE，Owner 提供可访问片源及本轮有界执行授权、Reviewer 核对前置事实后才激活。
OBJECTIVE: 从一段用户片源制作有证据、有中文旁白、能正常播放的合格测试视频。
CURRENT_FORMAT: Owner本轮纠正为顺序展开的陪伴式拉片。保留所选分析场景完整原速播放，在有意义的位置暂停/回看后继续；取消90至180秒目标，不大幅裁片做短影评。新品牌未确认，不用旧版名称/灰色图标。
MAX_ENDPOINT_THIS_ROUND: 一个 episode 的本地视频和审阅包，最多到 PASS_CANDIDATE；不自动进入完整一期或交互网站。
MANDATORY_REVIEW_STOP: 提交 completion.md 与实际媒体证据后停止，Reviewer 决定 PASS/RETURN。
TARGET_AND_SCOPE: 源文件只读；项目 episodes/<唯一run-id>/；项目已有 scripts；固定 HyperFrames npm 缓存。不得写其他项目、OpenMontage、用户技能或全局网络配置。
APPLICABLE_CRITICAL_CONSTRAINTS: Human Writing 强制调用；片源不能公开上传；原片/片段/成片三时钟；不得编造导演意图；TTS 不重试或换路由；不导出 Secret。

## 接受的事实与前置条件

已接受频道定位、内容方法与观众，不询问首片/首发平台/风格。默认方案由 RUNBOOK 定义，用户新指令优先。既有模型/音色为 qwen-audio-3.1-tts-flash / longzhe_v3.1 / zh，北京；配置存在但服务/权限/额度未实测。CLI HyperFrames 0.8.186 已完成版本运行，实际视频渲染未验收。

PREFLIGHT:
1. 确认输入可读且是明确指定素材；ffprobe、SHA256、片段版本；输出目录唯一，不覆盖旧 run。
2. 确认与本机相同的用户/路径、Python/FFmpeg/Node 和已核验 CLI 可用。只读取 gate、RUNBOOK、TOOLCHAIN 及本任务涉及源码/技能。
   当前 doctor 报告可用内存偏低。渲染强制 `--low-memory-mode`，先用同一项目做 3 至 5 秒小段试渲染；退出码和 doctor JSON 都要检查，不把 exit=0 当作全部通过。不擅自关闭其他程序，也不静默降低分辨率或换框架。
3. 使用项目适配脚本 scripts/bailian_voice.py，不使用旧入口的凭据环境变量或签名 URL recovery 文件。离线合同测试必须通过；顺序调用，禁止并行和自动重试。
4. 真实生成必须有本次 Owner 的明确调用授权。建议上限最多 4 次、总计 1200 字、单次不超过 600 字、总费用不超过人民币 1 元；这是待 Owner 随执行提示词授权的边界，并非本轮已获付费授权。
5. 发起前核验当前确切模型价格/免费额度及账户/地域适用性，保存非秘密依据。不能用同系列其他模型价格替代；未知则 RETURN_TTS_AUTH_OR_QUOTA，不能私自生成或换成本地声音。
6. 将授权消息来源、价格/额度来源、approved/provider/model/voice/max_calls/max_characters 写入本 run approval.json。不得编造 Owner 批准。脚本只核验字段和数量，价格证据的正确性仍由 Reviewer/Executor 核对。
7. 学术搜索有界；若检索或材料不足以支持主张，就缩小为片段可证的分析。

## 执行 relay

REVIEWER_TO_EXECUTOR_RELAY:
从本 Gate 开始，只读 `RUNBOOK.md`、`TOOLCHAIN.md`、项目适配脚本及对应技能；不重读治理、不扫描历史或其他项目。使用 $hyperframes 的 general-video 路径和 $human-writing，flow=automation、storyboard=no；默认用户要本地完整测试，按默认方案自主执行。实际渲染目录在新 run 内；先 init 空目录，再写 BRIEF，不能在有规划文档的项目根 init。项目 brief 写明已知受众、中文、16:9、自然长度、旁白和分析性回看；运行时按 HyperFrames 的当前技术合同写 composition，不靠旧代码记忆。CLI 固定 0.8.186；技能要求更新但涉及范围外全局改动时 RETURN Reviewer，不自行修改全局技能。对适用技能中的常规中间确认，Owner 的明确本轮自动执行指令优先；成本和发布边界仍须遵守。

固定运行入口 `npx --yes hyperframes@0.8.186 <command>`。Python `C:/Users/34707/Tools/OpenMontage/.venv/Scripts/python.exe`。TTS 调用 `python scripts/bailian_voice.py --text <run/line.txt> --out <run/voice.wav> --approval <run/approval.json>`。先离线 `python -m unittest discover -s scripts -p test_bailian_voice.py`。真实调用结果不确定就保留 attempt marker、停止受影响生成，不得删除 marker 来重试。

REQUIRED_EVIDENCE: 输入探测/hash；逐点观察和 claim-source 映射；实际读取 Human Writing/执行文案检查记录；当前 TTS 授权与价格/额度依据、每次安全状态和真实音长；渲染/完整 decode；抽样帧；实看实听记录；最终文件 hash、时长/编码/字幕；分阶段耗时与调用计数。
ACCEPTANCE_CRITERIA: RUNBOOK 的八项硬门槛通过，评分 ≥80；额外证明所选分析场景的first-pass原速播放区间并集覆盖完整区间，原顺序未变，无未说明跳段，回放不能冒充首次播放覆盖。成片时长与各段播放/解读/回看映射一致，不受旧90秒目标限制。不能依靠自评分跳过媒体实际检验。视频与旁白实际存在，未审项不得写 PASS。
ROLLBACK_STATUS_OR_PLAN: 源输入不变，全部产物位于新 run；不覆盖原有文件；本地候选可废弃但默认保留证据。云端已产生费用不能回滚，失败/模糊结果先核对、不重复生成。
OWNER_ONLY_ACTIONS: 真实调用的有界授权、价格/额度条件；额外费用、模型/地域更换、片源上传与公开发布均需新授权。
EXECUTOR_TO_REVIEWER_RELAY: 写 run/completion.md；将授权/前置/改动/读回/验证/异常/证据/回滚/资源变化/执行结果追加 EXECUTION_EVIDENCE.md；不能改 REVIEWER_HANDOFF。

## 完成包

结果：PASS_CANDIDATE / RETURN_具体原因
改动：实际输出了什么。
验证：内容、音画及证据检查的实际结果。
问题：NONE 或精确阻塞原因。
回滚：源输入不变，候选目录与供应商调用状态。
请 Reviewer 检查：final.mp4、具体证据及未审项。
Owner 转交：默认 NONE；媒体若不可直接访问才说明最小转交动作。
