# Curious World Studio V5.6.1｜五项局部返修复核包

日期：2026-10-18
状态：`PASS_CANDIDATE / INDEPENDENT_REVIEW_PENDING / FORMAL_PRODUCTION_HOLD`

## 源码身份

- 新HTML：`CWS_原版Mac六模板_V5.6.1_五项局部返修.html`
- GitHub候选路径：`curious-world-studio/visual/content-template-lab/storyboard-v5-6-1-targeted-review-fixes.html`，隔离分支 `cws/content-template-lab-v1-20261017`，PR #144仍Draft。
- 新 Git blob：`3cd8b040a9f106ca7d0876b55b34ab71088af175`，SHA256 `44319df40d2b6e14400f720b97d4a34161ae0cef89c9d9e3a7b5c54e5b8fa213`。
- 父文件 V5.6 blob：`a0213f7991968fabd3f36be99363310d27324422`。
- 唯一main冻结V5.2 blob：`f002fd3a3fea24352c8eddb63d8f265014a9e93b`，**未改**。

## 五项返修

| 问题 | 本次修改 | 实际判定 |
|---|---|---|
| R-01 单位空格导致百分比差值被当成百分比 | 校验阶段统一`trim`指标单位，比较层使用规范化单位；绝对差值以“百分点”呈现 | `" % "` +5→40显示`+35 个百分点` |
| R-02 不同MIME静默替换 | 批量关联要求完整子类型相同（WAV等价别名除外）；逐槽及旁白手动替换格式需用户明确确认，取消不改登记 | `video/webm`拒绝`video/mp4`批量绑定，手动同意后可换 |
| R-03 非零极小变化被显示为零 | 当设定精度导致非零结果显示为零时，启用有意义的有效数字回退 | `100000000→100000001`显示`+0.000001%`而非`+0%` |
| R-04 小数柱形默认尺度失真 | 默认使用最大实际绝对值作为比例基准，全部为零时安全回退1；显式传入刻度优先 | `.001` / `.01`显示10%/100%，显式0.1仍为1%/10% |
| R-05 版本与导出命名 | 页面显示V5.6.1，JSON文件名V2，原JSON schema保持`CWS_STORYBOARD_V2`，兼容导入V1 | 通过 |

额外数值安全：拒绝因极端输入产生非有限计算结果的比较配置。没有增加模板数量、外部素材、动画、音画生产功能。

## 自检证据

- `test_v561.py` / `V561_TEST_RESULTS.json`：真实Chromium专项 **40/40 PASS**，其中Mac `canvas#view`与父V5.6在10个时间点逐像素一致；无JS异常。
- `test_media.py` / `MEDIA_RESULT.json`：**7/7 PASS**，包括合成5秒MP4在T5第二阶段0.30秒本地时码、11秒WAV与Master Clock的seek/播放/暂停。
- `test_fullplay.py` / `FULL_PLAY_RESULT.json`：同一V5.6.1最终HTML从t=0实速播放到31.06秒，`playing=false`，单Mac画布，内容视口隐藏，返回桌面，**PASS**，JS异常0。用页面内默认媒体占位完成全程，不能替代带真实配音素材的4–6分钟MP4输出。
- `apply_v561.py`：逐处唯一匹配的最小差分脚本，输入V5.6 Git源字节，输出新候选。
- 运行环境：Linux隔离Chromium `page.set_content`，**未测Windows Edge通过`file://`打开**，没有自动联网抓素材。

## 下一位Reviewer应重点复核

1. R-01百分比差值与百分比变化率概念不可混淆；trim前后合法单位一致，JSON导出规范化。
2. R-02验证批量模式严格MIME，手动不同格式需要显式确认，拒绝时不破坏原登记/已加载URL；关注WAV别名。
3. R-03对正负极小值、真正零、数量级极端输入精度核查。
4. R-04自动刻度、明确指定刻度、全部零、负数零轴不引入误导。
5. R-05版本/下载文件名改正且旧V1/V2 JSON导入、T5及多Cue旁白同步保持。
6. 不重复改造 Mac／增加第七模板／开放发布；可独立审查实际源码、测试脚本，不可仅依赖本报告PASS_CANDIDATE。

## 项目边界

本轮Owner授权仅修R-01～R-05。冻结V5.2不动，PR#144保持Draft、未合并。正式CW0005 `R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`与素材权利`PARTIAL`不变。真实4–6分钟知识片的旁白制作、SRT/MP4导出与版权审查仍没有执行和验收。