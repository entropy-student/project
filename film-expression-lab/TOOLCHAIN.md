# 本机工具与研究路径

核验日期 2026-10-23。PRESENT 表示文件/配置存在，BEHAVIORALLY_VERIFIED 表示已实际运行相应行为，UNVERIFIED 表示没有完成真实验证。配置与历史报告不能证明当前服务可用。

## 已核实

| 能力 | 本地入口 | 核验与边界 |
|---|---|---|
| 媒体处理 | PATH 的 ffmpeg / ffprobe | FFmpeg 9.0，版本运行成功；真实片源尚未提供 |
| JavaScript | PATH 的 node / npx | Node v24.19.0；HyperFrames 初始未安装，准备结果另见 E002 |
| Python | `C:/Users/34707/Tools/OpenMontage/.venv/Scripts/python.exe` | 可运行，requests/python-dotenv/Pillow 可导入 |
| 百炼中文 TTS | OpenMontage 的 `tools/audio/qwen_audio_tts.py` | 源码模型 qwen-audio-3.1-tts-flash，音色 longzhe_v3.1，zh、WAV 24kHz；未发起请求 |
| 凭据元数据 | `C:/Users/34707/Tools/OpenMontage/.env` | 文件、DASHSCOPE_API_KEY、DASHSCOPE_WORKSPACE_ID 非空；仅输出布尔值。权限、余额、产品权限和实际生成仍 UNVERIFIED |
| 通用/原始资料搜索 | `mcporter call exa.web_search_exa` | 实测返回 David Bordwell 官方书籍/场面调度页面；搜索可用不代表全文已读 |
| 学术书目核验 | Crossref works API | 真实 GET 返回 200、DOI、journal-article 与 book-chapter；不等于全文或同行评审质量认证 |
| 平台检索路由 | `C:/Users/34707/.agent-reach/venv/Scripts/python.exe -m agent_reach.cli` | 找到可运行入口；此前仅 PATH 不可用，不能再写成完全未安装 |
| 中文平台 CLI | `C:/Users/34707/.local/bin/bili.exe` | 文件存在，未进行目标视频搜索/字幕核验，不在首测关键依赖中 |
| 视频制作技能 | `C:/Users/34707/.codex/skills/hyperframes/SKILL.md` 及 general-video、core、media-use | 已读取入口；流程参考文档在 hyperframes/references，不在 core/references |
| 中文文案 | `C:/Users/34707/.agents/skills/human-writing/SKILL.md` | 强制调用；已读主文件及 formats/reality，实际文案初稿后读 revision 并运行写作检查 |

G1 后续读回：HyperFrames 0.8.186 已通过固定版本下载及版本命令，doctor 的浏览器/编码工具可用；JSON 总结果为 false，主要资源风险为可用内存 1.6GB。`--low-memory-mode` 是已从本版本 render help 确认的单 worker 模式。尚未完成真实影视渲染，不能称渲染链 PASS。general-video 安装更新命令的 `--dir` 只限制删除检测，不能误当安装隔离目录。

## 保留的限制

1. 本机旧科普项目已有研究方法与 OpenAlex/PubMed 等来源登记，但这不等于配置了可覆盖电影学的自动学术系统。本轮只复用方法，未把科普主题采集器直接当电影研究器。
2. OpenMontage venv 无 faster-whisper、whisperx。不自动安装本地 AI 权重。原片对白可用用户字幕或人工分段核对；TTS 文本按短句生成和测量真实音长实现旁白字幕，不把均分字数冒充强制对齐。
3. 现有 DashScope ASR 源码要求可公开访问的音频 URL。首次测试不公开上传片源，故不能当作即用本地 ASR。
4. OpenMontage 原有 TTS 使用进程环境变量读取凭据，且下载前写含签名 URL 的 recovery.json。治理对 Secret 的环境变量/普通临时文件有更严格约束，不能直接无审查调用。项目适配入口采用受保护文件内存读取、无环境变量传递、无签名链接落盘；需离线验证及首次真实调用核验，不能冒称既有生产能力。
5. provider 的真实价格/剩余额度未核验，不沿用旧文档中的价格。真实生成前必须有当前任务的有界调用授权及价格或免费额度依据。超时不重试，不切模型/地域/供应商。

## 电影研究检索办法

先描述片段事实，再针对具体问题做中英文检索。影片原文名/年份＋场景＋staging、blocking、sound、narration、motif 等；补查创作者/摄影/剪辑访谈、剧本、storyboard、audio commentary、making-of。优先创作者、制作方、发行方和正规出版来源。

学术深挖以作者官网、大学知识库、出版社、电影学期刊与 Crossref 书目为入口。可按需尝试 OpenAlex、Semantic Scholar、JSTOR、Project MUSE、CNKI/国家哲社文献中心等，但这些不是本轮已验证连接，不绕登录/付费墙，不伪造已读全文。

快测默认最多 3 组聚焦检索、4 条精读来源或约 10 分钟研究预算；遇到决定论点的事实缺口，缩小论点或 RETURN，不以时间预算为由编造。完整一期另开扩展研究范围。

记录 author/title/year/url 或 DOI、材料类型、读到的范围、页码/段落、支持哪个 claim、局限和相反解释。只读摘要只能支撑摘要明确表达的内容。学术概念帮助分析，不能证明导演想法；不同转载不算独立证据。

Agent Reach 的版本检查使用可运行的 venv module 入口。工具和配置均不全局更新，不改系统代理/DNS/VPN。

## 2026-10-23 Owner 授权升级后的当前入口

本节更新 Agent Reach 当前状态，前述 venv module 作为历史发现保留，不再是推荐调用入口。新版 uv 安装为1.6.0，入口 `C:/Users/34707/.local/bin/agent-reach.exe`。已运行 uv tool update-shell，把该可执行目录加入用户 PATH，旧进程可能要重启 shell 才生效；执行 agent 可直接用绝对路径，不要求用户调试。

当前 web search 实测 backend=exa、ok=true，返回作者官网/出版社两条结果；后续可使用 `agent-reach web search <query> --limit 2`。不修改既有 mcporter Exa 设置。GitHub 读取仍优先使用本会话插件，不能因新版报告的通用说明改成浏览器。

setup 顶层 ok=true，但默认渠道4/5成功；B站依赖安装报 `No matching distribution found for bilibili-cli==0.6.2`，是上游依赖可获得性问题，未修复。没有循环重试、换模型、改代理或对所有平台作成功声明。独立 bili.exe 与 .agent-reach/venv 仍存在；后者未自动移除，避免牵连共享包。新版安装器只从 .agent-reach-venv 卸载旧 Agent Reach 包，未删除该 venv 的其他包。

旧技能备份位于 `C:/Users/34707/.agent-reach/tools/upgrade-backup-20261023-01/agent-reach-skill-v1.5`，不含凭据。原始安装报告见 AGENT_REACH_INSTALL_REPORT_20261023.md。TTS 入口与授权状态未改变。
