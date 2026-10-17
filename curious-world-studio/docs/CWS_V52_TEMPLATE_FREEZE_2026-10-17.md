# Curious World Studio｜V5.2 模板阶段冻结记录

> **日期：** 2026-10-17  
> **Owner 决策：** `V5.2_TEMPLATE_BASELINE_FROZEN`（保留当前样式，允许未来版本继续优化，但不得直接覆盖冻结版）  
> **边界：** 模板/技术基线冻结 ≠ 最终画风逐帧冻结 ≠ 正式节目素材、声音、完整成片验收 PASS ≠ 允许公开发布。

## 1. 唯一冻结资产、验真和回滚

- **main 永久归档版：** [V5.2 HTML](../visual/frozen/storyboard-v5-2-20261017.html)，项目内路径 `curious-world-studio/visual/frozen/storyboard-v5-2-20261017.html`。
- **Git blob（SHA-1）：** `f002fd3a3fea24352c8eddb63d8f265014a9e93b`。2026-10-17 `DIRECT_READBACK`：其与 Draft [PR #144](https://github.com/entropy-student/project/pull/144) 源 `curious-world-studio/visual/content-template-lab/storyboard-v5-2-reviewed.html` blob **相同且内容逐字相等**；大小 40,074 字符。
- **来源基线：** 已选 [Research Aqua V2 原始 HTML](../p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html) Git blob `acb0ee80264527bd11160e0ae277ce24528c4a03`（原版不修改）；[STYLE_LOCK v1.2](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)。
- **私人媒体：** 之前在会话中提供的带参考片段 HTML 仅作个人视觉对照，版权/复用许可并未取得公开授权。**冻结到 main 的版本不含第三方图片、视频字节、不含外部媒体 URL、不得将私人样片上传仓库。** 浏览器打开可替换素材，默认有明确占位。
- **版本保全：** 过去的 V1–V5 及 PR #144 仍保留。**归档复制 ≠ 合并 PR**。PR 继续 Draft，不对正式电影 Gate 造成放行。后续新增 `V5.3+` 或 `V6` 候选，而不覆写上述main冻结文件；回退未来尝试即可重新使用本HTML。

## 2. 当前已经做成并决定保留的内容

| 模块 | 现有状态及判断 |
|---|---|
| Mac 视觉外壳 | 单一 Research Aqua V2 Canvas：桌面、Finder/视频文件、鼠标双击、QuickTime 银灰标题栏/控制条、结束关闭回桌面。V4双播放器叠层问题已移除；不再重新绘制第二套Mac |
| T1–T6 内容模板 | 已有单素材、双画面对照、实拍+解释、真实资料/档案展示、三阶段过程、数据/结论六种。分开为可重复调用的渲染函数，但不分成六个播放器 |
| 镜头实例 | 现有7镜头技术样片，T1出现两次且素材槽独立；单期可任意选择模板，不要求六种全部出场 |
| 时序 | 统一Master Clock，约31.06秒：桌面开场0–4.76、内容4.76–28.76、结尾关闭28.76–31.06；播放器进度、播放/暂停、字幕、场景、素材偏移统一控制，不逐模板重置 |
| 本轮V5.2修正 | 已修媒体视口响应式缩放引起的字幕裁切；调整播放/暂停符号及交互；缩小来源标识、移除冗余大标题；T4以媒体为主，避免大块伪文档盖住真实资料 |
| Owner 验收 | Owner认可连续观看的“视频感”，允许以V5.2作为**当前基线冻结**；仍指出画风有可继续调整之处，未来视觉优化不构成对本冻结文件的返修命令 |

## 3. Review 证据与剩余缺口

- **`DIRECT_READBACK`：** 本轮GitHub主线冻结文件与PR候选文件的blob都是 `f002fd3a3fea24352c8eddb63d8f265014a9e93b`，源码对等；一个 `canvas#view`，没有第二个 `#qt`，没有第三方视频数据。
- **`BEHAVIORALLY_VERIFIED`（上一轮真实Chromium技术QA）：** 1440px下T1/T4/T6画面截图检查，27秒至31.06秒实速自动结束，真实MP4播放时间增长及暂停，本地PNG槽位导入，浏览器脚本异常0。**没有对完整31秒从0秒起的1×实时播放、所有视频格式、完整音画制作作出已PASS宣称**；私有媒体版本与GitHub无媒体源码需分别理解。
- **`OWNER_REPORTED`：** “样式还有可以调整的地方，但是这版先冻结留档”。这是“版本接受/冻结”而非“全部视觉细节终稿”。
- **仍未完成：** 真实节目4–6分钟时序、选题与完整分镜对应、素材来源/权利/禁止同源重复、口播润色与配音、SRT字幕实际同步、Remotion/FFmpeg导出成品MP4、正式成片完整视觉Story-Fit、跨设备长片稳定性、公开发行审核。
- **项目正式红线不变：** `CW0005_R3=RETURN_OWNER_VISUAL_STORYFIT`、`CW0005_VISUAL_STORYFIT_HOLD`、`G1_NOT_PASS`、`G2_NOT_AUTHORIZED`、`R4_NOT_AUTHORIZED`、`NO_PUBLISH`；素材使用权 `PARTIAL`。不能用本次模板冻结覆盖这些项目状态。

## 4. 当前 Gate、下一步和执行边界

- **GATE_ID：** `CWS-V52-TEMPLATE-BASELINE-FREEZE-20261017`
- **OBJECTIVE：** 保全已获Owner认可的V5.2源码为可恢复且可追溯的版本。
- **MAX_ENDPOINT_THIS_ROUND：** 只读核验PR V5.2文件；原样复制其无媒体HTML到 `main/visual/frozen/`；更新main 当前状态、Handoff、Decision和冻结报告；PR评审说明；读回校验。
- **MANDATORY_REVIEW_STOP：** 完成源码与记录冻结，停止。**不执行新视觉修改、正式素材获取、真实视频生成或GitHub PR合并**。
- **TARGET_AND_SCOPE：** `entropy-student/project` 的 CWS 文档与冻结版单一HTML，其他项目路径及Owner本地/VPS不变。
- **PREFLIGHT / REQUIRED_EVIDENCE：** 读Governance v0.2.7、CURRENT_STATE、HANDOFF、STYLE_LOCK、PR V5.2源 blob及PR Draft状态，保留两端相同blob的GitHub实际回读。
- **ACCEPTANCE_CRITERIA：** 冻结文件存在于main，内容与PR源逐字一致，没有第三方媒体，当前状态/唯一Handoff/决策均指向本冻结文件并且明确正式制片未放行。
- **ROLLBACK/RECOVERY：** 任何未来候选不改冻结副本；必要时从 `main` 的固定路径重新取回exact blob；本轮不删除项目资料。
- **OWNER_ONLY_ACTIONS：** 无需进一步人工操作；公开商用、正式R4、实际付费、不可逆删除和未来合并另需授权。
- **REVIEWER_TO_EXECUTOR_RELAY：** 未来直接读取本文件和顶部的`REVIEWER_HANDOFF_CURRENT`，以`main/visual/frozen/storyboard-v5-2-20261017.html`作为冻结基线。禁止以老PR的V3/V4近似Mac壳重新起步。
- **EXECUTOR_TO_REVIEWER_RELAY：** 归档blob与源blob一致的证据、main提交指针、PR不合并、素材/制片边界不变，后续优化另建非覆盖候选。
- **NEXT_STEP：** 在不变动冻结版的前提下，将镜头脚本/真实来源合法素材映射为T1–T6的镜头配置，并验证4–6分钟声画与自动输出；或先就明确的视觉细节启动独立`V5.3`精修。两条都不能在没有新Gate时自动开工。

**状态：`TEMPLATE_V5_2_FROZEN / MAIN_ARCHIVED / FORMAL_PRODUCTION_STILL_HOLD`。**
