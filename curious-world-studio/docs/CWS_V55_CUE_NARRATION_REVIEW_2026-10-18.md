# CWS V5.5｜多字幕 Cue + 旁白时间轴：接口与自检

> Gate `CWS-V55-ISSUE10-MULTICUE-NARRATION-TIMELINE-20261018` · `PASS_CANDIDATE / OWNER_PRODUCTION_UNVERIFIED`  
> Owner仅授权原14问题的⑩；Draft [PR#144](https://github.com/entropy-student/project/pull/144)隔离分支，**未合并**，正式CW0005暂停与发布限制不变。

## 目标、基线与回滚

- **目标**：不再局限每镜头一句字幕；在**唯一**Master Clock上按多个Cue起止时刻显示单行字幕，并让本地导入的旁白音轨跟随时间轴的播放、暂停及跳转。音频与Cue的时间关系由用户/编排器**明确提供**，本轮无自动TTS、强制对齐、SRT导入或MP4渲染。
- **直接基线**：V5.4 `storyboard-v5-4-import-asset-map.html` blob `b7b880db77d42a9e35dcf3a833a68924cd4ef4df`。
- **本轮唯一候选**：[storyboard-v5-5-cues-narration.html](../visual/content-template-lab/storyboard-v5-5-cues-narration.html)，Git blob `bbc6f40c1dd6bf1cc4b1c8ab4f55f49e0a13881f`。V5.2 main冻结blob `f002fd3a3fea24352c8eddb63d8f265014a9e93b`及原Research Aqua绘制代码原样保全。
- **权限与回滚**：只新增隔离PR文件，不覆盖冻结版、旧V5.4、既有生产素材/服务；回退只需舍弃新候选。不合并、不部署、不付费、不发布。

## V2 分镜数据协议

保留V5.4全部镜头/素材字段，但导出升级为 `schema:"CWS_STORYBOARD_V2", version:2`：

```json
{
  "schema":"CWS_STORYBOARD_V2",
  "version":2,
  "film":{"fileName":"QUESTION_01.mov","narration":{"assetId":"voice_demo","startAt":4.76}},
  "timeline":{"intro":4.76,"outro":2.3,"total":31.06},
  "assets":[{"id":"voice_demo","fileName":"narration_demo.wav","mimeType":"audio/wav","rights":"UNVERIFIED","sourceRef":""}],
  "shots":[{"id":"S01","template":"T1","duration":3.8,"assets":["..."],"title":"示例",
    "caption":"第一句的兼容摘要","label":"辅助素材",
    "cues":[{"start":0,"end":1.1,"text":"第一句"},{"start":1.15,"end":2.5,"text":"第二句"}]
  }]
}
```

上述片段只演示新增字段，不是可直接导入的完整配置；正式完整7镜头示例随本轮会话ZIP交付。每条Cue时间是**镜头局部秒数**；显示时刻 `shot.start+cue.start` 到 `shot.start+cue.end`（半开区间）；空白间隔不显示字幕。单镜头0～80 Cue，禁止越界、负数、零/反向时长、互相重叠、非数字、超单行安全宽度。旧`CWS_STORYBOARD_V1/version=1`导入时将每镜头`caption`变为覆盖整镜头的一条Cue，再导出V2；不修改V1原始输入。
`film.narration`可为null或`{assetId,startAt}`；对应素材必须在顶层登记并为支持的音频MIME（WAV/MP3/OGG/部分M4A/WebM）。开始时刻是**全片绝对秒数**，音频时间=`max(0,masterTime-startAt)`，到内容结束停止，不隐式循环。播放、暂停、跳转与整个片长始终由一个Master Clock驱动，不创建第二套片长或独立字幕计时器。

## 操作流程与边界

1. 在字幕编辑区为每个镜头添加、调整、删除Cue（局部开始/结束/文字）；超长、重叠和超范围即时提示且阻止导出。
2. 可上传本地旁白WAV/MP3/OGG并自动登记稳定`narration_voice`素材ID；或通过V2 JSON预登记音频ID，再用批量文件关联恢复。**JSON从不存储音频二进制、磁盘路径或授权声明**。
3. 旁白与字幕显示采用同一主时钟和明确的数值时码；**不会自动从音频识别字幕或调整配音停顿**。缺失/格式不支持/权限阻挡的音频可见提示，不能冒充有声成片。
4. 不能从“本轮同步播放器PASS”推断长片4–6分钟、TTS/SRT、真实素材权利、科学叙事或FFmpeg/Remotion导出PASS。

## 验证证据

- **GitHub直接回读**：新候选blob一致，原始V5.2冻结不变，PR#144仍Draft。
- **真实Chromium**：V5.5多Cue/旧V1迁移/空档/越界重叠拒绝/JSON原子性/本地11秒WAV旁白seek与播放暂停/V2导出再导入 **34/34 PASS**；既有V5.4 JSON与素材行为回归 **43/43 PASS**；既有真实MP4、T5局部时码及拒绝非法配置安全媒体回归 **6/6 PASS**。
- **视觉基线对照**：0、1.5、3.5、4.76、5.8、17.1、23.2、29.7、31.06s，原版Mac Canvas 与 V5.4 画面 9/9 像素一致。
- **完整视频时序**：从t=0正常播放到31.06s结束并回原桌面，`playing=false`、内容视口隐藏、JS异常0。本测试用默认无私人版权媒体的素材占位和无外部旁白；旁白同步由合成WAV独立测试。
- **局限**：Chromium `page.set_content` 的实测不等于Owner Windows Edge `file://`通过；11秒测试音频只检验播放器同步，非人工口播音质/实际台词对齐。V2兼容迁移检查为配置层可回读，不等于真实素材自动授权。

## Reviewer意见 / 下一步

本轮⑩的**技术候选PASS**，建议由独立Reviewer检查：V1导入、Cue在暂停/跳转/镜头边界、音轨丢失、时间轴变化后同步、字幕安全区、导入原子性及原版视觉。下一独立工作项原表⑨（T6更灵活数据形式）；⑤真实档案与⑭故事素材匹配留待正式制作，⑪显示语义低优先级。正式`CW0005 R3_RETURN_OWNER_VISUAL_STORYFIT / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`及权利`PARTIAL`完全不变。
