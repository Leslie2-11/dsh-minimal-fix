# dsh-minimal-fix

Windows 平台下 DeepSeek Harness (dsh)「极简模式」(minimal agent preset) 的修复。

## 问题

`@deepseek-ai/dsh` 随包发布的 `minimal` 预设只挂载 bash 工具链：`dsh-terminal-bash`
的默认 `shellPath` 是 `/bin/bash`，预设里没有 Windows 平台分支。Windows 上通常没有
bash，因此极简模式下 Agent 每次调用 `bash` 工具都会失败（表现为
`persistent bash shell did not accept initialization` 等错误）。

标准模式 (`standard`) 预设对 bash/pwsh 做了平台开关
（`disabled: !!js process.platform === 'win32'`），极简模式没有——这就是根因。

## 修复方案（方案 A：平台感知的 minimal 预设）

对 `minimal/agent.cordis.yml` 增加平台分支：

- win32：禁用 persistent-shell 组的三个 bash 行（pty / terminal-bash / persistent-bash），
  改挂宿主层的 `dsh-tool-pwsh`（每次调用是全新 pwsh 进程；
  `enableRunInBackground: false`，因为极简预设没有 `job_*` 工具）；
- 其他平台：行为与原版完全一致。

修复后的完整组合见 `agent-presets/minimal-win/agent.cordis.yml`。

## 安装

### 方式 1：作为新预设（免管理员、免重启）

把 `agent-presets/minimal-win/` 复制到 `$DSH_HOME/.agent-presets/minimal-win`：

```powershell
.\sync-user-preset.ps1
```

然后在 Web 界面预设选择器中选择「极简模式 (Windows)」。发现是即时的，无需重启。

### 方式 2：原地修复安装目录自带的「极简模式」（需管理员 + 重启 dsh web）

以管理员运行（先备份 `.orig` 再覆盖）：

```powershell
.\fix-minimal-inplace.ps1
```

或双击 `fix-minimal-inplace.bat`（触发 UAC）。重启 dsh web 后生效——正在运行的进程
持有旧的 preset 组合，只有重启才会重新加载组合文件。

> 脚本内的路径（`F:\deepseek Harness`、`F:\nodejs\node_global\...`）需要按你的
> 实际环境调整。

## 文件

- `agent-presets/minimal-win/agent.cordis.yml` —— 修复后的极简预设组合（平台感知）
- `agent-presets/minimal-win/preset.yml` —— 预设显示名与描述
- `fix-minimal-inplace.ps1` —— 管理员权限原地修复安装目录的 minimal 预设
- `fix-minimal-inplace.bat` —— 上述脚本的 UAC 双击入口
- `sync-user-preset.ps1` —— 把 minimal-win 同步到 `$DSH_HOME\.agent-presets`

## 许可

修复文件源自 `@deepseek-ai/dsh`（MIT License），本仓库同样以 MIT 发布，见 LICENSE。