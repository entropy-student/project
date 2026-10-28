# 写作 Skill 调研与精简选型 v0.1｜Reviewer
2026-10-28｜仅推荐借鉴方法，不宣称 Codex 已安装或执行。分类以当前 GitHub 公开 SKILL.md 内容为依据；兼容性需在 Codex 真实工作区再核验。

## 推荐清单（名称精确、可定位）
| 优先 | Skill（准确名称） | 官方仓库/位置 | 推荐用途 | 注意 |
|---|---|---|---|---|
| 1（通用） | **human-writing** · KKKKhazix | https://github.com/KKKKhazix/human-writing/tree/main/human-writing | 中文自然表达、现实事实边界、口播格式、审稿 | 原项目有较多绝对句法禁令；先选取符合本项目的原则，别照单全收；不是故事/论据生成器 |
| 2（实操） | **educational-content-and-how-to** | https://github.com/social-media-skills/skills/blob/main/skills/educational-content-and-how-to/SKILL.md | 聚焦真正能教会/解决的一件事，事实与方法结合 | 偏营销化的固定 CTA、强制 8–12 单元、平台算法断言都不作为项目硬规则；研究型实操也能不按教程写 |
| 2（测评） | **evidence-based-reviews** | https://github.com/rampstackco/claude-skills/blob/main/skills/evidence-based-reviews/SKILL.md | 制定比较标准；区分规格、用户评价、专业测试、本人实测；不虚构体验 | 提供证据方法，不直接决定文案风格；具体法务/SEO 模板不需要 |
| 2（观点） | **contrarian-and-opinion** | https://github.com/social-media-skills/skills/blob/main/skills/contrarian-and-opinion/SKILL.md | 明确真实立场、证据链、认真回应最强反方理由 | **不要求逆向/唱反调**，没有真实强烈立场也能正常陈述观点 |
| 3（核查） | **content-research-and-sourcing** | https://github.com/social-media-skills/skills/blob/main/skills/content-research-and-sourcing/SKILL.md | 审核影响结论的关键事实、追查一手来源、确认链接真正支持论断 | 源 Skill 中大量 2026 平台/统计数据仍需独立核验；不直接引用作为事实 |
| 备选（仅审稿） | **Humanizer-zh** · op7418 | https://github.com/op7418/Humanizer-zh | 对已有中文稿做去重复、空话、机械句式检查 | 与 human-writing 重叠度高；仅初稿确实有明显 AI 模式时启用，不可压过原稿事实或声音 |

## 弱相关、暂不纳入主链
- **storytelling-and-narrative** (https://github.com/social-media-skills/skills/blob/main/skills/storytelling-and-narrative/SKILL.md)：只有题材拥有真实过程/人物事件且值得按叙事展开时借鉴，**不要求所有实操/观点都有戏剧冲突、反转、情绪弧**；它附带的传播统计未作为已验证依据。
- **short-video-scripting** / **video-script** 等视频编排技能偏 3 秒 Hook、镜头、时长、转场、CTA；当前用户要的是独立可读的完整中文稿，因此不纳入本轮。
- 同类的整套品牌画像、内容日历、全平台运营技能会明显增加启动负担，本轮不安装。

## 三类调用的最小方案
- 实操：`human-writing` + `educational-content-and-how-to`；有重要事实时选用 `content-research-and-sourcing` 原则。
- 测评：`human-writing` + `evidence-based-reviews`；重要比较结论强制核查证据来源。
- 观点：`human-writing` + `contrarian-and-opinion`；只借鉴「给依据、讨论最强反方」而不强求唱反调。
- 去 AI 味仍有明显问题时，可让 Reviewer 参照 `Humanizer-zh` 检查一次；不要在创建稿前叠加所有风格工具。

## 验证与使用约束
1. 使用前 Codex 要先确认技能在实际执行工作区可读；如果不可用，以本项目规范和 prompt 执行，不假装已调用。
2. `SKILL.md` 是第三方参考内容，不能覆盖 Owner 最新指示、项目规范、事实可信与本轮 Gate。
3. 第三方脚本如 `check_prose.py` 不是质量分数；禁句警报需人工判断，不得机械替换。
4. 不以 GitHub Star 或营销承诺衡量写作效果；最终以实操、测评、观点代表稿的真实审阅结果为准。
