# R4 Owner 手机录屏动效校准 — 内部 advisory finish review

## 1. 内部 disposition

**Candidate / 可交 Owner 连续动效验收。** 在本轮已有截图和源码中，未发现必须修复的 CTA 遮挡、横向溢出、阅读阶段缺失或静态回退内容缺失。本结论是内部视觉建议，不是官方 Reviewer 决策，也不代替 Owner 最终验收。Owner 最新继续执行授权与历史等待记录分别保留，不将新授权解释为最终 PASS。

依据为本 namespace 的 `DESIGN.md`、当前 `home.css` / `home-motion.js`、`round2/screenshots/` 中已保存的代表帧、`round2/browser.json`、`qa-report.json` 及 runtime before/after JSON。最终批次共有 125 帧；本 review 直接查看了其中 33 张代表截图，没有重启浏览器、自行采样、运行测试或修改应用源码。

## 2. 动效方向与可读性

- **Hero：** 桌面五个定时帧显示清晰原裁切 → 失焦 → 清晰放大裁切 → 失焦 → 清晰原裁切。模糊只作用于摄影层；标题、说明、标记和 CTA 始终清晰且位置稳定。手机清晰帧显示较小裁切变化，标题与按钮仍完整。源码具有清晰停留区间，并在离屏或标签页隐藏时暂停循环。
- **Editorial：** 两个桌面中间帧均已进入稳定阅读状态，正文和按钮清晰，产品跨页和封面完整。源码的分段进入与较小离场位移有明确稳定区间，手机强度更低。
- **Panel：** Preview 的 hold-start / hold-end 帧显示前景卡片随文档移动，背景场景在有界区间停留；说明始终可读。Offer 中间帧的人物、价格和按钮没有互相遮挡。QA 记录背景同屏位置误差小于 2px、前景移动约 350px；源码采用纵向 overscan，未引入横向放大。手机 Preview 两位人物的脸可见，Offer 保留 320px 场景高度，人物眼睛露在深色卡片上方。
- **Samples：** 三个桌面中间帧保留 R2 三项不同的 full-bleed 场景与标签；第一张的 enter / read-start / read-end / exit 帧明确区分入场、平整阅读和退场。报告记录三卡在 .42 / .50 / .58 均为平整状态，入场与退场约 ±20.48°。手机代表帧中三卡均可辨认，保持正常纵向次序。
- **Closing：** 桌面 early / left / mid / right / late 帧确认左图先出现，标题随后从左至右揭示，右图最后出现；后期标题完整。CTA 在全部五帧保持清晰、同一位置，图片没有进入标题或按钮区域。375px 版本为完整静态标题与两图、无 sticky；本 review 不声称手机复现桌面的分段揭示。

上述静态场景继续沿用已接受的 R2 五项原创生成资产、暖纸色、衬线字体、深色胶囊导航与交替图文布局。手机品牌保持单行可读，菜单为原生紧凑面板。此次没有提出静态重新设计。

## 3. Craft floor、回退与冻结边界

直接查看的 desktop reduced Closing、mobile reduced full 和 mobile no-JS full 均显示完整标题、摄影场景、三项样本、CTA 与页尾，没有隐藏内容或空白动画等待区。源码的静态默认值、reduced-motion 覆盖及静态 Closing 正常流与截图一致。无 JS 时 Preview 仅证明默认展示完整；本轮未重测其互动功能。

已有浏览器记录为 1440px / 375px 的 normal、reduced、no-JS、controller-unavailable 共八上下文，错误与失败为零，报告记录无损坏图片与横向溢出。自动化结果为 `AUTOMATED_CHECKS_PASS`；它与本内部视觉结论分开。

读取并比较已保存的 runtime before/after JSON，Home 内容、footer、theme mods 和受保护 runtime hashes 一致；八个 Gutenberg Groups、六个锚点及单一 Preview 保留。展示控制器查询范围为首页摄影、split、sample、Closing 和导航标签，不含 Preview 表单、选图、commerce 或 auth 处理。

冻结边界结论依赖已保存的 readback / QA 证据，本 review 未重新计算运行态哈希。报告记录订单数 1 → 1，generation jobs / model calls / imagegen calls / 支付 / checkout submission / add-to-cart / production deploy / shared infra mutation 均为零，Preview 交互未重放。

## 4. 必须修复项与证据说明

**本次所查看的最终代表帧中，没有新增必须修复项。** 应用源码在 round1 后未追加修补。执行方说明 round2 校正的是定时截图采样：按实际 CSS animation.currentTime 等待清晰、失焦、裁切和重聚焦区间，未 seek 动画。旧 round1 采样失败观察应作为历史证据保留，不由本 review 改写。

手机 Panel 和 Closing 的静态简化属于当前明确记录的范围；若以后要求手机也执行桌面停留或 Closing 分段顺序，应另行确认范围。这里不把静态手机截图当作该顺序已实现的证明。

## 5. Handoff 限制

截图与状态记录能证明所采样的裁切、可见性和分段状态，不能证明连续滚动的流畅度、真实手机帧率、录屏观感或 Owner 对动效强度的满意程度。本轮未重新爬取参考站、未操作浏览器、未触发业务行为，也未修改历史文档、运行态或 Git。

**Owner live motion perceptibility 与 formal Reviewer decision 仍为 PENDING。** 本 advisory 支持提交当前候选进行正式审阅，不授予正式通过或生产发布结论。
