# P4-G1｜历史技术试验与当前工程入口

> **当前索引（2026-10-11）**：本目录包含G1早期研究实验、Research Aqua V2真源、M1/M2媒体接入与已有测试证据。**旧版G1-R1/R2任务书、部分M2诊断与Mac首版一次性提示词已经执行/过期，已从HEAD清理6份；它们存在于Git历史，可在提交 `f6095a5993531dbf412ba11082b7d022c38bff2e` 找回。** 禁止将早期README“G1未渲染”误读为当前事实：确有后续机器测试片，但**正式G1仍NOT_PASS、G2未授权**。

## 先读什么

1. **唯一当前状态及ZIP交接**：[`../docs/CURRENT_STATE.md`](../docs/CURRENT_STATE.md)。
2. **正式视觉锁定**：[`../visual/retro-mac-v1.2/docs/STYLE_LOCK.md`](../visual/retro-mac-v1.2/docs/STYLE_LOCK.md)；Research Aqua [V2 HTML真源](visual-reference/g1va_v2_research_aqua_prototype.html)。
3. **当前可复用媒体适配源码**：[`m1-media-adapter/README.md`](m1-media-adapter/README.md) 与其源码；PR #116 已合并但不等于第一支正式影片整条管线PASS。
4. **正式素材3＋1与Aqua2/4/6**：[`../docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md`](../docs/VIDEO_ASSET_POLICY_3_PLUS_1_2026-10-11.md)，[`../docs/P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md`](../docs/P4_VISUAL_GRAMMAR_3PLUS1_RESEARCH_AQUA_246_2026-10-11.md)。
5. **下一条主线任务（尚未下发）**：[`P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md`](P4_MAIN_R1_EDITORIAL_STORYFIT_RIGHTS_GATE_2026-10-11.md)；主线仍需先完成真实原研究、真正可看素材及复用权核验。

## 目录内容和权限

- `remotion/`、`scripts/`、`m1-media-adapter/`：历史原型及已合并适配代码；在正式视频/许可证明确授权前不执行新渲染、不重构生产模块。
- `visual-reference/`：已选V2外壳行为、独立质量证据，不等于全部正式B镜头的制作/版权许可。
- `evidence/`、`source_manifest.json`、`rights.reviewed.template.json`、`captions.manual.template.json`：真实历史核验与未来媒体权利、字幕来源的基础合同，不应作为旧缓存删除。
- 旧日期命名任务书、历史拒绝与返工报告仅作审计；**目前只给Codex文字提示词，Codex每轮交一个ZIP给Owner→Reviewer，不为普通报告修改GitHub**。长期要复用的代码/模板及正式决策仍需受控PR。
- 任何第三方视频或论文图的`LINK_FOUND`、`CONTENT_VERIFIED`、`REUSE_RIGHTS_VERIFIED`需分别核对，不能仅凭网址/论文许可宣称可商用。Owner明确批准以前禁止下载权利未知素材、付费、外联、真实删除或正式发布。

## 旧G1试验为何被否决（简史，不是现行任务）

早期J-B互动果冻20–30秒试验曾以PLOS Fig.7/8静态多格图为主，机器QA虽通过，Owner视觉否决；随后采用Research Aqua V2及M1/M2适配、独立Mac动效库。原始报告继续保留在`../docs/P4_*.md`或Git历史，不能将旧视觉回归任务重新下发到主线。
