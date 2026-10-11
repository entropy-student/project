# M2 测试源码五文件补丁｜限定代码 PR 提交任务（未执行）

> 状态：`PROPOSED_READY_FOR_OWNER_RELAY` · 2026-10-11。**仅代码审查/PR，不是渲染测试、正式视频生产，也不包含对现有失败日志的更多调查。**  
> 依据：`docs/P4_G1VA_M2_F2_REVIEWER_INDEPENDENT_MEDIA_QA_2026-10-11.md`。  
> **Owner 可将本文明确转发给本地主线 Codex，才构成当前代码分支和 PR 写入授权；未转发前无需 Codex 主动执行。**

## 目标与严格范围

- 将本地 `C:\Users\34707\Documents\ChatGPT\cws-g1va-m2-20261011-x7k2p9\evidence\qa\g1va_m2_source_diff.patch` 的五文件**原样**变更审成一个 GitHub PR；补丁 SHA256 必须等于 `4c5df1ad6a5acea1f74fa26f76d9038d0d7e62b48a1b98c2bd8a678392554482`。
- 只能更改 `curious-world-studio/p4-g1/m1-media-adapter/` 下这5个路径：
  1. `ResearchAquaMediaAdapter.tsx`
  2. `generate_m2_test_fixture.ps1`
  3. `m2_media_guard.psm1`
  4. `render_m2_windows.ps1`
  5. `verify_m2_fail_closed.ps1`
- 当前 main 在 Reviewer 复核时，TSX blob 为 `bc20a83cbbf84a697dcf19679343b3a15d3bce9a`，须先刷新 main 并确认 patch 可 clean apply、原 M1 runner 未漂移、代码白名单不变。如存在漂移，停下请求 Reviewer，不随意 rewrite patch。
- 既有 Windows checkout 保留原始证据与本地改动；优先从**最新 GitHub main 新建隔离工作树/分支**应用五文件 patch，不将混杂的本地历史分支直接 push 到 main。不拷贝 `evidence/` 视频、原始日志、临时 stage、用户绝对路径中的任何隐私数据到 repo。
- PR 描述必须引用 M1 和 M2 候选已验证 MP4 SHA 与 F2 单轮回归 Review、旧首次 184 帧/HTTP500 间歇故障、Observer post-render exit1 与内存风险，保持 `M2_NOT_FORMALLY_PASSED`。
- 静态 diff 审查：确认 RightsBasis 只允许 self-generated fixtures、视频默认保持横屏输出、竖屏只作为 contain 兼容性测试；不能把 test-only 代码冒称正式实拍/配音系统；确认 M1 legacy props 兼容，无网络下载/源站访问/系统配置副作用；既有 M2 首次失败 STOP 约束保留。

## 验证

- 用 `git apply --check`、`git diff --check` 和项目已有静态 fail-closed 测试（仅当已证明不会渲染/下载且工具现成时）检查补丁；不能重新渲染，不能安装或升级工具。
- **只创建 PR，不自行合并**。将 PR URL、base/head SHA、精确5文件 diff、上述静态检查结果、观察到的任何风险、GitHub 工作树状态提交 Reviewer。
- 如果原始 patch 在 main 上不能无冲突复现，或某个检查失败，返回 `RETURN_PATCH_INTEGRATION_CONFLICT` 或精确失败原因，**不自动修改源逻辑或循环试错**。

## 与后续工作区分

- 此 PR 接受的是**M2 测试适配代码**，不是正式 `G1_PASS`、`G2_AUTHORIZE`、音轨对齐通过或真实素材版权通过。
- PR 经过 Reviewer 检查并按 Owner/治理流程获准合并后，才进入正式首期生产前的受控清理及后续 G2 实际内容制作设计。真实内容至少需要来源合法且相关的横屏源素材、旁白/单行字幕、音画对齐、资源上限与可回退策略。
- 不接触 yt-dlp 支线、VPN、Clash/系统代理、VPS、其他项目，不删除任何文件。
