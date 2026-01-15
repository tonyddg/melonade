#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Pybullet 笔记")

#import "/utility/include.typ": *

= Sapien 与 ManiSkill 笔记

== Sapien 基础仿真引擎

#link("https://sapien-sim.github.io/docs/user_guide/index.html")[参考教程]

=== 基本结构

一个典型的 Sapien 引擎使用代码如下，包含了 Sapien API 的基本使用流程，其中
- `sapien.Scene` 对象用于管理仿真场景，通过其方法可设置场景的基础配置，建议直接使用示例的设置代码
- 观察界面不是必要的，在大规模仿真训练中可以不使用观察界面
- 仿真循环中，通过 `scene.step()` 更新下一时间刻的物理状态、`scene.render()` 渲染模型，更新观察界面与传感器相机

```py
import sapien
import numpy as np

def main():
    # 创建并设置场景的仿真步长、环境光照、地面等基本参数
    scene = sapien.Scene()
    scene.set_timestep(1e-2)
    scene.set_ambient_light([0.5, 0.5, 0.5])
    scene.add_directional_light([0, 1, -1], [0.5, 0.5, 0.5])
    scene.add_ground(altitude = 0)
    
    # 向场景中添加物体
    actor_builder = sapien.ActorBuilder()
    actor_builder.add_box_collision(half_size = (0.5, 0.5, 0.5))
    actor_builder.add_box_visual(half_size = (0.5, 0.5, 0.5), material=(1.0, 0.0, 0.0))
    actor_builder.set_scene(scene)
    actor_builder.set_initial_pose(sapien.Pose(p = (0, 0, 0.5)))
    box = actor_builder.build(name = "box")

    # 创建观察界面并设置
    viewer = scene.create_viewer()
    viewer.set_camera_xyz(x = -4, y = 0, z = 2)
    viewer.set_camera_rpy(r = 0, p = -np.arctan2(2, 4), y = 0)
    assert viewer.window is not None
    viewer.window.set_camera_parameters(near = 0.05, far = 100, fovy = 1)

    # 仿真循环
    while (not viewer.closed) and (not viewer.window.key_down('q')):
        scene.step()
        scene.update_render()
        viewer.render()

        time.sleep(scene.timestep)

if __name__ == "__main__":
    main()
```

=== 物体操作 <sec:sapien_entity>

Sapien 中称场景内的物体为 Actor，使用 `sapien.Entity` 对象表示，基础的物体仅有名称 (name) 与位姿 (pose) 两个基本属性，且有对应设置方法：
- 构造函数 `entity = sapien.Entity()` 
- `entity.set_name(name)` 设置物体名称 
- `entity.set_pose(pose)` 设置物体在世界坐标系下的位姿
    - `pose` #link(<sec:sapien_pose>)[位姿对象]
- `entity.remove_from_scene()` 将物体从场景中删除

物体的物理形状 (collision) 与视觉形状 (visual) 则通过组件 (component) 的形式附加到 `sapien.Entity` 对象上，从而实现物体的定义。关于这部分底层 API 使用可参见#link("https://sapien-sim.github.io/docs/user_guide/getting_started/create_actors.html#create-an-entity")[文档]。

实际使用更多通过 `sapien.ActorBuilder` 对象预构造物体，然后加载到场景 `sapien.Scene` 中，得到 `sapien.Entity` 对象。
- 构造函数 `actor_builder = sapien.ActorBuilder()`
- 一般静态物体的形状设置方法（可以添加多个形状组合得到复杂形状的物体）
    - `actor_builder.add_box_collision(pose, half_size)` 添加长方体的物理形状
        - `pose` #link(<sec:sapien_pose>)[位姿对象]，设置形状在物体坐标系下的位姿
        - `half_size` 三元组，设置物体长、宽、高的一半
    - `actor_builder.add_convex_collision_from_file(filename)` 导入模型作为物理形状
        - `filename` 模型文件路径
    - `actor_builder.add_box_visual(pose, half_size, material)` 添加长方体的视觉形状
        - `pose, half_size` 位姿与尺寸
        - `material` 三元组，模型的颜色，使用 0-1 的浮点数表示
    - `actor_builder.add_visual_from_file(filename)` 导入模型作为视觉形状 
        - `filename` 模型文件路径
    - 关于其他基本形状可通过形如 `actor_builder.add_xxx_collision()` 的方法创建
- 物体加载方法
    - `actor_builder.set_scene(scene)` 设置物体所在场景
    - `actor_builder.set_initial_pose(pose)` 设置物体加载初始位置
        - `pose` #link(<sec:sapien_pose>)[位姿对象]
    - 在场景中以静态物体的方式创建指定名称的物体，并返回物体的 `sapien.Entity` 对象\ `entity = actor_builder.build_static(name)` 
- 官方推荐的做法为通过 `scene.create_actor_builder()` 创建已经绑定好场景的 `sapien.ActorBuilder` 对象，在 Sapien 中两者等价但在 ManiSkill 中需要使用第二种做法

以上方法添加的是无法运动的静态物体，如果希望物体具有动力学特性，需要补充额外的参数
- Sapien 在碰撞物体的材质 (material) 中规定其与其他物体交互的特性，具体表示为 `sapien.physx.PhysxMaterial` 对象，有构造函数\ `material = physx.PhysxMaterial(static_friction, dynamic_friction, restitution)`
    - `static_friction` 静摩擦系数，默认材质为 `0.3`
    - `dynamic_friction` 动摩擦系数，默认材质为 `0.3`
    - `restitution` 碰撞恢复系数，默认材质为 `0.1`
- 在使用 `actor_builder.add_xxx_collision()` 方法添加物理形状时需要额外提供一下参数表示运动特性
    - `density` 物体密度，单位为 $"kg"slash m^3$，默认为 1000，即水的密度
    - `material` 物体交互特性参数，即 `sapien.physx.PhysxMaterial` 对象
- 在场景中以动态物体的方式创建指定名称的物体，并返回物体的 `sapien.Entity` 对象
    - `entity = actor_builder.build_kinematic(name)` 创建纯运动学物体，此类物体可以人为设置位置、速度等，但不受外力影响（即使是静态物体，只要有交互也建议设置为此类型）
    - `entity = actor_builder.build(name)` 创建一般动态物体，此类物体具有速度、加速度且受重力、接触力等外力
    - `entity = actor_builder.build_static(name)` 创建绝对静态物体，此类物体除了构建时使用 `set_init_pose` 设置初始位姿外无法再被修改（除了绝对不动的场景，一般不会使用此类型）
    - `actor_builder.set_physx_body_type(type)` 也可通过方法设置物体在 `build` 方法创建时的动态特性
        - `type` 字符串，即 `static, kinematic, dynamic, link` 中的一个，默认为 `dynamic`
- 对于 `kinematic, dynamic` 类型的物体，本质为添加了组件 `saphysx.PhysxRigidBodyComponent` 对象，可通过该组件对象获取物体的运动学信息
    - 首先使用物体 `sapien.Entity` 对象的方法找出指定类型的组件\ `cmp = cube.find_component_by_type(cls)`
        - `cls` 待获取组件的 Python 类型
        - 返回值为对应的组件对象，可在后续使用 `assert` 断言类型
    - 可调用获取的 `saphysx.PhysxRigidBodyComponent` 对象的方法获取物体的运动学信息，常用的有
        - 获取角速度矢量 `cmp.get_angular_velocity()`
        - 获取线速度矢量 `cmp.get_linear_velocity()`
        - 获取组件附加的物体对象 `cmp.get_entity()`

例如以下代码创建一个固定斜坡与运动滑块，并记录滑块运动速度变化曲线

```py
import time
import sapien
import numpy as np
from scipy.spatial.transform import Rotation as R

def main():
    scene = sapien.Scene()
    scene.set_timestep(1e-2)
    scene.set_ambient_light([0.5, 0.5, 0.5])
    scene.add_directional_light([0, 1, -1], [0.5, 0.5, 0.5])
    scene.add_ground(altitude = 0)

    # 创建斜坡
    slope_builder = sapien.ActorBuilder()
    slope_builder.add_box_collision(half_size = (0.25, 1, 0.05))
    slope_builder.add_box_visual(half_size = (0.25, 1, 0.05), material=(0.5, 0.5, 0.5))
    slope_builder.set_scene(scene)
    slope_builder.set_initial_pose(
        sapien.Pose(
            p = (0, 0, 0.6), 
            q = np.asarray(R.from_euler("X", 30, degrees = True).as_quat(scalar_first = True), dtype = np.float32)
        )
    )
    slope = slope_builder.build_static(name = "slope")
    
    # 创建滑块
    cube_builder = sapien.ActorBuilder()
    cube_builder.add_box_collision(half_size = (0.1, 0.1, 0.1))
    cube_builder.add_box_visual(half_size = (0.1, 0.1, 0.1), material=(1.0, 0.0, 0.0))
    cube_builder.set_scene(scene)
    cube_builder.set_initial_pose(sapien.Pose(p = (0, 0.4, 1.5)))
    cube = cube_builder.build(name = "cube")

    # 创建观察并设置界面
    viewer = scene.create_viewer()
    viewer.set_camera_xyz(x = -4, y = 0, z = 2)
    viewer.set_camera_rpy(r = 0, p = -np.arctan2(2, 4), y = 0)
    assert viewer.window is not None
    viewer.window.set_camera_parameters(near = 0.05, far = 100, fovy = 1)

    # 获取滑块的刚体组件
    cube_rigid_component = cube.find_component_by_type(sapien.physx.PhysxRigidBodyComponent)
    assert isinstance(cube_rigid_component, sapien.physx.PhysxRigidBodyComponent)
    velocity_list = []

    # 仿真循环
    while (not viewer.closed) and (not viewer.window.key_down('q')): #  and (len(velocity_list) < 200):
        scene.step()
        scene.update_render()
        viewer.render()
        velocity_list.append(np.linalg.norm(cube_rigid_component.get_linear_velocity()))
        time.sleep(scene.timestep)

    # 绘制滑块速度变化曲线
    from matplotlib import pyplot as plt
    plt.plot(np.arange(0, len(velocity_list) * scene.timestep, scene.timestep), velocity_list)
    plt.show()

if __name__ == "__main__":
    main()
```

=== 观察界面 <sec:sapien_view>

使用 `viewer = scene.create_viewer()` 创建观察界面后，将在仿真环境运行时创建一个可交互的 ui 界面用于观察与编辑仿真环境（该观察界面不是必要的）。

观察界面中通过以下方式移动视角
- #bl(0)[w]、#bl(0)[a]、#bl(0)[s]、#bl(0)[d] 沿相机视角方向或垂直视角方向移动观察相机
- 鼠标右键：旋转视角；鼠标左键：平移视角；鼠标滚轮：缩放视角
- 鼠标左键可选中物体，选中后 #bl(1)[Entity] 选项卡将出现物体基本信息

界面中有如下实用选项卡
- #bl(1)[Control] 选项卡：控制仿真环境
    - 最上方的 #bl(2)[Pause] 复选框与 #bl(2)[Single Step] 按钮：暂停仿真环境与单步执行仿真
    - 中间的 #bl(2)[Camera] 下拉标签页：可以在 #bl(2)[Name] 标签处的下拉栏选择场景中的特定相机，观察相机的输出
    - 中间的 #bl(2)[Display] 下拉标签页：可以在 #bl(2)[Target] 标签处的下拉栏选择观察相机输出类型
    - 下方的 #bl(2)[Selection] 下拉标签页：设置右键选中物体后是否绘制关节坐标系、物体坐标系，以及坐标系大小、物体不透明度等
    - 最下方的 #bl(2)[Screenshot] 按钮：拍摄相机视角保存为图片
- #bl(1)[Scene] 选项卡：以树状图显示场景中的物体及关节连接关系
- #bl(1)[Entity] 选项卡：显示被选中物体详细信息
- #bl(1)[Contacts] 选项卡：显示物体间的接触与碰撞信息
- #bl(1)[Transform] 选项卡：在线编辑选中物体位姿
- #bl(1)[Articulation] 选项卡：在线编辑选中机器人（带有关节的物体）关节位置，对于机械臂需要加入#link(<sec:sapien_robot>)[被动力补偿]相关代码以正确编辑关节

此外 `viewer` 对象还可以有如下方法用于捕获观察界面的操作
- 属性 `viewer.closed` 判断观察界面是否关闭，可作为仿真循环的结束条件
- 方法 `viewer.key_down(key)` 无阻塞地检测，当用户在观察界面按下指定按钮时返回 `True` 

=== 机器人应用 <sec:sapien_robot>

Sapien 允许直接导入机器人的 URDF 模型，首先导入 URDF 加载类\ `from sapien.wrapper.urdf_loader import URDFLoader`，其中 `URDFLoader` 类使用空构造函数，需要通过对象方法确定导入配置
- `urdf_loader.set_scene(scene)` 设置模型加载到的场景
- 属性 `urdf_loader.fix_root_link` 使用布尔值表示末端关节是否固定，对于机械臂应为 `True`；对于移动机器人应为 `False`
- `robot = urdf_loader.load(file)` 加载 URDF 文件到场景中，并返回对应的多关节物体对象 `sapien.physx.PhysxArticulation`

加载得到的 URDF 模型将通过多关节物体对象 `physx.PhysxArticulation` 管理机器人的各个关节，有如下常用方法
- `robot.set_root_pose(pose)` 设置基座位姿
    - `pose` #link(<sec:sapien_pose>)[位姿对象]
- `robot.get_active_joints()` 获取可动关节列表，返回值为列表，列表中的元素为关节组件对象 `physx.PhysxArticulationJoint`
    - `joints_dict = {joint.name: joint for joint in joints}` 习惯上会通过该语句将获取的关节列表转化为关节名称与具体关节对象的映射（关节名称来自 URDF 定义）
- `robot.get_joints()` 获取所有关节列表，返回值为关节对象 `physx.PhysxArticulationJoint` 构成的列表
- `robot.get_links()` 获取所有连杆列表，返回值为列表，列表中的元素为连杆组件对象 `physx.PhysxArticulationLinkComponent`
    - 该对象继承自刚体组件 `physx.PhysxRigidBodyComponent`，可以像#link(<sec:sapien_entity>)[动态物体]一样获取连杆的运动状态
    - 组件还有方法 `cmp.get_pose()` 获取连杆坐标系位姿

- `robot.get_qpos()` 获取所有关节位移，返回值为 Numpy 数组，与 `robot.get_joints()` 得到的关节列表对应，注意无法通过单个关节对象获取具体关节位移

对于机器人的运动控制与状态查询需要通过对具体关节对象的操作实现，Sapien 没有提供直接位置控制，只能使用内置的 PD 控制器实现关节位置、速度控制
- `joint.get_name()` 获取关节名称，与 URDF 中定义的相同
- `joint.get_limit()` 获取关节限位，输出为二元素的 Numpy 数组
- `joint.set_drive_property(stiffness, damping, force_limit)` 在关节上添加控制器
    - `stiffness` PD 控制器的系数 kp，建议取 `200`
    - `damping` PD 控制器的系数 kd，建议取 `50`
    - `force_limit` 限制控制量，即关节力的大小
- `joint.set_drive_target(target)` 设置目标关节位移
- `joint.set_drive_velocity_target(velocity)` 设置目标关节速度，用于车轮等关节

控制机械臂时，由于重力等被动力影响机械臂始终无法准确运动到目标位置，还需要加入重力补偿保证更准确的位置控制。一般被动力补偿仅需在物理仿真前加入以下代码

```py
# 计算各个关节补偿力矩
qf = robot.compute_passive_force(
    gravity = True,
    coriolis_and_centrifugal = True,
)
# 设置关节力矩
robot.set_qf(qf)
# 执行物理仿真
scene.step()
```

以下为机械臂控制示例代码，可以尝试开启或关闭被动力平衡感受其对控制的影响

```py
import sapien
from sapien.wrapper.urdf_loader import URDFLoader
import numpy as np

def main():

    scene = sapien.Scene()
    scene.set_timestep(1e-2)
    scene.set_ambient_light([0.5, 0.5, 0.5])
    scene.add_directional_light([0, 1, -1], [0.5, 0.5, 0.5])
    scene.add_ground(altitude = 0)
    # 加载机器人
    urdf_loader = URDFLoader()
    urdf_loader.set_scene(scene)
    urdf_loader.fix_root_link = True
    robot = urdf_loader.load("assets/jaco2/jaco2.urdf")
    robot.set_root_pose(sapien.Pose([0, 0, 0], [1, 0, 0, 0]))
    # 设置机器人控制器
    arm_zero_qpos = [0, 3.14, 0, 3.14, 0, 3.14, 0] + [0, 0, 0, 0, 0, 0]
    active_joints = robot.get_active_joints()
    for joint_idx, joint in enumerate(active_joints):
        joint.set_drive_property(stiffness = 200, damping = 50, force_limit=1000, mode="force")
        joint.set_drive_target(arm_zero_qpos[joint_idx])
    # 创建观察并设置界面
    viewer = scene.create_viewer()
    viewer.set_camera_xyz(x = -4, y = 0, z = 2)
    viewer.set_camera_rpy(r = 0, p = -np.arctan2(2, 4), y = 0)
    assert viewer.window is not None
    viewer.window.set_camera_parameters(near = 0.05, far = 100, fovy = 1)

    is_blance_passive_force = True
    # 仿真循环
    while (not viewer.closed) and (not viewer.window.key_down('q')):
        if is_blance_passive_force:
            qf = robot.compute_passive_force(
                gravity = True,
                coriolis_and_centrifugal = True,
            )
            robot.set_qf(qf)

        scene.step()
        scene.update_render()
        viewer.render()
        # 开启或关闭被动力平衡
        if viewer.window.key_press("i"):
            is_blance_passive_force = not is_blance_passive_force
            print(f"is_blance_passive_force: {is_blance_passive_force}")
            # 取消被动力平衡设置的关节力矩
            if not is_blance_passive_force:
                robot.set_qf(np.zeros(robot.get_qf().shape))
        # 关节运动
        if viewer.window.key_press("j"):
            active_joints[3].set_drive_target(robot.get_qpos()[3] + 0.1)
        if viewer.window.key_press("l"):
            active_joints[3].set_drive_target(robot.get_qpos()[3] - 0.1)
        if viewer.window.key_press("b"):
            active_joints[5].set_drive_target(robot.get_qpos()[5] + 0.1)
        if viewer.window.key_press("m"):
            active_joints[5].set_drive_target(robot.get_qpos()[5] - 0.1)

if __name__ == "__main__":
    main()
```

=== 相机渲染 <sec:sapien_camera>

与一般相机坐标系规定不同，Sapien 相机：X 轴与相机视角同向，而不是一般的使用 Z 轴；Z 轴指向相机上方；Y 轴则一样指向左侧。

通过场景对象 `scene` 的方法创建附加在指定物体上的相机\ `scene.add_mounted_camera(name, mount, pose, width, height, fovy, near, far)`
- `name` 相机名称
- `mount` 附加物体对象
- `pose` 相机在物体坐标系上的位姿
- `width, height` 相机输出图片尺寸
- `fovy, near, far` 相机视场角、最近观察距离、最远观察距离
- 类似的有创建固定点相机方法 `scene.add_camera`
- 返回值为相机组件对象 `RenderCameraComponent`

相机组件对象 `RenderCameraComponent` 有以下实用方法
- 获取相机参数
    - `camera.get_global_pose() / camera.get_local_pose()` 获取相机相对世界坐标系 / 附加物体坐标系下的位姿
    - `camera.get_intrinsic_matrix()` 获取相机 3x3 的内参矩阵
- 渲染相机图片
    - `camera.take_picture()` 更新相机图片，需要在每步仿真更新渲染场景后，获取相机图片前执行
    - `camera.get_picture(name)` 获取指定类型的相机图片，常用的有
        - `Color` 获取彩色图片，返回 `[H, W, 4]` 的 Numpy 数组，图片格式为 `RGBA`，像素值范围为 0-1
        - `Position` 获取像素点云，返回 `[H, W, 4]` 的 Numpy 数组，通道代表像素在 OpenGL 规范的相机坐标系下的 x,y,z 坐标与渲染深度，可#hl(2)[z 坐标通道取负数]作为深度图，点云生成参见#link("https://sapien-sim.github.io/docs/user_guide/rendering/camera.html#generate-point-cloud")[文档]
        - `Segmentation` 获取语义分割图，返回 `[H, W, 4]` 的 Numpy 数组，通道 0 代表基于模型分割，1 代表基于物体分割
        - 更多的输出类型可以在#link(<sec:sapien_view>)[观察界面]的 #bl(1)[Control] 选项卡中设置与查看效果

Sapien 除了一般的光栅渲染，还支持基于光线追踪的渲染以获得更逼真的图片，相关开启设置如下
- `sapien.render.set_camera_shader_dir("rt")` 相机渲染图片时启用光线追踪
- `sapien.render.set_ray_tracing_samples_per_pixel(spp)` 光线追踪采样次数，无去噪器时建议使用 256，有去噪器时建议使用 64
- `sapien.render.set_ray_tracing_denoiser(name)` 去噪器类型，常用值有
    - `none` 无去噪器，默认设置
    - `optix` Nvidia 内置去噪器，仅在 Linux + NVIDIA 显卡下才能稳定工作


以下示例代码介绍基于理想相机与模拟相机获取深度图的方法，其中香蕉模型可在#link("https://sapien-sim.github.io/docs/user_guide/getting_started/create_actors.html")[官方文档]下载

```py
import sapien
import numpy as np
from sapien.sensor import StereoDepthSensor, StereoDepthSensorConfig
from matplotlib import pyplot as plt

def main():
    # 创建场景
    scene = sapien.Scene()
    scene.set_timestep(1e-2)
    scene.set_ambient_light([0.5, 0.5, 0.5])
    scene.add_directional_light([0, 1, -1], [0.5, 0.5, 0.5])
    scene.add_ground(altitude = 0)
    # 设置深度相机模拟所需的渲染参数
    sapien.render.set_camera_shader_dir("rt")
    sapien.render.set_ray_tracing_samples_per_pixel(64)
    sapien.render.set_ray_tracing_denoiser("optix")
    sapien.render.set_ray_tracing_path_depth(8)
    # 添加立方体
    cube_builder = sapien.ActorBuilder()
    cube_builder.add_box_collision(half_size = (0.05, 0.05, 0.05))
    cube_builder.add_box_visual(half_size = (0.05, 0.05, 0.05), material=(1.0, 0.0, 0.0))
    cube_builder.set_scene(scene)
    cube = cube_builder.build(name = "cube")
    cube.set_pose(sapien.Pose(p = (1, -0.15, 0.2)))
    cube_rigid_info = cube.find_component_by_type(sapien.physx.PhysxRigidBodyComponent)
    assert isinstance(cube_rigid_info, sapien.physx.PhysxRigidBodyComponent)
    # 添加香蕉模型
    banana_builder = sapien.ActorBuilder()
    banana_builder.add_convex_collision_from_file(filename = "./assets/banana/collision.obj", scale = (1.5, 1.5, 1.5))
    banana_builder.add_visual_from_file(filename="./assets/banana/visual.glb", scale = (1.5, 1.5, 1.5))
    banana_builder.set_scene(scene)
    banana = banana_builder.build(name = "banana")
    banana.set_pose(sapien.Pose(p = (1, 0.15, 0.2)))
    banana_rigid_info = cube.find_component_by_type(sapien.physx.PhysxRigidBodyComponent)
    assert isinstance(banana_rigid_info, sapien.physx.PhysxRigidBodyComponent)
    # 添加理想相机
    camera = scene.add_camera(
        name="camera",
        width=480,
        height=480,
        fovy=np.deg2rad(42.5),
        near=0.05,
        far=100,
    )
    view_pose = sapien.Pose(p = [0.504185, -0.00991216, 0.502542], q = [-0.927925, 0.0118068, -0.372521, -0.00669983])
    camera.set_entity_pose(view_pose)
    # 添加模拟双目相机
    sensor_config = StereoDepthSensorConfig()
    depth_sensor = StereoDepthSensor(sensor_config, camera.get_entity())
    # 等待物体稳定
    while True:
        scene.step()
        if (np.linalg.norm(cube_rigid_info.get_linear_velocity()) < 0.0001) and\
           (np.linalg.norm(banana_rigid_info.get_linear_velocity()) < 0.0001):
            break
    # 渲染相机图像
    scene.update_render()
    
    depth_sensor.take_picture()
    depth_sensor.compute_depth()
    depth = depth_sensor.get_depth()

    depth = depth[:, 180:660]
    depth[depth < 0.001] = 0

    camera.take_picture()
    depth_real = -camera.get_picture("Position")[:, :, 2]
    rgb = camera.get_picture("Color")[:, :, :3]
    # 绘制图像
    fig, axe = plt.subplot_mosaic([[0, 1, 2]])
    axe[0].imshow(depth, vmin = 0, vmax = np.max(depth_real))
    axe[0].set_title("Depth Sensor")
    axe[1].imshow(depth_real, vmin = 0, vmax = np.max(depth_real))
    axe[1].set_title("Real Depth")
    axe[2].imshow(rgb)
    axe[2].set_title("RGB")

    fig.set_layout_engine("compressed")
    fig.savefig("output.png")

if __name__ == "__main__":
    main()
```

代码运行效果

#figure(
    image("res/maniskill_camera.png")
)

=== Sapien 位姿表示 <sec:sapien_pose>

Sapien 内部提供了 `sapien.Pose` 对象用于表示位姿，并提供了基本的位姿转换、运算方法：
- 构造函数 `pose = sapien.Pose(p, q)` 通过位置、四元组构造位姿对象
    - `p` 位置参数，三元组或三元素 Numpy 数组
    - `q` 姿态参数，四元组或四元素 Numpy 数组，即 (w, x, y, z) 表示的四元数
- 构造函数 `pose = sapien.Pose(matrix)` 通过齐次矩阵构造位姿对象
- `pose.inv()` 获取位姿的逆
- `pose.to_transformation_matrix()` 获取位姿的齐次矩阵
- `pose.__mul__(other)`  与其他位姿的乘法组合运算

== ManiSkill 环境搭建

#link("https://maniskill.readthedocs.io/en/latest/user_guide/tutorials/custom_tasks/intro.html")[参考教程]

ManiSkill 为高度并行化训练环境而设计
- 其场景管理操作具有与 Sapien 类似的接口，但均为 ManiSkill 设计的特化版本，因此存在一定差异
- 搭建环境时需要按照固定的步骤进行，重载指定的方法完成指定的操作

以下为环境搭建的基本方法，注意 ManiSkill 中搭建环境的重点在于与机器人交互的环境，关于使用什么机器人、环境传感器与观测（认为是机器人的一部分）、机器人控制方法、场景渲染方法等于交互无关的细节均在#link(<sec:maniskill_interaction>)[环境实例化与交互]中涉及。

=== 注册环境

```py
from mani_skill.envs.sapien_env import BaseEnv
from mani_skill.utils.registration import register_env

@register_env(uid = "PushCube-v1", max_episode_steps = 50)
class PushCubeEnv(BaseEnv):

    def __init__(
        self, *args, **kwargs
    ):
        super().__init__(*args, **kwargs)
```

- ManiSkill 中环境类需要继承自 `BaseEnv` 类，并在构造函数时调用基类构造函数 `super().__init__(...)`（调用基类构造函数时，可通过传递参数设置环境）
- 还需要使用修饰器 `register_env(uid, max_episode_steps)` 修饰环境类，将其注册到 `Gymnasium` 中便于后续创建环境
    - `uid` 字符串，环境名称
    - `max_episode_steps` 环境 Episode 最大长度，该参数会在 `gym.make` 是为环境加上 `TimeLimitWrapper` 包裹器使其在超时时返回 `truncated`，#hl(2)[但不会在到达最大长度时自动重置环境]，且会使环境对象类型变为 `gym.Wrapper` 而不是 `BaseEnv`（可能会无法通过 `assert` 但实际上无影响）

=== 加载机器人

```py
import sapien
from typing import Union
from mani_skill.agents.robots import Panda, Fetch

class PushCubeEnv:
    #...

    SUPPORTED_ROBOTS = ["panda", "fetch"]
    agent: Union[Panda, Fetch]

    def __init__(
        self, *args, robot_uids: str = "panda", **kwargs
    ):
        super().__init__(*args, robot_uids = robot_uids, **kwargs)

    def _load_agent(
        self, options: dict, 
        initial_agent_poses = None, build_separate: bool = False
    ):
        return super()._load_agent(
            options, 
            initial_agent_poses = sapien.Pose(p = [-0.615, 0, 0]), 
            build_separate = build_separate
        )
```

- 具体机器人类型需要通过基类构造函数 `super().__init__()` 的参数 `robot_uids` 设置，该参数可以是字符串（预定义机器人类）或自定义机器人类型（具体可参考#link(<sec:maniskill_robot_config>)[自定义机器人]）。
- 可使用类静态成员 `SUPPORTED_ROBOTS` 的列表值限制环境可使用的机器人有哪些、类静态成员 `agent` 的类型限制可使用的机器人类型
- 方法 `_load_agent(...)` 执行机器人加载步骤，基类中已完成了加载操作，一般仅会使用如上示例代码通过重载主动设置 `initial_agent_poses` 参数，从而设置机器人初始位姿

=== 加载场景

```py
from mani_skill.utils.scene_builder.table import TableSceneBuilder
from mani_skill.utils.building import actors

class PushCubeEnv:
    #...

    # 仅作为静态常量，无额外含义
    goal_radius = 0.1
    cube_half_size = 0.02
    def _load_scene(self, options: dict):

        # Sapien 风格物体加载
        cube_builder = self.scene.create_actor_builder()
        cube_builder.add_box_collision(half_size = (self.cube_half_size,) * 3)
        cube_builder.add_box_visual(
            half_size = (self.cube_half_size,) * 3,
            material = (np.array([12, 42, 160]) / 255).tolist()
        )
        cube_builder.set_initial_pose(sapien.Pose(p = [0, 0, self.cube_half_size], q = [1, 0, 0, 0]))
        self.cube = cube_builder.build_dynamic(name = "cube")
        # 加载预定义场景
        self.table_scene = TableSceneBuilder(
            env=self,
        )
        self.table_scene.build()
        # ManiSkill 的预定义物体加载器
        self.goal_region = actors.build_red_white_target(
            self.scene,
            radius=self.goal_radius,
            thickness=1e-5,
            name="goal_region",
            add_collision=False,
            body_type="kinematic",
            initial_pose=sapien.Pose(p=[0, 0, 1e-3]),
        )
```

- 一般情况下 ManiSkill 中机器人与场景的加载仅在环境第一次 `env.reset` 时执行之后除非有 `reconfigure` 信号否则保持冻结，因此场景加载完后就不能在交互时添加新的物体
- 方法 `_load_scene(options)` 执行机器人加载步骤，该方法为纯虚方法无需调用基类同名方法。其中 `options` 为 Gym API 中 `env.reset(...)` 的同名参数。
- `_load_scene(options)` 中加载几何体的方法与 #link(<sec:sapien_entity>)[Sapien] 基本一致，但是只能使用 `self.scene` 访问环境对象管理的并行场景，通过场景的 `scene.create_actor_builder()` 方法创建物体预加载对象。
- 关于并行场景加载不同物体、场景复用等高级操作参见#link(<sec:maniskill_load_scene>)[复杂场景加载]

=== 场景初始化

```py
import torch
from mani_skill.utils.structs.pose import Pose

class PushCubeEnv:
    #...

    def _initialize_episode(self, env_idx: torch.Tensor, options: dict):
        with torch.device(self.device):
            b = len(env_idx)
            # 加载预定义场景
            self.table_scene.initialize(env_idx)
            # 随机设置物体位姿
            p = torch.zeros((b, 3))
            p[:, :2] = torch.rand((b, 2)) * 0.2 - 0.1
            p[:, 2] = self.cube_half_size
            q = torch.tensor([1, 0, 0, 0])
            cube_init_pose = Pose.create_from_pq(p = p, q = q)
            self.cube.set_pose(cube_init_pose)
            # 随机设置目标位置
            target_region_xyz = p + torch.tensor([0.1 + self.goal_radius, 0, 0])
            target_region_xyz[..., 2] = 1e-3
            self.goal_region.set_pose(
                Pose.create_from_pq(
                    p=target_region_xyz,
                    q=R.from_euler("xyz", [0, np.pi / 2, 0]).as_quat(scalar_first = True).tolist(),
                )
            )
```

- 方法 `_initialize_episode(env_idx, options)` 用于在冻结的加载环境基础上执行随机初始化步骤，会在每次 `env.reset` 后调用。
- ManiSkill 默认使用并行化的环境，每个时间步仅有一部分的环境需要重新初始化，这些环境 id 通过参数 `env_idx` 的列表表示，使用 `len(env_idx)` 即可确定有多少需要重新初始化的环境
- ManiSkill 中的场景及物体均为向量化的且使用 `torch.Tensor` 管理具体可参考#link(<sec:maniskill_vec_entity>)[向量化的物体与位姿]，在 `_initialize_episode` 中随机初始化时，会自动将物体对象限制为需要随机化的环境中，而不是所有环境，无需额外操作。

=== 成功与失败判定 <sec:maniskill_success>

```py
import torch

class PushCubeEnv:
    #...
    def evaluate(self) -> dict:
        is_obj_placed = torch.as_tensor(
            torch.linalg.norm(
                self.cube.pose.p[:, :2] - self.goal_region.pose.p[:, :2], dim = 1
            ) < self.goal_radius
        ) 
        is_obj_fall = torch.as_tensor(
            (self.cube.pose.p[..., 2] < 0) or (self.cube.pose.p[..., 2] > 2 * self.cube_half_size)
        )
        return {
            "success": is_obj_placed,
            "fail": is_obj_fall
        }
```

- 方法 `_initialize_episode(env_idx, options)` 用于判定当前环境是否成功或失败。每当 `env.step` 被调用时，都会调用该函数检查所有环境。判定时会以向量化地方式访问所有物体，可参考#link(<sec:maniskill_vec_entity>)[向量化的物体与位姿]，通过向量化操作提高效率
- 通过返回以字符串为键，形状为 (N,) 的布尔张量表示各个并行环境的判定结果，可用的键有 `success` 表示对应为 `True` 的环境达到成功状态，`fail` 表示达到失败状态。键不是必须的例如无具体成功 / 失败状态的环境可返回空字典。
- 返回的信号字典将被合并到 `info` 中，同时令 `env.step` 返回的 `terminations` 信号为 `True`
- ManiSkill 自带基于以上成功与失败信号的稀疏奖励，即成功奖励为 1，失败奖励为 -1，超时或同时处于成功与失败时奖励为 0

=== 稠密奖励

```py
class PushCubeEnv:
    # ...
    def compute_dense_reward(self, obs: Any, action: Array, info: Dict):
        # ...
        return reward

    # ...
    def compute_normalized_dense_reward(self, obs: Any, action: Array, info: Dict):
        # this should be equal to compute_dense_reward / max possible reward
        max_reward = 3.0
        return self.compute_dense_reward(obs=obs, action=action, info=info) / max_reward
```

- 奖励模式通过实例化环境时的参数 `reward_mode` 设置，具体参见#link(<sec:maniskill_interaction>)[其他设置]
- 根据不同的奖励模式会尝试调用以下方法获取奖励
    - `compute_normalized_dense_reward` 获取标准化的稠密奖励，当#link(<sec:maniskill_interaction>)[环境示例化]参数  `reward_mode = "normalized_dense"` 时调用该函数获取奖励
    - `compute_dense_reward` 获取一般稠密奖励，当 `reward_mode = "dense"` 时调用该函数获取奖励
- 奖励函数中，由于 `info` 已经整合了方法 `evaluate` 返回的成功与失败状态，因此可通过如 `reward[info["success"]] = ...` 给出成功奖励
- 注意由于 ManiSkill 只负责创建类 Gym 环境，但环境是否依据终止、截断信号重置与具体算法有关，奖励信号也要以此为依据设计

=== 相机设置与第三人称观测 <sec:maniskill_camera>

```py
from mani_skill.sensors.camera import CameraConfig
from mani_skill.utils import sapien_utils

class PushCubeEnv:
    @property
    def _default_sensor_configs(self):
        pose = sapien_utils.look_at(eye = [0.3, 0, 0.6], target = [-0.1, 0, 0.1])
        return [
            CameraConfig("base_camera", pose = pose, width = 128, height = 128, fov = np.pi / 2, near = 0.01, far = 100)
        ]
```

- 对于机器人上的相机属于本体感知，需要在#link(<sec:maniskill_robot_config>)[自定义机器人]中设置，此处设置的是与机器人无关、固定在环境物体上的第三人称相机
- 环境相机通过环境类的属性 `_default_sensor_configs` 定义，属性的值为一个以相机信息为元素的列表，代表环境中的多个相机
- 相机信息通过数据类 `CameraConfig` 定义，常用的键有
    - `uid` 相机名称，从观测读取相机图像时需要该信息
    - `shader_pack` 渲染方式，可用的有
        - `minimal` 默认，最节省显存且快速的渲染方式
        - `default` 平衡渲染方式，支持尽可能多的纹理
        - `rt, rt-med, rt-fast` 光线追踪渲染，从左到右速度逐渐提升，质量逐渐降低
    - `pose, width, height, fov, near, far` 相机基本参数，含义与#link(<sec:sapien_camera>)[Sapien 中的相机]类似
- 针对相机位姿的设计，ManiSkill 在模块 `mani_skill.utils.sapien_utils` 中提供了函数 `look_at(eye, target)` 可给出相机坐标和目标坐标生成一个观测目标的位姿

=== 额外环境感知

```py
from mani_skill.utils import sapien_utils

class PushCubeEnv:
    def _get_obs_extra(self, info: sapien_utils.Dict):
        return dict(
            tcp_pose = self.agent.tcp.pose.raw_pose
        )
```

// - 对于机器人本体感知、相机图像等观测的具体设置，ManiSkill 通过实例化环境时的设置确定，具体参考#link(<sec:maniskill_camera>)[观测设置]；对于全局相机观测可参考#link(<sec:maniskill_camera>)[相机设置]
- 方法 `_get_obs_extra(info)` 从当前环境中获取额外的感知信息，ManiSkill 认为默认观测包含了所有常用的数据，该方法主要用于从场景获取真实位姿等实际使用中无法准确测量的感知信息。
- ManiSkill 中观测通过键名为字符串，键值为第 0 维大小为 N 的张量的字典表示，因此方法 `_get_obs_extra(info)` 返回的新观测字典也要使用同样的格式，最后将合并到自动生成的观测中。

=== 复杂场景加载 <sec:maniskill_load_scene>

https://maniskill.readthedocs.io/en/latest/user_guide/tutorials/custom_tasks/advanced.html

=== 领域随机化

https://maniskill.readthedocs.io/en/latest/user_guide/tutorials/domain_randomization.html

== ManiSkill 自定义机器人 <sec:maniskill_robot_config>

#link("https://maniskill.readthedocs.io/en/latest/user_guide/tutorials/custom_robots.html")[自定义机器人]

== ManiSkill 环境实例化与应用 <sec:maniskill_interaction>

=== 环境实例化

=== 生成示教轨迹

示教轨迹的生成同样基于实例化的环境，且一般使用以下设置实例化环境

```py
env = gym.make(
    ...,
    # 规划器只能处理单个环境
    num_envs = 1,
    # 为了适应动作规划器，必须保证机械臂关节使用绝对坐标
    control_mode="pd_joint_pos",
)
# 使用轨迹规划器时，通常会去操作原始环境对象便于后续开发
env = env.unwrapped
assert isinstance(env, BaseEnv)
```

推荐使用 ManiSkill 中已经写好的机械臂轨迹规划器，轨迹规划器的基本使用方法如下
- `mani_skill.examples.motionplanning.<机器人>.motionplanner` 模块下定义了如 Panda 等机器人的轨迹规划器，需要与环境中使用的机器人相同（后续以 Panda 机器人的轨迹规划器为例）
- `planer = PandaArmMotionPlanningSolver(env, pose)` 创建轨迹规划器对象
    - `env` 环境对象（确保为独立环境与使用绝对关节坐标动作）
    - `pose` Sapien 位姿对象，机器人当前基座位姿，可通过 `env.agent.robot.pose` 直接获取环境中的机器人基座位姿（可先使用#link(<sec:maniskill_vec_entity>)[to_sapien_pose]转为 Sapien 位姿对象）
- `planer.move_to_pose_with_screw(pose, dry_run, refine_steps)` 规划并执行机器人运动
    - `pose` 运动目标位姿的 Sapien 位姿对象，即机器人基座标系下末端工具坐标系的位姿（机器人的末端虚拟关节）
    - `dry_run = False` 布尔值
        - 取 `True` 时将仅尝试规划路径并返回规划结果
        - 取 `False` 时将通过 `env.step`，在环境中执行规划结果，并返回最后一步的环境输出
    - `refine_steps = 0` 机器人运动到目标位置后停止等待的步数
    - 规划失败时将返回 `-1`
- `planer.planer.set_base_pose(pose)` 重新设置机器人基座位姿（用于移动机器人）

对于目标抓取的示教轨迹生成，ManiSkill 提供了如下的实用函数
- 以下函数来自模块 `mani_skill.examples.motionplanning.utils`
- `obb = get_actor_obb(actor)` 获取场景中物体的包容盒（场景中的物体对象一般直接访问环境对象即可得到）
- `grasp_info = compute_grasp_info_by_obb(...)` 依据包容和获取抓取位姿
    - `obb` 包容盒对象
    - `approaching` 抓取接近方向向量，应为单位向量，观察坐标系为被抓取物体坐标系
    - `target_closing` 机器人夹取方向，一般即末端姿态矩阵的 y 轴，可通过以下方式获取 `env.agent.tcp.pose.to_transformation_matrix()[0, :3, 1].cpu().numpy()`
    - `depth` 夹取深度，依据夹爪的指长度确定

与相关实用函数

- `mani_skill.examples.motionplanning.utils` 模块下提供了生成示教所需的实用函数


```py
from mani_skill.examples.motionplanning.panda.motionplanner import PandaArmMotionPlanningSolver
from mani_skill.examples.motionplanning.panda.utils import compute_grasp_info_by_obb, get_actor_obb
```

其中
- `PandaArmMotionPlanningSolver(env)` 为基于场景

#link("https://github.com/haosulab/ManiSkill/blob/main/mani_skill/examples/motionplanning/base_motionplanner/motionplanner.py")[机器人运动规划]

#link("https://maniskill.readthedocs.io/en/latest/user_guide/wrappers/record.html")[记录动作轨迹]

#link("https://github.com/haosulab/ManiSkill/blob/main/mani_skill/examples/motionplanning/panda/run.py")[轨迹记录示例代码]

#link("https://maniskill.readthedocs.io/en/latest/user_guide/datasets/replay.html")[示教数据回放]

== ManiSkill 杂项

=== 向量化的物体与位姿 <sec:maniskill_vec_entity>

ManiSkill 中的场景及物体均为向量化的且使用 `torch.Tensor` 张量对象管理，其中张量对象所在设备可通过 `self.device` 查询。相比 Sapien 对应对象主要有以下区别：

对于位姿表示
- ManiSkill 使用向量化的位姿表示对象：\ 
`from mani_skill.utils.structs.pose import Pose`
- 静态方法 `Pose.create(pose, device)` 用于从 `sapien.Pose` 创建位姿
    - `pose` 由 `sapien.Pose` 对象构成的列表
    - `device` 位姿信息张量保存设备，一般与环境一致取 `self.device`
- 静态方法 `Pose.create_from_pq(p, q)` 用于从坐标与四元数张量创建位姿
    - `p` 位置参数，(N, 3) 张量，确保保存设备与环境一致
    - `q` 姿态参数，(N, 4) 张量或 (4,) 张量并依据位置参数广播，即 (w, x, y, z) 表示的四元数
- `Pose` 对象本质为一个位姿数组，支持数字索引、`:` 连续索引、布尔索引
- 属性 `p, q` 为底层位置参数 (N, 3) 与姿态参数 (N, 4) 的张量
- 属性 `raw_pose` 为 `p, q` 两个参数合并得到 (N, 7) 的张量，可以作为观测传递

对于物体对象
- ManiSkill 同样使用向量化的物体表示，即对单个物体的操作将广播到所有向量化环境上，读取物体信息将读取所有向量化环境中该物体的信息
- 依然使用 `actor.set_pose(pose)` 设置物体位姿，但获取物体位姿则通过属性 `actor.pose` 获取，其中位姿均为 ManiSkill 中向量化的位姿对象，第 0 维长度为并行环境数
- 不需要通过 `find_component...` 等方法从组件获取运动学信息，可直接使用方法 `get_linear_velocity()` 与 `get_angular_velocity()` 获取线速度与角速度，均为 (N, 3) 的张量

对于 Sapien 与 ManiSkill 的两种位姿表示可使用 `to_sapien_pose(pose)` 函数转化
- 函数导入方式为 `from mani_skill.utils.structs.pose import to_sapien_pose`
- 该函数仅能处理单个 ManiSkill 位姿，如果为位姿列表转换将出错
