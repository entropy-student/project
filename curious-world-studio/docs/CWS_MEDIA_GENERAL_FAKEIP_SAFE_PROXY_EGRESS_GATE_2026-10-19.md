# CWS｜一般素材URL在TUN/Fake-IP下的安全代理获取｜联合执行Gate（2026-10-19）

> **唯一状态：`OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / SINGLE_BOUNDED_GATE`**。Owner在2026-10-19独立Reviewer接受PR#158的`PASS_FIXTURE_PROXY_COMPAT`后明确“我同意，继续吧”，授权下一步**从固定测试夹具升级为普通素材候选URL可用的安全下载能力**。本Gate最大端点是**在隔离项目分支实现经实测的代理出口校验、一次实际非硬编码视频获取/QA、回归和独立PR/ZIP**；不可升级为正式制片或对外发布。按`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7执行。
>
> **重要避免误判**：[PR#158](https://github.com/entropy-student/project/pull/158) `ff613307e1ee67846786c00e42fa0a48719fcc52` 已获Reviewer**固定官方Blender测试视频**技术PASS但仍**Open未合并**；`main`的普通`probe_one/download_one`仍在调用yt-dlp前`_validate_public_url`，本机Fake-IP可能使它们报`NON_PUBLIC_MEDIA_ADDRESS`。**既有固定Blender路径不代表“任意视频站点下载”的安全授权；本轮不得重复下载Blender或重跑历史搜索。**

## 1. Gate固定合同

- **`GATE_ID`**：`CWS-MEDIA-GENERAL-FAKEIP-SAFE-PROXY-EGRESS-20261019`
- **`OBJECTIVE`**：不关闭Owner TUN/Fake-IP或修改Clash设置，让**非硬编码、来源可审的正常素材候选URL**可通过现有回环HTTP CONNECT代理安全地完成受限格式探测/可行时真实下载，解决此前CWS把本机Fake-IP误用为远端最终地址从而在网络请求前拦截的问题，且**不削弱未知URL访问私网/保留IP/重定向/云元数据地址的防SSRF边界**。
- **`TARGET_AND_SCOPE`**：Owner Windows 11实体机，GitHub `entropy-student/project/curious-world-studio/media-pipeline/`；最新main建立干净CWS隔离worktree/分支及`curious-world-studio/.local/media-generic-fakeip-20261019/`运行证据；原始旧工作树、历史媒体/缓存/ZIP保留不动。
- **`MAX_ENDPOINT_THIS_ROUND`**：①仅定向读回main与未合并PR#158真实Head/三个改动文件，必要时在新隔离分支**原样复用PR#158已核的受限基础实现**（可明确cherry-pick或从PR#158已验文件进行最小移植，绝不擅自merge到main）；②在现成媒资管线加**最小、可审的动态候选代理路径和负例测试**；③使用**2个不同真实来源站点**的有限合法公开媒资候选做连通性/探测测试（可以沿用已有目录，禁止再大范围搜片），**最多1条新的、不是Blender的真实视频完整下载**，新增媒体单文件`≤30MB`、总`≤60MB`、下载同源最多一次真实尝试/另一候选最多一次有证据的修复后尝试；④完成真实解码/SHA及脱敏PR/ZIP停独立Reviewer。不要求两个站点各下载；不要求一定进入未经证实的yt-dlp分段视频站点。
- **`MANDATORY_REVIEW_STOP`**：Executor交`PASS_CANDIDATE_SAFE_DYNAMIC_DIRECT_MEDIA`、`PASS_CANDIDATE_SAFE_EXTRACTOR`、`PARTIAL_* / RETURN_*`之一并交新PR、Head SHA和真实ZIP；**不自行合并任何PR/修改CW0005冻结正文/视频/发布**；Renderer G1/G2/R4均不解锁。
- **`OWNER_ONLY_ACTIONS`**：更改Clash/TUN/Fake-IP/DNS/系统代理/防火墙、添加本机特权/常驻代理服务、部署VPS/公网代理、共享Docker修改、付费/登录、禁用SSRF/绕过站点认证/DRM、真实商用素材入片、清理旧工作树、合并PR、发布或正式视频制作全部不在本Gate权限内。若安全实现需要这些行动，返回精确阻塞而非代行。
- **`APPLICABLE_CRITICAL_CONSTRAINTS`**：V5.6.2壳及59.933秒样片技术已PASS不得重复返工；历史PR#155素材流程`RETURN_PROCESS_COMPLIANCE`、PR#156搜索`PARTIAL_SEARCH`、PR#157安全测试Open、PR#158夹具PASS且Open；项目级视频唯一使用、排大陆平台/方形竖屏、优先1080p与`RIGHTS_PARTIAL / CW0005_VISUAL_STORYFIT_HOLD / G1_NOT_PASS / G2_NOT_AUTHORIZED / R4_NOT_AUTHORIZED / NO_PUBLISH`继续保持。**本轮只证明技术下载，不拿旧274条的版权普查当安全网络修复前置**；测试源仍须公开可合法取用，不把第三方未知权利视频分享到Git或用于节目。

## 2. 冻结的安全策略：不得“代理可用就放行任何网址”

本次核心障碍不是`yt-dlp`完全不能下载，而是**本机TUN Fake-IP DNS结果不等于实际HTTPS访问目的地**。OWASP SSRF防护要求校验最终网络目的地、避免DNS rebinding/检查后再解析导致的失配、拒绝或逐跳重新校验重定向；单独一次公共DoH回答、`Host`字符串合法、HTTP CONNECT握手成功都**不足以**证明代理真实出口安全。

**执行者按能力优先复用最小路径，禁止默认新建通用服务**：

1. **路径A（优先）｜独立的受控HTTP(S)素材直链下载**：从现有真实`catalog`指定ID选择**非Blender的、运行时读取的`https://`普通视频直链**（非硬编码某一域名）；严格URL解析（schema/port/用户名密码/编码/IP字面量/私有域/协议别名等）、**对域名的全部目标A/AAAA做可信公网解析和地址分类**，只有**实际代理CONNECT的目的IP被绑定到已验证的公网IP**且该连接对原域名做有效TLS SNI/证书验证时才可以通过。确保通过代理真正连接的目标地址就是已检查公网地址，避免`DNS precheck→代理自行另解析`的绕过；如当前Clash HTTP CONNECT不支持IP地址目的端且保留原域名TLS/规则，必须停止这一通路而不是回退到无凭证的域名CONNECT。**外部DoH一次返回public IP不能代替目标连接绑定/证书验证**。在真实媒体直链下载中默认拒绝所有自动跳转，或在每一跳重新执行同一地址绑定/证书检查；任何playlist/manifests/子URL不自动追踪，无法自审时`PARTIAL_NESTED_MEDIA_UNSUPPORTED`。
2. **路径B（如果现有可信能力具备）｜按原始提供方受限的媒体API**：已有OpenMontage Pexels/Pixabay官方适配器或原站稳定API若能在当前代理环境下正常工作，可以优先复用，不要求安装新库/下载器；但要**准确说明其网络目标防护责任和可审对象**，不能因为适配器在历史曾下载成功就证明任意未知域名安全。最多做一条直接受控下载Canary，不得将受信API下载误报为未知候选任意URL安全。
3. **路径C｜一般视频网页+yt-dlp复杂提取器**：`yt-dlp`可能在页面加载后访问第三方嵌套URL、manifest、分段/CDN与跳转。**只有确能截获/审核所有派生目标、锁定每个实际代理出站目的地并限制协议/重定向/大小的实现证据，才可启用此类泛用来源**。当前已有`--proxy`参数并不等于这种安全能力。若无法安全实现，仅对直链支持宣布`SAFE_DYNAMIC_DIRECT_MEDIA`，明确`GENERIC_YTDLP_EXTRACTOR_BLOCKED`并保留旧拒绝，**不得把这当整轮失败而重新刷几百条源**。
4. **原无代理/直接连接路径**：对非全局IP或混合Fake-IP的`_validate_public_url`保持原有严格拒绝；`198.18.0.0/15`、127/8、169.254/16、10/8、172.16/12、192.168/16、IPv6回环/ULA及云元数据不能因为处于TUN/代理而视为合法公网。禁止使用“域名看起来不像私网就跳过检测”、大量域名宽白名单或本机Fake-IP允许表。

### 设计现实性与降级规则

- **严禁假设**既有Clash/Verge提供代理出口目的IP证明。若现成代理确实不能接受“验证后的数字IP CONNECT＋保留原Host/SNI”的等价模式，也不能从它读取可信逐目标出口地址，执行者应明确证明哪个协议阶段不支持，标`RETURN_PROXY_EGRESS_PINNING_UNAVAILABLE`；**本Gate不授权修改Clash配置、VPN规则、添加特权出站网关或用公网服务器代替本机**。
- 可以在隔离分支实现原有媒体程序使用的标准库/现成依赖**必要的极少量“验证并固定连接目标”的客户端适配**，但要在最小功能单测通过且没有其他来源回退漏洞的前提下真实试；不能只用模拟的`getaddrinfo`单测得出代理出口被验证。
- 若需要单独研究一个安全转发架构，这超出本轮最小修正：保留诊断证据交`PARTIAL_SECURE_PROXY_EGRESS_ARCHITECTURE_REQUIRED`，不要再为了持续交PASS虚构旁路。

## 3. 单轮连续执行计划

**P0｜只读身份/网络前置**：
- 核Windows实体机、项目Git根目录/最新main、PR#158未合并及具体`ff613307...`代码源、新隔离分支/非目标未提交文件；任何“已PASS代码存在于main”的判断需从真实blob读回而不是记忆。新工作分支若选择复用PR#158，注明依赖、来源SHA、测试基线及PR重复/后续合并策略；不得推着PR#157、PR#158进入main。
- 核HTTP代理**当前实际**loopback协议与端口（历史7897只是快照）、当前TUN/Fake-IP与可用内存`≥1664MiB`、磁盘。不得泄露本地代理/网络出口真实地址值，敏感字段在Owner本机脱敏；**不用Docker、SearXNG、4get、广泛爬虫，不再次下载旧Blender测试MP4**。
- 在已有274条候选索引/既有受信视频站点内挑至多**2个可信公开、真实合法可访问、非历史已用节目资产**，只挑能验证真实内容和取得直接媒体的候选；不要为选源启动全网搜。确认可下载性/许可页/原站归属以测试用途留证，不涉及节目发布授权。

**P1｜唯一故障域与设计比选**：
- 分离`INPUT_URL_POLICY`、`LOCAL_FAKE_IP_RESOLUTION`、`PROXY_PROTOCOL`、`REMOTE_RESOLVE_AND_REAL_EGRESS`、`TLS_IDENTITY`、`REDIRECT/NESTED_MEDIA`、`MEDIA_CAP`七层，固定两个具有意义的实现选项（已存在的受信API vs IP-pin直链出口），先看现有库/Clash协议事实能否完成实际目的地址校验。只走**一个最小可行解**；不因CWS安全拦截正确而直接更改所有下载器。**不允许DNS预检结果公共但下一次CONNECT实际目标未知的方案**。
- 必要时在隔离分支最小修改`media-pipeline/media_pipeline.py`、`cws_media.py`及集成测试；目标是实现普通catalog候选选择（ID而不是新的用户任意URL直接高权限调用）、Proxy-aware安全直链探测/下载，并维持已验证PR#158的固定夹具语义，**不要另造长期跨项目HTTP代理程序**。

**P2｜安全负例＋正例**：
- 必须覆盖：loopback/私有/保留/混合DNS、IPv4/IPv6、数字IP/百分号/Unicode/反斜杠/用户信息/非HTTPS或未受理端口、含恶意跳转到云元数据`169.254.169.254`、302多跳、可信域首次公网后变私网的DNS rebinding、代理端口不匹配或恶意非loopback代理、TLS SNI/证书名错误、验证后CONNECT不同IP、超限/截断/下载后嵌套清单、不允许的local ffmpeg网络协议、无响应和超时、旧PR#157的混合Fake-IP防护仍在普通路径生效。每个反例按实际代码路径fail closed，而不是只验证一个固定函数会抛ValueError。**本机正常TUN环境无需改动**。
- 在不调用真实外网的单测中**可用mock远端代理确认CONNECT目标和原域名SNI被绑定**，真实网络Canary必须用可审日志确认真正握手路径/实际连接目的地与TLS验证已完成。基线旧60或PR#158候选67（取决于实际分支基线）、新增测试都必须通过；PR#158/157已有测试不可被简化或静默删除以凑绿。

**P3｜真实、有上限的新来源测试**：
- 从catalog动态选择一个**不是Blender，非硬编码URL**的公开合适视频素材`https://`（最好≥4:3横屏、内容源明确），先安全媒体属性探测/实际预览，再在所有安全前置通过后最多下载1个完整源文件`≤30MB`，本轮临时片段+文件累计`≤60MB`，独立FFprobe/FFmpeg完整解码、文件SHA、真实帧数/尺寸/比例/时长；2个不同站点可以一条完整下载＋另一条metadata-only探测，不强制两条完整下载。候选因法律/站点保护无法访问时换已有的另一个公开合法候选一次，不要登录/突破403/DRM或重复阻塞重试。
- 必须实际运行**CWS一般候选路径**，不是单独yt-dlp、固定`canary-blender-fixture`、PowerShell浏览器下载或其它绕过。真实截图/关键帧只在用户授权本机忽略目录或验收附件保存，不含第三方不当版权/隐私；不把视频放Git。
- 若仅安全直链下载成功，交`PASS_CANDIDATE_SAFE_DYNAMIC_DIRECT_MEDIA / GENERIC_EXTRACTOR_UNVERIFIED`；只有一般页面型yt-dlp及派生子请求逐跳目的校验也实测通过，才能`PASS_CANDIDATE_SAFE_GENERAL_EXTRACTOR`；两者不混同。

**P4｜交付与回滚**：
- 输出一个新PR与**一个脱敏ZIP + SHA256**（ZIP含有用的**非空源码diff**、`ROOT_CAUSE_AND_EGRESS_POLICY.md`、`PROXY_CONNECT_TLS_PROOF.md`、`NEGATIVE_TEST_MATRIX.md`、`DYNAMIC_MEDIA_CATALOG_SELECTION.json`、`MEDIA_DOWNLOAD_QA.json`、`ROLLBACK.md`、`EXECUTOR_HANDOFF.md`、任何不能交付的具体原因）；保留完整run证据在新`.local`，媒体原片仅本机和Owner/Reviewer可合法访问附件，**不得发到公开GitHub或向私人浏览器求权限**。此前PR#158 ZIP空`source-diff.patch`的缺陷，本轮必须生成实际Git diff或标`NOT_AVAILABLE`并附GitHub正式patch地址，不允许假装空文件是diff证据。
- 仅删除/停止属于**本轮新创建且可证归属**的临时进程，保留系统TUN/Clash/全局Docker/所有旧文件；`git clean/reset --hard`和批量清理禁用。回滚即不合并新PR/弃用隔离修补，新旧PR#158/#157保持不受影响、原59.933秒音画/冻结HTML不动。
- 单轮同根因最多1次有证据修复与1次回归测试；第二次同类失败且无新事实即`RETURN_*`，不要无穷循环。外部服务阻断/版权未知/网络端点安全无法证明，保留`PARTIAL_*`与具体证据。

## 4. 验收矩阵

| 候选结论 | 必须有的证据 | 不可以被误读为 |
|---|---|---|
| `PASS_CANDIDATE_SAFE_DYNAMIC_DIRECT_MEDIA` | 新运行时catalog媒体直链、两不同域名校验、实际CONNECT到已验证公网IP且保留原域名TLS证书与SNI、下载1份`≤30MB`、FFprobe/FFmpeg/SHA、完整负例PASS | 全平台yt-dlp/任意素材网页可下 |
| `PASS_CANDIDATE_SAFE_GENERAL_EXTRACTOR` | 上述全部成立，且yt-dlp网页解析的所有302/CDN/manifest/片段URL均逐跳执行同等安全验证并做完整实际下载QA | 正式爆米花视频已可直接发布 |
| `PARTIAL_SAFE_DIRECT_ONLY` | 可证明受信来源/固定代理直链可下，但普通catalog动态URL或远端出口安全还未充分验证 | “通用下载已修复” |
| `RETURN_PROXY_EGRESS_PINNING_UNAVAILABLE` | 有证据显示现成HTTP CONNECT/Clash无法把已验证公网IP与TLS原域名绑定，或无法读取真实出站目标 | 可以使用Fake-IP白名单绕过 |
| `RETURN_TEST_FAILURE / RETURN_UNSAFE_REDIRECT / RETURN_RUNTIME_DRIFT` | 明确日志和失败代码，不产生外部源媒体乱下载 | 再扩展274个链接查询 |

无论新候选结论如何，**正式PASS只由独立Reviewer核验真实证据后宣布**；原[PR#158固定夹具PASS](reviews/CW0005_PR158_TUN_FAKEIP_FIXTURE_PROXY_COMPAT_INDEPENDENT_PASS_20261019.md)不失效，但不自动变为通用源PASS。旧HOLD/G1/G2/R4/NO_PUBLISH保持。

## 5. `REVIEWER_TO_EXECUTOR_RELAY`（唯一直接启动入口）

> 请执行Owner于2026-10-19授权的`CWS-MEDIA-GENERAL-FAKEIP-SAFE-PROXY-EGRESS-20261019`。从最新main的`curious-world-studio/AGENTS.md`及**本Gate**开始。按本Gate顺序执行`P0真机+Git/代理状态→P1最小安全端点绑定设计/条件式修补→P2正反例→P3最多一份新的动态候选真实下载/FFmpeg QA→P4隔离PR/脱敏ZIP交Reviewer`；**本Gate内允许连续执行，无须每一步暂停请求Owner审批**。
>
> **精准阅读**：仅`media-pipeline/media_pipeline.py`相关`_validate_public_url/_opener_for/probe_one/download_one/qa_media`、`cws_media.py`的`--proxy`和`probe/fetch`路径、`tests/test_integration.py`；[PR #158](https://github.com/entropy-student/project/pull/158)实际三文件增量（尚未合并，HEAD `ff613307e1ee67846786c00e42fa0a48719fcc52`）及[PR #158 Reviewer固定夹具PASS](reviews/CW0005_PR158_TUN_FAKEIP_FIXTURE_PROXY_COMPAT_INDEPENDENT_PASS_20261019.md)；[PR #157混合Fake-IP保护审计](reviews/CW0005_PR157_INDEPENDENT_MEDIA_E2E_REVIEW_PARTIAL_20261019.md)只核负例；既有274候选本机工作目录仅需少量定位。**不反复读取完整治理或项目历史，不重做Blender，也不重启Docker/SearXNG/4get**。
>
> **必须守卫**：不可关闭本机TUN/Fake-IP或更改Clash/DNS/系统代理；不可让任意URL绕过`NON_PUBLIC_MEDIA_ADDRESS`，不可凭一次外部DNS公共结果+普通域名CONNECT谎称防SSRF。验证实际IP目的地绑定/TLS/重定向/嵌套媒体；若当前技术路径无法确保安全即`RETURN_PROXY_EGRESS_PINNING_UNAVAILABLE`，**不要自建特权代理/外部服务绕路**。优先现成组件和最小源码改动。跑测试/真实下载有界不强行凑成功，保留之前通过的局部能力。
>
> **`EXECUTOR_TO_REVIEWER_RELAY`**：七行简报（结果、变更、验证、阻塞、回滚、Reviewer重点检查、Owner转交）＋新PR/HEAD SHA/完整未伪造差异/脱敏ZIP路径与SHA/必要的真实文件审阅方式。PR只送审，绝不自行合并/正式视频入片/发布。
