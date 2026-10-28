# Meadow 交互式页面还原

本项目根据用户提供的录屏还原 Meadow 单页前端：原视频场景分层、草坡遮挡的大字、日夜柔边过渡及鼠标花朵/光点效果。页面为原生 HTML、CSS 和 JavaScript，可在桌面和窄屏运行。

项目当前状态与后续边界：[REVIEWER_HANDOFF.md](./REVIEWER_HANDOFF.md)。执行与核验事实：[EXECUTION_EVIDENCE.md](./EXECUTION_EVIDENCE.md)。素材来源与恢复：[docs/ASSET_PROVENANCE.md](./docs/ASSET_PROVENANCE.md)。

## 运行

需要 Node.js；运行阶段不需要安装依赖：

```sh
npm start
```

打开 `http://127.0.0.1:4173`。也可直接打开 `dist/index.html`；部署静态站点时上传 `dist/`。`npm run check` 检查 JavaScript 语法。

点击页面、右下角按钮或按空格键切换日夜；移动鼠标可在草地上触发短暂花朵与光点。导航链接打开演示说明，录屏没有提供真实目标页面。

## 目录

```text
dist/                       可运行页面、独立字样和场景 SVG
scripts/build-scenes.py     从参考帧重新构建 SVG（需要 Pillow、NumPy、OpenCV）
scripts/restore-reference-video.py  按顺序还原并校验原始录屏
reference/                  构建使用的五张原帧及原视频分片
qa/fullbleed-desktop.png    已验证的桌面全屏效果
docs/                       来源和内容完整性清单
```

恢复录屏：`python scripts/restore-reference-video.py`。脚本会先校验分片、合并结果及 SHA-256，已有目标文件时不会覆盖。

归档中的背景纹理和字样来源于录屏，不代表取得原站源代码、三维模型或素材商用授权。花草运动、夜间光点与场景切换是前端近似实现；原素材权利和后续公开商用许可仍待核实。
