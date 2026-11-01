#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "AI Agent")

#import "/utility/include.typ": *

= AI Agent 笔记

参考教程：https://www.bilibili.com/video/BV14rzQB9EJj

实用教程：https://www.runoob.com/claude-code/claude-code-tutorial.html

== Claude Code 安装

=== 安装本体

参考#link("https://code.claude.com/docs/en/overview#terminal")[官方文档]，执行对应的命令安装 Claude Code 本体

安装本体注意:
+ 建议在终端中开启对应环境变量或开启全局代理
+ 如果安装失败，可以下载对应安装脚本，查看内容正确

=== 自定义 API

安装 #link("https://github.com/farion1231/cc-switch")[cc-switch] 可用于使用自定义的大模型 API 而无需使用 Claude 模型。关于 API 的配置 JSON 等可查看对应 API 文档的环境变量设置即可（直接点保存即可，不需要修改模型映射配置），如 #link("https://api-docs.deepseek.com/zh-cn/quick_start/agent_integrations/claude_code")[DeepSeek] 对应的配置 JSON 为

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "deepseek api key",
    "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-v4-flash",
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  },
  "theme": "auto",
  "autoUpdatesChannel": "latest"
}
```

对于无 cc-switch 的情况，可以主动修改 ClaudeCode 的配置文件，填入内容与以上示例相同（一般位于 `~/claude/settings.json`）

== Claude Code 基本使用

在代码工作区文件夹下通过终端命令 `claude` 启动软件后，就可以通过输入指令实现 LLM 交互辅助编程

=== 输入模式

Claude Code 共有以下三个输入模式，不同模式下 LLM 将有不同的表现，三个模式通过快捷键 #bl(0)[Shift] + #bl(0)[Tab] 切换
- 默认模式：输入框下方显示 `? for shortcuts`，为进入 Claude Code 时所在的模式
  - 模型将依据输入框输入的语言指令创建或修改工作区内的代码或回答用户的问题
  - 每次操作都会询问用户
  - 生成代码后可以继续输入指令用于修改代码
- 自动模式：输入框下方显示 `accept edits on`，与默认模式类似，但生成代码时不会询问用户，仅执行命令时询问
- 规划模式：输入框下方显示 `plan mode on`，不会生成代码而仅与用户对话输出整体代码框架，可以多次对话修改框架，并在框架完成后生成完整代码

=== 输入框与交互

Claude Code 的输入框使用方式如下
- 输入语言指令后，使用 #bl(0)[Enter] 即可提交语言指令
- 通过 #bl(0)[Shift] + #bl(0)[Enter] 可以在输入框中换行
- 通过 `@文件路径` 可以引用项目下的文件用于询问 LLM
- 使用快捷键 #bl(0)[Ctrl] + #bl(0)[g] 可以打开文本编辑器用于编辑指令内容，退出编辑器时将使用其中内容代替输入框中的内容
- 复制图片后，使用 #bl(0)[Alt] + #bl(0)[g]，可以将图片添加到语言指令中
- 按两次 #bl(0)[Ctrl] + #bl(0)[c] 可以退出 Claude Code
- 退出 Claude Code 后，使用 `/resume` 命令可以恢复之前的上下文，或使用 `claude -c` 启动 Claude Code 能自动回到之前对话

关于自然语言指令的使用指南可#link("https://www.runoob.com/claude-code/claude-code-basic.html")[参见]

=== 特殊交互模式

`/` 执行 Claude Code 内置操作的指令，常用的指令有
- `/help <指令>` 查看指令帮助
- `/model` 切换模型与思考强度
- `/status` 查看环境状态
- 其他常用指令#link("https://www.runoob.com/claude-code/claude-code-slash-commands.html")[参见]

`!` 输入框的内容将作为命令行执行，并在命令完成前阻塞对话
- 命令行指令在退出前都将阻塞 LLM 对话，可输入 #bl(0)[Ctrl] + #bl(0)[b] 将任务放在后台
- 指令 `/tasks` 可以查看后台中的任务

=== 修改回滚

对于 Claude Code 做出的修改可以回滚，操作方式有
- 按两次 #bl(0)[Esc] 可以进入回滚页面，选择回滚的到的对话，回滚时可以选择回滚代码修改与对话等
- Claude Code 只能回滚自己创建的文件，对于其使用命令行创建的文件无法精确回滚

=== 上下文管理

当上下文过大时，可通过以下命令压缩 Claude Code 的上下文保证 LLM 性能并减少 Token 消耗量
- `/context` 查看上下文的 token 占用与优化建议，占用超过 70% 后建议压缩
- `/compact [压缩要求]` 压缩上下文，还可以额外提供语言指令表示重点保留内容
- `/clear` 清除所有上下文
- `/btw <语言指令>` 给出一条不进入上下文的语言指令，用于不想污染上下文时查阅小细节

除了聊天的上下文，Claude Code 还会依据 `CLAUDE.md` 文件作为 LLM 的基础 prompt
- `/init` 依据当前上下文生成 `CLAUDE.md`
- `/memory` 用于查看全局与项目的 `CLAUDE.md`
- `CLAUDE.md` 文件的具体编写方法#link("https://www.runoob.com/claude-code/claude-code-claudemd.html")[参见]

=== Agent Skill

Agent Skill 即一种特殊的 prompt，用于告诉 LLM 如何完成特定操作，通常表示为保存在 `<项目根目录>/.claude/skills/<agent skill 名称>/SKILL.md` 下，具有以下形式的 markdown 文件，关于更详细的编写方式#link("https://www.runoob.com/claude-code/claude-agent-skills.html")[参见]

```md
---
name: [agent skill 名称]
description: [agent skill 描述]
---

... 具体 prompt 内容

```

使用 Claude Code 时将依据 `agent skill 描述` 自动调用对应的 Agent Skill，或者使用 `/<agent skill 名称> [补充要求]` 主动调用 Agent Skill

也可以在 #link("https://github.com/farion1231/cc-switch")[cc-switch] 中集中管理 Agent Skill

=== vscode 集成

在 vscode 中安装 Claude Code 插件后，可在 vscode 页面中使用 Claude Code，相比于 CLI 中的 Claude Code
- 快捷键与 Claude Code 保持一致，同样可以按两次 #bl(0)[Esc] 进入回滚、#bl(0)[Shift] + #bl(0)[Tab] 切换输入模式等
- 左下角的 #bl(0)[+] 按钮可用于上传任意文件；#bl(0)[/] 按钮可查看命令与选择模型以及思考强度
- 能够自动引用其他编辑页中选中的代码段

== Codex CLI

参考#link("https://learn.chatgpt.com/docs/codex/cli?surface=cli#getting-started")[官方文档]，执行对应的命令安装 Codex CLI 本体

=== 自定义 API

对于 Linux 参考对应的 API 提供商文档在 `~/.codex/` 下创建配置文件 `~/.codex/models.json` 与 `~/.codex/config.toml` 并写入对应的配置

对于 Windows 可以使用 #link("https://github.com/farion1231/cc-switch")[cc-switch] 管理，使用时注意
- 使用 API 提供商的 `config.toml` 覆盖 cc-switch 下方默认的 `config.toml` 配置
- 模型映射配置处，先点击右侧 `获取模型列表` 按钮根据提供商名称确定提供的模型，然后点击右侧 `添加模型` 按钮根据 API 提供商 `models.json` 的 `supported_reasoning_levels` 与 `max_context_window` 填写思考等级（可以多选）与上下文窗口等设置

=== vscode 集成 

在 vscode 中安装 Codex CLI 插件后，可在 vscode 页面中使用 Codex CLI

在使用 Docker 容器或 SSH 远程开发时，Codex CLI 插件将使用本地安装的 Codex CLI，但是读取远程 `~/.codex/` 下的配置，还需要手动创建或挂载（Docker）相关配置

`~/.codex/config.toml` 中填写 API Key 时，除了键 `experimental_bearer_token` 直接将值作为 API Key，也可以使用  
