# Codex / Muse · 视觉工作交接

读取顺序：
1. `../../README.md` 与本项目 `README.md`
2. `docs/STYLE_LOCK.md`（视觉权威）
3. `config/design-tokens.json`（机读参数）
4. `docs/EDITORIAL_RULES.md`（证据/字幕）
5. `preview/index.html`（可见实现）

## 硬性边界
- A = 简短 Tiger Aqua 桌面；B = 占满 16:9 画布的 QuickTime 风格播放器。没有独立 C。
- 内部素材按旁白语义轮播；论文画面和独立复现须有标签；字幕单行并以真实音频对齐。
- 尽量复用 HTML/CSS 和既有库，不能因为改 UI 大范围重写播放逻辑。
- 当前只是外观原型，不得声称已经实现自动找素材、版权核查、声学对齐或成片渲染。
- 不得修改 project 仓库其他一级项目；视觉大改必须获得 Owner 确认。
