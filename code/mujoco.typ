#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Mujoco 笔记")

#import "/utility/widget.typ": *

= Mujoco 笔记

== 基本使用

=== MJCF 文件描述场景中的物体

Mujoco 场景中的仿真参数、各个物体信息均使用 #link("https://docs.mujoco.cn/en/stable/modeling.html")[MJCF] 文件以 `xml` 格式描述。MJCF 文件中以 `mujoco` 标签为顶层标签，各级标签通过自身属性与子标签描述特定属性，以二级标签定义场景基本信息，例如子标签 `worldbody` 用于定义场景中的物体。

MJCF 文件中属性的元组值使用字符串表示，每个元素以空格分隔

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

=== 场景加载与访问

Mujoco 中，使用类 `mujoco.MjModel` 管理仿真场景中的静态信息，即在 MJCF 文件中所描述的仿真场景参数、物体等信息，因此通过读取 MJCF 文件即可创建对应的 `MjModel` 对象并加载 mujoco 场景。

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

类 `MjModel` 的对象存储的是场景的静态信息，场景的动态信息则由类 `MjData` 的对象存储与管理。需要给定被管理的静态场景，即  `MjModel` 对象，才能创建 `MjData` 对象。

类 `MjData` 有构造函数 `mujoco.MjData(arg0)`
- 参数 `arg0`：`MjModel` 对象，被管理的静态场景 

对于场景中的简单几何体，`MjData` 对象同样有方法 `MjData.geom(...)`，从返回的 `MjDataGeomViews` 对象获取指定名称或 id 物体的位姿信息（该信息将随几何体或其他物体特性有所改变），一般固定物体只有位置与姿态：
- `xmat`：9 元素 Numpy 数组，几何体姿态的旋转矩阵表示
- `xpos`：3 元素 Numpy 数组，几何体位置的旋转矩阵表示

直接调用 `MjData` 对象无法得到正确的信息，因此此时场景虽然被读取了但还没有实际加载，要进行下一时间步的仿真后才能得到当前时间步的动态信息。

方法 `mujoco.mj_step(m, d, n_step)` 用于仿真计算下一时间步 <fun:mj_step>
- 参数 `m`：`MjModel` 对象，场景静态信息
- 参数 `d`：`MjData` 对象，场景动态信息
- 参数 `n_step = 1`：整数，计算后续多个时间步

=== 场景渲染

Mujoco 中场景的渲染与环境的仿真是相互分离的，且与一般仿真软件不同，Mujoco 默认不存在仿真环境窗口，即场景渲染本质为相机拍摄一张 RGB 图片。

为了创建场景渲染类 `mujoco.Renderer` 对象，同样需要给定被渲染场景的静态信息，即类 `MjModel` 对象。

类 `Renderer` 有构造函数 `mujoco.Renderer(model, height, width)`
- 参数 `model`：`MjModel` 对象，需要渲染的场景
- 参数 `height, width`：渲染图像的尺寸
- 为了保证资源正确释放（不需要渲染时需要调用 `close()` 方法释放资源），Mujoco 官方提供并推荐使用 `with` 语法管理（管理资源，即 `__enter__()` 方法的返回值为 `Renderer` 对象自己）

`Renderer` 对象通过如下方法渲染场景
- `update_scene(data, camera, scene_option)` 更新渲染场景
  - 参数 `data`：`MjData` 对象，创建对象的 `MjModel` 对象仅记录了静态信息，还需要 `MjData` 对象中的动态信息（使用前保证动态信息以经过 #link(<fun:mj_step>)[mj_step] 函数计算下一时刻的仿真）
  - 参数 `camera`：相机名称或 id（默认将使用自动创建的相机）
  - 参数 `scene_option`：`mujoco.MjvOption` 对象，用于渲染设置（具体使用见后）
- `render()` 获取最新渲染结果
  - 获取渲染结果前需要 `update_scene` 方法更新
  - 返回值：Numpy 数组，即渲染得到的 RGB 图片（形状为 (H, W, 3)）

渲染设置由类 `mujoco.MjvOption` 管理
- 类的构造函数没有参数可以直接创建
- 属性 `flags` 为一个图例元素渲染开关字典，开关通过枚举量 `mujoco.mjtVisFlag` 作为键索引，常用的有：
  - `mjtVisFlag.mjVIS_JOINT`：显示关节运动轴
  - `mjtVisFlag.mjVIS_CAMERA`：显示相机
  - `mjtVisFlag.mjVIS_CONTACTPOINT`：绘制接触点
  - `mjtVisFlag.mjVIS_CONTACTFORCE`：绘制接触力矢量
  - `mjtVisFlag.mjVIS_TRANSPARENT`：使物体透明以便于显示图例
- 属性 `frame` 以枚举量 `mujoco.mjtFrame` 为值，用于为特定类型的物体绘制坐标系，常用值有
  - `mjtFrame.mjFRAME_GEOM`：绘制简单几何体坐标系
  - `mjtFrame.mjFRAME_BODY`：绘制物体坐标系

例如以下例子用于渲染多帧图像得到一个视频
```python
xml = """
<mujoco>
  <worldbody>
    <light name="top" pos="0 0 1"/>
    <body name="box_and_sphere" euler="0 0 -30">
      <joint name="swing" type="hinge" axis="1 -1 0" pos="-.2 -.2 -.2"/>
      <geom name="red_box" type="box" size=".2 .2 .2" rgba="1 0 0 1"/>
      <geom name="green_sphere" pos=".2 .2 .2" size=".1" rgba="0 1 0 1"/>
    </body>
  </worldbody>
</mujoco>
"""

model = mujoco.MjModel.from_xml_string(xml)
data = mujoco.MjData(model)
scene_option = mujoco.MjvOption()
scene_option.frame = mujoco.mjtFrame.mjFRAME_BODY
scene_option.flags[mujoco.mjtVisFlag.mjVIS_JOINT] = True
scene_option.flags[mujoco.mjtVisFlag.mjVIS_TRANSPARENT] = True

LENGTH = 3
HZ = 60
fig, ax = plt.subplots()

with mujoco.Renderer(model) as renderer:
    assert isinstance(renderer, mujoco.Renderer)

    def draw_sim(cur_time: float):
      # data.time 获取仿真环境的真实时间
      # 仿真步长远小于帧率，通过 while 等待仿真计算
      while data.time < cur_time:
          mujoco.mj_step(model, data)

      # 仅绘制时渲染
      renderer.update_scene(data, scene_option = scene_option)
      pic = renderer.render()

      ax.clear()
      art = ax.imshow(pic)
      return [art]

    start = time.perf_counter()
    fa = FuncAnimation(fig, draw_sim, np.arange(0, LENGTH, 1 / HZ))
    fa.save("tmp.mp4", fps = HZ)
    print(f"use: {time.perf_counter() - start:.3f}s")
```

=== 仿真参数设置

仿真环境的参数设置同样在 MJCF 文件中，通过二级标签 `option` 的属性确定，常用的有：
- `timestep`：仿真步长，默认为 `0.002`
- `integrator`：积分器，默认为 `Euler`，关于推荐的积分器选择参见#link("https://docs.mujoco.cn/en/stable/computation/index.html#choosing-timestep-and-integrator")[官网]
  - `Euler`：兼容旧模型与用于 MJX
  - `implicitfast`：除了快速旋转的情况可能发散，最推荐
- `gravity`：三浮点数元组，重力加速度（默认有正确的重力加速度）

二级标签 `option` 还可以引入 `flag` 子标签，该子标签的属性确定开关型的仿真参数，如：
- `contact`：是否启用碰撞检测与约束
- `gravity`：是否启用重力

例如以下设置
```xml
<option timestep=".001" integrator="RK4">
  <flag contact="disable"/>
</option>
```

=== 动态修改仿真环境

== 机器人应用

=== 关节控制器模型

Mujoco 提供了一种广义的控制器。规定关节 $i$ 的输出的广义力 $p_i$、关节当前广义坐标 $l_i$ 及其导数 $dot(l)_i$、控制器控制量 $u_i$。规定控制器有控制量增益参数 $a_i$，偏置增益参数 $b_i^((0)),b_i^((1)),b_i^((2))$，则控制器的表达式如下：

$
  p_i=a_i u_i + b_i^((0)) + b_i^((1)) l_i + b_i^((2)) dot(l)_i
$

通过设置四个参数即可实现位置、速度、力等控制器。例如对于简单的 PD 位置控制器有：

$
  f=k_p (p_"tar"-p_"cur") - k_v v_"cur" arrow u_i=p_"tar",a_i=k_p,b_i^((1))=-k_p,b_i^((2))=-k_v
$

通过二级标签 `<actuator>` 下的自闭合子标签为关节添加控制器，常用的有
- `<general>` 广义控制器，通过属性设置控制器参数，常用的有
  - `name`：控制器名称
  - `joint`：附加控制器的关节名称
  - `gainprm`：浮点数，控制量增益参数 $a_i$
  - `biasprm`：三浮点数元组，三个偏置增益参数
  - `forcerange`：二浮点数元组，控制器力范围限制（默认无限制）
- `<position>` PD 位置控制器，其余参数与 `<general>` 相同，但可以直接给出控制参数
  - `kp`：浮点数，位置误差增益（默认为 1）
  - `kv`：浮点数，速度误差增益（默认为 0）
- `<velocity>` P 速度控制器，其余参数与 `<general>` 相同，但可以直接给出控制参数
  - `kv`：浮点数，速度误差增益（默认为 1）

=== 机器人关节位置控制



=== 相机图像获取

== 杂项

=== 类型检查与 IDE 提示 <type_hint_ide>

目前，Mujoco 仍有部分类缺少 .pyi 类型注释文件，可以下载非官方的 #link("https://github.com/I-am-Future/mujoco-stubs/tree/main/mujoco-stubs")[pyi 文件]放置在项目根目录临时解决（也可以参考此仓库提供的脚本自行生成）

