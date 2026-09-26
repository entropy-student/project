# QA Report — ep-agent-permission-boundary-20260926

- Run: `20260926-1522-images-r1`
- Batch status: `HOLD_OWNER_REVIEW`
- Frame-level result: **15 ACCEPTED, 0 final rejects, 56 NOT_GENERATED**.
- Retry history: **7 superseded rejected candidates**, each followed by an accepted retry.
- The batch is not complete; generation stopped after VB015 on owner request.
- Accepted output PNGs were full-frame normalized to 1920×1080; no crop or overlay was applied.
- IMAGE_NATIVE text: VB014 exact match `中午一起吃饭？`; VB015 exact match `已下单`.

## Per-beat status

| Visual Beat | Status | QA / review note |
|---|---|---|
| VB001 | ACCEPTED | V2 主角表演和外卖袋、手机层级符合要求；手机显示抽象 UI，不出现额外可读字。 |
| VB002 | ACCEPTED | 主角被四张待办卡围住，白暖背景与指定留白清楚；卡片无字。 |
| VB003 | ACCEPTED | 手机与四张抽象任务卡均清楚可见；主角身份及指定构图通过。 |
| VB004 | ACCEPTED | 主角在卡片中显得 overwhelmed，表演、景别、简洁背景通过。 |
| VB005 | ACCEPTED | 抽象确认 UI，无人脸/机器人；任务卡推向手机，构图与表演通过。 |
| VB006 | ACCEPTED | 手机呈现简洁抽象接受/绿色勾选状态；无额外可读文字。 |
| VB007 | ACCEPTED | 白色简洁背景；包裹、日历、购物袋次序和主角兴奋表演清楚。 |
| VB008 | ACCEPTED | 包裹/时间卡与主角准备出门的状态易读；门框仅为轻微环境线索。 |
| VB009 | ACCEPTED | 日历会议块与要求道具可辨；无可读文字，焦点未被背景分散。 |
| VB010 | ACCEPTED | 包内仅有一瓶泵头瓶可辨，必要包裹/日历道具保留；构图简洁。 |
| VB011 | ACCEPTED | 抽象几何设备 UI，无人形或脸；卡片和主角表演符合本 Beat。 |
| VB012 | ACCEPTED | 设备抽象接收卡片，无脸；角色及卡片关系、留白通过。 |
| VB013 | ACCEPTED | 通知具体内容保持 withheld；仅有通用朋友头像轮廓，没有可读通知文字。 |
| VB014 | ACCEPTED | IMAGE_NATIVE：屏幕原生生成文字逐字核对为“中午一起吃饭？”；无拒绝状态或额外可读字。 |
| VB015 | ACCEPTED | IMAGE_NATIVE：屏幕原生生成文字逐字核对为“已下单”；订单卡覆盖邀请状态且无拒绝提示。 |
| VB016 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB017 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB018 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB019 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB020 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB021 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB022 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB023 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB024 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB025 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB026 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB027 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB028 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB029 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB030 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB031 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB032 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB033 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB034 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB035 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB036 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB037 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB038 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB039 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB040 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB041 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB042 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB043 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB044 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB045 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB046 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB047 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB048 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB049 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB050 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB051 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB052 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB053 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB054 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB055 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB056 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB057 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB058 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB059 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB060 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB061 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB062 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB063 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB064 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB065 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB066 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB067 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB068 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB069 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB070 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |
| VB071 | NOT_GENERATED | Generation paused at owner request after VB015; awaiting overall review. |

## Superseded rejected candidates

| Beat | Candidate | Rejection reason |
|---|---|---|
| VB001 | `exec-ebe01c4f-30f3-46ff-bed6-80638320d68d` | Phone/status not visible enough. |
| VB003 | `exec-3dfb358f-d496-4bb2-a89f-a5de51294136` | Phone was missing. |
| VB005 | `exec-407e125b-72f9-40d6-8e6d-c942d8232e58` | Phone UI depicted a face/robot. |
| VB007 | `exec-453e9afd-11d4-4535-a6fa-3a0964d1dc28` | Room/background was too detailed and cluttered. |
| VB010 | `exec-6fedec68-ccfd-4e44-96f1-023d5be94edd` | Shopping contents/background were overfull. |
| VB011 | `exec-45ab2efe-d552-4d63-bac6-fa663942b9cf` | AI was depicted as a humanoid robot. |
| VB012 | `exec-ea695862-ff6e-4b0d-8e4d-1f3c0b5068d1` | Phone UI depicted a face. |
