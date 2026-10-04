# G3CR6R3C Core Aha — Research Ledger

> Date: 2026-10-04
> Scope: Core Aha interaction only
> Runtime/source mutation: NONE
> Candidate count: 82
> Source ecosystems: 8

## Counting rule

Each counted entry was directly inspected through its source page, live/equivalent demo page, repository, or current platform documentation. Failed/unreachable source pages were excluded rather than counted. Variants/duplicates were not counted twice.

Grades here are role-specific for **Core Aha**, not general design quality:
- S: direct shortlist for the first “this is their magazine” moment;
- A: strong mechanism/reference or later-reader candidate;
- R: reject for Core Aha.

## Ledger

| ID | Ecosystem | Candidate / source | Primary pattern | Grade | Reuse status | Core-Aha judgment |
|---|---|---|---|---|---|---|
| C01 | Codrops | [Preview to Full Content Page Transition](https://tympanus.net/codrops/2021/04/07/preview-to-full-content-page-transition/) | shared-element preview→article | S | DIRECT_REUSE_OK | 最接近“预览物体成为完整内容” |
| C02 | Codrops | [Large Image to Content Page Transition](https://tympanus.net/codrops/2022/08/03/large-image-to-content-page-transition/) | large image→content slot | S | DIRECT_REUSE_OK | 同一图像跨布局连续变形 |
| C03 | Codrops | [Stack to Content Layout Transition](https://tympanus.net/codrops/2022/05/11/stack-to-content-layout-transition/) | image stack→content/gallery | S | DIRECT_REUSE_OK | 适合封面后出现纸张/跨页层级 |
| C04 | Codrops | [Cover Page Transition](https://tympanus.net/codrops/2022/07/06/how-to-create-a-cover-page-transition/) | cover→content reveal | S | REFERENCE_ONLY_REIMPLEMENT | 产品语义非常贴合，精确代码边界单独核验 |
| C05 | Codrops | [Fullscreen Clip Animation](https://tympanus.net/codrops/2023/03/14/fullscreen-clip-animation/) | fullscreen image→clipped layout | S | DIRECT_REUSE_OK | 适合照片变成版式而非换场 |
| C06 | Codrops | [Image To Grid Transition](https://tympanus.net/codrops/2022/05/19/image-to-grid-transition/) | image→grid | A | DIRECT_REUSE_OK | 可借用照片展开为多块版式的空间逻辑 |
| C07 | Codrops | [Responsive Grid Layout Transitions with GSAP Flip](https://tympanus.net/codrops/2026/01/20/animating-responsive-grid-layout-transitions-with-gsap-flip/) | responsive FLIP grid | A | DIRECT_REUSE_OK | 移动端重排证据强，叙事语义较弱 |
| C08 | Codrops | [Magnetic 3D Grid Interaction with Content Preview](https://tympanus.net/codrops/2021/04/21/magnetic-3d-grid-interaction-with-content-preview/) | 3D grid→preview | A | DIRECT_REUSE_OK | 有纵深但不像杂志生成 |
| C09 | Codrops | [Image Stack Intro Animation](https://tympanus.net/codrops/2020/11/24/image-stack-intro-animation/) | stack entrance | A | DIRECT_REUSE_OK | 纸张堆叠感可借用 |
| C10 | Codrops | [On-Scroll 3D Stack Motion Effect](https://tympanus.net/codrops/2024/03/06/on-scroll-3d-stack-motion-effect/) | scroll 3D stack | A | DIRECT_REUSE_OK | 可做次级层叠，不宜作为首个 Aha |
| C11 | Codrops | [Thumbnail Flow with GSAP MotionPath](https://tympanus.net/codrops/2026/06/04/creating-a-thumbnail-flow-animation-with-gsap-motionpath/) | thumbnail flow | R | DIRECT_REUSE_OK | 运动强但产品语义弱 |
| C12 | Codrops | [Full Image Reveal Effect](https://tympanus.net/codrops/2018/06/12/full-image-reveal-effect/) | mask/reveal | A | DIRECT_REUSE_OK | 适合作为局部封面揭示 |
| C13 | Codrops | [Multi-Layer Page Reveal Effects](https://tympanus.net/codrops/2016/06/01/multi-layer-page-reveal-effects/) | layered page reveal | A | DIRECT_REUSE_OK | 纸层感强但年代较早 |
| C14 | Codrops | [Motion Reveal Slideshow](https://tympanus.net/codrops/2018/07/26/motion-reveal-slideshow/) | slideshow reveal | R | DIRECT_REUSE_OK | 更像轮播而不是成刊 |
| C15 | Codrops | [Creative WebGL Image Transitions](https://tympanus.net/codrops/2019/11/05/creative-webgl-image-transitions/) | WebGL distortion | R | DIRECT_REUSE_OK | 视觉抢戏、实现/降级成本高 |
| C16 | Codrops | [Rapid Image Layers Animation](https://tympanus.net/codrops/2020/04/07/rapid-image-layers-animation/) | rapid image layers | R | DIRECT_REUSE_OK | 像视觉特效，不解释产品 |
| C17 | Codrops | [Tooltip to Gallery Transition](https://tympanus.net/codrops/2022/12/07/tooltip-to-gallery-page-transition/) | small preview→gallery | A | DIRECT_REUSE_OK | 共享元素思路有用，入口语义偏作品集 |
| C18 | Codrops | [Rotated Overlays](https://tympanus.net/codrops/2019/04/18/how-to-create-and-animate-rotated-overlays/) | rotated overlays | R | DIRECT_REUSE_OK | 装饰性高于产品意义 |
| C19 | Codrops | [Make Way Grid Effect](https://tympanus.net/codrops/2022/06/28/make-way-grid-effect/) | grid displacement | R | DIRECT_REUSE_OK | 互动有趣但不像杂志 |
| C20 | Codrops | [Tiny Grid Layout Animation](https://tympanus.net/codrops/2022/07/13/tiny-grid-layout-animation/) | tiny grid→layout | A | DIRECT_REUSE_OK | 可参考信息展开 |
| C21 | Codrops | [Animated Grid Previews](https://tympanus.net/codrops/2018/10/31/animated-grids-layout/) | animated grid preview | R | DIRECT_REUSE_OK | 预览感强，成刊感弱 |
| C22 | Codrops | [Menu to Grid Layout Animation](https://tympanus.net/codrops/2022/09/19/menu-to-grid-layout-animation/) | list/menu→grid | R | DIRECT_REUSE_OK | 不匹配输入→礼物的主线 |
| C23 | Codrops | [Unreveal Effects for Content Previews](https://tympanus.net/codrops/2022/11/01/unreveal-effects-for-content-previews/) | unreveal/mask | A | DIRECT_REUSE_OK | 可用于封面文字/照片揭示 |
| C24 | Codrops | [Fullscreen Pageflip Layout](https://tympanus.net/codrops/2012/12/11/fullscreen-pageflip-layout/) | page flip | A | DIRECT_REUSE_OK | 适合阅读器，不适合第一次 Aha |
| C25 | Codrops | [Image Stack Entrance Animations](https://tympanus.net/codrops/2024/04/10/image-stack-entrance-animations/) | stack entrance variants | A | DIRECT_REUSE_OK | 纸张/照片堆叠参考 |
| C26 | Codrops | [Expanding Image within Typography](https://tympanus.net/codrops/2024/04/02/on-scroll-expanding-image-animation-within-typography/) | image expansion in type | A | DIRECT_REUSE_OK | 高级但依赖滚动，产品理解较慢 |
| C27 | Codrops | [Palmer Draggable Product Grid](https://tympanus.net/codrops/2025/09/01/recreating-palmers-draggable-product-grid-with-gsap/) | drag grid | R | DIRECT_REUSE_OK | 手势重、杂志语义弱 |
| C28 | Codrops | [Infinite GSAP Gallery with Flip](https://tympanus.net/codrops/2026/07/30/building-an-infinite-gsap-scroll-gallery-with-parallax-and-flip-transitions/) | gallery→fullscreen FLIP | A | DIRECT_REUSE_OK | 证明 plain JS + Flip 足够，但滚动劫持不采用 |
| C29 | Webflow | [Image Reveal on Hover & Mouse Cursor Follow](https://webflow.com/made-in-webflow/website/image-reveal-on-hover-and-mouse-cursor-follow-interactions) | cursor reveal | R | REFERENCE_ONLY_REIMPLEMENT | 桌面发现性依赖鼠标 |
| C30 | Webflow | [Image Reveal Animation](https://webflow.com/made-in-webflow/website/image-reveal-interaction) | image reveal | R | REFERENCE_ONLY_REIMPLEMENT | 普通 reveal，不足以构成 Aha |
| C31 | Webflow | [Photography Portfolio Smooth CMS Transition](https://webflow.com/made-in-webflow/website/photography-portfolio-smooth-cms-transition-experiment) | shared visual transition | A | REFERENCE_ONLY_REIMPLEMENT | 同图连续感强，平台不同 |
| C32 | Webflow | [Image Lightbox Interaction](https://webflow.com/made-in-webflow/website/image-portfolio-interaction) | lightbox expansion | R | REFERENCE_ONLY_REIMPLEMENT | 放大图而非变成杂志 |
| C33 | Webflow | [Image Scroll Reveal](https://webflow.com/made-in-webflow/website/image-scroll-reveal) | scroll reveal | R | REFERENCE_ONLY_REIMPLEMENT | 滚动触发过于普通 |
| C34 | Webflow | [Click to Reveal an Image](https://webflow.com/made-in-webflow/website/click-to-reveal-an-image) | click reveal | R | REFERENCE_ONLY_REIMPLEMENT | 产品语义不足 |
| C35 | Webflow | [CMS jQuery Portfolio Preview](https://webflow.com/made-in-webflow/website/cloneable-cms-jquery-portfolio-preview-interaction) | preview→detail | A | REFERENCE_ONLY_REIMPLEMENT | 结构可借鉴，技术栈不取 |
| C36 | Webflow | [Full Portfolio Image on Scroll](https://webflow.com/made-in-webflow/website/096-100dwfix) | scroll image expansion | R | REFERENCE_ONLY_REIMPLEMENT | 依赖滚动，不够即时 |
| C37 | Webflow | [Image Reveal Effect](https://webflow.com/made-in-webflow/website/image-reveal-effect-in-webflow) | image reveal | R | REFERENCE_ONLY_REIMPLEMENT | 视觉层级不足 |
| C38 | Webflow | [Moving Floating Image Gallery](https://webflow.com/made-in-webflow/website/moving-floating-image-gallery-interacti) | floating gallery | R | REFERENCE_ONLY_REIMPLEMENT | 像作品集 |
| C39 | Webflow | [Custom Slider Autoplay Gallery](https://webflow.com/made-in-webflow/website/slider-gallery-animation) | autoplay gallery | R | REFERENCE_ONLY_REIMPLEMENT | 轮播语义错误 |
| C40 | Webflow | [Pixelated Image Reveal (GSAP)](https://webflow.com/made-in-webflow/website/osmo-pixelated-image-reveal) | pixel reveal | R | REFERENCE_ONLY_REIMPLEMENT | 特效强但廉价化风险 |
| C41 | Webflow | [Pixelated Image Reveal Hover](https://webflow.com/made-in-webflow/website/pixelated-image-hover-effect) | hover pixel reveal | R | REFERENCE_ONLY_REIMPLEMENT | 移动端/语义双弱 |
| C42 | Webflow | [Before and After Slider](https://webflow.com/made-in-webflow/website/before-and-after-image-cloneable) | before/after | R | REFERENCE_ONLY_REIMPLEMENT | 比较工具隐喻不符合礼物生成 |
| C43 | Webflow | [Table Hover Image Reveal](https://webflow.com/made-in-webflow/website/table-hover-animation) | hover reveal | R | REFERENCE_ONLY_REIMPLEMENT | 桌面限定 |
| C44 | Webflow | [CMS Hover Image Reveal](https://webflow.com/made-in-webflow/website/wb-image-hover-animation) | hover CMS reveal | R | REFERENCE_ONLY_REIMPLEMENT | 桌面限定 |
| C45 | Webflow | [GSAP Flip Corners](https://webflow.com/made-in-webflow/website/gsap-flip-corners) | GSAP Flip expansion | A | REFERENCE_ONLY_REIMPLEMENT | Flip 机制强，业务语义需重写 |
| C46 | Webflow | [Pixelated Page Transition](https://webflow.com/made-in-webflow/website/pixel-transition) | pixel page transition | R | REFERENCE_ONLY_REIMPLEMENT | 装饰性过强 |
| C47 | Webflow | [3 Column Image Scroll Animation](https://webflow.com/made-in-webflow/website/column-image-scroll-animation) | 3-column scroll | R | REFERENCE_ONLY_REIMPLEMENT | 不够即时 |
| C48 | Webflow | [Stacking CMS Slider](https://webflow.com/made-in-webflow/website/stacking-cms-slider) | stacking slider | A | REFERENCE_ONLY_REIMPLEMENT | 堆叠语言可用，仍像 slider |
| C49 | Webflow | [Image Trail](https://webflow.com/made-in-webflow/website/image-trail-p5) | mouse image trail | R | REFERENCE_ONLY_REIMPLEMENT | 酷但完全不解释杂志 |
| C50 | Webflow | [Draggable CMS Grid](https://webflow.com/made-in-webflow/website/draggable-cms-grid) | draggable grid | R | REFERENCE_ONLY_REIMPLEMENT | 操作成本过高 |
| C51 | Webflow | [Image Trail from CMS](https://webflow.com/made-in-webflow/website/image-trail-from-cms) | CMS image trail | R | REFERENCE_ONLY_REIMPLEMENT | 同 C49 |
| C52 | Webflow | [Award Winning Grid Trail Mouse Follow](https://webflow.com/made-in-webflow/website/grid-trail) | grid mouse trail | R | REFERENCE_ONLY_REIMPLEMENT | 鼠标依赖且产品语义弱 |
| C53 | Framer | [Image](https://www.framer.com/marketplace/templates/image/) | fullscreen hover index | R | REFERENCE_ONLY_REIMPLEMENT | Single-Use，且偏作品集 |
| C54 | Framer | [Orynthe](https://www.framer.com/marketplace/templates/orynthe/) | editorial photo motion | A | REFERENCE_ONLY_REIMPLEMENT | Single-Use；风格可参考 |
| C55 | Framer | [Madeline](https://www.framer.com/marketplace/templates/madeline/) | 3D gallery/rail | A | REFERENCE_ONLY_REIMPLEMENT | Single-Use；动效多但不是成刊过程 |
| C56 | Framer | [MAGAZIN](https://www.framer.com/marketplace/templates/72822/) | digital magazine system | A | REFERENCE_ONLY_REIMPLEMENT | Limited；适合视觉语义验证 |
| C57 | Framer | [Vellum Editorial](https://www.framer.com/marketplace/templates/vellum-editorial/) | book-style loader/editorial motion | A | REFERENCE_ONLY_REIMPLEMENT | Limited；书感好，非核心转换 |
| C58 | Framer | [HALIDE Photo Studio](https://www.framer.com/marketplace/templates/halide-photo-studio/) | photo story/reveal | A | REFERENCE_ONLY_REIMPLEMENT | 摄影书感强，核心交互弱 |
| C59 | Framer | [Archyve](https://www.framer.com/marketplace/templates/archyve/) | portfolio transitions | R | REFERENCE_ONLY_REIMPLEMENT | 平台/产品语义不匹配 |
| C60 | Framer | [Marginalia](https://www.framer.com/marketplace/templates/marginalia/) | issue-based editorial | A | REFERENCE_ONLY_REIMPLEMENT | 强杂志感，但更适合 P1–P12 研究 |
| C61 | Awwwards | [studio brot](https://www.awwwards.com/sites/studio-brot) | high-end page motion | R | REFERENCE_ONLY_REIMPLEMENT | 品质参考，无复用授权 |
| C62 | Awwwards | [Integra Magna](https://www.awwwards.com/sites/integra-magna) | high-end page motion | R | REFERENCE_ONLY_REIMPLEMENT | 品质参考，无复用授权 |
| C63 | Awwwards | [J-Vers Page Transition](https://www.awwwards.com/inspiration/page-transition-j-vers) | page transition | A | REFERENCE_ONLY_REIMPLEMENT | 转场质感参考 |
| C64 | Awwwards | [Luzia Page Transition](https://www.awwwards.com/inspiration/page-transition-luzia-con-zeta-2025) | page transition | A | REFERENCE_ONLY_REIMPLEMENT | 转场质感参考 |
| C65 | CodePen | [Shared Element Transition](https://codepen.io/drenther/pen/NjzeOO) | shared element | A | UNKNOWN_DO_NOT_COPY | 机制直接相关，许可未单独确认 |
| C66 | CodePen | [Shared Element Page Transition](https://codepen.io/milanvogels/pen/PoQvdEM) | shared element page | A | UNKNOWN_DO_NOT_COPY | 机制相关，许可未确认 |
| C67 | CodePen | [CSS 3D Bending Page Flip](https://codepen.io/studioMJC/pen/vYrLqW) | 3D page flip | A | UNKNOWN_DO_NOT_COPY | 阅读器语义强，首个 Aha 仍错位 |
| C68 | CodePen | [GSAP Flip Card Popup](https://codepen.io/dxlubvjh-the-encoder/pen/MYwdEjj) | card→popup FLIP | A | UNKNOWN_DO_NOT_COPY | 布局连续性强 |
| C69 | CodePen | [GSAP Stack Cards on Scroll](https://codepen.io/urvashi-jain/pen/rNgeLze) | stack cards | A | UNKNOWN_DO_NOT_COPY | 纸层感可借鉴 |
| C70 | CodePen | [Carousel with GSAP Flip Cards](https://codepen.io/lwekuiper/pen/jOJYxbr) | carousel FLIP | R | UNKNOWN_DO_NOT_COPY | 更像组件 |
| C71 | CodePen | [GSAP Draggable Card Stack](https://codepen.io/GreenSock/pen/xxoGqdq) | draggable stack | A | REFERENCE_ONLY_REIMPLEMENT | 触觉感好但不应成为必需手势 |
| C72 | CodePen | [Smashing Image Gallery Shared Element](https://codepen.io/smashingmag/pen/OJZWKaK) | gallery shared element | A | REFERENCE_ONLY_REIMPLEMENT | 共享元素证明强 |
| C73 | GitHub OSS | [StPageFlip](https://github.com/Nodlik/StPageFlip) | realistic page turn | A | DIRECT_REUSE_OK | MIT；适合阅读器，不适合首个 Aha |
| C74 | GitHub OSS | [react-pageflip](https://github.com/Nodlik/react-pageflip) | React page turn | R | DIRECT_REUSE_OK | MIT；额外 React 依赖无必要 |
| C75 | GitHub OSS | [turn.js](https://github.com/blasten/turn.js) | HTML5 page flip | R | REJECT | 非商业 BSD；商业产品直接排除 |
| C76 | Motion | [Shared Layout Animation](https://motion.dev/docs/react-layout-animations) | shared layout/layoutId | A | REFERENCE_ONLY_REIMPLEMENT | 机制优秀但 React 依赖无必要 |
| C77 | Motion | [iOS App Store Card→Article](https://motion.dev/examples/react-app-store) | card→full content | A | REFERENCE_ONLY_REIMPLEMENT | 高质量共享元素参考 |
| C78 | Motion | [Card Stack](https://motion.dev/examples/react-card-stack) | card stack | A | REFERENCE_ONLY_REIMPLEMENT | 堆叠触觉参考 |
| C79 | Motion | [AnimateView](https://motion.dev/docs/react-animate-view) | view transition orchestration | A | REFERENCE_ONLY_REIMPLEMENT | React 方案，不引入 |
| C80 | Motion | [View Animations](https://motion.dev/docs/animate-view) | View Transition wrapper | A | REFERENCE_ONLY_REIMPLEMENT | 实现参考，不作为依赖 |
| C81 | Browser Standards | [MDN ViewTransition API](https://developer.mozilla.org/en-US/docs/Web/API/ViewTransition) | native view transition | A | DIRECT_PLATFORM_API | 适合渐进增强，不能作为唯一路径 |
| C82 | Browser Standards | [Chrome Element-Scoped View Transitions](https://developer.chrome.com/blog/element-scoped-view-transitions) | scoped/nested transition | A | DIRECT_PLATFORM_API | 未来增强价值高，需旧浏览器回退 |

## First-order pattern families found

1. Shared-element / image-to-content morph.
2. Cover / mask / clip reveal.
3. Stack / fan-out / layered paper staging.
4. Grid reflow / image-to-layout transformation.
5. Physical page turn / flipbook.
6. Controlled 3D / draggable depth.
7. Scroll-driven staging.
8. Cursor/hover reveal and image trails.
9. Pixel/WebGL/distortion transitions.
10. Slider/collage/crossfade.

No new first-order interaction family appeared after the threshold cohort; later research only supplied implementation alternatives, quality references, or license evidence.
