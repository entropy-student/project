# Codex / Muse · 视觉工作交接

**读取顺序（所有路径相对 `curious-world-studio/` 项目根目录，与 Codex 启动目录无关）**：
1. `docs/CURRENT_STATE.md`（运行状态，不是视觉标准）与 `README.md`（项目说明）
2. `visual/retro-mac-v1.2/README.md`（视觉模块）
3. `visual/retro-mac-v1.2/docs/STYLE_LOCK.md`（唯一视觉规范）
4. `visual/retro-mac-v1.2/config/design-tokens.json`（机读参数）
5. `visual/retro-mac-v1.2/docs/EDITORIAL_RULES.md`（证据与字幕）
6. `visual/retro-mac-v1.2/preview/index.html`（仅外观预览）

## 硬性边界
- A = 简短 Tiger Aqua 桌面；B = 占满 16:9 画布的 QuickTime 风格播放器。没有独立 C。
- 内部素材按旁白语义轮播；论文画面和独立复现须有标签；字幕单行并以真实音频对齐。
- 尽量复用 HTML/CSS 和既有库，不能因为改 UI 大范围重写播放逻辑。
- 本目录只是视觉外观原型，**不是整片渲染系统**。Owner 技术交接称本地 OpenMontage 技术底座 READY，但本项目尚未接入，且真实长视频质量未验证；不能混同两者，也不能擅自触发 OpenMontage/TTS/视频。生产前必须请 Owner 明确确认。
- 不得修改 project 仓库其他一级项目；视觉大改必须获得 Owner 确认。
