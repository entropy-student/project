# Conversion Leak Audit — Visual Acceptance

Status: `FROZEN_G3_5_ACTIVE_FOR_G4_5`

视觉验收目标：把“高保真”从主观感觉变成可重复检查。

## 1. Golden viewports

Desktop:
- `1440 × 900`

Mobile:
- `390 × 844`

如后续需要补 Tablet，再单独加入，不在首版扩大范围。

## 2. Golden screens required before PASS_G3_5

至少：
1. Home desktop
2. Home mobile
3. Scan progress desktop/mobile
4. Scan incomplete / error
5. Free Top 3 desktop
6. Free Top 3 mobile
7. Issue evidence detail
8. Full report shell

Golden screen 必须由 Owner 明确批准后才成为机器视觉基准。

## 3. Visual invariants

Codex 实现时以下结构不得自行改变：
- Hero primary message order；
- URL form primary position；
- trust microcopy directly adjacent to form；
- Top 3 card information order；
- evidence as first-class element；
- paid expansion after free value；
- mobile single-column priority；
- no giant total score as first visual center。

## 4. Pixel tolerance policy

视觉回归不追求“每像素完全相同”，但必须限制 drift。

建议：
- 使用 Playwright screenshot；
- stable fonts / viewport / animation disabled；
- deterministic fixture data；
- visual diff threshold 由首版基准实测后冻结；
- 首次建议从非常严格的低阈值开始，再根据 anti-aliasing 噪声调整。

禁止为了让截图测试通过而把 threshold 放宽到失去意义。

## 5. Component visual acceptance

### URL form
- input/button baseline aligned desktop；
- mobile full-width stack；
- focus state visible；
- validation 不引发布局大跳动；
- trust strip 视觉弱于 CTA，但可发现。

### Finding card
- title / observed fact / why / action 层级明显；
- evidence CTA 可见；
- priority 不靠红黄绿彩虹系统；
- card 不堆满 icon/badge；
- 三张 card 在同屏有清晰 rhythm。

### Progress
- 不显示假 percent；
- 当前阶段视觉明确；
- reduced motion 可用；
- skeleton 不模拟不存在的结果内容。

### Error / incomplete
- 不能看起来像普通 ISSUE；
- 显示 retry/action；
- 不使用恐吓式 red alert 除非确实是输入安全拒绝。

## 6. Responsive acceptance

必须检查：
- 1440 × 900
- 1280 × 800
- 390 × 844
- 360 × 800

Golden 只固定 1440 与 390；其他 viewport 做 layout regression。

不允许：
- 横向 overflow；
- CTA 被固定元素遮挡；
- Evidence table 超出屏幕；
- body text < 16px；
- 关键 CTA tap target < 44px。

## 7. Content fidelity

视觉实现不得偷偷改产品文案含义。

特别保护：
- claim boundary；
- public pages only；
- no admin access；
- no guaranteed uplift；
- fail-closed explanation；
- Free vs Full 增量边界。

文案调整如改变承诺，必须 RETURN Reviewer。

## 8. clone-ui acceptance boundary

若使用 clone-ui：
- 参考站截图/结果只进入 `references/`；
- 先转换为 Design System token / component pattern；
- production 不直接依赖参考站 clone 代码；
- clone 后如果引入 global CSS drift、功能 regression、第三方依赖污染，则整项 RETURN。

## 9. Reviewer visual checklist

Reviewer 验收顺序：

```text
1. hierarchy
2. comprehension
3. trust/proof visibility
4. free Aha visibility
5. responsive
6. states
7. design fidelity
8. motion
9. polish
```

不是先挑 2px spacing，再忽略产品路径。

## 10. G4.5 PASS

必须同时：
- FUNCTIONAL_ACCEPTANCE PASS；
- golden screenshot diff PASS；
- responsive PASS；
- Owner 对核心高保真方向未提出重大视觉异议；
- Reviewer 确认没有因“更像参考站”造成架构/功能污染。
