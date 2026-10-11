# CWS Mac Window Motion Kit｜第一批 Owner 原则认可与第二批启动决定（2026-10-11）

> **Owner 原话**：「我觉得基本达到要求了，如果你认为还有问题可以进一步优化，其他模版也可以开始了。然后汇报一下进展吧。」  
> **已确认的决定**：`WAVE1_V2_OWNER_PROVISIONAL_VISUAL_ACCEPTANCE`；`WAVE2_FOUR_ISOLATED_HTML_DEMOS_AUTHORIZED`。  
> **没有确认的决定**：Owner 未对第一批五项逐一说最终 `KEEP`；未确认 1:1 动态 V2 等价；未签正式视频/Remotion 集成、暂停真实科研视频或扩大正式2/4/6动作类型；**不得把「基本达到要求」冒称正式 G1/G2/发布 PASS**。

## 第一批（当前成果与各项用途）

| ID | 窗口行为 | 当前决策 | 解释 |
|---|---|---|---|
| MW-01 | 红灯关闭窗口 | **`OWNER_PROVISIONAL_KEEP`** | Reviewer独立技术/实时视觉候选通过，Owner大方向认可；沿用v2新版 |
| MW-02 | Aqua提醒弹窗 | **`OWNER_PROVISIONAL_KEEP`** | 保留“触发—阅读—选择—关闭”的完整动作 |
| MW-03 | A↔B前后台切换 | **`OWNER_PROVISIONAL_KEEP`** | 独立实测前后窗确实发生几何移动、点击可逆，非旧版 z-index 假切换 |
| MW-04 | 播放器暂停 UI | **`DEMO_KEEP_ONLY`** | Owner整体认可演示，**正式 B 源视频时间控制未授权** |
| MW-05 | 进度操作 UI | **`DEMO_KEEP_ONLY`** | Owner整体认可演示，**正式剧情不能伪装科研计算或假文件下载** |

此前旧版v1五项仍 `RETURN_VISUAL_REJECTED_ALL_FIVE`，是另一份历史交付的真实评价，不能删改。新版v2源 ZIP SHA256 `8987b1a5594ecc346d463ec3c8f47239de5c50587711eb56232ed48964757b67`；本轮 Reviewer 的最新源证据：[V2独立 QA](MAC_WINDOW_MOTION_KIT_V2_REWORK_REVIEWER_QA_2026-10-11.md)。Owner原则认可基于其实际观看反馈；Reviewer此前独立验证5/5正常浏览器播放到终帧及MW03反向切换。

## 仅做低优先级的后续精修，不阻塞第二批

1. **动态 V2 母版差异**：独立HTML演示现在固定 `desktop(t=0)`；原V2壁纸/ Dock动画 `t>1.75s` 时播放图标上移约5px。当前作为独立静态底座可接受为待办，未来如复用到正式视频，须在不改变已选V2外观前提下做同时间轴对照，避免错位或突然“跳”。
2. **完整录像证据**：五段 v2 WebM 已解码成功，但实际编码长度均略短于标称演示，MW02约短1秒；Reviewer的浏览器1×执行确实到了终帧，不把录屏短尾当“动画失败”。在下一次封装 QA 时补每段含结束保持的完整录屏及帧时序报告。
3. **Windows双击验收**：受限Reviewer Chromium无法导航 `file://`，在Owner Windows Edge双击新版离线HTML的结果尚未确证；若用户后续直接部署在本机再补一次。既有 `set_content` 浏览器实验不等价于真实 `file://`。
4. **可读性/风格**：制作更多动效时优先观察真实播放，不要只因为按钮点击或3张截图通过便给视觉 PASS；避免过度增加“纯装饰操作”打断4–6分钟左右的真实研究视频节奏。

以上均为 **`NON_BLOCKING_POLISH_BACKLOG`**，除非下一轮实际预览发现新的高严重程度缺陷，否则不再重新渲染/反复打磨第一批；**不允许直接覆盖已验收v2 HTML/ZIP**，若需补丁只在独立新输出目录制作v2.1。

## 第二批现在允许执行的四个独立 Demo

按第一批成功复用的V2桌面/鼠标窗口组件，新增：**MW-11 Spotlight Tiger搜索**、**MW-12 Exposé窗口总览**、**MW-07 Dock Genie精灵最小化/恢复**、**MW-13 Finder文件拖拽导入**。工作范围**只有独立纯HTML离线演示/截图/浏览器QA包，不触主线Remotion/官方素材/商业发布**。

完整Bounded Gate见 [第二批执行任务](../p4-g1/MAC_WINDOW_MOTION_KIT_WAVE2_4_DEMOS_GATE_2026-10-11.md)，它已获得Owner**对“可以开始第二批模板”这一独立Demo范围的原则授权**；**执行结果尚未返回，任何人不能宣称四模板已制作/通过**。要在Owner本地Codex启动，仍需Owner将任务书转发给独立Executor；本GitHub文档本身不会自动在Windows启动任务。

## 正式视频与主线边界

- A已选Research Aqua V2桌面/文件双击/开窗→B QuickTime真实证据素材满幅为当前固定壳；新增A窗口动效均先独立评审，不直接改正式B。
- 素材合同仍是3+1（研究原始素材、OpenMontage合法真实动作素材、yt-dlp合规URL）与额外后期仅 **2转场、4画面布局、6信息/单行字幕**；除原 V2 已锁外，不新增未经确认的暂停时间控制/新风格特效/AI科研实体/重复镜头。
- PR #116五文件M2 code已经并入main且Review阻塞已修，但历史 M2/G1正式Gate未通过，G2未授权；正式首片仍需Story-Fit、版权/证据镜头、云端配音/单行字幕同步、长片资源预算，以及首片前受控只读清理盘点→Owner精确删除批准。

## 下一次Reviewer交接

先读本决定，再读 [V2第一批Reviewer QA](MAC_WINDOW_MOTION_KIT_V2_REWORK_REVIEWER_QA_2026-10-11.md)、[第二批执行Gate](../p4-g1/MAC_WINDOW_MOTION_KIT_WAVE2_4_DEMOS_GATE_2026-10-11.md)、[旧V1退回报告](MAC_WINDOW_MOTION_KIT_V1_REVIEWER_VISUAL_RETURN_2026-10-11.md)；区分**原V1废案、V2原则通过、第二批授权尚未生成、正式视频未授权**四种状态。
