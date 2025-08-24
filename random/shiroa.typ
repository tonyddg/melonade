#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Shiroa 笔记")
// #show: codly-init.with()

// #let color_arr = (rgb("#1f77b4"), rgb("#ff7f0e"), rgb("#2ca02c"), rgb("#d62728"), rgb("#9467bd"), rgb("#8c564b"), rgb("#e377c2"), rgb("#7f7f7f"), rgb("#bcbd22"), rgb("#17becf"))


// #show raw.where(block: false, lang: none): it => {
//   show regex("<[\w\-]+>"): text.with(fill: color_arr.at(0))
//   show regex("\[[\w\-]+\]"): text.with(fill: color_arr.at(2))
//   show regex("--[\w\-]+"): text.with(fill: color_arr.at(1))
//   it
// }

// #show raw.where(block: false): box.with(
//   fill: luma(240),
//   inset: (x: 3pt, y: 0pt),
//   outset: (y: 3pt),
//   radius: 2pt,
// )

= Shiroa 笔记

Shiroa 是一个基于纯 typst 创建在线文档的工具。在创建文档时可以自由地引入社区模块或自定义样式，不同于基于 markdown 的工具为了实现复杂自定义功能而引入与其本身割裂各种的 “方言” 以及复杂的配置流程。

参考资料
- #link("https://github.com/Myriad-Dreamin/shiroa/")[shiroa Github 仓库]
- #link("https://myriad-dreamin.github.io/shiroa/introduction.html")[shiroa 官方文档]

== Shiroa 基本使用 - 从创建到部署

此处快速介绍如何创建一个 Shiroa 项目并部署到 Github Page 上，对于详细设置见下一节介绍。

=== 创建基本项目

Shiroa 为一个独立的，具有 CLI 的程序，不依赖于 Node.js 等，因此安装非常简单
+ 下载 #link("https://github.com/Myriad-Dreamin/shiroa/releases/")[Shiroa 最新 Release]
+ 将 Shiroa 添加到 PATH 中便于后续执行
+ 命令 `shiroa init <项目名>` 在当前目录下创建一个基本的 Shiroa 项目

=== Git 项目与字体资源

在部署到 Github Page 前需要先将当前的 Shiroa 项目创建为 Git 仓库管理，通常即运行 `git init` 并同步到远程的 Github 仓库。

由于项目的编译在 Github Action 中完成，因此要特别注意字体资源。通常将字体资源放置在某个目录下（如 `assert/font`），可使用以下三种方式管理
- 直接将使用到的所有字体放置在 `assert/font` 中作为项目一部分（简单，但可能导致项目文件冗余）
- 在部署页面时下载字体到 `assert/font` 中（此处不介绍，可参考#link("https://github.com/Myriad-Dreamin/shiroa/blob/main/.github/workflows/gh_pages.yml")[官方文档构建流程]）
- 使用 #link("https://www.runoob.com/git/git-submodule.html")[git submodule] 管理字体资源（分离管理字体，可以在不同项目间共享）
  - `git submodule add https://github.com/typst-doc-cn/fonts/tree/tutorial-v0.2.0 -b tutorial-v0.2.0 assert/font`\ 
    可使用基于默认模板的字体仓库，直接适配默认模板
  - `git submodule add https://github.com/tonyddg/font_collection assert/font`\ 
    本文档使用字体仓库，使用时需要修改生成模板 `templates/page.typ` 文件
      - 将变量 `main-font` 的列表值前添加字符串 `Source Han Sans SC`
      - 将变量 `code-font` 的列表值前添加字符串 `Fira Code` 与 `Source Han Sans SC`
      - 如果需要基于子模块设置自定义字体类似此方法
      - 克隆项目是如果要下载字体可使用 `git clone --recurse-submodules <url>`

=== 部署到 Github Page

首先打开 Github Page 设置，在 Github 仓库中进入 Settings #sym.arrow Pages #sym.arrow #sym.arrow Source 设置为 GitHub Actions。

然后在仓库目录下创建 `.github/workflows/gh_pages.yml`，可以参考本文的 #link("https://github.com/tonyddg/my-first-book/blob/master/.github/workflows/gh_pages.yml")[Github Action 配置]，使用时注意
- 检查 `on.push.branches` 字段的值是否为主分支，如果设置错误将不能在 pull 时自动触发部署
- 检查 Build Book 任务中执行的页面编译命令 `shiroa build [book]`
  - `--font-path` 该选项参数指定字体资源路径，将自动搜索路径下所有字体文件
  - `--path-to-root` 网页根目录，部署到 Github pages 时，该选项参数必须为 `/<git项目名>/`
  - `-w` 文档的逻辑根目录，默认为根目录，通常在文档作为项目的一个子文件夹时使用
  - `book` 文档的所在目录，指向 Shiroa 基础配置文件 book.typ 所在目录，默认为根目录，通常在文档作为项目的一个子文件夹时使用
  - 可以在 pull 前执行该指令检查项目是否能通过编译，检查字体问题时，可以删除系统安装的字体以防止干扰
- 如果部署时在 Deploy to GitHub Pages 任务出错，可以检查文件中使用到的官方 Action `actions/xxx@vx` 如 `actions/deploy-pages@v3` 是否全部更新到最新版本
- 如果在线下载字体资源，需要取消注释 Download font assets 部分的任务，并设置下载路径

== Shiroa 配置

Shiroa 的配置完全基于 typ 文件，且以 `book.typ` 文件作为入口生成文档。建议在 `shiroa init` 初始化项目的基础上修改，通过多文件的方式配置文档。

=== 元信息与章节安排

通过向 `book.typ` 的 `book-meta` 函数传入参数以设置元信息与章节安排。

参考文献: #link("https://myriad-dreamin.github.io/shiroa/format/book.html")

章节安排通过向 `summary` 参数传入内容值实现，函数将解析内容中的隔行与无序列表确定章节安排。
- 通过无序列表中的 `chapter(link, section)[title]` 函数设置文档章节
  - Shiroa 中文档的每个章节不论层级都使用一个独立的 typ 文件表示，并具有一个独立的页面，且章节安排与文件结构完全独立
  - 参数 `link: str | none` 表示页面指向的 typ 文件，如果传入 `none` 将作为无法进入的草稿章节
  - 参数 `title: content` 表示该章节在目录中的名称
  - 参数 `section: auto | str` 表示章节编号，可根据函数所在的列表位置及层级自动确定，因此不建议手动指定该参数
- 通过标题元素设置部分标题
  - 部分标题不会只想具体章节，进用于指示后续的章节进入新部分，但不会阻断章节计数
  - 使用任意级别的标题效果均相同
  - 部分标题用于引领一个部分的章节安排，不建议在无序列表结构中插入部分标题，这将导致自动编号出错
- 前言章节通过函数 `prefix-chapter(link)[title]` 表示
  - 前言章节是一种没有编号的特殊章节，其参数与 `chapter` 相同，但是必须作为第一个章节
  - 类似的尾声章节通过函数 `suffix-chapter(link)[title]` 表示

文档的元信息则通过 `book-meta` 函数的其他参数定义，常用的有
- `title: str` 文档标题
- `repository: str` 文档仓库链接，将在网页中添加仓库信息
- `repository-edit: str` 文档源文件链接，使用 `{path}` 作为文档路径的占位符，对于 github 通常即 `<仓库路径>/blob/<分支名>/{path}`
- `description: str` 文档描述，将被添加到网页元信息中
- `language: str` 文档语言，将被添加到网页元信息中

基于以上规则有如下章节安排示例

```typst
// TODO
```

=== 文档章节

由于文档中每个章节均为一个独立的 Typst 文件，因此文档章节样式实际上为通过 show 规则引用 `templates/page.typ` 中定义的模板 `project` 生效的。在 Shiroa 初始项目中则是通过引用 `templates/page.typ` 中定义的模板 `project` 并重新以 `book-page` 导出实现的。

因此通过以下代码即可作为一个最简单的章节：

```typst
#import "/book.typ": book-page
#show: book-page.with(title: "Test")
```

=== 自定义样式与文档章节

初始项目中，生成的以下文件与定义文档的基本样式有关，虽然这些文件不是必要的
- `templates/page.typ` 定义文档的基本样式
- `templates/theme-style.toml`，`templates/tokyo-night.tmTheme` 定义颜色主题与定义代码块渲染样式，用于 `templates/page.typ`


=== 非网页文档

初始项目中，剩余的以下两个文件用于纯 typst 生成如 PDF 等非网页文档
- `ebook.typ` 文档生成的根文件，使用 typst 编译即可生成非网页文档
- `templates/ebook.typ` 文档样式控制
  - 在 `show: _page-project` 后可添加自定义内容
  - 函数 `context{...}` 即将原始文档内容生成部分

非网页文档注意
- 建议在 `templates/page.typ` 中定义非网页文档样式，生成非网页文档与基于 typst 预览时标志变量 `is-pdf-target` 将为 `True`
- 如果不需要生成非网页文档可以删除此部分内容

== Typst 集成

由于 Shiroa 生成文档的特点，其通过 Typst 包的形式提供了一系列实用函数以提供额外的特性。

由于 `book.typ` 中已经导入了 Shiroa 用于支持Typst 集成的包 `shiroa`，因此可以在导入 `book.typ` 时导入所需函数，而无需重新导入 `shiroa`。

注意，目前为止这些集成函数在电子书导出（基于纯 typst 预览）时可能无法发挥正常功能。（Shiroa 0.3.1-rc2）

=== 文档引用

函数 `cross-link(path: any, reference: label)[content]` 提供了更简单的方式用于生成指向当前乃至不同文档超链接
- `path: any` 通常为文档路径字符串，注意需要使用以 `/` 开头的绝对路径，根目录为 Shiroa 的逻辑根目录，可以为当前文档（同样需要指定路径）
- `reference: label | auto` 被引用文档内的引用标签
  - 可以是普通的由 `<>` 定义的标签
  - 可以使用 `templates.heading-reference[content]` 简便引用标题（以 `== xxx` 的内容传入）而不需要主动设置标签
  - 默认将直接导航到被引用的文档

关于文档引用有如下示例代码：

```typst
== 引用测试

#cross-link("/random/test1.typ")[链接到其他文档]

// 对于频繁自引用场景可以定义变量
#let p-self = "/random/shiroa.typ"

#cross-link(
  p-self, 
  // 标题名与层级需要相同
  reference: templates.heading-reference[== 引用测试]
)[链接到本文档]
```

=== html 嵌入

https://myriad-dreamin.github.io/shiroa/supports/embed-html.html

== 其他记录

=== serve 子命令

https://myriad-dreamin.github.io/shiroa/cli/serve.html

=== 常见问题

网页渲染标题没有加粗
- 默认情况下，普通渲染标题加粗但网页渲染标题不加粗
- 注释 `templates/page.typ` 中以下代码，取消该设置\ 
  #raw("#show heading: set text(weight: \"regular\") if is-web-target", lang: "typst")
