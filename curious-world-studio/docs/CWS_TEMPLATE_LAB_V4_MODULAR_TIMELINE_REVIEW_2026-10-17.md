# CWS｜V4 Mac 完整视频与六模板模块化 Reviewer 记录

> **Gate**: `CWS-TEMPLATE-LAB-V4-EXACT-SHELL-MODULAR-TIMELINE-20261017`  
> **Result**: `V4_ARCHITECTURE_CANDIDATE / LOCAL_BEHAVIOR_PASS / EXACT_SHELL_VISUAL_UNVERIFIED`  
> PR: [#144](https://github.com/entropy-student/project/pull/144), Draft / unmerged.

## Owner 需求与约束

Owner 在V3连续样片已具备“真正视频感”的基础上，明确希望**最小精修**而非推倒重做：复用原Research Aqua V2 Mac桌面/鼠标/双击打开/全幅QuickTime；B区内容采用已经设计的六个模板；结尾点击关闭按钮回到桌面。六模板应当可独立调用、多次使用，但**不能拥有各自独立的播放时间轴**。一次最终成片只用一个Master Clock。无需增加第七模板、不授权真实节目R4/发布。

## Gate contract

| Item | This round |
|---|---|
| OBJECTIVE | 有意义地复用原版Mac源码；把六展示布局独立成函数；7镜头示例证明T1复用；总时间轴负责播放、字幕、素材偏移、开窗和关窗 |
| MAX_ENDPOINT_THIS_ROUND | 单文件离线HTML、GitHub Draft PR#144 `storyboard-v4-master.html`、必要的项目文档与Review；不合并、不发布、不加入真实付费素材 |
| MANDATORY_REVIEW_STOP | 浏览器完整可复核与正式素材Story-Fit评估之前不把V4评为最终版；到PR审查即停 |
| TARGET_AND_SCOPE | `curious-world-studio/visual/content-template-lab/` / Draft branch `cws/content-template-lab-v1-20261017`，原版真源保持不变 |
| CRITICAL_CONSTRAINTS | `STYLE_LOCK v1.2`、素材权利PARTIAL、原视频来源项目级不得再次使用、`R3=RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / NO_PUBLISH` |
| PREFLIGHT | GitHub main原版源码 blob `acb0ee80264527bd11160e0ae277ce24528c4a03` / 最新项目状态、Handoff、PR只读确认；仅隔离分支写 |
| REQUIRED_EVIDENCE | Github blob readback、私有离线样片的6模块7镜头和时间轴测试、起/结尾行为、输入与JSON，说明哪些是私有素材或未经同一浏览器集成复核 |
| ACCEPTANCE_CRITERIA | A→B开场与B→A关闭；T1～T6可复用独立布局；同一播放器/总时轴；具体镜头的素材槽/字幕互不串扰；不制造伪科学素材/不把测试当可发布MP4 |
| ROLLBACK | 此PR未合并；旧V1/V2/V3源码、Owner真实媒体、main不受影响；可单独回滚V4新文件 |
| OWNER_ONLY_ACTIONS | NONE for demo; actual production/sourcing/AI spending/publication separately authorized |
| REVIEWER_TO_EXECUTOR_RELAY | 以[锁定V2绘制源码](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html)、[Style Lock](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)、[V3](../visual/content-template-lab/storyboard-v3-source.html)为最小工作面，7镜头/6模板一Master Clock，勿修改main真源或假冒资产权利 |
| EXECUTOR_TO_REVIEWER_RELAY | V4候选、blob/局部Chromium实测、未验证项、文件指针、明确停止边界 |

## 实际结构及运行方式

- GitHub母版文件：[V4 storyboard-v4-master.html](../visual/content-template-lab/storyboard-v4-master.html)。**这是唯一真正嵌入仓库原版Research Aqua V2源码的V4候选**：`iframe#auth-shell srcdoc`含原始Canvas绘制函数（壁纸、菜单、Dock、窗口、鼠标、播放器），移除历史果冻对象试验，只修改媒体时长、总进度时码和`renderClose`。原始文件/commit无修改。
- B区六个模块函数：`TEMPLATE_RENDERERS.T1…T6`；编排数据：`EDITORIAL` 7个镜头，其中`S01=T1(视频)`与`S06=T1(图片)`两次独立实例；不会按顺序强制使用全部六种。
- 时间轴：`compileTimeline()`计算场景 `start/end`；**开场0–4.76s、7个内容镜头4.76–28.76s、结尾28.76–31.06s**；Master Clock是唯一播放时间源。T5进度按当前shot时长分三段，非单独计时器；QuickTime轨道跟随全长、字幕按当前镜头，两个T1的媒体键由`shot_id:slot`隔离。
- 结束：最后一帧之后暂停内容，鼠标移向左上红点，点关闭，QuickTime窗变小消失，保留原Research Aqua桌面。V4不循环。
- 私有单文件离线示范HTML内嵌此前会话提供的参考视频片段及内部样例图（只供Owner观片，不入Git；版权未经公播授权）。**该对话附件仍使用V3近似Mac HTML绘制壳**，不能冒称与GitHub真原版母版完全等价。GitHub版不包含第三方媒体，需用户通过插槽选择素材才能看到非占位图。

## 实际测试、未验证与Review

- **BEHAVIORALLY_VERIFIED（本地隔离Chromium / `page.set_content`）**：7/7镜头可通过时间轴选择；6/6模板均有执行分支；`T1`出现2次但镜头/素材标识不同；T5能自动推进；时轴覆盖Opening、Content、Closing、DesktopClosed四阶段；编辑S01字幕时显示内容更新；播放从S06 23.16s继续到约23.81s；按暂停正常停止；页JavaScript异常0。15个时间点seek检查符合所处阶段。
- **DIRECT_READBACK（GitHub）**：新母版blob复查含原绘制函数`drawWallpaper`/`qtWindow`/`cursorAt`，含`renderClose`、六模板函数、全局`compileTimeline`；无第三方媒体base64或远程请求。
- **UNVERIFIED**：受限本地浏览器未实际执行*GitHub上带真实原V2 iframe*的那一份合成文件；它是准确来源、代码级已查，但其实际视觉与录制流畅度仍需下轮同一候选浏览器回放。私有V4演示的全31秒一倍速自动化测试发生**测试环境超时**，不得称为全程PASS；确定性时间点seek在31.06s显示已关闭并回桌面。Owner Windows Edge真实双击file URL、音频/SRT以及最终MP4输出均未验证。
- **Material quality gap**：源演示图仍带参考片水印/文字、素材权利未清；该样片不能作为正式科研证据或准备发布。六模板复用与播放器视觉基础更接近目标，整体影片Story-Fit尚需真实合法素材、事实与旁白验收。
- **Reviewer verdict**：`PARTIAL`；模块化/单时轴代码满足本轮技术设计方向；**原版融合实际观看/完整一倍速回归、素材与影片质量仍未PASS**。不能自动合并PR或进入正式R4。

## 差异、后续步骤与归档

- V1：静态模板；V2：六个固定scene但外壳/播放不同步；V3：30秒连续视频感建立但Mac视觉近似；**V4：7镜头实例+六个复用模块+Master Clock+完整A→B→A结构，并在GitHub真正移植原V2绘制源码。**
- Next: 在可打开该**GitHub原版V4母版**的实际浏览器中做完整一倍速观片，重点核验`iframe`层叠和关闭过程；核验后才考虑替换私有样片外壳，再做具备实际合法多样素材、文案和音频的完整短片与Remotion桥接。
- No unrelated mainline files, audio, models, paid calls, real site/services or historical R3 assets touched. 
