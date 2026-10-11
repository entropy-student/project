# CWS Mac Window Motion Kit Wave 2｜2026-10-11 独立高标准 Reviewer QA

> **交付归属**：Owner上传 `cws-mac-window-motion-kit-wave2-20261011(1).zip`，这份新交付不同于第一批5种V2。**当前 Reviewer 判定：`WAVE2_INDEPENDENT_TECH_PASS_4_OF_4`；`MW11_MW12_MW13_REVIEWER_KEEP_CANDIDATE`；`MW07_REVIEWER_HOLD_VISUAL_POLISH`；`OWNER_VISUAL_SIGNOFF_PENDING`**。视觉候选不是正式节目可集成的功能许可，仍遵守原3+1/2/4/6、A→B、G1_NOT_PASS / G2_NOT_AUTHORIZED。
>
> **第一批**状态不变：Wave1 V2 已被Owner原则认可，旧第一版视觉不通过作为历史保留；第二批交付并不自动获得Owner KEEP。

## 1. 证据真实性（Reviewer独立拆包与验证）

- 原ZIP大小约21.34 MiB，实测 SHA256：**`9487840262a7292ac38b975e8ad44e338c0489823bc52afda0e9cf73247e86d1`**；包含 **88个ZIP条目**（含`SHA256SUMS.txt`），Reviewer逐项独立计算 **87/87 条清单 SHA通过**。这是本轮对文件完整性的独立验证，不只是读取Codex JSON。
- 自包含 `index.html` SHA256：**`5551369c0d1499ea1be4b677c30b065ce781f8cb26bd317b4d5cd2ba62184821`**；Review只对本轮上传的版本负责。
- 53张 `screenshots/MW-*_F*.png` 实测全部 **1280×720**（MW07 14，MW11 13，MW12 13，MW13 13）；已目视总览和MW07 F051、MW12 F083、MW13 F095等关键原图。
- `qa/baseline_wave1_v2.png` 与 `qa/baseline_wave2.png` 实测文件**字节完全相同**；仅证明 **`desktop(0,false)` 静态底座相同**，不构成原V2全年龄动态像素/时间轴等价。仍保留旧有Dock在动态t>1.75秒偏移5px的已知例外。
- 四段 `*_1x_playback_verified.webm` 全部成功 FFmpeg全片解码，视频分辨率1920×1080、VP8；各容器元数据可读时长 MW11 **8.059秒**、MW12 **8.976秒**、MW07 **8.309秒**、MW13 **7.949秒**，均超出1×演示标称长度并有尾帧保持。**不可从这四段WebM推论其连续捕获达到30fps**：编码器间歇取帧，部分FFprobe `avg_frame_rate=1000/1` 是无意义的重封装元数据，不可作为帧率PASS。
- Chrome/Chromium安全限制：Reviewer本轮真实尝试`file://`导航，返回 **`ERR_BLOCKED_BY_ADMINISTRATOR`**。隔离新page读取实际HTML文本后才进行独立浏览器运行；故 **Owner Windows Edge 双击本地文件状态 `NOT_VERIFIED_FILE_URL`**。

## 2. 第二轮独立真实浏览器实测（不是仅凭随包报告）

使用现有 Chromium + Playwright、不安装新工具、不联网，在`page.set_content`中加载原始HTML，直接执行原`motionWave2`状态机并观察真实`requestAnimationFrame`。所有实测均 **1×从0到最终帧**，然后 Reset回0；JS page errors **0**、外部HTTP请求**0**。

| ID | 名称 | 标称帧/秒 | Reviewer自己的1×墙钟 | Reset | 实际观感/真实性 |
|---|---|---|---|---|---|
| MW-11 | Tiger Spotlight | 181f / 6.03s | **6.11s → 181** | 0 | 带完整菜单点击→逐字输入→可读结果→选中→模拟文件窗；**Reviewer KEEP候选**。是假搜索，UI DEMO标注明确 |
| MW-12 | Exposé | 208f / 6.93s | **7.08s → 208** | 0 | 从初始重叠到不同几何轨迹2×2总览→明确选窗恢复；独立**0.5×13.93s完成**，`overview→D→overview→A`实测回选成功；**Reviewer KEEP候选**。不是仅z-index交换 |
| MW-07 | Dock Genie | 191f / 6.37s | **6.50s → 191** | 0 | 分段形变跟Dock目标图标匹配，非线性条带非简单缩放，独立**0.5×12.78s完成**；**Reviewer HOLD小修**：中途 F051 窗口内容中文字被拉裂/重复、两侧外缘有明显6px台阶，离已认可V2的柔顺质感仍有差距 |
| MW-13 | Finder拖拽 | 179f / 5.97s | **6.06s → 179** | 0 | 移动→按下→拖影→投放高亮→接收结果完整；另外**真实鼠标pointerdown/drag/pointerup**到目标区会把`manualImported`设为true、Reset会清零；**Reviewer KEEP候选** |

四项0.5×Codex报告均完成；Reviewer本轮另外独立实跑了**MW12和MW07**，另外MW11/MW13的0.5×只核Codex报告，没有冒称本人重新跑过所有四项。

## 3. 严格视觉判定及必要低成本修正

### MW-11 `KEEP_CANDIDATE`
保留紧凑Tiger菜单栏右侧 Spotlight、逐字输入、结果停留时间与鼠标因果，和V2桌面协调。**Owner实看后**再决定是否KEEP。正式节目中不能将模拟搜索画成真实研究检索历史。

### MW-12 `KEEP_CANDIDATE`
4个窗初态不同，过渡到2×2总览明确，支持D→A重新选择。字号/控制区在1280px截图可识别。可后续微调初态层级和总览时露出背景图标，但**没有重新出现第一批MW03那种纯z-index假动画**。避免把此多窗动作塞入正式B科学证据镜头。

### MW-07 `HOLD_VISUAL_POLISH`
`source/wave2-motion.js`中`drawGenie`把窗口分为**6px高横带**，通过`ribbonDest(u,q)`作非仿射位移、宽度、纵向重映射，已证明不是`transform:scale`欺骗。但在全分辨率中途容易出现**字体重影、竖向拉断、分段绘制的台阶锯齿**，特别是 **MW-07_F051.png**（0.5×也能看到），观众可能把它当成粗糙的压缩而不是丝滑Genie。建议**仅针对这一个效果局部小修**：使用更密的1–2px横带或等效纹理映射、正确的边界裁剪/插值，检查真实1×全过程，保留同一个Dock落点、反向恢复和原V2主题；不能退化为简单`scale(0)`或覆盖已交付ZIP。刷新4段录屏中的MW07完整尾帧与关键帧证据；只有Owner看后才能判KEEP，不要求其他3项重造。
**注意**：这不是功能阻塞也不是正式Mac OS 10.4像素忠实认证，是高标准视觉微调建议。

### MW-13 `KEEP_CANDIDATE`
拖影与光标同步进入高亮区域，真实手动pointer触发模拟导入，Reset撤回。**投放区域是演示容器，并没有实际文件IO**；视觉OK但不可用于假造真实资料已经下载/导入。

## 4. 环境、版权与主线的明确边界

- 首批Wave1 v2 HTML/ZIP未在此轮覆盖（上传包独立，Codex报告同哈希），未修改GitHub M2/Remotion源文件或V2 STYLE_LOCK。
- 本轮QA只验证**隔离窗口UI Demo**。正式内容仅允许2转场/4布局/6信息三类轻动效按 [Research Aqua 2/4/6统一视觉提案](P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md)，非默认批准Spotlight/Exposé/Genie/拖入动作在B画面自由使用。
- 主线选题 `CW-0002` 原始研究录像公开可用、画面与权利未过关；Story-Fit状态仍未获GO。视频完整配音/字幕/真实素材组合和长片并发仍未验，G1尚未PASS/G2仍禁止。
- 如果 Windows Edge `file://` 双击不支持，Owner返回具体错误，下一轮只针对离线打开做本地封装修复；不修改网络/系统设置或使用服务器补救。不能为了这项证据擅自运行正式视频。

## 5. 当前下一步

1. Owner本机双击`index.html`，各项正常1×观看并在MW12窗口总览时尝试D→A重选；对MW11/MW12/MW13逐项决定KEEP/HOLD/DROP，对MW07先看6px条带风格是否可接受。
2. 如Owner也感到Genie形变有明显锯齿/文字撕裂，只返工MW07的ribbon sampling与帧审查，不重做已通过其余3项；明确指示Codex生成**独立新版本**并保留原ZIP哈希。
3. 主线跟随独立Story-Fit合法素材与Aqua 2/4/6轻量预览任务；Reviewer下次继续审任何新上传产物，逐一确认源权利与技术门禁，不开G2。

**最终状态：`WAVE2_TECH_PASS_ALL_4 / THREE_KEEP_CANDIDATES / ONE_HOLD_POLISH / OWNER_SIGNOFF_PENDING / FORMAL_VIDEO_NOT_AUTHORIZED`。**
