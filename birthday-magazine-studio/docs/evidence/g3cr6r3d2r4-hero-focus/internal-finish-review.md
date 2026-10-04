# Hero 双图焦点窗口 — 内部 advisory finish review

## Disposition

**Candidate，可交 Owner 验收。** 所查看的最终 Hero 证据未显示必须修复的 CTA 遮挡、横向越界或静态回退缺失。本文件仅为内部 advisory，不是官方 Reviewer 决策；`ownerVisualFreeze` 仍为 `PENDING`。

## 视觉与实现

读取本目录 `DESIGN.md`、`qa-report.json`、`round2/browser.json` 及当前 `home.css` / `home-motion.js`。直接查看已有 desktop default / pointer-right / B-clear / reduced，以及 mobile default / B-clear / reduced / no-JS Hero 截图。

桌面窗口右移后显示全景对应的另一部分，背景构图保持稳定；透明边框没有变成独立重居中的缩略图。Mira 与 Lena 清晰帧明显不同。源码中的清晰层与模糊层共用尺寸、object-position、缩放及同步动画起点，只有窗口裁切跟随鼠标；装饰层不捕获点击。手机窗口固定。标题、说明和 CTA 在所查看帧中清晰、位置稳定，窗口与正文有间隔。

源码为 20 秒双图周期，每图清晰停留约 8 秒，失焦／缩放／交叉淡化集中在切换区间；离屏、页面隐藏和 reduced motion 时暂停。这里依据源码和已有状态记录判断时序，没有自行播放或测试连续动画。

## 回退与冻结边界

已查看的 desktop reduced、mobile reduced / no-JS 帧保留原静态摄影、标题、说明和按钮，不依赖窗口跟随或双图初始化。浏览器报告的八上下文均为 1440px / 375px，无错误、失败、损坏图片或横向溢出；Preview 与业务交互计数为零。

已有 QA 记录 `AUTOMATED_CHECKS_PASS`，包括非 Hero CSS／JS 投影一致、Preview PHP 和受保护运行态一致、五项 R2 图片不变、产品 USD39.99 与订单／jobs／model 冻结。本 review 未重新计算哈希或操作运行态；这些边界结论引用保存的检查证据。应用修改范围记录为 `home.css` 与 `home-motion.js`，新增生图调用为零。

## Blockers 与限制

**未发现需开启新修补循环的真实阻塞项。** 同坐标窗口展示的是全景局部：默认或切换后的帧可裁到封面字或人物边缘，不能把它描述为窗口内始终展示完整封面。手机轻量裁切与桌面完整场景的比例也不同，但每个平台内部的两层对应关系保持一致。

截图和几何记录不能证明连续跟随手感、物理手机帧率或 Owner 对裁切与切换观感的满意程度。这些仍属于最终视觉验收。未访问浏览器、添加测试、重新截图、修改应用／历史文档／运行态或提交 Git；仅新增本报告。
