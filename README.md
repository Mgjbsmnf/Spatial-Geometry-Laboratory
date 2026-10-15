# 空间几何实验室 V1.3（直接打开版）

## Windows 最简单的启动方式

1. **先完整解压 ZIP**，不要在压缩包预览窗口中直接运行文件。
2. 双击 `启动网页-Windows.bat`，或直接双击 `index.html`。
3. 不需要安装 Python，也不需要启动 PowerShell 本地服务器。
4. 当前版本的 Three.js 从 CDN 加载，因此首次/每次在全新电脑打开时需要能够联网访问 CDN。

如果双击启动脚本没有打开浏览器，请直接双击 `index.html`；如果仍不行，运行 `如果直接打开失败-诊断.bat`，窗口会保留并显示检查结果。

---

# 空间几何实验室（动点与截面虚线棱版 v1.3 · 便携启动版）

这是一个无需接入 AI API 的浏览器端原型：把多模态 AI 输出的几何 JSON 粘贴进网页，就能生成可旋转的三维多面体，并使用标准视图、动点与平面截面功能。

## Windows：推荐的一键启动方式（不需要 Python）

1. 解压整个 ZIP，**不要只单独取出 index.html**。
2. 双击 `启动网页-Windows.bat`（或 `Start-Windows-No-Python.bat`）。
3. 系统会使用 Windows 自带 PowerShell 启动本地网页服务，并自动打开 `http://127.0.0.1:8000/`。
4. 启动后的黑色窗口需要保持打开；关闭窗口即停止网页服务。

这个启动方式不安装 Python，也不要求使用 WSL。

> 当前网页中的 Three.js 仍从 jsDelivr CDN 加载，因此首次打开以及浏览器未缓存库文件时需要联网。几何 JSON 本身只在浏览器本地处理。

## Windows：Python 备用启动方式

项目同时包含 Python 自动安装/启动脚本：

- `Install-Python-Windows.bat`：检测不到 Python 时，优先执行：  
  `winget install -e --id Python.Python.3.12 --scope user --silent --accept-package-agreements --accept-source-agreements`
- 如果电脑没有 winget 或 winget 安装失败，脚本会尝试从 Python 官方网站下载 Python 3.12.10 64 位安装程序，并以当前用户方式静默安装。
- `Start-Windows-AutoPython.bat`：先检测 Python；没有时调用上述安装脚本，然后用 `python -m http.server` 启动网页。如果安装仍失败，会自动转到免 Python 的 PowerShell 启动模式。

自动安装 Python 需要联网，且部分受单位/学校管理的电脑可能禁止软件安装；遇到这种情况直接使用免 Python启动方式即可。

## macOS

在终端进入本文件夹后运行：

```bash
python3 -m http.server 8000
```

然后打开 `http://localhost:8000`。

## 主要功能

- **截面虚线棱**：启用切割后，保留侧真实棱显示为实线，切除侧真实棱显示为虚线，截面边界继续突出显示。
- **动点探索**：默认模型含动点 M 在线段 AB 上运动，可在三维图中拖动或使用右侧滑块调节参数 t，辅助线会同步更新。
- JSON 粘贴、编辑、格式整理、校验、导入和导出。
- 三维模型自由旋转、缩放，正视图、俯视图、侧视图与三维斜视。
- 顶点标签、面片、棱线、辅助线显示控制。
- 水平、竖直和自定义法向量切割平面；自定义法向量有 nₓ、nᵧ、n_z 三个方向滑块和一个平面位置滑块。
- 凸多面体截面交点与截面多边形计算。
- 分享链接把模型 JSON 编码到 URL hash 中，适合当前原型的小模型分享。

## 输入 JSON 协议

主要字段包括：`vertices`、`edges`、`faces`、`auxiliarySegments`、`dynamicPoints`、`conditions`、`uncertainties`、`initialView`、`defaultSectionPlane`。

动点示例：

```json
{
  "id": "M",
  "label": "M",
  "onSegment": ["A", "B"],
  "t": 0.5,
  "description": "点 M 在线段 AB 上运动"
}
```

网页按 `M = A + t(B-A)` 实时计算动点坐标，`0 ≤ t ≤ 1`。动点不应写入实体 `faces` 或 `edges`，但可作为 `auxiliarySegments` 的端点。

切割平面满足：

`normal[0]*x + normal[1]*y + normal[2]*z = offset`

AI 提示词见项目中的 `AI提示词-支持动点.txt`。

## 当前限制

- 当前重点面向凸多面体；输入数据必须给出正确且闭合的面与真实棱。
- 切除侧虚线是截面模式的空间辅助显示，并非任意观察视角下的自动隐藏线消隐。
- 当前 Three.js WebGLRenderer 需要现代浏览器和 WebGL 2；过旧浏览器或禁用硬件加速的设备可能无法渲染。
- 当前 Three.js 仍从 CDN 加载，因此完全离线运行尚未实现。
