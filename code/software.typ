#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "实用软件笔记")

#import "/utility/include.typ": *

= 实用软件笔记

== Xpra 仅窗口的远程连接 

Xpra 可通过 SSH 进行远程连接，连接时本质上为共享 `DISPLAY` 环境变量中图形输出到的 xServer 而不是整个屏幕，因此可实现更高效的屏幕共享

=== Xpra 安装

Xpra 的安装方法如下
- 对于 Window 可在#link("https://github.com/Xpra-org/xpra/?tab=readme-ov-file#installation")[官方仓库] 下载最新版本
- 对于 Ubuntu 可使用命令 `curl https://xpra.org/get-xpra.sh | bash` 自动安装

安装好 Xpra 后注意使用 `xpra --version` 检查版本，如果服务端与客户端版本相差过大可能导致连接失败
- 例如 Ubuntu 20.04 最高仅支持 3.0.x 版本（客户端需要下载相同版本的 Xpra），而笔记使用的版本为 6.4

=== Xpra 服务端共享

服务端通过命令 `xpra start <display>` 启动共享屏幕服务
- `display` 共享屏幕的编号（`DISPLAY` 环境变量），不能与已有的屏幕编号重复，通常为 `:数字` 的形式
- `--start=<start>` 共享屏幕中启动的程序，一般为终端窗口 `xterm`，再通过终端窗口启动其他程序
    - 对于桌面环境的 Ubuntu 可以用更现代的终端窗口 `gnome-terminal`
    - 对于无桌面环境的 Linux 可以使用 `xfce4-terminal`（需要先安装）
- `--env=<env>` 执行程序时定义的环境变量，可以有多个
- `--daemon=<yes/no>` 是否在后台运行服务，默认为 `yes`，可以设置为 `no` 以在终端查看程序输出
- `--exit-with-windows=<yes/no>` 是否当全部窗口退出后关闭服务（如被客户端主动关闭），默认为 `no`，临时窗口可设置为 `yes`
- `--encoding=<encodings>` 传输画面的编码方式，建议使用 `openh264,webp`

有以下常用命令

```sh
xpra start :100\
    --daemon=no\
    --exit-with-windows=yes\
    --encoding=openh264,webp\
    --start=xterm
```

服务端还有以下实用命令
- `xpra list` 查看现在正在共享的窗口
- `xpra attach <display>` 连接到本地的共享窗口，可以用于排除本地问题
- `xpra stop <display>` 关闭共享屏幕

=== Xpra 客户端连接

在使用 Xpra 连接前，确保能使用 `ssh` 连接到服务端

由于客户端一般有图形界面，因此可以直接使用命令 `xpra` 打开客户端 GUI，打开 GUI 后
- 选择 `Connect` 进入客户端连接界面
- `Mode` 字段选择 `SSH`
- `Server` 字段分别填入 `<用户名>@<ip 地址><SSH 端口>:<连接到的窗口编号>`
- `Server Password` 字段填入用户密码
- 可使用下方的 `Save` 与 `Load` 将以上信息保存为文件并加载
