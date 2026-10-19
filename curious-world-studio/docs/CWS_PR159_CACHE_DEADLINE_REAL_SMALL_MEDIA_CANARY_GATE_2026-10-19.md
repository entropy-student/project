# CWS｜PR #159最小返修：缓存来源＋总超时＋小文件真实素材Canary（2026-10-19）

> **STATUS=`OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / SINGLE_FIX_AND_CANARY_GATE`**
>
> Owner在PR#159独立Review后明确要求“好的继续下一步吧”。按`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7，**本轮只修F159-01/F159-02两个已被独立核实的问题，并选一条≤30MB且不跳转的真实非Blender素材，在CWS自己`fetch --safe-direct`路径完整下载/QA**。不重新研究TUN/Fake-IP/SSRF架构、不重新跑NASA 87.6MB文件/JPL 301、不开新大规模搜索，不提高尺寸上限。原PR#159安全代理真实CONNECT/证书、IP绑定技术成果保留，但**当前正式结论仍为`PARTIAL_SAFE_PROXY_EGRESS_VERIFIED_NO_MEDIA_CANARY`**。
>
> 旧[PR159独立Reviewer审查](reviews/CW0005_PR159_GENERAL_SAFE_PROXY_EGRESS_INDEPENDENT_PARTIAL_20261019.md)已准确说明两个最小问题及媒体不可下载原因。唯一现行入口由`curious-world-studio/AGENTS.md`顶部`CURRENT_GATE`指定。

## 1. 固定合同

| 字段 | 范围与验收边界 |
|---|---|
| `GATE_ID` | `CWS-PR159-CACHE-DEADLINE-SMALL-REAL-MEDIA-20261019` |
| `OBJECTIVE` | 修复安全直链下载模式的缓存来源误报与整体下载超时问题；**真实使用一个非硬编码catalog视频ID**在Owner保留TUN/Fake-IP状态下完成≤30MB、HTTP200/无跳转、HTTPS MP4/WebM下载、完整FFprobe/FFmpeg/SHA、可回放预览 |
| `TARGET_AND_SCOPE` | Owner Windows 11真实宿主；`entropy-student/project` 的`curious-world-studio/media-pipeline/`、有关单测、仅本Gate专用`.local/media-pr159-small-canary-20261019/`；主线只写必要项目状态/Gate，不碰其它项目 |
| `SOURCE_PIN` | [PR #159](https://github.com/entropy-student/project/pull/159) 当前受审HEAD `59f427d37591d2c6c8aa67033ddc4cfe401a933a`，仍Open/未合并；PR#158固定Blender技术PASS（Open）及PR#157局部安全测试（Open）均不得擅merge或重演 |
| `MAX_ENDPOINT_THIS_ROUND` | 仅修两个缺口+必要直接相邻回归测试；先HEAD核最多2–3个**官方现有**短视频候选，合格后`≤1`个新非Blender媒体GET与正式完整QA；单文件`≤30,000,000B`，本轮临时＋最终媒体合计`≤60,000,000B`；同根因失败只允许一次有新证据的修复/有界复测，不进行盲目重试 |
| `MANDATORY_REVIEW_STOP` | **优先更新原PR#159的同一隔离分支**，附新commit/明确差异、1份实际脱敏ZIP及SHA供独立Reviewer核验，**不合并、不宣布Reviewer PASS、不正式制片或发布**；若原PR分支写权/HEAD真实漂移，停止并精确报告或以明确引用原Head的**一条**小追补PR（不能盲建多个） |
| `OWNER_ONLY_ACTIONS` | 改TUN/Clash/Fake-IP/系统DNS/代理端口、共享Docker/VPS、停其它服务、安装付费软件、登录、强行绕301或私网安全拦截、提高文件硬上限、删除或覆盖旧文件、改PR#157/#158、合并PR、将测试素材加入节目、正式视频渲染/发布均未授权 |
| `ROLLBACK` | 保持Owner网络/其它worktree/媒体/PR不变；未合并的PR#159在确认前不成为main正式代码；只清理由本Gate自身创建且归属可证的临时`.part`或进程，执行日志/哈希/QA留存在隔离`.local` |
| `REQUIRED_EVIDENCE` | Windows身份、分支Head/工作区diff、Proxy/TUN/资源只读回执；原80测试基线及改后运行结果；针对两个缺口的实际CLI代码路径负例；候选原站URL/分辨率/官方标称大小/HEAD真实状态/源License与使用目的；真实CWS CLI和本地文件、FFprobe/FFmpeg完整解码、真实帧、SHA；本轮实际Git diff、回滚记录与脱敏ZIP校验 |

## 2. 两个已经定位的最小修复（不得拓展架构）

### F159-01｜safe-direct缓存来源误报

当前`cws_media.py`的`fetch`先`cached_result(workdir,key,item)`，后判`args.safe_direct`。旧普通yt-dlp/图片下载缓存即使SHA匹配，也能被`--safe-direct`返回`CACHED/CLI exit0`，但本轮**没经过IP固定安全代理**。

- **最小实现首选**：`--safe-direct`模式先检查目标video、指定显式可信代理、catalog来源和安全路径等前置条件；**不允许跨传输缓存被认成safe-direct成功**。最简单可接受方式是对`--safe-direct`完全停用旧缓存捷径（旧媒体文件已在对应路径则返回`SAFE_OUTPUT_ALREADY_EXISTS`并要求使用本轮新隔离workdir，不覆盖/删除）；若实现同模式缓存，必须验证`transport=SAFE_DYNAMIC_DIRECT_MEDIA`与完整可信`safe_proxy_proof`、相同ID/来源与文件SHA，返回的`CACHED`必须显式`network_request_made=false`、不能当“本轮新下载Canary”。
- **强制负例**：构造有效SHA的旧普通`FULL_DECODE_PASS`视频缓存，再调用真实`cws_media.py fetch --safe-direct`，证明不能静默返回0表示本轮新媒体安全下载成功；验证图片的旧缓存不被当作safe-direct视频，未知ID/无代理和已有同名输出不覆盖；旧非safe-direct缓存行为保持。

### F159-02｜全过程wall-clock截止

当前`safe_proxy.open_response(...,timeout)`主要控制socket单次操作；正文`while response.read(...)`只看累计字节，不管累计墙钟。服务器每次在socket超时前滴入一点数据，可能让一条下载执行很久。

- **安全、最小、可实际验证的硬截止**：在单次safe-direct请求链路确立`time.monotonic()`绝对deadline，覆盖**DoH / HTTP CONNECT / TLS / 响应头 / 正文流读取**；阻塞read也需在deadline到时真正中止或强制关闭受控socket，不能仅在下一次返回Python循环后才检查；FFprobe/FFmpeg可用**另有独立已审超时**，不混称为网络60秒。采用已存在运行机制/stdlib最小能力，不安装全局代理服务、不开无限后台线程/无归属常驻进程。失败返回统一`SAFE_MEDIA_TIMEOUT`或明确`SAFE_TOTAL_DEADLINE_EXCEEDED`、清理本轮自身`.part`，无新媒体PASS。
- **强制负例**：受控mock或本地受控HTTPS+代理慢滴流，连续每次读取小量、各次间隔不足单次socket超时但**累计超过总时限**，要求截止内abort且资源释放；另有普通响应可通过及已有非安全模式不受影响。对超时后部分文件、源文件存在和重试语义检查。

### 安全不变量回归

原`safe_proxy.py`的**合法URL/公网A+AAAA/CNAME、多值混合拒绝、数字IP CONNECT及原Host/TLS SNI验证、localhost/私网/Fake-IP/IPv6、身份错误、转跳/manifest拒绝、超大小、编码/Content-Length异常、CWS普通yt-dlp旧`NON_PUBLIC_MEDIA_ADDRESS`**全部不放宽。**不允许用更换网络、忽略证书、跳过DNS/SSRF或提高30MB上限实现测试成功**。保持支持只限单文件MP4/WebM，不自作主张开启平台网页/分段媒体。

## 3. 提供一条已核对官方页面的更合格技术测试候选

之前NASA目标是`87,626,655B`，在30MB上限前正常阻断；JPL 301不可直接跟跳。本次已在官方NASA SVS页面[5582｜OSIRIS-APEX Earth Flyby](https://svs.gsfc.nasa.gov/5582)核对到**两个小文件**：

- **首选**：`https://svs.gsfc.nasa.gov/vis/a000000/a005500/a005582/osiris_apex_092025_ega_top-down_1080p60.mp4`，官方标注**1920×1080，约2.5MB**；
- **备用**：`https://svs.gsfc.nasa.gov/vis/a000000/a005500/a005582/osiris_apex_092025_ega_1080p60.mp4`，官方标注**1920×1080，约6.8MB**。

> 这是**官方页面的文件入口/标称大小，不是本机验证HTTP HEAD已返回200、不跳转或文件已实际可下载**。必须先用刚才已经实现的安全HEAD（数字公网IP pin+原域名TLS）现场读`HTTP200 / video/mp4 / Content-Length<=30MB / no redirect`才能入单文件下载。两个文件是**技术Canary**，不是爆米花真实故事画面/正式素材，不得引用作为CW0005节目StoryFit与版权PASS。优先一条足够，不用把两条都下载；如当前路径临时失效可先在同一官方页面换上述备用，只计实际媒体GET最多一次。

**素材入catalog的方法**：如果本地旧274条目录无此直链，可通过现有`parse_results('searxng','video',{'results':[{'url':..., 'width':1920,'height':1080,'title':...}]})`和`Catalog.add`导入本次专用`.local`工作目录；保留**官方来源页、明确原始直链、作品身份、官方分辨率、暂不入片/技术测试状态**及可复算的ID，严格遵守CWS现有候选记录路径。**不得为绕过项目安全校验让Codex独立curl/PowerShell直接下载并冒充CWS成功**。先导入catalog，再调用真实`cws_media.py --workdir <...> --proxy <实际只读验证的loopback HTTP代理> fetch --safe-direct --ids <catalog-ID>`，用新目录确保旧缓存绝不会冒充本轮真实下载。

## 4. 严格步骤（同一授权Gate内连续推进）

**P0｜Preflight**：最新main、GitHub PR#159 HEAD是否仍为`59f427d...`（如发生变化先只读核diff，禁止覆盖其它Agent改动），当前Windows宿主身份、网络协议/端口、TUN未改、物理可用内存≥1664MiB及临时磁盘；已有PR分支是唯一默认返修目标，保留其历史原80项测试、六文件源码、并与最新main只有文档差异的状态核对。PR#158/157继续Open不处理。工作目录必须隔离，禁止`git reset --hard/clean -fd`对旧工作树。
  
**P1｜最小补丁**：只修F159-01、F159-02，增加对应正反例测试。若旧PR本来已有准确策略，则由事实说明无需重复改；不得无原因再改`safe_proxy.py`其他正确网络层，尤其不能将隐私/证书/重定向保护简化。

**P2｜一次回归**：Windows基线已知80项（如分支真实增加新测试则以新增总数为准），必须跑新增两类负例及全测试、AST/语法和diff-check；失败要按阶段定位不盲重试。**第一次成功/返回后不重复此前已PASS的Blender测试文件下载**。

**P3｜官方小文件有界Canary**：官方NASA页面的首选＋备用优先，安全HEAD最多3个候选（优先两条指定的，不要再遍历全网），确认`200 + video/mp4|video/webm + Content-Length≤30MB + no redirect`，从真实catalog ID执行**一次**新媒体GET与QA。真实文件必须`≤30,000,000B`、`ffprobe`分辨率/编解码/比例/时长、`ffmpeg -xerror -f null`全片解码/实际帧数、SHA256、代表帧；若晚期突然超限/被跳转则正确阻断、留下精确`PARTIAL`，不可越权修改Gate预算。对正式本机素材文件，放`.local`；Review所需媒体由Owner可上传的有界ZIP附件承载（优先小于30MB，ZIP真实清单/SHA），不要把媒体放公共GitHub。
  
**P4｜证据/交付停线**：若原PR#159在Owner当前隔离分支可安全续写，则**在同一PR上追加最小commit**（原review结论历史不改写），提交新Head SHA、局部真实非空patch、`F159_FIX_MATRIX.md`、`CWS_SMALL_MEDIA_CANARY_QA.json`、`PROXY_TLS_CONNECT_CONFIRMATION.md`、`ROLLBACK.md`、必要测试/CI与主机证据，单一脱敏验收ZIP和SHA256。**不自行合并PR**。若PR分支不可写，则显式`RETURN_PR159_BRANCH_NOT_WRITABLE`并给可恢复路径，只有已证明最小替代链接PR必要时可创建一个，不能连发多PR。旧PR#159修正Head可能使Github mergeability状态变化，必须停止交Reviewer决定。

## 5. Reviewer接收门槛

- **`PASS_CANDIDATE_SAFE_DIRECT_MEDIA_CANARY`**：两修复在真实CLI和流慢滴下有反例测试+无回归；一个新非Blender **catalog动态URL通过CWS安全代理GET实际下载≤30MB**、正式全片解码、真实SHA/画面及来源/性能证据；实际CONNECTED IP公有、TLS原域名证书PASS、原防SSRF与禁止跳转不减弱；明确`SAFE_DIRECT_ONLY`、不宣称任意yt-dlp网页/分片PASS。
- **`PARTIAL_CODE_FIXED_MEDIA_BLOCKED`**：两个代码修补与回归PASS，但NASA官方小文件现场没有可用的200安全直链/实际GET仍不能下载；明确真实HTTP状态、预计尺寸、是否发起媒体正文读取与失败原因，不重试旧87.6MB文件。
- **`RETURN_TIMEOUT_GUARD_NOT_PROVEN / RETURN_CACHE_PROVENANCE_FAIL / RETURN_TEST_REGRESSION / RETURN_RUNTIME_DRIFT`**：必需负例、真实网络安全/资源/工作树条件失败，分类精确后停线，不用安全绕过顶替。
- `PASS_CANDIDATE`由Executor提出，**只有独立Reviewer真实取回ZIP、实际文件、GitHub PR新Head、测试和网络证据后才能宣布正式PASS**。单文件技术PASS不解锁CW0005`VISUAL_STORYFIT_HOLD/G1_NOT_PASS/G2_NOT_AUTHORIZED/R4_NOT_AUTHORIZED/RIGHTS_PARTIAL/NO_PUBLISH`。

## 6. `REVIEWER_TO_EXECUTOR_RELAY`（Codex只读启动入口）

请执行`CWS-PR159-CACHE-DEADLINE-SMALL-REAL-MEDIA-20261019`，由Owner 2026-10-19授权的一轮最小修复与真实小媒体Canary。读取当前`curious-world-studio/AGENTS.md`顶部唯一Gate及本文件；只定向读取[PR#159独立Review](reviews/CW0005_PR159_GENERAL_SAFE_PROXY_EGRESS_INDEPENDENT_PARTIAL_20261019.md)、**PR#159真实Head**、`media-pipeline/cws_media.py`的`cached_result/dispatch(fetch)`、`media_pipeline.py`的`download_safe_direct_candidate`、`safe_proxy.py`的`open_response`，以及这两路径的现有单测。**不再泛读仓库/重验Blender、不重跑庞大素材搜索。**

沿本Gate连续完成：P0只读环境/Branch预检 → P1最小修F159-01旧缓存来源误报和F159-02全过程超时 → P2相关负例与全回归 → P3仅NASA官方已列两条小1080p测试MP4优先、一条新的catalog-ID CWS安全下载/FFprobe/FFmpeg/SHA → P4尽量向**原PR#159追加commit**＋脱敏ZIP及真实media审阅附件，停独立Reviewer。无需每步Owner单独批准。**不提高30MB、不绕NASA/JPL重定向或私网/证书检查、不改Clash/TUN/DNS/全局系统、不合并旧PR、不进入正式节目制作**。如果安全/超时/数据源不满足，按精确状态返回并保留真实证据。

**`EXECUTOR_TO_REVIEWER_RELAY`**：七字段最短摘要（结果、改动、测试/下载真实QA、问题、回滚、Reviewer重点、Owner转交），后附**PR#159新的Head SHA（或经核准的唯一替代PR）**、有实际内容diff、脱敏ZIP的Owner本地实际路径+SHA、媒体文件及其能供Reviewer实检的受控附件路径。不能只给Windows本机绝对路径却不上传需要Reviewer验证的文件。
