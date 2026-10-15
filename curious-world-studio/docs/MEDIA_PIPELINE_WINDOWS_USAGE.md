# CWS MEDIA pipeline｜Windows 本地使用说明

> **2026-10-15运行事实**：MEDIA工具代码已入main，Windows G2–G4已实测**本机Docker Desktop按需启动SearXNG/4get**并停机释放端口；本说明为独立CLI手动入口，**Docker Compose/Windows一键启停脚本尚未作为正式PR入main**。旧文档中“无Docker尚未通过”是历史尝试，不是当前运行路线。G2–G4已完成，见[最新状态](CURRENT_STATE.md)；无需重做Ubuntu注销。

**范围：**该本地可选入口于2026-10-15经PR#129合并`main`；属于CWS素材工具链中的独立入口，用于搜索发现、候选去重与索引、显示方向/格式核验、指定ID下载、FFprobe/FFmpeg QA和本地素材页。它不替代OpenMontage库存来源或正式制作系统，也不改Research Aqua、Remotion、题库或任何节目Gate。

正式项目目前保持 `CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED`。本模块的技术可访问、可下载和解码结果，不代表镜头内容匹配、复用权审核或正式节目批准。

## 本机隔离数据

所有候选索引、下载文件、抽帧和HTML页面必须放在 `curious-world-studio/.local/`。该目录由本项目 `.gitignore` 排除。程序CLI会拒绝 `.local` 之外的工作目录；不要将媒体或运行日志加入Git。

## 使用顺序

1. 查询本机正在运行的SearXNG或4get API。查询记录会被写入索引，不会触发媒体下载。
2. 查看候选ID和来源页面；运行 `probe --ids` 获取单条视频元数据与格式。
3. 只有已显式指定且格式通过显示方向核验的ID才能下载。对下载文件重新检查显示比例、视频流、分辨率、帧率、完整解码并计算SHA-256。
4. 图片须单独指定ID，下载后检查MIME类型、真实图片流、像素、完整解码和SHA-256。
5. 运行 `gallery` 生成本地HTML。真实本地媒体与未验证搜索缩略图使用不同标签。

## 过滤与权利边界

默认排除中国大陆视频平台，并按SAR和旋转元数据校正后的显示宽高比过滤竖屏及方形视频；显示宽高比低于4:3的视频不进入下载队列。未知分辨率进入最多5个格式的有界探测，不会直接误判为竖屏。具体规则见[媒体过滤实现](../media-pipeline/media_filter.py)。

素材记录中的权利状态默认是 `UNKNOWN`。研究来源、素材来源、署名、实际内容及复用许可需要分别核实。不要把此工具的可下载状态作为《视频素材3+1合同》的权利审核结果；OpenMontage与正式视频素材入口仍按原有合同独立运行。

## 网络与运行保护

只在需要时向命令显式传入已验证的HTTP(S)代理。Loopback搜索API走本机直连；子进程不会继承环境中不匹配的代理配置。不要修改系统代理、Clash、VPN或全局PATH。下载仅接受显式ID；每次运行最多30个不同ID、单视频不超过80 MB、视频累计不超过2 GB、单张图片不超过15 MB，并有时间上限。

4get目前只调用首页结果；分页必须先验证当前实例返回的next-page令牌结构，程序不会猜测或伪造令牌。

## 无Docker验收与回滚

无Docker整链试验按[正式Gate协议](MEDIA_DOCKERFREE_RUNTIME_AND_ACCEPTANCE.md)执行。**尚未获得无Docker整链PASS**；即使搜索客户端未调用Docker，也必须验证SearXNG/4get的实际进程来源及是否依赖容器。HTML可由仅绑定127.0.0.1的短时静态HTTP服务器检查，以解决旧`file:`被阻止问题，但必须实际浏览器播放并保留证据。

PR #129已合并`main`，不要将“删除已经合并的源码文件”当成普通回滚。回退已接受的源码应通过新PR/受控revert；本地试验资源位于被忽略的`.local/`，按Owner明确的清理授权保留和处理，不修改历史ZIP。

Research Aqua、Remotion 及“3+1”来源合同未被本PR修改。生产媒体授权、实际动作核验、字幕/音轨/渲染与CW-0005正式Gate均不属于此本地工具的验收范围。
