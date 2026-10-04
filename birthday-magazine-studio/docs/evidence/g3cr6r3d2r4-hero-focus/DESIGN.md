---
name: Birthday Magazine — Hero Focus Candidate
description: Owner-authorized two-image focus window, scoped to Hero presentation.
---

# Design System: Hero 双图焦点窗口

## Overview

Owner 已确认此 Hero-only 方案并授权开始修改。最新授权作为本候选的执行依据；历史 [R4 动效契约](../g3cr6r3d2r4/DESIGN.md) 和 [手机录屏校准契约](../g3cr6r3d2r4-owner-video/DESIGN.md) 保留，不改写为已完成或正式 PASS。本文件记录已确认的实现方向，不宣称源码完成、运行态验证或最终验收。

Hero 的常态是清晰停留。两个真实不同的现有自有图片交替展示：背景是当前整幅图片的模糊版本，焦点窗口显示该图片在同一坐标系统中的清晰裁切。换图时才短暂失焦、缩放和交叉淡化，随后重新聚焦；不以持续失焦循环替代稳定观看。

## Layout

模糊背景和清晰窗口使用同一整幅图片的渲染尺寸、定位与裁切坐标。窗口移动时揭示背景对应位置的清晰像素，不成为独立缩放的缩略图，也不重新居中图片内容。两层在换图期间保持对应关系。

标题、说明、CTA 及其命中区域固定在既有位置，不随窗口移动、缩放、模糊或淡化。交互不得阻挡原生链接、导航或正常页面滚动。

## Components

**复用图片。** 仅使用已有自有静态资产：

- `preview-plugin/assets/g3cr6/gift-hero.png`：Mira 杂志礼物场景。
- `preview-plugin/assets/g3cr6r3d2r2/sample-lena-gift.png`：第三张样刊的 Lena 礼物场景。

两图保持原有虚构／示意性质，不代表真实客户输出。**新生图 = 0；新增图片生成调用 = 0**。

**桌面焦点窗口。** 窗口平滑、有界地跟随 Hero 内的鼠标位置；位移受 Hero 展示区域约束。鼠标离开后平滑回到中心。窗口运动只改变展示裁切位置，不移动标题或 CTA，不捕获点击、不劫持滚动。清晰停留期间图片保持可辨识。

**双图切换。** 清晰 hold 是默认状态。切换按“短暂 blur／zoom／crossfade → 新图中心重聚焦 → 清晰 hold”推进。每次切换确实更换 Mira 与 Lena 两张图片，而不是把同一图片的缩放变化称为换图。此次授权未锁定精确毫秒值、窗口尺寸或鼠标位移幅度；实际实现参数应另行记录，不能在本契约中伪造测量结果。

**手机。** 焦点窗口固定，保留同坐标清晰裁切关系，以轻量双图切换表达焦点变化。手机不依赖鼠标跟随，不要求手势操作才显示信息，不阻碍纵向滚动。

**Reduced motion／无 JS。** Reduced motion 显示固定、清晰、完整的静态 Hero，停止跟随、循环切换和 blur／zoom／crossfade。无 JavaScript 或动效控制器不可用时，现有 Hero 图片、标题、说明和 CTA 立即可用，不等待初始化、加载动画或自动切换。静态回退无需新增数据库内容。

## Do's and Don'ts

- 只改 Hero 展示；原 Home 数据库内容、八组结构、六个锚点、链接目标保持冻结。
- 保持全部 Hero 之外的 CSS／JS 及业务行为冻结，不继续 Editorial、Panel、Samples 或 Closing 校准。
- 冻结 Preview 内部、选图／替换／移除、本地图片处理、object-URL 和原有数据钩子。
- 冻结 Woo 产品、价格、购物车、结账、订单、账户、支付、私有工作区和 entitlement/provider 语义；不涉及 P1–P12 或 core Aha。
- 不引入图片生成、照片上传、运行时模型、真实支付、订单创建、生产部署或共享基础设施变更。
- 不把此次 Owner 开始修改的授权写成正式 PASS 或新运行态回归证据。

本次文档工作仅新增此文件；未改源码、未跑测试、未提交 Git。

## Implementation read-back

The preceding sentence describes the direction-document authoring step only. Execution subsequently implemented the approved Hero enhancement and retained51 final captures with60 automated checks. Details, parameters, rollback and limits are recorded in [README.md](README.md); formal Reviewer / Owner visual confirmation remains pending.
