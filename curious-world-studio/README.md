# Curious World Studio · 世界有点意思（暂定）

> **项目性质**：不露脸的真实发现 / 科技故事频道，当前为**研究协议 + 视觉规范的文档与原型模块**，不是可自动生成完整视频的成品系统。
>
> **项目目录名**：`curious-world-studio` 是项目代号；“世界有点意思”目前只是**频道名称候选**，未正式注册或最终确定。

## 一句话定位

像一个好奇心旺盛的朋友，发现了一件不可思议但真实存在的事情，忍不住打开资料给大家看，并弄明白它为什么会这样。

**核心原则：知识小众，问题大众；现场具体，过程有趣；证据真实，承诺兑现。**

频道向观众的承诺：**每期分享一个值得好奇的真实发现，让观众看见它、弄明白它，并清楚知道研究证实了什么、没有证实什么。**

## 当前组成

| 模块 | 权威文件 | 状态 |
| --- | --- | --- |
| 频道定位与边界 | [`docs/CHANNEL.md`](docs/CHANNEL.md) | 核心定位已确认，频道名称待定 |
| HF 选题方法 | [`research/HF_有趣发现_唯一主协议.md`](research/HF_有趣发现_唯一主协议.md) | 唯一选题主协议 v1.0 |
| 视觉风格 | [`visual/retro-mac-v1.2/docs/STYLE_LOCK.md`](visual/retro-mac-v1.2/docs/STYLE_LOCK.md) | 当前 v1.2 视觉基线，允许后续小细节修订 |
| 机读视觉参数 | [`visual/retro-mac-v1.2/config/design-tokens.json`](visual/retro-mac-v1.2/config/design-tokens.json) | 对应 v1.2 |
| 可交互预览 | [`visual/retro-mac-v1.2/preview/index.html`](visual/retro-mac-v1.2/preview/index.html) | 视觉原型，非渲染引擎 |
| 已知问题 / 决策日志 | [`docs/STATUS_AND_DECISIONS.md`](docs/STATUS_AND_DECISIONS.md) | 维护中 |
| Agent / Codex 入口 | [`AGENTS.md`](AGENTS.md) | 指向各权威文档 |

## 统一工作方式

**选题**：Hugging Face Daily Papers → 遍历论文 → 深挖具体实验与行为 → 标证据及素材/授权状态 → 按发现价值排榜；制作可行性另列榜。源站：<https://huggingface.co/papers>。

**视频视觉**：A — Mac OS X Tiger 时代 Aqua 桌面简短开场；B — 接近 QuickTime 7 的银灰播放器占满正文 16:9 画布，**B 内部**按旁白展示视频 / 图片 / 论文图表 / 证据；无第三个 C 状态。字幕单行，证据标注来源。

**边界**：未经 Owner 另行要求，不自动编写剧本、找商用素材或实现生产渲染；不把网页可观看的研究演示当作获准商用；不把作者的文字描述伪装成真实录像。

## 如何调用 Codex / Muse

把本项目目录设为 Agent 工作目录；输入：

```text
运行【HF-FIND】；模式=日常发现；范围=最近3个已完整发布的 HF Daily Papers 日榜。
按仓库唯一主协议执行；仅输出发现价值榜、制作优先榜、证据与素材状态、覆盖日志；不要写剧本或制作视频。
```

详见 [`AGENTS.md`](AGENTS.md) 与 [唯一主协议](research/HF_有趣发现_唯一主协议.md) 中的正式调用合同。

**只看样式**：直接在浏览器打开 `visual/retro-mac-v1.2/preview/index.html`。可在 B 模式中导入本地视频观察画框；这不代表版权、字幕声学对齐、渲染已通过。

## 当前阶段与后续

研究系统与风格基线已经建立；**未完成**真实视频生产流水线、逐镜头素材授权核验、完整字幕声学对齐、发布自动化。频道正式名称/Logo/最终视觉小修尚待确认。详见 [`docs/STATUS_AND_DECISIONS.md`](docs/STATUS_AND_DECISIONS.md)。

## 许可与权利

- `visual/retro-mac-v1.2/vendor/` 保存外部 **NovusGFX Retro Design System** MIT 许可声明和来源记录；请保留原版权声明。
- Mac OS X / QuickTime 是**时代视觉参考**，本项目目录不是 Apple 官方软件；不要混淆商标、截图及第三方媒体的许可。
- 项目生成的示例画面不是论文实验事实；任何论文视频/图片复用都需逐项核验权利。
- **本项目目录尚未选择统一的开源发布许可证**；所在项目库已有自己的可见性与治理规则，公开发布第三方素材需另行评估。