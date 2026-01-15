#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Python 杂记")

#import "/utility/include.typ": *

= Python 杂记

== uv <sec:uv>

基于 uv 的 Python 项目管理，参考#link("https://uv.doczh.com/")[教程]，安装方法参见#link("https://uv.doczh.com/getting-started/installation/")[文档]

Conda 通过虚拟环境隔离与管理不同版本的 Python，这些不同版本的 Python 根据需求启用，与具体项目无关。

而在具体项目开发中，每个项目都有自己单独的环境依赖，且 Python 的虚拟环境与项目高度相关，环境中安装的包同时也是项目的依赖。而 uv 就是用于这类场景下的 Python 虚拟环境管理与项目部署，因此 uv 环境配置即写在 Python 项目配置文件 #link("https://packaging.python.org/en/latest/guides/writing-pyproject-toml/")[pyproject.toml] 中，且不存在一个中心化的项目管理器。

当 Python 项目中存在大量 py 文件且使用文件夹作为子模块管理这些文件时，模块间的相对引用将不可避免地引入相对引用、绝对引用等问题造成代码的混乱。最佳的解决办法即将这个项目作为一个#hl(2)[可编辑的模块]安装到当前虚拟环境中，既能解决相对引用问题，也能让项目像一般 Python 模块一样方便地安装、部署到其他环境，同时也能与 Pytest 等功能集成。

由于 #link("https://packaging.python.org/en/latest/guides/writing-pyproject-toml/")[pyproject.toml] 的编写较为复杂，此处仅从实用角度介绍如何使用 uv 管理项目。

=== 单模块项目

单模块项目中，整个项目即一个完整的 Python 模块，该模块下可能存在子模块（文件夹或 py 文件），现有单模块项目 `my_module`，该项目包含了三个子模块 `app, util, main.py`。

在项目所在目录下使用命令 `uv init --package <项目名>` 即可创建一个最基础的单模块项目

该类项目通常具有以下的文件结构

```txt
<顶层文件夹>
├─src 
│  └─my_module // 需要与 pyproject.toml 中的模块名保持一致
│     ├─app
│     │  ├─main.py // 文件夹模块下的 py 文件即其子模块
│     │  └─__init__.py // 文件夹模块需要有 __init__.py 表明这是一个模块
│     ├─util
│     │  ├─main.py
│     │  └─__init__.py // 可在 __init__.py 中 import 文件夹下的子模块
│     ├─main.py
│     └─__init__.py // 顶层模块同样要有 __init__.py
└─pyproject.toml
```

该项目的 `pyproject.toml` 有编写模板

```toml
[project]
name = "my_module" # 模块名称，需要与文件夹名称保持一致
# 必要的元信息，按需要填写
version = "0.1.0"
description = "A module"
requires-python = ">=3.10" # Python 版本要求，一般以类似方式规定第二位版本号
# 依赖模块
dependencies = [
    "numpy>=2.0.0", # 版本范围限制与 requirements.txt 相同
    "matplotlib", # 可以不预留版本范围
]
# 基于构建器 uv_build 安装子模块，一般直接复制即可
[build-system]
# uv init 生成的构建器会带有版本要求, 一般可以删除仅保留 requires = ["uv_build"]
requires = ["uv_build>=0.9.6,<0.10.0"] 
build-backend = "uv_build"
```

完成项目基本配置后，通过以下命令部署项目
- 安装项目所需的 Python 虚拟环境 `uv venv --python <version>`
    - `<version>` 安装的 Python 版本号，一般指定到第二位即可如 `3.10`
    - 该命令将在项目根目录的文件夹 `.venv` 中创建虚拟环境
- 将项目中的模块安装到虚拟环境中 `uv sync`
    - 该命令将以可编辑的方式将当前项目安装到虚拟环境中
    - 该命令用于初次安装项目 / 部署已有项目
- 向虚拟环境安装 / 卸载模块 `uv add / remove <模块名>`
    - 模块名同样可通过 `==, >=` 等限制模块版本
    - 对于 PyTorch 等从特殊位置下载的模块（此时 `pip` 命令会带有参数 `--index-url`），可使用 `uv add <模块名> --index <来源组>=<来源链接>`
        - `来源组` 名称可取任意相关名称
        - `来源链接` 即对应 `pip` 命令中选项 `--index-url` 的参数
        - 例如（关于在 uv 中使用 Pytorch 更多参见#link("https://uv.doczh.com/guides/integration/pytorch/#uv-pip")[文档]）：\ `uv add torch torchvision --index pytorch=https://download.pytorch.org/whl/cu126`
    - 对于引用自 github 的包，可使用一下命令安装（需要具有完整的模块结构）\ `uv add "git+<url>@<branch>[#subdirectory=<subfolder>]"`
        - `url` 仓库在 github 上的 url 地址（以 `.git` 为后缀）
        - `branch` 引用的分支
        - `subfolder` 可选，从指定的仓库子目录下寻找子模块，开头不需要 `/`
    - 不建议直接修改 `pyproject.toml` 的 `dependencies` 字段，而是使用以上命令将智能同步修改 `pyproject.toml` 与虚拟环境
- 运行虚拟环境中的脚本时 
    - 对于模块中的脚本需要使用 `uv run -m <顶层模块名>.<模块名>` 以类似引用模块的方式运行脚本
    - 对于一般脚本可使用 `uv run <脚本文件>`
    - 进入当前虚拟环境的 Python 可使用 `uv run python`

=== Monorepo 项目

Monorepo 项目意为使用一个项目（github 仓库）管理多个开发中的，与项目有关的 Python 模块。现有 Monorepo 项目 `my_project`，该项目包含了两个独立模块 `moduleA, moduleB`（这两个模块可以存在依赖关系）与依赖于这两个模块的总模块 `moduleMain`。

该项目通常具有以下的文件结构，可以发现 `packages` 文件夹中的独立模块本质上也是

```txt
<顶层文件夹>
├─src 
│  └─moduleMain // 需要与 pyproject.toml 中的模块名保持一致
│     ├─main.py
│     └─__init__.py
├─packages 
│  ├─moduleA
│  |  └─src
|  │     └─moduleA
|  │        ├─main.py
|  │        └─__init__.py
│  └─moduleB
│     └─src
|        └─moduleB
|           ├─main.py
|           └─__init__.py
└─pyproject.toml
```

对于其中的子项目有编写模板（子项目也可通过命令 `uv init --package <项目名>` 创建）

```toml
[project]
name = "moduleA" # 子模块名称，需要与文件夹名称保持一致
# 必要的元信息，按需要填写
version = "0.1.0"
description = "A module"
requires-python = ">=3.10" # Python 版本要求，一般以类似方式规定第二位版本号
dependencies = []
# 基于构建器 uv_build 安装子模块
["uv_build"]
requires = ["uv_build>=0.9.6,<0.10.0"] 
build-backend = "uv_build"
```

对于顶层项目的编写模板与一般项目类似，仅需要如下变动用于引入子模块

```toml
# 在依赖中加入子模块
dependencies = [
    "moduleA",
    "moduleB",
    ...
]

# 说明子模块来自工作区
[tool.uv.sources]
moduleA = { workspace = true }
moduleB = { workspace = true }

# 说明工作区路径
[tool.uv.workspace]
members = ["packages/*"]
```

以上 Monorepo 的项目结构同样可以直接使用 `uv` 命令管理
- 总模块依然使用 `uv init --package <模块名称>` 创建
- 在项目目录下创建 `packages` 文件夹并进入该文件夹使用 `uv init --package <模块名称>` 创建子模块，此时子模块将自动加入工作区而不需要修改 `pyproject.toml`（仍需要手动将子模块作为依赖添加到主模块的配置文件中）
- 进入对应子模块的目录下使用 `uv add/remove` 命令即可管理对应子模块的依赖

=== Docker 集成

当项目运行环境为 Ubuntu，而开发环境为 Windows，可在 Docker 中的容器中开发项目。构建开发容器的 DockerFile 参考如下：

```Dockerfile
FROM ubuntu:22.04
COPY --from=ghcr.io/astral-sh/uv:0.9.5 /uv /uvx /bin/

# 使用清华源，uv 至少需要 curl 与 ca-certificates（update-ca-certificates 更新整数）两个包
RUN sed -i 's|http://.*archive.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    sed -i 's|http://.*security.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates && \
    update-ca-certificates

# uv 中使用清华源
RUN mkdir -p ~/.config/uv && \
    touch ~/.config/uv/uv.toml && \
    echo <<'EOF' > ~/.config/uv/uv.toml
[[index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/"
default = true
EOF

# 项目文件夹为 /app，虚拟环境文件夹为 /.venv
WORKDIR /app
ENV UV_PROJECT_ENVIRONMENT=/.venv
ENV PATH="/.venv/bin:$PATH"
# 针对容器的相关优化设置
ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1

# 创建虚拟环境并将项目临时挂载到容器中以安装依赖
RUN uv venv --python 3.10 $UV_PROJECT_ENVIRONMENT
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=/app/uv.lock,rw \
    --mount=type=bind,source=.,target=/app,readonly \
    uv sync --editable

CMD ["/bin/bash"]
```

以上 DockerFile 用于构建项目所需环境的镜像，实际使用时还要将项目文件夹挂载到 `/app` 中，通过 Vscode 附加到容器中进行开发，一般即 `--mount type=bind,src=${PWD},dst=/app`。

在容器内（Linux）与容器外（Windows）使用 git 时可能会因为行尾字符不同导致问题，可添加 git 设置忽视行尾解决，一般即在容器内运行以下命令统一行尾策略：\ `printf "* text=auto eol=lf\n" > .gitattributes`

在 Docker 容器中安装模块时，建议先使用 `uv add` 等命令在容器中安装并，确定模块可用后重新构建镜像，由于设置已经写入 `pyproject.toml`，因此新镜像能够保留新加入的模块。

=== 复杂依赖管理

对于如 `pytest` 等测试模块、`xxx-stub` 等用于提示的模块仅在开发时需要，安装时不需要，即开发时依赖
- 安装开发时依赖仅需在启用 `uv add` 命令的 `--dev` 选项，如 `uv add --dev pytest`
- 命令 `uv sync` 同步项目时则需要增加 `--all-packages --group dev` 选项，同步时包含项目中所有模块的开发时依赖

对于仅在特定子功能使用到的依赖，即可选依赖
- `uv add` 把某个模块添加到特定的依赖组时，需要使用选项 `--optinal <依赖组>`
- `uv sync` 同步项目时则需要使用选项 `--extra <依赖组>` 同步安装特定依赖组，选项 `--all-extras` 同步所有依赖组
- 对于存在依赖组的模块，使用 `uv add` 安装时则需要使用 `--extra <依赖组>`，对应 `pip` 中将依赖组放在模块名后 `[]` 的部分中

=== 问题解决

警告 `warning: Failed to hardlink files`
- 参考#link("https://juejin.cn/post/7544742344099364906")[链接]，该问题由 Windows 中 uv 的缓存文件夹与项目文件夹所在磁盘不同导致
- 添加环境变量 `UV_CACHE_DIR=<盘符>:\uv-python-cache` 指定 uv 缓存文件夹与常用项目文件夹一致，或无视警告（可能导致虚拟环境空间占用增加）

使用 `uv add torch torchvision --index pytorch=xxx` 安装模块时出现版本过低问题
- 该问题来源为优先从添加的索引仓库安装其他包，其中没有所需包对应版本，因此要手动修改 `pyproject.toml`，令添加的索引仓库仅用于安装 torch
- ```toml
[tool.uv.sources]
torch = { index = "pytorch" }

[[tool.uv.index]]
name = "pytorch"
url = "https://download.pytorch.org/whl/cu121"
# 表明仅显示需要该索引仓库时才从中寻找包
explicit = true
```
- 然后使用 `uv add torch` 安装 Torch

== Tyro

Tyro 是一个 Python 模块，用于依据给定的#link("https://tonyddg.github.io/noteverse/coding/py/base/base.html#%E6%95%B0%E6%8D%AE%E7%B1%BB")[数据类]生成对应的命令行交互界面。

笔记中通过 `import tyro` 导入 Tyro

=== 基础使用

Tyro 通过解析给定的数据类类型，依据类型中属性名称作为命令行参数名、依据属性类型检查命令行参数值、依据属性默认值作为参数默认值、依据属性注释作为命令行帮助的注释。

例如以下代码演示了 Tyro 所支持的基础类型：

```python
import tyro
import pathlib
from typing import Literal, Tuple, Optional, Union
from dataclasses import dataclass

@dataclass
class Args:
    """Tyro 能读取数据类注释作为命令行接口介绍"""

    # Tyro 支持 str, float, int, bool 等基础类型，以及路径 pathlib.Path 
    # base_val: str = "Hello"

    # 给定各个元素类型, 接收固定长度的元组
    fix_tuple: Tuple[int, int]
    # 给定元素类型与 ... 接收不定长度的元组
    multiple_tuple: Tuple[pathlib.Path, ...]

    # 没有默认值的布尔属性与一般属性一样
    none_flag: bool
    # 有默认值的布尔属性将视为标志处理, 通过 --no-<属性名> 表示关闭
    # flag_a: bool = False

    # 字面量类型将视为枚举处理（同样可接收枚举值，此处略）
    color: Literal["red", "green"]

    # Union 与 Option 同样可用, 且能与上述类型组合
    # option_and_literal: Optional[Literal[0, 1, 2, 3]] = None
    tuple_of_string_or_int: tuple[Union[Literal["red", "green"], int], ...]

    # Tyro 支持 str, float, int, bool 等基础类型，以及路径 pathlib.Path 
    base_val: str = "Hello"
    # 有默认值的布尔属性将视为标志处理, 通过 --no-<属性名> 表示关闭
    flag_a: bool = False
    # Union 与 Option 同样可用, 且能与上述类型组合
    option_and_literal: Optional[Literal[0, 1, 2, 3]] = None

if __name__ == "__main__":
    # 通过函数 tyro.cli 生成命令行接口并读取
    cnf = tyro.cli(Args)
    print(cnf)
```

关于基础使用
- tyro 同样支持基于函数构造命令行接口，此时接口说明写在函数注释的 `Args` 下
- 对于不支持的类型，不会出错而是无法用命令行接口修改值，可通过#link(<sec:tyro_constructor>)[自定义构造器]用命令行构造这些不支持的类型
- tyro 依据属性名生成接口时，会将其中下划线 `_` 转为横杠 `-`，大写字母转为小写字母，大写小写切换时将添加横杠 `-`，如 `AdamPolicy_func` 将转化为 `adam-policy-func` <sec:tyro_cmd_style>

=== 实用高级功能

关于 Tyro 更多高级操作详见文档，此处仅介绍实用操作

==== 数据类嵌套

Tyro 同样支持将数据类作为接口数据类的属性值，此时需要通过 `.` 访问嵌套数据类的属性值，如 `--<接口属性名>.<嵌套属性名>`

例如以下例子中，需要使用 `--opt.learning-rate` 访问属性 `opt` 下的属性 `learning_rate`

```py
import dataclasses

import tyro

@dataclasses.dataclass
class OptimizerConfig:
    learning_rate: float = 3e-4
    weight_decay: float = 1e-2

@dataclasses.dataclass
class Config:
    # Optimizer options.
    opt: OptimizerConfig
    # Random seed.
    seed: int = 0

if __name__ == "__main__":
    config = tyro.cli(Config)
    print(dataclasses.asdict(config))
```

对于使用 `Union` 组合的嵌套数据类同样支持，此时需要使用子命令的形式明确各个属性具体使用的嵌套类，具体格式为 `<属性名>:<嵌套类名>`（嵌套类名也会转为为#link(<sec:tyro_cmd_style>)[命令行格式]）。

例如以下例子需要先使用 `opt:adam-config alg:ppo-policy` 明确使用的嵌套数据类型：

```py
import dataclasses
import tyro
from typing import Union

@dataclasses.dataclass
class AdamConfig:
    learning_rate: float = 3e-4
    beta: float = 1e-2
@dataclasses.dataclass
class SGDConfig:
    learning_rate: float = 3e-4
    weight_decay: float = 1e-2

@dataclasses.dataclass
class PPOPolicy:
    epsilon: float = 1e-3
@dataclasses.dataclass
class SACPolicy:
    updata_step: int = 30

@dataclasses.dataclass
class Config:
    # Optimizer options.
    opt: Union[AdamConfig, SGDConfig]
    # Algorithm options.
    alg: Union[PPOPolicy, SACPolicy]
    # Random seed
    seed: float

if __name__ == "__main__":
    config = tyro.cli(Config)
    print(dataclasses.asdict(config))
```

==== 自定义构造器 <sec:tyro_constructor>

虽然 Tyro 不支持 `Callable` 或一般类等类型，但可以定义一个构造器函数（同样会尝试解析该函数的命令行接口）代替。

通过 `Annotated[实际类型, tyro.conf.arg(constructor = construct_func)]` 规定构造器，构造器将被视为数据类嵌套，具体示例如下：

```py
import tyro
from typing import  Annotated, Callable
from dataclasses import dataclass

def add(a: float, b: float):
    return a + b
def mul(a: float, b: float):
    return a * b

def construct_func(
    name: Literal["add", "mul"]
) -> Callable[[float, float], float]:
    if name == "add":
        return add
    else:
        return mul

@dataclass
class Args:
    # 通过 Annotated[实际类型, tyro.conf.arg(constructor = construct_func)] 规定构造器
    func: Annotated[
        Callable[[float, float], float],
        tyro.conf.arg(
            constructor = construct_func
        )
    ]
    a: float
    b: float

if __name__ == "__main__":
    cnf = tyro.cli(Args)
    print(cnf.func(cnf.a, cnf.b))
```

== Pytest

此处仅介绍 Pytest 基于 uv 集成的简单使用。

Pytest 能够基于编写的测试脚本，测试项目中的模块是否按照输入给出预期的输出或抛出预期的异常，以确定模块是否正常工作。

=== uv 项目集成

在创建好基于 #link(<sec:uv>)[uv 的单模块或 Monorepo 项目]后，以通过命令 `uv add --dev pytest` 将 Pytest 以开发时依赖安装到项目。

一般情况下，在项目根目录下创建文件夹 `tests` 管理测试脚本，测试脚本使用 `xxx_test.py` 或 `test_xxx.py` 作为名称，`xxx` 可使用对应被测试模块名称。文件夹 `tests` 下可以有子文件夹为不同测试脚本分类。

最后通过命令 `uv run pytest [target] [-v]` 执行测试
- `target` 测试脚本路径或所在目录（将递归运行目录下所有测试脚本），默认将自动检测
- `-v` 是否输出详细的测试结果

=== 基本测试脚本

测试脚本与一般 Python 脚本类似可以使用 `import` 调用项目中的模块，且一般会 `import pytest` 以引用相关功能。不同之处在于 pytest 使用名称为 `test_xxx` 的测试函数作为最小测试单元。测试时 pytest 将调用这些函数执行测试。

一般情况下 Pytest 根据测试函数是否抛出异常判断测试是否通过，且一般使用 `assert` 语句判断表达式是否成立，因此有以下示例：

```py
def test_assert():
    fun_ret = 100
    # 检查函数返回值是否符合预期
    assert fun_ret == 100
```

此外，还可以通过基于 `pytest.raises` 的 with 表达式检查代码是否能抛出期望的异常类型

`pytest.raises(expected_exception, *, match = None)`
- `expected_exception` 异常类型，当代码块抛出指定异常及其子类时通过测试
- `match` 正则表达式，当指定时，需要异常信息匹配该正则表达式才能通过测试

例如以下示例：

```py
import pytest

def test_div():
    with pytest.raises(ZeroDivisionError, match=r"division by .*"):
        a = 5 / 0
```

=== 测试夹具

在执行测试时，输入数据可使用 Pytest 的测试夹具功能进行统一管理，应避免定义在函数内或脚本公共区域。

Pytest 的夹具（Fixture）为使用 `@pytest.fixture` 修饰的函数，测试时将执行这些函数并捕获其返回值，检测测试函数中存在与夹具同名的参数时，将会传递这些夹具返回值。注意：
- 其他夹具函数也可以以夹具名为参数，从而接收夹具值
- 每次进入新的测试函数都会重新初始化夹具
- 当夹具函数被多次调用时（被其他夹具间接调用），仅会调用一次，后续使用其引用，因此最好保证夹具间没有副作用

例如以下示例：

```py
import pytest

@pytest.fixture
def first_entry():
    return "a"
# 该夹具返回的列表为可变对象
@pytest.fixture
def order():
    return []

# 每次进入新的测试单元都会重新初始化夹具
def test_int(order):
    # Act
    order.append(2)
    # Assert
    assert order == [2]

# 该夹具中对 order 产生了副作用
@pytest.fixture
def append_first(order, first_entry):
    return order.append(first_entry)
# 初始化时，夹具调用仅进行一次，此时的 order 将是被修改了的 ["a"]
def test_string_only(append_first, order, first_entry):
    # Assert
    assert order == [first_entry]
```

可以在测试目录下的脚本 `conftest.py` 中定义所有测试单元共享可引用的夹具，同时还可使用修饰器参数 `@pytest.fixture(scope)` 规定夹具的作用域，即何时被销毁，常用的作用域有
- `function` 默认，即测试函数退出后销毁对应夹具，调用时再重新创建（一般测试数据）
- `module` 当前的测试脚本测试完成后销毁对应夹具（可用于对类对象测试，避免重复创建类）
- `session` 测试结束后销毁对应夹具

有时测试数据可能有多组，从而以不同角度测试函数性能，称为参数化测试。可使用修饰器参数 `@pytest.fixture(params)` 创建参数化测试
- `params` 值为一个列表，每个列表元素对应一份测试数据
- 通过夹具函数的参数 `request.param` 提取单组测试数据（`request` 为一个特殊夹具）

例如以下代码

```py
@pytest.fixture(params = [(1, 1), (-1, 1)])
def data_fn(request):
    return request.param

def test_fn(data_fn):
    assert data_fn[1] == data_fn[0] ** 2
```

=== 消息捕获

默认情况下 Pytest 会捕获测试中的 `stdout` 和 `stderr`，仅当测试函数出错时，会输出其 `stdout` 和 `stderr`。表现为仅当测试不通过时 `print` 函数的内容会被打印到控制台上（包括 logger）。


