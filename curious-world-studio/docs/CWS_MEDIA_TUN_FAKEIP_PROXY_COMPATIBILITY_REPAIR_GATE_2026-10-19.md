# CWS｜TUN / Fake-IP 与媒体下载安全校验兼容修复 Gate（2026-10-19）

> **状态**：`OWNER_AUTHORIZED / EXECUTOR_NOT_DISPATCHED / SINGLE_SCOPE_REPAIR_GATE`。
> **原因**：Owner已确认继续推进，并要求按现行治理解决本轮唯一优先技术阻塞。PR#157只证明`NON_PUBLIC_MEDIA_ADDRESS`对于混合Fake-IP地址的安全拒绝有效，但**没有**证明CWS能在Owner正常启用TUN/Fake-IP时安全请求与下载视频。本Gate聚焦**代理感知型路径**；不重新做SearXNG/4get搜索，不拿素材版权讨论阻断“已许可测试片的技术下载”，不要求Owner修改网络模式。
> **上位规范**：`entropy-student/spike.skill/main:vps-project-governance/VNEXT.md` v0.2.7；项目`AGENTS.md`现行入口及[PR#157正式Reviewer结论](reviews/CW0005_PR157_INDEPENDENT_MEDIA_E2E_REVIEW_PARTIAL_20261019.md)。

## 1. 工作合同

| 字段 | 冻结内容 |
|---|---|
| `GATE_ID` | `CWS-MEDIA-TUN-FAKEIP-PROXY-COMPAT-20261019` |
| `OBJECTIVE` | 在Owner现有TUN+Fake-IP不变时，让CWS现有媒体链能**以安全、可复现、明确代理**取得一个来自可信公开来源的测试MP4；维持对未知来源、私网、保留IP、混合DNS、可疑重定向的防护 |
| `TARGET_AND_SCOPE` | Windows 11 Owner真机；`entropy-student/project/curious-world-studio/media-pipeline/`；最新main干净隔离分支与忽略的`.local/media-fakeip-compat-20261019/` |
| `MAX_ENDPOINT_THIS_ROUND` | 只定位当前TUN/Fake-IP→现有代理→CWS拒绝点，在必要时对**CWS媒体安全校验/代理选择的最小代码和单元测试**实施修复，在**一条已验证可信的官方公共测试视频**上完成请求、至多一次受控完整下载、FFprobe/FFmpeg/SHA。单文件与本轮新增媒体总量`≤10MB`，下载源重试0、同因最多2次有限检查；PR#157原8行安全回归测试应作为验收参照，不为合并它而擅改其历史PR。允许一个由源码控制的只限可信目标的临时HTTP mock/proxy测试夹具，无需 Docker/搜片扩张 |
| `MANDATORY_REVIEW_STOP` | 新独立PR、commit、一个脱敏ZIP（附SHA）交独立Reviewer；**不自行合并PR、不能将`PASS_CANDIDATE`写成Reviewer PASS** |
| `OWNER_ONLY_ACTIONS` | 修改Clash/Mihomo/Verge/TUN/Fake-IP/DNS/系统代理、共享Docker/网络、外部服务器、登录/付费、删除旧文件、发布、重渲正式CW0005视频、正式版权复用全部**未授权**；若必须触及，精确RETURN并保全现场 |

### 明确复用现有已证实的成果

- **2026-10-11成功对照**：[显式代理Blender/Sintel实际下载及独立解码](P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md)：历史`https://download.blender.org/durian/trailer/sintel_trailer-480p.mp4`，约4.37MB，历史输出SHA `b670602fa00934ca27c4351bb0efe7ea7a07fae57284e44226025eeed7c51254`、52.208秒、854×480/24fps。历史成功调用yt-dlp时**显式指明当前已探明的Clash HTTP代理协议**；当时7897端口只属历史检查，不是今天可直接硬编码的恒定端口。此旧视频可在**隔离技术测试**重取一次，但绝不作为新的节目素材，故不违反“每条节目素材只在作品里用一次”规则。
- **2026-10-12另有OpenMontage Pexels/Pixabay两条视频下载成功**，与本轮目标互相印证，但不要求为本轮再试/下载两条或调用未配置的Provider API。
- **本机2026-10-19真实障碍**：PR#157的聚合DNS`PRIVATE/RESERVED_FAKE_IP`，`_validate_public_url`先行检查`socket.getaddrinfo`，拒绝后yt-dlp未收到URL；测试证明拒绝符合现有防SSRF意图，**不能删除守卫**。内存与源码已在PR#157回报正常，不重开这两条问题。
- 该Sintel URL是**技术测试夹具**，如果本轮失效或重定向未知/返回403/429，不得为了完成“下载1条”而泛搜其他平台。只在已存在的、可信的等价正式测试URL有现成授权与少量替代证据时用一次替代，否则精确`RETURN_FIXTURE_UNAVAILABLE`。

## 2. 关键方案边界——不是“关闭检查”而是“匹配代理模式的检查”

**现有非代理/direct路径完全保留原有`_validate_public_url`：** 任何非公网IP、IPv4/IPv6保留/私网、DNS混合公私地址、回环/localhost、非法scheme/凭据、受限跳转继续失败。代理路径需先证明它本次是Owner已启用并由用户空间正确连接的**可信127.0.0.1 HTTP CONNECT或等价明确端口**；读取实际端口和协议、只记录脱敏`HTTP_OK/SOCKS_ONLY/UNAVAILABLE`，不改设置。不能依赖`HTTP_PROXY`字符串，其在历史曾出现“HTTP scheme指向SOCKS5端口”错误。

**两种信任边界严格区分：**
1. **可信的固定官方测试主机**（仅本轮确切Blender下载URL）：可定义独立`trusted_fixture_proxy`路径，让HTTPS**域名**通过经核实的本机HTTP CONNECT代理处理，不把TUN本地合成的Fake-IP当实际目标连接地址。做强制HTTPS、固定主机+路径/端口白名单、不带user/pass/敏感query、非直接IP字面量、拒绝私网/localhost目标、证书验证、大小/超时/重试限制、重定向默认禁止或严格同等校验；完整记录本机目标主机识别、HTTP status/Content-Type/下载指纹、私网否定测试。**若下载工具不能真实约束所有跳转/子URL/嵌套清单则此路径必须限为固定直接MP4测试，不能扩大为任意网站/yt-dlp通用Pass。** 也不可仅凭HTTP CONNECT成功就谎称透明获得了代理出口远端真实IP。
2. **未知的搜索候选URL/通用下载**：在**没有**远端解析/连接目的地和重定向等价防SSRF校验事实之前，`_validate_public_url`严守原样，**不支持“只要开代理就跳过DNS全局拦截”**、不接受泛域名白名单、不把`198.18.0.0/15`标为公网。不允许用外部DoH一次公开解析来自动认可某条未知URL。若技术上需新的可信代理出口/逐跳防护机制，这属于本Gate之外的明确架构变更，停止于精准`PARTIAL_SECURE_PROXY_PATH_REQUIRED`。

**优先最小实现**：先对照已存在的yt-dlp显式代理成功路径与`media_pipeline.py`当前HTTP代理/下载安全调用层；若可用旧合法工具的受限接口/包装方法而不新增模块，优先拼接复用。若需要加少量`trusted_fixture_proxy`回归路径，必须独立命名并在代码和日志注明`FIXTURE_ONLY_NOT_GENERIC_SOURCE_APPROVAL`，防止后续不经审查被普通下载候选复用。

## 3. 任务次序（本Gate内连续执行，不拆多轮审批）

**P0／一次性前置**：定位Owner真实Windows、最新GitHub main commit、源文件blob、隔离worktree、历史PR#157仍Open与相邻工作树非目标改动。检查当前Clash实际本地HTTP CONNECT可用协议及端口、`HTTP_PROXY`类型是否和监听匹配，TUN和Fake-IP现状仅只读状态，不向日志记录个人IP、端口完整路径、凭据。实际可用物理内存要通过沿用1664MiB门槛，磁盘至少满足10MB加工作树开销，避免关闭其他项目应用；不开Docker和通用聚合搜索。

**P1／最短对照**：使用**完全相同的官方可信URL**，比较三层：A) 现有历史成功类型的受限yt-dlp显式HTTP代理调用（优先`--skip-download --dump-single-json`这类元数据/有限请求；完整下载预算留给P3），B) 现有CWS DNS检查记录其失败类别（这一步**禁止对未知URL放宽/出网**），C) 新方案受限代理处理结果。P0后若事实证明根因其实为端口协议不符、TUN DNS混合或其它，按真实证据选择**一个**最小修正；不为不存在的毛病发明通用中间件。允许在同一轮内最多一次补丁与一轮负例回归，必要时小修改后再测一次，仍失败则精确RETURN而不是猜测性循环。

**P2／安全回归**：先验证旧单测baseline，覆盖PR#157混合DNS Fake-IP守卫（即使该PR还未合并，亦需在新隔离分支把等价负例覆盖带上，注明来源；勿双份重名）、非法代理协议/端口、非loopback代理、私网IPv4/IPv6和回环、混合DNS、重定向至`127.0.0.1`、`192.168.*`或`198.18.*`、HTTP URL、可疑跨站media manifest/嵌套URL、绕过下载上限、超时/异常分支，均应**被拒绝**或按合法旧契约安全失败。**测试直接代码实际工作路径，而不只是模拟`_validate_public_url`本来就会抛错的静态事实**。正式源码变更仅项目`media-pipeline/`和相关测试，不改变DNS全局策略。

**P3／可验证的本机真实技术Canary**：只有P2必要拒绝测试均Pass且本轮实际代理可工作，才向确切官方Blender小MP4执行至多一条`≤10MB`下载，`ffprobe`检查分辨率/编解码/时长/实际SAR，`ffmpeg -v error -xerror ... -f null`**整片解码成功**并计算SHA。核本轮source/redirect及代理实际路径，`HTTP_STATUS_2XX`并非“下载文件成功”。如文件与历史SHA不同不一概判恶意，但必须事实区分源改版/响应体异常，保留可验证技术内容；不要把历史已使用视频作为CW0005新镜头，也不得对历史PR#155的流程缺失追溯补证。

**P4／Evidence / PR / 回滚**：一个`.local`目录保留必要脱敏技术日志（URI不含token/查询私参）、实际命令的**脱敏版本**、每层代理协议/失败code、Git来源、真实网络出口模式描述（不虚称能看到远端代理DNS解析或IP）、命令退出码、FFprobe JSON/FFmpeg完整解码/文件SHA、端口与安全负例测试。一个新的隔离PR包含仅需长期复用的最小源码/测试改动和1份简明执行摘要，项目`.local`原MP4不可推公共Git；回滚为不合并PR/停本轮新建进程，旧本机媒体/旧PR/冻结模板/Clash配置全保持。交一个验收ZIP（包含脱敏记录、代码差异测试证明、必要QA；原视频可按受许测试材验收放本机，给Reviewer能访问的文件或受控附件，不能使用公网Git装原片），另附SHA256。

## 4. Reviewer验收语义

- `PASS_CANDIDATE_FIXTURE_PROXY_COMPAT`：可证明CWS**自身**在当前TUN+Fake-IP状态下经**受限、可信、真实代理**安全获取Blender指定MP4，并通过实际解码/SHA及所有地址/跳转/权限负例，不靠关闭守卫、变更VPN或临时harness；且明确标记**FIXTURE_ONLY**。
- `PARTIAL_EXISTING_YTDLP_ONLY`：Standalone yt-dlp成功，但CWS仍阻止调用/缺受限安全中间层，不能谎称项目已修复。
- `PARTIAL_SAFE_ADDRESS_GUARD`：仍受Fake-IP/代理边界阻断但防护未减弱，安全退出。
- `RETURN_PROXY_PROTOCOL_MISMATCH / RETURN_FIXTURE_UNAVAILABLE / RETURN_SAFETY_REGRESSION / RETURN_HOST_DRIFT`等按根因精确分类。
- **即使`PASS_CANDIDATE_FIXTURE_PROXY_COMPAT`，也只解锁“该官方测试源技术下载路径”；** 未验证泛用来源SSRF安全、搜索命中质量、原创作品复用身份和正式视频`RIGHTS_PARTIAL/G1_NOT_PASS/G2_NOT_AUTHORIZED/R4_NOT_AUTHORIZED/NO_PUBLISH`状态仍不变。通用下载路径升级需以后独立风险Gate，不能在这轮自动转GO。

## 5. REVIEWER_TO_EXECUTOR_RELAY（发给本机Codex）

请以GitHub最新main中`curious-world-studio/AGENTS.md`顶部指定的**唯一当前Gate**为准，本轮只做TUN/Fake-IP与CWS MEDIA下载安全校验的代理兼容性最小修复。**首先完整读取此Gate**，再定向读取：`media-pipeline/media_pipeline.py`的`_validate_public_url/_validated_proxy/probe_one/download_one/fetch_limited`、`media-pipeline/cws_media.py`的CLI参数与错误映射、`media-pipeline/tests/test_integration.py`的相关用例；已接受的10月11日代理下载PASS文档`docs/P4_YTDLP_EXPLICIT_PROXY_DIRECT_DOWNLOAD_PASS_REVIEW_2026-10-11.md`与10月19日PR#157独立结论`docs/reviews/CW0005_PR157_INDEPENDENT_MEDIA_E2E_REVIEW_PARTIAL_20261019.md`。禁止大范围重读全仓、重做SearXNG/4get或追搜新素材。Owner现已授权此轮`P0→P1→必要时最小修复→P2安全回归→P3一条受控测试视频下载与解码→P4 PR/ZIP`，无需逐项等待确认。实际TUN/Fake-IP与全局Clash、系统DNS、端口、节点设置保持原样，绝不可削弱`NON_PUBLIC_MEDIA_ADDRESS`或变为泛用代理白名单；安全条件不满足需精确PARTIAL/RETURN，保留证据，不继续重试。**本轮不是正式版权/素材筛选Gate**，不要把274个未知权限链接的许可核对或另找一条作品当作本任务的完成门槛。

**EXECUTOR_TO_REVIEWER_RELAY**：回报七项：结果、最小变更、真实对照与单测/下载解码证据、残留阻塞、可回滚性、需Reviewer重点核查的安全边界、PR/HEAD SHA/验收ZIP路径+SHA。无任何PR合并、下载源直接入节目、冻结模板更新或新正式视频渲染。
