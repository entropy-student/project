# Conversion Leak Audit — Design System

Status: `FROZEN_G3_5`

Design direction: **Editorial Diagnostic Console**

目标：像一个可信、克制、证据优先的专业诊断工具，而不是 AI chatbot、SEO 工具目录或企业后台。

## 1. Visual principles

1. **Evidence > score**：事实卡片比总分更重要。
2. **Hierarchy > decoration**：信息层级优先于装饰。
3. **Calm confidence**：专业但不沉重。
4. **Signal color has meaning**：颜色用于状态，不做无意义渐变。
5. **Whitespace is trust**：避免把结果页做成密集仪表盘。
6. **Motion explains state**：动效只解释扫描进度、展开与反馈，不做炫技。

## 2. Color tokens — first direction

最终 high-fidelity 可微调，但语义先冻结。

```text
--bg-canvas:        #F6F7F5
--bg-surface:       #FFFFFF
--bg-subtle:        #EEF0EC

--text-primary:     #111412
--text-secondary:   #5D655F
--text-muted:       #828A84
--border-default:   #D8DDD8

--accent-primary:   #FF6338   // signal orange
--accent-hover:     #E94F28
--accent-soft:      #FFF0EA

--success:          #18794E
--success-soft:     #E9F7EF
--warning:          #A15C00
--warning-soft:     #FFF3D6
--danger:           #C33D3D
--danger-soft:      #FCECEC
--info:             #2F63C7
--info-soft:        #EAF0FC
```

原则：
- Hero 只允许一个主要强调色；
- issue priority 不靠彩虹色区分类别；
- 红色只给真正错误/高风险状态；
- `ISSUE` 不等于“danger”，多数 issue 用中性/橙色表达。

## 3. Typography

推荐采用系统可获得的现代 sans-serif，避免依赖稀有字体。

层级：

```text
Display: 56–64 / 0.95–1.05 line-height desktop
H1:      44–52
H2:      32–40
H3:      22–28
Body L:  18–20
Body:    16
Meta:    13–14
```

移动端：
- Display 38–44；
- H1 34–40；
- Body 保持 16，不缩到 14。

重要：Finding title 不用过度粗体；Observed Fact 才是结果阅读主线。

## 4. Spacing

采用 4px base grid。

核心 token：

```text
4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96
```

页面 section desktop 推荐 `96–128px` 垂直空间。
Mobile `56–80px`。

## 5. Radius / shadow

```text
small control: 10px
card:          16px
large panel:   20–24px
pill:          999px
```

Shadow 极轻：
- 默认用 border + surface hierarchy；
- hover 只增加轻微 elevation；
- 不使用大面积玻璃拟态。

## 6. Core components

### URL Scan Form
- 单一输入；
- primary button；
- trust microcopy；
- inline validation；
- desktop 可水平；mobile 堆叠。

### Trust Strip
最多 4 个点：
- Public pages only
- No admin access
- No install
- No website changes

避免 icon wall。

### Platform Compatibility Strip
首页可展示主要独立站平台标识，用于快速回答“我的站能不能扫”。

可包含：
- WordPress / WooCommerce；
- Shopify；
- Wix；
- Squarespace；
- BigCommerce；
- `+ more`。

必须表达为兼容性提示，不得暗示官方合作或深度平台接入。

### Finding Card
结构固定：

```text
priority
finding title
observed fact
why it may matter
first move
[view evidence]
```

Evidence 默认不直接占满卡片，进入 drawer/detail。

### Evidence Block
视觉强调 `Observed` 与 `Source`，而不是营销 copy。

### Progress Step
真实阶段，不显示假百分比。

### Free vs Full Comparison
只展示增量价值，避免 feature checklist 过长。

## 7. Layout

### Homepage desktop
12-column grid；max width 1180–1240px。

Hero：
- 左侧 6–7 columns：problem + URL form；
- 右侧 5–6 columns：真实感 report preview，而不是抽象插画。

### Result page desktop
推荐 3/9 或 4/8：
- 左：summary / navigation；
- 右：findings。

但 Top 3 第一屏不做复杂 dashboard。

### Mobile
单列；
Finding card 必须在无需横向滚动时读完标题 + observed fact。

## 8. Motion

允许：
- form submit feedback 150–200ms；
- card hover 120–180ms；
- drawer 200–280ms；
- progress state transition 200–350ms；
- evidence highlight / skeleton。

禁止：
- hero 大面积粒子；
- AI 光球；
- 无意义数字滚动；
- fake scanning terminal；
- parallax 影响输入任务。

## 9. Accessibility baseline

- keyboard focus visible；
- semantic labels；
- color 不作为唯一状态信号；
- controls target ≥ 44px；
- contrast 按 WCAG AA 方向检查；
- reduced motion；
- error message 与字段关联。

## 10. Brand / logo boundary

Current blue bar-style mark is **placeholder only** and must not be treated as frozen identity.

Final symbol should:
- stay minimal and geometric;
- remain legible at favicon scale;
- convey a gap / interruption / leak plus inspection/evidence;
- work in monochrome;
- avoid generic analytics-bar-only meaning;
- avoid shopping-cart, magnifier and AI-sparkle clichés.

Detailed brand contract: `BRAND_IDENTITY.md`.

## 11. clone-ui boundary

clone-ui 只能输出：
- reference layout；
- tokens；
- component visual pattern；
- motion inspiration。

不能：
- 直接复制参考站组件到 production；
- 覆盖 WordPress 基线；
- 为视觉相似改变 Scanner / API / state contract。

后续高保真必须重新映射到本 Design System。
