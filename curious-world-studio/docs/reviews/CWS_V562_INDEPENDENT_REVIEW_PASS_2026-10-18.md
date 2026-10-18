# Curious World Studio V5.6.2｜独立 Reviewer 技术审核报告

- 审核日期：2026-10-18
- 审核类型：**Review Only**（未改源码、未写 GitHub、未合并 PR、未制片）
- **整体裁决：PASS（仅 V5.6.2 技术候选在本次规定范围内；不代表正式生产、冻结或发布准入）**
- N-01：**PASS**；N-02：**PASS**；继承性与局部回归：**PASS**；完整 31.06s 实速播放：**PASS**
- **发现的新 P0/P1/P2 缺陷：0**。当前未提出必须返修项；主 Reviewer/Owner 仍须决定是否验收和如何继续。

## 1. 权威输入、源码指纹及权限边界

依次完整阅读 ZIP 中 `00_先读_独立Reviewer审核要求.md`、仓库 `docs/CURRENT_STATE.md` 与 `docs/REVIEWER_HANDOFF_CURRENT.md`，以及 `main` 的 `docs/reviews/CWS_V562_EXECUTOR_REPAIR_AND_SUCCESSOR_STATUS_2026-10-18.md`、PR 分支 `docs/CWS_V562_N01_N02_TARGETED_REPAIR_AND_TESTS_2026-10-18.md`、`main` 的 `docs/reviews/CWS_V561_MAIN_REVIEW_AND_SUCCESSOR_RELAY_2026-10-18.md`。后两份主线评审文档在 PR 分支路径不可取，明确切换 `main` 读取，不将 404 误判为文档缺失。

- GitHub 仓库：<https://github.com/entropy-student/project>
- PR：<https://github.com/entropy-student/project/pull/144>；审核时 **Open / Draft / 未合并**，PR Head `33d5357c0c09931ba5e7d9070ca92cf1b2adb35f`。
- V5.6.2 最终候选：`curious-world-studio/visual/content-template-lab/storyboard-v5-6-2-percent-scale-edge-fixes.html`；独立计算 SHA-256 `47dbe555b297153bab7520b7b1b716fa8403ed32c237b3b2603e283829c2fb84`，Git blob `33aabc3ff2e48877493277eb1a86274818e3c769`；通过 GitHub 连接器在 PR 分支查得目标文件 blob 与附件一致。
- V5.6.1 父版：SHA-256 `44319df40d2b6e14400f720b97d4a34161ae0cef89c9d9e3a7b5c54e5b8fa213`，Git blob `3cd8b040a9f106ca7d0876b55b34ab71088af175`。
- `main` 冻结 V5.2：独立从 GitHub `main` 读取 blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`，未做写操作。
- V5.6.1→V5.6.2 实际差异：版本文字、`normalizeUnit` 新函数及 3 处调用、比例尺比较取消固定 `1e-8` 容差、诊断 `__CWS_SOURCE` 标识；没有重构 Mac Canvas 或时间轴。

**来源分层：** 本报告结论取自下列 `independent_*.py` 本轮新写脚本、Chromium 动态观测及结果 JSON；执行方原 `v562_*.py`、PASS 数量与截图只被用作测试线索，**不计入独立通过数**。

## 2. 本轮独立环境和证据覆盖

- Debian 13 Linux + Chromium `144.0.7559.96` + Python Playwright（隔离新页 `page.set_content`）；JS 页面异常监听。
- 本轮独立执行：**41/41** 定向边界、反例和基础回归通过（`independent_probe_results.json`）；**9/9** 媒体、旁白、暂停、长镜头跳转回归通过（`independent_media_results.json`）；3/3 原生 Mac Canvas 帧 PNG 哈希一致（`canvas_independent_results.json`）；另行执行一条 **0→31.06s 不跳时、1× 实速播放**（`fullplay_independent_results.json`）。
- 原问题的 **V5.6.1 错误** 也使用父版在浏览器中重现；不是仅用 V5.6.2 正例验证。
- 测试脚本/JSON、两张正例截图、源 HTML 的哈希校验及合成 WAV/MP4 均随包提供。

## 3. N-01｜全/半角百分号与比较语义：PASS

| 独立用例 | 预期 | 本轮实际 |
|---|---|---|
| V5.6.1 父版：`[5,40]`, 单位 `％`, `delta` | 复现错误的非百分点标注 | 旧版显示 `+35％`，**旧缺陷复现** |
| V5.6.2：`[5,40]`, 单位 `％`/` ％ `, `delta` | `+35 个百分点` | **PASS**，显示 `+35 个百分点`，登记单位都规范化为 `%` |
| ` % ` 与 `﹪` 混用，[−5,5] `delta` | `+10 个百分点` | PASS |
| `[5,40]`, `％`/`﹪`, `change` | `+700%`（不能误成百分点） | **PASS**，结果 `+700%` |
| `[40,5]`, `change` | `−87.5%` | PASS |
| `[0,0]` `delta` | 0 个百分点 | PASS |
| `[0.125,0.25]` `delta` | +0.125 个百分点 | PASS |
| `[2,10]` `ratio` | 5 倍 | PASS |
| 真正混合 `%` 与 `kg` | 拒绝且不改变当前状态 | PASS，拒绝异常明确，`__CWS_SCHEMA()` 前后相同 |
| `change` 以 0 为基数 | 拒绝除零 | PASS |
| 规范化后导出 | V2 JSON，单位为 `%` | PASS，`CWS_STORYBOARD_V2.json`，`schema=CWS_STORYBOARD_V2`，两指标单位 `%` |

**判断：** `normalizeUnit` 在 JSON 导入的 metric、渲染数值和 `delta` 后缀使用同一规范。`delta` 与 `change` 不混用；无暗中放宽不同量纲的比较。源代码仍保留 `normalizeUnit(v)` 只用于指定的百分号字符变体，符合本轮要求。**无需返修。**

## 4. N-02｜极小值显式刻度：PASS

| 独立用例 | 预期 | 本轮实际 |
|---|---|---|
| V5.6.1 父版 `[1e−9,2e−9]`, `dataScaleMax=1e−10` | 旧版错误接受，两个满柱 | **旧缺陷重现**：验证通过，两个柱宽均100% |
| V5.6.2 同上 | 严格拒绝小于最大绝对值的刻度 | **PASS**，返回 `S07比例基准不可小于数据绝对值` |
| 刻度恰好 `2e−9` | `[50%,100%]` | PASS |
| 刻度 `4e−9` | `[25%,50%]` | PASS |
| `[5e−324,1e−323]` 设 `5e−324` | 次正规数仍拒绝不足刻度 | PASS |
| 同组刻度 `1e−323` 或自动 | `[50%,100%]` | PASS |
| 负数 `[-1e−9,2e−9]` | 负值以零轴左侧可视化 | PASS，柱宽 `[25%,50%]`（双向零轴） |
| `[-0.0005,-0.002]` 自动 | 宽度 `[12.5%,50%]`（双向零轴） | PASS |
| 全零、自动或正数极小刻度 | 均为0宽，无除零 | PASS |
| 刻度稍低于2e−300（机器可区分值） | 严格拒绝 | PASS |
| 刻度为 0 或负数 | 拒绝 | PASS |
| 非法刻度真实导入 | 不污染当前合法配置 | PASS，导入抛错且前后 schema 一致 |

**判断：** 新判断 `scale < Math.max(...metrics.map(abs))` 消除了旧 `1e−8` 绝对误差门槛对微小值的误接收，没有误拒本轮覆盖的合法相等、较大、次正规和零值情形。**无需返修。**

## 5. V5.4–V5.6 功能继承与视觉回归：PASS（限本轮样本）

| 子项 | 独立动态证据 | 结果 |
|---|---|---|
| V2 结构和导出 | JSON 可导出；schema/version 与文件名对应 | PASS |
| V1→V2 | 将合法 V1（移除 V2 的旁白专属字段/Cue）导入后自动转为 V2，七镜头均获迁移 Cue | PASS |
| 多 Cue | 为 S01 配置两段 Cue，跳到第二段内容能更新字幕 | PASS |
| 素材 ID + MIME | Batch 拒绝同名但登记 WebM / 实际 MP4 的错误关联 | PASS |
| 手动错 MIME 取消 | 原 MP4 绑定和注册 MIME 仍在，未丢失绑定 | PASS |
| T5真实 MP4 | 使用包内可解码 MP4，第二阶段 inPoint 0.4s，局部0.3s时定位约0.7s；再seek定位约1.2s | PASS |
| WAV 与 Master Clock | 导入11秒合成WAV，时间跳转后音频定位≈主时钟−4.76；播放后暂停音频与主时钟保持对齐 | PASS |
| T6 4模式 | `bars`、`delta`、`ratio`、`change` 均动态验证 | PASS |
| 60镜头长时间轴 | 307.06s 配置在 40/150/298s 显示播放器，终点关闭 | PASS（**seek测试，不是5分钟连续播放**） |
| 单一 Mac / 六模板 / 七镜头 | `canvas#view=1`，第二 Mac 窗口不存在；默认6个模板/7个镜头 | PASS |
| Canvas 像素一致 | 父版与 V5.6.2 原生绘图 script SHA 一致；在0、9.3、29.8s通过 Chromium `toDataURL()` 提取的 PNG SHA-256 逐帧相同 | PASS（3帧抽样） |

**关于未重复全量执行：** 本轮已覆盖关键继承入口和逆向边界，但没有宣称逐一验证所有媒体编码组合、浏览器种类或240镜头上限；不存在凭借执行者的36/36、28/28直接给 PASS 的情况。

## 6. 最终候选 31.06s 实时完整播放：PASS

**使用候选 SHA-256 `47dbe...2fb84`，而非旧版测试日志：** Playwright 页面从0s实际点击播放、不通过 `__CWS_SEEK` 快进；每约1秒采样 Master Clock。终点在**31.62s 墙钟时间**读到：

```json
{"time":31.06,"playing":false,"shot":"S07","template":"T6","oneOriginalCanvas":1,"secondMacWindow":false,"end":31.06,"visible":"hidden","wall":31.62}
```

镜头观测集 `S01, S02, S03, S04, S05, S06, S07`；JS 页面异常 `0`。片尾内容层隐藏、状态停止、返回原 Mac 桌面。完整 31次每秒采样记录在 `fullplay_independent_results.json`；与 `independent_probe.py` 的快进/seek 回归相互独立。

## 7. 问题清单和最小返修建议

| 级别 | 问题/证据 | 影响 | 最小建议 | 是否现在处理 |
|---|---|---|---|---|
| P0 | **未发现** | — | 无 | 否 |
| P1 | **未发现** | — | 无 | 否 |
| P2 | **未发现本次变更引入、且可复现的 P2 缺陷** | — | 无 | 否 |
| P3 | 本轮未形成必须处理的新增视觉或文案小问题 | — | 保留当前六模板设计 | 否 |

**需保持独立的未验证项（不是上述 N-01/N-02 返修失败）：** Windows 11 Edge 本机 `file://` 双击链路；真实4–6分钟连续有声/多视频播放及声学对齐；TTS/SRT与完整MP4渲染导出；真实研究文献、素材来源授权与知识叙事 Story-Fit。此处不能据技术短片PASS推导生产流程PASS。

## 8. 推荐裁决与后续动作

建议主 Reviewer **接受 V5.6.2 的 N-01/N-02 技术修复，判本轮 `PASS`，无需再次返工两处算法或重做 Mac/六模板**。主 Reviewer 和 Owner 决定是否更新正式基线及是否授权后续独立 Gate；本报告本身**不冻结、不合并、不许可制片或发布**。

必须保留：`CW0005 R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`，素材权利 `PARTIAL`。当前 PR 保持 Draft，`main` V5.2 冻结原件不变。

## 9. 证据文件目录

- `independent_probe.py` + `independent_probe_results.json` + `probe_stdout.txt`：41项正反例、V5.6.1原缺陷复现、V2往返及原子回滚。
- `independent_media_probe.py` + `independent_media_results.json` + `media_stdout.txt`：9项素材/Cue/WAV/MP4/307.06s回归。
- `canvas_independent.py` + `canvas_independent_results.json`：原Mac源脚本SHA、3时码PNG指纹。
- `fullplay_independent.py` + `fullplay_independent_results.json` + `fullplay_stdout.txt`：同最终SHA文件31.06s不快进完整运行记录。
- `evidence/N01_fullwidth_delta.png`, `N02_tiny_equal.png`, `N02_subnormal_equal.png`：浏览器独立截屏。
- `evidence/exported_v2.json`：从页面实际下载的规范化V2分镜。
- `source/`：从用户工作包只读复制的精确 V5.6.2/V5.6.1 HTML 与合成小媒体，不是新版本。
- `SHA256SUMS.txt`：包内哈希。

**Reproduction note:** 独立脚本使用本轮隔离容器绝对路径 `/mnt/data/cws_v562_reviewer_work` 和 `/mnt/data/CWS_V562_Independent_Reviewer_20261018`；换机器时只需调整脚本顶部路径，不需要改项目源 HTML。需要 Python Playwright、Linux Chromium、FFmpeg兼容的视频解码能力。个人/项目生产环境不得以本容器行为推断全部兼容性。
