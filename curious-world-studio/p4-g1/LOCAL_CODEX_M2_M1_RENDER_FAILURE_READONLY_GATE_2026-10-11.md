# P4-G1V-A-M2-F1｜首次旧 M1 回归渲染失败的**只读**诊断 Gate

> Date: 2026-10-11 | Status: REVIEWER_GATE_READY / EXECUTION_NOT_STARTED  
> 前置：M2 两支候选 MP4 文件 QA 通过，但正式 M2 因首次旧 M1 兼容回归渲染失败后**先重试、后诊断**而 RETURN。此 Gate 只收集根因/边界线索，不抹去历史 STOP 偏差，**不宣布 M2/G1 PASS**。

## GATE_ID / OBJECTIVE / MAX_ENDPOINT_THIS_ROUND
- **Gate**: `P4-G1V-A-M2-F1_READONLY_RENDER_FAILURE_DIAG`
- **Objective**: 对第一次旧 M1 runner 在输出帧184 / 临时媒体 PTS 20992 的 `No frame found` 现象做**有界只读**归因与证据保全。确定是否更接近临时媒体文件、Remotion OffthreadVideo 抽帧、浏览器 worker、磁盘/内存/并发资源的某一层；若不足则精确记录 `ROOT_CAUSE_UNKNOWN`，不得猜测。
- **Maximum endpoint**: 仅只读比对**现有**失败日志、成功重试日志、两个 stage 的目录/文件引用、既有 FFprobe/FFmpeg 报告、M2 source patch、已保全的进程/临时资源记录。可在项目隔离 evidence 目录新建**文字诊断报告/摘录副本**；**不运行渲染器、不重试、不下载/安装、不改变缓存/运行环境/源文件、不清理，不执行 yt-dlp/G2**。
- **Mandatory review stop**: Executor 返回 `DIAGNOSIS_CANDIDATE` 或明确 `RETURN_DIAGNOSTIC_INCONCLUSIVE`，交 Reviewer；不得自行解锁 M2 或开始下一轮测试。

## Target / Preconditions / Scope
- 原本本机根目录：`C:\Users\34707\Documents\ChatGPT\cws-g1va-m2-20261011-x7k2p9`。**实际 Owner Windows 路径必须以本机预检验证**，不假装 Reviewer 可远程读取。
- 已归档证据：`evidence/qa/m1_render_failure_diagnostic.json`、`evidence/qa/reviewer_round2_return.md`、`evidence/qa/final_artifact_manifest.json`、`evidence/qa/execution_report.md`。
- 失败日志：`evidence/m1_legacy_runner_regression/out/qa/render.log`。
- 成功日志：优先取 `evidence/m1_legacy_runner_regression_retry/out/qa/render.log`，若无则定位 manifest 中原 runner 的日志路径；禁止搜索私人目录/非本项目文件。
- 失败 stage：`runtime/openmontage/remotion-composer/projects/cws-g1va-v2-media-m1-m2compat-20261011-a1` 与 `public/...`；成功为同前缀 `-a2`。两次原 M1 source SHA `bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3`，历史 QA 记录首失败 frame 184、PTS 20992、source frame41。
- 不更改或覆盖当前 accepted `main` M1 实现；现 M2 patch 尚未获得正式 PASS，不合并。

## PREFLIGHT
1. 先在 Windows read back Git root、main/分支、工作树及本 Gate 精确路径是否存在，核对旧失败和成功的报告、日志与 stage，保证任务只在 CWS 本项目目录内。
2. 检查目前是否有 M2 / yt-dlp 安装测试正操作同一目录或渲染；不终止别人进程、不覆盖、不清理；资源边界不清则 STOP。
3. 读取只需的文件而不打印环境 Secret、URL 查询身份凭据、浏览器配置或完整可能敏感日志；回传 allowlist 摘要。新的实际远程安装/网络流量/资源测试不在本 Gate。

## DIAGNOSTIC READBACK
- 在原失败 `render.log` 精确找到第一条错误及前后相关若干行：完整错误类别、片内时间/输出帧/source PTS、是否包含 `remotion-assets-dir` 临时媒体路径、文件未找到/读取/seek/timeout/worker 崩溃/并发等具体信号。不可凭错误字符串替根因。
- 对照成功 `-a2` 相同源时段、Remotion/Chrome/FFmpeg/Node 版本与 render flags、thread count/concurrency、source media props、临时副本 SHA、stage 文件引用；只读比对有无不一致。若原临时媒体文件已不存在，标为 `ABSENT`，**不自动重新创建**。
- 用已存在的 FFprobe/FFmpeg **旧日志**（不重跑解码；本 Gate 只读）与事后 frame41 诊断核对：原源帧可解码与 compositor 错误可以并存；不虚构损坏源素材。
- 若可见的 Windows 事件日志/已有资源记录能无特权且只读获取，则可做最小核对；不为此开启管理员权限、扫全盘或改变服务。
- 输出“已排除 / 已支持 / 未知”三列，不允许把一次新 stage 成功误当成旧错误已修复。
- 将原始失败 render.log 的**经过必要脱敏的最小相关片段**附入证据包，保留绝对路径和必要 hashes。原始日志不修改。

## REQUIRED_EVIDENCE / ACCEPTANCE_CRITERIA
- `original_failure_log_available` 及 SHA、失败调用/退出码/帧号/PTS；实际错误原句与相邻上下文；
- 成功阶段可用原始日志摘要、两次 source 与临时媒体副本的确切对应关系、已知事实/推断分开；
- 一份 `m2_f1_readonly_diagnostic.md` 报告（根因 CONFIRMED / NARROWED / UNKNOWN，明确所缺证据），加必要的脱敏日志；
- 本轮所有读取/报告写入位置与确认**未渲染、未安装、未改已保留输入/缓存/素材、未清理**的记录；
- 对本 Gate 验收是**诊断证据充分且边界可信**，不要求一定查出软件内部 root cause；`ROOT_CAUSE_UNKNOWN` 可作为真实结果返回，但**不得升级 M2 PASS**。

## ROLLBACK_STATUS_OR_PLAN
- 原视频/源 patch/失败成功日志均保留不可覆写；本任务若仅新增文字证据，可以保留候审或经 Review 后仅删除**本 Gate 新建报告目录**，不碰历史。
- 若需要“实际重渲才能区分根因”，**先 STOP** 提交风险/资源影响/最小可复现用例的提议，等待 Reviewer 和必要的 Owner 对另一个 Gate 的审批。

## REVIEWER_TO_EXECUTOR_RELAY
> 在 Windows 本机针对 `C:\Users\34707\Documents\ChatGPT\cws-g1va-m2-20261011-x7k2p9` 仅执行 `p4-g1/LOCAL_CODEX_M2_M1_RENDER_FAILURE_READONLY_GATE_2026-10-11.md`。检查现存首次第184帧失败的 `render.log`、成功重试日志和两次 stage 的原始证据，做有界故障隔离。**不重新渲染、不安装、不清理、不修改 M2/M1 源码、不碰 VPN/VPS、不运行 yt-dlp、不进入 G2**。输出小型诊断报告与可独立查看的脱敏日志片段；找不到原因就如实 `ROOT_CAUSE_UNKNOWN`，停止交 Reviewer，不继续试错。

## EXECUTOR_TO_REVIEWER_RELAY
结果：DIAGNOSIS_CANDIDATE / RETURN_DIAGNOSTIC_INCONCLUSIVE；改动：只新增何种报告；验证：失败日志定位和已排除范围；问题：已确认/未确认的根因；回滚：新建报告路径；请 Reviewer 检查：具体证据路径和哈希；Owner 转交：必要的脱敏失败日志摘录及诊断报告。
