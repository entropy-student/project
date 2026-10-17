# Curious World Studio｜V5 原版唯一 Mac 外壳整合：执行证据与 Reviewer 判断

> **GATE_ID:** `CWS-ORIGINAL-RESEARCH-AQUA-SHELL-ONLY-INTEGRATION-20261017`  
> **RESULT:** `V5_SOURCE_INTEGRATION_PASS / DETERMINISTIC_LOGIC_PASS / REAL_BROWSER_VISUAL_UNVERIFIED / OVERALL_PARTIAL`  
> **PR:** [#144](https://github.com/entropy-student/project/pull/144) · Draft / 未合并。**本结果不批准真实影片制作或发布**。

## Scope 与 Owner 接受条件

Owner已授权本轮直接精修模板集成：**原版 Research Aqua V2 桌面双击研究视频文件→QuickTime全幅播放内容→结束鼠标点击红色关闭→恢复原桌面**；保留 T1–T6 的分工和任意多次调用，每期一条 Master Clock，不增加第七模板；禁止第二套Mac界面与独立播放器。

- **SOURCE OF TRUTH:** `main:curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html`，Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`；原source完全不动。
- **CHANGE TARGET:** [V5 原版唯一播放器 HTML](../visual/content-template-lab/storyboard-v5-original-shell.html)，仅在隔离 `cws/content-template-lab-v1-20261017` 分支中新增。V1–V4源仍保留；所有main原科学项目文件不动。
- **MAX ENDPOINT / MANDATORY REVIEW STOP:** 一份PR候选HTML，受控代码/时轴QA和文档回读，停止在PR评审之前；不得自动merge、启动正式R4、发布、生成或购买素材。
- **OWNER ONLY:** 正式影片/授权媒体/收费/外部公开与Merge另行审查。
- **ROLLBACK:** 未合并的新V5文件可在隔离PR回退，不影响main旧基准、数据或服务。

## 本次实现：修正上版错误而非重做

1. 从原V2 **整份自包含Canvas/HTML源码** 出发，保留原来的 Research Aqua 桌面绘制、菜单、Dock、Finder图标、真实鼠标轨迹、点击反馈、`qtWindow`银灰标题栏/交通灯/控制条、窗口几何。
2. 只把原`qtWindow`内部历史果冻示意画面替换为**单一媒体内容槽** `#content-viewport/#content-plane`。这不是再加一个播放器：新HTML只有一个`canvas#view`，**不存在`#qt`**，也没有第二套菜单/Dock/控制条CSS。
3. 复用上一版已经具备的`TEMPLATES`/`EDITORIAL`/`TEMPLATE_RENDERERS`及`compileTimeline`；六个布局的展示HTML只被放入原V2播放器的内视口，按原`windowGeom(t)`几何变化而裁切/缩放。7个镜头中T1出现两次且对应不同`shot_id:slot`素材key。
4. **唯一时轴**：开场0–4.76秒；内容4.76–28.76秒；结束28.76–31.06秒。时钟同时喂给原Canvas的`window.renderAt(t)`、单一内容槽、视频时间偏移、字幕、页面跳转控件。结尾同源`drawCursor/clickRing`点原红灯，`qtWindow`收起并回同一桌面；不是再创建一个窗口。
5. 本版本故意不提交任何第三方图片视频到Git。未指定合法素材时显示明确占位；可本地选视频/图片、调整镜头字幕并导出Json时间线。原V2自绘果冻函数仍可能作为**未被调用的历史定义**留在源码，但不再生成或宣称真实科研画面。

## 测试和可声称范围

- **DIRECT_READBACK:** V5文件 GitHub Blob `752f713eb20975a68431559618d2a3acf84b8225`，原V2 blob仍`acb0ee80264527bd11160e0ae277ce24528c4a03`。源码包含原V2 `qtWindow/drawWallpaper/drawCursor`，`canvas#view`只有1个，`#qt` DOM定义0个、六个 T1…T6 模块和统一编排字段存在，无外部URL/第三方媒体。
- **SYNTAX:** 以隔离JS parser检查两个`script`块，2/2成功，解析异常0。
- **DETERMINISTIC SHIM TEST（非浏览器视觉）:** 在不运行浏览器内核的受控DOM/Canvas替身中，22个固定时间点调用原V2绘制代码与新单时轴内容，观察到0–1.92桌面、2.3–3.76窗口逐步放大、3.76后全幅、7镜头覆盖6布局、T5随全局时间从step0→1→2、28.76开始关闭、30.80后窗口不存在并恢复桌面；无JS异常。假阳性说明：替身的`getElementById`对不存在的id也会合成对象，故第一次由其判断`#qt`的“存在”是假阳性，实际HTML静态扫描证实无第二播放器。
- **UNVERIFIED / NO FINAL PASS:** V5的完整真实Chromium 1×观看、原V2开窗逐帧一致性、文件上传的视频播放与全程seek、播放器关窗观感、Edge离线file URL、整片MP4/TTS/SRT均未用**相同V5候选**实际浏览器验收。JS替身通过不等于视频可用。由于无已授权真实媒体的工程资产，不冒充完整内容故事的视觉Story-Fit通过。
- **Reviewer verdict:** **整体PARTIAL**，核心架构按Owner指定的“只保留原V2外壳+六内容模板”修正；下一轮以确切V5文件在真实浏览器复核和必要最小补丁为唯一优先，不因代码阅读就合并或封板。

**Persistent status:** 旧项目`CW0005_VISUAL_STORYFIT_HOLD / R3=RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`，素材权利PARTIAL，仍全部保持。
