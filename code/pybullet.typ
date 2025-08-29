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
        
        # 串联关节索引
        self.panda_revolute_idx = []

        # 夹爪关节
        self.panda_finger_main = 0
        self.panda_finger_mimic = 0
        # 夹爪张开位置（最大行程）
        self.panda_finger_open_pos = 0 
        self.panda_finger_close_pos = 0 

        # 夹爪目标点伪连杆
        self.grasp_target_link_idx = -1

        # 串联关节限位，用于后续逆运动学约束
        self.panda_revolute_upper_limit = []
        self.panda_revolute_lower_limit = []
        self.panda_revolute_range = np.zeros(7)
        
        # 匹配主要关节信息
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
                self.panda_revolute_idx.append(joint_id)
                self.panda_revolute_upper_limit.append(joint_lower_limit)
                self.panda_revolute_lower_limit.append(joint_upper_limit)
            # 匹配夹爪关节
            elif joint_name == "panda_finger_joint1" and\
                 joint_type == pb.JOINT_PRISMATIC:
                self.panda_finger_main = joint_id
                self.panda_finger_open_pos = joint_upper_limit
                self.panda_finger_close_pos = joint_lower_limit
            elif joint_name == "panda_finger_joint2" and\
                 joint_type == pb.JOINT_PRISMATIC:
                self.panda_finger_mimic = joint_id
            # 匹配夹取点伪连杆（与伪关节同索引）
            elif joint_name == "panda_grasptarget_hand" and\
                 joint_type == pb.JOINT_FIXED:
                self.grasp_target_link_idx = joint_id

        # 反解关节限位
        self.panda_revolute_lower_limit = np.array(self.panda_revolute_lower_limit)
        self.panda_revolute_upper_limit = np.array(self.panda_revolute_upper_limit)
        self.panda_revolute_range =\
            self.panda_revolute_upper_limit - self.panda_revolute_lower_limit

    def current_revolute_joints_pos(self):
        '''获取当前各个旋转关节位置'''
        return np.array(
            [pb.getJointState(self._body_id, i)[0] for i in self.panda_revolute_idx]
        )

    def current_finger_pos(self):
        '''获取当前夹爪位置'''
        return np.array(
            [pb.getJointState(self._body_id, i)[0] for i in [self.panda_finger_main, self.panda_finger_mimic]]
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
- 对于单个关节有 `pb.setJointMotorControl2(...)`，使用方法类似可参考下方示例

由于 `pb.setJointMotorControlArray(...)` 仅设置控制器，需要加上后续检测判断机器人是否运到到了目标位置

该函数使用示例如下

```python

SupportJointPos = typing.TypeVar("SupportJointPos", np.ndarray, float)
def wait_for_joint(
        target_joint: SupportJointPos,
        fn_get_joint: Callable[[], SupportJointPos],
        joint_tol: float = 0.001, 
        timeout: float = 1,
        is_sleep_for_real_simulation: bool = True
    ):
    '''辅助函数，等待控制器让机械臂运动到指定位置'''
    t0 = time.time()
    while (time.time() - t0) < timeout:
        # 检查位置误差是否小于阈值判断是否到达目标位置
        err = np.linalg.norm(fn_get_joint() - target_joint)
        if err < joint_tol:
            return True
        
        pb.stepSimulation()
        if is_sleep_for_real_simulation:
            time.sleep(1 / 240) # 确保仿真动画真实
    return False

class PandaRobot:
  ...

    def revolute_joints_move_to_pos(
            self, 
            target_joint: np.ndarray, 
            pos_gain: float = 0.1, 
            joint_tol: float = 0.01, 
            timeout: float = 1
        ):
        '''
        运动旋转关节到指定关节角
        '''
        pb.setJointMotorControlArray(
            bodyIndex = self._body_id, 
            jointIndices = self.panda_revolute_idx, 
            controlMode = pb.POSITION_CONTROL, 
            targetPositions = target_joint,
            positionGains = pos_gain * np.ones(len(self.panda_revolute_idx))
        ) # type: ignore

        success = wait_for_joint(
            target_joint, self.current_revolute_joints_pos, 
            joint_tol, timeout
        )
        if success:
            return True
        else:
            warnings.warn("joints moving timeout")
            return False

    def gripper_move_pos(
            self,
            target_joint: float = 0,
            pos_gain: float = 0.1, 
            joint_tol: float = 0.01, 
            timeout: float = 1,
        ):
        '''控制手指关节使夹爪张开或闭合'''
        pb.setJointMotorControl2(
            bodyIndex = self._body_id, 
            jointIndex = self.panda_finger_main, 
            controlMode = pb.POSITION_CONTROL, 
            targetPosition = target_joint,
            positionGain = pos_gain,
        ) # type: ignore

        success = wait_for_joint(
            target_joint, lambda: self.current_finger_pos()[0], 
            joint_tol, timeout
        )
        if success:
            return True
        else:
            warnings.warn("finger moving timeout")
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

注意
- 该函数中 `lowerLimits` 等参数以及返回值包含了所有单自由度关节且与原始索引无关，当机器人中包含夹爪等无关关节时要注意忽略这些关节的结果
- 参数 `lowerLimits, upperLimits, jointRanges, restPoses` 用于带有约束的求解模式，默认可以不给出，注意
  - 对于如 Franka Panda 等 7 自由度且夹爪固连在模型中的多自由度机器人，不建议使用该模式
  - 四个参数传入数组长度必须正确，否则将自动退回一般求解模式
- 该函数不能保证求解结果一定正确，特别是目标位置在工作空间外的情况，需要手动检查

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
            timeout: float = 1,

            is_quant_rot: bool = False,
        ):

        if is_quant_rot:
            target_rot = target_eular
        else:
            target_rot = pb.getQuaternionFromEuler(target_eular) # type: ignore

        target_joint = pb.calculateInverseKinematics(
            bodyUniqueId = self._body_id,
            endEffectorLinkIndex = self.grasp_target_link_idx,
            targetPosition = target_pos,
            # 以便于理解的欧拉角作为参数
            targetOrientation = target_rot,
            # 仅传入旋转关节限位（影响未知）
            lowerLimits = self.panda_revolute_lower_limit,
            upperLimits = self.panda_revolute_upper_limit,
            jointRanges = self.panda_revolute_range,
            # 以当前旋转关节位置为起点，便于得到合理反解结果
            restPoses = self.current_revolute_joints_pos(),
            maxNumIterations = 200,
            residualThreshold = 1e-3,
        ) # pyright: ignore[reportCallIssue]
 
        return self.revolute_joints_move_to_pos(
            target_joint[:7], # 夹爪关节不参与运动 
            pos_gain, 
            joint_tol, 
            timeout
        )
```

=== 运动约束与夹爪控制

Pybullet 中，通过添加约束实现两个 URDF 模型的连接或关节间的联动（URDF 中的 mimic 参数无效）

函数 `pb.createConstraint(...)` 用于创建约束
- 参数 `parentBodyUniqueId, childBodyUniqueId`：主动关节与从动关节所在的模型 id，可以相同（同机器人上的两个关节）或不同（固连两个不同模型）
- 参数 `parentLinkIndex, childLinkIndex`：主动连杆与从动连杆在各自模型的编号，`-1` 表示基座主要用于两个不同模型固连
- 参数 `jointType`：枚举量，常用约束类型如下
  - 固定约束 `pb.JOINT_FIXED`：固连两个 URDF 模型（如将夹爪等末端执行器固连到机械臂上）
  - 齿轮约束 `pb.JOINT_GEAR`：让从动关节（旋转或平动）模仿主动关节运动（如夹爪两个手指同步运动）
- 参数 `jointAxis`：三元组，表示关节方向，通常查询 URDF，与主动关节方向相同
- 参数 `parentFramePosition`：三元组坐标，约束点相对主动连杆坐标系的位置，用于固连约束，齿轮约束一般传入 `(0, 0, 0)` 即可
- 参数 `childFramePosition`：三元组坐标，约束点相对从动连杆坐标系的位置，用于固连约束，齿轮约束一般传入 `(0, 0, 0)` 即可
- 可选参数 `childFrameOrientation`：四元数，从动连杆与主动连杆坐标系的相对姿态，用于固连约束
- 返回值：整数，约束关系 id

上述函数仅创建了约束，还需要具体设置约束参数才能使约束生效

函数 `pb.createConstraint(...)` 用于设置约束参数（该函数在#link(<type_hint_ide>)[非官方 pyi 文件]中的定义有误）
- 参数 `userConstraintUniqueId`：约束关系 id
- 参数 `gearRatio`：浮点数，用于 `pb.JOINT_GEAR`，主从关节的位移比，可以是负数以反向运动，一般为 1
- 参数 `erp`：约束误差消除系数，一般取 0.8
- 参数 `maxForce`：最大约束力，一般取 1000

例如以下代码在夹爪的两个手指关节间施加约束

```python
class PandaRobot:
  ...

    def setup_grasp(self):
        '''设置夹爪运动约束，添加到 __init__ 后'''
        c = pb.createConstraint(
            parentBodyUniqueId = self._body_id,
            parentLinkIndex = self.panda_finger_main,
            childBodyUniqueId = self._body_id,
            childLinkIndex = self.panda_finger_mimic,
            jointType = pb.JOINT_GEAR,
            jointAxis = [0, 1, 0],
            parentFramePosition = [0, 0, 0],
            childFramePosition = [0, 0, 0]
        ) # type: ignore
        pb.changeConstraint(
            userConstraintUniqueId = c,
            gearRatio = -1,
            erp = 0.8, maxForce = 1000
        ) # type: ignore
```

=== 夹取物体所需的物体物理性质设置

夹取物体时涉及到物体间的接触与摩擦力，还需要额外对物体的摩擦特性进行设置

函数 `pb.changeDynamics(...)` 用于设置物体摩擦特性，以下为主要参数
- 参数 `bodyUniqueId`：#link(<load_model>)[函数 pb.loadURDF()] 返回的模型 id
- 参数 `linkIndex`：被设置物体所在连杆索引（单个物体即 -1）
- 参数 `lateralFriction`：线性摩擦系数，一般设为 1 #sym.tilde 2
- 参数 `rollingFriction, spinningFriction`：滚动摩擦系数，无接触时设置为 0 禁用提高运算效率，接触时设置为 0.2 #sym.tilde 0.5
- 参数 `frictionAnchor`：取 1 将启用位置级别的摩擦补偿，可以防止抖动但降低运算效率，默认或无接触时设置为 0

关于夹取问题
- 被夹取物体通常使用默认的摩擦特性即可，仅需设置参与接触的两个手指连杆
- 可以在夹取前才设置 `lateralFriction` 外的摩擦系数，松开后重新取 0 提高效率
- 除了摩擦系数还有多个因素会导致物体脱落，当物体容易脱落时：
  - 增大摩擦系数 `lateralFriction`，同时设置仿真参数 `pb.setPhysicsEngineParameter(...)` 中的 `numSolverIterations` 增加仿真求解器迭代次数保证仿真正确（从 100 开始增加）
  - 降低机械臂运动速度（控制增益），取 0.02 以下的增益能较好保证物体不会脱落

== 杂项

=== 相机渲染

Pybullet 不使用一般的相机外参与内参矩阵，而是来自 OpenGL 的 ViewMatrix 与 ProjectionMatrix 确定相机的方位与特性，两者虽然存在转换关系，但依然建议使用 Pybullet 提供的函数计算

函数 `pb.computeProjectionMatrix(...)` 计算与相机方位有关的 ViewMatrix
- 参数 `cameraEyePosition`：三元组，世界坐标系下相机坐标系原点坐标，满足 $attach(bold(t), tl: w, bl: c)$
- 参数 `cameraTargetPosition`：三元组，相机主光轴上的任意一点坐标，满足 $attach(bold(t), tl: w, bl: c)+attach(bold(p), tl: w, bl: c, br: z)$
- 参数 `cameraUpVector`：三元组，相机坐标系 X 轴方向矢量，满足 $attach(bold(p), tl: w, bl: c, br: x)$
- 返回值：关于相机方位的 ViewMatrix

函数 `pb.computeProjectionMatrixFOV(...)` 计算与相机内参有关的 ProjectionMatrix
- 参数 `fov`：浮点数，相机垂直视场角，单位为度，满足 $2 arctan(h/2 div f/d_x)$
- 参数 `aspect`：浮点数，图片宽高比，满足 $w\/h$
- 参数 `nearVal, farVal`：浮点数，最近与最远观察深度
- 返回值：关于相机内参的 ProjectionMatrix

函数 `pb.getCameraImage(...)` 捕获 RGB / 深度 / 物体语义分割图像
- 参数 `width, height`：图片的宽和高
- 参数 `viewMatrix, projectionMatrix`：两个相机参数矩阵
- 参数 `lightDirection`：三元组，光照方向
- 参数 `lightColor`：三元组，光照颜色
- 参数 `flags`：枚举量，关于物体语义分割的设置
    - 默认使用物体及其连杆的 id 作为像素值
    - `ER_NO_SEGMENTATION_MASK` 不进行语义分割
    - `pb.ER_SEGMENTATION_MASK_OBJECT_AND_LINKINDEX` 区分物体各个连杆，连杆的编号满足：`objectUniqueId + (linkIndex+1)<<24` 
- 返回值 `w, h, color, zbuffer, segm`：分别为图像大小与彩色、深度、语义分割图，#hl(2)[这些图像不能直接使用]，具体处理方法见下方示例

关于相机的返回值：
- 一般情况下 Pybullet 将直接返回储存在列表中的图像，这将导致数据读取效率低
- 当 Pybullet 检测到 Numpy 时将尝试返回 Numpy 数组以提高效率，处理这些结果时可使用 `np.asarray` 以减少数据复制
- 通过函数 `pb.isNumpyEnabled()` 检查是否支持，支持时返回 True
- 部分情况，如 Python 3.12.7，Pybullet 3.2.7 可能检测不到 Numpy，需要降级为 Pybullet 3.2.6

以下为一个封装好的相机类用于示例

```python
class Camera:
    def __init__(
            self,
            # 外参（世界坐标系下的相机位姿）
            # from scipy.spatial.transform import Rotation as R
            rot_mat: np.ndarray = R.from_euler("YZX", np.array([45, 180, -180]), True).as_matrix(),
            pos: np.ndarray = np.array([1, 0, 1]),
            # 内参（Realsense D345）
            f_over_dx: float = 462.14, # f/dx 一般即内参矩阵第一个元素
            img_h: int = 480, img_w: int = 640,
            znear: float = 0.01, zfar: float = 10.0
        ) -> None:
        self.rot_mat = rot_mat
        self.pos = pos
        self.image_size = (img_h, img_w)
        self.znear, self.zfar = (znear, zfar)
        # 位姿改变时需要相应变化
        lookdir = rot_mat[:, 2]
        updir = rot_mat[:, 0]
        self.view_mat = pb.computeViewMatrix(pos, pos + lookdir, updir) # type: ignore
        # 来自内参，不随位姿改变
        fov = np.rad2deg(2 * np.arctan(img_h / 2 / f_over_dx))
        self.proj_mat = pb.computeProjectionMatrixFOV(
            fov, img_w / img_h, znear, zfar
        ) # type: ignore

    def captureImage(self):
        '''捕获 RGB，深度，语义图像'''
        _, _, color, zbuffer, segm = pb.getCameraImage(
            width = self.image_size[1],
            height = self.image_size[0],
            viewMatrix = self.view_mat,
            projectionMatrix = self.proj_mat,
        ) # type: ignore
        # 减少不必要的数据复制
        color = np.asarray(color, dtype = np.uint8).reshape((
            self.image_size[0], self.image_size[1], 4
        ))[:, :, :3] # 转为 Numpy 数组并去除无用的 Alpha 通道

        zbuffer = np.asarray(zbuffer, dtype = np.float32).reshape((
            self.image_size[0], self.image_size[1]
        ))
        depth = self.zfar + self.znear - (2.0 * zbuffer - 1.0) * (self.zfar - self.znear)
        depth = (2.0 * self.znear * self.zfar) / depth

        segm = np.asarray(zbuffer, dtype = np.int32).reshape((
            self.image_size[0], self.image_size[1]
        ))

        return color, depth, segm

    def saveImage(self, root: Union[str, Path] = "./tmp"):
        '''捕获并保存图像'''
        if isinstance(root, str):
            root = Path(root)
        color, depth, _ = self.captureImage()

        fig, axes = plt.subplot_mosaic([[0, 1]])
        axes[0].imshow(color)
        axes[0].set_title("color")

        axes[1].imshow(depth)
        axes[1].set_title("depth")

        fig.savefig(root.joinpath(f"{time.strftime('%m-%d-%H-%M-%S')}.png"))

    def showCameraCoordinate(self):
        '''绘制相机坐标系'''
        pb.addUserDebugLine(
            self.pos, self.pos + self.rot_mat[:, 0] * 0.2, [1, 0, 0], 3
        ) # type: ignore
        pb.addUserDebugLine(
            self.pos, self.pos + self.rot_mat[:, 1] * 0.2, [0, 1, 0], 3
        ) # type: ignore
        pb.addUserDebugLine(
            self.pos, self.pos + self.rot_mat[:, 2] * 0.2, [0, 0, 1], 3
        ) # type: ignore
```

=== Debug 图例

Pybullet 支持在仿真环境中绘制点、线等图例用于 Debug（这些图例不会被相机捕捉到）

函数 `pb.addUserDebugPoints(...)` 在仿真环境中绘制点
- 参数 `pointPositions`：以三元组为元素的列表（即使只有一个点），即所有绘制点的坐标
- 参数 `pointColorsRGB`：以三元组为元素的列表（即使只有一个点），各个点的颜色（取值为 0 #sym.tilde 1）
- 参数 `pointSize`：浮点数，点的大小倍数，最少为 1

函数 `pb.addUserDebugLine(...)` 在仿真环境中绘制线
- 参数 `lineFromXYZ`：三元组，线段起点
- 参数 `lineToXYZ`：三元组，线段终点
- 参数 `lineColorRGB`：三元组，线段颜色（取值为 0 #sym.tilde 1）
- 参数 `lineWidth`：浮点数，线段粗细倍数，最少为 1

=== 类型检查与 IDE 提示 <type_hint_ide>

目前，在 PyBullet 中没有内置 .pyi 类型注释文件。可以参考 #link("https://github.com/bulletphysics/bullet3/discussions/3913?utm_source=chatgpt.com")[issue]，下载非官方的 #link("https://github.com/rohit-kumar-j/temporary_pybullet_stub/blob/main/pybullet.pyi")[pyi 文件]放置在项目根目录临时解决（该文件没有说明参数的默认值，因此参数已有默认值的情况下可能依然报出语法错误）
