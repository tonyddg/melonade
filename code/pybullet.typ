#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Pybullet 笔记")

#import "/utility/widget.typ": *

= Pybullet 笔记

== 基本使用

笔记中使用如下别名引入 Pybullet 及其相关模块：

```python
import pybullet as pb
import pybullet_data as pbd
```

=== 仿真环境创建与关闭

Pybullet 通过客户端 - 服务端架构管理仿真环境，客户端（Python 程序）通过向服务端发送指令控制仿真环境。常用的函数有：

函数 `pb.connect(...)` 用于创建并链接到仿真环境
- 参数 `method = pb.GUI`：仿真环境类型，可选值有
  - `pb.GUI` 渲染并创建带有 GUI 界面的仿真环境
  - `pb.DIRECT` 不渲染仿真环境
- 返回值为创建的服务端 id（服务端创建失败时返回负数）
  - #bl(6)[Pybullet 均基于服务端 id （参数 `physicsClientId`）发送命令控制仿真环境，仅有单个仿真环境时可以不提供 id，后续 API 介绍时也将忽略该参数]
  - 关于向量化环境中可能存在多个服务端，可参考#link(<vectorize_env>)[向量化环境]，使用对象作为客户端
- 该函数还可链接其他进程 / 其他服务器的环境，详细用法见文档

函数 `pb.disconnect()` 用于断开并关闭仿真环境

函数 `pb.isConnected()` 用于判断环境是否链接，如果链接返回 `True`

对于渲染的仿真环境的交互方式如下
- 鼠标滚轮：缩放视图
- #bl(0)[Ctrl] + 左键拖动：旋转视图
- #bl(0)[Ctrl] + 中键拖动：平移视图

=== 仿真环境控制

函数 `pb.stepSimulation()` 用于进入下一时刻的仿真，默认仿真间隔为 $1\/240s$
- 需要保证渲染画面与仿真一致时，可在该函数后执行 `time.sleep(1 / 240)` 休眠相同的时间间隔

函数 `pb.setTimeStep(timeStep)` 用于设置仿真间隔

函数 `pb.resetSimulation(flag)` 用于重置仿真环境（参数一般传入 0）

函数 `pb.setGravity(gravX, gravY, gravZ)` 设置环境重力加速度矢量
- `gravX, gravY, gravZ` 重力加速度矢量，单位 $m \/ s^2$
- 默认没有重力加速度，通常需要手动设置 `pb.setGravity(0, 0, -9.8)`

=== 模型与场景加载 <load_model>

函数 `pb.setAdditionalSearchPath(...)` 用于添加模型搜索路径
- 函数参数为额外搜索路径字符串
- 通常用于配合模块 pybullet_data（pbd） 中提供了一系列官方模型，通过 `pbd.getDataPath()` 获取官方模型路径

函数 `pb.loadURDF(...)` 导入 URDF 模型
- 参数 `fileName`：字符串，URDF 模型路径
- 参数 `basePosition`：三元组，模型基座坐标，默认为 0
- 参数 `baseOrientation`：四元组，模型基座姿态，默认为 0
- 参数 `useFixedBase`：布尔值，为 True 时模型基座将与地面固连
- 返回值为整形的模型 id（导入失败时为负数）
- 关于其他模型导入#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.sbnykoneq1me")[参见函数] `pb.loadSDF` 与 `pb.loadMJCF`（支持较差）

函数 `pb.removeBody(...)` 删除模型
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id

关于全场景导入#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.4j7rul6vry1a")[参见函数] `pb.saveState`、`pb.saveBullet`、`pb.restoreState`（Pybullet 中更推荐使用 Python 程序创建场景）

关于简单几何体与 obj 模型的导入，#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.q1gn7v6o58bf")[参见函数] `pb.createCollisionShape()` 与 `pb.createVisualShape()` 以及#link("https://github.com/bulletphysics/bullet3/blob/master/examples/pybullet/examples/createVisualShape.py")[官方示例]

=== 物体控制

Pybullet 中
- 使用 ${x, y, z}$ 表示物体位置
- 使用 ${x, y, z, w}$ 四元数表示物体姿态
- 位姿信息分别存储在两个浮点数列表中

函数 `pb.getBasePositionAndOrientation(objectUniqueId)` 获取物体基座位姿
- 参数 `objectUniqueId` 加载物体时返回的整数物体 id
- 返回值 `pos, rot` 为物体位置与姿态

函数 `pb.resetBasePositionAndOrientation(bodyUniqueId, posObj, ornObj)` 设置物体基座位姿
- 参数 `bodyUniqueId` 加载物体时返回的整数物体 id
- 参数 `posObj, ornObj` 设置的物体位置与姿态
- 该函数将强制清空物体已有的速度与加速度，在准确仿真环境中为了防止错误可用以下代码检查环境是否静止

```py
def is_static(client_id, rigid_obj_ids):
    """
    参考自 https://github.com/xukechun/Vision-Language-Grasping/blob/74fc522bce44cba2b1ec34b6b3c88014ff030d5d/env/environment_sim.py#L44
    * client_id 仿真环境 id
    * obj_ids 环境中所有刚体的 id
    """
    v = [
        np.linalg.norm(pb.getBaseVelocity(i, physicsClientId = client_id)[0])
        for i in rigid_obj_ids
    ]
    return all(np.array(v) < 5e-3)
```

Pybullet 也提供了一系列位姿转换函数，更多参见#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.y6v0hy52u8fg")[官方文档]

函数 `py.getEulerFromQuaternion(...)` 将四元数姿态转为欧拉角
- 参数 `quaternion`：浮点数列表，${x, y, z, w}$ 四元数
- 返回值：浮点数列表，基于固定角的 XYZ 欧拉角，单位弧度
- 相反的也有函数 `pb.getQuaternionFromEuler(...)`

=== 向量化环境 <vectorize_env>

Pybullet 中也提供了基于对象的仿真环境客户端，用于向量化环境：

类 `pybullet_utils.bullet_client.BulletClient(...)` 用于管理服务端 
- 参数 `method = pb.GUI`：同 `pb.connect(method)`
- 该客户端类可以在对象销毁时自动断开服务端
- 类方法与 Pybullet API 一致，可直接像调用 Pybullet API 一样使用，区别仅在自动提供了 `physicsClientId` 参数（可能缺少 IDE 提示）

关于向量化环境使用方法参见
- #link("https://github.com/bulletphysics/bullet3/blob/master/examples/pybullet/gym/pybullet_envs/env_bases.py")[用于强化学习的向量化环境]
- #link("https://github.com/bulletphysics/bullet3/blob/master/examples/pybullet/gym/pybullet_utils/examples/multipleScenes.py")[多服务端最小示例]

== 机器人

将 URDF 文件所定义的，具有多个关节与连杆的物体称为机器人

=== 基本信息

URDF 中使用标签的 `name` 属性标记关节与连杆名称，而 Pybullet 中则使用数字索引标记关节与连杆。其中基座连杆使用不存在的索引 `-1` 标记，关节与其连接的子连杆使用同一索引。

Pybullet 中提供了以下函数用于获取机器人基本信息

函数 `pb.getNumJoints(...)` 获取机器人的关节数
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 返回值：整数，机器人的关节数

函数 `pb.getJointInfo(...)` 获取机器人关节信息
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 参数 `jointIndex`：查询的关节
- 返回值 `info`：包含该关节信息的列表，列表完整含义参见#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.la294ocbo43o")[官方文档]，关键信息有
  - `info[0]`：关节索引，整数
  - `info[1]`：关节名称，与 URDF 的 `name` 属性对应，类型为字节流，需要调用 `decode("utf-8")` 方法转为字符串
  - `info[2]`：关节类型，与 URDF 的 `type` 属性对应，类型为形如 `pb.JOINT_XXX` 的枚举量

函数 `pb.getJointState(...)` 获取机器人关节状态
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 参数 `jointIndex`：查询的关节
- 返回值 `info`：包含该关节状态的列表，列表完整含义参见#link("https://docs.google.com/document/d/10sXEhzFRSnvFcl3XxNGhnD4N2SedqwdAvK3dsihxVUA/edit?pli=1&tab=t.0#heading=h.p3s2oveabizm")[官方文档]，关键信息有
  - `info[0]`：关节位置，浮点数
  - `info[1]`：关节速度，浮点数

例如以下代码用于获取机器人所有关节的基本信息，并匹配关键关节与连杆的索引

```python
class PandaRobot:
    def __init__(self, body_id: int) -> None:

        self._body_id = body_id
        
        # 主要关节索引
        self.panda_joint_idx = []
        # 关节限位，用于后续逆运动学约束
        self.panda_joint_upper_limit = []
        self.panda_joint_lower_limit = []
        self.panda_joint_range = None
        # 夹爪目标点伪连杆
        self.grasp_target_link_idx = -1

        for i in range(pb.getNumJoints(self._body_id)):
            info = pb.getJointInfo(self._body_id, i)
            joint_id: int = info[0]
            joint_name: str = info[1].decode("utf-8")
            joint_type: int = info[2]

            joint_lower_limit = info[8]
            joint_upper_limit = info[9]

            # 依据 URDF，通过名称与类型正确匹配旋转关节
            if joint_name.startswith("panda_joint") and\
               joint_type == pb.JOINT_REVOLUTE:
                self.panda_joint_idx.append(joint_id)
                self.panda_joint_upper_limit.append(joint_lower_limit)
                self.panda_joint_lower_limit.append(joint_upper_limit)
            # 匹配夹爪目标的伪连杆
            elif joint_name == "panda_grasptarget_hand" and\
                 joint_type == pb.JOINT_FIXED:
                self.grasp_target_link_idx = joint_id

        self.panda_joint_lower_limit = np.array(self.panda_joint_lower_limit + [0, 0]) # 两个夹爪关节不参与反解
        self.panda_joint_upper_limit = np.array(self.panda_joint_upper_limit + [0, 0])
        self.panda_joint_range = self.panda_joint_upper_limit - self.panda_joint_lower_limit

    @property
    def current_joints(self):
        '''获取当前各个旋转关节位置'''
        return np.array(
            [pb.getJointState(self._body_id, i)[0] for i in self.panda_joint_idx]
        )
```

=== 串联机器人位置控制

Pybullet 中，通过在机器人关节上施加不同控制器以达到控制关节处于指定的速度 / 位置

对于浮点数列表类型的参数，也可以传入一维 Numpy 数组作为参数值

函数 `pb.setJointMotorControlArray(...)` 用于控制多个关节（此处仅介绍单自由度关节在位置控制模式下的用法）
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 参数 `jointIndices`：列表，包含所有被设置的关节索引
- 参数 `controlMode`：枚举量，值 `pb.POSITION_CONTROL` 表示位置控制模式
- 参数 `targetPositions`：列表，对应关节的目标位置，角度单位为弧度
- 参数 `positionGains`：列表，对应关节的位置控制的比例增益（建议设置范围为 0.1 到 0.01，过快可能出错）
- 该函数仅需设置一次后续仿真将持续使用给定控制器控制

由于 `pb.setJointMotorControlArray(...)` 仅设置控制器，需要加上后续检测判断机器人是否运到到了目标位置

该函数使用示例如下

```python
class PandaRobot:
  ...

    def move_to_joints(
        self, 
        target_joint: np.ndarray, 
        pos_gain: float = 0.1, 
        joint_tol: float = 0.01, 
        timeout: float = 1
    ):

        pb.setJointMotorControlArray(
            bodyIndex = self._body_id, 
            jointIndices = self.panda_joint_idx, 
            controlMode = pb.POSITION_CONTROL, 
            targetPositions = target_joint,
            positionGains = pos_gain * np.ones(len(self.panda_joint_idx))
        ) # type: ignore

        t0 = time.time()
        while (time.time() - t0) < timeout:
            # 检查位置误差是否小于阈值判断是否到达目标位置
            err = np.linalg.norm(self.current_joints - target_joint)
            if err < joint_tol:
                return True
            
            pb.stepSimulation()
            time.sleep(1 / 240) # 确保仿真动画真实

        warnings.warn("joints moving timeout")
        return False
```

=== 串联机器人逆运动学

函数 `pb.calculateInverseKinematics(...)` 用于反解给定连杆位姿下的关节位置
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 参数 `endEffectorLinkIndex`：末端执行器连杆索引
- 参数 `targetPosition, targetOrientation`：分别为三元组与四元组表示的目标位置与姿态
- 参数 `lowerLimits, upperLimits, jointRanges`：关节位置限位（可从关节信息 / URDF 中获取），依据关节索引顺序传入且忽略 0 自由度关节
- 参数 `restPoses`：反解迭代起始关节位置，依据关节索引顺序传入且忽略 0 自由度关节
- 参数 `residualThreshold`：允许反解误差
- 参数 `maxNumIterations`：最大迭代次数，当满足反解误差或超过迭代次数时停止反解
- 返回值：反解结果，为依据关节索引顺序且忽略 0 自由度关节的各个关节位置列表

注意该函数中 `lowerLimits` 等参数以及返回值包含了所有单自由度关节且与原始索引无关，当机器人中包含夹爪等无关关节时要注意忽略这些关节的结果

该函数使用示例如下
```python
class PandaRobot:
  ...

    def move_grasp_to_pose(
            self, 
            target_pos: np.ndarray, 
            target_eular: np.ndarray, 
            pos_gain: float = 0.1, 
            joint_tol: float = 0.01, 
            timeout: float = 1
        ):
        target_joint = pb.calculateInverseKinematics(
            bodyUniqueId = self._body_id,
            endEffectorLinkIndex = self.grasp_target_link_idx,
            targetPosition = target_pos,
            # 以便于理解的欧拉角作为参数
            targetOrientation = pb.getQuaternionFromEuler(target_eular), # type: ignore
            lowerLimits = self.panda_joint_lower_limit,
            upperLimits = self.panda_joint_upper_limit,
            jointRanges = self.panda_joint_range,
            # 以当前关节位置为起点，便于得到合理反解结果
            restPoses = self.current_joints,
            maxNumIterations = 100,
            residualThreshold = 1e-4,
        ) # pyright: ignore[reportCallIssue]
        
        return self.move_to_joints(target_joint[:7], pos_gain, joint_tol, timeout)
```

== 杂项

=== 类型检查与 IDE 提示

目前，在 PyBullet 中没有内置 .pyi 类型注释文件。可以参考 #link("https://github.com/bulletphysics/bullet3/discussions/3913?utm_source=chatgpt.com")[issue]，下载非官方的 #link("https://github.com/rohit-kumar-j/temporary_pybullet_stub/blob/main/pybullet.pyi")[pyi 文件]放置在项目根目录临时解决（该文件没有说明参数的默认值，因此参数已有默认值的情况下可能依然报出语法错误）
