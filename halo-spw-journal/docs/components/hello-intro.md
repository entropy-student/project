# Hello Intro

独立、零依赖的原生 Web Component。可用于普通 HTML、Vue、React、Astro、Halo 等站点，不需要引入整套主题。

```html
<link rel="stylesheet" href="/components/hello-intro/hello-intro.css">
<script type="module" src="/components/hello-intro/hello-intro.js"></script>
<noscript><style>spw-hello-intro{display:none}</style></noscript>
<spw-hello-intro greeting="Hello" target="site-content"></spw-hello-intro>
<div id="site-content" tabindex="-1">你自己的网站内容</div>
```

为了首帧直接显示问候，可在组件内预置与 JS 模板一致的 spw-hi-screen 标记，Halo 已这样接入。CSS 应在 head 中加载。颜色通过 `--hello-bg`、`--hello-fg` 设置；greeting 只作为文字，不作为 HTML 注入。

当前为第二版：固定覆盖层，不占文档高度。Hello 以 700ms/250ms 入场，随后自动切换 Bonjour、Ciao、Olá、こんにちは、Hallå、Guten Tag、你好，再以 800ms 弧形揭幕结束。完整节奏约 3 秒。动画期间以 `html[data-spw-opening]` 短暂禁止页面滚动，结束、跳过、导航或 5.5 秒超时均释放。

原生锚点深链接不显示开场；同一文档中的局部导航不重播，全新加载首页可再次看到。减少动态模式直接显示内容。幕布开始离开时及完成时派发幂等 `document` 事件 `spw:opening-reveal`，供第二幕开始条带和 Canvas 动画。脚本注册时已设置 `body[data-spw-opening]`，用于第二幕等待。

视觉与编排来源：https://ansyn.me/ ，源码：https://github.com/7-an/ansyn-lab/blob/main/src/lib/page-transition.ts 。本组件只移植开场时序与几何，不依赖原导航、Lenis 或 Astro；颜色由 CSS 变量控制。
