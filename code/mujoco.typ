#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Mujoco 笔记")

#import "/utility/widget.typ": *

= Mujoco 笔记

== 基本使用

=== 场景加载与访问

Mujoco 中，使用类 `mujoco.MjModel` 管理仿真场景，通过创建仿真环境场景即可启动仿真环境。场景中的仿真参数、各个物体信息均使用 #link("https://docs.mujoco.cn/en/stable/modeling.html")[MJCF] 文件以 `xml` 格式描述，加载并编译 MJCF 文件即可创建场景。

例如以下代码加载了一个 mujoco 场景

```python
import mujoco
from matplotlib import pyplot as plt

xml = """
<mujoco>
  <worldbody>
    <light name="top" pos="0 0 1"/>
    <geom name="red_box" type="box" size=".2 .2 .2" rgba="1 0 0 1"/>
    <geom name="green_sphere" pos=".2 .2 .2" size=".1" rgba="0 1 0 1"/>
  </worldbody>
</mujoco>
"""
```

类 `MjModel` 的静态方法 `mujoco.MjModel.from_xml_string(xml)` 用于从字符串形式的 MJCF 文件加载场景。
- 参数 `xml`：MJCF 文件字符串
- 返回值：`MjModel` 对象

对于场景中的简单几何体（MJCF 文件标签为 `geom`，其他物体访问方式类似）
- 通过对象的属性 `MjModel.ngeom` 获取场景中几何体数量
- 通过对象的方法 `MjModel.geom(...)` 获取场景中指定几何体信息
  - 参数可以是整数表示几何体 id，或字符串表示几何体名称（即 MJCF 的 `name` 属性）
  - 返回值为一个 `MjModelGeomViews` 对象，可以获取该物体在创建场景时的信息（只读），常用的有：
    - `name`：字符串，几何体名称
    - `id`：整数，几何体 id
    - `size`：三元素 Numpy 数组，几何体尺寸
    - `type`：整数，几何体类型

几何体 id 通常按顺序编号，因此以下代码遍历整个场景所有几何体名称

```python
... # 接上方代码块

for i in range(model.ngeom):
    print(model.geom(i).name)
```

`MjModel` 对象存储的是场景的静态信息，场景的动态信息则由类 `MjData` 对象存储与管理。`MjData` 对象可直接通过 `MjModel` 对象创建。

类 `MjData` 有构造函数 `mujoco.MjData(arg0)`
- 参数 `arg0`：被管理的 `MjModel` 对象

对于场景中的简单几何体，`MjData` 对象同样有方法 `MjData.geom(...)`，从返回的 `MjDataGeomViews` 对象获取指定名称或 id 物体的位姿信息（该信息将随几何体特性有所改变），一般固定物体只有位置与姿态：
- `xmat`：9 元素 Numpy 数组，几何体姿态的旋转矩阵表示
- `xpos`：3 元素 Numpy 数组，几何体位置的旋转矩阵表示

直接调用 `MjData` 对象无法得到正确的信息，因此此时场景虽然被读取了但还没有实际加载，要进行下一时间步的仿真后才能得到当前时间步的动态信息。

方法 `mujoco.mj_step(m, d, n_step)` 用于仿真计算下一时间步
- 参数 `m`：`MjModel` 对象，场景静态信息
- 参数 `d`：`MjData` 对象，场景动态信息
- 参数 `n_step = 1`：整数，计算后续多个时间步

=== 仿真与场景渲染

== MJCF 文件描述

=== 基本结构

MJCF 文件中
- 以 `mujoco` 标签为顶层标签，各级标签通过自身属性与子标签描述特定属性
- 二级标签定义场景基本信息

- 多组属性使用字符串表示，每个元素以空格分隔

=== 物体 body

与 URDF 不同，MJCF 通过 XML 描述的物体间的树状结构表示物体间的连接。以四轮小车为例：父节点为小车底盘，小车四个轮子则作为子节点（即底盘物体的子标签），底盘与轮子间的旋转关系则通过轮子的关节属性描述（关节子标签）。

其中二级子标签 `worldbody` 也属于一种特殊物体，表示基座物体，但不具有惯性（`inertial` 标签）与相对上一物体的关节（`joint` 标签），该标签为场景中一切物体的基础

以下为常用的描述物体属性的子标签（关于标签具体信息参见#link("https://docs.mujoco.cn/en/stable/XMLreference.html#world-body-r")[文档]）
- `body` 本身的也具有属性，常用的有
  - `name`：物体名称
  - `pos, euler`：物体相对父物体坐标系的位置与姿态
- `geom` 用于描述物体的形状，可以存在多个表示物体由多个几何体拼接得到，常用属性有
  - `name`：几何体名称
  - `type`：几何体类型，常用有：`sphere` 球（默认）、`box` 长方体、`cylinder` 圆柱体
  - `size`：几何体尺寸，具体见文档
  - `pos, euler`：几何体相对所在物体坐标系的位置与姿态
  - `mass`：几何体质量，用于推断物体惯性
  - `rgba`：几何体颜色，使用四个浮点数的元组表示
- `joint` 用于描述物体与其父物体之间的关节连接，如果未定义关节则认为是与父物体相固连，常用属性有
  - `name`：关节名称
  - `type`：关节类型，常用有：`free` 无约束的自由物体、`slide` 滑动关节、`hinge` 旋转关节（默认）
  - `pos`：关节坐标系相对所在物体坐标系的位置
  - `axis`：三元素元组，基于物体坐标系的关节的旋转轴或平移方向
  - `ref`：初始关节位置
- `light` 附加在物体上的灯光（通常附加在 `worldbody` 上作为固定光源）
  - `pos`：灯光点相对所在物体坐标系的位置
  - `axis`：三元素元组，基于物体坐标系的灯光方向
- `site` 不参与运动计算的形状，属性与 `geom` 基本一致，可用于指示坐标系或传感器位置等信息
- `camera` 附加在物体上的相机，位置描述与 `geom` 类似，相机内参表示参见文档

== 杂项

=== 类型检查与 IDE 提示 <type_hint_ide>

目前，Mujoco 仍有部分类缺少 .pyi 类型注释文件，可以下载非官方的 #link("https://github.com/I-am-Future/mujoco-stubs/tree/main/mujoco-stubs")[pyi 文件]放置在项目根目录临时解决（也可以参考此仓库提供的脚本自行生成）

