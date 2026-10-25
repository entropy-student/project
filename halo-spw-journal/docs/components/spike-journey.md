# SPW / spike 首页序章

独立的 `<spw-journey>` Web Component：动态五词与字符背景 → 滚动收拢 spike 署名 → 交互地球。只处理这一段首页内容，不接管网站导航或整站滚动。

## 接入

把 `journey.html` 的片段放在 Hello 之后、博客 `#spw-content` 之前，加载样式和模块：

```html
<link rel="stylesheet" href="/assets/journey/journey.css">
<!-- 此处插入 journey.html 全文 -->
<main id="spw-content" tabindex="-1">自己的博客内容</main>
<script type="module" src="/assets/journey/journey.bundle.js"></script>
```

同目录发布：

- `journey.bundle.js`
- `journey.css`
- `countries.json`
- `fonts/`（包含 WOFF2 与 OFL 授权文本）

运行时不需要 CDN、Node.js、Astro、Lenis 或原作者导航。`journey.html` 内部有 SPW 博客入口和 spike 署名；不要在这一段上方叠另一条固定导航，以免改变原动画构图。原博客导航在序章结束后出现。

## 与 Hello 对接

Hello 在此模块初始化前设置：

```js
document.body.setAttribute('data-spw-opening', '');
```

幕布开始揭开时派发：

```js
document.body.removeAttribute('data-spw-opening');
document.dispatchEvent(new CustomEvent('spw:opening-reveal'));
```

等待阶段，七条带动画处于 paused，Canvas RAF 也暂停；收到事件后开始。没有该 body 标记时模块直接运行。Hello 自身应使用覆盖层、不额外占一屏文档流。

## 保留的动效机制

- 五词是 Space、Pursuit、Infinity、Karma、Elusive，采用原场景的五处错落排版。
- 每个词实际生成七个水平裁切条带，65ms 错峰，以原缓动揭示；保留少量酒红条带和字符叠印。
- 原 3D simplex 噪声驱动字符跳动；离屏文字掩码生成 SPIKE 轮廓，字符 atlas 缓存减少逐帧文字排版开销。
- 随 native scroll，五词依次上移淡出，SPIKE 掩码以立方缓动缩到左上署名，最后与真实 DOM spike 衔接。
- 地球从下方大尺寸进入并收拢。Canvas 2D 绘制、d3 地理裁切、透视投影、国界和经纬线保持原机制。
- 支持地球内拖动、刷新率无关的指数惯性、轻微自动旋转、方向键、实时经纬度、城市平滑定位。
- 只有上海 `(31.2304, 121.4737)` 和深圳 `(22.5431, 114.0579)`。原香港、杭州、照片与图库、外链没有进入运行代码。

首页人物署名 spike，与 SPW 站名分开。第三幕介绍只采用姓名和五个主题词，不声称用户经历。

### 明暗与调色

`html.dark` 使用深蓝背景、奶油白文字；默认使用纸色背景、深蓝文字。强调色 `--sj-accent` 继承宿主 `--spw-accent`，独立使用时回退酒红。Canvas 通过 `--sj-paper`、`--sj-land`、`--sj-line`、`--sj-field`、`--sj-word` 与 DOM 共享颜色。

组件在初始化及宿主 html 的 `class`/`style` 改变后读取计算色值，MutationObserver 合并为单次 RAF；字符 atlas 仅重建颜色，不重新随机化掩码或排版。逐帧绘制不调用 `getComputedStyle`。断开时取消该 RAF 并断开 Observer。

## 生命周期与可访问性

- Custom Element 断开时取消 RAF、fetch、计时器、Resize 延时与事件监听，解除 Observer。
- `swup:visit:start` / `astro:before-swap` 暂停；`astro:page-load` / `swup:page:view` / `swup:visit:abort` 幂等恢复。
- 每次只为自己的子节点设置样式；没有全局 html/body 样式或全局 `js` / `motion-ready` 类。
- 不拦截 wheel/touch 事件；地球 `touch-action: pan-y`，手机纵向滚动保留。
- 离屏与后台标签页暂停 Canvas 动画。
- `prefers-reduced-motion: reduce` 或 `?motion=reduce` 改为两段正常文档布局：静态文字场 + 静态地球；仍保留键盘与城市定位。
- JS 不可用时保留文字和静态布局；地图加载失败时显示提示，仍可用经纬线和城市。
- 键盘可通过“跳过序章”直接到博客，地球支持方向键。

原生滚动与原站 Lenis 的滚动手感存在有意差别，场景位置/插值/条带/地球算法保留；这样避免与 Halo 原滚动机制争夺控制。

## 调试接口

根 `<spw-journey>` 的 DOM 属性可供验收读取：

- `data-progress`: native scroll 场景进度 0–1。
- `data-scene`: `words` / `transition` / `world`。
- `data-map-ready="true"`: 本地地图数据完成加载。
- `data-reduced`: 减少动态模式。

点击城市时派发冒泡事件 `spw:city-focus`，`detail` 包含 `name`、`lat`、`lon`。没有照片弹层或外部跳转。

## 本地构建

```powershell
cd components/spike-journey
npm ci
npm run build
npm run check
```

生产只需要前述四组文件；`node_modules` 不随主题包发布。`package-lock.json` 锁定 d3-geo、esbuild 和三种 Fontsource 字体包。

## 参考与授权记录

动画与算法参考 `7-an/ansyn-lab`：`src/lib/original-hero-field.ts`、`src/lib/home-experience.ts`、`src/lib/globe-projection.ts`、`src/components/HomeExperience.astro`。本组件将其改为独立生命周期、SPW 配色与内容；去掉原图库及整站滚动控制。上游仓库授权核验/使用记录由项目 `design/spike-reference-20261025/` 保留，部署前应一并保存。

字体来自 npm `@fontsource/poppins`、`@fontsource/space-mono`、`@fontsource/chivo-mono`，使用同名字体的本地 Latin WOFF2；随附 `fonts/OFL-*.txt`。字体采用独立 SPW 名称与 `font-display: swap`，不影响博客字体。

## 验证边界

构建、语法与投影数学检查由此目录执行；真实浏览器中的三幕节奏、Halo 路由与移动端整体验收由站点集成完成。未经过实机检查前不宣称所有设备固定 60fps。
