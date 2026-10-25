# spike 三幕来源记录

2026-10-25，依据用户提供的 Ansyn Lab 仓库与五张截图进行本地 Halo 适配。通过本会话 GitHub 插件读取 `7-an/ansyn-lab` main 分支相关文件；此目录保留当时的参考源文。未向原仓库写入、提交或发布。

- `src/lib/page-transition.ts`、`src/components/PageTransition.astro`：多语言问候、Web Animations 时序与弧形幕布几何。
- `src/lib/original-hero-field.ts`：字符 atlas、噪声与文字掩码飞行。
- `src/lib/home-experience.ts`、`src/lib/globe-projection.ts`、`src/components/HomeExperience.astro`：七条带、滚动场景与 Canvas 地球。
- `src/lib/home-scroll.ts` 仅研究原滚动手感；未引入其整站 Lenis 控制。
- 地图来自原仓库 `public/data/countries.json`，本地副本随组件打包。

改动包括 SPW/spike 品牌、五词、颜色与本地字体、上海/深圳定位、组件生命周期、Halo 接入；照片图库、原作者外链与原站后续内容没有移入。原仓库根目录当次未见 LICENSE 文件，不对其公开可读状态作额外授权推断。此处保留来源事实与修改范围。

字体二进制经 GitHub 插件读取报错：`UnicodeDecodeError: 'utf-8' codec can't decode byte 0x88 in position 11: invalid start byte`。已停止该读取且未浏览器绕过，使用 npm Fontsource 的同名 Poppins、Space Mono、Chivo Mono 本地 WOFF2。版本见组件 package-lock.json；OFL 随 fonts/ 保留。d3-geo、d3-array、internmap 的许可证随组件及主题包保留。
