# Visual Narrative Animation Lab（画面叙事动画实验室）

把“口播稿 + 配音”变成**真正由画面参与叙事**的手绘/漫画式动画，而不是一句话配一张图的动态幻灯片。

## 当前目标

先用人工/半自动方法验证一条 30–45 秒原创样片，提炼可复用的 Visual Beat Grammar，再逐步建设角色资产库、AI Director、素材解析器与可编程渲染流水线。

## 核心方法

```text
Script + Voiceover
        ↓
Director / Visual Beat SHOTBOOK
        ↓
Asset Resolver
  ├─ reuse existing pose / prop / scene
  └─ generate only missing art
        ↓
Timeline performance
(hard cuts first, sparse camera moves)
        ↓
Subtitles / SFX / overlays
        ↓
MP4
```

关键原则：**台词和画面是 many-to-many 关系。** 一句话可以对应多个镜头，多句话也可以共用同一构图。

## 当前状态

```text
P0 Project Intake                        ✅ PASS
G1A Corpus + Analysis Schema             ✅ PASS
G1B Benchmark Deconstruction             ✅ PASS
G2A Script + Director SHOTBOOK           ✅ PASS
G2B Character + Style Proof              ✅ PASS
G2C1 Shot Asset Resolution               ✅ PASS
G2C2 Major Art Plates                    ✅ PASS_CANDIDATE
G2C3 30–45s Animatic                     ✅ PASS_CANDIDATE
G2C4 Visual Comparison                   ← HERE
G3 Character / Scene Asset System        ⏳
G4 Director SHOTBOOK Specification       ⏳
G5 Semi-Automated Pipeline               ⏳
G6 Rendering Automation                  ⏳
G7 Batch Validation                      ⏳
G8 Reusable Skill / Workflow             ⏳
```

当前需要验证：`renders/G2C_animatic_v0_preview.mp4` 是否已经具备目标中的“画面叙事感”，以及还缺哪一层。

## 关键结论

- 参考样本的生命力主要来自**语义换画、夸张 Pose、视觉比喻、回调与约 2 秒级硬切节奏**，而不是持续运镜。
- 不再采用“一句文案 -> 一张图 -> 擦除出现”的默认模型。
- AI 生图只负责角色、场景、Pose 和道具；**正式可读文字统一后期叠加简体中文**。
- 先证明人工/半自动基线，再把验证过的规则编码成 Remotion 或其他自动渲染器。

## 目录

```text
visual-narrative-animation-lab/
├── README.md
├── PROJECT_RECORD.md
├── REVIEWER_HANDOFF.md
├── CHANGELOG.md
├── ASSET_HASHES.sha256
├── docs/
│   ├── g1/   # 基准拆解与 Visual Beat Grammar
│   └── g2/   # 原创 MVP、Art Bible、资产/时间轴证据
├── assets/
│   └── previews/  # 仓库友好的压缩预览
└── renders/
    └── G2C_animatic_v0_preview.mp4
```

## 阅读顺序

```text
README.md
  ↓
PROJECT_RECORD.md
  ↓
REVIEWER_HANDOFF.md
  ↓
docs/g1 + docs/g2
```

## 资产策略

GitHub 只保留项目继续开发所需的文档、关键视觉预览和低码率样片。高分辨率中间资产不重复堆入仓库，但通过登记表与 SHA-256 追踪。第三方参考视频及其逐帧截图不进入仓库，仅保留派生分析数据。

## Governance

项目采用 `VPS Project Governance v0.1.6` 的适配版管理：保留 Gate、Evidence、Reviewer PASS/RETURN 和唯一 handoff，去除当前阶段无关的服务器部署条款。
