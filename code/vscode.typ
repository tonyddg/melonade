#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Vscode 笔记")

#import "/utility/include.typ": *

= Vscode 笔记

== Continue: AI 辅助编程插件

插件 Continue 可提供基于 AI 的代码生成与改写（Edit）、代码解释（Chat）、自动补全（Autocomplete）功能。此处以辅助注释生成角度，介绍 Continue 插件。

关于插件的完整配置示例可参见仓库的 #link(github-raw-link("code/res/continue_config.yaml"))[continue_config.yaml]

=== 插件基本配置 <sec:continue-setup>

安装好 Continue AI 后，需要配置插件使用的 AI 模型 API，此处介绍基于#link("https://www.siliconflow.cn/")[硅基流动]提供的免费 API 的配置方法。

首先获取免费的 AI 模型 API
- 注册#link("https://www.siliconflow.cn/")[硅基流动]账号，并在账户管理 #sym.arrow API 密钥界面创建一个 API。
- 寻找免费且用于辅助编程的 AI 模型，在模型 #sym.arrow 模型广场 #sym.arrow 展开筛选器，筛选 `Coder`、`只看免费` 找到所需模型。
- 基于如下图所示的步骤，获取所需的模型名，用于后续配置

#figure(
  image("res/vscode_continue_0.png", height: 10em), 
  caption: [获取免费的 AI 编程模型],
)

然后设置插件的模型配置
- 安装插件，选择使用本地模型并跳过初始设置
- 根据下图打开模型配置文件 `config.yaml`

#figure(
  image("res/vscode_continue_1.png", height: 10em), 
  caption: [Continue AI 模型配置],
)

基本的模型配置模板如下，详细配置见#link("https://docs.continue.dev/reference#models")[文档]

```yaml
name: Local Agent
version: 1.0.0
schema: v1
models:
  - name: <任取模型名称>
    provider: siliconflow # 使用硅基流动时使用此名称
    model: <填入复制的所需模型名>
    apiKey: <填入注册的 API Key>
    # 模型应用，由于免费模型较弱不推荐启用代码生成功能
    roles:
      - autocomplete
      - chat
      # - edit
    # 模型可引用的上下文来源，更多见文档
    context:
      - provider: codebase
      - provider: web
```

=== 代码解释与 Prompt 设置

通过如下图，打开交互聊天框使用代码解释功能

#figure(
  image("res/vscode_continue_2.png", height: 10em), 
  caption: [代码解释功能基本使用],
)

其中
- 通过侧边栏进入 Continue 插件界面即聊天框，可直接输入内容要求解释、检查代码
- 选中代码，按下快捷键 #bl(0)[Ctrl]+#bl(0)[L] 可引用代码
- 确定第二个红框为 `Chat`，第三个红框 `@` 用于将文件、文件夹引入上下文，点击第四个红框发出聊天请求
- 上方红框用于新建对话与查看历史对话

Continue 中使用 `Rule` 功能实现类似全局 Prompt 的效果，可通过该功能
- 告诉 AI 模型项目的类型信息
- 向 AI 说明项目结构以更智能地引用其他文件，参加#link("https://docs.continue.dev/guides/codebase-documentation-awareness#create-rules-to-help-the-agent-understand-your-codebase")[官方文档说明]
- 强制 AI 模型输出中文

通过如下图步骤打开 `Rule` 功能设置区，并新建 `Rule`

#figure(
  image("res/vscode_continue_3.png", height: 10em), 
  caption: [`Rule` 功能设置],
)

其中
- 一般直接使用全局 `Rule` 即可，根据需要开启或关闭
- 在模型配置文件 `config.yaml` 中，使用一级键 `rules` 下的 `uses: ...` 键值对列表可以引用 #link("https://hub.continue.dev/")[Continue Hub] 上的 `Rule` 
- 单个 `Rule` 为一个带 yaml 配置的 Markdown 文件，示例如下

```md
---
description: 强制中文规则
---

始终用中文回答
```

Continue 中使用 `Prompt` 功能通过触发式的 Prompt 让 AI 实现生成注释、生成测试代码等快捷功能
- 打开模型配置文件 `config.yaml`，通过一级键 `prompts` 下的列表元素定义 `Prompt`，打开方式#link(<sec:continue-setup>)[参见]
- 使用单个键 `uses` 表示引用 #link("https://hub.continue.dev/")[Continue Hub] 上的 `Prompt`，值为对应页面中网址 `https://hub.continue.dev/` 后的部分
- 使用以下结构表示本地自定义的 `Prompt`
  - `name`：`Prompt` 名称，`description`：`Prompt` 描述
  - `prompt`：具体 `Prompt` 内容，可使用 yaml 的 `|` 语法表示多行文本，可使用 `@` 语法引用上下文 
- 在对话中通过 `/` + `Prompt` 名称调用 `Prompt`

例如以下设置示例

````yaml
prompts:
  - name: python-docs
    description: 生成 Python 函数注释
    prompt: |
      你是一名 Python 编程专家，请为给定的代码生成详细的 Google 风格 Docstring 注释。
      要求：
      1. 格式严格遵循 Google Python Style Guide，包括：
        - 简短的功能概述（第一行）
        - Args: 参数说明（类型 + 含义）
        - Returns: 返回值说明（如有）
        - Raises: 可能抛出的异常（如有）
        - Todo: 代码可能需要改进的地方 (如有)
      2. 仅输出 ''' 中包裹的注释部分，不需要复制原有代码
      3. 保证注释如实反应给定的代码，如果需要修改在 Todo 部分写出

      例如给定代码：

      ```python
      def get_ema(y: np.ndarray, alpha: float = 0.9):
          if alpha < 0:
              raise ValueError("alpha 必须大于等于 0")

          y_ema = np.zeros(y.shape[0])
          y_ema[0] = y[0]
          
          for i in range(1, y.shape[0]):
              y_ema[i] = (1 - alpha) * y[i] + alpha * y_ema[i - 1]
          return y_ema
      ```

      有示例输出（不需要复制原有代码）：

      ```
      计算指数移动平均值（EMA）。

      Args:
        y (np.ndarray): 输入的数组。
        alpha (float, optional): 平滑系数，默认为 0.9。必须大于等于 0。

      Returns:
        y_ema (np.ndarray): 计算得到的 EMA 数组。

      Raises:
        ValueError: 如果 alpha 小于 0。

      Todo:
        1. 缺少对 alpha 大于 1 情况的异常检查
      ```

      以下是给定的代码：
  - uses: roddsrod/document-python-function
````

=== 代码补全

在使用代码补全功能前，可先通过下图设置代码补全功能

#figure(
  image("res/vscode_continue_4.png", height: 10em), 
  caption: [代码补全功能设置],
)

其中
- 通过 Continue 选项卡下方的按钮打开设置，自动补全功能设置区位于下方
- 在此区域可设置禁用自动补全的文件，对于作为文档的 `.md` 文件建议禁用

除此之外，在模型配置文件 `config.yaml` 中，模型配置结构体下的键 `promptTemplates.autocomplete` 可设置自动补全的 Prompt，其中使用到了上下文与特殊 token，具体见#link("https://docs.continue.dev/customize/model-roles/autocomplete#prompt-templating")[文档]，自动补全的 Prompt 作用有限，一般中文场景使用以下示例就足够了

```yaml
models:
  - name: Qwen2.5 Coder 7b Instruct
    ... # 其他模型配置
    promptTemplates:
      autocomplete: |
        你是 {{{language}}} 编程专家，以下是代码补全上下文：
        `
        <|fim_prefix|>{{{prefix}}}<|fim_suffix|>{{{suffix}}}<|fim_middle|>
        `
```

在自动补全功能中有以下快捷键
- #bl(0)[Ctrl] #bl(0)[Alt]+#bl(0)[Space] 强制询问自动补全建议
- #bl(0)[Esc] 拒绝生成的自动补全建议
- #bl(0)[Tab] 接收自动补全建议并插入到代码中
