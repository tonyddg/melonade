#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "FastAPI 笔记")

#import "/utility/include.typ": *

= FastAPI 笔记

FastAPI 是一个使用 Python，用于构建 API 的 web 框架

#link("https://fastapi.tiangolo.com/zh/")[参考教程]

通过 pip 命令 
- `pip install fastapi` 安装 FastAPI 基本组件
- `pip install uvicorn[standard]` 安装运行 FastAPI 的服务器

== 基本使用

一个 FastAPI 应用具有如下的基本结构

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
```

=== 启动服务

以上代码中，`app = FastAPI()` 创建了一个 API 交互对象

使用命令 `uvicorn <模块>:<交互对象> [option]` 即可启动服务
- `模块`：交互对象所在的模块（通常对应 Python 程序文件，不需要 `.py` 后缀）
- `交互对象`：模块中定义的交互对象变量名，如以上示例的 `app`
- `option` 命令选项，常用的有
  - `--port <端口>` 指定服务所在的端口，默认为 8000
  - `--host <地址>` 指定服务所在的地址，默认为 127.0.0.1（Docker 容器最好使用全地址 0.0.0.0 并从 localhost 发起服务）
  - `--reload` 自动监控 Python 程序变化而重启服务器（用于开发）

FastAPI 中，通过访问 URL `/docs`（如 `http://127.0.0.1:8000/docs`）还可以查看自动生成的 API 测试与文档页面

=== 路径操作

在 HTTP 协议中，将 URL 中从第一个 `/` 起的后半部分称为路径，认为每个路径对应了一个资源。

用于可以通过发出请求从而操作这些资源，常用的操作有
- `GET` 请求只能附带查询参数，多用于读取数据
- `POST` 除了查询参数外，同时可以将复杂结构体（JSON）或二进制文件作为请求体，多用于创建与修改数据
- 其他操作此处略

用户在某个路径发出某个操作请求后，具体的行为需要由服务器完成。FastAPI 中则通过修饰器的方式将 Python 函数注册到交互对象中，从而确定当用户发出以特定操作访问特定路径的请求后，服务器该执行什么，返回什么。

FastAPI 中使用*路径操作装饰器*定义服务器可以处理的请求，被修饰的*路径操作函数*确定了服务器需要执行的程序
- *路径操作装饰器*由交互对象 `app` 的成员函数创建，函数 `app.get` 表明操作为 `GET`（类似的 `app.post` 表明操作为 `POST`），函数的字符串参数确定被访问的路径
- *路径操作函数*以请求参数为函数参数，以请求结果为返回值（返回值将自动转换为 JSON）
- 例如上述示例中的路径操作装饰器 `@app.get("/")` 表明当服务器接收到使用 `GET` 方法访问路径 `/` 的请求时将执行路径操作函数 `root`

=== 异步编程

在 Web 应用中，涉及到了如请求网络数据、文件读写、数据库访问等操作需要 CPU 原地等待数据响应，如果直接阻塞等待将占用大量 CPU 资源

因此可以将涉及相关操作的*路径操作函数*定义为异步函数，从而提高服务器运行效率

此处仅简略介绍 Python 异步编程的使用
- 定义函数时使用 `async def` 标注，表明该函数为一个异步函数，即调用后将返回一个协程对象，不会立刻返回值，直到被 `await` 关键字处理
- 在异步函数中调用异步方法时，可以使用 `await` 关键字修饰异步方法的调用，让解释器切换到其他部分代码的执行（如处理其他请求）直到这一异步方法执行完成
- 涉及异步操作时，相关库的文档都会说明这是一个异步函数，需要 `await` 关键字，此时就可以将*路径操作函数*定义为异步函数

== 数据交互

首先确定以下名词：
- *响应体*：服务器响应用户发出请求后返回的数据，在 FastAPI 中通常为 JSON 格式数据
- *查询参数*：查询参数包含在 URL 中（键值对位于 URL 的 `?` 之后，以 `&` 分隔），以明文传递且只能使用 ASCII 参数，一般的操作均可附带
- *请求体*：请求传输的主要内容，可以是文件、JSON、表单等，基于请求体的操作参数将使用 JSON 的方式传递因此可以传递复杂数据结构，但操作 `GET` 不支持请求体

虽然 FastAPI 均通过路径操作函数的参数获取查询参数与请求体，但使用中需要注意区分查询参数与请求体，确保 `GET` 操作仅能使用查询参数

=== Pydantic 数据模型

Pydantic 为数据模板定义与校验库，可以快速检查数据是否符合给定的模板，功能上与 Python 官方的 dataclass 类似但功能更强大。其为 FastAPI 的基础模块之一，为 FastAPI 提供了参数校验的功能。

Pydantic 中将数据模板称为模型
- 与 dataclass 不同，通过继承模型基类 `pydantic.BaseModel` 构造模型
- 与 dataclass 相同，通过定义带有类型标注的静态模型确定模型中的字段，且模型将据此自动生成构造函数
- 与 dataclass 不同，Pydantic 模型在非严格模式中，构造函数在构造模型时会尝试类型转换与忽略不匹配的参数（详见后续例子）
- 通过成员函数 `model_dump()` 将模型转为 Python 字典
- 模型还提供了以下静态函数用于验证并创建模型
  - `cls.model_validate(d)` 验证字典 `d` 是否符合模型要求，如符合返回基于该字典构造的模型（基本等价于构造函数，仅将传入类型换为字典）
  - `cls.model_validate_strings(d)` 类似 `cls.model_validate(d)`，但会尝试将字符串的值转化为模型要求的形式
  - `cls.model_validate_json(s)` 验证并将 JSON 字符串转化为模型
- 其他应用参见#link("https://docs.pydantic.dev/latest/concepts/models/")[官方文档]

Pydantic 中提供了 `Field(...)` 函数用于约束字段的取值，通过向函数传递参数从而确定约束，主要有
- 字段默认值
  - `default` 设置字段的默认值（Pydantic 会深拷贝默认值，没有 dataclass 中可变类型不能直接作为默认值的问题）
  - `default_factory` 字段默认值构造函数，不同于 dataclass，函数还会接收一个包含了已确定字段的字典作为参数，因此不需要 `post_init`
- 数字约束：
  - `gt, lt, ge, le` 限制数字范围
  - `decimal_places` 限制浮点数小数范围
- 字符串约束：
  - `min_length, max_length` 限制字符串、列表或元组的长度
  - `pattern` 需要匹配的正则表达式
- 其他应用参见#link("https://docs.pydantic.dev/latest/concepts/fields/")[官方文档]

Pydantic 中使用 `Field(...)` 函数约束字段取值时
- 可以像 dataclass 一样使用 `<字段名>:<字段类型> = Field(...)`
- 还可以使用 Python 官方模块 `typing` 中的带标注类型 `typing.Annotated`
  - 通过 `<字段名>:Annotated[<字段类型>, Field(...)]` 实现与上述相同的效果（FastAPI 中更倾向此类做法，特别是函数参数中）
  - `Annotated` 本身定义了一种类型，因此可以像 `MyType = Annotated[<字段类型>, Field(...)]` 一样复用带约束的字段类型
  - Pydantic 还有其他类型约束 / 修饰器需要在 `Annotated` 中修饰（`Annotated` 第一个参数为主类型，后续均为类型标注可以有任意多个）

=== 查询参数与请求体

FastAPI 中使用类似 Pydantic 中的 `Field(...)` 函数显示地规定参数属于哪个类型
- `Query(...), Body(...)` 分别表示查询参数与请求体（除此之外还有路径参数、Cookie、Header、表单、文件等后续介绍）
- 这些函数具有与 `Field(...)` 相同的参数与使用方法，区别在于其来自 `FastAPI` 模块
- 通过 `Annotated` 将类型与三个函数结合，作为*路径操作函数*的参数类型确定请求参数的名称、类型、约束

对于请求体，FastAPI 还支持直接使用 Pydantic 模型作为参数类型，从而在接收到请求后依据 Pydantic 模型对请求体进行检查（查询参数也可以使用 Pydantic 模型作为参数类型，但最好不能有嵌套）

除了显示标注参数类别，FastAPI 通过以下规则简单区分无标注的参数为查询参数还是请求体：
- 类型是（int、float、str、bool 等）单类型的参数，是查询参数
- 类型是 Pydantic 模型的参数，是请求体

除了值约束，FastAPI 还可以通过 `Query(...), Body(...)` 等函数规定字段的名称等元数据，常用的如
- `title`：字段名称
- `description`：字段描述

=== 接收文件 <accept_file>

HTTP 中文件以表单的形式发送，因此需要安装扩展 `pip install python-multipart`

FastAPI 中使用类型 `UploadFile` 表示文件参数，同时接收到的文件也将表示为 `UploadFile` 对象
- 属性 `filename`：文件名
- 属性 `content_type`：内容的 MIME 类型 / 媒体类型字符串
- 异步方法 `read()`：将文件读入内存，通常将读取到的数据传入 `io.BytesIO` 创建 io 对象从而可以像一般 `open` 方法打开的文件一样操作

例如以下示例代码接收压缩的 Numpy 数组文件，并转为 Numpy 数组对象，实现 Numpy 数组的传递（对应#link(<client_program>)[客户端]）

```python
from fastapi import FastAPI, UploadFile, HTTPException
import numpy as np
import io

app = FastAPI()

@app.post("/infer")
async def infer(arr_npz: UploadFile):
    # 异步读取文件为字节串 (bytes)
    raw = await arr_npz.read()
    # 部分要求文件对象的读取函数可用 io.BytesIO 包装
    raw = io.BytesIO(raw)

    try:
        # numpy 可以直接从字节串读取  
        npz = np.load(raw, allow_pickle=False)
        data = npz["data"]
    except Exception:
        raise HTTPException(400, "Invalid file")
    
    return {"shape": data.shape}
```

=== 响应体模型

默认情况下路径操作函数可以返回认为键值对作为响应体，但大部分情况下我们需要对响应体进行检查，保证其输出固定的格式以便于客户端使用

在定义*路径操作装饰器*中，参数 `response_model` 规定了响应体需要符合的类型，参数值为 Python 类型

例如以下代码中，返回的 `user` 经过模型 `UserOut` 验证后，丢弃了不匹配的 `pw` 字段

```python
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr

class UserIn(BaseModel):
    name:str = "John"
    email: EmailStr = "example@gmail.com"
    pw: str = "123456"

class UserOut(BaseModel):
    name: str
    email: EmailStr

app = FastAPI()
@app.post("/user/", response_model = UserOut)
async def create_user(user: UserIn):
    return user
```

== 其他应用

=== 交互对象生命周期事件

在如机器学习应用、数据库连接中，通常需要在应用启动前读取模型参数，在应用关闭时清理资源，可通过定义响应的回调函数来达成这一目的

FastAPI 并不直接使用回调函数，而是 Python 的异步上下文管理器，该语法较为复杂，此处直接给出这类函数的模板

```python
from contextlib import asynccontextmanager
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 在应用启动前执行
    ml_models.load()
    yield # 函数将在此暂停
    # 在应用关闭后执行
    ml_models.clear()
```

将定义的异步上下文管理器传递给交互对象构造函数的 `lifespan` 参数即可注册

=== 客户端编程 <client_program>

此处介绍 Python 的 requests 模块，该模块将作为客户端，用于访问如基于 FastAPI 的服务端

此处仅简单介绍，关于详细教程参见#link("https://docs.python-requests.org/projects/cn/zh-cn/latest/index.html")[官方文档]

函数 `response = requests.post(...)` 用于发送 `POST` 请求
- 参数 `url`：字符串，访问的链接
- 参数 `data`：一般请求体，可以是字符串（视为文本文件）、字典（视为表单）
- 参数 `json`：字典，将该字典编码为 JSON 字符串作为请求体发送
- 关键字参数 `file`：字典，用于表示文件请求体
  - 字典的键名为文件参数名称
  - 字典的键值为元组，包含文件名、文件对象（或字节串对象）、文件类型（如一般二进制文件 `application/octet-stream`）
- 关键字参数 `params`：字典，请求的查询参数
- 关键字参数 `timeout`：浮点数，服务器超时（当服务器超过此时刻没有应答任何数据抛出异常，否则将阻塞等待）
- 其他关键字参数，如 `header, cookie` 等此处略
- 类似的有 `requests.get(...)` 用于发送 `GET` 请求（没有用于请求体的 `data, json` 参数）

返回值 `response` 对象包含了响应信息，主要属性有
- `status_code` 响应状态码
- `headers` 响应头
- `content` 字节串（`bytes` 类型）形式的响应内容
- `json()` 尝试将响应内容视为 JSON，转为字典

例如以下代码向服务端发送 Numpy 数组文件（对应对应#link(<accept_file>)[服务端]）

```python
import requests
import io
import numpy as np

arr = np.zeros((3, 3))
# 将文件保存到内存的字节流中而不是硬盘上
buf = io.BytesIO()
np.savez(buf, data = arr)

respond = requests.post(
    url = "http://127.0.0.1:8000/infer",
    # 注意参数名称
    files = {"arr_npz": (
        "data.npz",
        # 将字节流转为字节串发送
        buf.getvalue(),
        "application/octet-stream"
    )},
    timeout = 1
)

print(respond.json())
```
