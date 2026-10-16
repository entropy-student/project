<!-- CWS-AUTHORITATIVE-ENTRY-20261016 -->
> **Owner 2026-10-16最新明确**：视频画面“只要相关就可以”，不追求逐帧精准或每句配实验影像。旧R6L/R7L的`PARTIAL_ASSET_GAP`仅是历史研究镜头证据缺口，**不可据此继续增加搜片轮次、制造识别模型或卡住普通内容创作**。科学讲述须准确，库存片只能作为辅助画面、具体使用许可仍单独审核；不能冒充原论文实验。下一步建议编辑现有CW-0005脚本/镜头匹配已有画面，**未授权Codex实际制片/发布**。正式`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`继续保留。首读[CURRENT_STATE](docs/CURRENT_STATE.md)与[完整新Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md)。
> **已完成技术**：PR#129/#131已合并main，Windows Docker SearXNG+4get及`cws_media.py`按需可用；部分上游失败默认`PARTIAL_SEARCH`非零，`--allow-partial`须显式。不重做G2–G4或旧R6L。
# Curious World Studio｜Agent / Codex 唯一入口

> **最新有效结果**：`MEDIA-INTEGRATION PR#129 MERGED`；本机`G2_G3_G4_TECHNICAL_ACCEPT`（Ubuntu备份注销、Docker按需搜索、真实素材下载/解码/Owner Edge手播通过）。**Docker Compose和统一Codex工具已由PR #131合并main；媒体动作/复用权、CW-0005制作Gate尚未通过。** 不重复G2–G4或操作集成验收；R6L/R7L试跑已完成，完整R6/R7产品化仍须另行授权。正式`CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。
>
> **先读**：[唯一当前状态](docs/CURRENT_STATE.md) → [最新Reviewer交接](docs/REVIEWER_HANDOFF_CURRENT.md) → [MEDIA架构/阶段表](docs/MEDIA_PIPELINE_ARCHITECTURE_AND_ROADMAP.md)。旧`G0`、`G1A`、`G1B`、`DOCKERFREE`和已经完成的`G2-G4`“下一步”指令**全部历史化**，不能再根据旧文字重新卸载Ubuntu、安装组件或要求Owner重播旧样片。

## 工作范围与Gate

- **频道与研究**：不露脸跨领域真实知识视频；B站主阵地。九大信息源→发现→初筛→[36条选题库](research/topic-bank/WORKFLOW_V1.md)→STORY-FIT→剧本/素材证据→制作。HF-FIND单独遵循[唯一研究主协议](research/HF_有趣发现_唯一主协议.md)。
- **视觉**：A简短Mac Tiger Aqua桌面→B满屏QuickTime 7银灰播放器，单行字幕；以[STYLE_LOCK](visual/retro-mac-v1.2/docs/STYLE_LOCK.md)为规范，HTML原型不等于成片。
- **素材**：以[3+1正式合同](docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)为最高来源/权利规则，MEDIA技术默认排除大陆平台、竖屏及方形、显示比例≥4:3，优先1080p，未知先有限探测；严格区分`LINK_FOUND / CONTENT_VERIFIED / REUSE_RIGHTS_VERIFIED`。
- **MEDIA当前运行选择**：Windows已有Docker Desktop/WSL2；SearXNG+4get Compose本机按需启停，CWS Python/yt-dlp/FFmpeg本机执行；不部署VPS、不开公网、不需要后台24h常驻。不操作共享Docker项目、VPN/Clash、全局代理、OpenMontage。
- **制作Gate**：MEDIA技术PASS不能触发`CW0005_VISUAL_STORYFIT_HOLD`解除、不能自动换题、做音画/成片、支付/公开发布。MEDIA-R6/R7与PROD-R1～4互不代替。

## Reviewer与执行者职责

- **Owner**：明确授权下一Gate、付费、删除、远程部署、素材复用、生产和发布，审核内容动作、审美。
- **Windows本机Codex**：仅执行Owner授权范围，保留旧工作树3个tracked改动/2个未跟踪缓存与Ubuntu备份；若需新增稳定源码，基于最新main建隔离分支PR，**不得自行合并**；交**一个脱敏ZIP+SHA**供Reviewer验收。
- **独立Reviewer**：分别标明实际独立验证和执行端/Owner提供的证据；判断PASS/PARTIAL/RETURN/HOLD；认可合并应独立审查而非仅凭日志口述。
- **浏览器自动技术QA**：今后应由Codex在获准的**独立测试浏览器**测试`readyState/videoWidth/play()/currentTime`和实际画面，结束时回收本轮进程；不得控制Owner现有私人Edge窗口或绕过Computer Use明确的安全停止。若运行权限受限，标`BROWSER_AUTO_NOT_VERIFIED`，不默认让Owner反复点击同一技术样片。
- **保全**：不对旧工作树做`reset --hard`/`git clean`，不`docker system prune`/`down -v`，不删已备份Ubuntu tar/旧媒体、不把Cookie、凭据、全量原片/日志上传Git。

## 按指令类型分流

- `PROJECT-STATUS`：仅依据[CURRENT_STATE](docs/CURRENT_STATE.md)与交接，不能把旧“已授权执行”当现行任务。
- `HF-FIND`：按唯一主协议执行HF日榜发现；不自行制作视频。
- `TOPIC-BANK`：按[工作流](research/topic-bank/WORKFLOW_V1.md)和[九源注册表](research/SOURCE_SYSTEM_FINAL_V1.md)，修改母表/看板时先运行`python curious-world-studio/research/topic-bank/validate_topic_bank.py`及`python -m unittest discover -s curious-world-studio/research/topic-bank -p test_validate_topic_bank.py`。
- `STYLE-REVIEW`：仅依据视觉锁与真实证据评论样式，不自动开发渲染器。
- `MEDIA-OPERATIONS-INTEGRATION`已合并；R6L/R7L一次试跑已结束。下一步建议按[最新状态](docs/CURRENT_STATE.md)**直接编辑既有CW-0005 50–60秒剧本/S01–S10分镜，使旁白准确且画面相关**，无须继续寻找精确实验录像。历史[试跑合同](docs/MEDIA_R6L_R7L_FAST_MATCH_PILOT_2026-10-15.md)仅为证据；完整R6/R7产品化、PROD、公开发布仍未获授权。

历史G0/M2/阶段报告只用于追溯。**GitHub main记录稳定代码和长期规范，执行ZIP/媒体保留Owner本机，不为每轮普通QA新增重复Git报告。**
