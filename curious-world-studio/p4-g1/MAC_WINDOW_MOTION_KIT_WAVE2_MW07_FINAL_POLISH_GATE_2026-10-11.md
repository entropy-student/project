# CWS Mac Window Motion Kit｜收尾返工 MW-07 Dock Genie **only**（2026-10-11）

> **GATE_ID:** `CWS_MAC_WAVE2_MW07_ONE_FINAL_VISUAL_POLISH`  
> **授权依据**：Owner在独立Reviewer指出 Genie 中途**6px 横条台阶/文字撕裂**后同意“我们把支线修完，专心推主线”。**只授权一次聚焦MW-07的隔离HTML视觉精修+证据，不是新模板开发/正式Remotion视频集成**。Owner可最终拒绝；若无法修到要求，交 `HOLD` 而不是再连续扩任务。本任务书准备好交独立本地Codex执行，**NOT_EXECUTED**。
> **原审报告**：[第二批独立Reviewer QA](../docs/MAC_WINDOW_MOTION_KIT_WAVE2_INDEPENDENT_QA_2026-10-11.md)，锁定[Wave2原任务](MAC_WINDOW_MOTION_KIT_WAVE2_4_DEMOS_GATE_2026-10-11.md)，第一批V2和原锁定研究桌面均为视觉基准。Owner现有Wave2源包 `cws-mac-window-motion-kit-wave2-20261011(1).zip`，SHA256 `9487840262a7292ac38b975e8ad44e338c0489823bc52afda0e9cf73247e86d1`（必须先读并核对）。

## 一、本轮只修一个视觉问题

- 保留 MW07**已经成立的**完整鼠标→黄灯→Dock Genie非线性吸入→Dock图标停留→逆向恢复 191帧/约6.37秒的故事语义、操作节奏、落点、V2 1920×1080桌面及既有形态。可在新版本中因优化微调各阶段时长，但必须说明精确帧差；**不接受把复杂变形降级成简单缩放/渐隐**。
- 原版 `source/wave2-motion.js` 的 `drawGenie` 以6px高分带做 `ribbonDest(u,q)` 插值，F051等中间帧出现明显**边缘阶梯、字形撕裂、重复横纹**。必须尝试 **1–2px动态采样、足够高的源纹理离屏缓存与插值/整窗变形采样、边缘裁剪**，验证文本/银灰标题栏/红黄绿控制点变形时仍平滑；遵守内存/CPU有界限制。若在高保真下实时性能不达标，先报告瓶颈与有界替代方案，不用粗糙或假Genie达标。
- **严格静态对齐**：开始/结束桌面、Dock、文件图标应与旧Wave2和第一批V2的对应静态基线一致，区别应只发生在 Genie 的瞬间变形，不得改变其它三模板、对象锚点或Aqua配色。
- **仅更改 MW-07**：MW11 Spotlight、MW12 Exposé、MW13 Finder拖拽的历史原包保持原样；无需重拍、重跑它们，除非用于只读回归看受共享组件影响（共享资源如发生变化是越界理由，STOP），**不覆盖原ZIP及HTML**。

## 二、交付和高标准QA

1. 在**全新独立目录**输出MW07 v2.1单独离线HTML（可带原四卡导航但MW11/12/13不能改变）、README、改前/改后同帧1×静帧总览，包含至少 `F037/F045/F051/F059/F067` 等关键运动中间帧；另交 1×与0.5×完整循环且延伸到**终态停留**的真正浏览器录屏和SHA256SUMS、ZIP。
2. 至少三种真实**全窗口**变形画面：开始吸入、中段最大弯曲、快落入Dock，并同样覆盖逆向释放3时点；两个方向必须肉眼看清连续形变和鼠标因果，不可只凭 `seek` 抽帧判定。
3. Reviewer可直接观测和验证：1×真实回放、0.5×检查、逐帧拖动、Reset、Dock图标真实鼠标复点/恢复、目标坐标不漂移、无JS异常与外部网络；**Windows本地如可 file:// 双击，必须真测，否则标 `NOT_VERIFIED_FILE_URL`**。
4. **量化对照**：同尺度下将旧 F051（6px阶梯）与新的中帧放大比较，报告“最大可见阶梯像素/条带采样间隔/文字断裂情况”；新样允许像经典Genie一样发生内容连续拉伸，但**不能出现横条断裂、未连接的投影碎片、黑洞/透明条**。用正常观看观感优先于PSNR等数值。
5. 任何新离线HTML所显示的导入/进度/搜索仍只作 **UI DEMO**；不使用真实研究视频/无权素材、云TTS或网络；不生成正式 MP4、不安装、不删除、不清理、不动其他项目/OpenMontage共享环境/Clash/WG/Remotion/M2源码/GitHub main。
6. **失败即停**：如2px采样导致CPU高耗、真实播放不到终帧/尾帧、窗口拉伸过度仍有严重撕裂，报告 `RETURN_MW07_POLISH_NOT_READY`，保留原证据与替代路线；**一次小修不自动升级为无限返工**。用户不需要再为同一功能重复看十轮。

## 三、交接状态

`MW07_ONE_FINAL_POLISH_READY_TO_EXECUTE / MW11_12_13_REVIEWER_KEEP_CANDIDATE_UNCHANGED / WAVE1_V2_OWNER_PROVISIONAL_PASS / OWNER_FINAL_VISUAL_DECISION_PENDING`。

**交回Reviewer**：新版SHA、变更范围、旧/新 F051并排，播放视频一切观测、阶段帧/鼠标坐标与Dock位置、1×和0.5×实测、是否真正用 file://、局限。**仅MW07局部更新**。若达到“明显更丝滑且仍是Genie”再推荐Owner KEEP，否则标HOLD后优先返回主线R1。
