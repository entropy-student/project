# Curious World Studio｜V5.4 分镜 JSON 导入与素材 ID 映射

## 本阶段解决的问题

原来 HTML 只导出部分镜头信息，不能重新导入并恢复镜头、素材关联、时长等配置。V5.4 提供单文件浏览器内的 `CWS_STORYBOARD_V1` 数据接口，保留六模板、原 Research Aqua 桌面和唯一 Master Clock。**只处理原表第 ⑬ 项**，没有引入多字幕 cue、复杂数据图表、音轨渲染或新的模板。

## 工作流程

1. 在 HTML 中点击 **导出 JSON**，得到 `CWS_STORYBOARD_V1.json`。或者参考提供的 `CWS_STORYBOARD_V1_示例.json` 编辑。
2. 编辑 JSON 内 `film.fileName`、`shots`、`assets` 等字段并保存。
3. 在 HTML 中点击 **导入分镜 JSON**，选择配置文件。页面在整体校验成功后一次性更新镜头、时间轴、字幕和素材登记，校验失败则原镜头与已加载素材都不动。
4. 每个镜头的 `assets` 放素材 ID，例如 `"rolls"`；`assets` 顶层列表以同一 ID 登记 `fileName`、`mimeType`、`rights`、`sourceRef`。一个 ID 可以出现在多个图像镜头里。如果真实视频不允许跨镜头复用，同一源也不得通过改 ID 规避项目规则。
5. **本地文件不会写入 JSON**。重新导入后页面显示“未关联素材”，用各镜头槽位选择文件，或用“批量关联本地素材”选择本地文件，按登记的**精确文件名且唯一匹配**关联。不匹配或重名歧义不会自动猜测；不会访问任意磁盘路径、远程 URL 或读取浏览器不允许访问的文件。
6. 缺失素材仍显示显式占位，而不是隐藏缺失并声明成片完成。完成合法素材的真实映射、音画生产、权利验证是独立后续阶段。

## 主要字段

| 字段 | 说明 |
|---|---|
| `schema`, `version` | 固定 `CWS_STORYBOARD_V1`、`1`，禁止混用旧导出格式 |
| `film.fileName` | 原版 QuickTime / 桌面显示的文件名（不超过 40 字） |
| `timeline` | `intro=4.76`, `outro=2.30` 固定基线；`total` 等于两者加所有镜头时长，用于校验（不单独创建时钟） |
| `assets[]` | `id`、`fileName`（仅名称，无路径）、`mimeType`、`rights`、`sourceRef`（仅留档注记，不发请求） |
| `shots[]` | `id`、`template`、`duration`、`assets` 引用列表、`title`、`caption`（仅当前单句）、`label`，可选 `assetOptions`/`compareLabels` 等 |
| `assetOptions[]` | 各槽 `fit=contain/cover`、`inPoint>=0`、`endBehavior=hold/loop` |
| `stages[]` | T5 必须三阶段，`label`、`name`、`duration`、`inPoint`，阶段时长之和必须等于镜头时长 |
| `dataMetrics[]` | T6 两项以上指标及 `dataScaleMax`, `dataNote`；尚不等于未来第⑨项数据泛化 |

## 约束与错误处理

- 校验要求每个镜头 ID 唯一、每个引用都存在素材登记且槽位数正确；不接受额外未知字段、恶意路径、未知 MIME、重复素材 ID、非法时长或 T5 阶段时长不一致。
- 最多 240 镜头、600 素材登记、总片长最多 3600 秒，JSON 文件输入最多 2MB；这些是本轮单文件编辑器的保守上限，不是频道视频必须如此长。
- 本地文件只用于这次打开的浏览器会话；切换分镜 JSON 时旧 Blob URL 被释放，避免误把不相关的媒体错误保留在新分镜里。
- `rights=UNVERIFIED` 不代表授权；`LINK_FOUND`、`CONTENT_VERIFIED` 与 `REUSE_RIGHTS_VERIFIED` 仅是用户提供的登记值，本工具不会自动认证真实性。
- 当前字幕字段仍每镜头一条，字幕 cue / 音轨数据结构属于未授权的 ⑩ 号后续任务。
- 不自动上传文件至 GitHub，也不包含私有参考视频、凭据、下载器或隐藏联网。

## 真实 QA 及未验证事项

- 使用真实 Chromium `page.set_content` 执行 43 项接口、错误输入及 UI 测试，**43/43 PASS**：包含正常 JSON 导出/导入、结构完整往返、内容修改、镜头数变化、长片跳转/关闭、8组失败输入的原子回滚、素材 ID 绑定、精确文件名批量重连、异镜头字幕警告。
- 另外在 0/1.5/3.5/5.8/17/23/29.5/31.06 秒对 V5.3.1 和 V5.4 的原版 Mac Canvas 做像素级比较，**8/8 完全相同**。
- Chromium 的 `file://` 打开被测试环境管理员策略阻止，改用 `page.set_content`。**用户 Windows Edge 双击打开未实际验证**；完整 4–6 分钟真实音画连续渲染、正式 MP4、TTS/SRT、权利和内容故事仍未验收。
- 本轮仅新增候选，冻结 main 中的 V5.2 不变，PR #144 保持 Draft、未合并，正式 CW0005 R3 视觉 RETURN/G1 HOLD/G2、R4 未授权/NO_PUBLISH 不变。

## 独立复查补充（同一V5.4源码）

- **43/43** 浏览器分镜接口与JSON输入测试通过；**6/6** 真实本地媒体及安全测试通过（1秒MP4停末帧、T5第二阶段5秒MP4正确起点、非法配置不丢已绑定媒体、JSON原型污染字段被拒、无JavaScript异常）。
- **8/8** 对原版Research Aqua播放画布的逐帧像素对照与V5.3.1完全一致（0, 1.5, 3.5, 5.8, 17, 23, 29.5, 31.06秒）。
- 正常导入完整重建shots+时间轴+素材登记；导出再导入语义、字段完全一致；批量关联通过精确文件名唯一映射；若没有本机字节，页面明确提示“未关联”；错误JSON在验证阶段即拒绝且原媒体对象URL不被释放。
- 使用Chromium `page.set_content` 验证。**file:// 导航被测试环境安全策略拦截，不能宣称在用户Windows Edge文件浏览器中通过实测。**
- 代码候选仅在隔离PR#144，main已冻结V5.2不覆盖。状态：`V54_TECHNICAL_CANDIDATE_PASS / OWNER_PRODUCTION_AND_LONG_MOVIE_UNVERIFIED`。


## 31.06秒全程一倍速复查

同一 V5.4 HTML 在独立真实 Chromium 中调用页面播放键，从 `t=0` 等待约32.6秒，捕获结果：
```json
{"time":31.06,"end":31.06,"playing":false,"shot":"S07","template":"T6","oneOriginalCanvas":1,"secondMacWindow":false,"contentViewportVisibility":"hidden","jsErrors":[],"passed":true}
```
本项以无版权媒体的占位槽位执行，**验证的是播放器的整段时间控制、关窗与脚本无异常**；不能替代实媒体填充的31秒观感验收或4–6分钟正式音视频导出。因运行容器单次命令超时，完整测试在同一执行轮通过进程日志读回结果，未将之前超时当作PASS。
