# Paymenter Local Lab
Stage: LOCAL_PREVIEW_PREPARED / NOT_YET_DEPLOYED

这是 Owner Windows 11 上的**私有 Docker 试用项目**，用于快速观察真实 Paymenter 用户前台、管理员后台、中文和计费功能，而不是把官网当作客户端。官方源码： https://github.com/Paymenter/Paymenter ，官方安装： https://paymenter.org/docs/installation/docker 。

## 最短执行
在 **Owner 的 Windows 本机 Codex** 中直接发送下面的指令，无需手动逐条执行：
> 阅读 [当前 G1 Gate](docs/G1_LOCAL_DOCKER_PREVIEW_GATE.md)，在真实 Windows 本机执行本项目 [START_PAYMENTER_LOCAL.ps1](START_PAYMENTER_LOCAL.ps1)，直接推进到本地浏览器可登录用户前台和管理员后台。若脚本存在只影响试用的错误，在本 Gate 内最小修复、重新验证；不动其他项目。按规范提交非敏感 Evidence 和简短回报，STOP_AT_REVIEWER。管理员登录口令只在本机屏幕显示，不写入 GitHub。

也可在 PowerShell 7 本机运行已审核脚本；确保 Docker Desktop 已启动。脚本会自行下载**指定提交**的官方 Compose，建立独立目录、随机数据库/管理员密码、中文偏好、启动容器并在通过网页检查后打开浏览器。

- 首选试用网址： http://127.0.0.1:8187
- 管理面板： http://127.0.0.1:8187/admin
- 管理员邮箱： demo-admin@paymenter.local
- 密码：第一次运行**实时随机生成并显示**，绝不把演示密码当已成功创建的凭证提前宣传
- 工作目录： %USERPROFILE%\Documents\ChatGPT\Paymenter-Local-Lab
- Compose 项目： paymenter_local_lab；独立于其他已有项目
- 语言： zh 中文优先；翻译完整度以实际截图为准
- 本轮不接 Stripe Live，不购买第三方 Referrals，不开放公网，不重建或清理其他容器

## 路线
Review source → Owner host read-only preflight → Local Docker up → Local demo account → Browser front/back visible → Reviewer accepts evidence → 再决定该模板是否适用及是否要测第三方裂变扩展。
