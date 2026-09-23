# GPT-SoVITS Windows 中文启动器

用途：在当前项目记录的 Windows 本地环境中，用双击方式启动 GPT-SoVITS，并强制使用官方简体中文界面。

## 当前约定

- GPT-SoVITS: `C:\AI\GPT-SoVITS`
- Conda 环境: `GPTSoVits`
- Python: 当前项目记录为 3.10.x
- UI locale: `zh_CN`
- 主 WebUI 默认端口: `9874`
- 本启动器不修改 GPT-SoVITS 源码。

## 文件

`START_GPT_SOVITS_ZH_CN.bat`

行为：

1. 检查 GPT-SoVITS 路径；
2. 检查官方 `zh_CN.json` 语言包；
3. 自动寻找常见 Miniconda / Anaconda 的 `conda.bat`；
4. 检查 `GPTSoVits` 环境；
5. 检查当前已知的 WebUI 启动缺依赖：
   - `shellingham`
   - `rapidfuzz>=3.0.0`
   - `platformdirs>=2.5.0`
6. 如果缺失，仅补这三个已知依赖；
7. 设置 `PYTHONNOUSERSITE=1` 和 localhost proxy bypass；
8. 运行：

```text
python webui.py zh_CN
```

GPT-SoVITS 官方 WebUI 使用自身 i18n locale，因此不需要维护独立的“汉化补丁”。

## 使用

把 BAT 放在任何位置都可以，因为项目路径已经固定为：

`C:\AI\GPT-SoVITS`

双击即可。

正常启动后浏览器会自动打开主 WebUI；默认地址：

`http://127.0.0.1:9874`

如浏览器未自动打开，手工访问该地址。

## TTS 推理

在中文主界面：

```text
1-GPT-SoVITS-TTS
→ 1C-推理
→ 选择 GPT / SoVITS 模型
→ 勾选“是否开启TTS推理WebUI”
```

随后会打开独立 TTS 推理界面。

## 如果路径改变

编辑 BAT 顶部：

```bat
set "GPT_SOVITS_HOME=C:\AI\GPT-SoVITS"
set "ENV_NAME=GPTSoVits"
```

不要把本机绝对路径写进 portable `story-showrunner` Skill；这个启动器仅属于当前 validation/runtime workspace 的本机辅助工具。
