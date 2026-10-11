# CWS｜MW-07 Genie 最终局部精修独立 Reviewer 验收（2026-10-11）

> **CURRENT REVIEWER VERDICT**：`MW07_FINAL_POLISH_TECH_PASS / MW07_VISUAL_IMPROVEMENT_VERIFIED / MW07_REVIEWER_KEEP_CANDIDATE / OWNER_FILE_URL_AND_VISUAL_SIGNOFF_PENDING`。**无需再启动新的MW07编码返工或Wave3**，除非Owner正常速度实看提出明确阻塞。主线R1仍是`TASK_PREPARED_NOT_DISPATCHED`。本报告只审独立HTML动效库，不升级正式B的2/4/6、G1/G2或出版许可。

## 一、实收原始证据与独立校验

- Owner 上传包 `cws-mac-window-motion-kit-mw07-final-polish-20261011(1).zip`；Reviewer直接读取二进制 **33,081,224字节**；SHA-256 **`57c6644583b4a2d149295a861087fc71c62041ddac7a0ae82192c959311361f2`**，与Executor回报一致。
- 包含92项（其中`SHA256SUMS.txt`本身为1项），Reviewer独立逐文件计算 **91/91 条清单SHA全部匹配**，未发现缺失。HTML SHA-256 **`6bd889e5b7487c5ef94fc36693941fb96298023190f9db0422bf1c9854f34551`** 与报告一致。
- 旧版Wave2 ZIP在Reviewer本地可读；重新核原件SHA256 **`9487840262a7292ac38b975e8ad44e338c0489823bc52afda0e9cf73247e86d1`**，并读取旧`index.html` SHA **`5551369c0d1499ea1be4b677c30b065ce781f8cb26bd317b4d5cd2ba62184821`**。新包独立、不覆盖旧包。
- 不只依赖Executor“其他模板代码没变”：Reviewer从两份实际HTML分别取`scene11`、`scene12`、`scene13`场景实现片段，三段**字节级文本内容分别相同**；这证实这三项渲染场景逻辑没改，但不替代对共享变量/所有UI的形式化等价证明。
- PIL对比`qa/old_F000..new_F000`等**14对关键帧**：F000、F037、F062、F067、F119、F142、F191像素一致；F045/F051/F059和F123/F127/F130/F137只在Genie实际变形轮廓及内部内容区域出现差异。输入1280×720，没有原来常见的720/721一像素混淆。
- Reviewer目视`MW07_F051_before_after_1to1.png`和10组同帧contact sheet：**旧6px阶梯/不连续边缘变为清晰连续的曲线，文字不再一条条横带撕裂**；仍保留自然的收窄拉伸和逆向恢复。附带`EDGE_COMPARE.json`中对左轮廓280行的量化由Executor提交（最大行间跳变6→1px，跳变≥3px从26→0），Reviewer**只独立核了旧/新图片外观、像素一致与差异区域，没有宣称重新写独立算法测出同样数字**。

## 二、Reviewer 自行使用 Playwright/Chromium 运行真实HTML

- 审查环境：已有`/usr/bin/chromium`、Python Playwright；**没有安装工具**。Chromium `page.set_content` 载入解压后实际`index.html`，并执行`window.motionWave2.select(2,false)`，真实`requestAnimationFrame`到终帧并Reset。
- **1×：6.521秒到F191、playing=false，Reset回F000**。
- **0.5×：12.787秒到F191、playing=false，Reset回F000**。
- 在F094手动以画布目标实际DOM坐标映射`(770,1009)`点击Dock，状态`playing=true`并继续上升F099；**真实点击恢复路径可触发**。这次审查没有把所有真实Windows平台指针事件都当成通过。
- JS pageerror=0；外部HTTP请求=0。Reviewer该环境HTML载入+预热约**1.07s**，其中43帧Genie缓存计算`warmup_ms=879.6`、`cache_bytes=94,363,152`≈**90MiB**。Executor此前预热约**1.67s**，环境不同且缓存占RAM；本次仅证明独立浏览器演示实用，**不意味着正式Remotion长期片段加载/移动端内存性能通过**。
- Reviewer独立FFprobe两条`verified.webm`（VP8,1920×1080）：container时长**8.601s（1×）、14.899s（0.5×）**，FFmpeg 全片decode **2/2 PASS**。MediaRecorder变量帧率及`avg_frame_rate=1000/1`错误统计**不能证明录制连续30fps**；浏览器真实回放比录屏元数据更可信。
- **尚未解决的环境证据**：执行方在容器`file://`直接导航遇`ERR_BLOCKED_BY_ADMINISTRATOR`，Reviewer本轮同样采用HTML内容加载，**Owner Windows Edge真正双击仍记`NOT_VERIFIED_FILE_URL`**。

## 三、是否再次返工 / 最终定位

| 对象 | Reviewer结论 | 原因 |
|---|---|---|
| **MW07 Dock Genie v2.1** | **`REVIEWER_KEEP_CANDIDATE`（小修技术与视觉问题已解决，等待Owner1×实看）** | 连续1px采样替代6px分带，保留原非线性Genie吸入/恢复、191帧与Dock落点；实测1×/0.5×及Reset正常 |
| MW11 Spotlight | `REVIEWER_KEEP_CANDIDATE_UNCHANGED` | 原新版场景实现字节相同；不重做 |
| MW12 Exposé | `REVIEWER_KEEP_CANDIDATE_UNCHANGED` | 原新版场景实现字节相同；不重做 |
| MW13 Finder拖拽 | `REVIEWER_KEEP_CANDIDATE_UNCHANGED` | 原新版场景实现字节相同；不重做 |
| **整个Mac独立动效实验支线** | **`ENGINEERING_REVIEW_COMPLETE / NEW_DEVELOPMENT_STOP`** | 1+5+4=10个已规划行为、第一批Owner已原则认可、第二批三个候选与MW07改善；**Owner最终分项视觉签收及Windows fileURL使用验证尚存，不自动宣布全套10个进入正式视频** |

**高标准限制**：~90MiB缓存、启动预热与低/变帧率WebM本身不构成正式渲染通过或流畅30fps成品QA；不能用一个截图轮廓测试说“所有时刻无锯齿”，也不能因为关闭开发就强制Owner认可视觉。若Owner Windows Edge打不开，需按明确的`file://`兼容性缺陷独立处理；若Owner觉得Genie仍不喜欢，可将该模板HOLD/DROP而不是无限追加新轮返工。

## 四、下一步主线流转（支线无需等待）

- 用户最新澄清**支线MW07任务已下发、主线R1尚未发**；本报告是该支线实际回包后的Reviewer反馈，主线R1任务书 **[P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md](../p4-g1/P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md)**仍是**准备好、未执行**。
- Reviewer建议现在将主力切到R1（CW0002大象 vs CW0005爆米花的真实研究、行为视频、商用权利只读比选），由主线Codex执行，Reviewer独立审核选题；然后R2剧本/镜头/Aqua2/4/6展示方案让Owner第1次看、R3真实音画字幕小样Reviewer评、R4内部完整版Owner第2次看。**理想4轮到内部草片，G1/G2/发布另验收**。
- 泳道：[**纯主线3角色4轮时序图**](P4_MAINLINE_COLLAB_SWIMLANE_4_ROUNDS_2026-10-11.md)。不要因此新增剪辑模式或擅自使用尚未核权利的研究素材。
