# GPT-SoVITS 简洁使用说明

状态：**本地 WebUI 已可打开；当前仅作为 CosyVoice 候选，5-case A/B 尚未完成。**

## 1. 启动

双击：

```text
tools/gpt-sovits/START_GPT_SOVITS_ZH_CN.bat
```

浏览器地址：

```text
http://127.0.0.1:9874
```

主界面进入：

```text
1-GPT-SoVITS-TTS
→ 1C-推理
→ 开启 TTS 推理 WebUI
```

## 2. 最快声音克隆

准备一段 **3–10 秒、单人、无音乐、清晰** 的参考音频。

填写：

```text
参考音频        = 上传 wav/mp3
参考音频文本    = 音频中实际说的话，尽量逐字一致
参考语言        = 中文
目标文本        = 想让它说的新句子
目标语言        = 中文
```

第一次测试其余参数保持默认。

## 3. 按场景选择参考音频

同一人物建议保留多种参考：

| 场景 | 参考音频 |
|---|---|
| 普通旁白 | neutral |
| 好奇 / 怀疑 | curious |
| 反转 / 惊讶 | surprise |
| 严肃解释 / 收尾 | serious |

优先换参考音频，不要先大量调 `top_k / top_p / temperature`。

## 4. 长文 / Story Showrunner

不要一次生成整篇 2–3 分钟旁白。

保持现有流水线：

```text
Script
→ Speech Units
→ 每个 Unit 单独 TTS
→ audio QA
→ Runtime Timeline Resolver
→ narration_master
```

字幕文本和合成文本允许分离，例如：

```text
display_text: AI
synthesis_text: A I

display_text: 138
synthesis_text: 一三八
```

## 5. 当前 A/B 测试

先只做 5 类：

1. 普通叙述；
2. 好奇 / 怀疑；
3. 反转 / 惊讶；
4. 短促反应；
5. 严肃收尾。

与现有 CosyVoice 对比：

```text
真人感
音色/噪声
发音正确性
情绪匹配
句间连续感
生成稳定性
```

A/B 通过前：

- 不训练模型；
- 不批量重做整期 43 条；
- 不删除 CosyVoice；
- 不把 GPT-SoVITS 写成 canonical TTS；
- 不为了清除 `pip check` 的 onnxruntime 包名提示而重装 ONNX。

## 6. 当前目标

```text
GPT-SoVITS 5-case A/B
→ 决定音频 baseline
→ 只重生成失败 Speech Units
→ 重新解析 Runtime Timeline
→ 再决定是否恢复剩余画面生产
```
