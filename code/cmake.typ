#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "CMake 笔记")

#import "/utility/widget.typ": *

= CMake 笔记

== 基本语法与操作

CMake 提供了一套流程控制脚本语言，通过编写脚本规定如何组织项目中的源代码与资源。

=== 基本语法

CMake 中的所有语言结构均为命令
- 通过命令后的 `()` 内传入参数，多个参数#hl(2)[使用空格分隔]
- 命令必须以 `()` 结尾，即使该命令没有参数
- 通常使用小写字母表示命令，大写字母表示变量，`#` 作为注释符号
- 使用 `CMakeLists.txt` 作为脚本执行入口，其余 `.cmake` 文件需要通过 `CMakeLists.txt` 引用才能执行

CMake 中，所有变量保存的值本质均为字符串，传递给命令的参数本质也为字符串。向命令传递参数时注意：
- 命令需要的是变量名还是具体值（需要 `${}`）读取变量值
- 命令存在某些标志参数，这些参数本质为大写字母表示的字符串

==== 变量定义 <sec:变量定义>

使用命令 `set` 定义或修改字符串变量：\   
`set(<变量名称> <字符串值> [CACHE|PARENT_SCOPE])`
- `CACHE` 用于定义//[缓存变量](#缓存变量)
- `PARENT_SCOPE` 用于在父作用域上定义或修改变量，一般用于//[函数](#函数)

使用命令 `unset` 删除已定义的字符串变量：\ 
`unset(<变量名称> [CACHE])`
- `CACHE` 用于删除//[缓存变量](#缓存变量)
- `PARENT_SCOPE` 用于在父作用域上删除变量

=== 字符串

参考文章 #link("https://blog.csdn.net/jjjstephen/article/details/122415231")

==== 字符串表示 <sec:字符串表示>

字符串表示中：
- 可以不需要 `""` 包裹，但此时空格与换行与 `;` 将被作为//[列表](#列表)
分隔符。当使用 `""` 包裹时，空格则能被读取到。
- 通过 `${val}` 的方式可以引用其他变量的值。
  - 该语句的实质为从最近的作用域中，寻找一个名称为 `val` 的变量，如果找不到则得到空字符串。
  - `${${val}}` 将寻找具有与 `${val}` 对应字符串相同名称的变量，该方式常用于函数。
  - `$ENV{val}` 将引用名称为 `val` 的环境变量
- 字符串中可使用 `\` 进行转义，常用的转义有 
  - `\n` 换行，`\\` 表示 `\`，`\"` 表示 `"`
  - `\$` 表示 `$`，`\{` 表示 `{`, `\}` 表示 `}`

例如
- 对于定义 `set(text a "b c")`，变量 `text` 值为 `a;b c`
- 对于定义 `set(path ./src) set(cppFile ${path}/main.cpp)`，变量 `cppFile` 值为 `./src/main.cpp`

==== 字符串操作

使用命令 `string` 操作字符串，常用功能有
- 寻找子字符串 `string(FIND <input> <sub> <indVar> [REVERSE])`
    - `input` 输入字符串
    - `sub` 用于匹配的子字符串
    - `indVar` 保存第一个匹配位置的索引，不存在时为 `-1`，传入变量名称（自动创建）
    - `REVERSE` 启用此选项时，将从后往前寻找
- 字符串替换 `string(REPLACE <match> <replace> <outVar> <input>)`  
    - `match` 用于匹配的字符串
    - `replace` 匹配后替换的字符串
    - `outVar` 替换结果保存变量，传入变量名称（自动创建）
    - `input` 输入字符串
- 提取子字符串 `string(SUBSTRING <input> <index> <len> <outVar>)`  
    - `input` 输入字符串
    - `index` 提取开始位置
    - `len` 提取长度
    - `outVar` 提取结果，传入变量名称（自动创建）
- 字符串长度 `string(LENGTH <input> <outVar>)`  
    - `input` 输入字符串
    - `outVar` 提取结果，传入变量名称（自动创建）
- 正则表达式操作：见有关文档的介绍

例如以下使用示例及其输出

```cmake
set(IN_TEXT main.cpp)

string(FIND ${IN_TEXT} cpp OUT_VAR)
# OUT_VAR: 5
message(STATUS "OUT_VAR: ${OUT_VAR}")

string(REPLACE cpp h OUT_VAR ${IN_TEXT})
# OUT_VAR: main.h
message(STATUS "OUT_VAR: ${OUT_VAR}")

string(SUBSTRING ${IN_TEXT} 2 3 OUT_VAR)
# OUT_VAR: in.
message(STATUS "OUT_VAR: ${OUT_VAR}")

string(LENGTH ${IN_TEXT} OUT_VAR)
# OUT_VAR: 8
message(STATUS "OUT_VAR: ${OUT_VAR}")
```

==== 字符串打印

使用命令 `message` 操作字符串：
`message([消息类型] <str>)`
- `消息类型` 常有消息类型如下
  - `STATUS` 一般状态（默认的类型）
  - `WARNING` 警告，不会中断处理
  - `FATAL_ERROR` 严重错误，打印后处理也将终端
- `str` 用于打印的字符串  
  - 仅打印变量时注意，当变量为空时将导致出错
  - 对于列表，其中的分隔符将被忽略

调试 CMake 打印变量 `VAL` 时建议使用 `message(STATUS "VAL: ${VAL}")` 的方式
- 即使变量值为空（不存在），也能确定是哪个变量名
- 该方式可以打印出#link(<sec:列表>)[列表]分隔符

=== 其他变量类型

CMake 将所有变量视为字符串，仅在特定的上下文中，可将一些变量视为其他类型操作

==== 数字

使用命令 `math` 对数字字符串（及支持整数）进行运算  
`math(EXPR <outVar> <expr>)`
- `outVar` 保存计算结果的变量，传入变量名称（自动创建）
- `expr` 用于计算的字符出字符串，可通过 `${}` 将变量值传入表达式，运算符与规则同 C

例如以下使用示例及其输出

```cmake
set(IN_VAL 6)
math(EXPR OUT_VAL "(${IN_VAL} - 2) / 3")
# OUT_VAL: 1
message(STATUS "OUT_VAL: ${OUT_VAL}")
```

==== 列表 <sec:列表>

列表表示中：
- CMake 将使用 `;`，` ` 或换行分隔的字符串视为列表（末尾不需要 `;`）
- 使用 `${val}` 打印列表时，分隔符将被隐藏。但如果被 `"` 包裹则能够显示分隔符 `;`

使用命令 `list` 操作列表，格式如下  
`list(<操作类型> ...)`

- 列表长度 `list(LENGTH <listVar> <outVar>)`
  - `listVar` 列表变量名称，传入变量名称
  - `outVar` 列表长度，传入变量名称（自动创建）
- 获取元素 `list(GET <listVar> <index> <outVar>)`
  - `listVar` 列表变量名称，传入变量名称
  - `index` 获取的索引值，从 0 开始计
  - `outVar` 元素值，传入变量名称（自动创建）
- 插入元素 `list(APPEND <listVar> <item>)`
  - `listVar` 列表变量名称，传入变量名称，插入后原列表修改
  - `item` 插入元素，传入变量名称（自动创建）
- 删除元素 `list(REMOVE_AT <listVar> <index>)`
  - `listVar` 列表变量名称，传入变量名称
  - `index` 被删除元素的索引值，从 0 开始计
- 合并列表 `set(<outVar> "${list1};${list2}")`
  - 合并列表的操作通过如上方式创建一个包含两个列表元素的列表，然后#link(<sec:变量定义>)[定义变量]保存此列表
  - 必要时可使用命令 `list(REMOVE_DUPLICATES <listVar>)` 去除重复元素
    - `listVar` 列表变量名称，传入变量名称

例如以下使用示例及其输出

```cmake
set(TEST_LIST a;b c;d"\n"e)
list(LENGTH TEST_LIST OUT_VAL)
# OUT_VAL: 4
message(STATUS "OUT_VAL: ${OUT_VAL}")

set(TEST_LIST a;b;c;d)
list(GET TEST_LIST 2 OUT_VAL)
# OUT_VAL: c
message(STATUS "OUT_VAL: ${OUT_VAL}")

set(TEST_LIST a;b;c;d)
list(APPEND TEST_LIST e)
# TEST_LIST: a;b;c;d;e
message(STATUS "TEST_LIST: ${TEST_LIST}")

set(TEST_LIST a;b;c;d)
list(REMOVE_AT TEST_LIST 2)
# TEST_LIST: a;b;d
message(STATUS "TEST_LIST: ${TEST_LIST}")
```

==== 路径

参考文章 #link("https://www.jianshu.com/p/be1024b6b6ed")

注意在 Cmake 中的路径操作时，通常采用的是 CMAKE 风格，主要为以 `/` 为分隔符。可以此风格的路径作为参数进行配置，仅在 `ADD_CUSTOM_COMMAND` 等执行命令时需要传入系统风格的路径。

- 定义路径 `cmake_path(SET <pathVar> [NORMALIZE] <input>)`
  - `pathVar` 定义的路径变量名称
  - `NORMALIZE` 是否规范化路径为 CMAKE 风格，将替换分隔符，删除重复的分隔符等
  - `input` 输入的路径字符串
- 连接路径 `cmake_path(APPEND <res> <path1> <path2>...)`
  - `res` 保存拼接结果的变量，拼接时会按需要添加分隔符并将分隔符转为 `/`（不删除多余分隔符）
  - `path1/2` 用于拼接的路径字符串，当 `path2` 为绝对路径时可能导致拼接失败
- 获取路径信息 `cmake_path(GET <pathVar> <获取属性> <outVar>)`  
  - `pathVar` 用于解析的路径变量名称（不能直接传入字符串）
  - `outVar` 解析结果保存变量
  - `获取属性` 需要获取的属性，常用有
    - `FILENAME` 文件完整名称，包含扩展名，不会区分目录或文件
    - `EXTENSION [LAST_ONLY]` 文件所有扩展名（如 `a.ex1.ex2` 获取结果为 `.ex1.ex2`)，启用 `LAST_ONLY` 将仅保留最后一个扩展
    - `STEM` 文件基本名称，不包含扩展名
    - `PARENT_PATH` 文件父目录的路径，可处理多重分隔符
    - `ROOT_NAME` 根目录名称，用于 Windows 系统以获取盘符，在 Linux 中以及相对路径中结果为空
- 转换路径规范 `cmake_path(CONVERT <path> <目标规范> <outVar> [NORMALIZE])`
  - `path` 用于转换的路径字符串或路径字符串列表，传入列表时还将按系统规范转换路径间的分隔符
  - `outVar` 转换结果保存变量名称
  - `NORMALIZE` 除转换为还进一步规范化路径
  - `目标规范` 设置转换目标采用的规范
    - `TO_cmake_path_LIST` 转换为 CMAKE 规范
    - `TO_NATIVE_PATH_LIST` 转换为本地系统的规范

例如以下使用示例及其输出

```cmake
cmake_path(SET OUT_PATH NORMALIZE "home//build\\\\CMakeCache.txt")
# OUT_PATH: home/build/CMakeCache.txt
message(STATUS "OUT_PATH: ${OUT_PATH}")

cmake_path(APPEND OUT_PATH "//include" "build\\\\CMakeCache.txt")
# OUT_PATH: //include/build//CMakeCache.txt
message(STATUS "OUT_PATH: ${OUT_PATH}")

set(IN_PATH "\\dir\\\\a.exe")
cmake_path(GET IN_PATH PARENT_PATH OUT_PATH)
# OUT_PATH: \dir
message(STATUS "OUT_PATH: ${OUT_PATH}")

cmake_path(CONVERT "/dir\\\\a.exe" TO_NATIVE_PATH_LIST OUT_PATH NORMALIZE)
# OUT_PATH: \dir\a.exe
message(STATUS "OUT_PATH: ${OUT_PATH}")
```

==== 布尔型

CMake 中使用 `ON/YES/TRUE/非零数` 表示真，使用 `OFF/NO/FALSE/0` 表示假。

具体使用见 #link(<sec:条件判断>)[条件判断]

=== 缓存变量 <sec:缓存变量>

缓存变量是一类特殊变量，在第一次运行时，需用通过命令行或 GUI 确定变量的值，并一直保存在 `build` 中的 `CMakeCache.txt` 文件。当使用 `set` 定义了一个与缓存变量同名的一般变量时，一般变量优先。

==== 定义缓存变量

使用命令 `set` 可用于定义缓存变量：`set(<varName> <init> CACHE <type> <helpStr> [FORCE])`
- `varName` 变量名称
- `init` 变量初始值
- `type` 变量类型，主要有以下常用类型
  - `BOOL` 布尔型变量，GUI 为一个复选框
  - `STRING` 字符串
  - `PATH` 文件路径（有专门的 GUI 用于选择路径）
- `helpStr` 解释字符串，注意不可省略
- `FORCE` 启用此选项后，将强制刷新已有的缓存变量，否则当缓存已存在与 `CMakeCache.txt` 时将无法修改值

==== 定义缓存选项

使用命令 `option` 定义缓存选项：`option(<optName> <helpStr> [valStr])`
- `optName` 条件变量名称
- `helpStr` 解释字符串，不可省略
- `valStr` 条件变量的值，开启为 `ON/YES/TRUE/非零数`，默认或其他字符串表示 `OFF/NO/FALSE/0` 

==== 修改缓存变量

- 直接修改 `build` 下的 `CMakeCache.txt` 文件
- 通过 CMake-gui 选择项目目录与 `build` 目录修改，将自动读取缓存变量并修改
- 使用 `CMake` 命令时添加选项 `-D<缓存变量名称>[:变量类型]=<变量值>`

=== 流程控制

==== 条件判断 <sec:条件判断>
参考文章 #link("https://blog.csdn.net/fengbingchun/article/details/127946047")

条件语句具有如下格式

```cmake
if(<判断语句>)
<命令>
elseif(<判断语句>)
<命令>
else()
<命令>
endif()
```

以下为常用的判断语句
- 值为真 `<str>`   
  - `str` 被判断的字符串，当 `str` 取 `ON/YES/TRUE/非零数` 时为真
- 变量已定义 `DEFINED <val>`  
  - `val` 用于判断的变量名（不是字符串），当 `val` 已经定义时为真，包括缓存变量
- 文件存在 `EXISTS <path>`
  - `path` 用于判断的路径字符串，当 `path` 指向的文件或文件夹存在时为真    
- 绝对路径判断 `IS_ABSOLUTE <path>`  
- 目录判断 `IS_DIRECTORY <path>`  
- 字符串比较 `<str1> STREQUAL <str2>`  
  - `str1/2` 用于比较的字符串，当两个字符串相同时为真
- 正则匹配 `<str> MATCH <regex>`  
  - `str` 用于比较的字符串
  - `regex` 正则表达式字符串（似乎对 `\\w+` 支持有问题，可使用 `[A-Z]+` 或 `\\w*` 或直接使用需要匹配的子字符串） 
  - 当字符串部分或全部匹配时为真
- 数字比较 `<val1> EQUAL <val2>`
  - `val1/2` 用于比较的数字，可以是字符串
  - 除 `EQUAL` 还有 `LESS`，`GREATER`，`LESS_EQUAL`，`GREATER_EQUAL` 等比较方式
  - 满足比较条件时为真
- 目标是否存在 `TARGET <target>`
  - `target` 测试目标
  - 可用于避免目标重复生成

逻辑语句之间可使用 `NOT`，`OR`，`AND` 进行连接。可通过括号控制运算的优先级。

例如以下使用例子用于判断当前编译模式

```cmake
if(DEFINED ${CMAKE_BUILD_TYPE})
  if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    message(STATUS "Debug 模式编译")
  else()
    message(STATUS "Release 模式编译")
  endif()
else()
  message(STATUS "没有定义 build type，检查是否使用了多生成器")
endif()
```

==== foreach 循环 <sec:foreach_循环>

`foreach` 循环有如下基本结构
```cmake
foreach(<iter> ...)
...
endforeach()
```

- 遍历列表 `foreach(<iter> <listStr>)`
  - `iter` 迭代元素
  - `listStr` 被迭代列表字符串，不能传入变量
- 遍历变量 `foreach(<iter> IN LISTS <listVar>)`
  - `iter` 迭代元素
  - `listStr` 被迭代列表变量
- 按次循环 `foreach(<iter> RANGE <stop>)`
  - `iter` 迭代变量
  - `stop` 停止值，注意迭代将从 0 开始，直到停止值，因此循环此时为停止值 + 1

==== while 循环

`while` 循环有如下基本结构
```cmake
while(<条件语句>)
...
endwhile()
```

当条件语句为真时执行循环，可使用 `break()` 与 `continue()` 控制循环（也可用于#link(<sec:foreach_循环>)[foreach]）。

==== 函数

函数的基本结构
```cmake
function(<name> [arg1] [arg2]...)
...
endfunction()
```

- `name` 函数名，通过此函数名调用函数
- `arg` 函数参数

由于函数中的作用域比调用函数的位置低一级，因此函数可以访问外部的值，但无法修改  
如果希望修改外部的值，则需要启用 `set` 命令的 `PARENT_SCOPE` 选项，例如
```cmake
function(fun opt)
    set(${CMAKE_CXX_STANDARD} ${opt} PARENT_SCOPE)
endfunction()
```

CMake 中的函数仅能传入字符串，但可通过将变量作为名参数的方式传递值，并使用 `set` 操作（类似将变量名称字符串视为变量的指针），可以此实现类似引用的效果与返回值，例如
```cmake
function(fun result_val)
    set(${${result_val}} "Hello" PARENT_SCOPE)
endfunction()
```

通过语句 `return()` 可以提前退出函数，但不能返回值

==== 引用其他文件

使用命令 `include` 执行并引用其他 CMAKE 文件（扩展名为 `.cmake`） 

引用文件时将执行被引用文件，且引用的文件中具有与引用位置相同的作用域。可将部分操作作为封装为函数并写入单独的 `.cmake` 中，在需要使用时引用。

=== 文件操作

==== 文件查找 <sec:文件查找>

通过以下命令可以查找文件：\ 
```cmake
file(
  <GLOB|GLOB_RECURSE> <res> [LIST_DIRECTORIES true|false] [RELATIVE <path>]
   <express1> <express2> ...
)
``` 
- `res` 查找结果保存变量，为一个列表，保存了所有满足查找结果的文件路径（绝对路径）
- `express` 查找文件的表达式字符串，允许使用 `*` 与 `?` 等通配符，可以此实现查找所有源文件的效果，如 `src/*.cpp`
- `LIST_DIRECTORIES` 用于递归查询，是否将递归结果中的目录放在结果中，默认关闭
- `RELATIVE <path>` 查找路径，默认为当前的 `CMakeLists.txt` 所在路径
- `GLOB|GLOB_RECURSE` `GLOB` 表示仅查找当前目录，`GLOB_RECURSE` 则将进行递归查找

例如以下命令将寻找文件夹 `src` 下所有的 `.c` 与 `.cpp` 文件，以列表形式保存到变量 `SOURCE_FILE` 中

```cmake
file(
  GLOB SOURCE_FILE 
  "${PROJECT_SOURCE_DIR}/src/*.cpp" 
  "${PROJECT_SOURCE_DIR}/src/*.c"
)
```

使用命令 `aux_source_directory(<res> <dir>)` 将寻找指定目录下所有源文件
- `res` 保存查询结果的变量，为一个列表
- `dir` 查询的文件夹

==== 其他常用文件操作

- 命令 `file([FILE_COPY|COPY] <source> <dest>)` 复制文件
  - `FILE_COPY` 复制单个文件为指定文件
  - `COPY` 复制多个文件与目录到指定目录下
- 命令 `file(RENAME <source> <dest>)` 重命名（移动）文件
- 命令 `file([WRITE|APPEND] <file> <content>)` 创建文件并写入内容，文件不存在时将创建
  - `WRITE` 写入时将覆盖原有内容
  - `APPEND` 写入时将在文件末尾添加内容

== CMake 项目配置

参考文章 #link("https://blog.csdn.net/qq_43495002/article/details/134000654")

CMake 为一个跨平台的项目构建器，其本身无法编译与生成目标（如可执行程序），而是根据用户规则生成具体生成器所需的构建系统文件，最后由具体生成器生成相应的目标。

因此一个基于 CMake 的项目通常有以下使用流程
- 编写项目源代码
- 编写 `CMakeLists.txt`，说明生成项目的必要信息，例如对于 C++：
  - 项目源文件，需要说明哪些文件是源代码、头文件、静态链接库、动态链接库等
  - 构建方式，说明使用什么方式构建项目、编译器选项、生成二进制结果存放位置等
  - 如何组织动态链接库、可执行文件等多个不同目标
- 通过 `cmake` 命令，根据目标生成器与 `CMakeLists.txt`，生成项目构建系统文件
- 通过具体生成器命令，调用设置的编译器，生成目标

项目的配置值通常以 CMake 变量的形式保存，通过#link(<sec:字符串表示>)[读取] / #link(<sec:变量定义>)[修改]这些变量，即可查询 / 设置具体配置。

=== 基本项目配置

对于一个简单的基于 CMake 的 C++ 项目，通常有如下的项目配置流程

==== 项目基本信息 <sec:项目基本信息>

项目为 CMake 中一个最小的构建单元，项目除了与其他项目共享配置
- 可以有自己内部的私有配置、源码与生成文件夹
- 一个顶层 `CMakeLists.txt` 项目下可以管理多个子项目，用于管理总项目的不同部分
- 关于项目关于更多参见#link(<sec:多项目配置>)[多项目配置]

通过命令 `project(<name> [VERSION <ver>] [LANGUAGES <lang>])` 创建项目
- `name` 项目名称字符串
- `ver` 项目版本号的字符串
- `lang` 项目需要的语言，多个语言时输入字符串，经过此设置后 CMake 将检查对应语言的编译器 `CMAKE_XXX_COMPILER` 是否存在。主要语言的表示字符串有：
  - `C` C 语言（默认）
  - `CXX` C++（默认）
  - `ASM` 汇编语言
- 每个 `CMakeLists.txt` 的第一个命令必须是 `project`，该命令也决定了当前脚本所在的项目作用域

通过变量 `CMAKE_BUILD_TYPE` 查询与设置项目的构建类型，通常有以下构建类型
- `Debug` 调试版本，对于 g++ 将启用编译选项 `-g`，默认采用此设置
- `Release` 发行版本，对于 g++ 将启用编译选项 `-O3 -DNDEBUG`
- `RelWithDebugInfo` 保存调试信息的发行版本，对于 g++ 将启用编译选项 `-O2 -g`
- `MinSizeRel` 最小体积发行版本，对于 g++ 将启用编译选项 `-Os -DNDEBUG`
- 项目的构建类型是项目的基本属性之一，所有项目都将共享该属性，且通常通过命令传递而不是在脚本中设置。

通过设置变量 `CMAKE_XXX_STANDARD` 查询与设置项目中语言 `XXX` 标准要求，标准即一个数字 
- 对于 `CXX`（C++）常用的有 `98`，`11`，`17` 等
- 对于 `C` 常用的有 `98`，`11`
- 之后还要设置变量 `CMAKE_CXX_STANDARD_REQUIRED` 为 `ON`，开启要求

可使用以下变量查询项目的基本信息
- `PROJECT_NAME` 项目名称
- `PROJECT_SOURCE_DIR` 项目源文件目录，即 `CMakeLists.txt` 所在目录
- `PROJECT_BINARY_DIR` 项目构建系统文件目录
  - 对于顶层项目，一般即源文件目录下的 `build` 目录
  - 对于子项目，一般即 `build/<项目名>`

==== 定义生成目标

使用命令 `add_executable(<target> <src>)` 生成目标可执行文件
- `target` 目标名称，将生成目标名称的可执行文件（同平台下不需要后缀）
- `src` 用于生成目标的源文件列表

使用命令 `add_library(<target> <生成类型> <src>)` 生成目标动态 / 静态库
- `target` 目标名称，将生成目标名称的动态 / 静态库（同平台下不需要后缀）
- `src` 用于生成目标的源文件列表
- `生成类型` 主要有 `SHARE` 动态库与 `STATIC` 静态库两种

通过命令 `add_custom_target(<target> COMMAND <cmd1> COMMAND <cmd2> ...)` 创建自定义目标  
- `target` 自定义目标名称
- `cmd` 执行的 CMake 命令，与#link(<sec:目标生成过程命令>)[目标生成过程命令]中的相同
- 通过自定义目标，可将 CMake 用于构建其他语言的项目，或将一些常用操作封装为伪目标，并在需要时执行

根据一个项目对应一个目标的原则，习惯上使用项目名作为目标名，即 `${PROJECT_NAME}` 代替具体的目标名 `target`

对于源文件列表，可以结合#link(<sec:文件查找>)[文件查找]命令快速获取特定目录下的所有源文件，保存到变量 `SOURCE_FILE` 中

```cmake
file(
  GLOB SOURCE_FILE 
  "${PROJECT_SOURCE_DIR}/src/*.cpp" 
  "${PROJECT_SOURCE_DIR}/src/*.c"
  # 对于 QT 等部分项目需要读取头文件
  "${PROJECT_SOURCE_DIR}/src/*.h" 
)
```

==== 设置目标编译选项

设置目标选项时，通常需要使用特定的命令，不建议直接设置变量。这些命令中有如下的通用参数
- `target` 即目标名，需要先定义目标后才能设置目标的选项
- `domain` 目标依赖传递参数，仅有单个目标时取 `PRIVATE` 即可，对于多目标参见#link(<sec:多项目配置>)[多项目配置]

对于包含目录、链接库等编译选项选项，可通过以下命令设置
- 设置目标包含目录 `target_include_directories(<target> [domain1] <dir1> ...)` 
  - 一般即 `${PROJECT_SOURCE_DIR}/include`
- 设置目标引用库目录 `target_link_directories(<target> [domain1] <path1>)`
  - 该命令不起链接效果，仅设置 `target_link_libraries` 的搜索目录
- 设置目标引用库 `target_link_libraries(<target> [domain1] <path1>)`
  - 相当于 g++ 的 `l` 选项
- 设置目标预定义宏 `target_compile_definitions(<target> [domain1] <def1> ...)`
  - 相当于 g++ 的 `D` 选项，直接传入宏名称即可
  - 通过 `<DEF_NAME>=<VAL>` 设置宏的值
- 设置目标编译选项 `target_compile_options(<target> [domain1] <opt1> ...)`
  - 直接传递给编译器，与具体使用的编译器有关
  - 一般不建议主动设置编译选项，而是让 CMake 决定
- 设置目标链接选项 `target_link_options(<target> [domain1] <opt1> ...)`
  - 同编译选项设置，一般不建议主动设置

目标的内部属性需要使用如下的命令设置\ 
`set_target_properties(<target> PROPERTIES <property1> <value1> ...)`
- `value` 属性值字符串
- `property` 属性名称，常用的有
  - `XXX_OUTPUT_DIRECTORY_YYY` 目标存放目录
    - `XXX` 表示目标类型，有：`RUNTIME` 可执行文件；`ARCHIVE` 静态库；`LIBRARY` 动态库
    - `YYY` 表示构建类型，即可用构建类型大写
  - `OUTPUT_NAME` 输出目标的文件名，默认即目标名
  - `VERSION` 目标版本号

通过查看 `build` 下的文件 `compile_commands.json` 可查看 CMake 生成的最终编译命令用于检查（需要开启设置 `set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)`）。

例如以下命令控制 `Release` 与 `Debug` 版本的目标存放到不同文件夹中

```cmake
set_target_properties(${PROJECT_NAME} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${PROJECT_BINARY_DIR}/bin/Debug"
  RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_BINARY_DIR}/bin/Release"
)
```

==== 简单项目模板

基于以上配置流程，可得到如下的典型 C++ 项目的 `CMakeLists.txt` 模板

```cmake
cmake_minimum_required(VERSION 3.10)
PROJECT(MY_PROJECT CXX)

# 获取所有 .cpp 源文件
FILE(GLOB SRC_FILES "${PROJECT_SOURCE_DIR}/src/*.cpp")
# 创建目标
add_executable(${PROJECT_NAME} ${SRC_FILES})

# 包含头文件
target_include_directories(
  ${PROJECT_NAME} PRIVATE 
  "${PROJECT_SOURCE_DIR}/include"
)
# 将目标保存到 bin 文件夹下
set(TRAGET_OUPUT_DIRECTORY_DEBUG "${PROJECT_BINARY_DIR}/bin/Debug")
set(TRAGET_OUPUT_DIRECTORY_RELEASE "${PROJECT_BINARY_DIR}/bin/Release")
set_target_properties(${PROJECT_NAME} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${TRAGET_OUPUT_DIRECTORY_DEBUG}"
  RUNTIME_OUTPUT_DIRECTORY_RELEASE "${TRAGET_OUPUT_DIRECTORY_RELEASE}"
)
```

=== 其他配置介绍

==== 目标生成过程命令 <sec:目标生成过程命令>

虽然 CMake 仅负责生成项目构建系统文件，但为了在目标生成的各个阶段，还希望能执行特定的命令行指令，用于生成阶段输出信息、复制必要的动态链接库等功能。此时可通过命令设置目标生成过程中，执行的命令行指令。

以下命令设置在目标构建的不同阶段执行自定义操作：\ `add_custom_command(TARGET <target> <构建阶段> COMMAND <cmd1> COMMAND <cmd2> ...)` 
- `target` 配置的目标名称
- `构建阶段` 有如下执行命令的构建阶段
  - `PRE_BUILD` 编译前执行
  - `PRE_LINK` 链接前执行
  - `POST_BUILD` 生成后执行，例如将生成的库移动到测试环境
- `cmd` 执行的当前系统的命令行命令
  - 对于命令中的参数直接用空格分割，引号仅由于包裹参数  
  - 多条命令通过 `COMMAND` 分隔    
  - 为了保证 CMake 项目的跨平台特性，在执行命令时推荐通过变量 `CMAKE_COMMAND` 引用 CMake 解释器执行操作，而非一般命令行指令

通过 `cmake` 命令的 `-E <指令内容>` 选项可执行简单的命令行操作，常用有
- `copy <file1> [file2 ...] <dest>` 将文件 `file` 复制到目录 `dest` 下
- `rename <old> <new>` 重命名 / 移动文件
- `chdir <dir>` 修改所作目录即相对路径的根目录 
- `echo <string>` 向控制台输出内容
- 其他操作见#link("https://cmake.org/cmake/help/latest/manual/cmake.1.html#run-a-command-line-tool")[官方文档]

例如以下命令将在目标 `${PROJECT_NAME}` 构建完成时输出 `Build done` 
```cmake
add_custom_command(
  TARGET ${PROJECT_NAME} 
  POST_BUILD COMMAND
  ${CMAKE_COMMAND} -E echo Build done
)
```

==== 多项目配置 <sec:多项目配置>

命令 `add_subdirectory(<source_dir> [binary_dir])` 添加子项目
- `source_dir` 子项目源文件目录，要保证该路径下存在一个用于生成子项目的 `CMakeLists.txt` 文件
- `binary_dir` 生成文件存放目录
  - 默认为顶层项目源文件目录下的 `build/<项目名>`
  - 一般仅引用外部项目时需要，此时需要给出该项目的生成文件存放目录
- 使用多层级结构时，主项目中只需要使用此命令添加所有子项目即可，通过生成不同目标以生成特定子项目

对于子项目内部
- 子项目依然需要 #link(<sec:项目基本信息>)[project] 命令指定项目的基本信息
- 子项目能继承主项目的所有设置，同时具有独立的变量空间与#link(<sec:项目基本信息>)[项目信息]
- 基于一个项目管理一个目标的原则，多目标的工程应当有多个子项目
- 关于子项目间的引用更多注意事项参见#link("https://blog.csdn.net/lcmssd/article/details/64732528")[博客]

使用多项目结构后，就需要关注依赖传递参数 `domain` 的取值。假设项目中存在类似引用关系 `A.so->B.so->C.so`，其中 A，B，C 为项目中从外到内的三个层级。以下说明中，B 在情况符合时需要启用对应的设置，A 与 C 则按情况确定，对于单层次项目，使用 `PRIVATE` 即可
- `PRIVATE` 
  - 表明 A 完全不会使用到来自 C 的任何源文件（C.cpp）或接口（C.h）
  - 此时要求 B 中的公开接口（B.h）不包含来自 C 的接口（C.h）
- `INTERFACE` 
  - 表明 A 完全使用到来自 C 的接口（C.h)，但是 B 没有使用到 C 的源文件（C.cpp)，仅通过其接口将 C 的暴露给 A
  - 此时要求 B 中的公开接口（B.h）包含来自 C 的接口（C.h)，但其源文件没有使用 C 提供的功能
- `PUBLIC`
  - 即一般情况，B 与 A 均同时在其源文件内使用了 C 的接口

==== 项目配置技巧 <sec:项目配置技巧>

强制刷新项目

=== CMake 命令

==== 基于命令行选项生成目标 <sec:基于命令行选项生成目标>

参考文章 #link("https://blog.csdn.net/u014183456/article/details/124512715")

完成 CMakeLists.txt 的编写后，还需要通过 cmake 命令完成项目系统文件的构建：\   
`cmake <CMakeLists.txt 目录> [-B...] [-D...] [-G...]`
- `-B` 指定 CMake 构建过程中的 Build 目录，一般即 `CMakeLists.txt` 所在目录下的 `build` 文件夹
- `-D` 定义缓存变量，部分选项仅有通过 `-D` 选项设置才能正常生效如，例如   
  - `CMAKE_BUILD_TYPE` 指定构建方法
  - `CMAKE_<LANG>_COMPILE` 指定编译器，对于 C++ 可选的有：`cl` MSVC 编译器；`gcc` G++ 编译器；`clang` Clang 编译器；特定编译器使用具体路径
  - `CMAKE_TOOLCHAIN_FILE` 指定工具链路径（通常与如 #link(<sec:VCPKG_项目管理与构建>)[vcpkg] 等工具集成时使用）
- `-G` 具体指定生成器，常用有
  - `Ninja` 速度最快，需要安装（Linux 下通过 `apt` 安装，Windows 下通过 `pip` 或 `conda` 安装）  - `Visual Studio 17 2022` 生成 Visual Studio 2022 项目
  - `MinGW Makefiles` 用于 Windows 下的 MinGW

虽然 CMake 无法具体直接生成目标，但可通过以下 cmake 命令完成调用相应的生成器完成目标生成：\ 
`cmake --build <build 目录> --target <生成目标>`

==== 基于配置文件生成目标 <sec:基于配置文件生成目标>

直接使用命令行构建项目系统文件以及生成目标时，通常需要传递大量参数，不易于配置，更推荐使用预设功能设置这些。

预设即通过与顶层 `CMakeLists.txt` 同目录的两个 `json` 文件指定#link(<sec:基于命令行选项生成目标>)[基于命令行选项生成目标]，两个文件格式完全相同，仅名称与功能不同
- `CMakePresets.json` 基本预设配置文件，规定了项目推荐的生成器、编译器等配置，通常与项目打包在一起
- `CMakeUserPresets.json` 用户预设配置文件，通过 `inherits` 属性引用 `CMakePresets.json` 中的基本预设，补充预设缺少的工具路径环境变量等具体信息

`CMakeUserPresets.json` 文件中包含以下键
- `version` 预设格式版本，一般取 2 即可
- `configurePresets` 构建阶段预设，对应构建项目系统文件阶段的 `cmake`，值为以具体预设键值对为元素的列表，其中键值对常用键有
  - `name` 预设名称
  - `generator` 目标生成器，字符串，对应 `cmake` 的 `-G` 选项
  - `binaryDir` 构建文件目录，字符串，对应 `cmake` 的 `-B` 选项
  - `cacheVariables` 缓存变量定义，键值对，对应 `cmake` 的 `-D` 选项，其中键为缓存变量名、值为变量值
  - `environment` 构建时环境变量，使用键值对表示
  - `hidden` 是否隐藏预设，布尔值，取 `true` 时用于供其他预设引用的基础预设
  - `inherits` 引用预设名，字符串
  - `description` 预设描述
- `buildPresets` 生成阶段预设，对应目标生成阶段的 `cmake --build`
  - `configurePreset` 生成目标前构建阶段采用的构建预设
  - `configuration` 类似 #link(<sec:项目基本信息>)[CMAKE_BUILD_TYPE] 的构建配置，取值相同（仅用于 `Visual Studio` 等多配置生成器，建议同时设置）
  - `environment` 生成时环境变量，使用键值对表示

`CMakeUserPresets.json` 文件中表示值是
- 字符串中可以使用#link(<sec:字符串表示>)[字符串表示]中 `${val}`，`$env{val}` 等语法）
- `json` 列表能自动转化为 CMake 列表

在 `cmake` 命令中使用预设时
- 进入 `CMakeUserPresets.json` 文件所在目录
- 通过选项 `--preset <预设名>` 即可引入对应预设的设置

==== VSCODE 集成

在 VSCODE 中，可安装 CMake-Tools 插件实现 CMake 的 IDE 支持

对于一般模式，进入左侧工具栏的 `CMake` 标签页
- 编译器选择：#bl(1)[配置]下拉栏的第一项
- 构建类型选择：#bl(1)[配置]下拉栏的第二项
- 在 `CMakeLists.txt` 文件使用 #bl(1)[构建] 下拉栏右侧按钮或快捷键 #bl(0)[Ctrl] #bl(0)[S] 保存自动触发构建系统文件生成（需要生成构建系统文件后，IDE 支持才会生效）
- #bl(1)[生成]、#bl(1)[启动]、#bl(1)[调试] 下拉栏中选择对应的目标、点击右侧按钮执行对应操作
- #bl(1)[项目状态] 下拉栏右侧按钮 #bl(2)[删除缓存并重新配置] 可快速#link(<sec:项目配置技巧>)[强制刷新项目]
- 缓存变量通过插件设置 `Cmake: Configure Args` 添加，建议作为工作区设置
- 生成器通过插件设置 `Cmake: Generator` 选择，建议作为工作区设置

对于预设模式
- 首先需要在项目目录下创建有效的预设文件 `CMakePresets.json` 与 `CMakeUserPresets.json`，然后重启 VSCODE，可以参考 #link(<sec:VCPKG_项目管理与构建>)[VCPKG] 的模板
- 进入左侧工具栏的 `CMake` 标签页，在#bl(1)[配置]、#bl(1)[生成] 下拉栏选择对应的构建与生成预设（生成预设需要使用对应构建预设）
- 后续使用与一般模式相同

常见问题
- vscode 中使用 MSBUILD 等生成器时构建类型在执行生成命令时确定，因此变量 `CMAKE_BUILD_TYPE` 为空。可以勾选插件选项 `Set Build Type On Multi Config` 解决。
- 对于新添加的模块在代码检查中可能无法正确识别
    - 先执行 VScode 命令 `C/C++: Log Diagnostic`（通过 <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>P</kbd> 唤出） 检查 C/C++ 插件的包含目录
    - 如果没有所需模块，检查模块是否存在于 vcpkg 的 `build/vcpkg_install/<triple>/include` 中
    - 存在的话，执行 VScode 命令 `CMake: Configuration` 并重启刷新配置

== VCPKG 包管理工具

=== 基本使用

==== VCPKG 安装

可通过以下步骤安装 VCPKG
- 从地址 `https://github.com/microsoft/vcpkg` 克隆 vcpkg 仓库到本地文件夹
- 进入 vcpkg 目录，运行安装程序 
  - Windows `bootstrap-vcpkg.bat`
  - Linux `bootstrap-vcpkg.sh`
- 将 vcpkg 根目录添加到 `PATH` 环境变量与 `VCPKG_ROOT` 环境变量，检查命令 `vcpkg` 是否可运行
- 在 vcpkg 根目录运行 `git pull` 即可更新 vcpkg

==== VCPKG 项目管理与构建 <sec:VCPKG_项目管理与构建>

在项目的根目录下，通过如下命令管理 VCPKG 项目
- `vcpkg --application new` 可初始化项目的 vcpkg 功能，该命令将生成记录项目使用包信息的 `vcpkg.json` 与 `vcpkg-configuration.json`
- `vcpkg list <包名>` 查询指定包，VCPKG 中通常会使用 `<包名>[特性]` 的结构表示包
  - 仅安装基础包时，不需要特性部分
  - 需要多个特性时，可用 `,` 分隔
- `vcpkg add port <包>` 将指定的包添加到项目中
- 需要删除包时，可直接修改 `vcpkg.json` 文件，删除对应的键值对即可
- VCPKG 的包安装发生在 CMake 的构建系统文件生成阶段，此时仅记录使用的包

还需要将 VCPKG 与 CMake 的项目构建过程连接起来，才能使 VCPKG 发挥作用，为此需要设置两个#link(<sec:缓存变量>)[缓存变量]
- `CMAKE_TOOLCHAIN_FILE` VCPKG 工具链文件，一般即\ `$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake`
- `VCPKG_TARGET_TRIPLET` VCPKG 包构建方法，需要与项目构建方法对应，常用有
  - `x64-windows` 使用 64 位架构的 MSVC 编译器，使用动态方式链接包
  - `x64-windows-static` 使用 64 位架构的 MSVC 编译器，使用静态方式链接包，使用时需要以下设置保证编译通过
    - `set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")`
    - `set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")`
- 这两个缓存变量需要在项目构建前设置，否则要#link(<sec:项目配置技巧>)[强制刷新项目]保证其正确载入
- 官方建议通过#link(<sec:基于配置文件生成目标>)[预设的方式]导入这两个变量，例如以下预设模板用于 Ninja + MSVC 2022 + VCPKG 项目

`CMakePresets.json` 文件（使用时需要删除注释）
```json
{
    "version": 2,
    "configurePresets": [
        {
            "name": "vcpkg_ninja_base",
            "hidden": true,
            "generator": "Ninja Multi-Config",
            "binaryDir": "${sourceDir}/build",
            // 用于 MSVC 编译器指定架构
            "architecture": {
                "value": "x64",
                "strategy": "external"
            },
            "toolset": {
                "value": "host=x64",
                "strategy": "external"
            },
            
            "cacheVariables": {
                "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake",
                // 使用静态链接
                "VCPKG_TARGET_TRIPLET": "x64-windows-static",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "TRUE",
                "CMAKE_CXX_COMPILER": "cl"
            }
        }
    ]
}
```

`CMakeUserPresets.json` 文件
```json
{
  "version": 2,
  "configurePresets": [
    {
      "name": "vcpkg_ninja_release",
      "inherits": "vcpkg_ninja_base",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    },
    {
      "name": "vcpkg_ninja_debug",
      "description": "",
      "inherits": "vcpkg_ninja_base",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "vcpkg_ninja_release",
      "configurePreset": "vcpkg_ninja_release",
      "configuration": "Release"
    },
    {
      "name": "vcpkg_ninja_debug",
      "configurePreset": "vcpkg_ninja_debug",
      "configuration": "Debug"
    }
  ]
}
```

最后还需要将包添加到 `CMakeLists.txt` 中，具体添加方法可在构建系统文件生成后的\ `build/vcpkg-manifest-install.log` 找到，或查看#link(<sec:包安装说明>)[笔记说明]，通常为以下两条命令
- `find_package(<包名> REQUIRED)` 将包添加到项目中，通常在项目顶层使用 
- `target_link_libraries(${PROJECT_NAME} PRIVATE <包名>::<特性名>)` 将目标链接到具体包，通常在定义了目标后使用
- 具体还需看包安装后输出的说明

=== 包安装说明 <sec:包安装说明>

==== Qt

- 不同 Qt 包对应不同版本，包 `qtbase` 对应 Qt6
- 调用 Qt 相关头文件时，要使用 `<模块名>/<类名>` 的方式，例如\ `#include <QtWidgets/QApplication>`
- 没有特殊情况时，仅需引用 `QtCore, QtGui, QtWidgets` 三个模块
- 动态链接模式下，还需要使用#link(<sec:目标生成过程命令>)[生成结束后命令]将以下文件夹复制到可执行文件目录下\ `build/vcpkg_installed/x64-windows[/debug]/Qt6/plugins/platforms` 
- 使用 QT 时，自定义组件的类定义与类声明必须分离，且 `.cpp/.h` 文件均需要作为目标的源文件

例如以下代码链接必要的模块，并且在构建后自动复制 `platforms` 文件夹

```cmake

# 引用必要模块
find_package(Qt6Core CONFIG REQUIRED)
find_package(Qt6Gui CONFIG REQUIRED)
find_package(Qt6Widgets CONFIG REQUIRED)
# 使用 QT 时需要开启以下三个选项
set(CMAKE_AUTOUIC ON) # 启用自动UI编译 (AUTOUIC)
set(CMAKE_AUTOMOC ON) # 启用自动元对象编译 (AUTOMOC)
set(CMAKE_AUTORCC ON) # 启用自动资源编译 (AUTORCC)

# 构建目标
...
# 获取所有 .cpp 源文件
FILE(GLOB SRC_FILES "${PROJECT_SOURCE_DIR}/src/*.cpp")
# 获取所有 .h 源文件
FILE(GLOB INCLUDE_FILES "${PROJECT_SOURCE_DIR}/include/*.h")
# 创建目标 (QT 需要将头文件与源文件全部作为目标的源文件)
add_executable(<目标名> "${SRC_FILES};${INCLUDE_FILES}")
# 链接必要的模块
target_link_libraries(<目标名> PRIVATE Qt6::Core Qt6::Gui Qt6::Widgets)

# 根据目标复制 platforms 文件夹（用于动态链接的 windows-x64，对于 Ninja 可执行文件位于 ${CMAKE_BINARY_DIR} 中）
if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    add_custom_command(
        TARGET <目标名> POST_BUILD COMMAND ${CMAKE_COMMAND} -E 
        copy_directory 
        # $<TARGET_FILE_DIR:<目标名>> 为生成时表达式, 适用于基于 CMake tools 插件生成
        "${CMAKE_BINARY_DIR}/vcpkg_installed/x64-windows/debug/Qt6/plugins/platforms"
        "$<TARGET_FILE_DIR:<目标名>>/platforms"
    )
else()
    add_custom_command(
        TARGET <目标名> POST_BUILD COMMAND ${CMAKE_COMMAND} -E 
        copy_directory 
        "${CMAKE_BINARY_DIR}/vcpkg_installed/x64-windows/Qt6/plugins/platforms"
        "$<TARGET_FILE_DIR:<目标名>>/platforms"
    )
endif()
```

==== OpenCV

- 推荐中要求设定变量 `OpenCV_DIR` 的值，实际可不进行设置
- 链接与包含 `OpenCV` 相关库没有说明，可参考以下代码

```cmake
target_include_directories(TEST1 PRIVATE ${OpenCV_INCLUDE_DIRS})
target_link_libraries(TEST1 PRIVATE ${OpenCV_LIBS})
```

==== Boost

- 仅在#link("https://www.boost.org/doc/libs/1_79_0/more/getting_started/windows.html#header-only-libraries")[此列表]中的库需要按推荐的方式设置，一般的库使用 `find_package(Boost REQUIRED)` 与 `target_link_libraries(${PROJECT_NAME} PRIVATE Boost::boost)` 即可
- 对于 `Boost::asio`，在 Windows 下还需要额外链接库\ `target_link_libraries(${PROJECT_NAME} PRIVATE ws2_32.lib PRIVATE mswsock.lib)`

==== pybind11

对于 Python 与 C++ 的混合编程，推荐使用 pybind11 而不使用 Boost::python
- 首先要定义变量 `Python_ROOT_DIR`，变量值为要求的 python 环境中的解释器程序所在的根目录（可通过在要求的 python 环境中执行 `print(sys.executable)` 具体确定 `Python_ROOT_DIR`，该变量的本质为辅助 CMake 找到 python，其他寻找方法见#link("https://cmake.org/cmake/help/latest/module/FindPython.html#hints)")[官方文档]
- 确定变量后，需要通过#link(<sec:目标生成过程命令>)[生成结束后命令]将 `Python_ROOT_DIR` 下的 `pythonXXX.dll` 复制到生成目录（`PROJECT_BINARY_DIR`）下
- 注意，DEBUG 模式下，需要使用 `pythonXXX_d.dll` 版本的动态链接库，若没有则推荐设置构建类型（CMAKE_BUILD_TYPE）为 RelWithDebugInfo
- 通过寻找 python 与导入 pybind11
  - `find_package(Python COMPONENTS Interpreter Development)`  
  - `find_package(pybind11 CONFIG REQUIRED)` 
- 对于不同的混合方式需要采用以下目标
    - 通过 C++ 调用 Python 时，除了生成可执行文件\ `target_link_libraries(<可执行文件目标名> PRIVATE pybind11::embed)`
    - 生成供 Python 调用的 C++ 库时，则使用命令\ `pybind11_add_module(<模块名> MODULE <源文件>)` 生成 python 模块文件 `模块名.调用信息.pyd`（自动生成，注意模块名）

自动化项目时，可能会用到以下实用变量
- `PYBIND11_PYTHON_EXECUTABLE_LAST` 项目所用环境对应的 python 解释器，可用此解释器执行脚本保证环境匹配
- `PYTHON_MODULE_EXTENSION` 对应平台的 python 模块后缀，可用此获取生成的模块文件

对于 C++ 调用 Python 的配置示例如下
```cmake
cmake_minimum_required(VERSION 3.10)
project(pybind_test)

# 需要手动确认的变量
# 解释器程序根目录
set(Python_ROOT_DIR "D:/miniconda3/envs/playground")
# python 版本
set(PYTHON_DLL_VERSION "312")

# 生成三个重要的变量
set(PYTHON_DLL "python${PYTHON_DLL_VERSION}.dll")
file(COPY_FILE "${Python_ROOT_DIR}/python${PYTHON_DLL_VERSION}.dll" "${PROJECT_BINARY_DIR}/python${PYTHON_DLL_VERSION}.dll")

find_package(Python COMPONENTS Interpreter Development)
find_package(pybind11 CONFIG REQUIRED)

file(GLOB SOURCE_FILE ./src/*.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILE})
target_link_libraries(${PROJECT_NAME} PRIVATE pybind11::embed)
# 生成供 C++ 代码调用的宏
target_compile_definitions(${PROJECT_NAME}
    PRIVATE -DPYTHON_HOME_PUTENV_STR="PYTHONHOME=${Python_ROOT_DIR}"
    # 用于调用 python 时，引用的动态链接库文件夹
    PRIVATE -DPYTHON_ADD_DLL_DIR="${Python_ROOT_DIR}/Library/bin"
)
```

=== 其他说明

==== 清理 VCPKG

vcpkg 在本地构建时会占用大量空间，可以删除 vcpkg 安装目录中的以下文件夹释放空间
- `buildtrees` 构建中间文件（占用空间最大）
- `downloads` 下载源代码

