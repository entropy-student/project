# Curious World Studio｜V5.6 T6 数据通用化：接口与自检（问题⑨）

> **Gate**：`CWS-V56-T6-DATA-GENERALIZATION-20261018`  
> **结果**：`PASS_CANDIDATE / REAL_CHROMIUM_COMPONENT_QA_PASS / OWNER_PRODUCTION_UNVERIFIED`  
> **权限边界**：仅原问题⑨；停止于候选与技术自检。不允许改动冻结版本、合并 PR、制作/发布正式影片或继续新增功能。

## 目标与来源

- 原版 Mac 外壳、唯一全局播放时钟、T1～T5、V5.4 JSON 导入与素材关联、V5.5 多字幕/旁白全部保留。
- 来源 V5.5：`curious-world-studio/visual/content-template-lab/storyboard-v5-5-cues-narration.html`，Git blob `bbc6f40c1dd6bf1cc4b1c8ab4f55f49e0a13881f`。
- V5.2 冻结资产：`main:curious-world-studio/visual/frozen/storyboard-v5-2-20261017.html`，blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`，**不修改**。
- 本轮 V5.6 只增加 T6 参数、计算、数据校验与 T6 内部布局；分镜 Schema 仍是 `CWS_STORYBOARD_V2`，**不升级协议版本**，老 V1/V2 数据仍可导入。

## 新增能力

一段 T6 镜头可用的数据结构：

```json
{
  "template": "T6",
  "dataMode": "change",
  "dataMetrics": [
    {"label": "2024", "value": 100, "unit": "件"},
    {"label": "2025", "value": 80, "unit": "件"}
  ],
  "dataScaleMax": 100,
  "dataPrecision": 1,
  "dataNote": "用于说明比较口径的字幕化备注",
  "dataReference": "模拟数据，仅供测试"
}
```

此示例仅为 `shots[]` 中 T6 的部分字段，不能作为完整分镜导入。交付包里有六套可直接导入的完整示例 JSON。

| 参数 | 定义与约束 |
|---|---|
| `dataMode` | `bars` 默认柱形、`delta` 后者减前者、`ratio` 后者除以前者、`change` 相对变化率。缺失时沿用原 V5.5 柱形。 |
| `dataMetrics` | 2～8项数据，各含 label、有限 number value 与 unit。**必须同一计量单位与口径**，且不允许其他单位混入。支持负值（负值以中心零轴柱绘制）；金额、人数、时间、百分比只由实际数据与 unit 决定。 |
| `dataScaleMax` | 正数表示柱形基准（含零与正负区间）；不能小于数据的最大绝对值，否则**拒绝导入**而非错误裁切。可不提供，自动取合理绝对值基准。 |
| `dataPrecision` | 0～3 位小数，省略默认最多2位；以显示格式控制，不改变内部数值计算精度。 |
| `dataNote` / `dataReference` | 说明数据口径、来源，不构成来源真实性或复用许可的自动证明。HTML 只用 textContent 展示，不直接渲染用户 HTML。 |

比较公式及限制：

- `bars`：2～8 组同单位柱形；超过两组用两列自适应紧凑版式。出现负值时使用**居中零轴**，以最大绝对值作刻度；不将负值当作普通正长度。
- `delta`：恰好两组，计算第二项减第一项；单位为 `%` 时结果标注**百分点**，避免与相对变化率混淆。
- `ratio`：恰好两组，计算第二项÷第一项，以**倍**标注。第一项须大于0，第二项不得为负。
- `change`：恰好两组，计算（第二项－第一项）÷第一项×100%，第一项必须大于0，支持正负增长率。
- 不同单位、零分母、非法模式、超出刻度、非法小数位、非有限/超过上限的数字、错误模板携带T6字段，全部**整单原子拒绝**；原有镜头与素材关联不被改动。
- 数据比率必须有相同计量口径；本轮不会自动汇率/单位换算，不会推断真实统计含义。**示例全为虚构数据，不应作为正式节目引用。**

## 技术测试与复查

- **源码语法：** 2/2 JS 模块可解析，GitHub 只保存无第三方媒体字节HTML。
- **真实 Chromium Playwright：** 46/46 项检查通过，涵盖旧 V2 原样 roundtrip、V1 迁移、多种数据场景（含正负值、8项、百分比、差值、倍数、变化率）、非法输入与原子拒绝、V5.5 多句字幕保留。
- **原版桌面画面**：使用 Canvas 内部实际像素（排除允许变化的T6媒体覆盖层），8/8 时间点与 V5.5 精确一致，包括开窗及关窗。此前用DOM截图发现两个时间点“不同”，是**截图混入新增 T6 画面本身**，已从测试方法中排除并复验。
- **整段播放**：同一轮核心 V5.6 版本此前的 Chromium 单次实速播放日志显示从0到31.06秒、暂停并关窗回桌面、JS异常0；随后只修订了 T6 `%` 差值显示成“百分点”。最后一次针对**最终字节**的长时播放脚本在运行器内超时，**不宣称该最终字节完成了再次完整实速回归**。46项组件/时轴/Canvas检查为最终文件所测。
- **边界**：没有在 Owner Windows Edge 做 `file://` 实机验证；测试容器策略禁止 `file://` 导航，改用Chromium `page.set_content`。没有验证真实 4～6 分钟完整旁白/MP4 输出、真实科研数据合法来源或正式成片Story-Fit。

## 版本与后续边界

- 当前 V5.6 是独立技术候选，**不是取代已冻结V5.2的正式基线**。仅在 Draft PR#144 中归档新文件，旧源码保留。
- 原14项问题中⑨的技术开发到此**停止**。⑤真实研究档案素材和⑭故事叙事留待新的Owner决策；⑪ QuickTime时间显示语义继续暂缓。**本轮不启动这些事项。**
- 正式 `CW0005 R3_RETURN / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH` 与第三方素材使用权`PARTIAL`不变。