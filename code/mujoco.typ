#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Mujoco 笔记")

#import "/utility/widget.typ": *

= Mujoco 笔记

== Mujoco 场景建模

Mujoco 场景中的仿真参数、各个物体信息均使用 #link("https://docs.mujoco.cn/en/stable/modeling.html")[MJCF] 文件以 `xml` 格式描述。MJCF 文件中以 `mujoco` 标签为顶层标签，各级标签通过自身属性与子标签描述特定属性，以二级标签定义场景基本信息。

MJCF 文件的属性中
- 元组值使用字符串表示，每个元素以空格分隔
- 布尔值使用字符串 `true` 与 `false`

=== 场景物体与机器人定义 <sec:body_define>

与 URDF 不同，MJCF 通过 XML 描述的物体间的树状结构表示物体间的连接，并在子节点物体中描述其与父节点物体间的关节。以四轮小车为例：父节点为小车底盘，小车四个轮子则作为子节点（即底盘物体的子标签），底盘与轮子间的旋转关系则通过轮子的关节属性描述（关节子标签）。

其中以二级子标签 `worldbody` 作为树状结构的唯一根节点，表示基座物体，场景中所有其他物体都在该基座物体的基础上定义。基座物体但不具有惯性（`inertial` 标签）与相对上一物体的关节（`joint` 标签）。

因此机器人即在 `worldbody` 下某个子树定义一个以关节相连的多个物体

以下为常用的描述物体属性的子标签（关于标签具体信息参见#link("https://docs.mujoco.cn/en/stable/XMLreference.html#world-body-r")[文档]）
- `body` 本身的也具有属性，常用的有
  - `name`：物体名称（名称必须唯一，对于复杂场景可用 `类别/具体名称` 的方式防止冲突）
  - `pos`：物体相对父物体坐标系的位置
  - `euler`：物体相对父物体坐标系的欧拉角姿态，采用 `XYZ` 顺序，默认单位为角度（设置 `<compiler angle="radian">` 将使单位变为弧度）
  - `quat`：物体相对父物体坐标系的四元数姿态，采用 `XYZW` 规范（与 `euler` 参数互斥，规定其中一个即可，关于其他姿态参数参见#link("https://docs.mujoco.cn/en/stable/modeling.html#frame-orientations")[文档]）
  - `mocap`：布尔值，将物体设置为 Mocap 刚体，此时物体的位姿完全由程序控制，在动力学仿真中认为始终固定的，可用于创建跟踪点等（仅 `worldbody` 标签下的物体可设置，且不能有关节）
- `geom` 用于描述物体的形状，可以存在多个表示物体由多个几何体拼接得到，常用属性有
  - `name`：几何体名称
  - `type`：几何体类型，常用有：`sphere` 球（默认）、`box` 长方体、`cylinder` 圆柱体
  - `size`：几何体尺寸，具体见文档
  - `pos, euler`：几何体相对所在物体坐标系的位置与姿态
  - `mass`：几何体质量，用于推断物体惯性
  - `rgba`：几何体颜色，使用四个浮点数的元组表示
- `joint` 用于描述物体与其父物体之间的关节连接，如果未定义关节则认为是与父物体相固连，常用属性有
  - `name`：关节名称
  - `type`：关节类型，常用有：
    - `free` 无约束的自由物体
    - `slide` 滑动关节
    - `hinge` 旋转关节（默认）
  - `pos`：关节坐标系相对所在物体坐标系的位置
  - `axis`：三元素元组，基于物体坐标系的关节的旋转轴或平移方向
  - `ref`：初始关节位置
- `light` 附加在物体上的灯光（通常附加在 `worldbody` 上作为固定光源）
  - `pos`：灯光点相对所在物体坐标系的位置
  - `axis`：三元素元组，基于物体坐标系的灯光方向
- `site` 不参与运动计算的形状，属性与 `geom` 基本一致，可用于指示坐标系或传感器位置等信息
- `camera` 附加在物体上的相机，位置描述与 `geom` 类似，此外还具有如下属性
  - `mode`：相机相对观察物体的位姿特性，常用如下
    - `fixed`：默认，即相机相对所在物体的位姿固定
    - `track`：相机相对所在物体的固定，但姿态相对世界坐标系固定，不随物体改变，用于以稳定视角观察可能旋转的物体
    - `targetbody`：相机相对所在物体的固定，但姿态随时调整用于观察给定名称的物体（通过额外属性 `target` 给出），用于追踪特定物体
  - `fovy`：相机的垂直方向视场角（水平方向由相机分辨率确定）
  - `resolution`：相机分辨率（具体分辨率由创建 `Render` 对象时确定）
  - `xyaxes`：六元素元组，与 `quat`、`euler` 互斥的姿态参数，通过给出 x 与 y 轴确定坐标系（该方法能较好确定给定观察方向的相机位姿）

=== 关节控制器模型 <sec:actuator>

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

控制器的控制量通过 `MjData.ctrl` 或 `MjDataActuatorViews.ctrl` 给出，具体实例参见#link(<sec:joint_control>)[关节空间控制]

部分 MJCF 中，控制量并不直接与实际位移对应而存在特定比例关系、控制器可能施加在肌腱（Mujoco 中除关节外的一种执行器），可参见 #link("https://github.com/google-deepmind/mujoco_menagerie/blob/main/franka_emika_panda/panda.xml")[Panda 机器人对夹爪的设置]。

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

=== 其他常见模型 <sec:model>

Mujoco 中通常使用如下 MJCF 创建具有网格纹理的地面

```xml
<asset>
  <texture name="grid" type="2d" builtin="checker" rgb1=".1 .2 .3"
    rgb2=".2 .3 .4" width="300" height="300"/>
  <material name="grid" texture="grid" texrepeat="8 8" reflectance=".2"/>
</asset>

<worldbody>
    <geom size=".2 .2 .01" type="plane" material="grid"/>
</worldbody>
```

== 基本使用

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

类 `MjModel` 可通过以下两种静态方法从 MJCF 创建
- `mujoco.MjModel.from_xml_string(xml)` 用于从字符串形式的 MJCF 文件加载场景。
- `mujoco.MjModel.from_xml_path(xml)` 用于从给定的 MJCF 文件路径加载场景。

对于场景中的简单几何体（MJCF 文件标签为 `geom`，其他物体访问方式类似）<fun:ngeom>
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

对于场景中的简单几何体，`MjData` 对象同样有方法 `MjData.geom(...)`，从返回的 `MjDataGeomViews` 对象获取指定名称或 id 物体的动态信息（该对象能随仿真进行实时更新），一般固定物体只有位置与姿态： <fun:geom>
- `xmat`：9 元素 Numpy 数组，几何体姿态的旋转矩阵表示
- `xpos`：3 元素 Numpy 数组，几何体位置的旋转矩阵表示

直接调用 `MjData` 对象无法得到正确的信息，因此此时场景虽然被读取了但还没有实际加载，要进行下一时间步的仿真后才能得到当前时间步的动态信息。

方法 `mujoco.mj_step(m, d, n_step)` 用于仿真计算下一时间步 <fun:mj_step>
- 参数 `m`：`MjModel` 对象，场景静态信息
- 参数 `d`：`MjData` 对象，场景动态信息
- 参数 `n_step = 1`：整数，计算后续多个时间步

方法 `mujoco.mj_resetData(m, d)` 用于重置仿真环境
- 参数 `m`：`MjModel` 对象，场景静态信息
- 参数 `d`：`MjData` 对象，场景动态信息

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
<fun:update_scene>

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

例如以下函数用于渲染

```python
import time
from typing import Callable, Optional, Tuple
import numpy as np
import mujoco
from matplotlib import pyplot as plt
from matplotlib.animation import FuncAnimation

def draw_scene_animate(
    model: mujoco.MjModel,
    data: mujoco.MjData,
    scene_option: Optional[mujoco.MjvOption] = None,
    length: float = 3,
    hz: int = 60,
    save_name: str = "tmp.mp4",
    width: int = 640, height: int = 480,
    fig_size: Tuple[float, float] = (9, 6),
    animate_callback: Optional[Callable[[mujoco.MjModel, mujoco.MjData, float], None]] = None
):
    fig = plt.figure(figsize = fig_size)
    ax = fig.add_axes(rect = (0, 0, 1, 1))  # 完全铺满

    with mujoco.Renderer(model, width = width, height = height) as renderer:
        assert isinstance(renderer, mujoco.Renderer)
        sim_start = data.time

        def draw_sim(cur_time: float):        
            # data.time 获取仿真环境的真实时间
            # 仿真步长远小于帧率，通过 while 等待仿真计算
            while (data.time - sim_start) < cur_time:
                mujoco.mj_step(model, data)

            if animate_callback is not None:
                animate_callback(model, data, cur_time)

            # 仅绘制时渲染
            renderer.update_scene(data, scene_option = scene_option)
            pic = renderer.render()

            art = []
            ax.clear()
            art += ax.set_xticks([])  # 隐藏 x 轴上的所有刻度线
            art += ax.set_yticks([])  # 隐藏 y 轴上的所有刻度线
            art.append(ax.imshow(pic))
            return art

        start = time.perf_counter()
        fa = FuncAnimation(fig, draw_sim, np.arange(0, length, 1 / hz))
        fa.save(save_name, fps = hz)
        print(f"use: {time.perf_counter() - start:.3f}s")
```

以下例子用于渲染多帧图像得到一个视频

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

draw_scene_animate(model, data, length = 3)
```

== 机器人应用

Mujoco 官方提供了大量机器人模型，要使用这些模型需要从#link("https://github.com/google-deepmind/mujoco_menagerie")[官方仓库]中克隆。

以下例子默认使用 #link("https://github.com/google-deepmind/mujoco_menagerie/blob/main/franka_emika_panda/panda.xml")[mujoco_menagerie
/franka_emika_panda/panda.xml] 作为示例 

=== 机器人信息获取

类似 #link(<fun:geom>)[MjData.geom] 获取指定名称的几何体信息与 #link(<fun:ngeom>)[MjModel.ngeom] 获取几何体个数，对于关节与控制器也有同样的访问方法
- `MjModel.njnt`、`MjModel.nu`、`MjModel.nbody` 获取场景中的关节、控制器、物体的数量
- `MjModel/MjData.joint(...)`、`MjModel/MjData.actuator(...)`、`MjModel/MjData.body(...)` 获取场景中关节、控制器、物体的静态与动态信息视图（识图对象将自动获取最新仿真状态下的信息）

除了基于视图对象，mujoco 也支持直接访问底层以 Numpy 数组形式储存的底层信息，常用的有：
- `MjData.qpos`、`MjData.qvel`、`MjData.qacc` 关节位置、速度、加速度
- `MjData.ctrl` 控制器的给定控制量

对于不同关节类型
- `slide` 滑动关节
  - 占用 `qpos, qvel, qacc` 一个参数，位移单位为米
- `hinge` 旋转关节
  - 占用 `qpos, qvel, qacc` 一个参数，位移单位为弧度（与 MJCF 中默认角度单位不同）
- `free` 无约束的自由物体
  - 占用 `qpos` 3 个位置与 4 个四元数参数共 7 个参数
  - 占用 `qvel, qacc` 3 个速度与 3 个角速度参数共 6 个参数

这些底层信息按 `id` 顺序排列，但不一定一一对应，特别是多自由度关节，可根据：
- 根据 `MjModel.joint(...).qposadr` 获取关节参数在 `qpos` 中索引的起点
- 根据 `MjModel.joint(...).dofadr` 获取关节参数在 `qvel/qacc` 中索引的起点
- 由于控制器的控制量只有一个，因此 `MjData.ctrl` 与控制器 id 一一对应

例如以下代码收集 Panda 机器人七个旋转关节在 `qpos` 的索引，从而通过切片索引的方法批量获取旋转关节位置

```python
import numpy as np
import mujoco

model = mujoco.MjModel.from_xml_path(r"mujoco_menagerie\franka_emika_panda\panda.xml")
data = mujoco.MjData(model)
mujoco.mj_resetDataKeyframe(model, data, key = 0)

panda_jnt_idx_list = np.zeros(7, dtype = np.int32)
panda_jnt_ptr = 0
for i in range(model.njnt):
    jnt_view = model.joint(i)
    # 基于特定规则匹配
    # id 按关节出现顺序分配因此能从按下到上顺序匹配
    if jnt_view.name.startswith("joint"):
        panda_jnt_idx_list[panda_jnt_ptr] = jnt_view.qposadr
        panda_jnt_ptr += 1
print(f"joint pos: {data.qpos[panda_jnt_idx_list]}")
```

=== 关节空间控制 <sec:joint_control>

直接设置各个关节上的控制器控制量即可实现关节空间控制，例如官方示例的 Panda 机器人使用#link(<sec:actuator>)[位置控制器]，因此控制器的控制量即期望关节位置。

除了在程序中控制机器人，mujoco 还支持在 MJCF 中通过关键帧功能设置机器人特定姿态。关键帧定义于二级标签 `keyframe` 下的自闭合子标签 `key` 中，通过以下标签属性规定机器人姿态：
- `name`：关键帧名称
- `qpos`：关键帧下场景所有物体的关节位移（与 `MjData.qpos` 对应）
- `ctrl`：关键帧下场景所有控制器的控制量（与 `MjData.ctrl` 对应）

例如以下代码就控制 Panda 机器人的三个关节以正弦规律摆动，并绘制相应的控制误差

```py
... # 接 draw_scene_animate 相关代码

model = mujoco.MjModel.from_xml_path(r"mujoco_menagerie\franka_emika_panda\panda.xml")
data = mujoco.MjData(model)
mujoco.mj_resetDataKeyframe(model, data, key = 0)

class JointCtrlTester:

    def __init__(
        self,
        model: mujoco.MjModel,
        actuator_name_list: List[str],
        q_init: np.ndarray,
        q_period: float,
        q_magnitude: float
    ):
        self.actuator_name_list = actuator_name_list
        self.actuator_idx_list = []
        # 根据名称搜索对应的 id 用于索引
        for actuator_name in self.actuator_name_list:
            self.actuator_idx_list.append(
                model.actuator(actuator_name).id
            )

        self.q_init = q_init
        self.q_period = q_period
        self.q_magnitude = q_magnitude

        self.ctrl_dump = []
        self.qpos_dump = []
        self.t_list = []

    def joint_tilde(
        self,
        model: mujoco.MjModel,
        data: mujoco.MjData,
        cur_time: float
    ):
        val = self.q_magnitude * np.sin(cur_time / self.q_period * (2 * np.pi))
        data.ctrl[self.actuator_idx_list] = self.q_init + val

        self.ctrl_dump.append(data.ctrl[self.actuator_idx_list])
        # 均为单自由度关节，id 与索引对应
        self.qpos_dump.append(data.qpos[self.actuator_idx_list])
        self.t_list.append(cur_time)

    def plot_cmp(
        self,
        save_path: str
    ):
        '''
        绘制关节信息
        '''
        ctrl_dump = np.stack(self.ctrl_dump, axis = 1)
        qpos_dump = np.stack(self.qpos_dump, axis = 1)
        t_list = np.array(self.t_list)

        num_actuators = ctrl_dump.shape[0]
        
        fig, axes = plt.subplot_mosaic([[i] for i in range(num_actuators + 1)])
        fig.set_size_inches(9, 6)
        fig.set_layout_engine("compressed")

        for i in range(num_actuators):
            axes[i].plot(t_list, ctrl_dump[i])
            axes[i].plot(t_list, qpos_dump[i])
            axes[num_actuators].plot(t_list, ctrl_dump[i] - qpos_dump[i])

            axes[i].legend(["ctrl", "qpos", "err"])
            axes[i].set_title(self.actuator_name_list[i])
        
        axes[num_actuators].set_title("error")
        axes[num_actuators].legend([f"err of {self.actuator_name_list[i]}" for i in range(num_actuators)])

        fig.savefig(save_path)
        plt.close(fig)

jct = JointCtrlTester(
    model,
    ["actuator2", "actuator4", "actuator6"], 
    np.array([0, -1.57079, 1.57079]), 5, 0.3
)

draw_scene_animate(
    model, data, length = 10, 
    save_name = "joint.mp4", 
    animate_callback = jct.joint_tilde
)

jct.plot_cmp("joint.png")
```

上述代码可得到如下结果，表明控制器的控制量与关节真实位移间存在一定的误差，观察 MJCF 还可以发现误差大小与控制器的参数有关。

#figure(
  image("res/mujoco_joint.png", width: 80%), 
  caption: [Panda 机械臂关节摆动结果],
)

=== 笛卡尔空间控制

Mujoco 不提供逆运动学相关求解算法，只能通过软约束连接机器人末端与跟踪点，实现类似拖动示教的方式

首先需要创建跟踪点，跟踪点通常为 #link(<sec:body_define>)[Mocap 刚体]，且使用没有物理效果的 `site` 作为形状避免干涉，例如：

```xml
<body mocap="true" pos="0.56 0 0.60" euler="180 0 -90">
  <site name="mocap_site" type="sphere" size="0.02" rgba="1 1 1 0.5"/>
  <!-- 可选，用于指示坐标系 -->
  <!-- <site name="mocap_frame_xaxis" type="cylinder" size="0.015" fromto="0 0 0 0.2 0 0" rgba="1 0 0 1"/>
  <site name="mocap_frame_yaxis" type="cylinder" size="0.015" fromto="0 0 0 0 0.2 0" rgba="0 1 0 1"/>
  <site name="mocap_frame_zaxis" type="cylinder" size="0.015" fromto="0 0 0 0 0 0.2" rgba="0 0 1 1"/> -->
</body>
```

然后在机械臂末端创建一个被追踪点，通常在夹爪连杆下创建固连的 `site` 物体，例如：

```xml
<body name="hand" pos="..." quat="...">
    <body pos="0 0 0.1">
      <site name="hand_site" type="sphere" size="0.02" rgba="0 1 0 0.5"/>
    </body>
</body>
```

最后在二级子标签中添加软连接约束

```xml
<equality>
  <weld site1="mocap_site" site2="hand_site" solref="0.02 1" solimp="0.9 0.95 0.001"/>
</equality>
```

场景中使用 Mocap 时，注意
- Mocap 与控制器冲突，需要禁用或去掉所有相关的控制器
- 为了保证关节稳定，需要在关节上添加摩擦系数，如 `frictionloss="50"`
- 可以参考本笔记在 panda 基础上修改得到的，#link("https://github.com/tonyddg/melonade/blob/main/code/res/panda_mocap.xml")[适用于 Mocap 的场景]

在代码中控制 Mocap 时与 `ctrl` 类似，不能直接修改物体的位姿，而是使用 `MjData` 的属性 `MjData.mocap_pos` 与 `MjData.mocap_quat` 控制，其中
- `MjData.mocap_pos` 与 `MjData.mocap_quat` 为二维 Numpy 数组，第一维为 `mocap` 物体的编号（按定义顺序确定）
- `MjData.mocap_pos` 与 `MjData.mocap_quat` 分别为 Mocap 物体的位置与姿态
- 当 Mocap 物体超出机器人工作空间时，不会出现错误而是表现为末端无法与 Mocap 物体重合

例如以下代码用于控制机械臂末端做 x，y 方向画圆与 z 方向摆动运动

```python
class MocapCtrlTester:
    def __init__(
        self,
        mocap_idx: int,
        hand_site_name: str,
        pos_start: np.ndarray,
        radius: float = 0.1,
        period: float = 5,
        z_magnitude: float = 0.1
    ) -> None:
        self.mocap_idx = mocap_idx
        self.pos_start = pos_start
        self.radius = radius
        self.period = period
        self.z_magnitude = z_magnitude

        self.hand_site_name = hand_site_name
                
        self.mocap_dump = []
        self.hand_dump = []
        self.t_list = []

    def circle_move(
        self,
        model: mujoco.MjModel,
        data: mujoco.MjData,
        cur_time: float
    ):
        y = self.radius * np.sin(cur_time / self.period * (2 * np.pi))
        x = self.radius * (np.cos(cur_time / self.period * (2 * np.pi) + np.pi) + 1)
        z = self.z_magnitude * np.sin(cur_time / self.period * (2 * np.pi))

        data.mocap_pos[self.mocap_idx] = self.pos_start + np.array([x, y, z], dtype = np.float64)

        self.mocap_dump.append(data.mocap_pos[self.mocap_idx])
        self.hand_dump.append(data.site(self.hand_site_name).xpos)

        self.t_list.append(cur_time)

    def plot_cmp(
        self,
        save_path: str
    ):
        '''
        绘制跟踪信息
        '''
        mocap_dump = np.stack(self.mocap_dump, axis = 1)
        hand_dump = np.stack(self.hand_dump, axis = 1)
        t_list = np.array(self.t_list)

        fig, axes = plt.subplot_mosaic([[i] for i in range(4)])
        fig.set_size_inches(9, 6)
        fig.set_layout_engine("compressed")

        name_list = ['x', 'y', 'z']

        for i in range(3):
            axes[i].plot(t_list, mocap_dump[i])
            axes[i].plot(t_list, hand_dump[i])
            axes[3].plot(t_list, mocap_dump[i] - hand_dump[i])

            axes[i].legend(["ctrl", "qpos", "err"])
            axes[i].set_title(name_list[i])
        
        axes[3].set_title("error")
        axes[3].legend([f"err of {name_list[i]}" for i in range(3)])

        fig.savefig(save_path)
        plt.close(fig)

model = mujoco.MjModel.from_xml_path(r"mujoco_menagerie\franka_emika_panda\panda_mocap.xml")
data = mujoco.MjData(model)
mujoco.mj_resetDataKeyframe(model, data, key = 0)

# 通过循环语句等待末端运动到目标点
data.mocap_pos[0] = np.array([0.36, 0, 0.6])
while True:
    mujoco.mj_step(model, data)
    if np.linalg.norm(data.mocap_pos[0] - data.site("hand_site").xpos) < 0.01:
        break
print("move to target")

mct = MocapCtrlTester(
    0, "hand_site",
    np.array([0.36, 0, 0.6]),
)

draw_scene_animate(
    model, data, length = 10, 
    save_name = "mocap.mp4", 
    animate_callback = mct.circle_move
)

mct.plot_cmp("mocap.png")
```

=== 相机渲染

在 Mujoco 中，相机为固连在物体上的部件，关于相机的创建参见#link(<sec:body_define>)[场景物体定义]。

且相机同样通过场景渲染对象 `Renderer` 管理，所有相机共用一个渲染对象，仅需在渲染前指定 #link(<fun:update_scene>)[Render.update_scene] 的参数 `camera` 即可。

对于深度图与语义分割图同样可使用场景渲染对象 `Renderer` 渲染，仅需调用场景渲染对象的方法指定渲染的目标：
- `Renderer.enable_depth_rendering()` 渲染深度图像
  - 此时 `Renderer.render()` 结果即以真实深度为值的二维 Numpy 数组
  - 当场景中存在没有遮挡的区域（无穷远处）时，将得到一个极大的深度值，因此最好使用 `pic[pic > z_far] = z_far` 进行过滤 
- `Renderer.enable_segmentation_rendering()` 渲染语义分割图像
  - 此时 `Renderer.render()` 结果为三维 Numpy 数组，通道维度中 `pic[:, :, 0]` 为图像中的物体 id，`pic[:, :, 1]` 为图像中的物体类型
- 如果希望场景渲染对象 `Renderer` 绘制不同的图像，或绘制 RGB 图像，则需要以下方法禁用对应的设置
  - `Renderer.disable_depth_rendering()` 禁用深度输出
  - `Renderer.disable_segmentation_rendering()` 禁用语义分割输出

== 杂项

=== 类型检查与 IDE 提示 <type_hint_ide>

目前，Mujoco 仍有部分类缺少 .pyi 类型注释文件，可以下载非官方的 #link("https://github.com/I-am-Future/mujoco-stubs/tree/main/mujoco-stubs")[pyi 文件]放置在项目根目录临时解决（也可以参考此仓库提供的脚本自行生成）

